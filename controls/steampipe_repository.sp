benchmark "steampipe_repository_checks" {
  title = "Steampipe Repository Checks"
  children = [
    benchmark.steampipe_core_repository_checks,
    benchmark.steampipe_mod_repository_checks,
    benchmark.steampipe_plugin_repository_checks
  ]

  tags = merge(local.github_repository_common_tags, {
    type = "Benchmark"
  })
}
