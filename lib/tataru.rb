require "tataru/version"
require "uri"
require "dotenv"
require "mechanize"
require "active_support"
require "active_support/core_ext"
require "json"
require "faraday"
require "aws-sdk"

module Tataru
  class Error < StandardError; end

  autoload :CLI, "tataru/cli"
end
