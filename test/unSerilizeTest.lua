require "test.normalTest.Role"

_ENV=namespace "test"

using_namespace "luaClass"

local file=io.open('test/__serilizeResult.lua','rb')
if not file then return end


local str=file:read("a")
local obj=unSerilize(str)
print(obj:serilize())


