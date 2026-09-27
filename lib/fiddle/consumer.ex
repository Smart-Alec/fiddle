defmodule Fiddle.Consumer do
  @behaviour Nostrum.Consumer

  # Add commands

  def handle_event({:READY, %{guilds: guilds} = _event, _ws_state}) do
    guilds
    |> Enum.map(fn guild -> guild.id end)
    |> Enum.each(fn guild_id ->
      Nostrum.Api.ApplicationCommand.create_guild_command(guild_id, %{
        name: "start",
        description: "Start playing Fiddle!",
        options: [%{
          type: 3,
          name: "url",
          description: "Link to a playlist to choose songs from.",
          required: true
        }]
      })

      Nostrum.Api.ApplicationCommand.create_guild_command(guild_id, %{
        name: "guess",
        description: "Submit a guess for Fiddle.",
        options: [%{
          type: 3,
          name: "song",
          description: "The Youtube video title for the song.",
          autocomplete: true
        }]
      })
    end)
  end

  # Start game

  def handle_event({:INTERACTION_CREATE, %{data: %{name: "start"}} = interaction, _ws_state}) do
    [%{name: "url", value: _url}] = interaction.data.options
    Nostrum.Api.Interaction.create_response(interaction, %{type: 5}) # Tell discord that we are waiting to process data
    Fiddle.YouTube.test # come back and replace this
    Fiddle.Interface.render_controls(interaction)
  end

  # Play/Pause

  def handle_event({:INTERACTION_CREATE, %{data: %{custom_id: "pause"}} = interaction, _ws_state}) do
    Nostrum.Api.Interaction.create_response(interaction, %{type: 6, data: %{flags: 32768}})
    Fiddle.Interface.pause()
    Fiddle.Interface.render_controls(interaction)
  end

  # Autocomplete for /guess

  def handle_event({:INTERACTION_CREATE, %{data: %{options: [%{name: "song", focused: true, value: partial_value}]}} = interaction, _ws_state}) do
    Nostrum.Api.Interaction.create_response(interaction, %{
      type: 8,
      data: %{
        choices: Fiddle.YouTube.get_nearest_titles(Fiddle.YouTube.current_playlist, partial_value)
        |> Enum.map(fn title ->
          %{name: title, value: title}
        end)
      }
    })
  end

  # Ignore any other events

  def handle_event(_), do: :ok
end
