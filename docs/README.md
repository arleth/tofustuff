# Documentation Diagrams

## PlantUML Diagrams

This folder contains PlantUML diagrams documenting the VelPharma infrastructure.

### Available Diagrams

- **[reset-db-sequence.puml](reset-db-sequence.puml)** - Complete flow of `./reset-db.sh` execution

## Viewing PlantUML Diagrams

### Option 1: VS Code Extension (Recommended)

1. Install the PlantUML extension:
   - Open VS Code
   - Go to Extensions (Cmd+Shift+X)
   - Search for "PlantUML" by jebbs
   - Click Install

2. Install Graphviz (required by PlantUML):
   ```bash
   brew install graphviz
   ```

3. View diagram:
   - Open any `.puml` file
   - Press `Alt+D` (or `Cmd+Shift+P` → "PlantUML: Preview Current Diagram")
   - Diagram renders in preview pane

### Option 2: Online Viewer

1. Copy the contents of the `.puml` file
2. Go to http://www.plantuml.com/plantuml/uml/
3. Paste the code
4. View the rendered diagram

### Option 3: CLI (Generate PNG/SVG)

```bash
# Install PlantUML
brew install plantuml

# Generate PNG
plantuml docs/reset-db-sequence.puml

# Generate SVG
plantuml -tsvg docs/reset-db-sequence.puml

# Output: docs/reset-db-sequence.png or .svg
```

### Option 4: IntelliJ IDEA / WebStorm

1. Install PlantUML integration plugin
2. Right-click on `.puml` file → "View Diagram"

## Diagram Details

### reset-db-sequence.puml

Shows the complete execution flow when running `./reset-db.sh`:

1. **Teardown Phase** - Stop containers, remove volumes
2. **Rebuild Phase** - Build Docker image with init scripts
3. **Start Phase** - Launch postgres container
4. **Initialization Phase** - Automatic execution of init scripts
5. **Data Loading Phase** - 04-load-data.sh loads from Git backup
6. **Health Check Phase** - Container becomes healthy
7. **Complete Phase** - Database ready with production data

**Key Highlights:**
- Shows what happens by default (loads `production_backup_data_only.sql`)
- Shows fallback behavior when backup is missing
- Indicates which seed files are skipped (`.sql.disabled`)
- Shows timing and data volumes loaded

## Adding New Diagrams

When creating new diagrams:

1. Place `.puml` files in this `docs/` folder
2. Use descriptive filenames (e.g., `monthly-update-flow.puml`)
3. Add reference to this README
4. Link from main documentation (DATABASE_WORKFLOW.md, QUICK_START.md, etc.)

All `.puml` files are tracked in Git (not ignored).
