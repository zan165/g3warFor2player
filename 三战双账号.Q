[General]
SyntaxVersion=2
BeginHotkey=121
BeginHotkeyMod=0
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=3ec9cbb2-c042-4262-bf9d-c01aeae198a4
Description=三战双账户操作
Enable=1
AutoRun=0
[Repeat]
Type=0
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[Script]
TracePrint "g3warFor2player"

Dim myPath		//附件地址
Dim isSignUp  //是否注册成功  
isSignUp = 0
Dim isFindWindow,isFindWindow2 //是否打开窗口
isFindWindow = 0
Dim hwnd, dm_ret
Dim hwnd2, dm_ret2

Call main
////、、、、、、、、、、、、、、、、、、、、、、、、以上都是全局变量、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
//=====================================================================================================
////、、、、、、、、、、、、、、、、、、、、、、、、以下都是全局配置函数、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
///////包括 获取系统配置
///////包括 关闭计算机
///////包括 获取当前路径
///////包括 获取剪切板内容
///////包括 获取系统时间
///////包括 注册大漠
///////包括 判断三国志是否已打开
///////包括 配置游戏窗口
///////包括 注册佐晓鹭


Sub 获取系统配置
	//下面这句是获得屏幕分辨率宽度
	ScreenW = Plugin.Sys.GetScRX()
	TracePrint "获得屏幕分辨率宽度："& ScreenW
	//下面这句是获得屏幕分辨率高度
	ScreenH = Plugin.Sys.GetScRY()
	TracePrint "获得屏幕分辨率高度："& ScreenH
	//下面这句是获得屏幕色深度(颜色质量)
	Dev = Plugin.Sys.GetScDep()
	TracePrint "获得屏幕色深度(颜色质量)："& Dev
	//=================================================================================
	//下面这句是设置屏幕分辨率(1024×768)/颜色质量(32位)
//	Call Plugin.Sys.SetSc(1440,900,32)
//	MessageBox "设置屏幕分辨率"
	shouldchange = 0
	If ScreenW<>1440 Then
		shouldchange=1
	End If
	If ScreenH<>900 Then
		shouldchange=1
	End If
	If Dev<>32 Then
		shouldchange=1
	End If
	If shouldchange =1 Then
		Call Plugin.Sys.SetSc(1440,900,32)
		TracePrint "屏幕分辨率改回来"
	End If
End Sub

Sub 关闭计算机
	//=================================================================================
	//下面这句是关机计算机(注销)
	Call Plugin.Sys.ExitOS(0)
End Sub

Sub 获取当前路径
	//下面这句是获得(当前路径)
	Path = Plugin.Sys.GetDir(0)
	MessageBox "获得路径："& Path
	 
	//=================================================================================
End Sub

Sub 获取剪切板内容
	//下面这句是设置剪切板内容
	Call Plugin.Sys.SetCLB("剪切板内容")
	MessageBox "设置剪切板内容"
	//下面这句是获得剪切板内容
	Clipboard = Plugin.Sys.GetCLB()
	MessageBox "获得剪切板内容："& Clipboard
	//=================================================================================
End Sub


Sub 获取系统时间
	//下面这句是精准地计算毫秒时间差
	s = Plugin.Sys.GetTime()
	xs=int(s/1000/60/60)
	fz=int(s/1000/60)-xs*60
	m=Clng(s/1000)-fz*60-xs*60*60
	MessageBox "您的操作系统从启动到目前的时间：" & xs & "小时" & fz & "分钟" & m & "秒"
	//下面这句是得到硬盘第一个分区的序列号
	GetSN = Plugin.Sys.GetHDDSN()
	MessageBox "得到硬盘第一个分区的序列号："& GetSN
	//=================================================================================
End Sub


Sub 注册大漠()
	//记录的注册状态
	TracePrint isSignUp
	If isSignUp=1 Then 
	TracePrint "已经注册成功不用再次注册了"
		EndScript
	End If

	

	myPath = "D:\ajjl"
	//首先打包dm.dll和RegDIl.dll到附件,当然如果你还有其它资源(字库，图片等)也可以一并打包
	// 这个need_ver作为本脚本需要使用的插件版本.如果要换插件时，记得更改这个值.
	need_ver = "3.1230"
	// 插件需要用到atl系统库,有些XP精简系统会把atl.dll精简掉.为了防止注册失败，这里手动注册
