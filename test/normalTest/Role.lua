--[[
你会在这里看到最常见的使用方式。
1.和类型同名即为构造函数
2.其他名字作为方法
3.class 存在于luaClass 命名空间中，要么使用完全限定名luaClass.class
要么给当前环境通过using_namespace 引入这样就可以直接使用class了
4.命名空间的声明必须是_ENV=namespace (nsName)的形式
实际上 如果仅仅是lua5.1 可以直接写成 namespace "battle"，考虑到版本移植,应该写成第一种形式

]]

require "luaClass.init"
require "test.normalTest.Equipment"
_ENV=namespace "battle"

using_namespace "luaClass"
using_namespace "container"


class ("Role"){
    public{
        FUNCTION.Role(function(self,name)
            self.name=name
            self.hp=0
            self.attack=0
            self.defence=0
            self.equipments=array()
        end);

        FUNCTION.attackRole(function(self,role)
            print(self.name.." attack "..role.name)
            local hurt=self.attack-role.defence
            role.hp=role.hp-hurt
            print("oh ! "..role.name.." hurt: "..hurt)
        end);

        FUNCTION.speak(function(self,str)
            print(self.name.." say "..str)
        end);

        FUNCTION.showInfo(function(self)
            print(self.name,self.hp,self.attack,self.defence)
        end);
    };
    public{
        MEMBER.name();
        MEMBER.hp();
        MEMBER.attack();
        MEMBER.defence();
        MEMBER.equipments();
    };

}
