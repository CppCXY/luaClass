include "luaClass.class.namespace"
include "luaClass.class.config.init"
_ENV=namespace "luaClass"

LProtected={}
LProtected.__index=LProtected
function LProtected:new(memberTable)
    local object={
        members=memberTable;
    }
    setmetatable(object,self)
    return object

end
function LProtected:implement(classObject)
    local members=classObject.__protected_member
    local decl=classObject.__decl
    local funcTable=classObject.__function
    if classObject.__debug then
        for _,member in pairs(self.members) do
            member:check(true)
            if member.ctype=="function" then
                decl[member.key]="protectedFunction"
                funcTable[member.key]=member.object
            elseif member.ctype=="member" then
                decl[member.key]="protectedMember"
                members[member.key]=member.object
            elseif member.ctype=="static" then
                decl[member.key]="protectedStatic"
                classObject[member.key]=member.object
            elseif member.ctype=="staticFunction" then
                decl[member.key]="protectedStaticFunction"
                funcTable[member.key]=member.object
            elseif member.ctype=="const" then
                decl[member.key]="protectedConst"
                members[member.key]=member.object
            end
        end
    else
        for _,member in pairs(self.members) do
            member:check(false)
            if member.ctype=="function" then
                decl[member.key]="protectedFunction"
                classObject[member.key]=member.object
            elseif member.ctype=="member" then
                decl[member.key]="protectedMember"
                members[member.key]=member.object
            elseif member.ctype=="static" then
                decl[member.key]="protectedStatic"
                classObject[member.key]=member.object
            elseif member.ctype=="staticFunction" then
                decl[member.key]="protectedStaticFunction"
                classObject[member.key]=member.object
            elseif member.ctype=="const" then
                decl[member.key]="protectedConst"
                members[member.key]=member.object
            end
        end
    end
end

function protected(memberTable)
    return LProtected:new(memberTable)
end

