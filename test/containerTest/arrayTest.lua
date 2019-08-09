require "luaClass.init"
require "test.containerTest.timeTest"
_ENV=namespace "test"
using_namespace "luaClass"
using_namespace "container"


local arr=array({1,2,3,4,5,6,8})
arr:for_each(function(k,v) print(k,v) end)
arr:push_back(998)
arr:push_back(11511)
arr:push_back(666)
print("--------")
arr:reverse():for_each(function(k,v) print(k,v) end)
print(arr:size())
print(arr:at(1),arr:at(2),arr:at(7))
arr:set(1,998)
arr:set(7,888)
print("--------")
for k,v in arr:iter() do
    print(k,v)
end
print("-----------")
local resv=arr:reverse()
for i,v1,v2 in arr:zip(resv) do
    print(i,v1,v2)
end
arr:merge(resv)
print(arr:size())
arr:merge({999,777,666,555,444,33,22})
print(arr:size())
print(arr:empty())
arr:clear()
print(arr:empty())
print("------push time test--------")

local count=1000000
local tarr=array()
local t={}
local t2={}
testTime(function()
    for i=1,count do
        t[i]=i
    end
end)
testTime(function()
    for i=1,count do
        tarr:push_back(i)
    end
end)
testTime(function()
    for i=1,count do
        t2[#t2+1]=i
    end
end)

--array 并没有卓绝的性能，但是提供了许多有意义的方法，使代码更具有维护性


