class WishlistWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(book)
    library = Book.all
    matches = []
    if book.isbn.present?
      library.each do |lib_book|
        if book.isbn == lib_book.isbn
          matches << lib_book
        end
      end
    else
      library.each do |lib_book|
        if book.isbn13 == lib_book.isbn13
          matches << lib_book
        end
      end
    end
    UserMailer.wishlist_match(matches, book)
  end

end
