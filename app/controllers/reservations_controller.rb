# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[show edit update]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /reservations or /reservations.json
  def index
    @guest_reservations = Reservation.where(guest_id: current_user).order(created_at: :desc)
    @host_reservations = Reservation.where(host_id: current_user).order(created_at: :desc)
    if params.key?(:status)
      @guest_reservations = Reservation.guest_status(params[:status], current_user)
      @host_reservations = Reservation.host_status(params[:status], current_user)
    end
  end

  # GET /reservations/1 or /reservations/1.json
  def show; end

  # GET /reservations/new
  def new
    @home = Home.find_by(id: params[:home])
    @reservation = Reservation.new
    @reservation.check_in = params[:check_in]
    @reservation.check_out = params[:check_out]
    redirect_to homes_path unless params.key?(:home)
  end

  # GET /reservations/1/edit
  def edit
    @home = @reservation.home
  end

  # POST /reservations or /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)
    
    @home = Home.find_by(id: @reservation.home_id)
    @reservation.guest = current_user
    @reservation.host = @home.user
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to reservation_url(@reservation), notice: 'Su reservación fue realizada correctamente' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    @reservation.status = 'pending'
    @home = Home.find_by(id: @reservation.home_id)
    respond_to do |format|
      if @reservation.update(reservation_params)
        create_notifications unless @reservation.finished?
        format.html { redirect_to reservation_url(@reservation), notice: 'Los datos de su reservación se actualizaron correctamente' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def reservation_params
    params.require(:reservation).permit(:home_id, :check_in, :check_out, :pets_number, :amount, :status)
  end

  def create_notifications
    if current_user == @reservation.guest
      msg = "#{current_user.name} realizo un cambio en su reservación"
      Notification.create(recipient: @reservation.host, notifiable: @reservation, text: msg)
    else
      msg = "#{current_user.name} actualizo el estado de la reservación"
      Notification.create(recipient: @reservation.guest, notifiable: @reservation, text: msg)
    end
  end
end
