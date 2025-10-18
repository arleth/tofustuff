# VelPharma Backend Containerization Analysis

**Dato:** 18. Oktober 2025
**Status:** Analyse af containeriseringsmuligheder for .NET 9 Azure Functions solution
**Baggrund:** PostgreSQL database er nu kørende i Docker, backend skal evalueres for containerisering

---

## Executive Summary

VelPharma backend er aktuelt bygget som Azure Functions (serverless) deployed til Azure Function Apps. Med PostgreSQL nu kørende i Docker lokalt, er der mulighed for at containerisere hele stacken. Denne analyse evaluerer:

1. ✅ **Mulighed for containerisering** - JA, det er fuldt muligt
2. 📊 **Fire hovedstrategier** - Fra simpel Docker Compose til fuld Dapr microservices
3. 🎯 **Anbefaling** - Trinvis approach baseret på jeres behov
4. ⚖️ **Dapr vurdering** - Hvornår det giver mening vs. overhead

**Konklusion:** Containerisering er teknisk feasible og anbefalet for udviklings-miljøet. Produktion kræver valg mellem managed (Azure Container Apps) og self-hosted (Kubernetes).

---

## 1. Nuværende Arkitektur - Status Quo

### 1.1 Technology Stack

```
┌─────────────────────────────────────────────────────┐
│           Azure Functions (Serverless)               │
│                                                       │
│  ┌──────────────────┐      ┌─────────────────┐     │
│  │  Product API     │      │   Organ API     │     │
│  │  (.NET 9)        │      │   (.NET 9)      │     │
│  └────────┬─────────┘      └────────┬────────┘     │
│           │                          │               │
│           └──────────┬───────────────┘               │
└──────────────────────┼───────────────────────────────┘
                       │
          ┌────────────▼────────────┐
          │  Shared Libraries       │
          │  - AzureSharedLogic     │
          │  - VpSharedLogic        │
          │  - VpStandardLibrary    │
          │  - DatabaseLayer        │
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │  PostgreSQL Database    │
          │  (Docker Container)     │
          │  Port: 5434             │
          └─────────────────────────┘

External Services:
├── Application Insights (Azure)
├── Jaeger (Azure Container Instance)
└── Key Vault (Azure)
```

### 1.2 Deployment Model

**Nuværende:**
- **Compute:** Azure Function Apps (Consumption/Premium plan)
- **Database:** Lokalt Docker, Produktion Azure Managed PostgreSQL
- **IaC:** Bicep for Azure, OpenTofu for lokal Docker
- **CI/CD:** GitHub Actions → Azure Functions deployment

**Dependencies:**
- Entity Framework Core 9.0.9 (PostgreSQL provider)
- OpenTelemetry + Jaeger (distributed tracing)
- Application Insights (monitoring)
- gRPC support (proto-buf references)
- Serilog (structured logging)

### 1.3 Konfiguration

**Configuration Sources:**
```csharp
// Program.cs initialization chain
.ConfigureAppConfiguration()
.ConfigureVelPharmaFunctionsWorkerDefaults()
.ConfigureOpenTelemetry()
.ConfigureOpenApi()
.ConfigureVelPharmaLoggingAppInsights()
.ConfigureVelPharmaDatabase<VPDataContext>()
```

**Miljøvariabler (local.settings.json):**
- `AzureWebJobsStorage`: Development storage
- `FUNCTIONS_WORKER_RUNTIME`: dotnet-isolated
- `APPINSIGHTS_INSTRUMENTATIONKEY`: AppInsights key
- `JeagerOpenTelemetry`: Jaeger endpoint URL
- `PostgreSQL` (ConnectionString): Database connection

**Problem:** Hardcoded dependencies til Azure services i konfiguration.

---

## 2. Containeriserings Muligheder - Dyb Analyse

### Option 1: Docker Compose (Lokal Udvikling Focus)

**Beskrivelse:** Udvid eksisterende docker-compose.yml med backend services.

#### 2.1.1 Arkitektur

```yaml
services:
  postgres:
    # Existing setup

  product-api:
    build: ./backend/Azure/AzureFunctions/Vp.Azure.Function.Product.Api
    ports:
      - "7071:80"
    environment:
      - PostgreSQL__ConnectionString=Server=postgres;Port=5432;...
      - JaegerOpenTelemetry=http://jaeger:4317
    depends_on:
      - postgres
      - jaeger

  organ-api:
    build: ./backend/Azure/AzureFunctions/Vp.Azure.Function.Organ.Api
    ports:
      - "7072:80"
    depends_on:
      - postgres
      - jaeger

  jaeger:
    image: jaegertracing/all-in-one:latest
    ports:
      - "16686:16686"  # UI
      - "4317:4317"    # OTLP gRPC
```

#### 2.1.2 Dockerfile for Azure Functions (.NET 9)

