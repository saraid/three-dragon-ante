class ArithmeticProc < Proc
  include ThreeDragonAnte::Refinements::Inspection

  attr_accessor :operator, :value

  def inspectable_attributes
    %i( operator value )
  end
end

def cmp(operator, number_or_range)
  case operator
  when :between then ArithmeticProc.new { number_or_range.include? _1 }
  when :>=, :>, :<, :<=, :!= then ArithmeticProc.new { _1.send(operator, number_or_range) }
  else raise ArgumentError
  end.tap do |arithmetic_proc|
    arithmetic_proc.operator = operator
    arithmetic_proc.value = number_or_range
  end
end
