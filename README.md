# lua类型体系
---
## 支持内容
* 全新风格的class体系
    * 引入luaClass库
    * 命名空间与class 声明
        * 声明命名空间
        * 使用命名空间
    * 混合方式的oop
        * public
        * protected
        * 函数与成员
            * 普通函数
            * 元方法函数
            * 静态函数
            * 普通成员
            * 常量成员
            * 静态成员
        * 属性
        * 信号槽
        * 继承与多态
            * 单继承
            * 多重继承
            * 宿主类型继承
            * 不自动继承
            
        * 扩展设计
            * LObject根类
            * LMetaObject类
            * ui设计基类LUIObject
            * ui脚本化设计类LUIScript

* 旧风格的class
* 性能伸缩与设计缺陷
* lua对象序列化与反序列化
    * serilize
    * unSerilize
* 基础算法
    * zip
    * reverse
    * 可序列化函数

* lua基础数据结构
    * array
    * queue
    * map
    * stack
    * mat
    * graph
    * set


---
### 面向对象体系

1. 引入 luaClass 库
    将 luaClass 文件夹放入可被搜索的根目录下,然后require "luaClass.init"就可以使用了

    这里推荐一种组织方式,按文件夹划分模块,每个文件夹有一个init.lua文件,用于加载这个文件夹里面的所有.lua文件. 

    跨模块的引用只需要require "xxxxx.init" 模块内的互相引用不包含init.

    luaClass都采用这种组织方式, 可以给path 添加?/init.lua; 这样只需要 require "xxxx"

    如果你查看luaclass 的源码你会发现里面使用 include 去替代 require

    include的定义就是require,这是为以后的设计做准备

2. 命名空间与class 声明

    整个luaClass 是构建在命名空间上的
    luaClass 只引入了全局变量 namespace和include以及luaClass命名空间

    * 声明一个命名空间

        ```lua
        require "luaClass.init"
        _ENV=namespace "test" 
        ```

        1. 声明命名空间之后,所有的定义都会存在于当前命名空间之中
        2. 声明命名空间之后,使用的变量会优先访问当前命名空间中已经定义的对象,然后访问using 过的命名空间中的对象,最后访问_G中的对象
        3. 在一个命名中间中定义的对象,可以通过使用 命名空间.对象名称 的方式引用比如

        ```lua
        --文件 test
        require "luaClass.init"
        _ENV=namespace "test"
        a=123456
        --文件 test2
        require "test"
        --会自动生成在test空间中的test2空间
        _ENV=namespace "test.test2"
        print(test.a) --123456

        ```

    * using 命名空间
        ```lua
        --文件test
        require "luaClass.init"
        
        _ENV=namespace "test"
        var=996
        --文件test2
        require "test2"
        _ENV=namespace "test2"
        using_namespace "test"

        print(var) --996

        ```
        1. using 命名空间之后,你可以不加前缀的使用这个空间中的对象
        2. 相同命名空间中的对象不必 using
        3. using_namespace 不是全局变量,只能跟在namespace 声明之后用
    * class 声明

        class定义于luaClass 命名空间中,并非全局变量

        class被注册到 namespace的直接访问对象中,优先级高于一切

        luaClass的class 与namespace 直接访问的class 参数有差异,namespace对class做特殊处理是为了方便加入命名空间中
        例子
        ```lua
        require "luaClass.init"
        _ENV=namespace "test"

        class "NO996" {

        }


        ```
        1. class并非全局变量
        2. 通过class 声明之后当前空间就会存在变量 NO996 他就是这个类对象
        3. class 函数返回值是一个函数并非一个对象,他返回的函数要求传入一个表,这个表决定类的方方面面,这个新函数的返回值是class 对象,所以也可以使用这种方式
        ```lua
        local NO996=class "NO996" {}

        ```
        4. 尽管local 类对象,但是依然不必返回这个类对象,这个类对象会自动存在于当前命名空间之中
