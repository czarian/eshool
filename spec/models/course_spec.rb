require 'rails_helper'

RSpec.describe Course, type: :model do
  let!(:course) { FactoryGirl.build(:course)}

  it 'save' do
    expect(course.save).to eq true
  end

  it 'fails without course name' do
    course.name = nil
    expect(course.save).to_not eq true
  end

  it 'fails if name has wrong format' do
    course.name = "name(*) %12"
    expect(course.save).to_not eq true
    expect(course.errors.full_messages[0]).to eq("Name is invalid")
  end

  it 'fails without course description' do
    course.description = nil
    expect(course.save).to_not eq true
  end

  it 'fails if description is too short' do
    course.description = "desc"
    expect(course.save).to_not eq true
    expect(course.errors.full_messages[0]).to eq("Description is too short (minimum is 10 characters)")
  end

  it 'fails if status is not sent' do
    course.status = nil
    expect(course.save).to_not eq true
  end

end
