# Community Tracker Mod for Steampipe

A collection of benchmarks, controls, and dashboards used to track organization settings, repository settings, open issues and pull requests, and more.

## Overview

Dashboards and benchmarks can help answer questions like:

- How old are my issues and pull requests?
- What's my age trend data?
- Which organizations and repositories aren't configured correctly?

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the GitHub plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install github
```

Clone:

```sh
git clone http://github.com/turbot/steampipe-mod-community-tracker.git
cd steampipe-mod-community-tracker
```

### Usage

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser
window at https://localhost:9194. From here, you can run benchmarks by
selecting one or searching for a specific one.

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `steampipe check` command:

Run all controls:

```sh
steampipe check all
```

Run a single benchmark:

```sh
steampipe check benchmark.repository_steampipe_plugin_checks
```

Run a specific control:

```sh
steampipe check control.repository_steampipe_plugin_standard_description_is_set
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).

### Credentials

This mod uses the credentials configured in the [Steampipe GitHub plugin](https://hub.steampipe.io/plugins/turbot/github).

Note: Some benchmarks require organization and repository admin access. If your GitHub user doesn't have this access, some controls will return incorrect results.

### Configuration

No extra configuration is required.
