class Ability
  include CanCan::Ability

  def initialize(user, params)

    user ||= User.new # guest user (not logged in)

    if user.role =="admin"
        can :manage, :all
    elsif user.role == "regullar"

      can :read, [Answer,Course,Lesson,Question,User]

      can :read, Exam, :status => 2, :course_id => params[:course_id]

      can :create, UserExam
      can :update, UserExam, :user_id => user.id
      can :index, UserExam, :user_id => user.id, :exam_id => params[:exam_id]
      can :show, UserExam, :user_id => user.id

      #can :read, :all
    end
  end
end
