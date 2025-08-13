require "semantic_logger"

class CustomLogFormatter < SemanticLogger::Formatters::Raw
  def call(log, logger)
    super

    if hash[:name] == "ActiveRecord" && hash[:payload][:sql].present?
      puts "TRANSPIMT"
      puts "TRANSPIMT"
      puts "TRANSPIMT"
      puts "TRANSPIMT"
      puts "TRANSPIMT"
      puts "TRANSPIMT"
      puts "TRANSPIMT"
      # Turbo::StreamsChannel.broadcast_prepend_to(
      #   "content",
      # #  html: "<h1>#{hash[:payload][:sql]}</h1>".html_safe,
      #   content: hash[:payload][:sql].to_s,
      #   target: "what"
      # )

      #Turbo::StreamsChannel.broadcast_prepend_to("content", content: hash[:payload][:sql].to_s, target: "what")
    end

    hash.to_json
  end
end
