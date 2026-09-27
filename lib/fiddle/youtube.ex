defmodule Fiddle.YouTube do
  def test() do
    fetch_playlist("https://music.youtube.com/playlist?list=RDCLAK5uy_nxuz8sV0R7aWiLsbDv5W9_Bvp0X9PxFjY")
  end

  # Cache operations

  def cache_playlist(playlist) do
    :ets.insert(:yt_cache, {"playlist", playlist})

    {:ok, playlist}
  end

  def current_playlist() do
    {"playlist", playlist} = :ets.lookup(:yt_cache, "playlist")
    |> hd

    playlist
  end

  # Api functions

  def fetch_playlist(url) do
    playlist = System.cmd("yt-dlp", ["--flat-playlist", "-i", "--print", "%(title)s;%(channel)s;%(url)s", url])
    |> elem(0)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn metadata_string ->
      [title, channel, url] = String.split(metadata_string, ";")
      %{title: title, author: channel, url: url}
    end)

    cache_playlist(playlist)

    {:ok, playlist}
  end

  def get_nearest_titles(playlist, match_string) do
    playlist
    |> Enum.map(&(&1.title))
    |> Enum.map(&(String.downcase(&1)))
    |> Enum.map(fn title ->
      %{title: title, distance: String.jaro_distance(title, match_string)}
    end)
    |> Enum.sort_by(&(&1.distance), :desc)
    |> Enum.filter(&(&1.distance > 0))
    |> Enum.take(10)
    |> Enum.map(&(&1.title))
  end
end
