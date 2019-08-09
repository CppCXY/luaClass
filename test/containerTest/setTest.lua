require "luaClass.init"
require "test.containerTest.timeTest"
_ENV=namespace "test"

using_namespace "container"

local s=set()
s:insert("998")
print(s:has(998))
print(s:has("998"))
s:del("998")
print(s:has("998"))
s:insert("xixixix")
s:insert("hahaha")
s:insert("yinyinyin")
s:for_each(function(k)
    print(k)
end)
print("------------")
s:del("yinyinyin")
for k in s:iter() do
    print(k)
end

