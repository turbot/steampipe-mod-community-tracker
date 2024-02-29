dashboard "flowpipe_mod_issue_age_report" {

  title = "Flowpipe Mod Issue Age Report"

  tags = merge(local.github_issue_common_tags, {
    type = "Report"
  })

  container {

    # Analysis
    card {
      sql   = query.flowpipe_aws_compliance_mod_issue_external_count.sql
      width = 2
    }

    card {
      sql   = query.flowpipe_mod_issue_total_days_count.sql
      width = 2
    }

    table {
      sql = query.flowpipe_mod_issue_table.sql

      column "url" {
        display = "none"
      }

      column "Issue" {
        href = "{{.'url'}}"
      }
    }

  }

}

query "flowpipe_aws_compliance_mod_issue_external_count" {
  sql = <<-EOQ
    select
      'AWS Compliance' as label,
      case
        when sum(now()::date - created_at::date) is null then '0 days'
        else sum(now()::date - created_at::date) || ' days'
      end as value,
      case
        when sum(now()::date - created_at::date) > 30 then 'alert'
        else 'ok'
      end as type
    from
      github_search_issue
    where
      query = '${local.dashboard_issue_search_query}'
      and repository_full_name = 'turbot/flowpipe-mod-aws-compliance'
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

query "flowpipe_mod_issue_total_days_count" {
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
      github_search_issue
    where
      query = '${local.dashboard_issue_search_query}'
      and repository_full_name like 'turbot/flowpipe-mod-%'
      and repository_full_name <> 'turbot/flowpipe-plugin-sdk'
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

query "flowpipe_mod_issue_table" {
  sql = <<-EOQ
    select
      repository_full_name as "Repository",
      title as "Issue",
      now()::date - created_at::date as "Age in Days",
      now()::date - updated_at::date as "Last Updated (Days)",
      author ->> 'login' as "Author",
      url
    from
      github_search_issue
    where
      query = '${local.dashboard_issue_search_query}'
      and repository_full_name like 'turbot/flowpipe-mod-%'
      and repository_full_name <> 'turbot/flowpipe-plugin-sdk'
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
