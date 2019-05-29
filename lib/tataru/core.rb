module Tataru
  class Core
    UA = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, lik｀e Gecko) Chrome/47.0.2526.106 Safari/537.36"
    def initialize
      Dotenv.load
      @agent = Mechanize.new
      @agent.user_agent = UA
      @table = Aws::DynamoDB::Resource.new.table("discord_ff14")
    end

    def post_choseisan
      url = create_choseisan_url
      current_week_date_key
      @table.put_item(item: { date_key: next_week_date_key, url: url } )
      mention = ENV['DISCORD_CHOUSEISAN_MENTION_ID'] ? "@#{ENV['DISCORD_CHOUSEISAN_MENTION_ID']} " : ""
      conn = Faraday.new
      conn.post do |req|
        req.url ENV['DISCORD_INCOMMING_URL']
        req.headers['Content-Type'] = 'application/json'
        req.body = {content: "#{mention}来週の調整さんのURLでっす\n#{url}"}.to_json
      end
    end

    def announcement_all_member_complete
      url = get_choseisan_url
      num = complete_member_number(url)
      puts "調整さんURL = #{url}"
      puts "入力済み人数 = #{num}"

      announcement = false
      if num >= 8
        announcement = true
        mention = ENV['DISCORD_COMPLETE_MENTION_ID'] ? "<@#{ENV['DISCORD_COMPLETE_MENTION_ID']}> " : ""
        conn = Faraday.new
        conn.post do |req|
          req.url ENV['DISCORD_INCOMMING_URL']
          req.headers['Content-Type'] = 'application/json'
          req.body = {content: "#{mention}全員の入力が終わりましたでっす"}.to_json
        end
      end
      announcement
    end

    def target_week_date_key
      Time.now.wday > 2 ? next_week_date_key : current_week_date_key
    end

    private
    def current_week_date_key
      Date.today.beginning_of_week.to_s
    end

    def next_week_date_key
      (Date.today.beginning_of_week + 7.day).to_s
    end

    def get_choseisan_url
      item_output = @table.get_item(key: {date_key: target_week_date_key})
      if item_output
        item_output.item["url"]
      end
    end

    def create_choseisan_url
      page = @agent.get('https://chouseisan.com/')
      form = page.forms[0]
      form["name"] = "絶アルテマスケジュール調整"
      form.comment = "金土日何時までできるかコメ欄にお願いします。\n例 金土日 454"
      wday_strings = %w(日 月 火 水 木 金 土)
      # ヒカセンの週の開始は火曜日から
      start_date = (Date.today + 7).beginning_of_week - 1.week + 1.day
      #start_date = (Date.today + 7).beginning_of_week + 1.day
      form.kouho =  (start_date..(start_date + 6)).map {|d| "%02d/%02d(%s) 25:00 〜" % [d.month, d.day, wday_strings[d.wday]]}.join("\n")
      button = form.button_with(id: 'createBtn')
      result_page = @agent.submit(form, button)
      uri = URI::parse(result_page.uri.to_s)
      uri_params = Hash[URI::decode_www_form(uri.query)]
      "https://chouseisan.com/s?h=#{uri_params['h']}"
    end

    def complete_announcement?
      # dynamodbにアナウンス状況を確認する
    end
    def complete_member_number(url)
      page = @agent.get(url)
      p page
      #p page.title
      n = page.search('*[@id="nittei"]').first.search("a").size
      p n
    end
  end
end