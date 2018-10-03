class TournamentBot::Command
  getter name : String

  def initialize(name : String)
    @name = name.downcase
  end

  def call(payload, context)
    yield if payload.content.downcase.starts_with?(@name)
  end
end