```dockerfile
# Multi-stage build for Azure Functions
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj files and restore
COPY ["Vp.Azure.Function.Product.Api/Vp.Azure.Function.Product.Api.csproj", "Vp.Azure.Function.Product.Api/"]
COPY ["../../../../Common/Azure/SharedLogic/AzureSharedLogic/AzureSharedLogic.csproj", "AzureSharedLogic/"]
COPY ["../../../../Common/Azure/SharedLogic/VpSharedLogic/VpSharedLogic.csproj", "VpSharedLogic/"]
COPY ["../../../../Common/Azure/SharedLogic/VpStandardLibrary/VpStandardLibrary.csproj", "VpStandardLibrary/"]
COPY ["../../../../Tools/MasterdataLoader/DatabaseLayer/DatabaseLayer/DatabaseLayer.csproj", "DatabaseLayer/"]

RUN dotnet restore "Vp.Azure.Function.Product.Api/Vp.Azure.Function.Product.Api.csproj"

# Copy everything and build
COPY . .
WORKDIR "/src/Vp.Azure.Function.Product.Api"
RUN dotnet build "Vp.Azure.Function.Product.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Vp.Azure.Function.Product.Api.csproj" -c Release -o /app/publish

# Runtime image
FROM mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated9.0
WORKDIR /home/site/wwwroot

COPY --from=publish /app/publish .

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true
```

#### 2.1.3 Fordele

✅ **Minimal ændring af eksisterende kode**
- Azure Functions runtime container kører OOTB
- Ingen ændring af function signatures eller middleware

✅ **Konsistent udviklings-miljø**
- Hele stacken kører lokalt (inkl. Jaeger)
- Nemt at onboarde nye udviklere

✅ **Udvider eksisterende setup**
- PostgreSQL Docker setup er allerede implementeret
- OpenTofu infrastructure kan udvides

✅ **Debugging support**
- Kan køre med debugger attached
- Hot reload support i .NET 9

#### 2.1.4 Ulemper

❌ **Azure Functions runtime overhead**
- Container størrelse: ~1.5GB (functions runtime base image)
- Længere startup tid end native .NET app

❌ **Ikke production-ready**
- Mangler orchestration (scaling, health checks)
- Ingen service mesh / load balancing

❌ **Config kompleksitet**
- Application Insights kræver stadig Azure connection
- Storage emulator for local development

#### 2.1.5 Migrerings Effort

**Estimat: 1-2 dage**

1. ✏️ Opret Dockerfile for hver Function App (2-3 timer)
2. ✏️ Udvid docker-compose.yml (1 time)
3. ✏️ Konfigurer environment variables (2 timer)
4. ✏️ Tilføj Jaeger container (30 min)
5. ✏️ Test integration (4 timer)
6. ✏️ Dokumentation (2 timer)

**Risiko:** Lav - Azure Functions runtime er designet til containers.

---

### Option 2: Azure Container Apps (Managed Containers)

**Beskrivelse:** Deploy containers til Azure Container Apps (ACA) - Azure's managed container platform med Dapr integration.

#### 2.2.1 Arkitektur

```
┌─────────────────────────────────────────────────────┐
│    Azure Container Apps Environment                 │
│                                                       │
│  ┌────────────────────┐   ┌────────────────────┐   │
│  │ Product API        │   │ Organ API          │   │
│  │ Container App      │   │ Container App      │   │
│  │ (Auto-scale 0-10)  │   │ (Auto-scale 0-10)  │   │
│  └──────────┬─────────┘   └──────────┬─────────┘   │
│             │                          │             │
│             └──────────┬───────────────┘             │
│                        │                             │
│                  ┌─────▼─────┐                       │
│                  │  Dapr      │ (Optional)           │
│                  │  Sidecar   │                      │
│                  └────────────┘                      │
└────────────────────┼────────────────────────────────┘
                     │
        ┌────────────▼────────────┐
        │  Azure PostgreSQL       │
        │  Flexible Server        │
        └─────────────────────────┘
```

#### 2.2.2 Container App Spec (YAML)

```yaml
apiVersion: apps/v1
kind: ContainerApp
metadata:
  name: product-api
spec:
  template:
    containers:
      - name: product-api
        image: velpharma.azurecr.io/product-api:latest
        resources:
          cpu: 0.5
          memory: 1Gi
        env:
          - name: PostgreSQL__ConnectionString
            secretRef: postgres-connection
          - name: APPLICATIONINSIGHTS_CONNECTION_STRING
            secretRef: appinsights-key
    scale:
      minReplicas: 0
      maxReplicas: 10
      rules:
        - name: http-rule
          http:
            metadata:
              concurrentRequests: '100'
  configuration:
    ingress:
      external: true
      targetPort: 80
      transport: http
    dapr:
      enabled: false  # Start uden Dapr
```

#### 2.2.3 Fordele

✅ **Serverless + Containers**
- Scale-to-zero (cost saving)
- Auto-scaling baseret på HTTP requests eller custom metrics

✅ **Managed platform**
- Ingen Kubernetes cluster management
- Built-in HTTPS, auto-certificates

✅ **Azure integration**
- Native Application Insights integration
- Managed identity for Azure services

✅ **Dapr ready**
- Kan aktivere Dapr senere uden re-architecture

✅ **Deployment simplicity**
- `az containerapp up` eller Bicep modules
- Existing Bicep knowledge genbruges

#### 2.2.4 Ulemper

❌ **Azure vendor lock-in**
- Ikke multi-cloud
- Migration til andet cloud kræver re-work

❌ **Cold start overhead**
- Scale-to-zero: 2-5 sekunder første request
- Kan være problem for latency-sensitive endpoints

❌ **Pricing**
- Dyrere end Consumption Functions ved lav traffic
- Men billigere end Kubernetes ved medium traffic

❌ **Region availability**
- Ikke alle Azure features tilgængelige i alle regions

#### 2.2.5 Migrerings Effort

