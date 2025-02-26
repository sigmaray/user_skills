class User < ApplicationRecord
  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  validates :surname, :name, :patronymic, :email, :age, :nationality, :country, :gender, presence: true
  validates :email, uniqueness: true
  validates :age, numericality: { greater_than: 0, less_than_or_equal_to: 90 }
  validates :gender, inclusion: { in: %w[male female] }

  def skill_names=(names)
    self.skills = names.split(",").map do |name|
      Skill.where(name: name.strip).first_or_create!
    end
  end

  def interest_names=(names)
    self.interests = names.split(",").map do |name|
      Interest.where(name: name.strip).first_or_create!
    end
  end
end