* 使用风格

    luaClass 并不推荐使用传统模块化方案,因为命名空间的设计,传统的许多方案不再有意义.

    例如,传统的class 声明方案大多是这样的
    ```lua
    local Role=class ("Role")

    function Role:init()
    end
    .
    .
    .

    return Role

    ```
    
    传统的方案为了避免未预期的全局变量满屏幕都是local而且还要return 这个类或者模块
    

*  全新语法
    * 先看个例子
    ```lua
    require "luaClass.init"
    _ENV=namespace "test"
    using_namespace "luaClass"

    class ("metaTest") {
        property("Time"){READ.getTime;WRITE.setTime};
        public{ 
            FUNCTION.getTime(function(self) end);
            FUNCTION.setTime(function(self) end);
            FUNCTION.Do(function(self) end);
            FUNCTION.you(function(self) end);
            FUNCTION.want(function(self) end);
            FUNCTION.nine(function(self) end);
            FUNCTION.nine(function(self) end);
            FUNCTION.six(function(self) end);
            --         ?
            MEMBER.no();
            MEMBER.I();
            MEMBER.need();
            MEMBER.rest();

            CONST.NINE();
            CONST.SIX();
            CONST.FIVE();
            --      ?
            STATIC.good();

            STATICFUNC.getInstance(function(cls)
                if cls.s_instance==nil then
                    cls.s_instance=cls()
                end
                return cls.s_instance
            end);
        };
        protected{
            FUNCTION.metaTest(function(self) 
                self.name="metaTest"
            end);
            STATIC.s_instance();
            CONST.name();
        };
    }

    ```
    一目了然不是吗?
    你认为他有哪些效果,他可能就会有哪些效果.下面一一介绍
    * 首先要理解的是整个设计是利用的表的构造表达式来提供非同一般的语法.我究竟是怎样做的.去看源码吧.
    * 你看到的所有关键字都定义于luaClass命名空间中,所以必须引入luaClass命名空间

    * 你看到了public和protected,你可能会猜测还应该有private,实际上并没有private.

    * public是一个函数,他接受一个表作为他的参数,在表里面你可以写上各种成员.和你想的一样,public里面的成员都是可以被外部访问的.

    * protected也是一个函数,和public一样,不过意义不同的是,protected里面的成员是不可以在外部访问的.几乎没有class体系去实现访问控制,一方面是找不到合适的方式去控制访问,另一方面,这必然会带来相当的性能损失.关于性能后面会给出答案

    * 你看见了property,这个确实是属性,这个属性的设计跟QT很相似.但使用起来跟C#很相似.
    property也是一个函数,他接受一个字符串参数 这个参数作为属性的名字,之后返回一个新函数,这个新函数要求一个表.这个表用于指定属性的getter和setter.具体的语法是READ加上成员访问运算符,后面跟着getter需要调用的函数的名字.WRITE类似,用来表示setter.可以只有READ没有WRITE,也可以只有WRITE没有READ,也可以什么都没有.不过这就没有意义了.

    * 我个人认为属性应该是public的,所以就不必写在public里面.独立出来和public同级

    * MEMBER
    
        这个修饰用于表示,其后面的对象是一个成员,MEMBER._role(); 表示_role是一个成员变量,后面跟着一对括号,是因为你可以在括号里面指定这个这个成员的默认初始值.就像这样MEMBER._num(996);默认初始值必须是不可变类型,因为对于类的所有实例都会使用同一个初始值,而不是做一份拷贝. 为什么不实现拷贝?因为我无法清楚宿主的userdata的内存管理方式.MEMBER声明于public中就是公开的.声明于protected中就是受保护的.

    * CONST

        这个修饰和其他语言的语义并不完全相同,CONST只用于修饰成员,表示这个成员不会因为赋值而改变而不是不可变.就像这里
    ```lua
    --假设class里面有公开的CONST 成员 FIRST,其初值为996
    CONST.FIRST(996);

    --假设NO996是一个类型实例
    --那么以下会抛出异常
    NO996.FIRST=965
    ```

    * STATIC

        这个修饰用于表示,成员是全体实例共享的,在实现上这个修饰的成员是作为class的field存在

    * FUNCTION

        这个修饰用于修饰成员函数,成员函数一旦被定义将不可更改
        例如
    ```lua
    class "testClass" {
        public{
            FUNCTION.testClass(function(self)
            
            end);

            FUNCTION.getValue(function(self)
            
            end);

        }

    }

    local instance=testClass()
    instance.getValue=function()end
    --error:attempt to assign to member testClass::getValue ,it is protected
    ```
    1. 这里面出现了构造函数,和类型同名的成员函数就是这个类的构造函数,所有类都必须显式声明构造函数,尽管他可以是空的实现.既然设计了默认初始值为什么不设计默认构造函数? 这就涉及到继承,因为基类构造函数必须显式调用,我无法确定基类如何构造.

    2. 构造函数同样可以被protected控制访问.被控制时,你无法在外部构造类型实例
    ```lua
    require "luaClass.init"
    _ENV=namespace "test"
    using_namespace "luaClass"

    class ("ProtectedTest"){
        property ("Value"){READ.getValue };
        property ("Change") {WRITE.setProtected};
        public{
            STATICFUNC.getInstance(function(cls)
                if cls.s_instance==nil then
                    cls.s_instance=cls()
                end
                return cls.s_instance
            end)
        };
        protected{
            FUNCTION.ProtectedTest(function(self)
                self._protected=998
                print(self.Value)
                self.Change=3344
                print(self._protected)
            end);
            FUNCTION.getValue(function(self)
                print("get _VALUE");
                return self._VALUE
            end);
            FUNCTION.setProtected(function(self,value)
                print("set _protected")
                self._protected=value
            end);
            MEMBER._protected();
            CONST._VALUE(7744);
            STATIC.s_instance();
        };
    }
    --throw error 
    local pr2=ProtectedTest()
    
    ```
    构造函数将抛出异常,具体将抛出怎样的异常去测试用例,protectedTest看就知道了
    3. 虽然我写的例子构造函数都不用传递参数,但是构造函数是可以有参数的
    ```lua
    class "ITworker"{
        public{
            FUNCTION.ITworker(
                function(self,name,support996)
                    self._name=name
                    self._support996=support996
                end
            );

        };

        protected{
            MEMBER._name();
            MEMBER._support996();
        };

    } 

    local itWorker=ITworker("码农不配有名字",false)
    local itWorker2=ITworker:new("我好菜啊",true)
    local itWorker3=ITworker:create("钱到位,人到位",true)
    ```
    4. 上面展示了三种构造类的方式,C++风格,lua的new风格,cocos的create风格,这是为了兼容旧代码而作的设计.

    * STATICFUNC

        这个修饰是用于创建静态函数的,静态函数内部被视为类的内部,可以访问受保护的成员.之前的例子展示了单例的写法
        我更倾向于如果要定义静态函数,第一个参数取名cls而不是self

        这个修饰不可作用于protected的成员,因为我觉得static function,私有没什么用.

    * META

        这个修饰没有出现在例子里面,这个是用于声明元方法的,同样只在public中生效,与其他函数不同的是,META修饰的元方法被认为是类外部,所以只能调用public成员.这是因为元方法中比如__concat,无法确定他的两个参数中哪一个会是self
    * 超模的写法

        这种写法对lua来说非常超模。超过了大部分lua语法linter 或者ide 的解析极限。
        所以我同样支持下面的写法
        ```lua
            local host=class "host" {
                public{
                    FUNCTION.host;
                    FUNCTION.getWhat;
                };

                protected{
                    MEMBER._value;
                }

            }

            function host:host(value)
                self._value=value

            end

            function host:getWhat()
                return 996
            end
        ```

        这种写法和传统的lua class 方案很相似，只不过需要在class 后面接的构造表中增加一些声明。
        当然这并非是强制的，可以通过添加CLASS_DEBUG(false);
        让luaclass 放弃这个class 的debug，就可以不用写声明了。
        例如
        ```lua
            local host=class "host" {
                CLASS_DEBUG(false);
            }
            function host:host(value)
                self.value=23333333+value
            end
        ```
