class LinksController < ApplicationController
  after_action :popup_seen
  skip_before_action :verify_authenticity_token
  before_action :set_orientation, only: [:index, :search]
  def index
    @link = Link.new
    per_page = bot_request? ? 400 : 8
    if params[:q].present?
      Query.record(params[:q], current_visitor) if current_visitor
      @links = Link.search(params[:q], orientation).paginate(page: params[:page], per_page: per_page)
      @count = Link.search_count params[:q], orientation
      if params[:crawl].present?
        Searcher.perform_later params[:q] 
      end
    elsif params[:video_id].present?
      @links = Link.where(hidden: false, id: params[:video_id]).paginate(per_page: 1, page: 1)
      @count = 1
    else
      @links = Link.normal.with_orientation(orientation).limit(8).paginate(per_page: per_page, page: 1)
      @count = Time.now.to_i/3000
    end
  end

  def search
    if request.format.html?
      redirect_to root_path(q: params[:q])
    else
      if params[:q].present?
        Query.record(params[:q], current_visitor) if current_visitor
        @links = Link.search(params[:q], orientation, params[:order]).paginate(page: params[:page], per_page: 8)
        @count = Link.search_count params[:q], orientation
        #if @links.blank? || @links.next_page.blank?
        if params[:crawl].present?
          Searcher.perform_later params[:q]
        elsif params[:random].present?
          @links = Link.normal.with_orientation(orientation).order(Arel.new('random()')).limit(8).paginate(per_page: 8, page: 1)
        end
      else
        @links = Link.normal.with_orientation(orientation).paginate(per_page: 8, page: params[:page])
      end
      render 'search', layout: false
    end
  end

  def comments
    @link = Link.unscoped.find(params[:id])
    @comments = @link.comments
    render 'comment_section', layout: false
  end

  def create_comment
    comment_params = params.require(:comment).permit(:kind, :text)
    link_id = params[:id]
    @Link = Link.find(link_id)
    @comment = @Link.comments.create(comment_params.merge(user_id: current_user.id, kind: 'videoresponse', post_id: link_id))
    render 'posts/comments/comment', layout: false
  end

  def hidden
    if current_user.try :admin?
      @links = Link.unscoped.where(hidden: true).paginate(per_page: 8, page: params[:page])
    else
      redirect_to root_path
    end
  end

  def mark_fav
    if current_user.admin?
      @link = Link.unscoped.find(params[:id])
      @link.update(favourite: !@link.favourite)
      render 'hide', layout: false
    end
  end

  def favourite
    @links = Link.favourite.paginate(per_page: 8, page: params[:page])
    @count = Link.favourite.count
  end

  def create
    @link = Link.new(link_params)
    if @link.name.blank?
      @link.url.split(/[,\s\n]+/).select(&:present?).each do |url|
        uri = URI.parse url
        if uri.host.present?
          link = Link.create(url: uri.host.blank? ? "#{URI.parse(url).scheme}://#{URI.parse(url).host}#{url}" : url, visitor_id: current_visitor.id)
          Link.move_top(link.url) unless link.valid?
        end
      end
      render plain: 'link(s) created'
    elsif @link.save
      render plain: 'link created'
    else
      render 'new', layout: false, status: 422
    end
  end

  def tag
    link = Link.find(params[:id])
    new_tagset = link.tags.to_s + ' ' + params[:value]
    link.update(tags: new_tagset)
    current_visitor.contributions.create(contributable_type: 'Tag', contributable_id: params[:id], content: params[:value])
  end

  def retry
    render plain: Link.find(params[:id]).generate_source_url_now
  end

  def desc
    TextRecord.where(name: 'meta_desc').first_or_create.update(value: params.permit(:value)[:value])
    render plain: params[:value]
  end

  def destroy
    if current_user.admin?
      Link.unscoped.find(params[:id]).delete
    end
  end

  def hide
    if current_user.admin?
      @link = Link.find(params[:id])
      @link.update(hidden: true)
      render 'hide', layout: false
    end
  end

  def report
      @link = Link.find(params[:id])
      current_visitor.contributions.create(contributable_type: 'Flag', contributable_id: params[:id], content: 'Repting Video')
      render json: {message: 'report success'}
  end

  def unhide
    if current_user.admin?
      @link = Link.unscoped.find(params[:id])
      @link.update(hidden: false)
      render 'hide', layout: false
    end
  end

  def untag
    link = Link.unscoped.find(params[:id])
    if current_user.admin?
      link.update(tags: link.tags.gsub(params[:tag].strip, ''))
    end
  end

  def statistics
    t = Visitor.arel_table
    render json: {
      date: Date.today,
      counts: {
        gay: Link.search_count('gay', 'gay'),
        lesbian: Link.search_count('lesb', 'lesb'),
        total: Link.count,
        indexed_today: Link.where(created_at: (1.days.ago..Time.now)).count,
        signups: User.where(created_at: (1.days.ago..Time.now)).count,
        all_time_signups: User.count
      },
      visitors_today: Visitor.where(created_at: (1.days.ago..Time.now)).count,
      uniq_ips_today: Visitor.where(created_at: (1.days.ago..Time.now)).group(:ip).select('ip').length,
      current_ips_in_a_minute: Visitor.where(t[:created_at].in(1.minutes.ago..Time.now).or(t[:last_seen].in(1.minutes.ago..Time.now))).count('distinct ip'),
      uniq_ips_all_time: Visitor.group(:ip).select('ip').length,
      all_time_visitors: Visitor.count,
      total_searches: Query.where(created_at: (1.days.ago..Time.now)).count,
      all_time_total_searches: Query.count,
      top_search_counts_per_user: Query.where(created_at: (1.days.ago..Time.now)).group('visitor_id').count.to_a.map(&:last).sort.reverse[0..30].join(', '),
      flags: Contribution.where(created_at: (1.days.ago..Time.now), contributable_type: 'Flag').all.map{|c| Link.find(c.contributable_id).url},
      new_tags: Contribution.where(created_at: (1.days.ago..Time.now), contributable_type: 'Tag').all.map{|c| "#{c.content} added to #{Link.find(c.contributable_id).name} #{Link.find(c.contributable_id).url}"},
      queries: Query.where(created_at: (1.days.ago..Time.now)).group(:key).count.sort_by{|k, count| count.to_i}.reverse.map{|q,c| "#{q}(#{c})"},
      all_time_top_queries: Query.group(:key).count.sort_by{|k, count| count.to_i}.reverse[0..30].map{|q,c| "#{q}(#{c})"}

   } 
  end

  protected

  def popup_seen
    cookies[:popup_seen] = true
  end

  def orientation
    @orientation = cookies[:orientation]
    @orientation
  end

  def set_orientation
    if params[:orientation].present?
      cookies[:orientation] = params[:orientation]
    end
  end
  def link_params
    params.require(:link).permit(:name, :url, :tags)
  end
end
