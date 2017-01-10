json.exam_header exam, :id, :title, :status
json.questions exam.questions, partial: 'api/v1/questions/question', as: :question

