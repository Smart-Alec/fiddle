defmodule Fiddle.Interface do
  def progress_bar(percent, height \\ 1, width \\ 10) do
    row = String.duplicate("<:green_progress:1553596978154176564>", trunc(Float.ceil(width * percent))) <> String.duplicate("<:black_progress:1553638572551184414>", trunc(Float.floor(width * (1 - percent)))) <> "\n"
    String.duplicate(row, height)
    |> String.trim()
  end

  def get_stopwatch() do
    case :ets.lookup(:yt_cache, "stopwatch") do
      [] ->
        %Fiddle.Stopwatch{}
      [{"stopwatch", stopwatch}] ->
        stopwatch
    end
  end

  def set_stopwatch(stopwatch) do
    :ets.insert(:yt_cache, {"stopwatch", stopwatch})
    stopwatch
  end

  def toggle_pause() do
    Fiddle.Interface.get_stopwatch()
    |> Fiddle.Stopwatch.toggle()
    |> Fiddle.Interface.set_stopwatch()
    |> Fiddle.Stopwatch.current_time()
  end

  def rewind() do
    Fiddle.Interface.set_stopwatch(%Fiddle.Stopwatch{})
  end

  def render_controls(interaction) do
    progress_percentage = (Fiddle.Interface.get_stopwatch() |> Fiddle.Stopwatch.current_time()) / 10_000 |> min(1.0)
    Nostrum.Api.Interaction.edit_response(interaction, %{
      flags: 32768,
      components: [
        %{
          type: 10,
          content: Fiddle.Interface.progress_bar(progress_percentage, 3, 27)
        },
        %{
          type: 1,
          components: [
            %{
              type: 2,
              custom_id: "rewind",
              label: "⏪",
              style: 2
            },
            %{
              type: 2,
              custom_id: "pause",
              label: (if Fiddle.Interface.get_stopwatch() |> Fiddle.Stopwatch.paused?(), do: "▶️", else: "⏸️"),
              style: 2
            },
          ]
        }
      ]
    })

    if !(Fiddle.Interface.get_stopwatch() |> Fiddle.Stopwatch.paused?()) do
      # As long as the stopwatch is unpaused, continue updating the interface so that the progress bar progresses
      Fiddle.Interface.render_controls(interaction)
    end
  end
end
