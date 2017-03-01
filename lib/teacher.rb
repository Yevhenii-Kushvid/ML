require './lib/neural_network/neuron'
require 'matrix'

class Teacher
  attr_accessor :speed_of_teaching, :max_error_level

  def initialize(speed_of_teaching: 0.1, max_error_level: 0.0)
    @speed_of_teaching = speed_of_teaching
    @max_error_level = max_error_level
  end

  def teach(model: nil, questions:, answers:)
    check_input_data(model, questions, answers)

    # Initiate study on model
    questions.each_with_index do |question, index|
      # One question and answer for it
      model.study(question: question, answer: answers[index], speed_of_study: @speed_of_teaching)
    end
    true
  end

  def test(model: nil, questions:, answers:)
    check_input_data(model, questions, answers)
    result = Array.new(questions.size)

    answers.each_with_index do |real_answer, iteration|
      our_answer = model.solv(questions[iteration])
      our_answer = [our_answer] unless our_answer.kind_of? Array

      result[iteration] = (Vector[*our_answer] - Vector[*real_answer])
                              .to_a.inject(0){|sum, n| sum + n.abs} < @max_error_level
    end
    result.count(true).to_f / result.count
  end

  private

  def check_input_data(model, questions, answers)
    raise "Model shoud be present and kind of ML::Model: #{model.class.ancestors}" unless !model.nil? && model.kind_of?(Model)
    raise 'Need questions and answers for study self' if questions.empty? or answers.empty?
    raise 'The number of questions should be equal to the number of answers' unless questions.size == answers.size
  end
end