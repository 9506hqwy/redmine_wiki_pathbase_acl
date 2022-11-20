# Redmine Wiki Path Base Acl

This plugin provides wiki ACL base on path.

## Features

-  Configure wiki ACL base on path per project.

## Installation

1. Download plugin in Redmine plugin directory.
   ```sh
   git clone https://github.com/9506hqwy/redmine_wiki_pathbase_acl.git
   ```
2. Install plugin in Redmine directory.
   ```sh
   bundle exec rake redmine:plugins:migrate NAME=redmine_wiki_pathbase_acl RAILS_ENV=production
   ```
3. Start Redmine

## Configuration

1. Enable plugin module.

   Check [Wiki ACL] in project setting.

2. Set in [Wiki ACL] tab in project setting.

   Configure acl definition per wiki path and role permission.
   If request match acl definition at first, request is allowed or denied.
   If request does not match all acl definition, request is allowed.

   - If Who is empry, all user is match.
   - Path is wiki name and ancestor wiki names combined with '/'.
     Path is regular expression.
     If `:{user}` in Path, replace to request's user login name.

## Examples

This example provides personal wiki.

| Who  | Path                  | Permission  | Control  |
| ---- | --------------------- | ----------- | -------- |
|      | ^wiki/private/:{user} | View wiki   | allow    |
|      | ^wiki/private/        | View wiki   | deny     |

User1 is allowed to view *wiki/private/user1*, but can not view *private/user2*.
User2 is allowed to view *wiki/private/user2*, but can not view *private/user1*.

## Notes

- Wiki ACL does not affect to system administrator.
- Wiki ACL can not overrides role permission that is disabled.
  So user who does not have `Edit wiki pgaes` role permission can not edit any wiki in project.
- Wiki is listed even if user matches denied Wiki ACL `View wiki`.
- Currently, Permission is `View wiki`, `Edit wiki pages`, and `Edit wiki pages` includes permission except view.
  This will be changed in the future.

## Tested Environment

* Redmine (Docker Image)
  * 3.4
  * 4.0
  * 4.1
  * 4.2
  * 5.0
* Database
  * SQLite
  * MySQL 5.7
  * PostgreSQL 12

## References

- [#2636 Feature Request: Wiki ACLs (Access control for individual pages)](https://www.redmine.org/issues/2636)
