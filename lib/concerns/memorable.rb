module Memorable
    module ClassMethods
        def reset_all
            self.all.clear
        end

        def create(name)
            self.new(name).tap{|a| a.save}
        end
    end
end