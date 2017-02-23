# import lib
require './lib/neural_network/neuron'
require './lib/teacher'
require './lib/plotter'

# Get data
data = []
File.open('data/table.csv') do |file|
  basic_line = file.readline.split(',')[0..1]
  for line in file.readlines do
    data << line.chomp.split(',')[0..1]
  end
end

# Preprocess
days, prices = data.transpose
max_day = days.map { |day| day.split('-')[-1].to_i }.max
days.map! { |day| day.split('-')[-1].to_i + max_day * (day.split('-')[1].to_i - 1) }
prices.map! { |price| price.to_f }

# Display data
Plotter.plot :line, days, prices, './plots/data.html'

min, max = prices.minmax
prices.map! { |price| (price - min). / (max - min) }

questions = []
answers = []
prices.length.times do |iteration|
  last_week_prices = prices[iteration..(iteration+7)]
  break if last_week_prices.count < 8
  questions << last_week_prices[0..6]
  answers << last_week_prices[7]
end
puts questions.count

# Training
neuron = Neuron.new(7)
teacher = Teacher.new

p neuron

puts teacher.test(neuron, questions, answers)

10_000.times do
  teacher.teach(neuron, questions, answers)
  results_by_points = teacher.test(neuron, questions, answers)

  results_by_points.each {|point_result|
    result = false unless point_result
  }
end

# Testing
p neuron
puts teacher.test(neuron, questions, answers)

results = []
questions.each do |question|
  results << neuron.solv(question) * max
end

Plotter.plot :line, (1..answers.count).to_a, answers.map { |answer| answer  * max }.reverse, './plots/answers.html'
Plotter.plot :line, (1..results.count).to_a, results.reverse, './plots/results.html'

