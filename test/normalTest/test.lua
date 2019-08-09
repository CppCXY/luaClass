require "test.normalTest.Role"

_ENV=namespace "test"

using_namespace "battle"
 
local role=Role("oneRole")
role.attack=998
role.defence=334
role.hp=9988
role:speak("ok")
role:showInfo()

local equipment=Equipment("xixixi",3,4)
role.equipments:push_back(equipment)
local role2=Role("tworole")
role:attackRole(role2)
equipment:showInfo()
print(role:serilize())

