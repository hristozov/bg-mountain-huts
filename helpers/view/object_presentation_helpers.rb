# encoding: utf-8
class ObjectPresentationHelpers
  def self.add
    helpers do
      def get_object_type(object)
        case object
          when Hut then "хижа"
          when Shelter then "заслон"
          else "друг обект"
        end
      end
    end
  end
end