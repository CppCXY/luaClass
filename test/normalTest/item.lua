require "luaClass.init"


_ENV=namespace "battle"

using_namespace "luaClass"

class ("Item"){
    public{
        FUNCTION.Item(function(self,name,number)
            self.name=name
            self.number=number
        end);

        FUNCTION.showInfo(function(self)
            print(self.name,self.number)
        end);

    };
    public{
        MEMBER.name();
        MEMBER.number();
    };
}


