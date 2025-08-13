class ExplainsController < ApplicationController
  def show
    # doc = Nokogiri::HTML(File.read("/home/catalin/play/sql_explain/app/views/explains/index.html"))
    page = Ferrum::Browser.new(headless: false, js_errors: true )
    #page.goto("file:///home/catalin/play/sql_explain/app/views/explains/index.html")
    page.goto("https://explain.dalibo.com/")

    el = page.at_css("#planInput")
    el.focus.type(content.to_json)
    button = page.at_css("button[type='submit']")
    button.click
    #new_content = page.at_css('#app')
    #html = new_content.evaluate('this.innerHTML')
    plan_link = page.at_xpath('/html/body/div/header/nav/span[2]/a')
#    html = page.body
    #
    sleep(0.5)
    dialog = page.at_css('div.modal-dialog')
    if dialog.present?
      page.at_css('#dontAskAgain').click
      page.at_xpath('/html/body/main/div/div[4]/div/div/div[3]/button[2]').click
    end

    url = page.current_url
    page.quit

    redirect_to url, allow_other_host: true
  end

  def content
    [
      {
        "Plan": {
          "Node Type": "Seq Scan",
          "Parallel Aware": false,
          "Async Capable": false,
          "Relation Name": "users",
          "Schema": "public",
          "Alias": "users",
          "Startup Cost": 0.00,
          "Total Cost": 19.70,
          "Plan Rows": 970,
          "Plan Width": 56,
          "Actual Startup Time": 0.002,
          "Actual Total Time": 0.003,
          "Actual Rows": 3,
          "Actual Loops": 1,
          "Output": [ "id", "name", "created_at", "updated_at" ],
          "Shared Hit Blocks": 1,
          "Shared Read Blocks": 0,
          "Shared Dirtied Blocks": 0,
          "Shared Written Blocks": 0,
          "Local Hit Blocks": 0,
          "Local Read Blocks": 0,
          "Local Dirtied Blocks": 0,
          "Local Written Blocks": 0,
          "Temp Read Blocks": 0,
          "Temp Written Blocks": 0
        },
        "Query Identifier": -8627630264452254514,
        "Planning": {
          "Shared Hit Blocks": 65,
          "Shared Read Blocks": 0,
          "Shared Dirtied Blocks": 0,
          "Shared Written Blocks": 0,
          "Local Hit Blocks": 0,
          "Local Read Blocks": 0,
          "Local Dirtied Blocks": 0,
          "Local Written Blocks": 0,
          "Temp Read Blocks": 0,
          "Temp Written Blocks": 0
        },
        "Planning Time": 0.172,
        "Triggers": [],
        "Execution Time": 0.021
      }
    ]
  end
end
