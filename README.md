Rails Reroute
================================

Rails reroute allows you to full reroute your request from within a controller without having to duplicate code across controllers. Just plug it in and it works.

	class AirTrafficController < ApplicationController
	  def index
	    reroute "status"
	  end
	end

You can add it to your project by adding this to your Gemfile

	gem 'rails_reroute', :require => 'rails_reroute'
