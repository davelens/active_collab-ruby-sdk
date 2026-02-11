# frozen_string_literal: true

require 'spec_helper'
require 'ostruct'

RSpec.describe ActiveCollab::Response do
  describe '#initialize' do
    it 'stores the raw body' do
      json = '{"key":"value"}'
      expect(described_class.new(json).raw_body).to eq(json)
    end

  end

  describe '#raw_body' do
    it 'defaults to empty JSON if body is nil' do
      response = described_class.new(nil)
      expect(response.raw_body).to eq('{}')
    end

    it 'defaults to empty JSON if body is empty string' do
      response = described_class.new('')
      expect(response.raw_body).to eq('{}')
    end
  end

  describe '#to_json_string' do
    it 'returns the raw JSON string' do
      response = described_class.new('{"foo":"bar"}')
      expect(response.to_json_string).to eq('{"foo":"bar"}')
    end

    it 'returns empty JSON object string when body was nil' do
      response = described_class.new(nil)
      expect(response.to_json_string).to eq('{}')
    end
  end

  describe '#to_hash' do
    it 'defaults to an empty hash' do
      response = described_class.new(nil)
      expect(response.to_hash).to eq({})
    end

    it 'can parse valid JSON into a hash' do
      response = described_class.new('{"foo":"bar"}')
      expect(response.to_hash).to eq({ 'foo' => 'bar' })
    end

    it 'raises ParseError on invalid JSON' do
      response = described_class.new('<html>Error</html>')
      expect { response.to_hash }.to raise_error(ActiveCollab::ParseError) { |e|
        expect(e.body).to eq('<html>Error</html>')
      }
    end
  end

  describe '#to_object' do
    it 'returns an OpenStruct with parsed data' do
      response = described_class.new('{"foo":"bar"}')
      expect(response.to_object.foo).to eq('bar')
    end

    it 'returns an empty OpenStruct if body is empty' do
      response = described_class.new('')
      expect(response.to_object.to_h).to eq({})
    end
  end
end
