module SqlExplain
  class Scanner
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Context
    include ActionView::Helpers::UrlHelper

    def initialize(app); @app = app; end

    def call(env)
      collector = ActiveSupport::Notifications.subscribe("sql.active_record") do |*, payload|
        next if payload[:name] == "SCHEMA" || payload[:name] == "SQL_EXPLAIN_GEM"

        Thread.current[:sql_log] ||= []
        Thread.current[:sql_log] << { sql: payload[:sql] }
      end

      status, headers, response = @app.call(env)
      ActiveSupport::Notifications.unsubscribe(collector)
      logs = Thread.current[:sql_log]

      # THIS WOULD ONLY RUN IN DEVELOPMENT
      # To verify the request, encrypt the sql query. Then decrypt it using the master key and if they match it's secure?
      # OR pass a request ID and encrypt it and if those match its secure?

      Thread.current[:sql_log] = nil

      response_body = nil

      if logs.present?
        response_body = inject_content(response_body(response), logs)
      end

      [ status, headers, response_body ? [ response_body ] : response ]
    end

    private

    def inject_content(response_body, logs)
      body = response_body.dup

      content = content_tag(:ul) do
        logs.each do |log|
          concat content_tag(
            :li,
            link_to(
              log[:sql],
              SqlExplain::Engine.routes.url_helpers.query_path(query: log[:sql]),
              target: "_blank",
            ),
          )
        end
      end.html_safe

      if body.include?("<body>")
        position = body.rindex("<body>")
        body.insert(position, content)
      else
        body << content
      end
    end

    def response_body(response)
      if response.respond_to?(:body)
        Array === response.body ? response.body.first : response.body
      elsif response.respond_to?(:first)
        response.first
      end
    end
  end
end
