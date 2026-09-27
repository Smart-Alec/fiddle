defmodule Fiddle.Interface do
  def paused?() do
    :ets.insert_new(:yt_cache, {"paused", false})
    {"paused", paused} = :ets.lookup(:yt_cache, "paused") |> hd
    paused
  end

  def pause() do
    :ets.insert(:yt_cache, {"paused", !paused?()})
  end

  def render_controls(interaction) do
    Nostrum.Api.Interaction.edit_response(interaction, %{
      flags: 32768,
      components: [
        %{
          type: 1,
          components: [
            %{
              type: 2,
              custom_id: "pause",
              label: (if paused?(), do: "⏸️", else: "▶️"),
              style: 2
            }
          ]
        }
      ]
    })
  end
end
