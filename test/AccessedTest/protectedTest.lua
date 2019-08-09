require "luaClass.init"
_ENV=namespace "test"
using_namespace "luaClass"

class ("ProtectedTest"){
    property ("Value"){READ.getValue };
    property ("Change") {WRITE.setProtected};
    public{
        STATICFUNC.getInstance(function(cls)
            if cls.s_instance==nil then
                cls.s_instance=cls()
            end
            return cls.s_instance
        end)
    };
    protected{
        FUNCTION.ProtectedTest(function(self)
            self._protected=998
            print(self.Value)
            self.Change=3344
            print(self._protected)
        end);
        FUNCTION.getValue(function(self)
            print("get _VALUE");
            return self._VALUE
        end);
        FUNCTION.setProtected(function(self,value)
            print("set _protected")
            self._protected=value
        end);
        MEMBER._protected();
        CONST._VALUE(7744);
        STATIC.s_instance();
    };
}

local pr=ProtectedTest:getInstance()
print(pr)
print(pr:serilize())
--throw error 
--local pr2=ProtectedTest()
--thorw error
--print(pr.Value)
--thorw error
--pr.Change=666;
