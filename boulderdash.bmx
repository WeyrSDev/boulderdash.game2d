

' Simple Boulderdash game
' no sound, no cave transitions

'inspired by:
'http://codeincomplete.com/posts/2011/10/25/javascript_boulderdash/


SuperStrict
Import wdw.game2d

Include "moving.bmx"
Include "animation.bmx"
Include "tileentity.bmx"
Include "map2d.bmx"
Include "playstate.bmx"
Include "cavecam.bmx"


Const LAYER_MAP:Int = 0
Const LAYER_CAMERA:Int = 1

Const STATE_PLAY:Int = 0 

global g_cam:TCaveCam
global g_frame:Int

Global g_game:TBoulderdash = New TBoulderdash
g_game.Start()


Type TBoulderdash Extends TGame
	
	Method New()
		SetGameTitle("Boulderdash")
	End Method


	'put your setup code here
	Method StartUp()

		SeedRnd( MilliSecs() )
		HideMouse()
		
		InitializeGraphics( 800, 600, 800, 600 )
		'InitializeGraphics( 800, 600, 1024,768)'800, 600 )
		
		AddResourceGroup( "images" )
		AddResourceImage( LoadAnimImage( "media/sprites.png", 32, 32, 0, 96) , "tiles", "images" )

		AddEntityGroup( "tiles" )
		AddEntityGroup( "camera" )

		AddKeyControl( "UP", KEY_UP )
		AddKeyControl( "DOWN", KEY_DOWN )
		AddKeyControl( "LEFT", KEY_LEFT )
		AddKeyControl( "RIGHT", KEY_RIGHT )
		AddKeyControl( "GRAB", KEY_A )

		SetGameFont( LoadImageFont("media/arcade.ttf", 24 ) )

		'add game state. first state added is start state
		AddGameState( New TPlayState, STATE_PLAY )
	End Method
	
	
	'put your cleanup code here
	Method CleanUp()
		ClearEntities()
		_currentGameState = Null
	End Method


	Method OnRestartGame()
		_currentGameState.Enter()
	End Method

EndType


Function RandomChoice:Int( choices:Int[] )
	Return choices[ Rand( 0, choices.Length-1 ) ]
End Function
