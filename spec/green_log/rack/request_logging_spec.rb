# frozen_string_literal: true

require "green_log/logger"
require "green_log/rack/request_logging"

RSpec.describe GreenLog::Rack::RequestLogging do

  let(:entries) { [] }

  subject(:logger) { GreenLog::Logger.new(entries) }

  subject(:middleware) { described_class.new(app, logger) }

  let(:ip) { "123.456.789.001" }
  let(:user_name) { "Robert" }
  let(:request_host) { "api.example.com" }
  let(:request_method) { "GET" }
  let(:request_path) { "/whoami" }
  let(:request_scheme) { "https" }
  let(:request_body) { "" }
  let(:request_input_stream) { StringIO.new(request_body) }

  let(:request_env) do
    {
      "HTTP_HOST" => request_host,
      "HTTP_X_FORWARDED_PROTO" => request_scheme,
      "PATH_INFO" => request_path,
      "QUERY_STRING" => "",
      "REMOTE_ADDR" => ip,
      "REMOTE_USER" => user_name,
      "REQUEST_METHOD" => request_method,
      "rack.input" => request_input_stream,
    }
  end

  let(:response_status) { 200 }

  let(:app) do
    lambda do |env|
      visitor = env.fetch("REMOTE_USER", "stranger")
      message = "Hello, #{visitor}\n"
      [response_status, { "Content-Length" => message.length }, [message]]
    end
  end

  def make_request
    middleware.call(request_env)
  end

  describe "#call" do

    context "usually" do

      before { make_request }

      it "includes basics details in log message" do
        expect(entries.last.message).to eq("#{request_method} #{request_path} #{response_status}")
      end

      it "includes request details" do
        expect(entries.last.data).to include(
          request: hash_including(
            remote_addr: ip,
            remote_user: user_name,
            method: request_method,
            scheme: request_scheme,
            host: request_host,
            path: request_path,
            query: "",
          ),
        )
      end

      it "excludes request body" do
        expect(entries.last.data).not_to include(
          request: hash_including(:body),
        )
      end

      it "includes response details" do
        expect(entries.last.data).to include(
          response: hash_including(
            status: response_status,
            length: Integer,
            duration: Float,
          ),
        )
      end

    end

    context "when app raises an exception" do

      let(:app) do
        lambda do |_env|
          raise "HELL"
        end
      end

      before do
        expect { make_request }.to raise_error("HELL")
      end

      it "still logs request details" do
        expect(entries.last.data).to include(
          request: hash_including(
            method: request_method,
            scheme: request_scheme,
            host: request_host,
            path: request_path,
          ),
        )
      end

      it "assumes status 500" do
        expect(entries.last.data).to include(
          response: hash_including(
            status: 500,
          ),
        )
      end

    end

    context "when log_request_bodies is enabled" do

      subject(:middleware) { described_class.new(app, logger, log_request_bodies: true) }

      let(:request_method) { "POST" }
      let(:request_body) { "foobar" }
      let(:bytes_read) { 3 }

      before do
        request_input_stream.read(bytes_read)
        make_request
      end

      it "includes request body" do
        expect(entries.last.data).to include(
          request: hash_including(
            body: request_body,
          ),
        )
      end

      it "leaves body pointer at original position" do
        expect(request_input_stream.pos).to eq(bytes_read)
      end

    end

  end

end
