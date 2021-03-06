class Command
  getter name : String

  def initialize(name : String)
    @name = name.downcase
  end

  def call(payload : Discord::Message, context : Discord::Context)
    yield if payload.content.downcase.starts_with?(@name)
  end
end
