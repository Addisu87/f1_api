module Api
  module V1
    class DriversController < ApplicationController
      before_action :set_driver, only: %i[ show edit update destroy ]
      respond_to :json

      # GET /drivers
      def index
        @drivers = Driver.all
        render json: drivers, each_serializer: DriverSerializer
      end

      # GET /drivers/1
      def show
        @driver = Driver.find(params[:id])
        render json: @driver
      end

      # POST /drivers
      def create
        @driver = Driver.new(driver_params)

        respond_to do |format|
          if @driver.save
            render json: @driver, status: :created
          else
            render json: { errors: @driver.errors }, status: :unprocessable_entity
          end
        end
      end

      # PATCH/PUT /drivers/1
      def update
        respond_to do |format|
          if @driver.update(driver_params)
            render json: @driver, status: :ok
          else
            render json: { errors: @driver.errors }, status: :unprocessable_entity
          end
        end
      end

      # DELETE /drivers/1
      def destroy
        @driver.destroy!

        respond_to do |format|
          format.json { head :no_content }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_driver
          @driver = Driver.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def driver_params
          params.require(:driver).permit(:name, :code,  :team, :country)
        end
    end
  end
end
