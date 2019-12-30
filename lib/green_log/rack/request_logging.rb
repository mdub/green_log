# frozen_string_literal: true

require "rack"

module GreenLog

  module Rack

    # Structured request logging.
    class RequestLogging

      def initialize(app, logger)
        @app = app
        @logger = logger
      end

      def call(env)
        started_at = Time.now
        status, headers, _body = @app.call(env)
      ensure
        status ||= 500
        headers ||= {}
        duration = Time.now - started_at
        log(
          request: ::Rack::Request.new(env),
          response: Response.new(status, headers, duration),
        )
      end

      Response = Struct.new(:status, :headers, :duration)

      protected

      attr_reader :logger

      def log(request:, response:)
        logger.info(
          "#{request.request_method} #{request.path} #{response.status}",
          request: request_details(request: request),
          response: response_details(response: response),
        )
      end

      def request_details(request:)
        {
          method: request.request_method,
          scheme: request.scheme,
          host: request.host,
          path: request.path,
          query: request.query_string,
          remote_user: request.env["REMOTE_USER"],
          remote_addr: request.ip,
        }
      end

      def response_details(response:)
        {
          status: response.status.to_i,
          length: response.headers["Content-Length"].to_i,
          duration: response.duration.round(3),
        }
      end

    end

  end

end
