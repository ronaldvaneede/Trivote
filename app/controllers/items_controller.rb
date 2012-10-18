
class ItemsController < ApplicationController
  before_filter :authenticate_user!

  # GET /items
  # GET /items.json
  def index
    @items = Item.plusminus_tally

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @itemgroup = Itemgroup.find(params[:itemgroup_id])
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @itemgroup = Itemgroup.find(params[:itemgroup_id])
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @itemgroup = Itemgroup.find(params[:itemgroup_id])
    @item = Item.new(params[:item])
    @item.user = current_user

    respond_to do |format|
      if @item.save
        Statsd.increment("trivote.#{Rails.env}.items.create")
        format.html { redirect_to itemgroup_url(@item.itemgroup_id), notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  def vote_up
    begin
      current_user.vote_for(@item = Item.find(params[:id]))
      Statsd.increment("trivote.#{Rails.env}.votes.upvote")
      redirect_to itemgroup_url(params[:itemgroup_id])
    rescue ActiveRecord::RecordInvalid
      redirect_to itemgroup_url(params[:itemgroup_id])
    end
  end

  def vote_down
    begin
      current_user.vote_against(@item = Item.find(params[:id]))
      Statsd.increment("trivote.#{Rails.env}.votes.downvote")
      redirect_to itemgroup_url(params[:itemgroup_id])
    rescue ActiveRecord::RecordInvalid
      redirect_to itemgroup_url(params[:itemgroup_id])
    end
  end
end