* 信号槽

    熟悉QT的朋友应该知道这个强大的通信方式.我在luaClass也造了这么一个假冒伪劣的信号槽通信机制,只能够同步发送信号,异步需要根据开发框架再做设计.这个C# 的weak event 其实也很像，熟悉weak event 的朋友可以自己造一个类似的东西。

    * 看个例子
    ```lua
    require "luaClass.init"
    _ENV=namespace "test"
    using_namespace "luaClass"

    class ("SignalTest"){
        SINGAL.classCreate();
        public{
            FUNCTION.SignalTest(function(self,content)
                self._content=content
                connect(self,"classCreate",self,"hello")
                connect(self,"classCreate",self,"world")
                
                self:classCreate()
            
            end);
            FUNCTION.hello(function(self)
                print("hello",self._content)
            end);

            FUNCTION.world(function(self)
                print("world",self._content) 
            end)

        };
        protected{
            MEMBER._content();

        };
    }
    local instance1=SignalTest(996)
    local instance2=SignalTest(966)
    local instance3=SignalTest(965)
    ```

    * 通过SIGNAL去修饰一个信号,而槽没有一个独立的修饰关键词只需要是public的函数即可.

    * connect函数
    
        这个函数第一个参数是信号源,第二个参数是信号的名字,第三个参数是响应信号的对象,第四个参数是槽的名字

        这个函数有一个变化,或者说重载,第四个参数也可以是一个函数对象,这样第三个参数的意义是和这个函数同生命周期的对象.

        举个例子
        
    ```lua

    connect(self,"createClass",self,function()
        print("998")
    end)

    ```
    
    * 信号设计

        在实现上,是采用弱表去保留 连接,目标的生命周期决定连接的存在,当然如果信号源实例已经被清理了,连接也不存在.

    * 信号传递参数与信号转发

        1. 信号像普通函数一样调用,没有emit关键词.你给信号传递了哪些参数,槽就会收到哪些参数例如
        ```lua
            self:createClass(998,"xixixixix","11511")
            --假设下面是一个槽函数
            他会收到998,"xixixixixi","11511"三个参数
            function (p1,p2,p3)
                print(p1,p2,p3)
            end
        ```
        2. 你可以把一个信号转发给另一个信号
        ```lua

        class "test" {
            SIGNAL.signal1();
            SIGNAL.signal2();
            public{
                FUNCTION.test(function(self)
                    connect(self,"signal1",self,"signal2")
                end)
            }
        }


        ```
        3. 上面的转发方式要求两个信号参数相同,如果不同可以这样
        
        ```lua

        class "test" {
            SIGNAL.signal1();
            SIGNAL.signal2();
            public{
                FUNCTION.test(function(self)
                    connect(self,"signal1",self,function()
                        self:signal2("123456789")
                    
                    end)
                end)
            }
        }


        ```
        4. 可以在信号声明中标注要传入哪些参数
        ```lua
        class "test" {
            SIGNAL.touched("touch","event")
        }

        ```
        这些标注的参数并不会使用,仅仅是给自己一个提示.
        为什么不做类型检查?因为我觉得不是很有必要,这样会失去灵活性.

        5. 清理连接
        如果 当前的信号已有的连接并不需要,可以调用信号的clear方法
        例如
        ```lua
            instance.touched:clear()

        ```
        然后再重新连接需要的信号
