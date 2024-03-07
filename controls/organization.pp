benchmark "organization_checks" {
  title = "Turbot Organization Checks"
  children = [
    control.organization_description_set,
    control.organization_domains_verified,
    control.organization_email_set,
    control.organization_homepage_set,
    control.organization_profile_pic_set,
    control.organization_two_factor_authentication_required
  ]

  tags = merge(local.github_organization_common_tags, {
    type = "Benchmark"
  })
}

control "organization_two_factor_authentication_required" {
  title       = "Organization two-factor authentication should be required for users"
  description = "Two-factor authentication makes it harder for unauthorized actors to access repositories and organizations."
  tags        = local.github_organization_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when two_factor_requirement_enabled is null then 'info'
        when two_factor_requirement_enabled then 'ok'
        else 'alarm'
      end as status,
      coalesce(name, login) ||
        case
          when two_factor_requirement_enabled is null then ' 2FA requirement unverifiable'
          when (two_factor_requirement_enabled)::bool then ' requires 2FA'
          else ' does not require 2FA'
        end || '.' as reason,
      login
    from
      github_my_organization
    where
      login in ${local.organization_all_benchmark};
  EOT
}

control "organization_email_set" {
  title       = "Organization email should be set"
  description = "Setting an email provides useful contact information for users."
  tags        = local.github_organization_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when email is null then 'alarm'
        when email = '' then 'alarm'
        else 'ok'
      end as status,
      coalesce(name, login) || ' email is ' || case when (email is null) then 'not set' when (email = '') then 'not set' else email end || '.' as reason,
      login
    from
      github_my_organization
    where
      login in ${local.organization_all_benchmark};
  EOT
}

control "organization_description_set" {
  title       = "Organization description should be set"
  description = "Setting a description helps users learn more about your organization."
  tags        = local.github_organization_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when description <> '' then 'ok'
        else 'alarm'
      end as status,
      coalesce(name, login) || ' description is ' || case when(description <> '') then description else 'not set' end || '.' as reason,
      login
    from
      github_my_organization
    where
      login in ${local.organization_all_benchmark};
  EOT
}

control "organization_profile_pic_set" {
  title       = "Organization profile picture should be set"
  description = "Setting a profile picture helps users recognize your brand."
  tags        = local.github_organization_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when avatar_url is not null then 'ok'
        else 'alarm'
      end as status,
      coalesce(name, login) || ' profile picture URL is ' || case when(avatar_url <> '') then avatar_url else 'not set' end || '.' as reason,
      login
    from
      github_my_organization
    where
      login in ${local.organization_all_benchmark};
  EOT
}

control "organization_domains_verified" {
  title       = "Organization domains should be verified"
  description = "Verifying your domains helps to confirm the organization's identity and send emails to users with verified emails."
  tags        = local.github_organization_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when is_verified then 'ok'
        else 'alarm'
      end as status,
      coalesce(name, login) || ' domains are ' || case when (is_verified)::bool then 'verified' else 'not verified' end || '.' as reason,
      login
    from
      github_my_organization
    where
      login in ${local.organization_all_benchmark};
  EOT
}

control "organization_homepage_set" {
  title       = "Organization homepage should be set"
  description = "Setting a homepage helps users learn more about your organization."
  tags        = local.github_organization_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when website_url is null then 'alarm'
        when website_url = '' then 'alarm'
        else 'ok'
      end as status,
      coalesce(name, login) || ' homepage is ' || case when (website_url is null) then 'not set' when (website_url = '') then 'not set' else website_url end || '.' as reason,
      login
    from
      github_my_organization
    where
      login in ${local.organization_all_benchmark};
  EOT
}
