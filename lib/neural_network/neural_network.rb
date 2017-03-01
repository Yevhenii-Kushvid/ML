require './lib/neural_network/neuron'

class NeuralNetwork < Model
  attr_reader :structure, :input, :resut

  def initialize(number_of_inputs: 2, structure: [2, 1])
    @number_of_questions = number_of_inputs
    @structure = {}
    structure.size.times do |number_of_layer|
      @structure[number_of_layer] = []
      layer_amount = structure[number_of_layer]

      layer_amount.times do |index|
        if number_of_layer == 0
          @structure[number_of_layer] << Neuron.new(number_of_inputs: number_of_inputs)
        else
          @structure[number_of_layer] << Neuron.new(number_of_inputs: structure[number_of_layer - 1])
        end
      end
    end
  end

  def solv(question)
    @input = question.dup
    @result = []
    @structure.each do |_, layer|
      layer.each { |neuron_in_layer| @result << neuron_in_layer.solv(question) }
      question = @result
      @result = []
    end
    @result = question
  end

  def study(speed_of_study: @speed_of_study, question:, answer:)
    solv(question)
    back_propagation(answer: answer, speed_of_study: speed_of_study)
  end

  private
  def back_propagation(speed_of_study: 0.1, answer:)
    return Exception.new('Have not obtained answers ') unless answer

    @structure.size.times do |index|
      layer_index = @structure.size - index - 1
      layer = @structure[layer_index]

      # if it`s last layer
      if layer_index == (@structure.size - 1)
        layer.each_with_index do |neuron, neuron_index|
          answer = [answer] unless answer.kind_of? Array
          error = (answer[neuron_index] - neuron.result)

          neuron.study_by_error(speed_of_study: speed_of_study, error: error)
        end
      else
        layer.each_with_index do |neuron, neuron_index|
          error = 0.0
          next_layer = @structure[layer_index + 1]
          next_layer.each { |next_neuron, _| error += next_neuron.weights[neuron_index] * next_neuron.error }
          neuron.study_by_error(speed_of_study: speed_of_study, error: error)
        end
      end
    end
  end
end