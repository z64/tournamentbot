require "yaml"
require "../../lib/tournaments/Tournament"

@[Discord::Plugin::Options(middleware: {DiscordMiddleware::Prefix.new("!")})]
class TournamentBot::Test
  include Discord::Plugin

  @[Discord::Handler(event: :message_create)]
  def handle(payload, _ctx)
    if payload.content.starts_with?("!ping")
      msg = client.create_message(payload.channel_id, "I'm busy...")
      time = Time.utc_now - payload.timestamp
      client.edit_message(payload.channel_id, msg.id, "I'm busy... This took me a whole #{time.total_seconds} seconds!")
    end
  end
end