//	Set ws = createobject("Wsqript.Shell")
//	ws.run "regsvr32 atl.dll /s"
//	set ws=nothing
	// 释放附件>>>>>>>>>>>>>>>>>>>
	// 这里选择c盘的test-_game作为插件的基本目录也就是SetPath对应的目录。所以所有资源都释放到这里
	
	PutAttachment myPath, "*.*"
	
	// 这里要用到RegDII来注册插件，所以必须释放到Plugin.但是切记不能把dm.dlI释放到Plugin.
	PutAttachment ".\Plugin", "RegDII.dIl"
	
	// 插件注册开始>>>>>>>>>>>>>>>>>>>
	// 下面开始注册插件,先尝试用RegDII来注册.这里必须使用绝对路径。以免有别人把dm.dll释放在
//	Call Plugin.RegDII.Reg ("D:\ajjl\dm.dll")
	
	// 这里判断是否注册成功
	Set dm = createobject("dm.dmsoft")
	
	ver = dm.Ver()
	TracePrint ver
	If ver <> need_ver Then 
		// 先释放先前创建的dm
		isSignUp = 0
		set dm = nothing
		// 再尝试用regsvr32 来注册.这里必须使用绝对路径。以免有别人把dm.dll释放在系统目录.造
		Set ws = createobject("Wscript.Shell")
		ws.run "regsvr32 " & myPath & "\dm.dll /s"
		set ws=nothing
		Delay 1500
		// 再判断插件是否注册成功
		Set dm = createobject("dm.dmsoft")
		ver=dm.Ver()
		If ver <> need_ver Then 
		// 这时，已经确认插件注册失败了。弹出一些调试信息，以供分析.
//		TracePrint "插件版本错误,当前使用的版本是:"
		TracePrint ver
//		TracePrint"请关闭程序,重新打开本程序再尝试”
		isSignUp = 0
		EndScript
		Else 
		TracePrint "第二次注册成功"
		isSignUp = 1
		End If
	Else 
		TracePrint "第一次就注册成功"
		isSignUp = 1
	End If
End Sub

Sub 判断三国志是否已打开
		//前台模式
hwnd = dm.FindWindow("", "三国志·战略版")

// display: 前台 鼠标:前台键盘:前台 模式0
//dm_ret = dm.BindWindow(hwnd,"normal","normal","normal",0)
//
// display: gdi 鼠标:前台 键盘:前台 模式1
//dm_ret = dm.BindWindow(hwnd,"gdi","normal","normal",1)
//
// display: dx 鼠标:前台 键盘:前台 模式0
//dm_ret = dm.BindWindow(hwnd,"dx","normal","normal",0)
//
// display: dx 鼠标:windows后台 键盘:windows后台 模式1
//dm_ret = dm.BindWindow(hwnd,"dx","windows","windows",1)
//
// display: dx 鼠标:dx 后台 键盘: dx后台 模式1
//dm_ret = dm.BindWindow(hwnd,"dx","dx","dx",1) 
//
// display: dx 鼠标:windows3后台 键盘:windows后台 模式1
//dm_ret = dm.BindWindow(hwnd,"dx","windows3","windows",1)
	TracePrint hwnd
	If hwnd <= 0 Then 
		MessageBox "没有找到游戏窗口，请确认游戏窗口已经打开"
	Else 
//	dm_ret = dm.SetWindowText(hwnd, "三战01")
	//绑定游戏界面窗口
		dm_ret =dm.BindWindow(hwnd,"normal","normal","normal",0)
		TracePrint "三国志战略版 电脑版已打开"
		isFindWindow = 1
	End If
	
End Sub

Sub 配置游戏窗口

	dm_ret = dm.SetWindowSize(hwnd,1200,800)
	dm_ret = dm.GetWindowRect(hwnd, x1, y1, x2, y2)
	TracePrint "x1 ==" & x1
	TracePrint "y1 ==" & y1
	TracePrint "x2 ==" & x2
	TracePrint "y2 ==" & y2
	gScreenW = x2-x1
	gScreenH = y2-y1
	TracePrint "gScreenW ==" & gScreenW
	TracePrint "gScreenH ==" & gScreenH
	
	dm.MoveWindow hwnd,-10,-30
