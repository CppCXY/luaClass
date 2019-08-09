require "luaClass.init"
_ENV=namespace "test"
using_namespace "luaClass"


--By default, all classes inherit directly or indirectly from LObject
class ("ObjectTest"){
    public{
        FUNCTION.ObjectTest(function(self)
            
        end)    

    };

}
local obj=ObjectTest()
--LObject overload the __concat and __tostring ,all call the tostring
print(obj,obj.."996",obj:toString())

print(obj:inherit(LObject))

print(is(1,LObject))

print(obj:getClassName())

print(obj:getNamespace())

print(obj:getMetaObject())