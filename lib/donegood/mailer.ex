defmodule Donegood.Mailer do
  use Bamboo.Mailer, otp_app: :donegood
end



defmodule Donegood.Email do
  import Bamboo.Email

  @from "from@donegood.app"

  def welcome_email(user) do
    new_email(
      to: user.email,
      from: @from,
      subject: "Welcome to Donegood.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end

  def new_comment(comment, recipient, link) do
    body = "Hi " <> recipient.name <> ", " <> comment.user.name <> " wrote <blockquote>" <> comment.body <> "</blockquote> http://www.donegood.app" <> link
    new_email(
      to: recipient.email,
      from: @from,
      subject: "New comment by " <> comment.user.name <> " on " <> comment.deed.title,
      html_body: body,
      text_body: body
    )
  end

end
