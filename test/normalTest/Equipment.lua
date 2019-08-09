require "luaClass.init"
require "test.normalTest.Item"

_ENV=namespace "battle"
using_namespace "luaClass"

class ("Equipment"){
    super(Item);
    public{
        FUNCTION.Equipment(function(self,name,attack,defence)
            -- base constructor
            self:Item(name,1)
            self.attack=attack
            self.defence=defence
        end);
        --override super's method showInfo
        FUNCTION.showInfo(function(self)
            --call super's method
            local super=self.__super
            super.showInfo(self)
            print(self.attack,self.defence)
        
        end);

    };
    protected{
        MEMBER.attack();
        MEMBER.defence();
    };

}

