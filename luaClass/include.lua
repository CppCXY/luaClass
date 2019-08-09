--This part is experimental. default not open
LUA_PACKAGE_MANAGE=false

if LUA_PACKAGE_MANAGE then

    __loadStack={}
    include=function(modName)
        if package.loaded[modName]==nil then
            table.insert(__loadStack,modName)
            require (modName)
        end
    end
    reloadLua=function()
        for _,modName in pairs(__loadStack) do
            package.loaded[modName]=nil
        end
        local oldStack=__loadStack
        __loadStack={}
        for _,modName in pairs(oldStack) do
            include (modName)
        end
    end

else
    include=require
end