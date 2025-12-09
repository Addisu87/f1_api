module Api
  module V1
    class CircuitsController < ApplicationController
      before_action :set_circuit, only: %i[ show edit update destroy ]
      respond_to :json

      # GET /circuits or /circuits.json
      def index
        @circuits = Circuit.all
      end

      # GET /circuits/1 or /circuits/1.json
      def show
      end

      # GET /circuits/new
      def new
        @circuit = Circuit.new
      end

      # GET /circuits/1/edit
      def edit
      end

      # POST /circuits or /circuits.json
      def create
        @circuit = Circuit.new(circuit_params)

        respond_to do |format|
          if @circuit.save
            format.json { render :show, status: :created, location: @circuit }
          else
            format.json { render json: @circuit.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /circuits/1 or /circuits/1.json
      def update
        respond_to do |format|
          if @circuit.update(circuit_params)
            format.json { render :show, status: :ok, location: @circuit }
          else
            format.json { render json: @circuit.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /circuits/1 or /circuits/1.json
      def destroy
        @circuit.destroy!

        respond_to do |format|
          format.json { head :no_content }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_circuit
          @circuit = Circuit.find(params.require(:id))
        end

        # Only allow a list of trusted parameters through.
        def circuit_params
          params.require(circuit: [ :name, :location ])
        end
    end
  end
end
