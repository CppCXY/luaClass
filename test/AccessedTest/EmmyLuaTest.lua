require "luaClass.init"
_ENV=namespace "test"
using_namespace "luaClass"

---@class EmmyLuaTest
local EmmyLuaTest=class "EmmyLuaTest" {
    public{
        FUNCTION.EmmyLuaTest;
        FUNCTION.get;
        FUNCTION.set;
    };
    protected{
        MEMBER.lua23333;
        MEMBER.lua996;
    }
}

function EmmyLuaTest:EmmyLuaTest()
    self.lua23333=996;
    self.lua996=9999;
end
---@return number
function EmmyLuaTest:get()
    return self.lua23333
end
---@param value number
---@return number
function EmmyLuaTest:set(value)
    return self.lua996
end

local emmy=EmmyLuaTest()

print(emmy:get())