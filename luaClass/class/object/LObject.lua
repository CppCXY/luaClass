include "luaClass.class.namespace"
include "luaClass.class.class"
include "luaClass.class.object.LMetaObject"
_ENV=namespace "luaClass"

---@class LObject
---@field public getType fun(self:LObject):classObject
---@field public getClassName fun(self:LObject):string
---@field public getNamespace fun(self:LObject):string
---@field public getMetaObject fun(self:LObject):LMetaObject
---@field public getSupers fun(self:LObject,name:string):LObject
---@field public inherit fun(self:LObject,classObject:ClassObject):boolean
---@field public is fun(self:LObject,classObject:ClassObject):boolean
---@field public serilize fun(self:LObject):string
---@field public toString fun(self:LObject):string
local LObject=class ("LObject"){
    NO_AUTO_INHERIT();
    public{
        FUNCTION.LObject(function(self)
        end);
        --get the classObject
        FUNCTION.getType(function(self)
            return self.__class        
        end);
        --get object class name
        FUNCTION.getClassName(function(self)
            return self.__class.__cname
        end);
        --get namespace name
        FUNCTION.getNamespace(function(self)
            return self.__class.__nsName
        end);
        --get metaObject
        FUNCTION.getMetaObject(function (self)
            return LMetaObject(self.__class)
        end);
        --get super class by name
        FUNCTION.getSupers(function (self,name)
            return self.__supers[name]
        end);

        FUNCTION.getSuperMethod(function(self,superName,methodName)
            if self.__debug then
                return self.__supers[superName].__function[methodName]
            else
                return self.__supers[superName][methodName]
            end
        end);

        FUNCTION.inherit(function(self,classObject)
            local cname=classObject.__cname
            if cname then
                return self.__inherits[cname]
            else
                return self.__supers["__hostClass"]==classObject
            end
        end);
        FUNCTION.isHost(function(self)
            return self.__instance~=nil 
        end);

        FUNCTION.isExistField(function(self,key)
            local get=classRawGet(self,key)
            if get~=nil then return true end
            get=classRawGet(self._protected_,key)
            if get~=nil then return true end
            return false
        end);

        FUNCTION.isExistFunction(function(self,key)
            local get=classRawGet(self.__class,key)
            if get~=nil then return true end
            return false
        end);

        --return  whether self is target class object or not
        FUNCTION.is(is);
        --return string of serilize result
        FUNCTION.serilize(serilize);

        --get object string desciption
        FUNCTION.toString(function(self)
            return " [LOBJECT: "..self.__cname.."]"
        end);

        META.__tostring(function(self)
            return self:toString()
        end);
        META.__concat(function(concat1,concat2)
            return (is(concat1,LObject) and concat1:toString() or concat1)
            ..(is(concat2,LObject) and concat2:toString() or concat2)
        end);
        
    };
}


