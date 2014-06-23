class PagesController < ApplicationController

  def home
    @users = User.all
    @hash = Gmaps4rails.build_markers(@users) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
      marker.infowindow user.username
      ## Show user image as marker
      # marker.picture({
      #   url: user.avatar.url(:tiny),
      #   width: 25,
      #   height: 25
      #   })
    end
  end
end
