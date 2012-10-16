class PostsController < ApplicationController
  # GET /posts
  def index
    @posts =
      case params[:mode]
        when :all then Post.unscoped.all
        when :popular then Post.popular
        else Post.all
      end
    @popular_posts = Post.all
  end

  # GET /posts/1
  def show
    @post = get_post

    @post.update_attribute(:views_count, @post.views_count + 1)
    fetch_popular
  end

  # GET /posts/new
  def new
    @post = Post.new(:confirmed=>false)
  end

  # POST /posts
  def create
    @post = Post.new(params[:post])
    unless current_user
      email = params[:post][:user_email]
      email_validation = /^[-a-z0-9!#\%&'*+\/=?^_`{|}~]+(?:\.[-a-z0-9!#$\%&'*+\/=?^_`{|}~]+)*@(?:[a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?\.)*(?:aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|[a-z][a-z])$/

      if email.blank? || ! (email_validation =~ email)
        @post.errors.add(:base, "Sorry, we need your correct email to save post")
        render :new
        return
      end
    end

    format_body(@post)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render action: "new"
    end
  end

  # GET /posts/1/edit
  def edit
    @post = get_post
  end

  # PUT /posts/1
  def update
    @post = get_post

    format_body_for_hash(params[:post])
    if @post.update_attributes(params[:post])
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /posts/1
  def destroy
    @post = get_post
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end

  def preview
    @sample = Render.render_html(params[:preview_body])
    render 'preview', :layout=>'preview'
  end

  def confirm
    @post = get_post
    @post.update_attribute(:confirmed, true)
    fetch_popular

    flash[:notice] = "Confirmed"
    render :show
  end

  def discard
    @post = get_post
    @post.update_attribute(:confirmed,  false)
    fetch_popular

    flash[:notice] = "Discarded"
    render :show
  end

  private
  def get_post
    if is_admin?
      @post = Post.unscoped.find(params[:id])
    else
      @post = Post.find(params[:id])
    end
  end

  def fetch_popular
    @popular_posts = Post.popular.limit(10)
  end

  def format_body(post)
    post.body = Render.render_html(post.raw_body)

    preview_post = post.each_line.take(10).join
    preview_post+='```'  if preview_post.scan(/```/).size % 2 != 0
    preview_post+='`'  if preview_post.scan(/[^`]?`[^`]?/).size % 2 != 0

    preview_post = Render.render_html( preview_post )
    preview_post = preview_post.gsub('<a', '<span')
    preview_post = preview_post.gsub('</a>', '</span>')

    post.preview_text = preview_post
  end

  def format_body_for_hash(params)
    post = params[:raw_body]
    params[:body ] = Render.render_html(post)

    preview_post = post.each_line.take(10).join
    preview_post+='```'  if preview_post.scan(/```/).size % 2 != 0
    preview_post+='`'  if preview_post.scan(/[^`]?`[^`]?/).size % 2 != 0

    preview_post = Render.render_html( preview_post )
    preview_post = preview_post.gsub('<a', '<span')
    preview_post = preview_post.gsub('</a>', '</span>')

    params[:preview_text] = preview_post
  end
end
