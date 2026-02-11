# frozen_string_literal: true

require_relative 'lib/active_collab/version'

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

  # Runtime dependencies
  spec.add_runtime_dependency 'json', '~> 2.18'
  spec.add_runtime_dependency 'activesupport', '>= 7', '< 9'
end
