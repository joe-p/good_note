module Patches
  module ObjectPatch
    def instance_variables_hash
      Hash[instance_variables.map { |name| [name.to_s.gsub('@', ''), instance_variable_get(name)] }]
    end
  end
end

class Object
  prepend Patches::ObjectPatch
end
