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

  spec.metadata = {
    'homepage_uri'          => spec.homepage,
    'source_code_uri'       => spec.homepage,
    'changelog_uri'         => "#{spec.homepage}/blob/master/CHANGELOG.md",
    'rubygems_mfa_required' => 'true'
  }

  spec.files         = Dir.glob('lib/**/*.rb') + %w[README.md LICENSE CHANGELOG.md]
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.1'

  spec.add_runtime_dependency 'json', '~> 2.10'
  spec.add_runtime_dependency 'ostruct', '>= 0'
  spec.add_runtime_dependency 'activesupport', '>= 7', '< 9'
end