* 继承与多态

    * 单继承

    ```lua
    class "test" {
        super(LObject);
        public{
            FUNCTION.test(function(self)
                --调用基类构造函数
                self:LObject()

            end)

        }
    }

    ```
    这样test 就继承了LObject

    继承了一个类就需要显式的调用他的构造函数,如果基类构造函数为空可以不用调用,但是除了LObject外,建议都要调用
    * 多重继承
    
    看一个例子
    ```lua
    require "luaClass.init"
    _ENV=namespace "test"
    using_namespace "luaClass"

    class ("baseClass"){
        public {
            FUNCTION.baseClass(function(self)
            end);
            FUNCTION.speak(function(self)
                print("base speak");
            end);
            FUNCTION.speak2(function(self)
                print("base speak2");
            end)
        };
    }
    class ("baseClass2"){
        public{
            FUNCTION.baseClass2(function(self)
                self._fff=996
            end);
            FUNCTION.say(function(self)
                print(self._fff.." is your reward")
            end);
        };
        protected{
            MEMBER._fff();

        }
    }

    class ("subclass"){
        super(baseClass);
        super(baseClass2);
        public{
            FUNCTION.subclass(function(self)
                --call base1 class ctor
                self:baseClass()
                --call base2 class ctor
                self:baseClass2()
            end);
            FUNCTION.speak(function(self)
                print("subclass speak");
            end);
        }

    }

    local base =baseClass()
    base:speak()
    base:speak2()

    local sub=subclass()
    sub:speak()
    sub:speak2()
    sub:say()

    ```
    1. 继承在实现上是将基类的函数全部复制到当前类中,然后当前类写的同名函数就会覆盖基类继承下来的函数.

        为什么不用元表的方式做继承?

        元表的方式做继承如果继承链特别长的话,性能开销会越来越大,如果采用缓存加速的方式,那么缓存到哪呢?缓存到类上的话,这种会影响到所有的类的实例,而且既然要缓存到类,为什么不一开始就缓存好呢?缓存到类型实例,这样速度确实会更快,但是这样一方面就破坏了访问控制,另一方面方法和实例不再分离.到时候序列化就更不好做了.

    2. 但是这种继承方式会引发一个问题,后继承的类如果有和前一个类同名的方法,那么后继承的类会覆盖前一个类的方法.了解弊端,清楚弊端,然后就要自己去避免弊端.

    * 宿主类型继承

        关于宿主类型的继承,不同的框架有不同的方式,我尽可能设计了通用的方案,但是由于精力问题,我并没有对Unity的宿主类型继承做适配.
        
        以下针对cocos2dx 下的tolua++
        
        当然为了便于更换对宿主类型继承的支持,与宿主类型有关的设计,写在luaClass/class/config/classconfig.lua里面,可以尝试修改这里,来继承其他框架类型,等我以后有精力了再去尝试对xlua做适配

        先看个例子
        ```lua
        _ENV= namespace "ui"
        using_namespace "luaClass"
        class "Sprite" {
            super(cc.Sprite,ui.LUIObject);
            public{
                FUNCTION.Sprite(function(self,imagePath)
                    self=self:__super(imagePath)
                    self:LUIObject()
                end)
            }
        }

        ```

        1. 对宿主类型的继承跟普通的luaClass类是基本一样的.但是有这样的缺点,只能直接或者间接的继承一个宿主类型,当然可以多重继承其他luaClass类型.

        2. 调用基类构造,宿主类型的基类构造和luaClass的构造方式是不一样的,需要这样写,而且一定要写在前面
        ```lua
            self=self:__super(...)
        ```
        
        3. 继承宿主类型之后的类型创建跟luaClass类一样的,例如
        ```lua
            local sprite=Sprite("img.png")
            local sprite2=Sprite:create("ima.png")
            local sprite3=Sprite:new("img.png")

        ```
    * 不自动继承

        实际上所有luaclass 类都会直接或者间接的继承基类LObject,就算你不写super,也会继承LObject.这是一个根类,提供了通常需要被使用到的方法.具体这个根类有哪些方法参考后文.

        当然如果你不想继承LObject可以写上NO_AUTO_INHERIT()例如
        ```lua
        class "test" {
            NO_AUTO_INHERIT();

        }

        ```
    * 多态
    
        派生类如果重写了基类方法,那么会自然调用派生类方法.
        那么问题是如何在重写方法中调用基类方法.

        看下面的例子
    ```lua
    
    class ("baseClass2"){
        public{
            FUNCTION.baseClass2(function(self)
                self._fff=996
            end);
            FUNCTION.say(function(self)
                print(self._fff.." is your reward")
            end);
        };
        protected{
            MEMBER._fff();

        }
    }

    class ("subclass"){
        super(baseClass2);
        public{
            FUNCTION.subclass(function(self)
                self:baseClass2()
            end);

            FUNCTION.say(function(self)
                print("hello world")
                self:getSupers("baseClass2").say(self)
            end);
        }

    }
    local sub=subClass()
    sub:say()
    ```

    1. 如果继承了LObject,就可以调用方法getSupers,这个方法接受类名,返回该类的类对象

    2. 还可使用第二种方式这种方式是C++风格的.
    ```lua
        print("hello world")
        baseClass2.say(sef)
    ```

