require 'rails_helper'

# TODO: Вынести повторяющийся код в shared example

RSpec.describe Users::Create do
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
        user =  Users::Create.run(user_creation_params.except(k))
        expect(user).not_to be_valid
        expect(user.errors.messages[k].first.in?([ "is required", "can't be blank" ])).to be_truthy
      end
    end

    it "validates age greater than 0" do
      user = Users::Create.run(user_creation_params.merge(age: 0))
      expect(user).not_to be_valid
      expect(user.errors.messages[:age]).to include("must be greater than 0")
    end

    it "validates age is less than 90" do
      user = Users::Create.run(user_creation_params.merge(age: 91))
      expect(user).not_to be_valid
      expect(user.errors.messages[:age]).to include("must be less than or equal to 90")
    end

    it "validates gender is included in the list" do
      user = Users::Create.run(user_creation_params.merge(gender: 'agender'))
      expect(user).not_to be_valid
      expect(user.errors.messages[:gender]).to include("is not included in the list")
    end

    context "when same user already exists" do
      before do
        User.create!(user_creation_params)
      end

      it "validates email uniqueness" do
        user = Users::Create.run(user_creation_params)
        expect(user).not_to be_valid
        expect(user.errors.messages[:email]).to include("has already been taken")
      end
    end
  end

  it "creates user, skills and interests" do
    user = Users::Create.run!(user_creation_params)
    expect(user).to be_persisted
    expect(user.full_name).to eq("#{user_creation_params[:surname]} #{user_creation_params[:name]} #{user_creation_params[:patronymic]}")
    expect(user.skills.pluck(:name)).to eq([ "acting", "comedy" ])
    expect(user.interests.pluck(:name)).to eq([ "golf", "baseball", "music" ])
  end
end
