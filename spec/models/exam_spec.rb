require 'rails_helper'

RSpec.describe Exam, type: :model do

  let!(:course) { FactoryGirl.create(:course)}
  let!(:exam) { FactoryGirl.build(:exam, course: course) }

  describe "save" do

    it 'success' do
      expect(exam.save).to eq true
    end

    it 'fails without title' do
      exam.title = nil
      expect(exam.save).to_not eq true
    end

    it 'fails with title too short' do
      exam.title = "short"
      expect(exam.save).to_not eq true
      expect(exam.errors.full_messages[0]).to eq("Title is too short (minimum is 10 characters)")
    end

    it 'fails with title too long' do
      exam. title = "too long"*50
      expect(exam.save).to_not eq true
    end

  end

end