* 扩展设计

    * LObject
        
        1. 这个luaClass的根类,构造函数是空函数,所以不必显式调用

        2. 提供了一些有用的方法,
        * getType 返回当前实例的类
        * getClassName 返回当前类的类名
        * getNamespace 返回当前命名空间的名字
        * getSupers 要求一个参数返回他的基类
        * getMetaObject 返回一个元对象类
        * inherit 判断当前实例是否继承自某个基类
        * isHost 判断当前类是否是宿主实例
        * isExistField 判断是否存在某个成员
        * isExistFunction 判断是否存在某个函数
        * serilize 从自身开始序列化.
        * toString 返回描述自己的字符串

            值得注意的是LObject还定义了__tostring和__concat.他们都是转调用 toString,所以对于纯luaClass类,如果派生自LObject你可以直接print(object),也可以""..object..123

        关于函数的测试,自己去看luaClass/test/accessedTest/LObjectTest
    * LMetaObject
        
        这个类主要是用于返回类有哪些修饰过的方法,具体去看
        luaClass/test/accessedTest/LMetaObjectTest
    * LUIObject

        这个类是一个UI设计基类,理论上其他框架也可以修改这个框架后使用.

        这个基类有这样性质,定义大一大票属性.可以实现UI 脚本化配置...哎我不想写了,你们应该也不会去采用这个类.