**Estimat: 3-5 dage**

1. ✏️ Opret Dockerfiles (optimeret for prod) (1 dag)
2. ✏️ Setup Azure Container Registry (2 timer)
3. ✏️ Opret Container Apps Environment (Bicep) (4 timer)
4. ✏️ Deploy Container Apps (2 apps) (4 timer)
5. ✏️ Konfigurer networking + ingress (3 timer)
6. ✏️ Setup CI/CD pipeline (1 dag)
7. ✏️ Testing + monitoring (1 dag)

**Risiko:** Medium - Ny platform, men god dokumentation fra Microsoft.

---

### Option 3: Kubernetes (On-Premises eller Azure AKS)

**Beskrivelse:** Full containerization med Kubernetes orchestration - maksimal kontrol og portabilitet.

#### 2.3.1 Arkitektur

```
┌─────────────────────────────────────────────────────┐
│         Kubernetes Cluster (AKS / Self-hosted)      │
│                                                       │
│  Namespace: velpharma-prod                           │
│                                                       │
│  ┌────────────────────────────────────────────┐     │
│  │  Ingress Controller (Nginx/Traefik)        │     │
│  │  HTTPS termination + routing               │     │
│  └──────────────┬─────────────────────────────┘     │
│                 │                                     │
│        ┌────────┴────────┐                           │
│        │                 │                           │
│  ┌─────▼──────┐   ┌─────▼──────┐                    │
│  │ Product    │   │ Organ      │                    │
│  │ Deployment │   │ Deployment │                    │
│  │ (3 pods)   │   │ (2 pods)   │                    │
│  └─────┬──────┘   └─────┬──────┘                    │
│        │                 │                           │
│        └────────┬────────┘                           │
│                 │                                     │
│  ┌──────────────▼────────────────┐                   │
│  │  Service Mesh (Optional)      │                   │
│  │  - Istio / Linkerd / Dapr     │                   │
│  └───────────────────────────────┘                   │
│                                                       │
│  ┌────────────────────────────────┐                  │
│  │  Observability Stack            │                  │
│  │  - Prometheus (metrics)         │                  │
│  │  - Jaeger (tracing)             │                  │
│  │  - Grafana (visualization)      │                  │
│  └────────────────────────────────┘                  │
└──────────────────┼──────────────────────────────────┘
                   │
      ┌────────────▼────────────┐
      │  PostgreSQL             │
      │  (StatefulSet / External)│
      └─────────────────────────┘
```

#### 2.3.2 Kubernetes Manifests

**Deployment:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product-api
  namespace: velpharma-prod
spec:
  replicas: 3
  selector:
    matchLabels:
      app: product-api
  template:
    metadata:
      labels:
        app: product-api
        version: v1
    spec:
      containers:
      - name: product-api
        image: velpharma.azurecr.io/product-api:v1.2.3
        ports:
        - containerPort: 80
        env:
        - name: PostgreSQL__ConnectionString
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: connection-string
        - name: ASPNETCORE_ENVIRONMENT
          value: "Production"
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /api/v1/health
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /api/v1/health/ready
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: product-api-service
spec:
  selector:
    app: product-api
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
```

**ConfigMap:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: product-api-config
data:
  appsettings.Production.json: |
    {
      "Logging": {
        "LogLevel": {
          "Default": "Information"
        }
      },
      "JaegerOpenTelemetry": "http://jaeger-collector.observability:4317"
    }
```

**Secret (base64 encoded):**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
data:
  connection-string: U2VydmVyPXBvc3RncmVzO1BvcnQ9NTQzMjs...
