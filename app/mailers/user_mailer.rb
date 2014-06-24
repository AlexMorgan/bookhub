class UserMailer < ActionMailer::Base
  default from: "dukehub@gmail.com"

  def purchase_email(buyer, seller, book)
    @seller = seller
    @buyer = buyer
    @book = book

    @url  = 'http://www.launchacademy.com'
    mail(to: @seller.email, subject: "Purchase Inquiry: #{@book.title} has been sold!")
  end

  def contact_form(name, email, subject, message)
    @name = name
    @email = email
    @subject = subject
    @message = message


    mail(to: 'dukehub@gmail.com', subject: "#{@name} has contacted you")
  end
end