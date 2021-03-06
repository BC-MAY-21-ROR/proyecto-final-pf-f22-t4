# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show]
  before_action :authenticate_user!
  # load_and_authorize_resource

  # GET /reviews or /reviews.json
  def index
    @home = Home.find(params[:id])
    @reviews = Review.where(home: @home)
  end

  # GET /reviews/1 or /reviews/1.json
  def show; end

  # GET /reviews/new
  def new
    @reservation = Reservation.find_by(id: params[:reservation])
    @review = Review.new
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)
    @reservation = Reservation.find_by(id: @review.reservation_id)
    respond_to do |format|
      if @review.save
        format.html { redirect_to reservations_url(), notice: 'Su comentario se registro correctamente' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = Review.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def review_params
    params.require(:review).permit(:score, :comment, :home_id, :guest_id, :reservation_id)
  end
end
