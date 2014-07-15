class UpdateSearch
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(book_id)
    book = Book.find(book_id)
    needs = Need.all
    matches = []

    needs.each do |need|
      if need.isbn.present? && book.isbn.present?
        if need.isbn == book.isbn
          matches << book
          UserMailer.wishlist_match(matches, need).deliver
          need.update!(notified: true)
        end
      else
        if need.isbn13 == book.isbn13
          matches << book
          UserMailer.wishlist_match(matches, need).deliver
          need.update!(notified: true)
        end
      end
    end
  end
end
