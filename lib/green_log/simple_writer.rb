# frozen_string_literal: true

require "green_log/entry"
require "green_log/severity"

module GreenLog

  # A simple log formatter, aimed at humans.
  class SimpleWriter

    def initialize(dest)
      @dest = dest
    end

    attr_reader :dest

    def <<(entry)
      raise ArgumentError, "GreenLog::Entry expected" unless entry.is_a?(GreenLog::Entry)

      output = [
        format_part(entry, :severity),
        format_part(entry, :context),
        "--",
        format_part(entry, :message),
        format_part(entry, :data),
      ].compact.join(" ") + "\n"

      output << format_exception(entry.exception)

      dest << output
    end

    protected

    def format_part(entry, part)
      value = entry.public_send(part)
      return nil if value.nil?

      send("format_#{part}", value)
    end

    def format_severity(severity)
      Severity.name(severity)[0].upcase
    end

    def format_data(data)
      return nil if data.empty?

      "[" + each_part_of(data).to_a.join(" ") + "]"
    end

    alias format_context format_data

    def format_message(message)
      message
    end

    def format_exception(exception)
      return "" if exception.nil?

      result = "  ! #{exception.class.name}: #{exception.message}\n"
      exception.backtrace.each do |line|
        result += "    #{line}\n"
      end
      result
    end

    private

    def each_part_of(data, prefix = nil, &block)
      return enum_for(:each_part_of, data, prefix) unless block_given?

      data.each do |k, v|
        label = [prefix, k].compact.join(".")
        if v.is_a?(Hash)
          each_part_of(v, label, &block)
        else
          yield "#{label}=#{v.inspect}"
        end
      end
    end

  end

end
