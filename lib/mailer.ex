defmodule Donegood.Mailer do
  @config domain: Application.get_env(:donegood, :mailgun_domain),
          key: Application.get_env(:donegood, :mailgun_key)
  use Mailgun.Client, @config


  @from "from@donegood.app"

  def send_welcome_text_email(user) do
    send_email to: user.email,
               from: @from,
               subject: "hello!",
               text: "Welcome!"
  end

  def send_welcome_html_email(user) do
    send_email to: user.email,
               from: @from,
               subject: "hello!",
               html: "<strong>Welcome!</strong>"
  end

 # attachments expect a list of maps. Each map should have a filename and path/content

  def send_greetings(user, file_path) do
    send_email to: user.email,
               from: @from,
               subject: "Happy b'day",
               html: "<strong>Cheers!</strong>",
               attachments: [%{path: file_path, filename: "greetings.png"}]
  end

  def send_invoice(user) do
    pdf = Invoice.create_for(user) # a string
    send_email to: user.email,
               from: @from,
               subject: "Invoice",
               html: "<strong>Your Invoice</strong>",
               attachments: [%{content: pdf, filename: "invoice.pdf"}]
  end
end
