_ENV=namespace "container"
using_namespace "luaClass"

---@class mat
local mat=class "mat" {

    property "colNum" {READ.getColNum;};
    property "rowNum" {READ.getRowNum;};
    public{
        FUNCTION.mat;

        FUNCTION.at;

        FUNCTION.set;

        FUNCTION.del;

        FUNCTION.getColNum;

        FUNCTION.getRowNum;

        FUNCTION.size;

        FUNCTION.iter;

        FUNCTION.clear;

        FUNCTION.onFun;
    };
    protected{
        MEMBER._data;
        MEMBER._rowNum;
        MEMBER._colNum;
    };


}


function mat:mat(rowNum,colNum)
    local data={}
    self._data=data
    self._rowNum=rowNum
    self._colNum=colNum
    for i=1,rowNum*colNum do
        data[i]=false
    end
end

function mat:at(row,col)
    return self._data[col+(row-1)*self._colNum] or nil
end

function mat:set(row,col,value)
    self._data[col+(row-1)*self._colNum]=value
end

function mat:del(row,col)
    self:set(row,col,false)
end

function mat:getColNum()
    return self._colNum
end

function mat:getRowNum()
    return self._rowNum
end

function mat:size()
    return self._colNum*self._rowNum
end

function mat:iter()
    return ipairs(self._data)
end

function mat:clear()
    for i=1,self:size() do
        self._data[i]=false
    end
end

function mat:onFun(callBack)
    for _,v in ipairs(self._data) do
        callBack(v)
    end
end