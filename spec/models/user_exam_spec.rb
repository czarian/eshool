require 'rails_helper'

RSpec.describe UserExam, type: :model do
  let!(:course) { FactoryGirl.create(:course)}
  let!(:exam) { FactoryGirl.create(:exam, course: course) }
  let!(:questions) { FactoryGirl.create_list(:question, 5, exam: exam) }

  let!(:user_exam) { FactoryGirl.build(:user_exam, exam: exam) }

  describe "save" do

    it 'success' do
      expect(user_exam.save).to eq true
    end

    it 'saves user_exam with answers' do

      user_exam.save

      user_answers = []

        questions.each do |question|

          question.answers.each do |answer|
            if answer.correct == true
              user_answers << {"question_id" => question.id, "answer_id" => answer.id }
            end
          end
        end

      user_exam.user_answers_attributes = user_answers
      #update
      expect(user_exam.save).to eq true

    end

    it 'fails without answer_id' do
      user_exam.save

      user_answers = []

      questions.each do |question|

        question.answers.each do |answer|
          if answer.correct == true
            user_answers << {"question_id" => question.id}
          end
        end
      end
      user_exam.user_answers_attributes = user_answers
      #update
      expect(user_exam.save).to_not eq true
    end

    it 'fails with answer_id non integer' do
      user_exam.save

      user_answers = []

        questions.each do |question|

          question.answers.each do |answer|
            if answer.correct == true
              user_answers << {"question_id" => question.id, "answer_id" => "12answer.id" }
            end
          end
        end

      user_exam.user_answers_attributes = user_answers
      #update
      expect(user_exam.save).to_not eq true
    end

  end
end
