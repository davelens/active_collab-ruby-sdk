# frozen_string_literal: true

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

  describe '#get' do
    it 'delegates to #call with Get' do
      expect(subject).to receive(:call).with('Get', kind_of(URI), {})
      subject.get('/projects')
    end
  end

  describe '#post' do
    it 'delegates to #call with Post' do
      expect(subject).to receive(:call).with('Post', kind_of(URI), {})
      subject.post('/projects')
    end
  end

  describe '#put' do
    it 'delegates to #call with Put' do
      expect(subject).to receive(:call).with('Put', kind_of(URI), {})
      subject.put('/projects')
    end
  end

  describe '#call' do
    let(:response_double) do
      instance_double(Net::HTTPResponse, body: '{"success": true}', code: '200')
    end

    before do
      allow(Net::HTTP).to receive(:start) { response_double }
    end

    it 'defaults to Get for unsupported method' do
      allow(ActiveCollab::Response).to receive(:new) do
        double(to_hash: { success: true })
      end
      result = subject.call('Delete', URI('https://example.com/test'))
      expect(result).to eq({ success: true })
    end

    it 'does not set token header if @token is nil' do
      subject.instance_variable_set(:@token, nil)
      uri_double = double(hostname: 'example.com', port: 443, scheme: 'https')
      request_double = double(uri: uri_double)
      allow(Object).to receive(:const_get).and_return(double(new: request_double))
      allow(request_double).to receive(:set_form_data)
      allow(Net::HTTP).to receive(:start) { double(body: '{}', code: '200') }
      allow(ActiveCollab::Response).to receive(:new) { double(to_hash: {}) }
      expect(request_double).not_to receive(:[]=)
      subject.call('Post', URI('https://example.com/test'))
    end

    it 'can make a HTTP call and parses the response with a hash by default' do
      allow(ActiveCollab::Response).to receive(:new) do
        double(to_hash: { success: true })
      end

      result = subject.call('Get', URI('https://example.com/test'))
      expect(result).to eq({ success: true })
    end

    it 'can make a HTTP call and parses the response as json when chosen' do
      allow(ActiveCollab::Response).to receive(:new) do
        double(to_json_string: { success: true })
      end

      result = subject.call('Get', URI('https://example.com/test'), format: 'json')
      expect(result).to eq({ success: true })
    end

    it 'can make a HTTP call and parses the response as object when chosen' do
      allow(ActiveCollab::Response).to receive(:new) do
        double(to_object: { success: true })
      end

      result = subject.call('Get', URI('https://example.com/test'), format: 'object')
      expect(result).to eq({ success: true })
    end

    it 'defaults the response to a hash when given an unknown format' do
      allow(ActiveCollab::Response).to receive(:new) do
        double(to_hash: { success: true })
      end

      result = subject.call('Get', URI('https://example.com/test'), format: 'xml')
      expect(result).to eq({ success: true })
    end

    context 'error handling' do
      it 'raises AuthenticationError on 401' do
        allow(Net::HTTP).to receive(:start) { double(body: 'Unauthorized', code: '401') }
        expect {
          subject.call('Get', URI('https://example.com/test'))
        }.to raise_error(ActiveCollab::AuthenticationError) { |e|
          expect(e.status).to eq(401)
          expect(e.body).to eq('Unauthorized')
        }
      end

      it 'raises NotFoundError on 404' do
        allow(Net::HTTP).to receive(:start) { double(body: 'Not Found', code: '404') }
        expect {
          subject.call('Get', URI('https://example.com/test'))
        }.to raise_error(ActiveCollab::NotFoundError)
      end

      it 'raises RateLimitError on 429' do
        allow(Net::HTTP).to receive(:start) { double(body: 'Too Many Requests', code: '429') }
        expect {
          subject.call('Get', URI('https://example.com/test'))
        }.to raise_error(ActiveCollab::RateLimitError)
      end

      it 'raises APIError on other 4xx/5xx statuses' do
        allow(Net::HTTP).to receive(:start) { double(body: 'Server Error', code: '500') }
        expect {
          subject.call('Get', URI('https://example.com/test'))
        }.to raise_error(ActiveCollab::APIError) { |e|
          expect(e.status).to eq(500)
        }
      end

      it 'does not raise on successful responses' do
        allow(ActiveCollab::Response).to receive(:new) { double(to_hash: {}) }
        expect {
          subject.call('Get', URI('https://example.com/test'))
        }.not_to raise_error
      end
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
    expect(subject).to respond_to(*%I[projects])
  end

end