```

#### 2.3.3 Fordele

✅ **Maximum control**
- Fuld kontrol over networking, scaling, resources
- Custom health checks, circuit breakers, retries

✅ **Portability**
- Kan køre on-premises, Azure AKS, AWS EKS, GCP GKE
- Samme manifests til dev/staging/prod

✅ **Ecosystem**
- Stort community, mature tooling (Helm, Kustomize)
- Service mesh options (Istio, Linkerd, Dapr)

✅ **Observability**
- Prometheus + Grafana stack
- Distributed tracing med Jaeger/Tempo

✅ **GitOps ready**
- Flux/ArgoCD for automated deployments
- Infrastructure as Code via Helm charts

#### 2.3.4 Ulemper

❌ **Operational complexity**
- Cluster management (upgrades, patches, networking)
- Kræver Kubernetes expertise i teamet

❌ **Cost**
- AKS: ~$150-500/måned for small cluster (3 nodes)
- Monitoring stack overhead

❌ **Learning curve**
- Manifests, Helm, networking policies
- Debugging er komplekst (kubectl, logs across pods)

❌ **Overhead for lille team**
- Overkill hvis I kun har 2-3 microservices

#### 2.3.5 Migrerings Effort

**Estimat: 2-3 uger**

1. ✏️ Opret production-grade Dockerfiles (2 dage)
2. ✏️ Setup Kubernetes cluster (AKS via Bicep) (2 dage)
3. ✏️ Opret Helm charts for alle services (3 dage)
4. ✏️ Setup ingress + TLS certificates (1 dag)
5. ✏️ Konfigurer secrets management (Azure Key Vault integration) (1 dag)
6. ✏️ Deploy observability stack (Prometheus, Grafana, Jaeger) (2 dage)
7. ✏️ CI/CD pipeline (GitHub Actions → ACR → AKS) (2 dage)
8. ✏️ Testing, load testing, dokumentation (1 uge)

**Risiko:** Høj - Stor platform ændring, kræver ny kompetence.

---

### Option 4: Hybrid .NET Applications (Ikke Azure Functions)

**Beskrivelse:** Konverter Azure Functions til almindelige ASP.NET Core Web APIs.

#### 2.4.1 Refactoring

**Fra:**
```csharp
[Function("GetProductAsync")]
public async Task<HttpResponseData> Run(
    [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "v1/products/{productId}")]
    HttpRequestData req,
    string productId)
{
    // Function logic
}
```

**Til:**
```csharp
[ApiController]
[Route("api/v1/products")]
public class ProductsController : ControllerBase
{
    [HttpGet("{productId}")]
    public async Task<ActionResult<ProductDto>> GetProduct(string productId)
    {
        // Same logic
    }
}
```

#### 2.4.2 Fordele

✅ **Mindre container størrelse**
- Fra 1.5GB (functions runtime) til ~200MB (ASP.NET minimal)

✅ **Standard .NET patterns**
- Controller-based API (MVC/Minimal API)
- Lettere at teste, mere idiomatisk

✅ **Deployment flexibility**
- Kan deployes til any container platform
- Ikke bundet til Azure Functions infrastruktur

#### 2.4.3 Ulemper

❌ **Major refactoring**
- Alle functions skal konverteres til controllers
- Middleware changes, startup configuration

❌ **Mister Functions benefits**
- Ingen built-in triggers (timer, queue, event grid)
- Skal selv implementere async processing

❌ **Testing overhead**
- Skal omskrive alle unit tests

#### 2.4.4 Migrerings Effort

**Estimat: 3-4 uger**

- 🔨 Refactor 10+ functions til controllers (2 uger)
- 🔨 Opdater middleware + DI (3 dage)
- 🔨 Omskriv unit tests (1 uge)
- 🔨 Integration testing (3 dage)

**Risiko:** Høj - Stor code rewrite, regression risiko.

**Anbefaling:** KUN hvis I planlægger at forlade Azure completely.

---

## 3. Dapr Integration - Dybdegående Vurdering

### 3.1 Hvad er Dapr?

**Distributed Application Runtime (Dapr)** er et CNCF projekt der giver building blocks til microservices:

```
┌─────────────────────────────────────────────────────┐
│              Dapr Building Blocks                   │
├─────────────────────────────────────────────────────┤
│ 1. Service-to-Service invocation                    │
│ 2. State Management                                 │
│ 3. Pub/Sub messaging                                │
│ 4. Resource Bindings (input/output)                │
│ 5. Actors (virtual actors pattern)                 │
│ 6. Observability (tracing, metrics, logging)       │
│ 7. Secrets Management                               │
│ 8. Configuration Management                         │
│ 9. Distributed Lock                                 │
│ 10. Workflows                                       │
└─────────────────────────────────────────────────────┘
```

### 3.2 Dapr Arkitektur for VelPharma

```
┌─────────────────────────────────────────────────────┐
│                Product API Container                │
│                                                       │
│  ┌───────────────────────┐     ┌─────────────┐     │
│  │  .NET 9 Application   │────▶│ Dapr Sidecar│     │
│  │  Port: 80             │     │ Port: 3500  │     │
│  └───────────────────────┘     └──────┬──────┘     │
└───────────────────────────────────────┼─────────────┘
                                        │
                                        │ HTTP/gRPC
                                        │
┌───────────────────────────────────────▼─────────────┐
│              Dapr Control Plane                     │
│                                                       │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────┐│
│  │ Placement   │  │ Sentry (mTLS)│  │ Operator   ││
│  │ Service     │  │ Certificate  │  │ (K8s only) ││
│  └─────────────┘  └──────────────┘  └────────────┘│
└─────────────────────────────────────────────────────┘
        │                    │                  │
        ▼                    ▼                  ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ PostgreSQL   │   │ Redis        │   │ RabbitMQ     │
│ (State Store)│   │ (Pub/Sub)    │   │ (Messaging)  │
└──────────────┘   └──────────────┘   └──────────────┘
```

### 3.3 Dapr Use Cases for VelPharma

#### 3.3.1 Service-to-Service Communication

**Uden Dapr:**
```csharp
// Direct HTTP call med HttpClient
var response = await httpClient.GetAsync(
    "http://organ-api/api/v1/organs/123"
);
```

**Med Dapr:**
```csharp
// Dapr service invocation (service discovery, retry, circuit breaker built-in)
var response = await daprClient.InvokeMethodAsync<OrganDto>(
    HttpMethod.Get,
    "organ-api",  // Service name (not URL)
    "api/v1/organs/123"
);
```

**Fordele:**
- ✅ Built-in retry logic
- ✅ Circuit breaker pattern
- ✅ Service discovery
- ✅ mTLS automatic (hvis enabled)

#### 3.3.2 State Management

**Uden Dapr:**
```csharp
// Direct database eller cache access
await dbContext.ProductCache.AddAsync(new ProductCache { ... });
await redisClient.StringSetAsync(key, value);
```

**Med Dapr:**
```csharp
// Dapr state store (kan skifte backend uden code change)
await daprClient.SaveStateAsync(
    "statestore",  // Component name
    "product-123",
    productDto
);
```

**Fordele:**
- ✅ Abstraktion over forskellige backends (Redis, PostgreSQL, CosmosDB)
- ✅ TTL, consistency models built-in
- ✅ Kan ændre backend via config (ikke code)

#### 3.3.3 Pub/Sub Messaging

**Use case:** Når et produkt opdateres, notificer andre services.

**Med Dapr:**
```csharp
// Publisher (Product API)
await daprClient.PublishEventAsync(
    "pubsub",               // Pub/sub component
    "product-updated",      // Topic
    productUpdatedEvent
);

