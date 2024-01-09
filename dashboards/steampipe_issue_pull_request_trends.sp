dashboard "steampipe_issue_pull_request_age_trends" {

  title = "Steampipe Issue and Pull Request Age Trends"

  tags = merge(local.github_common_tags, {
    type = "Dashboard"
  })

  container {

    chart {
      title = "Core Issues Total Age (Days)"
      type  = "line"
      query = query.steampipe_core_issue_trend
      width = 6
    }

    chart {
      title = "Core Pull Requests Total Age (Days)"
      type  = "line"
      query = query.steampipe_core_pull_request_trend
      width = 6
    }

    chart {
      title = "Mod Issues Total Age (Days)"
      type  = "line"
      query = query.steampipe_mod_issue_trend
      width = 6
    }

    chart {
      title = "Mod Pull Requests Total Age (Days)"
      type  = "line"
      query = query.steampipe_mod_pull_request_trend
      width = 6
    }

    chart {
      title = "Plugin Issues Total Age (Days)"
      type  = "line"
      query = query.steampipe_plugin_issue_trend
      width = 6
    }

    chart {
      title = "Plugin Pull Requests Total Age (Days)"
      type  = "line"
      query = query.steampipe_plugin_pull_request_trend
      width = 6
    }
  }

}

query "steampipe_core_issue_trend" {
  sql = <<-EOQ
    select
      created_at as "Date",
      sum((r ->> 'Age in Days')::numeric) as "Days Open"
    from
      pipes_workspace_snapshot,
      jsonb_array_elements(data -> 'panels' -> 'community_tracker.table.container_dashboard_steampipe_core_issue_age_report_anonymous_container_0_anonymous_table_0' -> 'data' -> 'rows') as r
    where
      dashboard_name = 'community_tracker.dashboard.steampipe_core_issue_age_report'
    group by
      created_at
    order by
      created_at
  EOQ
}

query "steampipe_core_pull_request_trend" {
  sql = <<-EOQ
    select
      created_at as "Date",
      sum((r ->> 'Age in Days')::numeric) as "Days Open"
    from
      pipes_workspace_snapshot,
      jsonb_array_elements(data -> 'panels' -> 'community_tracker.table.container_dashboard_steampipe_core_pull_request_age_report_anonymous_container_0_anonymous_table_0' -> 'data' -> 'rows') as r
    where
      dashboard_name = 'community_tracker.dashboard.steampipe_core_pull_request_age_report'
    group by
      created_at
    order by
      created_at
  EOQ
}

query "steampipe_mod_issue_trend" {
  sql = <<-EOQ
    select
      created_at as "Date",
      sum((r ->> 'Age in Days')::numeric) as "Days Open"
    from
      pipes_workspace_snapshot,
      jsonb_array_elements(data -> 'panels' -> 'community_tracker.table.container_dashboard_steampipe_mod_issue_age_report_anonymous_container_0_anonymous_table_0' -> 'data' -> 'rows') as r
    where
      dashboard_name = 'community_tracker.dashboard.steampipe_mod_issue_age_report'
    group by
      created_at
    order by
      created_at
  EOQ
}

query "steampipe_mod_pull_request_trend" {
  sql = <<-EOQ
    select
      created_at as "Date",
      sum((r ->> 'Age in Days')::numeric) as "Days Open"
    from
      pipes_workspace_snapshot,
      jsonb_array_elements(data -> 'panels' -> 'community_tracker.table.container_dashboard_steampipe_mod_pull_request_age_report_anonymous_container_0_anonymous_table_0' -> 'data' -> 'rows') as r
    where
      dashboard_name = 'community_tracker.dashboard.steampipe_mod_pull_request_age_report'
    group by
      created_at
    order by
      created_at
  EOQ
}

query "steampipe_plugin_issue_trend" {
  sql = <<-EOQ
    select
      created_at as "Date",
      sum((r ->> 'Age in Days')::numeric) as "Days Open"
    from
      pipes_workspace_snapshot,
      jsonb_array_elements(data -> 'panels' -> 'community_tracker.table.container_dashboard_steampipe_plugin_issue_age_report_anonymous_container_0_anonymous_table_0' -> 'data' -> 'rows') as r
    where
      dashboard_name = 'community_tracker.dashboard.steampipe_plugin_issue_age_report'
    group by
      created_at
    order by
      created_at
  EOQ
}

query "steampipe_plugin_pull_request_trend" {
  sql = <<-EOQ
    select
      created_at as "Date",
      sum((r ->> 'Age in Days')::numeric) as "Days Open"
    from
      pipes_workspace_snapshot,
      jsonb_array_elements(data -> 'panels' -> 'community_tracker.table.container_dashboard_steampipe_plugin_pull_request_age_report_anonymous_container_0_anonymous_table_0' -> 'data' -> 'rows') as r
    where
      dashboard_name = 'community_tracker.dashboard.steampipe_plugin_pull_request_age_report'
    group by
      created_at
    order by
      created_at
  EOQ
}