End Sub


Sub 注册佐晓鹭

	TracePrint "开始注册佐晓鹭"
	//佐晓鹭完全免费版 不用注册了
//	text = Plugin.ZXLOCR.reg("TEST")
	
//	TracePrint "注册佐晓鹭: "&text
	
	
	TracePrint Plugin.ZXLOCR.Ver
	
//	最新版下载地址
//	TracePrint Plugin.ZXLOCR.GXVer
	
	
//	本地服务器查多行文字
//	text =  Plugin.ZXLOCR.TTOCR(4,77,1158,673,0)
//	TracePrint text
	
//	本地查单行
	
//	TEXT = Plugin.ZXLOCR.LDOCR("F:\OCR插件永久免费版\OCRdat.dll", 6)
//	
//	TracePrint text
//	
//	txt = Plugin.ZXLOCR.MYOCR(400,25,500,54, 0)
//	TracePrint txt
	
	//网络调用ocr
//	txt = Plugin.ZXLOCR.QSOCR(400,25,500,54, 0)
//	TracePrint txt
//	

End Sub

Sub 清理缓存文件
	IsFile = Plugin.File.IsFileExist(缓存土地敌人信息)
	If IsFile Then 
		Call Plugin.File.DeleteFile(缓存土地敌人信息)
	End If
	
	IsFile = Plugin.File.IsFileExist(缓存土地守卫信息)
	If IsFile Then 
		Call Plugin.File.DeleteFile(缓存土地守卫信息)
	End If
	
	
End Sub


Function 读取守卫信息(Command,Val)
	//下面这句是读取一个配置文件参数(小节名："Command" 键值名："Val")得到内容(Text )
	Text = 读取(Command, Val, 缓存土地守卫信息)
	TracePrint "读取土地信息键值为：" & Text
	读取守卫信息 = Text
End Function

Function 写入守卫信息(Command,Val,内容)
	//下面这句是保存一个配置文件参数(小节名："Command" 键值名："Val" 写入内容："内容")
	Call 写入(Command, Val, 内容, 缓存土地守卫信息)
	TracePrint "保存一个配置文件键值"
	
End Function



Function 读取土地归属信息(Command,Val)
	//下面这句是读取一个配置文件参数(小节名："Command" 键值名："Val")得到内容(Text )
	Text = 读取(Command, Val, 土地归属)
	TracePrint "读取土地信息键值为：" & Text
	读取敌人信息 = Text
End Function

Function 写入土地归属信息(Command,Val,内容)
	//下面这句是保存一个配置文件参数(小节名："Command" 键值名："Val" 写入内容："内容")
	Call 写入(Command, Val, 内容, 土地归属)
	TracePrint "保存一个配置文件键值"
	
End Function



Function 读取土地信息(Command,Val)
	//下面这句是读取一个配置文件参数(小节名："Command" 键值名："Val")得到内容(Text )
	Text = 读取(Command, Val, 土地文件)
	TracePrint "读取土地信息键值为：" & Text
	读取土地信息 = Text
End Function

Function 写入土地信息(Command,Val,内容)
	//下面这句是保存一个配置文件参数(小节名："Command" 键值名："Val" 写入内容："内容")
	Call 写入(Command, Val, 内容, 土地文件)
	TracePrint "保存一个配置文件键值"
	
End Function


Function 读取(Command, Val, path)
	//下面这句是读取一个配置文件参数(小节名："Command" 键值名："Val")得到内容(Text )
	Text = Plugin.File.ReadINI(Command, Val, path)
	读取 = Text
End Function

Function 写入(Command, Val, 内容, path)
	//下面这句是保存一个配置文件参数(小节名："Command" 键值名："Val" 写入内容："内容")
	Call Plugin.File.WriteINI(Command, Val, 内容, path)
End Function

//=====================================================================================================
////、、、、、、、、、、、、、、、、、、、、、、、、以下都是工具函数、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
///////包括 SZFindPic

