require './lib/kernel_functions/kernel_function'

class SinKernelFunction < KernelFunction
  def self.function(x)
    Math::sin(x)
  end

  def self.derivation(x)
    Math::cos(x)
  end
end