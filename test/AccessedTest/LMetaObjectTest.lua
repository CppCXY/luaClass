require "luaClass.init"
_ENV=namespace "test"
using_namespace "luaClass"

class ("metaTest") {
    property("Time"){READ.getTime;WRITE.setTime};
    public{ 
        FUNCTION.getTime(function(self) end);
        FUNCTION.setTime(function(self) end);
        FUNCTION.Do(function(self) end);
        FUNCTION.you(function(self) end);
        FUNCTION.want(function(self) end);
        FUNCTION.nine(function(self) end);
        FUNCTION.nine(function(self) end);
        FUNCTION.six(function(self) end);
        --         ?
        MEMBER.no();
        MEMBER.I();
        MEMBER.need();
        MEMBER.rest();

        CONST.NINE();
        CONST.SIX();
        CONST.FIVE();
        --      ?
        STATIC.good();

        STATICFUNC.getInstance(function(cls)
            if cls.s_instance==nil then
                cls.s_instance=cls()
            end
            return cls.s_instance
        end);
    };
    protected{
        FUNCTION.metaTest(function(self) 
            self.name="metaTest"
        end);
        STATIC.s_instance();
        CONST.name();
    };
}
local instance=metaTest:getInstance()
---@type LMetaObject
local meta=instance:getMetaObject()

local printList=function(preStr,t) print("----------",preStr) for _,str in pairs(t) do print(str) end end

printList("publicFunction",meta:getPublicFunctionList())

printList("property",meta:getPropertyList())

printList("metaMethod",meta:getMetaMethodList())

printList("protectedConst",meta:getProtectedConstList())

printList("protectedFunction",meta:getProtectedFunctionList())

printList("protectedStatic",meta:getProtectedStaticList())

printList("publicConst",meta:getPublicConstList())

printList("publicMember",meta:getPublicMemberList())

printList("staticFunction",meta:getStaticFunctionList())


