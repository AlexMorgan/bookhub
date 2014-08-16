class UserMailer < ActionMailer::Base
  default from: "thenobrainr@gmail.com"

  def purchase_email(buyer, seller, book)
    @seller = seller
    @buyer = buyer
    @book = book

    mail(to: @seller.email, subject: "Purchase Inquiry: #{@book.title} has been sold!")
  end

  def contact_form(name, email, subject, message)
    @name = name
    @email = email
    @subject = subject
    @message = message


    mail(to: 'thenobrainr@gmail.com', subject: "#{@name} has contacted you")
  end

  def offer_email(seller, bidder, book, offer)
    @seller = seller
    @bidder = bidder
    @book = book
    @offer = offer

    mail(to: @seller.email, subject: "New offer on '#{@book.title}!'")
  end

  def accept_offer_email(seller, offer)
    @seller = seller
    @offer = offer
    @book = offer.book
    @bidder = offer.user

    mail(to: @bidder.email, subject: "Your offer for '#{@book.title}' has been accepted!")
  end

  def wishlist_match(matches, need)
    @matches = matches
    @need = need
    mail(to: @need.user.email, subject: "Your wishlist item has been matched!")
  end
end
