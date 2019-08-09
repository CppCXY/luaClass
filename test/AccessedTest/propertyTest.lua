require "luaClass.init"
_ENV=namespace "test"
using_namespace "luaClass"

class ("PropertyTest"){
    property("Parent"){READ.getParent,WRITE.setParent};
    property("Order"){READ.getOrder};
    public{
        FUNCTION.PropertyTest(function(self)
            self._parent="parent"
            self._order=2
        end);
        FUNCTION.getParent(function(self)
            print("getter test")
            return self._parent
        end);

        FUNCTION.setParent(function(self,value);
            print("seeter test")
            self._parent=value
        end);
        FUNCTION.getOrder(function(self)
            print("getter order test")
            return self._order        
        end);

    };
    protected{
        MEMBER._parent();
        MEMBER._order();
        MEMBER._DATA();

    };
}

local pro=PropertyTest()
print(pro.Parent)
pro.Parent="parent parent"
print(pro.Parent)

--throw error test
--print(pro._parent)

local a=pro.Order
print(a)

--thorw error test
--pro.Order=998


local test=class ("test") {
    NO_AUTO_INHERIT();
    CLASS_DEBUG(false);
    super(PropertyTest);
}
function test:test(name)
    self:PropertyTest()
    self.name=name
end

local t=test()
print(t:getType())
print(t.Parent)
