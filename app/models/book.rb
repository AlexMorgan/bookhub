class Book < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :quality, presence: true
  validates_formatting_of :course_title, using: :alphanum
  validates_formatting_of :price, using: :dollars, allow_nil: true

  def self.qualities
    %w(New Good Decent )
  end

  def title
    # super.split.map! {|word| word.capitalize }.join(' ')
    lowercase = %w(a an the for and nor but or yet so at by after along from of on to with is)
    t = super.split
    arr = []
    t.each do |word|
      if lowercase.include?(word)
        arr << word.downcase
      else
        arr << word.capitalize
      end
    end

    arr.first.capitalize!
    arr.last.capitalize!
    arr.join(' ')
  end

  def course_title
    super.split.map! {|word| word.upcase }.join(' ')
  end

  def price
    super.to_f.round(0)
  end
end
