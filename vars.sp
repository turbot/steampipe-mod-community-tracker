# Store mod locals and variables in this file

locals {
  # Benchmarks and controls for specific services should override the "service" tag
  github_common_tags = {
    plugin   = "github"
    service  = "GitHub"
  }

  # Dashboard vars
  dashboard_issue_search_query        = "org:turbot is:open is:public archived:false"
  dashboard_pull_request_search_query = "org:turbot is:open is:public archived:false -author:app/dependabot"

  # Organization checks vars
  organization_all_benchmark = "('steampipe', 'turbot', 'turbothq', 'turbotio')"

  # Repository checks vars
  flowpipe_mod_all_benchmark_search_query    = "in:name flowpipe-mod- is:public archived:false org:turbot"
  flowpipe_mod_turbot_benchmark_search_query = "in:name flowpipe-mod- is:public archived:false org:turbot"

  powerpipe_mod_all_benchmark_search_query    = "in:name powerpipe-mod- is:public archived:false org:turbot"
  powerpipe_mod_turbot_benchmark_search_query = "in:name powerpipe-mod- is:public archived:false org:turbot"

  steampipe_mod_all_benchmark_search_query    = "in:name steampipe-mod- is:public archived:false org:turbot org:ellisvalentiner org:ernw org:francois2metz org:ip2location org:kaggrwal org:marekjalovec org:mr-destructive org:solacelabs org:theapsgroup org:tomba-io"
  steampipe_mod_turbot_benchmark_search_query = "in:name steampipe-mod- is:public archived:false org:turbot"

  steampipe_plugin_all_benchmark_search_query    = "in:name steampipe-plugin- is:public archived:false org:turbot org:ellisvalentiner org:ernw org:francois2metz org:ip2location org:kaggrwal org:marekjalovec org:mr-destructive org:solacelabs org:theapsgroup org:tomba-io"
  steampipe_plugin_turbot_benchmark_search_query = "in:name steampipe-plugin- is:public archived:false org:turbot"

  pipeling_core_benchmark_search_query = "repo:turbot/flowpipe repo:turbot/flowpipe-docs repo:turbot/pipe-fittings repo:turbot/powerpipe repo:turbot/powerpipe-docs repo:turbot/steampipe repo:turbot/steampipe-plugin-sdk repo:turbot/steampipe-docs repo:turbot/steampipe-postgres-fdw is:public archived:false"
}

locals {
  github_organization_common_tags = merge(local.github_common_tags, {
    service = "GitHub/Organization"
  })

  github_issue_common_tags = {
    service = "GitHub/Issue"
  }

  github_pull_request_common_tags = {
    service = "GitHub/PullRequest"
  }

  github_repository_common_tags = merge(local.github_common_tags, {
    service = "GitHub/Repository"
  })
}
