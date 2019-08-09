require "luaClass.init"
_ENV=namespace "test"
using_namespace "luaClass"

class ("PublicTest"){
    public{
        FUNCTION.PublicTest(function(self)
            --thorw error
            --self.FIRST=996;

            self.SECOND=997;
        end);
        
        CONST.FIRST(3333);
        CONST.SECOND();
        STATIC.myStatic(996);
    };

}
local p=PublicTest()
print(p.FIRST)
print(p.SECOND)
print(p)
print(p.myStatic)
p.myStatic=966
local p2=PublicTest()
print(p.myStatic,p2.myStatic)
