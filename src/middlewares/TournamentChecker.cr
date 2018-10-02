# Checks if a tournament is present in the guild a command was called in.
class TournamentChecker
  getter tournaments : Hash(UInt64, Tournament)

  def initialize(tournaments : Hash(UInt64, Tournament))
    @tournaments = tournaments
  end

  def call (payload : Discord::Message, context)
    guild = context[GuildChecker].guild

    if @tournaments[guild]?
      yield
    else
      context[Discord::Client].create_message(payload.channel_id, "There is currently no running tournament in this guild.")
    end
  end
end
