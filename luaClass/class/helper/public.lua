include "luaClass.class.namespace"
include "luaClass.class.config.init"
_ENV=namespace "luaClass"

LPublic={}
LPublic.__index=LPublic
function LPublic:new(memberTable)
    local object={
        members=memberTable;
    }
    setmetatable(object,self)
    return object

end



function LPublic:implement(classObject)
    local members=classObject.__public_member
    local protectedMembers=classObject.__protected_member
    local decl=classObject.__decl
    local funcTable=classObject.__function
    local meta=classObject.__metaMethod
    if classObject.__debug then
        for _,member in pairs(self.members) do
            member:check(true)
            if member.ctype=="function" then
                decl[member.key]="publicFunction"
                funcTable[member.key]=member.object
            elseif member.ctype=="member" then
                decl[member.key]="publicMember"
                members[member.key]=member.object
            elseif member.ctype=="static" then
                decl[member.key]="publicStatic"
                classObject[member.key]=member.object
            elseif member.ctype=="const" then
                decl[member.key]="publicConst"
                protectedMembers[member.key]=member.object
            elseif member.ctype=="staticFunction" then
                decl[member.key]="publicStaticFunction"
                funcTable[member.key]=member.object
            elseif member.ctype=="meta" then
                meta[member.key]=member.object
                classObject[member.key]=member.object
            end
        end
    else
        for _,member in pairs(self.members) do
            member:check(false)
            if member.ctype=="function" then
                decl[member.key]="publicFunction"
                classObject[member.key]=member.object
            elseif member.ctype=="member" then
                decl[member.key]="publicMember"
                members[member.key]=member.object
            elseif member.ctype=="static" then
                decl[member.key]="publicStatic"
                classObject[member.key]=member.object
            elseif member.ctype=="const" then
                decl[member.key]="publicConst"
                members[member.key]=member.object
            elseif member.ctype=="staticFunction" then
                decl[member.key]="publicStaticFunction"
                classObject[member.key]=member.object
            elseif member.ctype=="meta" then
                meta[member.key]=member.object
                classObject[member.key]=member.object
            end
        end

    end
end

function public(memberTable)
    return LPublic:new(memberTable)
end

