class ContactForm < ActiveRecord::Base
  validates_formatting_of :name, :using => :alphanum, presence: true
  validates_formatting_of :email, :using => :email, presence: true
  validates_formatting_of :subject, :using => :alphanum, allow_nil: true
  validates :message, presence: true
end
