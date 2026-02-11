# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and
this project adheres to [Semantic Versioning](https://semver.org/).

## [0.3.0] - 2026-02-12

### Added
- Custom exception hierarchy: `ActiveCollab::Error`, `APIError`, `AuthenticationError`, `NotFoundError`, `RateLimitError`, `ParseError`.
- HTTP error handling: 4xx/5xx responses now raise descriptive exceptions.
- JSON parse error handling: invalid response bodies raise `ParseError`.
- HTTP timeouts (30s open/read) to prevent hanging requests.
- Comprehensive test coverage for all public methods (63 examples).
- YARD documentation for all public methods.
- CHANGELOG, `.rspec`, and `Rakefile`.
- Gemspec metadata (`homepage_uri`, `source_code_uri`, `changelog_uri`, `rubygems_mfa_required`).

### Changed
- **Breaking:** `Projects#list` renamed to `Projects#all`.
- **Breaking:** `Tasks#get` renamed to `Tasks#find`.
- **Breaking:** `TimeRecords#push` renamed to `TimeRecords#create`.
- **Breaking:** `Token#header` renamed to `Token#auth_header`.
- **Breaking:** `Token#raw` removed (use `Token#value` instead).
- `Response#to_json` renamed to `Response#to_json_string` to avoid shadowing `Object#to_json`. The `format: 'json'` parameter is unchanged.
- VERSION extracted to dedicated `lib/active_collab/version.rb`.
- Gemspec no longer loads the entire library at eval time.
- Development dependencies moved from gemspec to Gemfile.
- Narrowed ActiveSupport requires to only the extensions actually used.
- `json` dependency loosened from `~> 2.18` to `~> 2.10`.
- `activesupport` dependency widened to `>= 7, < 9`.
- Tasks and TaskLists source files moved from `lib/active_collab/projects/` to `lib/active_collab/` to match their namespace.

### Fixed
- `Client#initialize` no longer mutates the caller's options hash.
- `Token#auth_header` now uses correct `AuthApiToken` casing (was `Authapitoken`).
- Mixed string/symbol key handling in `Tasks#archived` pagination.
- Added explicit `require 'ostruct'` for Ruby 3.3+ compatibility.
- `frozen_string_literal: true` added to all source files.

## [0.2.2] - 2025-09-03

### Changed
- Pinned `activesupport` to `~> 7` minimum.

## [0.2.1] - 2025-06-28

### Fixed
- Added missing `params` argument to `Projects#list`.

## [0.2.0] - 2025-06-28

### Added
- Format parameter support (`hash`, `json`, `object`) for all API calls.
- GET requests now correctly append params as query strings.

## [0.1.0] - 2025-06-15

### Added
- Initial release with Client, Token, Response, LoginResponse.
- Projects, Tasks, TaskLists, TimeRecords, and Users resources.
- Token-based and credential-based authentication.

[0.3.0]: https://github.com/davelens/active_collab-ruby-sdk/compare/0.2.2...0.3.0
[0.2.2]: https://github.com/davelens/active_collab-ruby-sdk/compare/0.2.1...0.2.2
[0.2.1]: https://github.com/davelens/active_collab-ruby-sdk/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/davelens/active_collab-ruby-sdk/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/davelens/active_collab-ruby-sdk/releases/tag/0.1.0
