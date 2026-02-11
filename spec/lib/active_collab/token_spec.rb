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

  describe '#header' do
    it 'returns a hash with the auth header' do
      expect(subject.header).to eq({ 'X-Angie-Authapitoken': token_value })
    end
  end

  describe '#raw' do
    it 'returns the token value' do
      expect(subject.raw).to eq(token_value)
    end
  end
end
