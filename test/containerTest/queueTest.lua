require "luaClass.init"
require "test.containerTest.timeTest"
_ENV=namespace "test"

using_namespace "container"

local q=queue(50)

q:push_back(998)
print(q:front())
print(q:pop_front())
print(q:empty())
q:push_back(7766)
q:push_back(8877)

print(q:pop_front())
print(q:pop_front())
print(q:empty())

for i=1,50 do 
    q:push_back(i)
end
print(q:full())
print(q:empty())
print("-------性能测试----------")
local count=1000000
testTime(function()
    for i=1,count do
        if i%1==1 then
            q:push_back(i)
        else
            q:pop_front()
        end
    end
end)
print(q:empty())

----------其实这个性能非常高,虽然跟前面的测试时间上似乎差不多,循环队列的设计先天保证了没有rehash开销----------------
