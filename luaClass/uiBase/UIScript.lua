include "luaClass.class.init"

_ENV=namespace "uis"
using_namespace "luaClass"



class "UIScript" {
    public{
        FUNCTION.UIScript(function(self,scriptName)
            uis[scriptName]=self            
        end);
        
        FUNCTION.setScript(function(self,uiScript)
           self._uiScript=uiScript; 
        end);

        META.__call(function(self,uiScript)
            self:setScript(uiScript)
        end);

        FUNCTION.getScript(function(self)
            return self._uiScript
        end)
    };

    protected{
        MEMBER._uiScript();

    };
}