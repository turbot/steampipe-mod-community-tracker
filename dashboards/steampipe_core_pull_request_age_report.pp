dashboard "steampipe_core_pull_request_age_report" {

  title = "Steampipe Core Pull Requests Age Report"

  tags = merge(local.github_pull_request_common_tags, {
    type = "Report"
  })

  container {

    # Analysis
    card {
      sql   = query.steampipe_cli_external_pull_request_count.sql
      width = 2
    }
    card {
      sql   = query.steampipe_sdk_external_pull_request_count.sql
      width = 2
    }

    card {
      sql   = query.steampipe_fdw_external_pull_request_count.sql
      width = 2
    }

    card {
      sql   = query.steampipe_docs_external_pull_request_count.sql
      width = 2
    }

    card {
      sql   = query.steampipe_core_total_days_pull_request_count.sql
      width = 2
    }

    table {
      sql = query.steampipe_core_pull_request_table.sql

      column "url" {
        display = "none"
      }

      column "Pull Request" {
        href = "{{.'url'}}"
      }
    }

  }

}

query "steampipe_core_total_days_pull_request_count" {
  sql = <<-EOQ
    select
      'Total' as label,
      case
        when sum(now()::date - created_at::date) is null then '0 days'
        else sum(now()::date - created_at::date) || ' days'
      end as value,
      case
        when sum(now()::date - created_at::date) > 30 then 'alert'
        else 'ok'
      end as type
    from
      github_search_pull_request
    where
      query = '${local.dashboard_pull_request_search_query}'
      and (repository_full_name ~ 'turbot/steampipe-(docs|fdw|plugin-sdk)' or repository_full_name = 'turbot/steampipe')
      and author ->> 'login' not in (
        select
          m.login as member_login
        from
          github_organization_member m
        where
          m.organization = 'turbot'
       );
    EOQ
}

query "steampipe_cli_external_pull_request_count" {
  sql = <<-EOQ
    select
      'CLI' as label,
      case
        when sum(now()::date - created_at::date) is null then '0 days'
        else sum(now()::date - created_at::date) || ' days'
      end as value,
      case
        when sum(now()::date - created_at::date) > 30 then 'alert'
        else 'ok'
      end as type
    from
      github_search_pull_request
    where
      query = '${local.dashboard_pull_request_search_query}'
      and repository_full_name = 'turbot/steampipe'
      and author ->> 'login' not in (
        select
          m.login as member_login
        from
          github_organization_member m
        where
          m.organization = 'turbot'
       );
    EOQ
}

query "steampipe_sdk_external_pull_request_count" {
  sql = <<-EOQ
    select
      'SDK' as label,
      case
        when sum(now()::date - created_at::date) is null then '0 days'
        else sum(now()::date - created_at::date) || ' days'
      end as value,
      case
        when sum(now()::date - created_at::date) > 30 then 'alert'
        else 'ok'
      end as type
    from
      github_search_pull_request
    where
      query = '${local.dashboard_pull_request_search_query}'
      and repository_full_name = 'turbot/steampipe-plugin-sdk'
      and author ->> 'login' not in (
        select
          m.login as member_login
        from
          github_organization_member m
        where
          m.organization = 'turbot'
       );
    EOQ
}

query "steampipe_fdw_external_pull_request_count" {
  sql = <<-EOQ
    select
      'FDW' as label,
      case
        when sum(now()::date - created_at::date) is null then '0 days'
        else sum(now()::date - created_at::date) || ' days'
      end as value,
      case
        when sum(now()::date - created_at::date) > 30 then 'alert'
        else 'ok'
      end as type
    from
      github_search_pull_request
    where
      query = '${local.dashboard_pull_request_search_query}'
      and repository_full_name = 'turbot/steampipe-fdw'
      and author ->> 'login' not in (
        select
          m.login as member_login
        from
          github_organization_member m
        where
          m.organization = 'turbot'
       );
    EOQ
}

query "steampipe_docs_external_pull_request_count" {
  sql = <<-EOQ
    select
      'Docs' as label,
      case
        when sum(now()::date - created_at::date) is null then '0 days'
        else sum(now()::date - created_at::date) || ' days'
      end as value,
      case
        when sum(now()::date - created_at::date) > 30 then 'alert'
        else 'ok'
      end as type
    from
      github_search_pull_request
    where
      query = '${local.dashboard_pull_request_search_query}'
      and repository_full_name = 'turbot/steampipe-docs'
      and author ->> 'login' not in (
        select
          m.login as member_login
        from
          github_organization_member m
        where
          m.organization = 'turbot'
       );
    EOQ
}

query "steampipe_core_pull_request_table" {
  sql = <<-EOQ
    select
      repository_full_name as "Repository",
      title as "Pull Request",
      now()::date - created_at::date as "Age in Days",
      now()::date - updated_at::date as "Last Updated (Days)",
      author ->> 'login' as "Author",
      url
    from
      github_search_pull_request
    where
      query = '${local.dashboard_pull_request_search_query}'
      and (repository_full_name ~ 'turbot/steampipe-(docs|fdw|plugin-sdk)' or repository_full_name = 'turbot/steampipe')
      and author ->> 'login' not in (
        select
          m.login as member_login
        from
          github_organization_member m
        where
          m.organization = 'turbot'
        )
    order by
      "Age in Days" desc;
  EOQ
}
