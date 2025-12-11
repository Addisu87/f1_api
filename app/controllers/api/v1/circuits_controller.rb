class Api::V1::CircuitsController < Api::V1::BaseController
  before_action :set_circuit, only: %i[ show update destroy ]

    # GET /circuits or /circuits.json
    def index
      @circuits = Circuit.all
      render json: @circuits, each_serializer: CircuitSerializer
    end

    # GET /circuits/1 or /circuits/1.json
    def show
      render json: @circuit
    end

    # POST /circuits or /circuits.json
    def create
      @circuit = Circuit.new(circuit_params)

      if @circuit.save
        render json: @circuit, status: :created
      else
        render json: { errors: @circuit.errors }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /circuits/1 or /circuits/1.json
    def update
      if @circuit.update(circuit_params)
        render json: @circuit
      else
        render json: { errors: @circuit.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /circuits/1 or /circuits/1.json
    def destroy
      @circuit.destroy!
      head :no_content
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_circuit
        @circuit = Circuit.find(params.require(:id))
      end

      # Only allow a list of trusted parameters through.
      def circuit_params
        params.require(:circuit).permit(:name, :location, :length_km)
      end
end
