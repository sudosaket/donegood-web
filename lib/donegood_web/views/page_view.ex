defmodule DonegoodWeb.PageView do
  use DonegoodWeb, :view
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

end
