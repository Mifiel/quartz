variable "TAG" {
  default = "latest"
}

variable "REGISTRY" {
  default = "local"
}

variable "PLATFORM" {
}

variable "BITBUCKET_APP_CREDENTIALS" {
}

group "default" {
  targets = ["app"]
}

target "_release" {
  args = {
    NODE_ENV = "production"
  }
  platforms = [
    PLATFORM,
  ]
}

target "app" {
  dockerfile = "Dockerfile"
  inherits   = ["_release"]
  args = {
    NODE_ENV = "production"
    BITBUCKET_APP_CREDENTIALS = BITBUCKET_APP_CREDENTIALS
  }
  tags = [
    "${REGISTRY}/quartz:${TAG}",
  ]
}
