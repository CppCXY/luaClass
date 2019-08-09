--可序列化函数类
_ENV=namespace "luaClass"

class ("Func"){
    public{
        FUNCTION.Func(function(self,captureList,luafunc)
            self._luaf=luafunc
            self._captureList=captureList
        end);
        FUNCTION.call(function(self,...)
            return self._luaf(self._captureList,...)
        end);

        META.__call(function(self,...)
            return self:call(...)
        end);

    };
    
    protected{
        MEMBER._luaf();
        MEMBER._captureList();


    };

}
