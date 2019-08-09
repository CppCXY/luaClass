
include "luaClass.class.namespace"
include "luaClass.class.config.init"
_ENV=namespace "luaClass"
local unpack=unpack or table.unpack
LMEMBER={}
LMEMBER.__index=function (self,key)
    return LMEMBER_INSTANCE:new(key,self.__ctype)
end

MEMBER={__ctype="member"}
setmetatable(MEMBER,LMEMBER)

STATIC={__ctype="static"}
setmetatable(STATIC,LMEMBER)

STATICFUNC={__ctype="staticFunction"}
setmetatable(STATICFUNC,LMEMBER)

FUNCTION={__ctype="function"}
setmetatable(FUNCTION,LMEMBER)

CONST={__ctype="const"}
setmetatable(CONST,LMEMBER)

META={__ctype="meta"}
setmetatable(META,LMEMBER)


LMEMBER_INSTANCE={}
LMEMBER_INSTANCE.__index=LMEMBER_INSTANCE
function LMEMBER_INSTANCE:new(key,ctype)
    local object={
        key=key;
        ctype=ctype;
    }
    setmetatable(object,self)
    return object
end

function LMEMBER_INSTANCE:__call(value)
    self.object=value
    return self
end

function LMEMBER_INSTANCE:check(debug)
    if debug==false  then return end
    if self.ctype=="function" then
        self.object=LFUNCTION_IMPLEMENT:new(self.key,self.object,"_inFunction")
    elseif self.ctype=="staticFunction" then
        self.object=LFUNCTION_IMPLEMENT:new(self.key,self.object,"_inStatic")
    elseif self.ctype=="meta" then
        if self.key=="__index" or self.key=="__newindex" then
            error("error :meta method __index or __newindex can't be declared")
        end
    end
end

LFUNCTION_IMPLEMENT={} 
function LFUNCTION_IMPLEMENT:new(key,functionObject,accessKey)
    local object={
        object=functionObject;
        key=key;
        accessKey=accessKey;
    }
    setmetatable(object,self)
    return object
end

function LFUNCTION_IMPLEMENT:__call(instance,...)
    assert(instance~=nil,"instance is nil maybe you should use ':' instead of '.' to call method")
    assert(self.object~=nil,"method ",instance.__cname,"::",self.key,"don't implement")
    local accessKey=self.accessKey
    local old=instance[accessKey]
    instance[accessKey]=true
    local result={self.object(instance,...)}
    instance[accessKey]=old
    return unpack(result)

end