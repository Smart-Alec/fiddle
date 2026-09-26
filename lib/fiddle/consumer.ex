defmodule MyBot.Consumer do
  @behaviour Nostrum.Consumer

  alias Nostrum.Api.Message

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!hello" ->
        {:ok, _message} = Message.create(msg.channel_id, "Hello, world!")

      _ ->
        :ignore
    end
  end

  # Ignore any other events
  def handle_event(_), do: :ok
end
