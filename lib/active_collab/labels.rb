# frozen_string_literal: true

# Provides access to label-related API endpoints.
#
# Supports both task labels and project labels through a unified interface.
# Label types share CRUD endpoints but are listed separately.
class ActiveCollab::Labels
  TYPES = %w[task-labels project-labels].freeze

  # @param client [ActiveCollab::Client]
  def initialize(client)
    @client = client
  end

  # Lists all labels of the given type.
  #
  # @param type [String] 'task-labels' or 'project-labels'
  # @param params [Hash] query parameters
  # @option params [String] :format response format ('hash', 'json', or 'object')
  # @return [Hash, String, OpenStruct]
  # @raise [ArgumentError] if type is not a valid label type
  def all(type, params = {})
    unless TYPES.include?(type)
      raise ArgumentError, "type must be one of: #{TYPES.join(', ')}"
    end

    @client.get("/labels/#{type}", params)
  end

  # Fetches a single label by ID.
  #
  # @param id [Integer, String] the label ID
  # @param params [Hash] query parameters
  # @return [Hash, String, OpenStruct]
  def find(id, params = {})
    @client.get("/labels/#{id}", params)
  end

  # Creates a new label.
  #
  # @param params [Hash] label attributes
  # @option params [String] :type label class ('TaskLabel' or 'ProjectLabel')
  # @option params [String] :name label name
  # @return [Hash, String, OpenStruct]
  def create(params = {})
    @client.post('/labels', params)
  end

  # Updates an existing label.
  #
  # @param id [Integer, String] the label ID
  # @param params [Hash] attributes to update
  # @return [Hash, String, OpenStruct]
  def update(id, params = {})
    @client.put("/labels/#{id}", params)
  end

  # Deletes a label.
  #
  # @param id [Integer, String] the label ID
  # @param params [Hash] query parameters
  # @return [Hash, String, OpenStruct]
  def delete(id, params = {})
    @client.delete("/labels/#{id}", params)
  end

  # Reorders labels by providing an ordered array of label IDs.
  #
  # @param ids [Array<Integer>] ordered list of label IDs
  # @return [Hash, String, OpenStruct]
  def reorder(ids)
    @client.put('/labels/reorder', ids)
  end
end
