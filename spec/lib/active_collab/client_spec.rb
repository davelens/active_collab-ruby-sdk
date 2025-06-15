require 'spec_helper'

RSpec.describe ActiveCollab::Client do

  let(:account_id) { '1337' }
  let(:token_value) { 'foobar123' }
  let(:options) do
    {
      username: 'test@example.com',
      password: 'password123',
      client_vendor: 'MyVendor',
      client_name: 'MyApp',
      account_id: account_id,
      token: token_value
    }
  end

  subject { described_class.new(options) }

  describe '#app_url' do
    it 'can build a legit endpoint URL' do
      uri = subject.app_url('/projects')
      expect(uri.to_s).to eq("https://next-app.activecollab.com/#{account_id}/projects")
    end
  end

  describe '#call_url' do
    it 'can build a legit endpoint for external logins' do
      uri = subject.call_url('/external/login')
      expect(uri.to_s).to eq("https://activecollab.com/api/v1/external/login")
    end

    it 'can build a legit endpoint for regular calls' do
      uri = subject.call_url('/projects')
      expect(uri.to_s).to eq("https://app.activecollab.com/#{account_id}/api/v1/projects")
    end
  end

  describe '#call' do
    let(:response_double) do
      instance_double(Net::HTTPResponse, body: '{"success": true}')
    end

    before do
      allow(Net::HTTP).to receive(:start) { response_double }
      allow(ActiveCollab::Response).to receive(:new) do
        double(to_hash: { success: true })
      end
    end

    it 'can make a HTTP call and parses the response' do
      result = subject.call('Get', URI('https://example.com/test'))
      expect(result).to eq({ success: true })
    end
  end

  describe '#request_token!' do
    it 'can request a token' do
      allow(subject).to(
        receive(:post)
          .with('/external/login', any_args)
          .and_return({ 'intent' => 'foobar' })
      )

      allow(ActiveCollab::LoginResponse).to(
        receive(:new).and_return(double(intent: 'foobar'))
      )

      allow(subject).to(
        receive(:post)
          .with('/issue-token-intent', any_args)
          .and_return({ 'token' => token_value })
      )

      allow(ActiveCollab::Token).to(
        receive(:new).and_return(double(value: token_value))
      )

      expect(subject.request_token!).to eq(token_value)
    end
  end

  describe '#token' do
    it 'can return a token object' do
      token_double = double
      allow(ActiveCollab::Token).to receive(:new).with(token_value) { token_double }
      expect(subject.token).to eq(token_double)
    end
  end

  it 'makes a few namespaces available' do
    expect(subject).to respond_to(*%I[projects time_records])
  end

end
