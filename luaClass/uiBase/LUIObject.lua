include "luaClass.class.init"
include "luaClass.uiBase.UIScript"
_ENV=namespace "ui"
using_namespace "luaClass"
using_namespace "container"
local unpack=unpack or table.unpack

local LUIObject=class ("LUIObject"){
    super(LObject);
    SINGAL.touched("touch","event");
    SINGAL.destroyed();
    property "tag" {WRITE.setTag; READ.getTag};
    property "anchor" {WRITE.setAnchorPoint; READ.getAnchorPoint;};
    property "pos" {WRITE.setPosition; READ.getPosition};
    property "scale" {WRITE.setScale;READ.getScale};
    property "opacity" {WRITE.setOpacity;READ.getOpacity};
    property "color" {WRITE.setColor;READ.getColor};
    property "rotation" {WRITE.setRotation;READ.getRotation};
    property "onExit" {WRITE.setOnExitCallBack};
    property "id" {WRITE.setID;READ.getID};
    property "size" {WRITE.setContentSize;READ.getContentSize};
    property "onTouch" {WRITE.onNodeTouch};
    property "backGround" {WRITE.setBackGround};
    public{
        FUNCTION.LUIObject(function(self)
            self._idParams={}
            self._idComponents={}

        end);

        FUNCTION.getID(function(self)
            return self._id
        end);

        FUNCTION.setID(function(self,value)
            self._id=value
        end);

        FUNCTION.onNodeTouch(function(self,swall)
    
            local onTouchBegin = function(touch, event)
                if self:isVisible()==false then return true end
                local target = event:getCurrentTarget()
                local size = target:getContentSize()
                local rect = cc.rect(0, 0, size.width, size.height)
                --local p = touch:getLocation()
                local p = target:convertTouchToNodeSpace(touch)
                if cc.rectContainsPoint(rect, p) then
                    self:touched(touch,event)
                    return swall
                end
                return false
            end
            local listener = cc.EventListenerTouchOneByOne:create()
            listener:setSwallowTouches(swall)
            listener:registerScriptHandler(onTouchBegin, cc.Handler.EVENT_TOUCH_BEGAN)
            local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
            eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
        end);

        FUNCTION.load(function(self,uiScript)
            self._uiScript=uiScript:getScript()      
        end);

        FUNCTION.setParams(function(self,id,paramsTable)
            self._idParams[id]=paramsTable
        end);

        FUNCTION.implement(function(self)
            self:_parse(self._uiScript, nil,self,nil)
            self._uiScript=nil
            self._idParams=nil
        end);

        FUNCTION.find(function(self,id)
            return self._idComponents[id]
        end);

        FUNCTION.setBackGround( function(self,backPath,contentSize,color)
            self._backGroundPath=backPath
            contentSize=contentSize or self:getContentSize()
            if  self._backGround then
                self._backGround:removeFromParent()
                self._backGround=nil
            end
            local backGround;

            if backPath then
                backGround=cc.Sprite:create(backPath)
                :setPosition(0,0)
                :setAnchorPoint(0,0)
                :setContentSize(contentSize)
                :addTo(self,-10)
            else
                local pointArr={
                    cc.p(0,0),
                    cc.p(contentSize.width,0),
                    cc.p(contentSize.width,contentSize.height),
                    cc.p(0,contentSize.height)
                }
                local fill=color or cc.c4f(0,0,0,0.6)
                backGround=cc.DrawNode:create()
                backGround:drawPolygon(pointArr,4,fill,2,fill)
                backGround:setAnchorPoint(0,0)
                :setContentSize(contentSize)
                :addTo(self,-10)
            end
            self._backGround=backGround
            return self
        end);

        FUNCTION.clear(function(self,key)
            if  self[key] then
                self[key]:removeFromParent()
                self[key]=nil
            end
        end);

        FUNCTION.delayClear(function(self,key,delayTime)
            local node=self[key]
            
            local action=cc.Sequence:create(
                cc.DelayTime:create(delayTime),
                cc.CallFunc:create(function()
                    node:release()
                end)
            )
            if  node then
                node:retain()
                node:removeFromParent()
                self:runAction(action)
            end
            self[key]=nil
        end);

        FUNCTION.remove(function(self)
            local destroyed=self.destroyed
            self:removeFromParent()
            destroyed(nil)
        end);
        

        FUNCTION.addUpdateFunction(function(self,name,callBack,bindArgs)
            if not self.InUpdate then
                self.InUpdate=true
                self.CallFunctions=map()
                self:onUpdate(function()
                    for _,call in self.CallFunctions:iter() do
                        call(bindArgs)
                    end
                end)
            end
            self.CallFunctions:insert(name,callBack)
        end);


        STATICFUNC.script(function(cls,uiScript)
            uiScript.__class=cls
            return uiScript            
        end);

        --get object string desciption
        FUNCTION.toString(function(self)
            return " [LUIObject: "..self.__cname.."]"
        end);
    };
    protected{
        FUNCTION._parse(function (self,uiScript,classObject,classInstance,parentInstance)
            local instance=classInstance
            if instance==nil then
                local create=self._idParams[uiScript.id] or uiScript.params
                instance=create 
                and classObject(unpack(create))
                or classObject()
            end
            self._idComponents[uiScript.id]=instance
            if parentInstance then
                parentInstance:addChild(instance)
            end

            for prop,value in pairs(uiScript) do
                if type(prop)=="number" then
                    self:_parse(value,value.__class,nil,instance)
                elseif prop~="__class" and prop~="params" then
                    instance[prop]=value
                end
            end
        end);
    };
    public{
        MEMBER.CallFunctions();
        MEMBER.InUpdate();
    };
    protected{
        MEMBER._id();
        MEMBER._uiScript();
        MEMBER._idParams();
        MEMBER._idComponents();
        MEMBER._backGround();
        MEMBER._backGroundPath();
    };
}


