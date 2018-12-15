defmodule Donegood.Mailer do
  use Bamboo.Mailer, otp_app: :donegood
end

defmodule Donegood.Email do
  import Bamboo.Email

  def welcome_email(user) do
    new_email(
      to: user.email,
      from: "from@donegood.app",
      subject: "Welcome to Donegood.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end
end
