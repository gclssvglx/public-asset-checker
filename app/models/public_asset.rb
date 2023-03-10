class PublicAsset < ApplicationRecord
  has_many :public_asset_statuses, dependent: :destroy

  validates :url, :validate_by, presence: true
  validates :url, url: true

  def validate_by_size?
    validate_by == "size"
  end

  def validate_by_version?
    validate_by == "version"
  end

  def latest_size
    public_asset_statuses.order(created_at: :desc).first.size
  end

  def self.sizes
    where(validate_by: "size")
  end

  def self.versions
    where(validate_by: "version")
  end
end
