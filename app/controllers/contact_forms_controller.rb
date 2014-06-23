class ContactFormsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  def new
    @contact = ContactForm.new
  end

  def create
    @contact = ContactForm.new(contact_form_params)

    if @contact.save
      UserMailer.contact_form(@contact.name, @contact.email, @contact.subject, @contact.message).deliver
      redirect_to root_path, notice: "Your message has been sent. Thank You"
    else
      render action: 'new'
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :email, :subject, :message)
  end

end
