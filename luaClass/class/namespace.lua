
local string_gsub=string.gsub
local function split(str,sep)
    local rt= {}
    local size=1
    string_gsub(str, '[^'..sep..']+', function(w) rt[size]=w size=size+1 end )
    return rt
end
local namespace_function_table={} 
local using_namespace
local function namespace(nsName)
    nsName=nsName or "_G"
    local names=split(nsName,".")
    local index=1
    local lastNs=_G
    while(names[index]~=nil) do
        local name=names[index]
        if rawget(lastNs,name)==nil then
            local ns={}
            rawset(lastNs,name,ns)
            lastNs=ns
        else
            lastNs=rawget(lastNs,name)
        end
        index=index+1
    end
    local newNs={}
    local old=_G
    local meta={__ns=lastNs,_G=old,__usingtable={}}
    meta.__index=function (self,key )
        --优先保证本地命名空间变量先获取
        local res=rawget(meta.__ns,key)
        if res~=nil then return res end
        --然后保证using过的命名空间获取
        for _,using_table in old.pairs(meta.__usingtable) do
            --防止无限递归访问
            local res=rawget(using_table,key)
            if res~=nil then return res end
        end
        --然后再查找全局变量
        return rawget(meta._G,key)
    end
    meta.__newindex=function(self,k,v)
        rawset(meta.__ns,k,v)
    end
    old.setmetatable(newNs,meta)
    newNs.using_namespace=function (nsName)
        using_namespace(newNs,nsName)
    end
    for key,value in pairs(namespace_function_table) do
        rawset(newNs,key,function (...)
            return value(...,newNs,nsName)
        end)
    end
    if lastNs.__nsName==nil then
        --主要用于序列化
        lastNs.__nsName=nsName
    end
    if _VERSION =="Lua 5.1" then
        setfenv(2,newNs)
    end
    return  newNs
end

rawset(_G,"namespace",namespace)
rawset(_G,"__nsName","_G")

local function namespace_register(name,luaf)
    namespace_function_table[name]=luaf
end
rawset(_G,"namespace_register",namespace_register)
using_namespace=function(nsTable,nsName)
    local names=split(nsName,".")
    local index=1
    local __lastNs=_G
    while(names[index]~=nil) do
        local name=names[index]
        if rawget(__lastNs,name)==nil then
            local ns={}
            rawset(__lastNs,name,ns)
            __lastNs=ns
        else
            __lastNs=rawget(__lastNs,name)
        end
        index=index+1
    end
    local meta=getmetatable(nsTable)
    local using_table=meta.__usingtable
    using_table[nsName]=__lastNs
end