// Subscriber (Organ API)
[Topic("pubsub", "product-updated")]
[HttpPost("/product-updated")]
public async Task<ActionResult> OnProductUpdated(ProductUpdatedEvent evt)
{
    // Handle event
    return Ok();
}
```

**Fordele:**
- ✅ Decoupling mellem services
- ✅ Kan bruge RabbitMQ, Azure Service Bus, Kafka (samme code)
- ✅ At-least-once delivery guarantees

### 3.4 Dapr Components Configuration

**State Store (PostgreSQL):**
```yaml
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: statestore
spec:
  type: state.postgresql
  version: v1
  metadata:
  - name: connectionString
    value: "Server=postgres;Port=5432;..."
  - name: tableName
    value: "dapr_state"
```

**Pub/Sub (RabbitMQ):**
```yaml
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: pubsub
spec:
  type: pubsub.rabbitmq
  version: v1
  metadata:
  - name: host
    value: "amqp://rabbitmq:5672"
  - name: durable
    value: "true"
```

### 3.5 Hvornår ER Dapr Relevant?

#### ✅ JA til Dapr hvis:

1. **Multiple microservices (5+)**
   - Nuværende: 2-3 services → Borderline
   - Fremtid: Hvis I planlægger 5+ microservices

2. **Async messaging behov**
   - Event-driven architecture
   - Background job processing
   - Notifications mellem services

3. **Multi-cloud eller hybrid deployment**
   - Dapr abstraherer cloud-specific services
   - Lettere at skifte mellem Azure Service Bus ↔ RabbitMQ

4. **Observability krav**
   - Distributed tracing OOTB
   - Metrics eksport til Prometheus

5. **State management complexity**
   - Caching layer med forskellige backends
   - Session state across services

#### ❌ NEJ til Dapr hvis:

1. **Få services (2-3)**
   - Overhead > benefit
   - Direct HTTP calls er simple nok

2. **Primært CRUD operations**
   - Ingen complex workflows
   - Minimal inter-service communication

3. **Team har ikke distributed systems erfaring**
   - Learning curve er steep
   - Debugging er sværere

4. **Azure-only deployment**
   - Azure Functions + Azure Service Bus er simplere
   - Managed services > self-hosted Dapr components

### 3.6 Dapr Migration Strategy (Hvis Relevant)

**Phase 1: Infrastructure**
```bash
# Install Dapr CLI
wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash

# Initialize Dapr (self-hosted mode)
dapr init

# Eller Kubernetes mode
dapr init --kubernetes
```

**Phase 2: Code Changes**
```csharp
// Program.cs
builder.Services.AddControllers().AddDapr();

// appsettings.json
{
  "Dapr": {
    "HttpEndpoint": "http://localhost:3500",
    "GrpcEndpoint": "http://localhost:50001"
  }
}
```

**Phase 3: Gradual Adoption**
1. Start med observability (tracing)
2. Tilføj pub/sub for events
3. Konverter service calls til Dapr invocation
4. State management som sidste (største refactoring)

### 3.7 Dapr Overhead

**Resource overhead:**
- Sidecar memory: 50-100MB per container
- CPU: Minimal (~5-10m)

**Latency overhead:**
- Service invocation: +1-3ms (sidecar hop)
- State management: +2-5ms

**Operational overhead:**
- Dapr control plane (Kubernetes): 3 ekstra pods
- Component configuration management
- Version upgrades (Dapr releases hver 3 måneder)

---

## 4. Anbefalet Strategy - Trinvis Approach

### 4.1 Phase 1: Lokal Udvikling (Docker Compose) - ANBEFALET START

**Timeline:** 1-2 uger
**Risk:** Lav
**Benefit:** Højt (bedre developer experience)

**Implementering:**

1. **Opret Dockerfiles** for Product API og Organ API
2. **Udvid docker-compose.yml** i `/Users/sarleth/repos/opentofu/my-infra/`
3. **Tilføj Jaeger container** for lokal tracing
4. **Konfigurer environment variables** fra .env fil
5. **Test integration** med PostgreSQL container

**Deliverable:**
```bash
# Fra opentofu/my-infra/
docker compose up -d

