_ENV=namespace "container"
using_namespace "luaClass"

class ("set"){
    public{
        FUNCTION.set;

        FUNCTION.del;

        FUNCTION.size;

        FUNCTION.merge;

        FUNCTION.has;

        FUNCTION.insert;

        FUNCTION.iter;

        FUNCTION.for_each;

    };
    protected{
        MEMBER._data;
    }

};


function set:set(data_t)
    local data={}
    if data_t then
        for _,value in pairs(data_t) do
            data[value]=true
        end
    end
    self._data=data
end

function set:del(key)
    self._data[key]=nil
end

function set:size()
    local count=0
    for _ in pairs(self._data) do
        count=count+1
    end
    return count
end

function set:merge(set2)
    for key,_ in set2:iter() do
        self:insert(key)
    end
end

function set:has(key)
    return self._data[key]~=nil
end

function set:insert(key)
    self._data[key]=true
end

function set:iter()
    local data=self._data
    return pairs(data)
end

function set:for_each(callBack)
    for key,_ in self:iter() do
        callBack(key)
    end
end