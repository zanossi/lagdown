class HomeController < ApplicationController
before_action :set_blog, only: %i[]
before_action :set_user, only: %i[]
 def index
 end

 def about
      
 end


private

def set_blog
  @blog = Blog.find_by_subdomain! request.subdomain
end

def set_user
  @user = Blog.user.find(params[:id])
end

end
