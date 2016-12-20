json.(question, :id, :content)
json.answers question.answers, :id, :content, :correct
