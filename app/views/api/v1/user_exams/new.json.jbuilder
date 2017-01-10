json.user_exam @user_exam, :id, :passed
json.exam do |json|
  json.partial! 'api/v1/exams/exam', exam: @exam
end

