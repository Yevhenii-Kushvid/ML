require './lib/kernel_functions/kernel_function'

class SignumKernelFunction < KernelFunction
  def self.function(x)
    x >  0 ? 1 : 0
  end

  def self.derivation(x)
    raise 'Derivation doesn`t exists.'
  end
end