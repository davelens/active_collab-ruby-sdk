# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/to_query'

module ActiveCollab
  require_relative 'active_collab/version'
  require_relative 'active_collab/client'
  require_relative 'active_collab/response'
  require_relative 'active_collab/login_response'
  require_relative 'active_collab/token'
  require_relative 'active_collab/projects'
  require_relative 'active_collab/projects/task_lists'
  require_relative 'active_collab/projects/tasks'
  require_relative 'active_collab/time_records'
  require_relative 'active_collab/users'
end
