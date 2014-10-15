
'helper type with moving directions
'and tests/checks

Type TMoving

	'currently moving in this direction
	Global dir:Int = TDir.NONE
	Global lastXdir:Int = TDir.LEFT
	
	'key switches, bools

	Global up:Int
	Global down:Int
	Global left:Int
	Global right:Int
	Global grab:Int

	
	'returns current move direction
	Function Where:Int()
		If TMoving.up
			Return TDir.UP
		ElseIf TMoving.down
			Return TDir.DOWN
		ElseIf TMoving.left
			Return TDir.LEFT
		ElseIf TMoving.right
			Return TDir.RIGHT
		End If
		Return TDir.NONE
	End Function
	
	
	'start an up movement
	Function StartUp()
		TMoving.up = True
		TMoving.dir = TDir.UP
	End Function

	'start a down movement	
	Function StartDown()
		TMoving.down = True
		TMoving.dir = TDir.DOWN
	End Function
	
	Function StartLeft()
		TMoving.left = True
		TMoving.dir = TDir.LEFT
		TMoving.lastXdir = TDir.LEFT
	End Function

	Function StartRight()
		TMoving.right = True
		TMoving.dir = TDir.RIGHT
		TMoving.lastXdir = TDir.RIGHT
	End Function
	
	'start to grab
	Function StartGrab()
		TMoving.grab = True
	End Function
	
	
	
	Function StopUp()
		TMoving.up = False
		If TMoving.dir = TDir.UP
			TMoving.dir = TMoving.Where()
		EndIf
	End Function
	
	Function StopDown()
		TMoving.down = False
		If TMoving.dir = TDir.DOWN
			TMoving.dir = TMoving.Where()
		EndIf
	End Function
	
	Function StopLeft()
		TMoving.left = False
		If TMoving.dir = TDir.LEFT
			TMoving.dir = TMoving.Where()
		EndIf

	End Function

	Function StopRight()
		TMoving.right = False
		If TMoving.dir = TDir.RIGHT
			TMoving.dir = TMoving.Where()
		EndIf
	End Function
	
	Function StopGrab()
		TMoving.grab = False
	End Function
End Type


'directions and their corresponding x and y offsets in the map
Type TDir
	Const NONE:Int = 0, UP:Int = 1, UPRIGHT:Int = 2, RIGHT:Int = 3, DOWNRIGHT:Int = 4
	Const DOWN:Int = 5, DOWNLEFT:Int = 6, LEFT:Int = 7, UPLEFT:Int = 8
	
	Global DIRX:Int[] =[0,  0,  1, 1, 1, 0, -1, -1, -1]
	Global DIRY:Int[] =[0, -1, -1, 0, 1, 1,  1,  0, -1]
	
	Function RotateLeft:Int(dir:Int)
		dir:- 2
		If dir < 1 Then dir:+ 8
		Return dir
	End Function

	Function RotateRight:Int(dir:Int)
		dir:+ 2
		If dir > 8 Then dir:- 8
		Return dir
	End Function
		
	Function IsHorizontal:Int(dir:Int)
		Return dir = TDir.LEFT or dir = TDir.RIGHT
	End Function
	
End Type

