# frozen_string_literal: true

class ActiveCollab::Token
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def header
    {
      'X-Angie-Authapitoken': @value
    }
  end

  def raw
    @value
  end
end
