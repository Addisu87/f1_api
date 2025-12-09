module Api
  module V1
    class DriversController < ApplicationController
      before_action :set_driver, only: %i[ show edit update destroy ]
      respond_to :json

      # GET /drivers or /drivers.json
      def index
        @drivers = Driver.all
        render json: drivers, each_serializer: DriverSerializer
      end

      # GET /drivers/1 or /drivers/1.json
      def show
        @driver = Driver.find(params[:id])
        render json: @driver
      end

      # GET /drivers/new
      def new
        @driver = Driver.new
      end

      # POST /drivers or /drivers.json
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

      # PATCH/PUT /drivers/1 or /drivers/1.json
      def update
        respond_to do |format|
          if @driver.update(driver_params)
            format.json { render :show, status: :ok, location: @driver }
          else
            format.json { render json: @driver.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /drivers/1 or /drivers/1.json
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
          params.require(:driver).permit(:name, :code, :country)
        end
    end
  end
end
