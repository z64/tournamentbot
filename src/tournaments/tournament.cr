class Tournament
  include Random::Secure
  include YAML::Serializable

  @[YAML::Field]
  property name : String

  @[YAML::Field]
  property guild : UInt64

  @[YAML::Field]
  property game : String

  @[YAML::Field]
  property creator : UInt64

  @[YAML::Field]
  property hosts : Array(UInt64)

  @[YAML::Field]
  property volunteers : Array(UInt64)

  @[YAML::Field]
  property commentators : Array(UInt64)

  @[YAML::Field]
  property participants : Array(UInt64)

  @[YAML::Field]
  property bracket : String

  @[YAML::Field]
  property started : Bool

  @[YAML::Field]
  property maps : Array(String)

  @[YAML::Field]
  property matches : Array(Match)

  @[YAML::Field]
  property current_match : String

  @[YAML::Field]
  property next_match : String


  def initialize(author : UInt64, guild : UInt64, name : String?)
    @name          = name.empty? ? Random::Secure.hex(3) : name
    @guild         = guild
    @game          = "*No game set for this tournament yet.*"
    @creator       = author
    @hosts         = [author]
    @volunteers    = Array(UInt64).new
    @commentators  = [author]
    @participants  = Array(UInt64).new
    @bracket       = "*No bracket set for this tournament yet.*"
    @started       = false
    @maps          = Array(String).new
    @matches       = Array(Match).new
    @current_match = ""
    @next_match    = ""
  end

  def to_embed(cache : Discord::Cache?)
    return Discord::Embed.new(title: "Can't create embed without cache.") if cache.nil?

    embed = Discord::Embed.new

    # Needed for the nil check to work.
    volunteers   = @volunteers
    commentators = @commentators

    creator      = cache.resolve_user(@creator)
    hosts        = resolve_users(@hosts, cache)
    volunteers   = resolve_users(volunteers, cache)
    commentators = resolve_users(commentators, cache)
    participants = resolve_participants(cache)

    fields = Array(Discord::EmbedField).new
    fields << Discord::EmbedField.new(name: "Hosts", value: hosts, inline: true) if hosts
    fields << Discord::EmbedField.new(name: "Volunteers", value: volunteers, inline: true) if volunteers
    fields << Discord::EmbedField.new(name: "Commentators", value: commentators, inline: true) if commentators
    fields << Discord::EmbedField.new(name: "Participants", value: participants)

    embed.author      = Discord::EmbedAuthor.new(name: "#{creator.username} presents:", icon_url: creator.avatar_url)
    embed.title       = "__#{@name}__ (#{@game})"
    embed.description = @bracket

    if @started
      embed.footer = Discord::EmbedFooter.new(text: "This tournament has already started, you can not sign up for it any longer.")
      embed.colour = 0xFF0000

      fields << Discord::EmbedField.new(name: "Current match:", value: @current_match)
    else
      embed.footer = Discord::EmbedFooter.new(text: "This tournament hasn't started yet. Join it by typing \"!join\"!")
      embed.colour = 0x00FF00
    end

    embed.fields = fields
    embed
  end

  def advance_match
    @current_match = @next_match
    @next_match = @matches[0]?.to_s
    @matches.delete(@matches[0]?)
  end

  private def resolve_users(users : Array(UInt64), cache : Discord::Cache) : String?
    return nil if users.empty?

    users.map { |u| "• #{cache.resolve_user(u).username}##{cache.resolve_user(u).discriminator}\n" }.join
  end

  # Different method because participants need to be numbered for seeding purposes.
  private def resolve_participants(cache : Discord::Cache) : String
    participants = @participants
    return "*No one is participating in this tournament yet.*" if participants.empty?

    n = 0
    participants.map { |u| "**#{n += 1}**: #{cache.resolve_user(u).username}##{cache.resolve_user(u).discriminator}\n" }.join
  end
end
