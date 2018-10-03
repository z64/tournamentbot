require "../spec_helper"

describe TournamentBot::GuildChecker do
  mock_client = MockClient.new

  it "doesn't pass when message isn't from a guild" do
    # Seed the mock client cache with a few channels, one in a guild, one not
    mock_client.cache.channels[1] = ChannelStub.new(3)
    mock_client.cache.channels[2] = ChannelStub.new(nil)

    # Form some payloads for each channel
    matching_payload    = MessageStub.new(channel_id: 1, content: "foo", embed: nil)
    mismatching_payload = MessageStub.new(channel_id: 2, content: "foo", embed: nil)

    # Place our MockClient inside a Context so our middleware uses it
    context = TestContext.new
    context.put(mock_client)
    mw = TournamentBot::GuildChecker.new

    # Test good payload:
    result = mw.call(matching_payload, context, &->{ true })
    result.should eq true
    context[TournamentBot::GuildChecker::Result].id.should eq 3

    # Test bad payload:
    result = mw.call(mismatching_payload, context, &->{ true })
    if result.is_a?(MessageStub)
      result.channel_id.should eq 2
      result.content.should eq "This command can only be used in a guild."
    else
      raise "Expected MessageStub, got #{result.class}"
    end
  end
end
