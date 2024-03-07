benchmark "steampipe_plugin_repository_checks" {
  title = "Steampipe Plugin Repository Checks"
  children = [
    control.steampipe_plugin_repository_has_mandatory_topics,
    control.steampipe_plugin_repository_default_branch_protection_enabled,
    control.steampipe_plugin_repository_delete_branch_on_merge_enabled,
    control.steampipe_plugin_repository_homepage_links_to_hub,
    control.steampipe_plugin_repository_language_is_go,
    control.steampipe_plugin_repository_license_is_apache,
    control.steampipe_plugin_repository_projects_disabled,
    control.steampipe_plugin_repository_squash_merge_allowed,
    control.steampipe_plugin_repository_standard_description_is_set,
    control.steampipe_plugin_repository_vulnerability_alerts_enabled,
    control.steampipe_plugin_repository_wiki_disabled,
  ]

  tags = merge(local.github_repository_common_tags, {
    type = "Benchmark"
  })
}

control "steampipe_plugin_repository_standard_description_is_set" {
  title = "Steampipe plugin repositories have standard description"
  sql = <<-EOT
    select
      url as resource,
      case
        when description like 'Use SQL to instantly query %. Open source CLI. No DB required.' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || case
        when description != '' then ': ' || description
        else ' description not set'
      || '.' end as reason,
      name_with_owner
    from
      github_search_repository
    where
      query = '${local.steampipe_plugin_turbot_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "steampipe_plugin_repository_has_mandatory_topics" {
  title = "Steampipe plugin repositories have mandatory topics"
  sql = <<-EOT
    with input as (
      select array['sql', 'steampipe', 'steampipe-plugin', 'postgresql', 'postgresql-fdw'] as mandatory_topics
    ),
    analysis as (
      select
        url,
        topics ?& (input.mandatory_topics) as has_mandatory_topics,
        to_jsonb(input.mandatory_topics) - array(select jsonb_array_elements_text(topics)) as missing_topics,
        name_with_owner
      from
        github_search_repository,
        input
      where
        query ='${local.steampipe_plugin_all_benchmark_search_query}'
    )
    select
      url as resource,
      case
        when has_mandatory_topics then 'ok'
        else 'alarm'
      end as status,
      case
        when has_mandatory_topics then name_with_owner || ' has all mandatory topics.'
        else name_with_owner || ' is missing topics ' || missing_topics || '.'
      end as reason,
      name_with_owner
    from
      analysis
    order by
      name_with_owner
  EOT
}

control "steampipe_plugin_repository_license_is_apache" {
  title = "Steampipe plugin repositories license is Apache 2.0"
  sql = <<-EOT
    select
      url as resource,
      case
        when license_info ->> 'spdx_id' = 'Apache-2.0' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' license is ' || coalesce(((license_info -> 'spdx_id')::text), 'not set') || '.' as reason,
      name_with_owner
    from
      github_search_repository
    where
      query ='${local.steampipe_plugin_all_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

# This control is only reliable for Turbot repos
control "steampipe_plugin_repository_vulnerability_alerts_enabled" {
  title = "Steampipe plugin repositories vulnerability alerts are enabled"
  sql = <<-EOT
    select
      url as resource,
      case
        when has_vulnerability_alerts_enabled then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' vulnerability alerts ' || case
        when has_vulnerability_alerts_enabled then 'enabled'
        else 'disabled'
      end || '.' as reason,
      name_with_owner
    from
      github_search_repository
    where
      query ='${local.steampipe_plugin_turbot_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

# This control is only reliable for Turbot repos
control "steampipe_plugin_repository_delete_branch_on_merge_enabled" {
  title = "Steampipe plugin repositories delete branch on merge enabled"
  sql = <<-EOT
    select
      url as resource,
      case
        when delete_branch_on_merge then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' delete branch on merge ' || case
        when delete_branch_on_merge then 'enabled'
        else 'disabled'
      end || '.' as reason,
      name_with_owner
    from
      github_search_repository
    where
      query = '${local.steampipe_plugin_turbot_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

# This control is only reliable for Turbot repos
control "steampipe_plugin_repository_default_branch_protection_enabled" {
  title = "Steampipe plugin repositories default branch protection is enabled"
  sql = <<-EOT
    select
      url as resource,
      case
        when default_branch_ref -> 'branch_protection_rule' is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when default_branch_ref -> 'branch_protection_rule' is not null then name_with_owner || ' default branch protection enabled.'
        else name_with_owner || ' default branch protection disabled.'
      end as reason,
      name_with_owner
    from
      github_search_repository
    where
      query = '${local.steampipe_plugin_turbot_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "steampipe_plugin_repository_homepage_links_to_hub" {
  title = "Steampipe plugin repositories homepage links to the Hub"
  sql = <<-EOT
    select
      url as resource,
      case
        when homepage_url like 'https://hub.%' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' homepage is ' || case
        when homepage_url = '' then 'not set'
        else homepage_url
      end || '.' as reason,
      name_with_owner
    from
      github_search_repository
    where
      query ='${local.steampipe_plugin_all_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "steampipe_plugin_repository_wiki_disabled" {
  title = "Steampipe plugin repositories wiki is disabled"
  sql = <<-EOT
    select
      url as resource,
      case
        when has_wiki_enabled then 'alarm'
        else 'ok'
      end as status,
      name_with_owner || ' wiki is ' || case
        when has_wiki_enabled then 'enabled'
        else 'disabled'
      end || '.' as reason,
      name_with_owner
    from
      github_search_repository
    where
      query = '${local.steampipe_plugin_turbot_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "steampipe_plugin_repository_projects_disabled" {
  title = "Steampipe plugin repositories projects are disabled"
  sql = <<-EOT
    select
      url as resource,
      case
        when has_projects_enabled then 'alarm'
        else 'ok'
      end as status,
      name_with_owner || ' projects are ' || case
        when has_projects_enabled then 'enabled'
        else 'disabled'
      end || '.' as reason,
      name_with_owner
    from
      github_search_repository
    where
      query = '${local.steampipe_plugin_turbot_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "steampipe_plugin_repository_language_is_go" {
  title = "Steampipe plugin repositories language is Go"
  sql = <<-EOT
    select
      url as resource,
      case
        when primary_language ->> 'name' = 'Go' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' language is ' || coalesce(((primary_language ->> 'name')::text), 'not set') || '.' as reason,
      name_with_owner
    from
      github_search_repository
    where
      query ='${local.steampipe_plugin_all_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

# This control is only reliable for Turbot repos
control "steampipe_plugin_repository_squash_merge_allowed" {
  title = "Steampipe plugin repositories allow squash merging"
  sql = <<-EOT
    select
      url as resource,
      case
        when not merge_commit_allowed and not rebase_merge_allowed and squash_merge_allowed then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || case
        when not merge_commit_allowed and not rebase_merge_allowed and squash_merge_allowed then ' only allows'
        else ' does not only allow'
      end || ' squash merging.' as reason,
      name_with_owner
    from
      github_search_repository
    where
      query = '${local.steampipe_plugin_turbot_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}
