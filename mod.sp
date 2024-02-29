mod "community_tracker" {
  # hub metadata
  title       = "Community Tracker"
  description = "Track GitHub organization and repository configurations, open issues and PRs, and trends."
  color       = "#191717"

  require {
    plugin "github" {
      min_version = "0.34.1"
    }
  }
}
