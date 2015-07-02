class Contestant < ActiveRecord::Base
  belongs_to :edition
  belongs_to :user

  has_many :colaborators
  has_many :projects, through: :colaborators, inverse_of: :contestants

  accepts_nested_attributes_for :colaborators,
    :reject_if => :all_blank,
    :allow_destroy => true
  accepts_nested_attributes_for :projects

  validates :edition, presence: true

  validates :address, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :country, presence: true
  validates :zip_code, presence: true

  validates :sex, presence: true
  validates :sex, numericality: { only_integer: true,
                                  greater_than_or_equal_to: 1,
                                  less_than_or_equal_to: 3}

  validates :cnp, presence: true
  validates :id_card_type, presence: true
  validates :id_card_number, presence: true

  validates :phone_number, presence: true
  validates :date_of_birth, presence: true, date: true

  validates :school_name, presence: true
  validates :grade, presence: true
  validates :school_county, presence: true
  validates :school_city, presence: true
  validates :school_country, presence: true

  validates :mentoring_teacher_first_name, presence: true
  validates :mentoring_teacher_last_name, presence: true

  validates :accompanying_teacher_first_name, presence: true
  validates :accompanying_teacher_last_name, presence: true

  def sex_enum
    [ [ :male, 1 ], [ :female, 2 ], [ :undisclosed, 3 ] ]
  end

  def name
    user.name
  end

  rails_admin do
    list do
      field :name
      field :school_name
    end
  end
end
