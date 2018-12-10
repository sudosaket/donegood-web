defmodule DonegoodWeb.PageView do
  use DonegoodWeb, :view
  use Timex

  def render("title", _assigns) do
    "Donegood"
  end

  # def render("toolbar_right", %{conn: conn}) do
  #   link tag(:span, class: "glyphicon glyphicon-edit"), to: deed_path(conn, :new)
  # end

  def panel(heading,body) do
    [
      "<div class='panel panel-default'>",
        "<div class='panel-heading'>",
          "<h3 class='panel-title'>#{heading}</h3>",
        "</div>",
        "<div class='panel-body'>",
          body[:do],
        "</div>",
      "</div>"
    ] |> Enum.map(&(raw &1))
  end

  def start_dates do
    Interval.new(from: ~D[2018-11-23], step: [weeks: 1], until: Timex.now)
    |> Enum.reverse
  end
end
