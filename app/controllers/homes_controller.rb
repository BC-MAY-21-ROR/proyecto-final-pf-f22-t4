# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  load_and_authorize_resource

  # GET /homes or /homes.json
  def index
    @homes = params.key?(:filter) ? Home.search_filter(params[:filter]) : Home.all
  end

  # GET /homes/1 or /homes/1.json
  def show; end

  # GET /homes/new
  def new
    @home = Home.new
  end

  # GET /homes/1/edit
  def edit
    delete_attachment(params[:photo_id]) if params.key?(:photo_id)
  end

  # POST /homes or /homes.json
  def create
    @home = Home.new(home_params)
    @home.user = current_user

    respond_to do |format|
      if @home.save
        format.html { redirect_to home_url(@home), notice: 'Home was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /homes/1 or /homes/1.json
  def update
    respond_to do |format|
      if @home.update(home_params)
        format.html { redirect_to home_url(@home), notice: 'Home was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /homes/1 or /homes/1.json
  def destroy
    @home.destroy

    respond_to do |format|
      format.html { redirect_to homes_url, notice: 'Home was successfully destroyed.' }
    end
  end

  def delete_attachment(photo_id)
    attachment = ActiveStorage::Attachment.find(photo_id)
    attachment.purge
    redirect_to edit_home_url(@home)
  end

  private

  # Only allow a list of trusted parameters through.
  def home_params
    params.require(:home).permit(:title, :address, :description, :price, :score, :user_id, :filter, photos: [])
  end
end
