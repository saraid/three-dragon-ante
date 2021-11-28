require 'forwardable'
module ThreeDragonAnte
  class Game
    class ListenableArray
      extend Forwardable

      def_delegators :@array, :last, :size

      def initialize
        @array = []
      end

      def <<(obj)
        (@array << obj).tap do
          @callback&.call(obj)
        end
      end

      def on_event(&callback)
        @callback = callback
      end
    end
  end
end
