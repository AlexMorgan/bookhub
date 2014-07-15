class UpdateSearch
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options retry: false

  recurrence { hourly }

  def perform
    needs = Need.all

    needs.each do |need|
      if need.notified == false
        if need.isbn.present?
          matches = Book.where(isbn: need.isbn)
        else
          matches = Book.where(isbn13: need.isbn13)
        end
      end

      if matches.length > 1 && need.notified == false
        need.update!(notified: true)
        UserMailer.wishlist_match(matches, need).deliver
      end
    end

  end
end
