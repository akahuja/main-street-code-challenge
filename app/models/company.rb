class Company < ApplicationRecord
  has_rich_text :description

  validates :email, uniqueness: true, format: {
    with: /\b[A-Z0-9._%a-z\-]+@getmainstreet\.com\z/,
    message: "must be a @getmainstreet.com domain based email"
  }, if: -> { email.present? }

  before_save :assign_city_state, if: -> { zip_code_changed? }

  private

  def assign_city_state
    zip_hash = ZipCodes.identify(zip_code)
    return if zip_hash.blank?

    self.city = zip_hash[:city]
    self.state = zip_hash[:state_code]
  end
end
