class PostsController < ApplicationController
  # GET /posts
  def index
    @posts = Post.all
    @popular_posts = Post.all
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
    @post.update_attribute(:views_count, @post.views_count + 1)
    @popular_posts = Post.all
  end

  # GET /posts/new
  def new
    @post = Post.new(:lang_id => Post::LANGS[:ruby])
  end

  # POST /posts
  def create
    email = params[:post][:user_email]
    @post = Post.new(params[:post])

    email_validation = /^[-a-z0-9!#\%&'*+\/=?^_`{|}~]+(?:\.[-a-z0-9!#$\%&'*+\/=?^_`{|}~]+)*@(?:[a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?\.)*(?:aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|[a-z][a-z])$/

    if email.blank? || ! (email_validation =~ email)
      @post.errors.add(:base, "Sorry, we need your correct email to save post")
      render :new
      return
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
    @post = Post.find(params[:id])
  end

  # PUT /posts/1
  def update
    @post = Post.find(params[:id])

    format_body_for_hash(params[:post])
    if @post.update_attributes(params[:post])
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /posts/1
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end

  def preview
    text = params[:preview_body]
    lang_id =  params[:preview_lang_id]
    lang = Post.lang_by_id(lang_id).to_s.downcase
    @sample = Uv.parse( text, "xhtml", lang, true, "twilight")
    render 'preview', :layout=>'preview'
  end

  private
  def format_body(post)
    lang = Post.lang_by_id(post.lang_id).to_s.downcase
    post.body = Uv.parse( post.raw_body, "xhtml", lang, true, "twilight")
    preview = Uv.parse( post.raw_body, "xhtml", lang, false, "twilight")
    post.preview_text = preview.each_line.take(10).join
  end

  def format_body_for_hash(params)
    lang = Post.lang_by_id(params[:lang_id]).to_s.downcase
    params[:body ] = Uv.parse( params[:raw_body], "xhtml", lang, true, "twilight")
    preview = Uv.parse( params[:raw_body], "xhtml", lang, false, "twilight")
    params[:preview_text] = preview.each_line.take(10).join
  end
end
