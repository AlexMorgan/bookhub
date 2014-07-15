class Need < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :user_id, presence: true

  before_create :find_result_info

  def find_result_info
    client = ASIN::Client.instance
    query = client.search_keywords(self.title)
    if !query.nil?
      result = query.first

      self.title = result.item_attributes.title
      self.author = result.item_attributes.author
      self.isbn = result.item_attributes.isbn
      self.isbn13 = result.item_attributes.ean
      self.amazon_url = result.detail_page_url
      self.image_url = result.small_image.url
    end
  end

end
