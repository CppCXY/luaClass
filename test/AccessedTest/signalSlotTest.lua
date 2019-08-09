require "luaClass.init"
_ENV=namespace "test"
using_namespace "luaClass"

class ("SignalTest"){
    SINGAL.classCreate();
    public{
        FUNCTION.SignalTest(function(self,content)
            self._content=content
            connect(self,"classCreate",self,"hello")
            connect(self,"classCreate",self,"world")
            
            self:classCreate()
        
        end);
        FUNCTION.hello(function(self)
            print("hello",self._content)
        end);

        FUNCTION.world(function(self)
           print("world",self._content) 
        end)

    };
    protected{
        MEMBER._content();

    };
}
local instance1=SignalTest(996)
local instance2=SignalTest(966)
local instance3=SignalTest(965)
print(instance3:serilize())


