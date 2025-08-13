class SqlCollectorMiddleware
  def initialize(app); @app = app; end

  def call(env)
    collector = ActiveSupport::Notifications.subscribe("sql.active_record") do |*, payload|
      next if payload[:name] == "SCHEMA"
      Thread.current[:sql_log] ||= []
      Thread.current[:sql_log] << { sql: payload[:sql], name: payload[:name] }
    end

    status, headers, response = @app.call(env)
    ActiveSupport::Notifications.unsubscribe(collector)
    logs = Thread.current[:sql_log]

    if logs.present?
      request_id = env["action_dispatch.request_id"] || SecureRandom.uuid
      file = Rails.root.join("log", "sql_explain.log")

      File.open(file, "a") do |f|
        f.write "#{request_id} => #{logs.map { |log| log[:sql] }}"
      end
    end

    Thread.current[:sql_log] = nil

    [ status, headers, response ]
  end
end
