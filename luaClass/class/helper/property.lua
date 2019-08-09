include "luaClass.class.namespace"
_ENV=namespace "luaClass"


LProperty={}
LProperty.__index=LProperty
function LProperty:new(propertyName,readName,setName)
    local object={
        propertyName=propertyName;
        readName=readName;
        setName=setName;
    }
    setmetatable(object,LProperty)
    return object
end
function LProperty:implement(classObject)
    local __property=classObject.__property
    classObject.__decl[self.propertyName]="property"
    __property[self.propertyName]={readName=self.readName,setName=self.setName}
end
function __property(propertyName,propertyTable)
    local read,write;
    for _,declType in pairs(propertyTable) do
        if declType.read then
            read=declType.read
        elseif declType.write then
            write=declType.write
        end
    end
    return LProperty:new(propertyName,read,write)
end

function property(propertyName)
    return function (propertyTable)
        return __property(propertyName,propertyTable)
    end
end

LREAD={}
LREAD.__index=function(self,key)
    return {read=key}
end
READ={}
setmetatable(READ,LREAD)

LWRITE={}
LWRITE.__index=function(self,key)
    return {write=key}
end
WRITE={}
setmetatable(WRITE,LWRITE)