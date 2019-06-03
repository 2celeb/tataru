require 'tataru'
require 'tataru/core'
require 'thor'

module Tataru
  class CLI < Thor
    desc "create_choseisan", "調整さんURLの作成"
    def create_choseisan
      tataru = Tataru::Core.new
      tataru.post_choseisan
    end

    desc "complete_announcement", "調整さんURL入力確認"
    def complete_announcement
      tataru = Tataru::Core.new
      tataru.announcement_all_member_complete
    end

    desc "target_week_date_key", "調整さんURL入力確認"
    def target_week_date_key
      tataru = Tataru::Core.new
      puts tataru.target_week_date_key
    end
  end
end