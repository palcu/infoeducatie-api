class Edition < ActiveRecord::Base
  has_many :contestants, dependent: :destroy
  has_many :news, dependent: :destroy
  has_many :talks, dependent: :destroy, inverse_of: :edition

  validates :name, presence: true, uniqueness: true
  validates :year, presence: true
  validates :motto, presence: true
  validates :camp_start_date, date: true
  validates :camp_end_date, date: true
  validates :registration_start_date, presence: true, date: true
  validates :registration_end_date, presence: true, date: true
  validates :travel_data_deadline, date: true
  validates :projects_forum_category, presence: true

  before_save do
    if current
      edition = Edition.get_current
      if not edition.nil? and edition != self
        edition.current = false
        edition.save!
      end
    end
  end

  def self.get_current
    where(current: true, published: true).first
  end

  rails_admin do
    list do
      field :year
      field :name
      field :published
      field :current
    end
    edit do
      configure :contestants do
        hide
      end
      configure :news do
        hide
      end
      configure :talks do
        hide
      end
    end
  end
end
