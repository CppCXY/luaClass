require "luaClass.init"
require "test.containerTest.timeTest"
_ENV=namespace "test"

using_namespace "container"

local arrData=array({1,2,3,4,5,6,7,8,9,10})
local gf=graph(arrData)

local v1={1,1,1,}
local v2={2,3,4,}
gf:setEdge(v1,v2)

local v1={2,3,4,4}
local v2={10,9,8,5}
gf:setEdge(v1,v2)

local v1={5,6}
local v2={6,7}
gf:setEdge(v1,v2)


local re=gf:DFS(1)
for _,v in re:iter() do
    print(v)
end
re=gf:BFS(1)
print("----------------------")
for _,v in re:iter() do
    print(v)
end