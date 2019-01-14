# Configure the Heroku provider
provider "heroku" {
}

variable "appname" {
  description = "Name of Heroku application"
  default = "vt-proxy-api"
}

variable "region" {
  description = "Heroku application region"
  default = "us"
}

# Create a new Heroku app
resource "heroku_app" "app" {
  name = "${var.appname}"
  region = "${var.region}"

  stack = "heroku-18"

  buildpacks = [
    "heroku/ruby"
  ]

  config_vars = {
    NEW_RELIC_DISTRIBUTED_TRACING_ENABLED = "true"
  }
}

# Postgresql
resource "heroku_addon" "database" {
  app = "${heroku_app.app.name}"
  plan = "heroku-postgresql:hobby-dev"
}

# New Relic
resource "heroku_addon" "newrelic" {
  app = "${heroku_app.app.name}"
  plan = "newrelic:wayne"
}

output "appinfo" {
  value = <<END

    appname: ${heroku_app.app.name}
    git url: ${heroku_app.app.git_url}
    web url: ${heroku_app.app.web_url}

    git remote add heroku ${heroku_app.app.git_url}
    git push heroku master
  END
}