* 旧风格class
    
    前面的篇幅都是介绍的新class语法,那么为了兼容旧有的代码,依然提供传统的class方式例如

    ```lua
    class "INeedJob" {
        --有这个声明之后就可以使用旧风格的class
        CLASS_DEBUG(false);
        --通过super继承某类
        --super(...);
        --也可以写属性
        --property ...
    }

    function INeedJob:INeedJob(company,telephone)
        self._company=company
        self._telephone=telephone

    end

    .
    .
    .

    ```

    当然实际上luaClass可以和大部分合理设计的Class共存,因为整个luaClass只引入了少数的全局变量,而且class只存在于 luaClass 和namespace 的优先访问field中.

* 性能伸缩与缺陷
    * 性能伸缩

        你可能会想,如此厚重的设计,势必会带来极大的性能开销,debug与性能不能兼得.

        而实际上并不是这样,设计之初性能就作为最需要考虑的地方.
        
        public,protected的访问控制会带来很大的性能消耗,当你debug完毕觉得项目可以上线的时候,可以去luaClass/class/config/classConfig.lua 文件查看一个叫LUA_DEBUG的变量,如果为true则对于未显式指定debug程度的class 将开启比较严格的检查.

        如果为false,则对于未显式指定debug程度的class将不开启debug,__index和__newindex将切换为非debug函数

        如果整个类并未继承或者设计属性__index将切换为类本身.

        在这种设计的情况下,就跟传统的class没什么区别了

        如何显式指定类的debug?

        就是在构造表里面声明CLASS_DEBUG(false);
        ```lua
            class "nodebug" {
                CLASS_DEBUG(false);
            }
        ```
    * 设计缺陷

        1. 语法对于传统lua开发者来讲过于新颖,一时不容易接受.甚至可能除了我自己别人都不会采用.

        2. 对灵活的脚本语言增加了这么多的条条框框,变得不再灵活.我知道很多人可能都有这样的想法,我自己也有这样的想法.直到我重构项目的时候.
        
            我就知道,如果没有条条框框的保证，很多事情就变得很难处理.
        
        3. 信号槽的连接释放时机,如果要连接宿主类型,会存在这样的问题.宿主管理的对象已经释放了,而lua 的userdata 还依然存在,并没有立即被gc掉.此时连接就不会自动移除.所以需要自己小心控制生命周期.等lua5.4的to-be-close语法出来后,再看看有没有什么办法.
        
        4. 这个class设计的内容太多了,你能看README到这里已经很有耐心了.这是我没有办法的事情.

        5. luaclass 可以有三种形态，超模形态对大部分lua插件不友好。将class 分为声明和定义的形态可以完美的拥有luaclass的debug能力和lua插件的帮助。完全退化形态，可以回归到普通的class 写法，取消luaclass 的debug能力，但是可以只声明关键的部分，让class拥有简单的多重继承和属性的语法。

