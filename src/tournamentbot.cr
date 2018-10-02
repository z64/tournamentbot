require "yaml"
require "discordcr"
require "discordcr-plugin"
require "discordcr-middleware"
require "discordcr-middleware/middleware/prefix"

require "./plugins/*"
require "./middlewares/*"

module TournamentBot
  class Bot
    getter client : Discord::Client
    getter cache : Discord::Cache
    delegate run,  to: client
    delegate stop, to: client

    def initialize
      "puts initialized"
      @client = Discord::Client.new(token: "Bot MzY2MjQ1MTQ3NjczMTAwMjg4.DosR0g.v4ayRZiLy2qhYk_Cy1U1M_3c0PU", client_id: 366245147673100288_u64)
      @cache = Discord::Cache.new(@client)
      @client.cache = @cache
      register_plugins
    end

    def register_plugins
      Discord::Plugin.plugins.each { |plugin| client.register(plugin) }
    end
  end

  OWNER_ID = 94558130305765376

  def self.run
    bot = Bot.new
    bot.run
  end
end

CLIENT_ID = 352983229063757825.to_u64

Dir.mkdir("./tournaments") unless Dir.exists?("./tournaments")
TournamentBot.run
