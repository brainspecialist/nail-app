class PolishesController < ApplicationController
  before_action :set_polish, only: [:show, :edit, :update, :destroy]
  before_action :owned, only: [:index, :brand, :color_family]

  # GET /polishes
  # GET /polishes.json
  def index
    @polishes = Polish.all.order(:name).page(params[:page])
  end

  def brand
    @polishes = Polish.where(brand: params[:brand]).order(:name).page(params[:page])
    @brand = params[:brand]
  end

  def color_family
    @polishes = Polish.where(color: params[:color]).order(:hex).page(params[:page])
    @color = params[:color]
  end

  # GET /polishes/1
  # GET /polishes/1.json
  def show
  end

  # GET /polishes/new
  def new
    @polish = Polish.new
  end

  # GET /polishes/1/edit
  def edit
  end

  def owned
    if user_signed_in?
      @owned = UserPolish.where(user_id: current_user.id).pluck(:polish_id)
    end
  end

  def collection
    @user = User.find(params[:id])
    @collection = UserPolish.where(user_id: @user.id)
  end

  def add_to_collection
    current_user.user_polishes.create(polish_id: params[:polish_id])
    redirect_back(fallback_location: root_path)
  end

  def remove_from_collection
    current_user.user_polishes.where(polish_id: params[:polish_id]).destroy_all
    redirect_back(fallback_location: root_path)
  end

  # POST /polishes
  # POST /polishes.json
  def create
    @polish = Polish.new(polish_params)

    respond_to do |format|
      if @polish.save
        format.html { redirect_to @polish, notice: 'Polish was successfully created.' }
        format.json { render :show, status: :created, location: @polish }
      else
        format.html { render :new }
        format.json { render json: @polish.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /polishes/1
  # PATCH/PUT /polishes/1.json
  def update
    respond_to do |format|
      if @polish.update(polish_params)
        format.html { redirect_to @polish, notice: 'Polish was successfully updated.' }
        format.json { render :show, status: :ok, location: @polish }
      else
        format.html { render :edit }
        format.json { render json: @polish.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polishes/1
  # DELETE /polishes/1.json
  def destroy
    @polish.destroy
    respond_to do |format|
      format.html { redirect_to polishes_url, notice: 'Polish was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_polish
      @polish = Polish.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def polish_params
      params.require(:polish).permit(:name, :brand, :hex, :color)
    end
end
