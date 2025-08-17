module SqlExplain
  class Railtie < ::Rails::Railtie
    initializer "sql_explain.configure_middleware" do |app|
      app.middleware.use Scanner
    end
  end
end
