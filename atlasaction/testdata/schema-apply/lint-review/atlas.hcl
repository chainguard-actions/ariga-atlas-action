env "test" {
  url = "sqlite://local.db"
  dev = "sqlite://file?mode=memory"
  schema {
    src = "file://schema.lt.hcl"
  }
}
lint {
  review = ERROR
}
