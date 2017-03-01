require './lib/kernel_functions/kernel_function'

class TanhKernelFunction < KernelFunction
  def self.function(x)
    Math::tanh(x)
  end

  def self.derivation(x)
    # 1.0 / Math::cosh(x)
    1 - Math::tanh(x) ** 2
  end
end