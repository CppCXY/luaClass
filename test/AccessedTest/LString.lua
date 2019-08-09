
require "luaClass.init"

_ENV=namespace "test"
using_namespace "luaClass"
using_namespace "container"
class "LString" {
    
    public{
        MEMBER._table();
        MEMBER._args();
    };
    public{
        FUNCTION.LString(function(self)
            self._table={}
            self._args=map()
        end);

        FUNCTION.toString(function(self)
            local result=table.concat(self._table)
            local args=self._args
            return result:gsub("{.-}",function (s)
                local index=string.match(s,"%s-(%w+)%s-")
                local newindex=tonumber(index)
                if newindex then
                    return args:get(newindex)
                else
                    return args:get(index)
                end
            end)
           
        end);
        
        FUNCTION.format(function(self,...)
            self._args:merge({...})
            return self
        end);
        FUNCTION.data(function(self,mapData)
            self._args=mapData
            return self
        end);

        META.__call(function(self,str_OR_table)
            local ctype=type(str_OR_table) 
            if ctype=="string" then
                table.insert(self._table,str_OR_table)
            elseif ctype=="table" then
                for _,v in pairs(str_OR_table) do
                    table.insert(self._table,tostring(v))
                end

            end
            return self
        
        end)
    }


}

local fm=LString()
local data=map()

local str=fm "1234" {996} "xixixi" {5555}
print(str)