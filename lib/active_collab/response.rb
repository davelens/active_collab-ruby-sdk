class ActiveCollab::Response
  attr_reader :raw_body

  def initialize(raw_body)
    @raw_body = raw_body
    @raw_body = '{}' if raw_body == '' || raw_body.nil?
  end

  def to_json
    @raw_body
  end

  def to_hash
    JSON.parse(@raw_body)
  end

  def to_object
    OpenStruct.new(to_hash)
  end
end
