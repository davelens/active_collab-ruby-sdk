# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveCollab::Token do
  let(:token_value) { 'test-token-abc123' }

  subject { described_class.new(token_value) }

  describe '#value' do
    it 'returns the token value' do
      expect(subject.value).to eq(token_value)
    end
  end

  describe '#auth_header' do
    it 'returns a hash with the auth header' do
      expect(subject.auth_header).to eq({ 'X-Angie-AuthApiToken': token_value })
    end
  end
end
