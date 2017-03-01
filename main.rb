# import lib

require './lib/model'
require './lib/neural_network/neuron'
require './lib/neural_network/neural_network'
require './lib/teacher'
require './lib/plotter'

############################################# Get data
data = []
File.open('data/apple_prices.csv') do |file|
  basic_line = file.readline.split(',')[0..1]
  for line in file.readlines do
    data << line.chomp.split(',')[0..1]
  end
end

############################################# Preprocess
days, prices = data.transpose
max_day = days.map { |day| day.split('-')[-1].to_i }.max
days.map! { |day| day.split('-')[-1].to_i + max_day * (day.split('-')[1].to_i - 1) }
prices.map! { |price| price.to_f }

############################################# Display data
Plotter.plot :line, days, prices, './plots/data.html'

min, max = prices.minmax
prices.map! { |price| (price - min). / (max - min) }

questions = []
answers = []
prices.length.times do |iteration|
  last_week_prices = prices[iteration..(iteration+7)]
  break if last_week_prices.count < 8
  questions << last_week_prices[0..6]
  answers << [last_week_prices[7]]
end
# puts questions.count

############################################# Training
neuron = Neuron.new(number_of_inputs: 7)
teacher = Teacher.new(max_error_level: 0.05)

10_000.times do |iteration|
  teacher.teach(model: neuron, questions: questions, answers: answers)
  teacher.test(model: neuron, questions: questions, answers: answers)
  print '.' if iteration % 1000 == 0
end
puts "\n==============================================="
############################################# Testing
puts teacher.test(model: neuron, questions: questions, answers: answers)

results = []
questions.each do |question|
  results << neuron.solv(question) * (max + min)
end

Plotter.plot :line, (1..answers.count).to_a, answers.map { |answer| answer.first  * max }.reverse, './plots/answers.html'
Plotter.plot :line, (1..results.count).to_a, results.reverse, './plots/results.html'

###################################################################################################################
neural_network = NeuralNetwork.new(number_of_inputs: 7, structure: [4, 1])

10_000.times do |iteration|
  teacher.teach(model: neural_network, questions: questions, answers: answers)
  teacher.test(model: neural_network, questions: questions, answers: answers)
  print '.' if iteration % 1000 == 0
end
puts "\n==============================================="
puts teacher.test(model: neural_network, questions: questions, answers: answers)

results = []
questions.each do |question|
  results << neural_network.solv(question).first * max
end

Plotter.plot :line, (1..results.count).to_a, results.reverse, './plots/nn_results.html'