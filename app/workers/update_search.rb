class UpdateSearch
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options retry: false

  recurrence { hourly.minute_of_hour(0, 10, 20, 30, 40, 50) }

  def perform
    needs = Need.all
    matches = []
    needs.each do |need|
      if need.notified == false
        if need.isbn.present?
          matches = Book.where(isbn: need.isbn)
        else
          matches = Book.where(isbn13: need.isbn13)
        end
      end

      if matches.length != 0 &&  need.notified == false
          UserMailer.wishlist_match(matches, need).deliver
          need.update!(notified: true)
      end
    end

  end
end
