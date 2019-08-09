include "luaClass.class.namespace"
include "luaClass.class.class"
_ENV=namespace "luaClass"
---@class LMetaObject
local LMetaObject=class ("LMetaObject"){
    NO_AUTO_INHERIT();
    public{
        FUNCTION.LMetaObject(function(self,classObject)
            self.classObject=classObject
        end);
        --get the public function name list
        FUNCTION.getPublicFunctionList(function(self)
            local list={}
            for key,value in pairs(self.classObject.__decl) do
                if value=="publicFunction" then
                    table.insert(list,key)
                end
            end
            return list
        end);
        --get the protected function name list
        FUNCTION.getProtectedFunctionList(function(self)
            local list={}
            for key,value in pairs(self.classObject.__decl) do
                if value=="protectedFunction" then
                    table.insert(list,key)
                end
            end
            return list
        end);
        --get the public member name list
        FUNCTION.getPublicMemberList(function(self)
            local list={}
            for key,value in pairs(self.classObject.__decl) do
                if value=="publicMember" then
                    table.insert(list,key)
                end
            end
            return list
        end);
        --get the protected member name list
        FUNCTION.getProtectedMemberList(function (self)
            local list={}
            for key,value in pairs(self.classObject.__decl) do
                if value=="protectedMember" then
                    table.insert(list,key)
                end
            end
            return list
        end);
        --get the public static list
        FUNCTION.getPublicStaticList(function (self)
            local list={}
            for key,value in pairs(self.classObject.__decl) do
                if value=="publicStatic" then
                    table.insert(list,key)
                end
            end
            return list
        end);
        --get the protected member name list
        FUNCTION.getProtectedStaticList(function (self)
            local list={}
            for key,value in pairs(self.classObject.__decl) do
                if value=="protectedStatic" then
                    table.insert(list,key)
                end
            end
            return list
        end);
        --get the public const name list
        FUNCTION.getPublicConstList(function (self)
            local list={}
            for key,value in pairs(self.classObject.__decl) do
                if value=="publicConst" then
                    table.insert(list,key)
                end
            end
            return list
        end);
        --get the protected const name list
        FUNCTION.getProtectedConstList(function (self)
            local list={}
            for key,value in pairs(self.classObject.__decl) do
                if value=="protectedConst" then
                    table.insert(list,key)
                end
            end
            return list
        end);
        --get the property name list
        FUNCTION.getPropertyList(function (self)
            local list={}
            for key,value in pairs(self.classObject.__decl) do
                if value=="property" then
                    table.insert(list,key)
                end
            end
            return list
        end);
        --get the metaMethod name list
        FUNCTION.getMetaMethodList(function (self)
            local list={}
            for key,value in pairs(self.classObject.__metaMethod) do
                table.insert(list,key)
            end
            return list
        end);
        FUNCTION.getStaticFunctionList(function(self)
            local list={}
            for key,value in pairs(self.classObject.__decl) do
                if value=="publicStaticFunction" then
                    table.insert(list,key)
                end
            end
            return list
        
        end)
        

    };
    protected{
        MEMBER.classObject();
    }
}
