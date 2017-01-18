require 'rails_helper'

RSpec.describe Question, type: :model do
    let!(:course) { FactoryGirl.create(:course)}
    let!(:exam) { FactoryGirl.create(:exam, course: course) }
    let!(:question) { FactoryGirl.build(:question, exam: exam) }

  describe "save" do

    it "success" do
      #question = FactoryGirl.build(:question, exam: exam)
      expect(question.save).to eq true

    end

    it "fails without question content" do
      #question = FactoryGirl.build(:question, exam: exam)
      question.content = nil
      expect(question.save).to_not eq true
    end

    it "fails without answers" do
      #question = FactoryGirl.build(:question, exam: exam)
      q = Question.new
      q.content = question.content
      q.exam_id = exam.id
      expect(q.save).to_not eq true
      q.errors.as_json
      expect(q.errors.full_messages[0]).to eq("Answers can't be blank")
    end

    it "fails creating question with to short content" do
      question.content = "con"
      expect(question.save).to_not eq true
      expect(question.errors.full_messages[0]).to eq("Content is too short (minimum is 5 characters)")
    end

    it "fails creating question with to long content" do
      question.content = "con" * 255
      expect(question.save).to_not eq true
      expect(question.errors.full_messages[0]).to eq("Content is too long (maximum is 255 characters)")
    end


  end

end
