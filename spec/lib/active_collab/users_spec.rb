# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveCollab::Users do
  let(:client) { instance_double(ActiveCollab::Client) }

  subject { described_class.new(client) }

  describe '#all' do
    it 'fetches all users' do
      expect(client).to receive(:get).with('/users')
      subject.all
    end
  end
end
