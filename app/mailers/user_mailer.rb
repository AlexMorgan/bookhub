class UserMailer < ActionMailer::Base
  default from: "dukehub@gmail.com"

  def purchase_email(buyer, seller, book)
    @seller = seller
    @buyer = buyer
    @book = book
    binding.pry

    @url  = 'http://www.launchacademy.com'
    mail(to: @buyer.email, subject: 'One of your items have been purchased!')
  end
end
