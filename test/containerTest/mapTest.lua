require "luaClass.init"
require "test.containerTest.timeTest"
_ENV=namespace "test"

using_namespace "container"

local m=map()
m:insert("998","yinyinyin")
print(m:has(998))
print(m:has("998"))
m:del("998")
print(m:has("998"))
m:insert("xixixix","11511")
m:insert("hahaha","yinyinyin")
print(m:get("xixixix"))
print(m:get("11511","wuwuwuwuwuw"))



m:for_each(function(k,v)
    print(k,v)
end)
print("------------")
m:del("yinyinyin")
for k,v in m:iter() do
    print(k,v)
end

