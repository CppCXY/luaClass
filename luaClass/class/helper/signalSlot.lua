include "luaClass.class.namespace"
_ENV=namespace "luaClass"


LSINGAL={}
LSINGAL.__index=function(self,key)
    --donot check the param ,It's not necessary
    return function(...)
        return LSINGAL_INSTANCE:new(key)
    end
end
SINGAL={}
setmetatable(SINGAL,LSINGAL)

LSINGAL_INSTANCE={}
LSINGAL_INSTANCE.__index=LSINGAL_INSTANCE

function LSINGAL_INSTANCE:new(key)
    local obj={
        key=key
    }
    setmetatable(obj,self)
    return obj
end

function LSINGAL_INSTANCE:implement(classObject)
    classObject.__decl[self.key]="publicConst"
    classObject.__signals[self.key]=true
end

LSIGNAL_IMPLEMENT={__cname="LSIGNAL_IMPLEMENT"}
LSIGNAL_IMPLEMENT.__index=LSIGNAL_IMPLEMENT
LSIGNAL_IMPLEMENT.__nsName="luaClass"
LSIGNAL_IMPLEMENT.__call=function(self,source,...)
    for slotName,target in pairs(self.slots) do
        
        if slotName~="__class" then
            local ctype=type(slotName)
            if ctype=="string" then
                target[slotName](target,...)
            elseif ctype=="function" then
                slotName(...)
                
            end
        end
    end
end
function LSIGNAL_IMPLEMENT:new()
    local obj={
        slots=LSLOTS:new(),
        __class=self
    }
    setmetatable(obj,self)
    return obj
end
--clear all connect
function LSIGNAL_IMPLEMENT:clear()

    self.slots=LSLOTS:new()

end

LSLOTS={__cname="LSLOT"}
LSLOTS.__nsName="luaClass"
LSLOTS.__index=LSLOTS
LSLOTS.__mode="v"

function LSLOTS:new()
    local obj={
        __class=self
    }
    setmetatable(obj,self)
    return obj
end
