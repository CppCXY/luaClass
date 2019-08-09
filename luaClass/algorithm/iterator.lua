include "luaClass.class.init"
_ENV=namespace "algorithm.iterator"

local table_unpack=unapck or table.unpack

local _zip2=function ( arrs,index )
	index=index+1
	if arrs[1][index]==nil then return end
	return index,arrs[1][index],arrs[2][index]
end

local _zip3=function ( arrs,index )
	index=index+1
	if arrs[1][index]==nil then return end
    return index,arrs[1][index],arrs[2][index],arrs[3][index]
end

local _zip=function ( arrs,index )
	index=index+1
	if arrs[1][index]==nil then return end
	local ar={}
	for i,arr in ipairs(arrs) do
		ar[i]=arr[index]	
	end	
	return index,table_unpack(ar)
end
--[[
--可以同时遍历多个数组table,针对主要使用情况进行优化
--for i,a,b,c in zip(arr,brr,crr) do
--  print(i,a,b,c)
--end
--]]
function zip(arr,... )
	local index=0
    local arrs={arr,...}
    local size=#arrs
    if size==1 then
        return ipairs(arr)
    elseif size==2 then
        return _zip2,arrs,index
    elseif size==3 then
        return _zip3,arrs,index
    else
        return _zip,arrs,index
    end
end

--反向迭代器

local __reverse=function (arr,index )
	index=index-1
	if index==0 then return end
    return index,arr[index]
end

function reverse(array)
	local index=#array
	return __reverse,array,index+1
end