require 'rails_helper'

RSpec.describe Lesson, type: :model do
  let!(:course) { FactoryGirl.create(:course)}
  let!(:lesson) { FactoryGirl.build(:lesson, course: course) }

  #test validations
  describe "save" do
    it "success" do
      expect(lesson.save).to eq true
    end

    it "fails without lesson name" do
      #question = FactoryGirl.build(:question, exam: exam)
      lesson.name = nil
      expect(lesson.save).to_not eq true
    end

    it "fails with too short name" do
      lesson.name = "na"
      expect(lesson.save).to_not eq true
      expect(lesson.errors.full_messages[0]).to eq("Name is too short (minimum is 5 characters)")
    end

    it "fails without description" do
      lesson.description = nil
      expect(lesson.save).to_not eq true
    end
  end
end
