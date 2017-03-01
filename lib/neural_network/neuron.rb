require './lib/kernel_functions/kernel_function'

class Neuron < Model
  attr_reader :number_of_inputs, :threshold, :kernel, :input, :result, :weights, :error

  def initialize(number_of_inputs: 0, threshold: 0.1, kernel: TanhKernelFunction)
    @threshold = threshold
    @number_of_inputs = number_of_inputs
    @weights = Array.new(@number_of_inputs) { rand() }
    @kernel = kernel

    @delta = 0
  end

  def solv(question)
    @input = question.dup
    sum = @threshold

    raise 'Number of inputs in question is wrong' unless question.size == @number_of_inputs

    @number_of_inputs.times { |iteration| sum += question[iteration] * @weights[iteration] }
    @result = @kernel.function(sum)
  end

  def study(speed_of_study: 0.1, question: @input, answer:)
    @error = calculate_error(question: question, answer: answer)
    study_by_error(speed_of_study: speed_of_study, error: @error)
  end

  def study_by_error(speed_of_study: 0.1, error:)
    @error = error
    vector_of_studying = error * speed_of_study * @kernel.derivation(@result)
    recalculate_weights(vector_of_studying: vector_of_studying)
  end

  private

  def calculate_error(question: @input, answer:)
    -2 * (solv(question) - answer.first)
  end

  def recalculate_weights(vector_of_studying:)
    @number_of_inputs.times do |iteration|
      @delta = vector_of_studying * @input[iteration] + @delta * 0.8
      @weights[iteration] += @delta
    end
    @threshold += vector_of_studying
  end
end