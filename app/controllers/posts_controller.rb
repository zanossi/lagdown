class PostsController < ApplicationController
  before_action :set_blog, only: %i[index show rss]
  before_action :set_post, only: %i[show]
  authorize_resource except: :preview
  layout 'blog'

  def index
    @posts = @blog.posts.page(params[:page])
  end

  def show
    description = LagdownRenderer.render(@post.content)[/<p>([^<].*)<\/p>/, 1]
    @title =  "#{@post.title} - #{@blog.name}"
    @meta_hash = {
      author: @blog.user.try(:nickname),
      description: description,
      generator: :lagdown
    }
    @og_hash = {
      title: @title,
      type:  :website,
      url: post_url(@post),
      description: description
    }
  end

  def preview
    render text: LagdownRenderer.render(params[:text].to_s)
  end



  def rss
    require "rss"

     @rss = RSS::Maker.make("2.0") do |maker|
     maker.channel.language = "en"
     maker.channel.author = "123"
     maker.channel.updated = Time.now.to_s
     maker.channel.link = "http://www.ruby-lang.org/en/feeds/news.rss"
     maker.channel.title = "Example Feed"
     maker.channel.description = "A longer description of my feed."
     
     @blog.posts.each do |p|

       maker.items.new_item do |item|
       item.link = post_url(p,:subdomain => @blog.subdomain)
       #"http://tim.lvh.me:3000/posts/" + p.id.to_s
       item.title = p.title
       item.updated = p.updated_at.to_s

    end

     end
    end

    # respond_to do |format|
    #   format.xml { render :xml => @rss.to_xml}
    # end
    render :xml => @rss.to_xml
  end



  private

  def set_blog
    @blog = Blog.find_by_subdomain! request.subdomain
  end

  def set_post
    @post = @blog.posts.find(params[:id])
  end
end
