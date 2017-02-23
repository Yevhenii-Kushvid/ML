require './lib/neural_network/neuron'

class Teacher
  def initialize(speed_of_teaching = 0.1)
    @speed_of_teaching = speed_of_teaching
  end

  # inputs  = Array of inputs
  # answers = Array of answers for questions(inputs)
  def teach(neuron, inputs, answers)

    if inputs.size == answers.size
      inputs.size.times { |iteration|

        # error = neuron.solv(inputs[iteration]) - answers[iteration]
        error = -2 * ( answers[iteration] - neuron.solv(inputs[iteration]))

        neuron.study(@speed_of_teaching, error)
      }
      true
    else
      return Exception.new('Amount of incoming inputs and answers are need to be eql.')
    end

  end

  def teach_matrix(neuron, problem, solved_problem)

    problem_points = get_asked_points(problem)
    problem_points.size.times { |iteration|
      row_number = problem_points[iteration][0]
      position_in_row = problem_points[iteration][1]

      error = neuron.solv([row_number, position_in_row]) - solved_problem[row_number][position_in_row]
      # error = -2 * ( solved_problem[row_number][position_in_row] - neuron.solv([row_number, position_in_row]))

      puts "ERROR = #{error}"
      neuron.study(@speed_of_teaching, error)
    }
    true

  end

  def test(neuron, inputs, answers)
    result = Array.new(inputs.size)

    if inputs.size == answers.size
      answers.size.times do |iteration|
        puts neuron.solv(inputs[iteration])
        # result[iteration] = neuron.solv(inputs[iteration]) == answers[iteration]
        result[iteration] = ((answers[iteration] - 0.1)..(answers[iteration] + 0.1)).include? neuron.solv(inputs[iteration])
      end
      result
    else
      return Exception.new('Amount of incoming inputs and answers are need to be eql.')
    end
  end

  # 0 - first class, 1 - second class, 2 - question
  def test_matrix(neuron, problem, solved_problem)
    #############################
    # check of neuron is valid
    # 2 inputs for position
    #############################
    # 1 input for image if grey
    # 3 inputs for image if colored without opacity
    # 4 inputs for image if colored with opacity
    #############################
    return Exception.new('Number of coordinates must be equal to number if inputs of neuron.') unless neuron.number_of_inputs == 2

    problem_points = get_asked_points(problem)

    result = Array.new(problem_points.count)
    result.length.times{ |iteration|
      row_number = problem_points[iteration][0]
      position_in_row = problem_points[iteration][1]

      result[iteration] = neuron.solv(problem_points[iteration]) == solved_problem[row_number][position_in_row]
      p "result = #{neuron.solv(problem_points[iteration])} == #{solved_problem[row_number][position_in_row]}"
    }
    result
  end

  def get_asked_points(problem)
    problem.collect {|row_number, position_hash|
      points = position_hash.collect { |position_in_row, value|
        [row_number, position_in_row] if value == 0
      }
      points if points.compact.count > 0
    }.flatten(1).compact
  end

end