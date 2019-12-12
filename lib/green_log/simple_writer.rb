module GreenLog

  class SimpleWriter

    def initialize(io)
      @io = io
    end

    def call(entry)
      @io << entry.message.to_str.inspect + "\n"
    end

  end

end
