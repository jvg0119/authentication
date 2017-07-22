require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create!(name: "Joe", email: "joe@example.com", password: "password") }

  # Shoulda tests for name
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(3)}

  # Shoulda tests for email
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to allow_value("joe@example.com").for(:email) }

  # Shoulda tests for password
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  describe "attributes" do
    it "should have name and email attributes" do
      expect(user).to have_attributes(name: "Joe", email: "joe@example.com")
    end
    it "should format name" do
      user.name = "mike smith"
      user.save
      expect(user.name).to eq("Mike Smith")
    end
  end

  describe "invalid user" do
    let(:user_with_invalid_name) { User.new(name: "", email: "joe@example.com") }
    let(:user_with_invalid_email) { User.new(name: "Joe", email: "")}

    it "should be invalid without a name" do
      expect(user_with_invalid_name).to_not be_valid
    end
    it "should be invalid without an email" do
      expect(user_with_invalid_email).to be_invalid
    end
  end

end
