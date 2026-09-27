defmodule Fiddle.Application do
  use Application

  @impl true
  def start(_type, _args) do
    bot_options = %{
      name: Fiddle,
      consumer: Fiddle.Consumer,
      intents: [:direct_messages, :guild_messages, :message_content],
      wrapped_token: fn -> System.fetch_env!("BOT_TOKEN") end
    }
    children = [
      {Nostrum.Bot, bot_options}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
