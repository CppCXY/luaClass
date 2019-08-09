--[[
    Copyright(c) 2019 CppCXY
    Author: CppCXY
    Github: https://github.com/CppCXY/luaClass
]]
include "luaClass.class.namespace"
_ENV=namespace "luaClass"

--this variable will open the all check.if all test finish,please set LUA_DEBUG=false
--it will be 5 times better performance
LUA_DEBUG=(DEBUG~=1)
--this variable will open hostInherit
CXX_TO_LUA_HOST_ENV=true

--If you have a host language and attempt to inherit the host type
--modify the following functions, but be compatible with Lua native classes
if CXX_TO_LUA_HOST_ENV then
    --this for tolua++
    --If it's another way of luabind, modify it yourself
    function isHostClass (classObject)
        return  type(classObject)=="function" or classObject[".isclass"]
    end
    
    function __hostCreate(self,...)
        local instance
        local super=self.__supers["__hostClass"]
        if type(super)=="function" then
            instance=super(...)
        else
            instance=super:create(...)
        end
        tolua.setpeer(instance,self)
        self.__instance=instance
        return instance
    end

    function hostInherit(classObject,superClass)
        classObject.__supers["__hostClass"]=superClass
        classObject.__super=__hostCreate
    end

    --This uses a new function because it cannot use rawset for UserData
    function classRawSet (classObject,key,value)
        return (type(classObject)=="userdata")
        and 
        rawset(tolua.getpeer(classObject),key,value)
        or 
        rawset(classObject,key,value)
    end
    --This uses a new function because it cannot use rawget for UserData
    function classRawGet(classObject,key)
        return ( type(classObject)=="userdata")
        and 
        rawget(tolua.getpeer(classObject),key)
        or 
        rawget(classObject,key) 
    end


else
    function isHostClass(classObject) return false end
    function hostInherit() return end
    classRawGet=rawget
    classRawSet=rawset
end


