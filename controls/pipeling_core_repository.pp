benchmark "pipeling_core_repository_checks" {
  title = "Pipeling Core Repository Checks"
  children = [
    control.pipeling_core_repository_default_branch_protection_enabled,
    control.pipeling_core_repository_delete_branch_on_merge_enabled,
    control.pipeling_core_repository_description_is_set,
    control.pipeling_core_repository_language_is_correct,
    control.pipeling_core_repository_license_is_correct,
    control.pipeling_core_repository_projects_disabled,
    control.pipeling_core_repository_squash_merge_allowed,
    control.pipeling_core_repository_vulnerability_alerts_enabled,
    control.pipeling_core_repository_wiki_disabled,
  ]

  tags = merge(local.github_repository_common_tags, {
    type = "Benchmark"
  })
}

control "pipeling_core_repository_description_is_set" {
  title = "Pipeling core repositories have a description"
  sql = <<-EOT
    select
      url as resource,
      case
        when description is not null then 'ok'
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
      query = '${local.pipeling_core_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "pipeling_core_repository_has_mandatory_topics" {
  title = "Pipeling core repositories have mandatory topics"
  sql = <<-EOT
    with input as (
      select array['sql', 'pipeling', 'postgresql', 'postgresql-fdw'] as mandatory_topics
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
      query = '${local.pipeling_core_benchmark_search_query}'
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

control "pipeling_core_repository_license_is_correct" {
  title = "Pipeling core repositories use correct license"
  sql = <<-EOT
    select
      url as resource,
      case
        -- The docs repos use CC-BY-NC-SA 4.0 which is not recognized by GitHub
        when name_with_owner like 'turbot/%-docs' and license_info  ->> 'spdx_id' = 'NOASSERTION' then 'ok'
        when name_with_owner in ('turbot/flowpipe', 'turbot/pipe-fittings', 'turbot/powerpipe', 'turbot/steampipe') and license_info ->> 'spdx_id' = 'AGPL-3.0' then 'ok'
        when name_with_owner in ('turbot/steampipe-plugin-sdk', 'turbot/steampipe-postgres-fdw') and license_info ->> 'spdx_id' = 'Apache-2.0' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' license is ' || coalesce(((license_info -> 'spdx_id')::text), 'not set') || '.' as reason,
      name_with_owner
    from
      github_search_repository
    where
      query = '${local.pipeling_core_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "pipeling_core_repository_vulnerability_alerts_enabled" {
  title = "Pipeling core repositories have vulnerability alerts enabled"
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
      query = '${local.pipeling_core_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "pipeling_core_repository_delete_branch_on_merge_enabled" {
  title = "Pipeling core repositories have delete branch on merge enabled"
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
      query = '${local.pipeling_core_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "pipeling_core_repository_default_branch_protection_enabled" {
  title = "Pipeling core repositories have default branch protection enabled"
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
      query = '${local.pipeling_core_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "pipeling_core_repository_wiki_disabled" {
  title = "Pipeling core repositories have wiki disabled"
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
      query = '${local.pipeling_core_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "pipeling_core_repository_projects_disabled" {
  title = "Pipeling core repositories have projects disabled"
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
      query = '${local.pipeling_core_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "pipeling_core_repository_language_is_correct" {
  title = "Pipeling core repositories have language set correctly"
  sql = <<-EOT
    select
      url as resource,
      case
        when name_with_owner like 'turbot/%-docs' then 'skip'
        when name_with_owner = 'turbot/powerpipe' and primary_language ->> 'name' = 'TypeScript' then 'ok'
        when primary_language ->> 'name' = 'Go' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || case
        when name_with_owner like 'turbot/%-docs' then ' language check skipped'
        else ' language is ' || coalesce(((primary_language ->> 'name')::text), 'not set')
      end || '.' as reason,
      name_with_owner
    from
      github_search_repository
    where
      query = '${local.pipeling_core_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}

control "pipeling_core_repository_squash_merge_allowed" {
  title = "Pipeling core repositories allow squash merging"
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
      query = '${local.pipeling_core_benchmark_search_query}'
    order by
      name_with_owner
  EOT
}
