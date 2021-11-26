module ThreeDragonAnte
  module Refinements
    module Inspection
      def inspect
        postamble = ''
        if respond_to?(:inspectable_attributes)
          postamble << inspectable_attributes
            .map { |attr| "@#{attr}=#{instance_variable_get(:"@#{attr}").inspect}" }
            .join(', ')
            .prepend(' ')
        end
        if respond_to?(:custom_inspection)
          postamble << custom_inspection
            .to_s
            .lstrip
            .yield_self { |str| str.empty? ? '' : str.prepend(' ') }
        end

        "#<#{self.class}:#{'0x%x' % (object_id << 1)}#{postamble}>"
      end
    end
  end
end
