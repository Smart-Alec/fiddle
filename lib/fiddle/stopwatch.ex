defmodule Fiddle.Stopwatch do
  defstruct elapsed: 0, timestamp: 0

  def current_time(%Fiddle.Stopwatch{elapsed: elapsed, timestamp: 0}) do
    # Stopwatch is currently paused, we can just use the elapsed time
    elapsed
  end

  def current_time(%Fiddle.Stopwatch{elapsed: elapsed, timestamp: timestamp}) do
    # Stopwatch is currently unpaused, we need to add accumulated time
    additional_time = Time.diff(Time.utc_now(), timestamp, :millisecond)
    elapsed + additional_time
  end

  def paused?(%Fiddle.Stopwatch{elapsed: _, timestamp: 0}), do: true
  def paused?(%Fiddle.Stopwatch{elapsed: _, timestamp: _}), do: false

  def resume(%Fiddle.Stopwatch{elapsed: elapsed, timestamp: 0}) do
    %Fiddle.Stopwatch{elapsed: elapsed, timestamp: Time.utc_now()}
  end

  def resume(_) do
    raise("Stopwatch is already running.")
  end

  def pause(%Fiddle.Stopwatch{elapsed: _, timestamp: 0}) do
    raise("Stopwatch is already paused.")
  end

  def pause(%Fiddle.Stopwatch{elapsed: elapsed, timestamp: timestamp}) do
    %Fiddle.Stopwatch{elapsed: elapsed + Time.diff(Time.utc_now(), timestamp, :millisecond), timestamp: 0}
  end

  def toggle(stopwatch) do
    if paused? stopwatch do
      resume stopwatch
    else
      pause stopwatch
    end
  end
end
