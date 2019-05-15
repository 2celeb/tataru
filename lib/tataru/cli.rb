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
  end
end