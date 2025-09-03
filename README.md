# Redmine Wiki Path Base Acl

This plugin provides Wiki ACL base on path.

## Features

- Configure Wiki ACL base on path per project.

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

   Configure Wiki ACL definition per wiki path and role permission.
   If request match Wiki ACL definition at first, request is allowed or denied.
   If request does not match all Wiki ACL definition, request is allowed.

   - If Who is empry, all user is match.
   - Path is wiki name and ancestor wiki names combined with '/'.
     Path is regular expression.
     `:{user}` in Path replace request's user login name.
   - Permission is bellow.
     - Delete wiki pages
     - Edit wiki pages
     - Protect wiki pages
     - Rename wiki pages
     - View wiki
     - View wiki history
     - all (includes above permissions)

## Examples

This example provides personal wiki.

| Who | Path                  | Permission        | Control |
| --- | --------------------- | ----------------- | ------- |
|     | ^wiki/private/:{user} | all               | allow   |
|     | ^wiki/private/        | View wiki         | allow   |
|     | ^wiki/private/        | View wiki history | allow   |
|     | ^wiki/private/        | all               | deny    |

User1 can manage *wiki/private/user1*, but can view *private/user2*.
User2 can manage *wiki/private/user2*, but can view *private/user1*.

## Notes

- Wiki ACL does not affect to system administrator.
- Wiki ACL can not overrides role permission that is disabled.
  Example, user who does not have `Edit wiki pages` role permission can not edit any wiki in project.
- Wiki name is listed in index and date index page even if user matches denied Wiki ACL `View wiki`.
- Can not export in index and date index page if request matches denied Wiki ACL `View wiki` without Path.
- Display wiki history in activity log even if user matches denied Wiki ACL `View wiki history`.

## Tested Environment

- Redmine (Docker Image)
  - 4.0
  - 4.1
  - 4.2
  - 5.0
  - 5.1
  - 6.0
- Database
  - SQLite
  - MySQL 5.7 or 8.0
  - PostgreSQL 14

## References

- [#2636 Feature Request: Wiki ACLs (Access control for individual pages)](https://www.redmine.org/issues/2636)
