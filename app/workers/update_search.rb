class UpdateSearch
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(book_id)
    book = Book.find(book_id)

    if book.isbn.present?
      matches = Need.where(isbn: book.isbn)
    else
      matches = Need.where(isbn13: book.isbn13)
    end

    if matches.length != 0
      matches.each do |need|
        book = [book]
        UserMailer.wishlist_match(book, need).deliver
        need.update!(notified: true)
      end
    end
  end
end
