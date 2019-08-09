require "luaClass.init"
_ENV=namespace "test"
using_namespace "luaClass"

class ("baseClass"){
    public {
        FUNCTION.baseClass(function(self)
        end);
        FUNCTION.speak(function(self)
            print("base speak");
        end);
        FUNCTION.speak2(function(self)
            print("base speak2");
        end)
    };
}
class ("baseClass2"){
    public{
        FUNCTION.baseClass2(function(self)
            self._fff=996
        end);
        FUNCTION.say(function(self)
            print(self._fff.." is your reward")
        end);
    };
    protected{
        MEMBER._fff();

    }
}

class ("subclass"){
    super(baseClass,baseClass2);
    public{
        FUNCTION.subclass(function(self)
            --call base1 class ctor
            self:baseClass()
            --call base2 class ctor
            self:baseClass2()
        end);
        FUNCTION.speak(function(self)
            
            print("subclass speak");
        end);
        FUNCTION.say(function(self)
            print("hello world")
            self:getSuperMethod("baseClass2","say")(self)
        end);
    }

}

local base =baseClass()
base:speak()
base:speak2()

local sub=subclass()
sub:speak()
sub:speak2()
sub:say()

