require 'rspec_request_helpers/version'
require 'rspec_request_helpers/configuration'
require 'rspec_request_helpers/helpers'
require 'rack'
require 'pry'

module RspecRequestHelpers
  SYMBOL_TO_STATUS_CODE = Rack::Utils::SYMBOL_TO_STATUS_CODE
  STATUS_CODE_TO_SYMBOL =
    SYMBOL_TO_STATUS_CODE.inject({}) do |hash, (symbol, code)|
      hash[code] = symbol
      hash
    end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
    Helpers.regenerate_helpers
  end

  def self.included(receiver)
    Helpers.generate_helpers
    receiver.send :include, Helpers
  end
end

