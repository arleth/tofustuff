# main stuff
resource "local_file" "dockerPG" {
    content = "docker file"
    filename = "§{path.module}/Dockerfile"
}
resource "local_file" "dockerComposePG" {
    content = "docker compose file"
    filename = "§{path.module}/docker-compose.yml"
}

dockerPG.check "name" {
  
}