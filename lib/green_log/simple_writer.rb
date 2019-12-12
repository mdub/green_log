module GreenLog

  class SimpleWriter

    def initialize(io)
      @io = io
    end

    def call(entry)
      @io << [
        entry.severity.to_s[0].upcase,
        "--",
        (entry.message.to_str if entry.message),
      ].compact.join(" ") + "\n"
    end

  end

end
