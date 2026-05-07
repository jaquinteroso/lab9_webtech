class Pet < ApplicationRecord
  belongs_to :owner
  has_many :appointments, dependent: :destroy

  has_one_attached :photo

  before_save :capitalize_name

  validates :name, :owner, :date_of_birth, presence: true
  validates :species, inclusion: { in: %w[dog cat rabbit bird reptile other] }
  validates :weight, numericality: { greater_than: 0 }
  validate :date_of_birth_cannot_be_in_future

  validate :acceptable_photo

  scope :by_species, -> (species) { where(species: species) }

  private

  def date_of_birth_cannot_be_in_future
    if date_of_birth.present? && date_of_birth > Date.today
      errors.add(:date_of_birth, "can't be in the future")
    end
  end

  def capitalize_name
    self.name = name.capitalize if name.present?
  end

  def acceptable_photo
    return unless photo.attached?

    if photo.blob.byte_size > 5.megabytes
      errors.add(:photo, "is too big (maximum is 5 MB)")
    end

    acceptable_types = ["image/jpeg", "image/png", "image/webp"]
    unless acceptable_types.include?(photo.content_type)
      errors.add(:photo, "must be a JPEG, PNG or WebP")
    end
  end
end
