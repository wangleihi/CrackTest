# CrackTest
MAC应用破解

### 说明：
我们创建的这个简单应用,是模仿注册码验证的一个逻辑判断(其实你也可以把这个当作是登录验证,道理是相同的),如果用户输入1234,我们认为是正确的结果,显示验证通过,否则都会显示验证码错误这样的提示信息

### 准备工具：
1、Mac OSX下的反汇编工具: Hopper Disassembler (本次使用v4.0.8)
2、基本的汇编指令(比如mov ,xor ,jmp,je 等)

- 先从xcode build产物中获取xx.app应用
- 打开Hopper Disassembler，将需要破解的应用(就是xx.app)拖入到Hopper中
确认选择界面
![](https://github.com/wangleihi/CrackTest/416012-c27ea02157e7e413.webp)
加载后的界面,入下图
![](https://github.com/wangleihi/CrackTest/416012-845f123a98be2016.webp)
这个界面的布局和Xcode非常相似,大家不要被一些看不懂的内容界面和工具栏迷惑而感到微微的手足无措(笔者第一次看到这个界面,也是茫然的~),我们下面把基本上常用的会一一介绍,其他的的功能按钮,先当作不存在(催眠式提升信心法~~),好,我们先来看一下工具栏下面的左侧Labels窗口:
![](https://github.com/wangleihi/CrackTest/416012-546cb583bfb1ca2c.webp)
这个Labels窗口中列出的是应用被反编译后可以识别出来Objective-c方法,看到这些熟悉的方法名,小伙伴们是不是一下子感觉又回到Xcode代码中啦,让我们先忘记掉我们之前写过的工程代码,从这个列表里,我们根据方面名称,大致可以推断(破解的一个要素就是要有根据的猜测)出这几个方法的用途:
[ViewController viewDidLoad] ====>  视图生命周期方法,加载视图的时候调用

[ViewController checkCode:] ====>  从名字可以看着,这个方法是用来做验证检查的(后面会进一步分析)

[ViewController textField] : ====>  get方法,获取文本输入控件

[ViewController setTextField: ] ====> set方法,设置文本输入控件

[ViewController tintLable]  ==== >  get方法,获取提示文本控件

[ViewController setTintLabel:]   ====> set方法,设置提示文本控件

- 查看checkCode:方法
我们根据方法名列表,最值得怀疑的就是checkCode:(就像如果破解一个软件的vip身份,那么如果看到isVip就应该给予特别注意一样)
![](https://github.com/wangleihi/CrackTest/416012-cc9ceb9dff03b2ea.webp)
从这个图里的右侧流程部分,我们可以看出checkCode这个方法的执行逻辑是这样的:
checkCode方法入口---> 执行一些代码(我们先不管这些代码在做什么)--->选择两个分支代码段中的一个执行---> 再执行一些代码后,checkCode方法结束
![](https://github.com/wangleihi/CrackTest/416012-c13579b7a2f3fe05.webp)

- 假设阶段
![](https://github.com/wangleihi/CrackTest/416012-1a962a45645ff52a.webp)
这三行汇编代码是:
mov al,byte [rbp+var_29]     ====> 这句汇编的含义相当于我们使用高级语言里的赋值语句,例如 al = 123(这里是为了理解写al = 123来举例,程序运行真实的al值并不是123),我们先把al当作一个变量来看,不去想al寄存器的事情

cmp al,0x0    ====> 这个汇编的含义是进行两个值的比较 ,我们可以把它想象成一个高级语言的比较函数,后面是两个参数,例如cmp(a,b), 执行后返回比较的结果,汇编执行比较,其实是做减法运算,因此两个数相减会有三种情况,分别是大于零,等于零,小于零,这三种结果,有可以简单分为两个:相等,或不相等

je loc_10001054  ====> 这个汇编的含义,我们可以认为是 相等(equality), 不相等是jne, 在汇编中,一般cmp后面都会根上类似的判断跳转语句. 因此这行代码下面会有两个分支(参考方法的流程图),如果cmp的比较结果是相等,就执行 loc_10001054 这个分支,否则就执行另外的那个分支(方法流程图中红色线条指向的那个分支)

- 求证阶段
现在我们面临的问题是,哪个分支才是正确结果的那个部分呢?
我们不必去读懂两个分支的汇编代码(如果你有兴趣另说),只需要修改逻辑并根据执行结果来验证就好了,比如,我们去除掉je loc_10001054 这个相等就执行的汇编代码,这样,checkCode的执行逻辑就被我们修改为没有分支loc_10001054的直线流程了.好,先动手试试
![](https://github.com/wangleihi/CrackTest/416012-435a84225d40f88e.webp)
替换掉je loc_10001054这条汇编指令(就是去掉条件判断,不管比较结果如何,都会执行固定的分支)
保存修改后的结果,生成新的可执行文件，这里注意保存的路径一定不能与xx.app相同!，然后使用新的可执行文件,替换掉破解前的可执行文件，运行破解后的demo.app：
![](https://github.com/wangleihi/CrackTest/416012-089c0490c03cf889.webp)