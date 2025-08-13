## v1.0.0 [2025-08-13]

_What's new?_

- All the dashboards are now renamed to use the `.pp` extension.
- New dashboards added: ([#6](https://github.com/turbot/steampipe-mod-community-tracker/pull/6))
  - Flowpipe Core Issue Age Report
  - Flowpipe Core Pull Request Age Report
  - Flowpipe Issue and Pull Request Age Trends
  - Flowpipe Mod Issue Age Report
  - Flowpipe Mod Pull Request Age Report
  - Flowpipe Plugin Issue Age Report
  - Flowpipe Plugin Pull Request Age Report
  - Powerpipe Core Issue Age Report
  - Powerpipe Core Pull Request Age Report
  - Powerpipe Issue and Pull Request Age Trends
  - Powerpipe Mod Issue Age Report
  - Powerpipe Mod Pull Request Age Report
  - Powerpipe Plugin Issue Age Report
  - Powerpipe Plugin Pull Request Age Report
  - Tailpipe Core Issue Age Report
  - Tailpipe Core Pull Request Age Report
  - Tailpipe Issue and Pull Request Age Trends
  - Tailpipe Mod Issue Age Report
  - Tailpipe Mod Pull Request Age Report
  - Tailpipe Plugin Issue Age Report
  - Tailpipe Plugin Pull Request Age Report

## v0.3 [2024-01-09]

_Enhancements_

- Updated the credential section of the doc to include the requisite github token permissions. ([#2](https://github.com/turbot/steampipe-mod-community-tracker/pull/2))

## v0.2 [2023-10-03]

_Breaking changes_

- Removed unnecessary `steampipe_repository_checks` benchmark.

_Bug fixes_

- Fixed title for `steampipe_plugin_repository_checks` benchmark.
- Tidied various reasons for skip reasons in `steampipe_core_repository_checks` benchmark controls.

## v0.1 [2023-09-29]

_What's new?_

- Added Turbot Organization Checks benchmark (`steampipe check benchmark.organization_checks`).
- Added Steampipe Repository Checks benchmark (`steampipe check benchmark.steampipe_repository_checks`).
- New dashboards added:
  - Steampipe Core Issue Age Report
  - Steampipe Core Pull Request Age Report
  - Steampipe Issue and Pull Request Age Trends
  - Steampipe Mod Issue Age Report
  - Steampipe Mod Pull Request Age Report
  - Steampipe Plugin Issue Age Report
  - Steampipe Plugin Pull Request Age Report