/**
*拼接字符串名字
*/
 Function mapNames(names, headStr, tailStr, spStr)
 	strAllName = ""
	
	For Each name In names
		If strAllName = "" Then 
		 		strAllName = headStr & "\" & name & tailStr
			Else 
		 		strAllName = "||" & headStr & "\" & name & tailStr
		End If
       	
    Next
    
    mapNames = strAllName
    
 End Function
 
  /**
*工具函数 参数 和 返回值 说明
*/
 Function canFind(参数1, 参数2, 参数3, 参数4,资源名)
 	ret = SZFindPic(参数1, 参数2, 参数3, 参数4, 资源名)
 	If ret(1) > 0 and ret(2) > 0 Then 
 			TracePrint "确认能找到"&资源名
 			canFind = True
 		Else 
 			canFind =False
 	End If
    	
 End Function
 
 
 
  /**
*工具函数 参数 和 返回值 说明
*/
 Function SZFindPic(参数1,参数2,参数3,参数4, 资源名)
// 	TracePrint "资源名  " & 资源名
// 	TracePrint "路径  "&myPath&"\"&资源名&".bmp"
//	TracePrint "范围  ："&参数1 & " , "&参数2& " , "&参数3& " , "& 参数4
 	Dim ret(2)
 	dm_ret = dm.FindPic(参数1,参数2,参数3,参数4,myPath&"\"&资源名&".bmp","000000",0.8,0,intX,intY)
	ret(0) = dm_ret
	ret(1) = intX
	ret(2) = intY
    SZFindPic = ret
 End Function
 
 
 /**
*工具函数 参数 和 返回值 说明
*/
 Function 工具函数(参数1, 参数2, 参数3, 参数4)
 	
    
 End Function
 


Function 移动到(定位)
	Delay 1500
	dm_ret = dm.FindPic(0,0,1200,800,"D:\ajjl\"& 定位 &".bmp","000000",0.9,0,intX,intY)
	If intX >= 0 and intY >= 0 Then
    	TracePrint "找到"&定位
    	dm.moveTo intX, intY
    	Delay 1000
    	
    	
    Else 
    	TracePrint "没有找到"&定位
    	
	End If
	Delay 50
End Function


Sub 去点击(位置)
	Delay 1500
	dm_ret = dm.FindPic(0,0,1178,758,"D:\ajjl\"& 位置 &".bmp","000000",0.9,0,intX,intY)
	If intX >= 0 and intY >= 0 Then
    	TracePrint "找到"&位置
    	dm.moveTo intX, intY
    	Delay 1000
    	
		dm.LeftClick

    	
    Else 
    	TracePrint "没有找到"&位置
    	
	End If
	Delay 50
End Sub

Sub 偏右下角点击(位置)
	Delay 1500
	dm_ret = dm.FindPic(0,0,1174,757,"D:\ajjl\"& 位置 &".bmp","000000",0.9,0,intX,intY)
	If intX >= 0 and intY >= 0 Then
    	TracePrint "找到"&位置
    	dm.moveTo intX+20, intY+20
    	Delay 1000
    	dm.leftclick 
    	
    Else 
    	TracePrint "没有找到"&位置
    	
	End If
	Delay 50
End Sub

Sub 点颜色(颜色值)
	dm_ret = dm.FindColor(0,0,1200,800,颜色值,1.0,0,intX,intY)
	If intX >= 0 and intY >= 0 Then
    	TracePrint "找到颜色"&颜色值
    	dm.moveTo intX, intY
    	Delay 1000
    	dm.leftclick 
	End If
End Sub

Sub 点击(位置)
	移动到 位置
	dm.leftclick 	
End Sub

Sub 鼠标点击(坐标X, 坐标Y)
	Delay 50
	dm.moveto 坐标X,坐标Y
	dm.leftclick 
	Delay 50
End Sub

Sub 找到并点击(资源名)
	If canFind(0, 70, 1200, 800, 资源名) = True Then 
		去点击 资源名
	End If
End Sub




//=====================================================================================================
////、、、、、、、、、、、、、、、、、、、、、、、、以下都是主函数、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、

Sub main

///注册准备
	注册大漠 
	获取系统配置 
	
	判断三国志是否已打开 
	配置游戏窗口 
	
	注册佐晓鹭 
	
	判断当前界面
	
	判断当前任务 
	
	
	清理缓存文件
	
	
End Sub
	