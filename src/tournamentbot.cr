require "yaml"
require "discordcr"
require "discordcr-plugin"
require "discordcr-middleware"
require "discordcr-middleware/middleware/prefix"

require "./plugins/*"
require "./middlewares/*"
require "./tournaments/*"

module TournamentBot
  class Bot
    getter client : Discord::Client
    getter cache : Discord::Cache
    delegate run,  to: client
    delegate stop, to: client

    def initialize
      @client = Discord::Client.new(token: "Bot #{AUTH["token"].as_s}", client_id: CLIENT_ID)
      @cache = Discord::Cache.new(@client)
      @client.cache = @cache
      register_plugins
    end

    def register_plugins
      Discord::Plugin.plugins.each { |plugin| client.register(plugin) }
    end
  end


  def self.run
    bot = Bot.new
    bot.run
  end
end

AUTH = YAML.parse(File.open("./src/config.yml"))
OWNER_ID = AUTH["owner"].as_i.to_u64
CLIENT_ID = AUTH["client_id"].as_i.to_u64

Dir.mkdir("./tournaments") unless Dir.exists?("./tournaments")
TournamentBot.run
