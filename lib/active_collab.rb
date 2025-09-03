require 'json'
require 'net/http'
require 'uri'
require 'active_support/all'

module ActiveCollab
  VERSION = '0.2.2'

  require_relative 'active_collab/client.rb'
  require_relative 'active_collab/response.rb'
  require_relative 'active_collab/login_response.rb'
  require_relative 'active_collab/token.rb'
  require_relative 'active_collab/projects.rb'
  require_relative 'active_collab/projects/task_lists.rb'
  require_relative 'active_collab/projects/tasks.rb'
  require_relative 'active_collab/time_records.rb'
  require_relative 'active_collab/users.rb'
end
