class Api::V1::LapTimesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lap_time, only: %i[ show update destroy ]
  respond_to :json

  # GET /lap_times
  def index
    @lap_times = LapTime.all

    # Filtering
    @lap_times = @lap_times.where(driver_id: params[:driver_id]) if params[:driver_id].present?
    @lap_times = @lap_times.where(circuit_id: params[:circuit_id]) if params[:circuit_id].present?
    @lap_times = @lap_times.where(lap_number: params[:lap_number]) if params[:lap_number].present?

    render json: @lap_times, each_serializer: LapTimeSerializer
  end

  # GET /lap_times/:id
  def show
    render json: @lap_time
  end

  # POST /lap_times
  def create
    @lap_time = LapTime.new(lap_time_params)

    if @lap_time.save
      render json: @lap_time, status: :created
    else
      render json: { errors: @lap_time.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lap_times/1
  def update
    if @lap_time.update(lap_time_params)
      render json: @lap_time
    else
      render json: { errors: @lap_time.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /lap_times/1
  def destroy
    @lap_time.destroy
    head :no_content
  end

  # GET /lap_times/fastest
  def fastest
    @fastest_lap = LapTime.order(time_ms: :asc).first
    if @fastest_lap
      render json: @fastest_lap, serializer: LapTimeSerializer
    else
      render json: { message: "No lap times found" }, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lap_time
      @lap_time = LapTime.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lap_time_params
      params.require(:lap_time).permit(:driver_id, :circuit_id, :lap_number, :time_ms)
    end
end
