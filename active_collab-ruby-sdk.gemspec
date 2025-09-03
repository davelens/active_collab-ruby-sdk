# frozen_string_literal: true

require_relative 'lib/active_collab'

Gem::Specification.new do |spec|
  spec.name          = 'active_collab-ruby-sdk'
  spec.version       = ActiveCollab::VERSION
  spec.authors       = ['Dave Lens']
  spec.email         = ['github@davelens.be']

  spec.summary       = 'Ruby SDK for Active Collab API'
  spec.description   = 'A basic Ruby SDK to interact with the Active Collab API.'
  spec.homepage      = 'https://github.com/davelens/active_collab-ruby-sdk'
  spec.license       = 'MIT'

  # Files to include in the gem
  spec.files         = Dir.glob('lib/**/*.rb') + %w[README.md LICENSE]
  spec.require_paths = ['lib']

  # Ruby version requirement (optional but recommended)
  spec.required_ruby_version = '>= 3.1'

  # Runtime dependencies (add if needed)
  spec.add_runtime_dependency 'json', '~> 2.12.2'
  spec.add_runtime_dependency 'activesupport', '~> 7'

  # Development dependencies (optional)
  spec.add_development_dependency 'rspec', '~> 3.13.1'
  spec.add_development_dependency 'irb', '~> 1.15.2'
end
