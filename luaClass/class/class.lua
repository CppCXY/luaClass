--[[
    Copyright(c) 2019 CppCXY
    Author: CppCXY
    Github: https://github.com/CppCXY
	如果觉得我的作品不错,可以去github给我的项目打星星.
]]
include "luaClass.class.config.init"
include "luaClass.class.helper.init"

_ENV=namespace "luaClass"

__debugCtor=function(cls,...)
    local instance={__class=cls}
    instance._inFunction=false
    instance._protected_={}
    setmetatable(instance,cls)
    local ctor=instance[cls.__cname]
    if ctor then

        for key,value in pairs(cls.__public_member) do
            classRawSet(instance,key,value)
        end
        local protected=instance._protected_
        for key,value in pairs(cls.__protected_member) do
            protected[key]=value
        end
        for key,_ in pairs(cls.__signals) do
            protected[key]=LSIGNAL_IMPLEMENT:new()
        end

        ctor(instance,...)
        instance=classRawGet(instance,"__instance") or instance
    else
        error("wrong: constructor"..cls.__cname..":"..cls.__cname.." is protected")
    end
    return instance
end
__classDebugIndex=function (instance,key)
    local cls=instance.__class
    if cls.__decl[key] then
        local declInfo=cls.__decl[key]
        if declInfo=="publicFunction" 
        or declInfo=="publicStaticFunction" then
            return cls.__function[key]
        elseif declInfo=="default" 
        or declInfo=="publicStatic" then
            return cls[key]
        elseif declInfo=="publicConst"  then
            return instance._protected_[key]
        elseif declInfo=="property" then
            local property=cls.__property[key]
            local read=property.readName
            if read then
                instance=cls.__super and instance.__instance or instance
                local getter=instance[read]
                return  getter(instance)
            else
                error("error: attempt to access "..cls.__cname.."::"..key.."'s getter ,it is inaccessible ")
            end
        elseif instance._inFunction or cls.__inStatic  then
            if declInfo=="protectedFunction" 
            or declInfo=="protectedStaticFunction" then
                return  cls.__function[key]
            elseif declInfo=="protectedStatic" then
                return  cls[key]
            else
                return instance._protected_[key]
            end
        else
            error("error :attempt access protected member "..cls.__cname.."::"..key)
        end 
    elseif cls.__super then 
        return nil
    else
        
        error("error: attempt to access undeclare member "..cls.__cname.."::"..key)
    end
end

__classDebugNewIndex=function(instance,key,value)
    local cls=instance.__class
    if cls.__decl[key] then
        local declInfo=cls.__decl[key]
        if declInfo=="publicMember" then
            classRawSet(instance,key,value)
        elseif declInfo=="publicStatic" then
            rawset(cls,key,value)
        elseif declInfo=="publicConst"  then
            if instance._protected_[key]~=nil then
                error("error:attempt to assign to member "..cls.__cname.."::"..key.." ,it is Const")
            else
                instance._protected_[key]=value
            end 
        elseif declInfo=="property" then
            local property=cls.__property[key]
            if property.setName then
                instance=cls.__super and instance.__instance or instance
                local setter=instance[property.setName]
                setter(instance,value)
            else
                error("error :attempt to access "..cls.__cname.."::"..key.."'s setter ,it is inaccessible")
            end
        elseif instance._inFunction or cls.__inStatic  then
            if declInfo=="protectedMember" then
                instance._protected_[key]=value
            elseif declInfo=="protectedStatic" then
                rawset(cls,key,value)
            elseif declInfo=="protectedConst" then
                if instance._protected_[key]~=nil then
                    error("error:attempt to assign to member "..cls.__cname.."::"..key.." ,it is Const")
                else
                    instance._protected_[key]=value
                end 
            else
                error("error:attempt to assign to immutable member "..cls.__cname.."::"..key)
            end
        else
            error("error:attempt to assign to member "..cls.__cname.."::"..key.." ,it is protected")
        end
    else
        error("error: attempt to assign undeclare member "..cls.__cname.."::"..key)
    end

end

__metaNewIndex=function(cls,key,value)
    local funcImp=cls.__function[key]
    if  funcImp then
        cls.__function[key]=LFUNCTION_IMPLEMENT:new(funcImp.key,value,funcImp.accessKey)
    else
        error("error: attempt define undeclare function")
    end
end

__ctor=function(cls,...)
    local instance={__class=cls}
    setmetatable(instance,cls)
    local ctor=instance[cls.__cname]
    for key,value in pairs(cls.__public_member) do
        classRawSet(instance,key,value)
    end
    local protected=instance._protected_
    for key,value in pairs(cls.__protected_member) do
        classRawSet(instance,key,value)
    end
    for key,_ in pairs(cls.__signals) do
        classRawSet(instance,key,LSIGNAL_IMPLEMENT:new())
    end
    ctor(instance,...)
    instance=classRawGet(instance,"__instance") or instance
    return instance
end
__classIndex=function (instance,key)
    local cls=instance.__class
    local declInfo=cls.__decl[key]
    if declInfo=="property" then
        local property=cls.__property[key]
        local read=property.readName
        instance=cls.__super and instance.__instance or instance
        local getter=instance[read]
        return  getter(instance)
    else
        return cls[key]
    end
end

__classNewIndex=function(instance,key,value)
    local cls=instance.__class
    local declInfo=cls.__decl[key]
    if declInfo=="property" then
        local property=cls.__property[key]
        instance=cls.__super and instance.__instance or instance
        local setter=instance[property.setName]
        setter(instance,value)
    elseif declInfo=="publicMember"
    or declInfo=="publicConst"
    or declInfo=="protectedConst"
    or declInfo=="protectedMember"
    or declInfo==nil then
        classRawSet(instance,key,value)
    else
        cls[key]=value
    end
end


function __class(className,classTable,namespaceTable,namespaceName)
    local cls={__cname=className,__nsName=namespaceName}
    cls.__public_member={}

    cls.__protected_member={}
    cls.__function={}
    cls.__inStatic=false
    cls.__signals={}
    cls.__metaMethod={}
    cls.__debug=LUA_DEBUG
    cls.__autoInherit=true
    cls.__property={}
    cls.__supers={}
    cls.__inherits={}
    cls.__decl={
        __cname="default",
        __nsName="default",
        __supers="default",
        __super="default",
        __inherits="default",
        __signals="default",
        __debug="default",
        __instance="publicMember"
    }
    
    for _,declType in pairs(classTable) do
        declType:implement(cls)
    end
    if cls.__autoInherit and cls.__inherits["LObject"]==nil then
        super(LObject):implement(cls,false)
    end
    cls.__decl.new=cls.__decl[className]
    cls.__decl.create=cls.__decl[className]

    local ctor= cls.__debug and __debugCtor or __ctor

    cls.new=ctor
    cls.create=ctor
    local meta={__call=ctor}
    if cls.__debug then
        cls.__index=__classDebugIndex
        cls.__newindex=__classDebugNewIndex
        meta.__newindex=__metaNewIndex
    else
        cls.__index=__classIndex
        cls.__newindex=__classNewIndex
    end
    
    if cls.__debug==false then
        local hasProperty=false
        for key,value in pairs(cls.__decl) do
            if value=="property" then
                hasProperty=true
                break;
            end
        end
        if hasProperty==false then
            cls.__index=cls
        end
    end
    setmetatable(cls,meta)
    namespaceTable[className]=cls
    return cls
end



function class (className,namespaceTable,namespaceName)

    ---@param classTable table
    return function(classTable)
        return __class(className,classTable,namespaceTable,namespaceName)
    end
end

namespace_register("class",class)



