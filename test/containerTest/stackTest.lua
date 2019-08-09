require "luaClass.init"
require "test.containerTest.timeTest"
_ENV=namespace "test"

using_namespace "container"

local st=stack()
st:push(1)
print(st:empty())
print(st:pop())
print(st:empty())
print("---------------------")
st:push(998)
st:push(8877)
print(st:top())
print(st:pop())
print(st:top())
print("----性能测试---------")

local count=1000000
st=stack()
testTime(function()
    for i=1,count do 
        if i%2==1 then
            st:push(i)
        else
            st:pop()
        end
    end
end)
print(st:size())
print(st:top())

--较高的抽象程度,其实绝大部分开销都来自于函数调用,性能还算可以