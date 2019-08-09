include "luaClass.container.array"
include "luaClass.container.set"
include "luaClass.container.queue"

_ENV=namespace "container"
using_namespace "luaClass"

---@class graph
local graph=class ("graph"){
    public{
        --此数据结构要求给出顶点数组或者表
        FUNCTION.graph;
        --设置一个顶点到另一个顶点的边，
        --ver1是一个表或者数组
        --ver2是一个表或者数组
        --dir代表方向true代表有向，false代表无向
        FUNCTION.setEdge;

        --level 如果为0就执行完整的搜索，否则就执行指定层数的搜索
        FUNCTION.BFS;

        FUNCTION.DFS;

    };
    protected{
        FUNCTION.dfs;

        MEMBER._data();
        MEMBER._edges();
    }
}

function graph:graph(data)
    local _data=is(data,array) and data or array(data)
    self._data=_data
    local edges=array()

    for i=1,_data:size() do
        edges:set(i,set())
    end
    self._edges=edges
end


function graph:setEdge(ver1,ver2,dir)
    ver1=is(ver1,array) and ver1 or array(ver1)
    ver2=is(ver2,array) and ver2 or array(ver2)
    dir=not not dir
    local edges=self._edges
    for _,v1,v2 in ver1:zip(ver2) do
        edges:at(v1):insert(v2)
        if not dir then edges:at(v2):insert(v1) end
    end
end

function graph:BFS(startVertexNum,level)
    --结果数组
    local result=array()

    local size=self._data:size()
    --顶点队列
    local verQueue=queue(size,{startVertexNum})
    --访问过的顶点集
    local accessedSet=set({startVertexNum})
    
    local count1=1
    local count2=0
    local _level=0
    while not verQueue:empty() do
        --弹出队列前部
        local front=verQueue:pop_front()
        result:push_back(self._data:at(front))

        for k,_ in self._edges:at(front):iter() do
            if not accessedSet:has(k) then
                verQueue:push_back(k)
                accessedSet:insert(k)
                count2=count2+1
            end
        end
        --level 非0 才采用
        if level~=0 then
            --记录层级
            count1=count1-1
            if count1==0 then
                --层级增加
                count1=count2
                count2=0
                _level=_level+1
                if _level==level then
                    while not verQueue:empty() do
                        local front=verQueue:pop_front()
                        result:push_back(self._data:at(front))
                    end
                    break
                end
            end
        end
    end
    return result
end

function graph:DFS(startVertexNum)
    --结果数组
    local result=array({self._data:at(startVertexNum)})
    --访问过的顶点集
    local accessedSet=set({startVertexNum})
    self:dfs(startVertexNum,self._data,self._edges,accessedSet,result)
    return result
end


function graph:dfs(startVertexNum,verArr,edges,accessedSet,result)
    for k,_ in edges:at(startVertexNum):iter() do
        if not accessedSet:has(k) then
            --这样写是降低递归深度
            accessedSet:insert(k)
            result:push_back(verArr:at(k))
            self:dfs(k,verArr,edges,accessedSet,result)
        end
    end
end



