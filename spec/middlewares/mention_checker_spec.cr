require "../spec_helper"

describe TournamentBot::MentionChecker do
  mock_client = MockClient.new

  it "responds with less than minimium mentions" do
    context = TestContext.new
    context.put(mock_client)
    mw = TournamentBot::MentionChecker.new(min_mentions: 2, max_mentions: 4)

    message = MessageStub.new(1, "foo", mentions: MentionsStub.new(3))
    result = mw.call(message, context, &->{ true })
    result.should eq true
  end

  it "responds with less than minimium mentions" do
    context = TestContext.new
    context.put(mock_client)
    mw = TournamentBot::MentionChecker.new(min_mentions: 2)

    message = MessageStub.new(1, "foo", mentions: MentionsStub.new(1))
    result = mw.call(message, context, &->{ true })
    result.should be_a MessageStub
    if result.is_a?(MessageStub)
      result.channel_id.should eq 1
      result.content.should eq "You need to mention at least 2 user(s) to use this command."
    end
  end

  it "responds with more than maximum mentions" do
    context = TestContext.new
    context.put(mock_client)
    mw = TournamentBot::MentionChecker.new(max_mentions: 2)

    message = MessageStub.new(1, "foo", mentions: MentionsStub.new(3))
    result = mw.call(message, context, &->{ true })
    result.should be_a MessageStub
    if result.is_a?(MessageStub)
      result.channel_id.should eq 1
      result.content.should eq "You can't mention more than 2 user(s) to use this command."
    end
  end
end
