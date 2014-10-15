

'map2d tile entity
'each map location holds one of these entities

Type TTileEntity Extends TImageEntity

	'tile definitions
	Const SPACE:Int = 0, DIRT:Int = 1, WALL:Int = 2
	Const BOULDER:Int = 3, FALLINGBOULDER:Int = 4, DIAMOND:Int = 6, FALLINGDIAMOND:Int = 7
	Const AMOEBA:Int = 8, STEELWALL:Int = 9, MAGICWALL:Int = 10, FLASH:Int = 11
	Const EXPLODETOSPACE0:Int = 12, EXPLODETOSPACE1:Int = 13
	Const EXPLODETOSPACE2:Int = 14, EXPLODETOSPACE3:Int = 15
	Const EXPLODETOSPACE4:Int = 16
	Const EXPLODETODIAMOND0:Int = 17, EXPLODETODIAMOND1:Int = 18
	Const EXPLODETODIAMOND2:Int = 19, EXPLODETODIAMOND3:Int = 20
	Const EXPLODETODIAMOND4:Int = 21
	Const PLAYER:Int = 22
	Const PLAYERBLINK:Int = 23
	Const PLAYERTAP:Int = 24
	Const PLAYERTAPBLINK:Int = 25
	Const PLAYERLEFT:Int = 26
	Const PLAYERRIGHT:Int = 27
	Const BUTTERFLYLEFT:Int = 28, BUTTERFLYRIGHT:Int = 29
	Const BUTTERFLYUP:Int = 30, BUTTERFLYDOWN:Int = 31
	Const FIREFLYLEFT:Int = 32, FIREFLYRIGHT:Int = 33
	Const FIREFLYUP:Int = 34, FIREFLYDOWN:Int = 35
	Const PREPLAYER0:Int = 36
	Const PREPLAYER1:Int = 37
	Const PREPLAYER2:Int = 38
	Const PREPLAYER3:Int = 39
	Const PREOUTBOX:int = 40
	Const OUTBOX:Int = 41
	Const MAGICWALLACTIVE:Int = 42
	const GROWINGWALL:Int = 43


	'position of this tileentity in the map array
	'!!not in the world!!
	'world position is set while loading and setting up the map.
	'not sure if this is needed
	Field x:Int
	Field y:int

	'last updated in this frame #
	Field lastUpdateFrame:Int

	'tile properties
	Field id:Int
    Field explodeable:Int
	Field rounded:Int
	Field consumable:Int

	'animation used by this tile. TAnim.anims[ x ]
	Field animation:Int


	Method New()
		Self.SetImage( GetResourceImage( "tiles", "images" ) )		
	EndMethod


	Function Create:TTileEntity( xpos:int, ypos:Int, tileType:Int )
		local t:TTileEntity = new TTileEntity
		t.x = xpos
		t.y = ypos
		t.SetType( tileType )

		'set first frame
		'because animations with 1 frame never get set once the game is running.
		t.SetFrame( TAnim.anims[ t.animation ].frame )

		return t
	EndFunction


	'resets tile to passed type
	'this means that tiles can change shape. the tile itself is not refreshed
	'by another tile.
	Method SetType( tileType:Int )
		id = tileType
		
		'set tile animation and properties
		'tiles can re-use different animations
		Select tileType
			Case Self.SPACE
				animation = TAnim.SPACE
				consumable = True
				explodeable = False
			Case Self.FLASH
				animation = TAnim.FLASH
				consumable = True
				explodeable = False
			Case Self.DIRT
				animation = TAnim.DIRT
				rounded = False
				explodeable = False
				consumable = True
			Case Self.WALL
				animation = TAnim.WALL
				rounded = True
				explodeable = False
				consumable = True
			Case Self.MAGICWALL
				animation = TAnim.MAGICWALL
				rounded = False
				explodeable = False
				consumable = True
			Case Self.MAGICWALLACTIVE
				animation = TAnim.MAGICWALLACTIVE
				rounded = False
				explodeable = False
				consumable = True
			Case Self.BOULDER
				animation = TAnim.BOULDER
				rounded = True
				explodeable = False
				consumable = True
			Case Self.FALLINGBOULDER
				animation = TAnim.BOULDER
				rounded = False
				explodeable = False
				consumable = True
			Case Self.DIAMOND
				animation = TAnim.DIAMOND
				rounded = True
				explodeable = False
				consumable = True
			Case Self.FALLINGDIAMOND
				animation = TAnim.DIAMOND
				rounded = False
				explodeable = False
				consumable = True				
			Case Self.STEELWALL
				animation = TAnim.STEELWALL
				explodeable = False
				rounded = False
				consumable = False
			Case Self.EXPLODETODIAMOND0
				animation = TAnim.EXPLODETODIAMOND0
				explodeable = False
				consumable = False
				rounded = False
			Case Self.EXPLODETODIAMOND1
				animation = TAnim.EXPLODETODIAMOND1
				explodeable = False
				consumable = False
				rounded = False
			Case Self.EXPLODETODIAMOND2
				animation = TAnim.EXPLODETODIAMOND2
				explodeable = False
				consumable = False
				rounded = False
			Case Self.EXPLODETODIAMOND3
				animation = TAnim.EXPLODETODIAMOND3
				explodeable = False
				consumable = False
				rounded = False
			Case Self.EXPLODETODIAMOND4
				animation = TAnim.EXPLODETODIAMOND4
				explodeable = False
				consumable = False
				rounded = False
			Case Self.EXPLODETOSPACE0
				animation = TAnim.EXPLODETOSPACE0
				explodeable = False
				consumable = False
				rounded = False
			Case Self.EXPLODETOSPACE1
				animation = TAnim.EXPLODETOSPACE1
				explodeable = False
				consumable = False
				rounded = False
			Case Self.EXPLODETOSPACE2
				animation = TAnim.EXPLODETOSPACE2
				explodeable = False
				consumable = False
				rounded = False
			Case Self.EXPLODETOSPACE3
				animation = TAnim.EXPLODETOSPACE3
				explodeable = False
				consumable = False
				rounded = False
			Case Self.EXPLODETOSPACE4
				animation = TAnim.EXPLODETOSPACE4
				explodeable = False
				consumable = False
				rounded = False
			Case Self.PLAYER
				animation = TAnim.PLAYER_FRONT
				rounded = False
				explodeable = True
				consumable = True
			Case Self.PLAYERBLINK
				animation = TAnim.PLAYER_BLINK
				rounded = False
				explodeable = True
				consumable = True
			Case Self.PLAYERTAP
				animation = TAnim.PLAYER_TAP
				rounded = False
				explodeable = True
				consumable = True
			Case Self.PLAYERTAPBLINK
				animation = TAnim.PLAYER_TAPBLINK
				rounded = False
				explodeable = True
				consumable = True
			Case Self.PLAYERLEFT
				animation = TAnim.PLAYER_WALK_LEFT
				rounded = False
				explodeable = True
				consumable = True
			Case Self.PLAYERRIGHT
				animation = TAnim.PLAYER_WALK_RIGHT
				rounded = False
				explodeable = True
				consumable = True
			Case Self.FIREFLYLEFT, Self.FIREFLYRIGHT, Self.FIREFLYUP, Self.FIREFLYDOWN
				animation = TAnim.FIREFLY
				rounded = False
				explodeable = True
				consumable = True
			Case Self.BUTTERFLYLEFT, Self.BUTTERFLYRIGHT, Self.BUTTERFLYUP, Self.BUTTERFLYDOWN
				animation = TAnim.BUTTERFLY
				rounded = False
				explodeable = True
				consumable = True
			Case Self.AMOEBA
				animation = TAnim.AMOEBA
				rounded = False
				explodeable = False
				consumable = True
			Case Self.PREPLAYER0
				animation = TAnim.PREPLAYER0
				rounded = False
				explodeable = False
				consumable = False
			Case Self.PREPLAYER1
				animation = TAnim.PREPLAYER1
				rounded = False
				explodeable = False
				consumable = False				
			Case Self.PREPLAYER2
				animation = TAnim.PREPLAYER2
				rounded = False
				explodeable = False
				consumable = False				
			Case Self.PREPLAYER3
				animation = TAnim.PREPLAYER3
				rounded = False
				explodeable = False
				consumable = False
			Case Self.PREOUTBOX
				animation = TAnim.PREOUTBOX
				rounded = False
				explodeable = False
				consumable = False
			Case Self.OUTBOX
				animation = TAnim.OUTBOX
				rounded = False
				explodeable = False
				consumable = False
			case Self.GROWINGWALL
				animation = TAnim.GROWINGWALL
				rounded = false
				explodeable = false
				consumable = true
			Default
				RuntimeError( "cannot find tiletype: " + tileType )				
		End Select

		Self.SetFrame( TAnim.anims[ animation ].frame )
	End Method
		
	
	
	Method UpdateEntity()

		'determine render frame to
		'get the animation for this tile
		'the animation defines the frame and animation speed (if any)
		'Self.renderFrame is updated by the game.
		Local anim:TAnim = TAnim.anims[ animation ]
		local frame:Int = anim.frameAmount
		If frame > 0
			frame = (g_frame * (1.0 / anim.fps)) Mod anim.frameAmount
		End If
		Self.SetFrame( anim.frame + frame )
	End Method

EndType

