require "../spec_helper"

private record Message, content : String

describe TournamentBot::Command do
  it "passes for a matching command" do
    matching_message = Message.new("!FOO")
    mismatching_message = Message.new("?FOO")

    mw = TournamentBot::Command.new("!foo")
    mw.call(matching_message, :ctx, &->{ true }).should eq true
    mw.call(mismatching_message, :ctx, &->{ true }).should eq nil
  end
end
