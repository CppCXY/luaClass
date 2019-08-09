_ENV=namespace "container"
using_namespace "luaClass"

---@class stack
local stack=class ("stack"){
    public{
        FUNCTION.stack;
        
        FUNCTION.size;

        FUNCTION.push;

        FUNCTION.top;

        FUNCTION.pop;

        FUNCTION.empty;

    };
    protected{
        MEMBER._data;
        MEMBER._size;
    };
}

function stack:stack(data)
    data=data or {}
    self._data=data
    self._size=#data
end

function stack:size()
    return self._size
end


function stack:push(value)
    local num=self._size+1
    self._size=num
    self._data[num]=value
end

function stack:top()
    return self._data[self._size]
end

function stack:pop()
    local num=self._size
    local elem=self._data[num]
    self._data[num]=nil
    num=num-1
    self._size=num<0 and 0 or num
    return elem
end

function stack:empty()
    return self._size==0
end

