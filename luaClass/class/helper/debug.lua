include "luaClass.class.namespace"
include "luaClass.class.config.init"
_ENV=namespace "luaClass"

LDEBUG={}
LDEBUG.__index=LDEBUG

DEBUG_INSTANCE={__ctype==true}
setmetatable(DEBUG_INSTANCE,LDEBUG)

NO_DEBUG_INSTANCE={__ctype==false}
setmetatable(NO_DEBUG_INSTANCE,LDEBUG)

function LDEBUG:implement(classObject)
    classObject.__debug=self.__ctype
end

function CLASS_DEBUG(bool)
    return bool and DEBUG_INSTANCE or NO_DEBUG_INSTANCE
end


