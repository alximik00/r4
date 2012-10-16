class PostsController < ApplicationController
  before_filter :authenticate_user!, :only=>[:destroy, :confirm, :discard]

  # GET /posts
  def index
    @posts =
      case params[:mode]
        when :all then Post.unscoped.page params[:page]
        when :popular then Post.popular.page params[:page]
        else Post.page params[:page]
      end

    fetch_popular
  end

  # GET /posts/1
  def show
    @post = get_post
    require_user unless @post.confirmed? || @post.user_id == current_user.try(:id)

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
    @post.confirmed = current_user.try(:admin?)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render action: "new"
    end
  end

  # GET /posts/1/edit
  def edit
    @post = get_post
    require_user and return unless able_to_edit?
  end

  # PUT /posts/1
  def update
    @post = get_post
    require_user and return unless able_to_edit?

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
    require_user and return unless able_to_edit?

    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end

  def preview
    @sample, _, _, _ = reformat_body_with_cut(params[:preview_body])
    #@sample = Render.render_html(params[:preview_body])
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

  helper_method :able_to_edit?
  def able_to_edit?
    ( @post.user_id.present? && @post.user_id == current_user.id ) || is_admin?
  end

  private

  def require_user
    flash[:error] = "It's not your post, you can't edit it"
    if current_user
      redirect_to posts_path
    else
      redirect_to new_user_session_path
    end
  end

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
    post.body,
    post.shorten,
    post.cut,
    post.preview_text=
      reformat_body_with_cut(post.raw_body)
  end

  def format_body_for_hash(post_hash)
    post_hash[:body],
    post_hash[:shorten],
    post_hash[:cut],
    post_hash[:preview_text]  =
        reformat_body_with_cut(post_hash[:raw_body])
  end

  def reformat_body_with_cut(body)
    post_body = Render.render_html(body)

    #take only 10 first lines
    preview_post = post_body .each_line.take(10).join

    #close all unclosed quotes
    preview_post+='```'  if preview_post.scan(/```/).size % 2 != 0
    preview_post+='`'  if preview_post.scan(/[^`]?`[^`]?/).size % 2 != 0

    #find cut tag
    cut_match = /(.*)\[cut\s+&#39;(.+)&#39;\s*\](.*)/m.match( post_body )
    if cut_match
      # remove cut tag from main text
      post_body = cut_match[1] + cut_match[3]
      shorten = cut_match[1]
      cut = cut_match[2]
      preview_post = preview_post.gsub(/\[cut\s+&#39;(.+)&#39;\s*\]/m, '') # remove cut from preview
    end

    preview_post = preview_post.gsub(/<a href=".+">/, "<span>")
    preview_post = preview_post.gsub("</a>", "</span>")

    [post_body, shorten, cut, preview_post]
  end
end
