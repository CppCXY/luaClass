require "luaClass.init"

_ENV=namespace "test"

function testTime(luaf)
    local startTime=os.clock()
    luaf()
    local endTime=os.clock()
    print("it cost time "..(endTime-startTime).." s ")
end



