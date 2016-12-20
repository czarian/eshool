require 'rails_helper'

RSpec.describe Question, type: :model do
    let!(:course) { FactoryGirl.create(:course)}
    let!(:exam) { FactoryGirl.create(:exam, course: course) }

  describe "save" do

    it "success" do
      question = FactoryGirl.build(:question, exam: exam)
      expect(question.save).to eq true
    end

  end

end
