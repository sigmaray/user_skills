require 'rails_helper'

# TODO: Вынести повторяющийся код в shared example

RSpec.describe User, type: :model do
  let(:user_creation_params) do
    {
      name: "Bill",
      patronymic: "James",
      email: "Billhimself@yahoo.com",
      age: 74,
      nationality: "american",
      country: "US",
      gender: "male",
      surname: "Murray",
      skill_names: "acting, comedy",
      interest_names: "golf, baseball, music"
    }
  end

  describe "validation" do
    it "validates presence" do
      user_creation_params.each do |k, v|
        next if k.in?([ :skill_names, :interest_names ])
        user = User.new(user_creation_params.except(k))
        expect(user).not_to be_valid
        expect(user.errors.messages[k]).to include("can't be blank")
      end
    end

    it "validates age greater than 0" do
      user = User.new(age: 0)
      expect(user).not_to be_valid
      expect(user.errors.messages[:age]).to include("must be greater than 0")
    end

    it "validates age is less than 90" do
      user = User.new(age: 91)
      expect(user).not_to be_valid
      expect(user.errors.messages[:age]).to include("must be less than or equal to 90")
    end

    it "validates age is less than 90" do
      user = User.new(age: 91)
      expect(user).not_to be_valid
      expect(user.errors.messages[:age]).to include("must be less than or equal to 90")
    end

    it "validates gender is included in the list" do
      user = User.new(gender: 'agender')
      expect(user).not_to be_valid
      expect(user.errors.messages[:gender]).to include("is not included in the list")
    end

    context "when same user already exists" do
      before do
        User.create!(user_creation_params)
      end

      it "validates email uniqueness" do
        user = User.new(user_creation_params)
        expect(user).not_to be_valid
        expect(user.errors.messages[:email]).to include("has already been taken")
      end
    end
  end

  it "creates user, skills and interests" do
    user = User.create!(user_creation_params)
    expect(user).to be_persisted
    expect(user.skills.pluck(:name)).to eq([ "acting", "comedy" ])
    expect(user.interests.pluck(:name)).to eq([ "golf", "baseball", "music" ])
  end
end
