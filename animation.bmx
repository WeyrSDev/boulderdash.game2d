

'animations shown on tiles.
Type TAnim
	
	'animation counters
	Field frame:Int
	Field frameAmount:Int
	Field fps:Int

	'animation IDs
	Const SPACE:Int = 0
	Const DIRT:Int = 1
	Const WALL:Int = 2
	Const BOULDER:Int = 3
	Const PLAYER_FRONT:Int = 4
	Const PLAYER_TAP:Int = 5
	Const PLAYER_TAPBLINK:Int = 6
	Const PLAYER_BLINK:Int = 7
	Const PLAYER_WALK_LEFT:Int = 8
	Const PLAYER_WALK_RIGHT:Int = 9
	Const DIAMOND:Int = 10
	Const AMOEBA:Int = 11
	Const FIREFLY:Int = 12
	Const BUTTERFLY:Int = 13
	Const STEELWALL:Int = 14
	Const EXPLODETOSPACE0:Int = 15
	Const EXPLODETOSPACE1:Int = 16
	Const EXPLODETOSPACE2:Int = 17
	Const EXPLODETOSPACE3:Int = 18
	Const EXPLODETOSPACE4:Int = 19
	Const EXPLODETODIAMOND0:Int = 20
	Const EXPLODETODIAMOND1:Int = 21
	Const EXPLODETODIAMOND2:Int = 22
	Const EXPLODETODIAMOND3:Int = 23
	Const EXPLODETODIAMOND4:Int = 24
	Const MAGICWALL:Int = 25
	Const PREPLAYER0:Int = 26
	Const PREPLAYER1:Int = 27
	Const PREPLAYER2:Int = 28
	Const PREPLAYER3:Int = 29
	Const PREOUTBOX:Int = 30
	Const OUTBOX:Int = 31
	Const FLASH:Int = 32
	Const MAGICWALLACTIVE:Int = 33
	Const GROWINGWALL:Int = 34
	
	'animation collection
	'uses the id's seen above.
	'these are referenced by the tileentities
	Global anims:TAnim[] = [ ..
		TAnim.Create(TAnim.FRAME_SPACE ), ..
		TAnim.Create(TAnim.FRAME_DIRT ), ..
		TAnim.Create(TAnim.FRAME_WALL ), ..
		TAnim.Create(TAnim.FRAME_BOULDER ), ..
		TAnim.Create(TAnim.FRAME_FRONT ), ..
		TAnim.Create(TAnim.FRAME_TAP, 8, 3), ..
		TAnim.Create(TAnim.FRAME_TAP_BLINK, 8, 3), ..
		TAnim.Create(TAnim.FRAME_BLINK, 8, 3), ..
		TAnim.Create(TAnim.FRAME_WALK_LEFT, 8, 3), ..
		TAnim.Create(TAnim.FRAME_WALK_RIGHT, 8, 3), ..
		TAnim.Create(TAnim.FRAME_DIAMOND, 8, 3), ..
		TAnim.Create(TAnim.FRAME_AMOEBA, 8, 3), ..
		TAnim.Create(TAnim.FRAME_FIREFLY, 8, 3), ..
		TAnim.Create(TAnim.FRAME_BUTTERFLY, 8, 3), ..
		TAnim.Create(TAnim.FRAME_STEELWALL ), ..
		TAnim.Create(TAnim.FRAME_EXPLODETOSPACE0 ), ..
		TAnim.Create(TAnim.FRAME_EXPLODETOSPACE1 ), ..
		TAnim.Create(TAnim.FRAME_EXPLODETOSPACE2 ), ..
		TAnim.Create(TAnim.FRAME_EXPLODETOSPACE3 ), ..
		TAnim.Create(TAnim.FRAME_EXPLODETOSPACE4 ), ..
		TAnim.Create(TAnim.FRAME_EXPLODETODIAMOND0 ), ..
		TAnim.Create(TAnim.FRAME_EXPLODETODIAMOND1 ), ..
		TAnim.Create(TAnim.FRAME_EXPLODETODIAMOND2 ), ..
		TAnim.Create(TAnim.FRAME_EXPLODETODIAMOND3 ), ..
		TAnim.Create(TAnim.FRAME_EXPLODETODIAMOND4) ,	..	
		TAnim.Create(TAnim.FRAME_WALL ), ..
		TAnim.Create(TAnim.FRAME_PREPLAYER0, 2, 12), ..
		TAnim.Create(TAnim.FRAME_PREPLAYER1 ), ..
		TAnim.Create(TAnim.FRAME_PREPLAYER2 ), ..
		TAnim.Create(TAnim.FRAME_PREPLAYER3 ), ..
		TAnim.Create(TAnim.FRAME_OUTBOX ), ..
		TAnim.Create(TAnim.FRAME_OUTBOX, 2, 12), ..
		TAnim.Create(TAnim.FRAME_FLASH ), ..
		TAnim.Create(TAnim.FRAME_MAGICWALLACTIVE, 4, 3), ..
		TAnim.Create(TAnim.FRAME_GROWINGWALL ) ]


	'animation frame definitions.
	'these are the frames in the tile image
	'and the first frame in an animation
	'frames can be reused in different definitions
	Const FRAME_FRONT:Int = 0
	Const FRAME_PREPLAYER1:Int = 1
	Const FRAME_PREPLAYER2:Int = 2
	Const FRAME_PREPLAYER3:Int = 3
	Const FRAME_FLASH:Int = 4
	Const FRAME_SPACE:Int = 5	
	Const FRAME_BLINK:Int = 8
	Const FRAME_TAP:Int = 16
	Const FRAME_TAP_BLINK:Int = 24
	Const FRAME_WALK_LEFT:Int = 32
	Const FRAME_WALK_RIGHT:Int = 40
	Const FRAME_PREPLAYER0:Int = 49
	Const FRAME_STEELWALL:Int = 49
	Const FRAME_OUTBOX:Int = 49
	Const FRAME_WALL:Int = 51
	Const FRAME_MAGICWALL:Int = 51
	Const FRAME_MAGICWALLACTIVE:Int = 52
	Const FRAME_BOULDER:Int = 56
	Const FRAME_DIRT:Int = 57
	Const FRAME_EXPLODETOSPACE0:Int = 59
	Const FRAME_EXPLODETOSPACE1:Int = 60
	Const FRAME_EXPLODETOSPACE2:Int = 61
	Const FRAME_EXPLODETOSPACE3:Int = 60
	Const FRAME_EXPLODETOSPACE4:Int = 59
	Const FRAME_EXPLODETODIAMOND0:Int = 59
	Const FRAME_EXPLODETODIAMOND1:Int = 60
	Const FRAME_EXPLODETODIAMOND2:Int = 61
	Const FRAME_EXPLODETODIAMOND3:Int = 60
	Const FRAME_EXPLODETODIAMOND4:Int = 59
	Const FRAME_AMOEBA:Int = 64
	Const FRAME_FIREFLY:Int = 72
	Const FRAME_DIAMOND:Int = 80
	Const FRAME_FALLINGDIAMOND:int = 80 
	Const FRAME_BUTTERFLY:Int = 88
	const FRAME_GROWINGWALL:Int = 51


	Function Create:TAnim( startFrame:Int, amount:Int=0, fps:Int=0 )
		local a:TAnim = new TAnim
		a.frame = startFrame
		a.frameAmount = amount
		a.fps = fps
		return a
	End function

End Type