# Alle services kører:
# - PostgreSQL: localhost:5434
# - Product API: localhost:7071
# - Organ API: localhost:7072
# - Jaeger UI: localhost:16686
# - PgAdmin: localhost:5050
```

**Next step:** Copy resultatet til OpenTofu projekt.

### 4.2 Phase 2: Production Decision

Efter Phase 1, evaluer baseret på:

**→ Vælg Azure Container Apps hvis:**
- I vil blive på Azure
- Serverless scaling er vigtig
- Teamet er lille (1-3 developers)

**→ Vælg Kubernetes (AKS) hvis:**
- Multi-cloud krav
- Avanceret networking / service mesh
- Teamet har Kubernetes erfaring

**→ Bliv ved Azure Functions hvis:**
- Nuværende setup fungerer fint
- Ingen containerisering behov i produktion
- Cost optimization er kritisk (Consumption plan)

### 4.3 Dapr Decision Tree

```
Start
  │
  ├─ Har I 5+ microservices?
  │   ├─ Ja → Overvej Dapr
  │   └─ Nej → Spring Dapr over (for nu)
  │
  ├─ Behov for event-driven architecture?
  │   ├─ Ja → Dapr kan hjælpe
  │   └─ Nej → Direct HTTP calls er fint
  │
  ├─ Multi-cloud deployment?
  │   ├─ Ja → Dapr giver portability
  │   └─ Nej → Azure managed services er simplere
  │
  └─ Team erfaring med distributed systems?
      ├─ Ja → Dapr er feasible
      └─ Nej → Start simpelt, tilføj Dapr senere
```

**Konklusion for VelPharma:**
❌ **Spring Dapr over NU** - I har 2-3 services, Azure-focused, simpelt communication pattern.
✅ **Re-evaluer om 6-12 måneder** når arkitekturen vokser.

---

## 5. Implementation Roadmap

### Anbefalet Path: Docker Compose → Azure Container Apps

#### Milestone 1: Lokal Docker Setup (Uge 1-2)

**Tasks:**
- [ ] Opret `Dockerfile` for Product API
- [ ] Opret `Dockerfile` for Organ API
- [ ] Udvid `docker-compose.yml` med backend services
- [ ] Tilføj Jaeger container til compose fil
- [ ] Eksternaliser alle environment variables
- [ ] Test health checks og logging
- [ ] Dokumenter setup i README

**Definition of Done:**
- Alle services kan startes med `docker compose up`
- Swagger UI tilgængeligt på localhost
- Database connectivity fungerer
- Logs flyder til console og Jaeger

#### Milestone 2: OpenTofu Integration (Uge 3)

**Tasks:**
- [ ] Kopier Docker setup til `/Users/sarleth/repos/opentofu/my-infra/`
- [ ] Opdater OpenTofu main.tf til at generere docker-compose.yml
- [ ] Tilføj backend services til .env generation
- [ ] Opret scripts til build + deploy (`build-backend.sh`)
- [ ] Test fra clean checkout

**Definition of Done:**
- `tofu apply` genererer komplet Docker setup
- `./reset-db.sh && docker compose up` starter hele stacken
- Team kan clone repo + køre lokalt på < 15 min

#### Milestone 3: Production Deployment (Uge 4-6) - VALGFRI

**Tasks (hvis I vælger Azure Container Apps):**
- [ ] Opret Azure Container Registry (ACR)
- [ ] Setup CI/CD pipeline (build + push til ACR)
- [ ] Opret Bicep modules for Container Apps Environment
- [ ] Deploy Container Apps via Bicep
- [ ] Konfigurer Application Insights integration
- [ ] Setup custom domain + TLS certificates
- [ ] Load testing + performance validation

**Definition of Done:**
- Production deployment via GitHub Actions
- Auto-scaling fungerer (test med load)
- Monitoring dashboards i Azure Portal
- Rollback strategy dokumenteret

---

## 6. Cost Analysis

### 6.1 Nuværende (Azure Functions)

**Monthly cost (estimat):**
```
Azure Functions (Premium Plan EP1):
  - 1 instance × €150/month = €150

PostgreSQL Flexible Server (Burstable B1ms):
  - 1 vCore, 2GB RAM = €25/month

Application Insights:
  - 5GB ingestion/month = €12

Total: ~€187/month (~$200/month)
```

### 6.2 Docker Compose (Lokal)

**Monthly cost:**
```
Udviklings-maskine overhead:
  - 4GB RAM ekstra = €0 (existing hardware)
  - Docker Desktop = €0 (free tier)

Total: €0/month (kun udvikling)
```

### 6.3 Azure Container Apps

**Monthly cost (estimat):**
```
Container Apps Environment:
  - Consumption plan = €0 (base)

Container Apps (2 apps):
  - 0.5 vCPU × 1GB × 730 hours × €0.000014/vCPU-sec
  - Request pricing: €0.000001/request
  - Estimated: €80-120/month

Azure Container Registry:
  - Basic tier = €5/month

PostgreSQL Flexible Server:
  - Same as current = €25/month

Application Insights:
  - Same as current = €12/month

Total: ~€122-162/month (~$130-175/month)
```

**Savings:** 15-35% vs. Functions Premium Plan

### 6.4 Azure Kubernetes Service (AKS)

**Monthly cost (estimat):**
```
AKS Cluster:
  - 3 × Standard_B2s nodes (2 vCPU, 4GB RAM) = €90/month
  - Cluster management = €0 (free)

Container Registry:
  - Basic tier = €5/month

PostgreSQL:
  - Same as current = €25/month

Load Balancer:
  - Standard LB = €20/month

Application Insights:
  - Same = €12/month

