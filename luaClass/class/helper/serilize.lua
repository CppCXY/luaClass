--[[
    Copyright(c) 2019 CppCXY
    Author: CppCXY
	Github: https://github.com/CppCXY
	如果觉得我的作品不错,可以去github给我的项目打星星.
	序列化方案
	针对我自己的编码规则进行特定的序列化和反序列化方式
	默认屏蔽一切双下划线开头的字段
	这部分内容与luaClass没有太多耦合,
	如果想分离出来,需要将include 部分删掉,_ENV删掉，initSerilize不使用
]]
include "luaClass.class.namespace"
_ENV=namespace "luaClass"

--这些key并不参与序列化
local disableKey={
	["class"]=true,--实际上我并没有这个字段
	["super"]=true,
}

local serilizeTable={}
local serilizeClassTable={}
local luaIDQuery={}
local waitTable={}
local id=0
local getId=function ()
	id=id+1
	return id
end
local reset=function ()
	id=0
	luaIDQuery={}
	waitTable={}
end


local type=type
local getmetatable=getmetatable
local string_format=string.format
local table_concat=table.concat
local table_insert=table.insert
local getType=function ( value )
	local t=type(value)
	if t=="table" then
		
		if not getmetatable(value) then return "unMetaTable" end
		if getmetatable(value) then return "class" end
		return "nil"
	elseif t=="string" then
		if value:find("\n") then return "blockString" end
		if disableKey[value] then return "nil" end
        if value:match("^__") then return "nil" end 
        return t       
    elseif t=="number" or t=="boolean" or t=="function" then
		return t
	end
    return "nil"
end

local arraySerilize=function(array)
	local t={}
	for i=1,#array do
		local value=array[i]
		t[i]=serilizeTable[getType(value)](value)
	end
	local str="{"..table_concat(t,",").."}"
	return str
end
serilizeTable["array"]=arraySerilize

local numberSerilize=tostring

serilizeTable["number"]=numberSerilize

local stringSerilize=function ( str )
	return "\""..str.."\""
end
serilizeTable["string"]=stringSerilize
local blockStringSerilize=function ( str )
	return "[["..str.."]]"
end
serilizeTable["blockString"]=blockStringSerilize
local booleanSerilize=function ( bool )
	return bool and "true" or "false"
end
serilizeTable["boolean"]=booleanSerilize
local nilSerilize=function ( value )
	return "\"\""
end
serilizeTable["nil"]=nilSerilize
local functionSerilize=function (value)
	local text={}
	local size=1
	for char in string.gmatch(string.dump(value),".") do
		text[size]= "\\"..char:byte(1)
		size=size+1
	end
	return "\"".."function"..table.concat(text).."\""
end
serilizeTable["function"]=functionSerilize
local unMetaTableSerilize=function ( tb)
	local t={}
	for k,v in pairs(tb) do
		local kType=getType(k)
		if kType~="nil" then
		table_insert(t,
			string_format("[%s]=%s",
			serilizeTable[kType](k),serilizeTable[getType(v)](v)
			))
		end
	end
	return "{"..table_concat(t,",").."}"
end
serilizeTable["unMetaTable"]=unMetaTableSerilize

--以下专门针对用class 声明得到的类型
--并不处理元表
local classSerilize=function (classValue)
	local t={}
	if luaIDQuery[classValue]==nil then
		local id=getId()
		luaIDQuery[classValue]=id
	else
		return ("\"luaID"..luaIDQuery[classValue].."\"")
	end
	table_insert(t,"__luaID="..id)
    for key,value in pairs(classValue) do
		local kType=getType(key)
		local vType=getType(value)
		if kType~="nil"  and vType~="nil" then	
			table_insert(t,
			"["..
			(
			luaIDQuery[key] and 
			("\"luaID"..luaIDQuery[key].."\"")
			or
			serilizeTable[kType](key)
			)
			.."]="..
			(
			luaIDQuery[value] and 
			("\"luaID"..luaIDQuery[value].."\"")
			or
			serilizeTable[vType](value)
			)
			)
		end
        
    end

    table_insert(t,
        "__class="..classValue.__nsName.."."..classValue.__cname
        )
	return "{"..table_concat(t,",").."}"
end
serilizeTable["class"]=classSerilize

local __serilizeAux
__serilizeAux=function (object)
	local objectType=type(object)
	if objectType=="table" then
		if object.__luaID then
			luaIDQuery[object.__luaID]=object
			local wt=waitTable[object.__luaID] 
			if wt then
				for _,wts in pairs(wt) do
					local obj=wts.obj
					if wts.keys.oldKey then
						local newKey=object
						obj[newKey]=obj[wts.keys.oldKey]
						obj[wts.keys.oldKey]=nil
					elseif wts.keys.key then
						obj[wts.keys.key]=object
					end
				end
				waitTable[object.__luaID]=nil
			end
		end
		local keyAlterTable={}
		local valueAlterTable={}
		for key,value in pairs(object) do
			local keyType=type(key)
			if keyType=="table" then
				__serilizeAux(key)
			elseif keyType=="string" then
				local mc=key:match("^luaID(%d+)")
				if mc then
					table_insert(
					keyAlterTable,
					{oldKey=key,mc=tonumber(mc)}
					)
				end
			end

			local valueType=type(value)
			if valueType=="string" then
				local mc=value:match("^luaID(%d+)")
				if mc then
					table_insert(valueAlterTable,
					{key=key,mc=tonumber(mc)}
					)
				end
				mc=value:match("^function(.+)")
				if mc then
					object[key]=load(mc)
				end
			elseif key~="__class" and valueType=="table" then
				__serilizeAux(value)
			end
		end
		for _,keys in pairs(keyAlterTable) do
			local newKey=luaIDQuery[keys.mc]
			if newKey then
				object[newKey]=object[keys.oldKey]
				object[keys.oldKey]=nil
			else
				local wt=waitTable[keys.mc] or {}
				table_insert(wt,
				{obj=object,keys=keys}
				)
				waitTable[keys.mc]=wt
			end
		end
		for _,keys in pairs(valueAlterTable) do
			local newValue=luaIDQuery[keys.mc]
			if newValue then
				object[keys.key]=newValue
			else
				local wt=waitTable[keys.mc] or {}
				table_insert(wt,
				{obj=object,keys=keys}
				)
				waitTable[keys.mc]=wt
			end
		end
		if object.__class then
			--object.__class=serilizeClassTable[object.__createClass]
			setmetatable(object,object.__class)
		end
	end
end

function serilize(object)
	local str=serilizeTable[getType(object)](object)
	reset()
	return str
end

function unSerilize(str,isAdd)
	if  isAdd==nil then
		isAdd=true
	end
	local g
	if isAdd then
		local result=str:find("return")
		g=load(result and str or ("return "..str))
	else
		g=load(str)
	end
	local t=g()
	__serilizeAux(t)
	reset()

	return t
end


