require "barley/version"
require "barley/railtie"
require "barley/configuration"
require "dry-types"

module Barley
  mattr_accessor :config

  self.config = Configuration.new

  def self.configure
    self.config ||= Configuration.new
    yield(config)
  end

  autoload :Cache, "barley/cache"
  autoload :Error, "barley/error"
  autoload :InvalidAttributeError, "barley/error"
  autoload :Serializable, "barley/serializable"
  autoload :Serializer, "barley/serializer"
end
