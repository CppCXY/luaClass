_ENV=namespace "container"
using_namespace "luaClass"
using_namespace "algorithm.iterator"


---@class array
local array=class ("array"){
    public{
        FUNCTION.array;
        
        FUNCTION.getData;

        FUNCTION.at;

        FUNCTION.set;

        FUNCTION.merge;
        
        FUNCTION.size;
        
        FUNCTION.push_back;
        
        FUNCTION.unpack;
        
        FUNCTION.back;

        FUNCTION.front;

        FUNCTION.join;

        FUNCTION.pop_back;

        FUNCTION.empty;

        FUNCTION.iter;

        FUNCTION.clear;

        FUNCTION.reverse;
        
        FUNCTION.sort;
        
        FUNCTION.zip;
        
        FUNCTION.for_each;

        FUNCTION.zip_each;

    };
    protected{
        MEMBER._data;
        MEMBER._size;
    }

}
function array:array(data)
    data=data or {}
    self._data=data
    self._size=#data
end

function array:getData()
    return self._data        
end

function array:at(index)
    return self._data[index]
end

function array:set(index,value)
    self._data[index]=value
end

function array:merge(arr)
    if is(arr,array) then
        local arrsize=arr:size()
        local size=self._size
        local selfData=self._data 
        local arrData=arr:getData()
        for i=1,arrsize do
            selfData[size+i]=arrData[i]            
        end
        self._size=size+arrsize
    else
        local arrsize=#arr
        local size=self._size
        local selfData=self._data 
        local arrData=arr
        for i=1,arrsize do
            selfData[size+i]=arrData[i]            
        end
        self._size=size+arrsize
    end
end

function array:size()
    return self._size
end

function array:push_back(value)
    if value==nil then return end
    local num=self._size+1
    self._size=num
    self._data[num]=value
end

function array:back()
    return self._data[self._size]
end

function array:front()
    return self._data[1]
end

function array:join(sep)
    return table.concat(self._data,sep)
end
local unpack=unpack or table.unpack

function array:unpack()
    return unpack(self._data)
end
function array:pop_back()
    local num=self._size
    local elem=self._data[num]
    self._data[num]=nil
    num=num-1
    self._size=num<0 and 0 or num
    return elem
end

function array:empty()
    return self._size==0
end

function array:iter()
    local data=self._data
    return ipairs(data)
end

function array:clear()
    self._data={}
    self._size=0
end

function array:reverse()
    local data={}
    local sourceData=self._data
    local size=self._size
    if size~=0 then
        for i=1,size do
            data[i]=sourceData[size+1-i]
        end
    end
    return array(data)
end

function array:sort(cmpFunction)
    table.sort(self._data,cmpFunction )
end


function array:zip(arr2)
    return zip(self._data,arr2:getData())
end

function array:for_each(callBack)
    for index,value in self:iter() do
        callBack(index,value)
    end
end

function array:zip_each(arr2,callBack)
    for index,v1,v2 in self:zip(arr2) do
        callBack(index,v1,v2)
    end
end

