# ActiveCollab Ruby SDK

A Ruby SDK for the [ActiveCollab](https://activecollab.com/) API. Provides a
clean interface for authentication, project management, task tracking, time
records, and more.

## Requirements

- Ruby >= 3.1
- An ActiveCollab account with API access

## Installation

Add to your Gemfile:

```ruby
gem 'active_collab-ruby-sdk', '~> 0.3'
```

Or install directly:

```
gem install active_collab-ruby-sdk
```

## Authentication

The SDK supports two authentication methods.

### Token-based (if you already have a token)

```ruby
require 'active_collab'

client = ActiveCollab::Client.new(
  account_id: '12345',
  token: 'your-api-token'
)
```

### Credential-based (username/password)

```ruby
client = ActiveCollab::Client.new(
  account_id: '12345',
  username: 'user@example.com',
  password: 'your-password',
  client_vendor: 'YourCompany',
  client_name: 'YourApp'
)

# Authenticates and stores the token on the client
client.request_token!
```

The token is stored on the client instance and sent as the
`X-Angie-AuthApiToken` header on all subsequent requests.

## Usage

### Projects

```ruby
# List all projects (returns a Hash by default)
projects = client.projects.all

# Get projects as a JSON string
json = client.projects.all(format: 'json')

# Get projects as an OpenStruct
projects = client.projects.all(format: 'object')
```

### Tasks

```ruby
tasks = client.projects.tasks(project_id)

# All tasks (active + archived, sorted by created_on desc)
all = tasks.all

# Active tasks only
active = tasks.active

# Archived tasks (auto-paginates through all pages)
archived = tasks.archived

# Archived tasks for a specific page (no auto-pagination)
page2 = tasks.archived('page' => 2)

# Find a single task
task = tasks.find(task_id)

# Update a task
tasks.update(task_id, name: 'New name')

# Time records for a specific task
records = tasks.time_records(task_id)
```

### Task Lists

```ruby
task_lists = client.projects.task_lists(project_id).all
```

### Time Records

```ruby
time_records = client.projects.time_records(project_id)

# List all time records for a project
records = time_records.all

# Create a new time record
time_records.create(value: 1.5, user_id: 10, job_type_id: 1)
```

### Users

_The Users resource is available as `ActiveCollab::Users` but is not yet
exposed as a convenience method on the client. Use the class directly:_

```ruby
users = ActiveCollab::Users.new(client).all
```

### Response Formats

All resource methods accept a `format` parameter:

| Format     | Return type | Description                  |
|------------|-------------|------------------------------|
| `'hash'`   | `Hash`      | Parsed JSON (default)        |
| `'json'`   | `String`    | Raw JSON response body       |
| `'object'` | `OpenStruct`| Parsed JSON as OpenStruct    |

```ruby
client.projects.all(format: 'json')   # => '{"projects": [...]}'
client.projects.all(format: 'object') # => #<OpenStruct projects=[...]>
```

### Token Object

```ruby
token = client.token
token.value        # => "your-api-token"
token.auth_header  # => { "X-Angie-AuthApiToken": "your-api-token" }
```

### URL Helpers

```ruby
# Build an app URL (for linking to the ActiveCollab web UI)
client.app_url('/projects/3') # => URI("https://next-app.activecollab.com/12345/projects/3")
```

## Error Handling

The SDK raises specific exceptions for API errors:

```ruby
begin
  client.projects.all
rescue ActiveCollab::AuthenticationError => e
  # 401 - invalid or expired token
  puts e.message # => "API request failed with status 401"
  puts e.status  # => 401
  puts e.body    # => raw response body
rescue ActiveCollab::NotFoundError => e
  # 404
rescue ActiveCollab::RateLimitError => e
  # 429
rescue ActiveCollab::APIError => e
  # Any other 4xx/5xx
rescue ActiveCollab::ParseError => e
  # Response body was not valid JSON
  puts e.body # => the raw unparseable body
end
```

Exception hierarchy:

```
ActiveCollab::Error
  ActiveCollab::APIError          (has #status and #body)
    ActiveCollab::AuthenticationError
    ActiveCollab::NotFoundError
    ActiveCollab::RateLimitError
  ActiveCollab::ParseError        (has #body)
```

## Development

```
git clone https://github.com/davelens/active_collab-ruby-sdk.git
cd active_collab-ruby-sdk
bundle install
bundle exec rake     # runs the test suite
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -am 'Add my feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Create a Pull Request

## License

Released under the [MIT License](LICENSE).
