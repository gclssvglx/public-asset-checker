class PublicAssetsController < ApplicationController
  before_action :set_public_asset, only: %i[show edit update destroy]

  def index
    @public_assets = PublicAsset.all
  end

  def show
    @url = @public_asset.url
    statuses = @public_asset.public_asset_statuses

    dates = statuses.map(&:created_at)
    @labels = dates.map { |date| Date.parse(date.to_s).strftime("%d/%m/%Y") }

    if @public_asset.validate_by_size?
      @values = statuses.map(&:size)
    elsif @public_asset.validate_by_version?
      versions = statuses.map(&:version)
      @values = versions.map { |version| version.split("=").last.to_i }
    end
  end

  def new
    @public_asset = PublicAsset.new
  end

  def edit; end

  def create
    @public_asset = PublicAsset.new(public_asset_params)

    if @public_asset.save
      redirect_to public_asset_url(@public_asset), notice: "Public asset was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @public_asset.update(public_asset_params)
      redirect_to public_asset_url(@public_asset), notice: "Public asset was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @public_asset.destroy!

    redirect_to public_assets_url, notice: "Public asset was successfully destroyed."
  end

private

  def set_public_asset
    @public_asset = PublicAsset.find(params[:id])
  end

  def public_asset_params
    params.require(:public_asset).permit(:url, :validate_by)
  end
end
