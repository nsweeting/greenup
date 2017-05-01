module Validators
  class PostalCode < ActiveModel::Validator
    COUNTRY_REGEX = {
      'CA' => /\A[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}\z/
    }.freeze

    def validate(record)
      return unless record.country.present?
      postal_regex = COUNTRY_REGEX[record.country.abbr]
      return unless postal_regex.present?
      return if !!(record.postal_code =~ postal_regex)
      record.errors.add(:postal_code, 'is invalid')
    end
  end
end
