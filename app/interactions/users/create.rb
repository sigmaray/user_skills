class Users::Create < ActiveInteraction::Base
  string :surname, :name, :patronymic, :email, :nationality, :country
  integer :age
  string :gender
  string :interest_names
  string :skill_names

  validates :surname, :name, :patronymic, :email, :nationality, :country, presence: true
  validates :age, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 90 }
  validates :gender, presence: true, inclusion: { in: %w[male female] }

  def execute
    user = User.create(
      surname: surname,
      name: name,
      patronymic: patronymic,
      email: email,
      age: age,
      nationality: nationality,
      country: country,
      gender: gender,
      full_name: "#{surname} #{name} #{patronymic}"
    )

    return errors.merge!(user.errors) if user.invalid?

    set_interests(user)
    set_skills(user)

    user
  end

  private

  def set_interests(user)
    user.skills = skill_names.to_s.split(",").map do |name|
      Skill.where(name: name.strip).first_or_create!
    end
  end

  def set_skills(user)
    user.interests = interest_names.to_s.split(",").map do |name|
      Interest.where(name: name.strip).first_or_create!
    end
  end
end
