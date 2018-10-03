require "spec"
require "../src/tournamentbot"

record MessageStub, channel_id : UInt64, content : String, mentions : MentionsStub = MentionsStub.new(0), embed : Discord::Embed? = nil
record MentionsStub, size : Int32
record ChannelStub, guild_id : UInt64?

# A proxy for Discord::Context that specifically returns
# MockClient when asked for Discord::Client
class TestContext
  def initialize
    @context = Discord::Context.new
  end

  def put(obj)
    @context.put(obj)
  end

  def [](client : Discord::Client.class)
    @context[MockClient]
  end

  def [](klazz : T.class) forall T
    @context[klazz]
  end
end

class MockClient
  class Cache
    getter channels = Hash(UInt64, ChannelStub).new

    def resolve_channel(id)
      @channels[id]
    end
  end

  def cache
    @cache ||= Cache.new
  end

  def create_message(channel_id, content, embed = nil)
    MessageStub.new(channel_id, content, embed: embed)
  end
end
