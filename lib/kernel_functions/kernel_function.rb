class KernelFunction
  def self.function(x)
    raise 'Implement function'
  end

  def self.derivation(x)
    raise 'Implement derivation'
  end
end

require './lib/kernel_functions/tanh_kernel_function'
require './lib/kernel_functions/sin_kernel_function'
require './lib/kernel_functions/rb_kernel_function'
require './lib/kernel_functions/signum_kernel_function'