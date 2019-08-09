include "luaClass.class.namespace"

_ENV=namespace "luaClass"

function is(self,classObject)
    local ctype=type(classObject)
    local stype=type(self)
    if ctype~="table" then return stype==ctype end
    local tname=classObject.__cname    
    if (stype=="table" or stype=="userdata") and self.__class  then
        return  self.__class==classObject or self:inherit(classObject)
    end 
    return false
end

function connect(source,signalName,target,slotName)
    assert(signalName~=nil,"error : param signalName is nil")
    assert(slotName~=nil,"error : param slotName is nil")
    if type(slotName)=="string" then
        assert(target[slotName]~=nil,"error : slot function "..slotName.." not exit") 
    end
    if type(signalName)=="string" then
        assert(source[signalName]~=nil,"error : signal "..signalName.." not exit")
    end
    source[signalName].slots[slotName]=target
end

function inheritInstance(self,classInstance)
    local metatable=getmetatable(self)
    if metatable then
        local __index=metatable.__index
        if __index then
            if type(__index)=="table" then
                metatable.__index=function (self,key)
                    local result=__index[key] 
                    if result~=nil then return result end
                    return classInstance[key]
                end
            elseif type(__index)=="function" then
                metatable.__index=function(self,key)
                    local result=__index(self,key) 
                    if result~=nil then return result end
                    return classInstance[key]
                end
            else
                error("error: wrong code __index must be table or function")
            end
        else
            metatable.__index=classInstance
        end
    else
        setmetatable(self,{__index=classInstance})
    end
end