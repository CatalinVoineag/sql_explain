module SqlExplain
  class QueriesController < ApplicationController
    before_action :set_query

    def show
      page = Ferrum::Browser.new(headless: false, js_errors: true)
      page.goto("https://explain.dalibo.com/")

      el = page.at_css("#planInput")
      el.focus.type(content.to_json)
      query_field = page.at_css("#queryInput")
      query_field.focus.type(query)

      button = page.at_css("button[type='submit']")
      button.click
      sleep(0.5)
      dialog = page.at_css("div.modal-dialog")
      if dialog.present?
        page.at_css("#dontAskAgain").click
        page.at_xpath("/html/body/main/div/div[4]/div/div/div[3]/button[2]").click
      end

      url = page.current_url
      page.quit

      redirect_to url, allow_other_host: true
    end

  private

    def set_query
      @query ||= params.require(:query)
    end

    def content
      result = nil

      ActiveRecord::Base.connection.transaction do
        result = ActiveRecord::Base.connection.execute(
          <<~SQL,
          EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
          #{query}
          SQL
          "SQL_EXPLAIN_GEM",
        )
        raise ActiveRecord::Rollback
      end
      raise "Result is nil" if result.nil?

      JSON.parse(result.column_values(0).first)
    end
  end
end