Total: ~€152/month (~$165/month)
```

**Note:** AKS kræver operational overhead (teamet skal vedligeholde cluster).

### 6.5 Cost Comparison

| Deployment Model | Monthly Cost | Scaling | Operational Overhead |
|------------------|--------------|---------|----------------------|
| **Azure Functions (Current)** | €187 | Auto | Lav |
| **Docker Compose (Dev only)** | €0 | Manual | Lav |
| **Azure Container Apps** | €122-162 | Auto | Lav |
| **Azure Kubernetes (AKS)** | €152 | Manual/HPA | Høj |

**Anbefaling:** Container Apps giver bedste cost/benefit ratio.

---

## 7. Risici og Mitigations

### 7.1 Migration Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| **Data migration fejl** | Høj | Medium | Test migration script, backup before deploy |
| **Performance degradation** | Medium | Lav | Load testing før prod, samme resources |
| **Configuration drift** | Medium | Medium | Infrastructure as Code (Bicep/Helm) |
| **Team knowledge gap** | Medium | Medium | Training sessions, dokumentation |
| **Cost overrun** | Medium | Lav | Budget alerts, cost monitoring dashboard |
| **Vendor lock-in (ACA)** | Lav | Medium | Docker Compose abstraction layer |

### 7.2 Operational Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| **Container registry downtime** | Høj | Multi-region registry, local caching |
| **Cold start latency** | Medium | Min replicas = 1 (ikke scale to zero) |
| **Logging overhead** | Lav | Log sampling, retention policies |
| **Secret leakage** | Høj | Azure Key Vault, never commit secrets |

---

## 8. Beslutnings Matrix

### 8.1 Hvis jeres prioritet er...

| Prioritet | Anbefaling |
|-----------|------------|
| **Developer Experience** | ✅ Docker Compose (lokal udvikling) |
| **Cost Optimization** | ✅ Azure Container Apps (scale-to-zero) |
| **Maximum Control** | ✅ Kubernetes (AKS eller self-hosted) |
| **Minimal Migration Effort** | ✅ Bliv ved Azure Functions |
| **Multi-Cloud Strategy** | ✅ Kubernetes + Dapr |
| **Rapid Prototyping** | ✅ Docker Compose → Container Apps |

### 8.2 Team Size Considerations

| Team Size | Anbefaling |
|-----------|------------|
| **1-2 developers** | Docker Compose + Azure Container Apps |
| **3-5 developers** | Azure Container Apps eller AKS (managed) |
| **6+ developers** | AKS + Dapr (hvis microservices > 5) |

---

## 9. Konklusion og Næste Skridt

### 9.1 Executive Summary

**Kan det lade sig gøre?** ✅ **JA** - VelPharma backend kan fuldt containeriseres.

**Anbefalet approach:**

1. **Nu (Phase 1):** Docker Compose for lokal udvikling
   - Effort: 1-2 uger
   - Risk: Lav
   - Benefit: Konsistent dev environment, lettere onboarding

2. **Om 1-2 måneder (Phase 2):** Evaluer produktion
   - Hvis Azure-only: Azure Container Apps
   - Hvis multi-cloud: Kubernetes (AKS)

3. **Dapr:** Spring over NU, re-evaluer om 6-12 måneder

### 9.2 Immediate Action Items

**Denne uge:**
- [ ] Review denne analyse med teamet
- [ ] Beslut om I går videre med Docker Compose approach
- [ ] Assign tasks hvis approved

**Næste sprint (uge 1-2):**
- [ ] Implement Dockerfiles for begge Function Apps
- [ ] Udvid docker-compose.yml i OpenTofu projektet
- [ ] Test lokal setup end-to-end
- [ ] Dokumenter ny developer onboarding flow

**Om 1 måned:**
- [ ] Evaluer developer feedback
- [ ] Beslut om production containerization
- [ ] Hvis ja: Start Bicep modules for Azure Container Apps

### 9.3 Dapr Decision - Konkret Anbefaling

**For VelPharma (Oktober 2025):**

❌ **Spring Dapr over NU** fordi:
- Kun 2-3 microservices
- Simpel HTTP-based kommunikation
- Azure-native deployment
- Team fokus skal være på business logic, ikke infrastructure

✅ **Re-evaluer Dapr om 6-12 måneder** hvis:
- I når 5+ microservices
- Event-driven patterns bliver nødvendige
- Multi-cloud bliver et krav
- Teamet har kapacitet til at lære distributed systems patterns

**Alternative til Dapr (for nu):**
- Azure Service Bus (hvis pub/sub behov)
- Application Insights (distributed tracing)
- Azure Cache for Redis (state management)

---

## 10. Resources og Yderligere Læsning

### 10.1 Docker + Azure Functions

- [Azure Functions i Docker](https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image)
- [.NET 9 i Docker - Best Practices](https://learn.microsoft.com/en-us/dotnet/core/docker/build-container)

### 10.2 Azure Container Apps

- [Container Apps Documentation](https://learn.microsoft.com/en-us/azure/container-apps/)
- [Bicep templates for Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/azure-resource-manager-api-spec)
- [Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)

### 10.3 Kubernetes

- [AKS Best Practices](https://learn.microsoft.com/en-us/azure/aks/best-practices)
- [Helm Charts Guide](https://helm.sh/docs/)

### 10.4 Dapr

- [Dapr Documentation](https://docs.dapr.io/)
- [Dapr for .NET Developers](https://learn.microsoft.com/en-us/dotnet/architecture/dapr-for-net-developers/)
- [Azure Container Apps + Dapr](https://learn.microsoft.com/en-us/azure/container-apps/dapr-overview)

### 10.5 OpenTofu

- [OpenTofu Docker Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)
- [Terraform to OpenTofu Migration](https://opentofu.org/docs/intro/migration/)

---

## Appendix A: Sample Dockerfile (Production-Ready)

```dockerfile
# =================================================================
# Production-ready Dockerfile for Vp.Azure.Function.Product.Api
# =================================================================

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy solution and project files for better caching
COPY ["backend/Azure/AzureFunctions/Vp.Azure.Function.Product.Api/Vp.Azure.Function.Product.Api/Vp.Azure.Function.Product.Api.csproj", "Vp.Azure.Function.Product.Api/"]
COPY ["backend/Common/Azure/SharedLogic/AzureSharedLogic/AzureSharedLogic.csproj", "AzureSharedLogic/"]
COPY ["backend/Common/Azure/SharedLogic/VpSharedLogic/VpSharedLogic.csproj", "VpSharedLogic/"]
COPY ["backend/Common/Azure/SharedLogic/VpStandardLibrary/VpStandardLibrary.csproj", "VpStandardLibrary/"]
COPY ["backend/Tools/MasterdataLoader/DatabaseLayer/DatabaseLayer/DatabaseLayer.csproj", "DatabaseLayer/"]

