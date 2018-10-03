# Checks if a command was called in a guild (as opposed to a DM channel.)
class GuildChecker
  getter guild : UInt64 = 0

  def call (payload, context)
    client = context[Discord::Client]
    guild = client.cache.try &.resolve_channel(payload.channel_id).guild_id
    if guild
      @guild = guild.to_u64
      yield
    else
      client.create_message(payload.channel_id, "This command can only be used in a guild.")
    end
  end
end
