
include "luaClass.class.namespace"
_ENV=namespace "luaClass"


LSuper={}
LSuper.__index=LSuper
local unpack=unpack or table.unpack
function LSuper:new(...)
    local object={
        supers={...}
    }
    setmetatable(object,self)
    return object
end

function LSuper:implement(classObject,isCover)
    if isCover==nil then 
        isCover=true
    end

    for _,cobject in pairs(self.supers) do
        self:inherit(classObject,cobject,isCover)
    end
end
__mergeTable=function (target,source,isCover)
    if isCover then
        for key,value in pairs(source) do
            target[key]=value
        end
    else
        for key,value in pairs(source) do
            if target[key]==nil then
        
                target[key]=value
            end
        end

    end
end


function LSuper:inherit(classObject,superClass,isCover)
    local cls=classObject

    if isHostClass(superClass) then return hostInherit(classObject,superClass) end
    cls.__supers[superClass.__cname]=superClass
    cls.__inherits[superClass.__cname]=true
    __mergeTable(cls.__public_member,superClass.__public_member,isCover)
    __mergeTable(cls.__protected_member,superClass.__protected_member,isCover)
    __mergeTable(cls.__signals,superClass.__signals,isCover)
    __mergeTable(cls.__property,superClass.__property,isCover)
    __mergeTable(cls.__decl,superClass.__decl,isCover)
    __mergeTable(cls.__metaMethod,superClass.__metaMethod,isCover)
    __mergeTable(cls,superClass.__metaMethod,isCover)
    __mergeTable(cls.__inherits,superClass.__inherits,isCover)
    __mergeTable(cls.__supers,superClass.__supers,isCover)
    __mergeTable(cls.__function,superClass.__function,isCover)
    if superClass.__super then
        cls.__super=superClass.__super
    end
    if isCover then
        for key ,value in pairs(superClass) do
            local mc=key:match("^__")
            if mc==nil then     
                cls[key]=value
            end
        end
    else
        for key ,value in pairs(superClass) do
            local mc=key:match("^__")
            if mc==nil and cls[key]==nil then
                cls[key]=value
            end
        end
    end
end

function super(...)
    return LSuper:new(...)
end

LNOOBJECT={}
LNOOBJECT.__index=LNOOBJECT
function LNOOBJECT:implement(classObject)
    classObject.__autoInherit=false
end
NOOBJECT={}
setmetatable(NOOBJECT,LNOOBJECT)
function NO_AUTO_INHERIT ()
    return NOOBJECT
end