## 序列化
* luaClass 原则

    luaClass的类型实例和类是严格分离的,实例上不会有方法.

* 如何使用序列化

    继承自LObject的类都会有一个方法 serilize
    这个方法从该类开始序列化,返回序列化的结果
    像下面这样
    ```lua
    role:serilize()
    ```
    * luaClass序列化的特点
        0. 非侵入式序列化

            这可能是个优点，也可能是个缺点，未来可能会设计出侵入式序列化方案，类似protobuf的声明格式

        1. 可以互相引用

            a引用了b,b又引用了a,序列化会自动处理这个问题
        2. 可以自引用
            
            也就是 a.c=a
        3. 支持的key类型丰富
            
            key不仅可以是number和string,也可以是类对象,或者普通的表
            最极端的例子是
            ```lua

            self[self]=self
            ````
        4. 支持value类型丰富

            value除了可以是key能支持的类型,还可以是函数,将无upvalue的函数序列化.如果这个函数必须是有upvalue的.可以采用algorithm 的Func.这是一个可序列化函数类.

            他通过捕获列表去捕获upvalue(全局变量不需要捕获)
        5. 序列化的结果是lua表格式的字符串

        6. 具体长什么样,可以去看test文件夹里面的测试用例.

 

    * 如何反序列化

        反序列化函数是unSerilize()存在于命名空间luaClass中,
        他接受一个字符串,并返回反序列化后的对象.
        ```lua
        --debug修复，之前不会返回新对象，这个函数有两个参数，自己看看就知道
        unSerilize(str)
        ```
## 迭代器

* 提供两种常见迭代器 zip 和reverse
    
    zip可以同时遍历多个等长的数组
    像这样
    ```lua
    local a={1,2,3,4}
    local b={5,6,7,8}
    local c={10,11,12,13}
    
    for i,_a,_b,_c in zip(a,b,c) do
        print(i,_a,_b,_c)

    end
    
    for i,v in reverse(c) do
        print(i,v)
    end
    
    ```
* 可序列化函数

    不写了

## 数据结构
    
与上面的设计相比,这里的设计显得很不够看,算是送的吧.

我写了很多数据结构，每一个都要展示就太麻烦了。自己去看测试用例。container用例应该足够使用了
这里就介绍一下他们的名字
* array 数组
* stack 栈
* queue 队列，实现上是循环队列
* set 集合 
* map 字典
* mat 矩阵，这个做的很一般
* graph 图，只有两个算法广度优先和深度优先。



