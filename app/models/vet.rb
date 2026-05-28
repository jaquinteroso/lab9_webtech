class Vet < ApplicationRecord
  belongs_to :user, optional: true
  has_many :appointments, dependent: :destroy

  validates :first_name, :last_name, :specialization, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :by_specialization, ->(specialization) { where(specialization: specialization) }
end