# Restore dependencies (cached if csproj files unchanged)
RUN dotnet restore "Vp.Azure.Function.Product.Api/Vp.Azure.Function.Product.Api.csproj"

# Copy all source code
COPY backend/ .

# Build and publish
WORKDIR "/src/Azure/AzureFunctions/Vp.Azure.Function.Product.Api/Vp.Azure.Function.Product.Api"
RUN dotnet build "Vp.Azure.Function.Product.Api.csproj" -c Release -o /app/build
RUN dotnet publish "Vp.Azure.Function.Product.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage - Azure Functions isolated worker
FROM mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated9.0
WORKDIR /home/site/wwwroot

# Copy published output
COPY --from=build /app/publish .

# Environment variables for Azure Functions runtime
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true \
    ASPNETCORE_ENVIRONMENT=Production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/api/v1/health || exit 1

# Expose port
EXPOSE 80

# Run as non-root user (security best practice)
USER app
```

---

## Appendix B: Sample docker-compose.yml (Komplet)

```yaml
version: '3.8'

services:
  # PostgreSQL Database (existing)
  postgres:
    build:
      context: ./postgres
      dockerfile: Dockerfile
    container_name: velpharma-db
    restart: unless-stopped
    env_file: .env
    ports:
      - "5434:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./postgres/init:/docker-entrypoint-initdb.d
      - ./backups:/backups
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-postgres}"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 5s
    networks:
      - velpharma-network

  # Product API (NEW)
  product-api:
    build:
      context: ../../vp/velpharma
      dockerfile: backend/Azure/AzureFunctions/Vp.Azure.Function.Product.Api/Dockerfile
    container_name: velpharma-product-api
    restart: unless-stopped
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - PostgreSQL__ConnectionString=Server=postgres;Port=5432;Database=${POSTGRES_DB};User Id=${POSTGRES_USER};Password=${POSTGRES_PASSWORD};
      - JaegerOpenTelemetry=http://jaeger:4317
      - AzureWebJobsStorage=UseDevelopmentStorage=true
      - FUNCTIONS_WORKER_RUNTIME=dotnet-isolated
    ports:
      - "7071:80"
    depends_on:
      postgres:
        condition: service_healthy
      jaeger:
        condition: service_started
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/api/v1/health"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s
    networks:
      - velpharma-network

  # Organ API (NEW)
  organ-api:
    build:
      context: ../../vp/velpharma
      dockerfile: backend/Azure/AzureFunctions/Vp.Azure.Function.Organ.Api/Dockerfile
    container_name: velpharma-organ-api
    restart: unless-stopped
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - PostgreSQL__ConnectionString=Server=postgres;Port=5432;Database=${POSTGRES_DB};User Id=${POSTGRES_USER};Password=${POSTGRES_PASSWORD};
      - JaegerOpenTelemetry=http://jaeger:4317
      - AzureWebJobsStorage=UseDevelopmentStorage=true
      - FUNCTIONS_WORKER_RUNTIME=dotnet-isolated
    ports:
      - "7072:80"
    depends_on:
      postgres:
        condition: service_healthy
      jaeger:
        condition: service_started
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/api/v1/health"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s
    networks:
      - velpharma-network

  # Jaeger (Distributed Tracing) (NEW)
  jaeger:
    image: jaegertracing/all-in-one:latest
    container_name: velpharma-jaeger
    restart: unless-stopped
    environment:
      - COLLECTOR_OTLP_ENABLED=true
    ports:
      - "16686:16686"  # Jaeger UI
      - "4317:4317"    # OTLP gRPC
      - "4318:4318"    # OTLP HTTP
    networks:
      - velpharma-network

  # PgAdmin (existing)
  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: velpharma-pgadmin
    restart: unless-stopped
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@velpharma.com
      PGADMIN_DEFAULT_PASSWORD: admin
      PGADMIN_CONFIG_SERVER_MODE: 'False'
    ports:
      - "5050:80"
    volumes:
      - pgadmin_data:/var/lib/pgadmin
    networks:
      - velpharma-network
    depends_on:
      postgres:
        condition: service_healthy

volumes:
  postgres_data:
    driver: local
  pgadmin_data:
    driver: local

networks:
  velpharma-network:
    driver: bridge
```

---

**Document Version:** 1.0
**Last Updated:** 18. Oktober 2025
**Author:** Claude Code Analysis
**Review Status:** Draft - Afventer team review