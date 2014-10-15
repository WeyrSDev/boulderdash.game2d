

Type TPlaystate Extends TState


	field updateCount:Int

	field index:Int
	field maps:TMap2d[]

	field map:TMap2d

	field won:Int

	'this is how fast the game updates.
	field fps:Int

	field playerBirthFrame:Int

	'player alive??
	field playerFound:Int	

	Field lives:Int
	Field time:Int
	Field score:Int
	Field flash:Int

	'idle anim settings
	Field idleDelay:Int
	Field idle:Int
	Field blink:Int
	Field tap:Int


	'types holding settings.
	Field amoeba:TAmoeba
	Field magic:TMagic
	Field diamonds:TDiamonds

	
	'starts a new game
	Method Enter()
		index = 0
		lives = 3
		fps = 8
		amoeba = New TAmoeba
		diamonds = New TDiamonds
		magic = New TMagic
		Self.LoadCaveData()

		'start the first map
		Self.Reset( index )

		g_cam = New TCaveCam'TCameraEntity
		g_cam.SetDelay(0.04)
		AddEntity( g_cam, LAYER_CAMERA, "camera" )

	End Method


	'creates the tmap2d types and stores the level data
	'does not yet create the map tiles
	Method LoadCaveData()
		Local filenames:String[] =["media/level1.txt", "media/level2.txt", "media/level3.txt"]
		maps = New TMap2d[filenames.Length]
		For Local index:Int = 0 Until filenames.Length
			maps[index] = TMap2d.Create(filenames[index], LAYER_MAP, "tiles" )
		Next
	End Method



	'starts a cave with passed index.
	Method Reset( caveIndex:Int )

		g_frame = 1

		flash = 0
		playerBirthFrame = 60*3
		idleDelay = 60*2
		won = false

		index = caveIndex
		map = maps[ index ]

		'create the map and sets its settings
		map.Reset()

		'pass map settings to this state
		'and settings types
		time = map.playTime

		amoeba.dead = false
		amoeba.maxsize = map.amoebamax
		amoeba.slow = map.amoebaslow

		diamonds.collected = 0
		diamonds.needed = map.diamondquota
		diamonds.value  = map.diamondscore
		diamonds.extravalue = map.diamondextrascore

		magic.active = false
		magic.millingtime = map.millingTime		
	EndMethod


	Method Update(tween:Double)
		g_frame:+ 1

		GetKeyInput()

		if g_frame mod fps = 0
			StartFrame()
			UpdateMap()
			EndFrame()
		endif

		if won
			RunOutTimer()
		Else
			AutoDeCreaseTimer()		
		endif
	
	End Method


	Method StartFrame()
		amoeba.size = 0
		amoeba.enclosed = True		
		If TMoving.dir = TDir.NONE
			idle = True
			If g_frame mod idleDelay = 0
				blink = False
				tap = False
				If Rand(4) = 1 Then blink = True
				If Rand(16) = 1 Then tap = True
			End If
		Else
			idle = False
		End If
	EndMethod


	Method EndFrame()
		If amoeba.dead = False
			If amoeba.enclosed
				amoeba.dead = TTileEntity.DIAMOND
			ElseIf amoeba.size > amoeba.maxsize
				amoeba.dead = TTileEntity.BOULDER
			ElseIf amoeba.slow > 0
				amoeba.slow:- 1
			End If
		EndIf

		If magic.active
			magic.millingTime:- 1
			If magic.millingTime = 0 Then magic.active = False
		End If
		
		If g_frame - playerFound > (60 * 4)
			'player not seen for 4 seconds. dead.
			LoseLevel()
		End If
		
	EndMethod
	

	Method UpdateAmoeba( this:TTileEntity )
		If amoeba.dead
			Set(this, amoeba.dead)
		Else
			amoeba.size :+ 1
			If IsEmpty(this, TDir.LEFT) Or IsEmpty(this, TDir.RIGHT) Or ..
				IsEmpty(this, TDir.UP) Or IsEmpty(this, TDir.DOWN) Or ..
				IsDirt(this, TDir.LEFT) Or IsDirt(this, TDir.RIGHT) Or ..
				IsDirt(this, TDir.UP) Or IsDirt(this, TDir.DOWN) Then
					amoeba.enclosed = False
			EndIf
			
			If g_frame > playerBirthFrame
				Local grow:Int = False
				If amoeba.slow = 0
					grow = Rand(1,128) < 3
				Else
					grow = Rand(1, 4) = 2
				EndIf
			
				If grow
					Local rnddir:Int = RandomChoice( [TDir.LEFT, TDir.RIGHT, TDir.UP, TDir.DOWN] )
					If IsDirt(this, rnddir) or IsEmpty(this, rnddir)
						SetWithDir(this, TTileEntity.AMOEBA, rnddir)
					End If
				EndIf
			EndIf
		EndIf
	End Method


	Method UpdateFirefly( this:TTileEntity, dir:Int )
		Local newDir:Int = TDir.RotateLeft(dir)
		If IsPlayer(this, TDir.UP) or IsPlayer(this, TDir.DOWN) or ..
			IsPlayer(this, TDir.LEFT) or IsPlayer(this, TDir.RIGHT)
			Explode(this, TDir.NONE)
		ElseIf IsAmoeba(this, TDir.UP) or IsAmoeba(this, TDir.DOWN) or ..
			IsAmoeba(this, TDir.LEFT) or IsAmoeba(this, TDir.RIGHT)
			Explode(this, TDir.NONE)
		ElseIf IsEmpty(this, newDir)
			Select newDir
				Case TDir.LEFT
					MoveWithTileType(this, newDir, TTileEntity.FIREFLYLEFT)
				Case TDir.RIGHT
					MoveWithTileType(this, newDir, TTileEntity.FIREFLYRIGHT)
				Case TDir.UP
					MoveWithTileType(this, newDir, TTileEntity.FIREFLYUP)
				Case TDir.DOWN
					MoveWithTileType(this, newDir, TTileEntity.FIREFLYDOWN)
			End Select
		ElseIf IsEmpty(this, dir)
			MoveWithTileType(this, dir, this.id)
		Else
			newDir = TDir.RotateRight(dir)
			Select newDir
				Case TDir.LEFT
					Set(this, TTileEntity.FIREFLYLEFT)
				Case TDir.RIGHT
					Set(this, TTileEntity.FIREFLYRIGHT)
				Case TDir.UP
					Set(this, TTileEntity.FIREFLYUP)
				Case TDir.DOWN
					Set(this, TTileEntity.FIREFLYDOWN)
			End Select
		End If
	End Method


	Method UpdateButterfly( this:TTileEntity, dir:Int )
		Local newDir:Int = TDir.RotateRight(dir)
		If IsPlayer(this, TDir.UP) or IsPlayer(this, TDir.DOWN) or ..
			IsPlayer(this, TDir.LEFT) or IsPlayer(this, TDir.RIGHT)
			Explode(this, TDir.NONE)
		ElseIf IsAmoeba(this, TDir.UP) or IsAmoeba(this, TDir.DOWN) or ..
			IsAmoeba(this, TDir.LEFT) or IsAmoeba(this, TDir.RIGHT)
			Explode(this, TDir.NONE)
		ElseIf IsEmpty(this, newDir)
			Select newDir
				Case TDir.LEFT
					MoveWithTileType(this, newDir, TTileEntity.BUTTERFLYLEFT)
				Case TDir.RIGHT
					MoveWithTileType(this, newDir, TTileEntity.BUTTERFLYRIGHT)
				Case TDir.UP
					MoveWithTileType(this, newDir, TTileEntity.BUTTERFLYUP)
				Case TDir.DOWN
					MoveWithTileType(this, newDir, TTileEntity.BUTTERFLYDOWN)
			End Select
		ElseIf IsEmpty(this, dir)
			MoveWithTileType(this, dir, this.id)
		Else
			newDir = TDir.RotateLeft(dir)
			Select newDir
				Case TDir.LEFT
					Set(this, TTileEntity.BUTTERFLYLEFT)
				Case TDir.RIGHT
					Set(this, TTileEntity.BUTTERFLYRIGHT)
				Case TDir.UP
					Set(this, TTileEntity.BUTTERFLYUP)
				Case TDir.DOWN
					Set(this, TTileEntity.BUTTERFLYDOWN)
			End Select
		EndIf
	End Method


	Method UpdateRock( this:TTileEntity )
		If IsEmpty(this, TDir.DOWN)
			Set(this, TTileEntity.FALLINGBOULDER)
		ElseIf IsRounded(this, TDir.DOWN) And IsEmpty(this, TDir.LEFT) And IsEmpty(this, TDir.DOWNLEFT)
			MoveWithTileType(this, TDir.LEFT, TTileEntity.FALLINGBOULDER)
		ElseIf IsRounded(this, TDir.DOWN) And IsEmpty(this, TDir.RIGHT) And IsEmpty(this, TDir.DOWNRIGHT)
			MoveWithTileType(this, TDir.RIGHT, TTileEntity.FALLINGBOULDER)
		EndIf
	End Method



	Method UpdateFallingRock(this:TTileEntity)
		If IsEmpty(this, TDir.DOWN)
			Move(this, TDir.DOWN)
		ElseIf IsMagic(this, TDir.DOWN)
			DoMagic(this, TDir.DOWN)
		ElseIf IsExplodable(this, TDir.DOWN)
			Explode(this, TDir.DOWN)
		ElseIf IsRounded(this, TDir.DOWN) And IsEmpty(this, TDir.LEFT) And IsEmpty(this, TDir.DOWNLEFT)
			Move(this, TDir.LEFT)
		ElseIf IsRounded(this, TDir.DOWN) And IsEmpty(this, TDir.RIGHT) And IsEmpty(this, TDir.DOWNRIGHT)
			Move(this, TDir.RIGHT)
		Else
			Set(this, TTileEntity.BOULDER)
		End If
	End Method


	Method UpdateDiamond( this:TTileEntity )
		If IsEmpty(this, TDir.DOWN)
			Set(this, TTileEntity.FALLINGDIAMOND)
		ElseIf IsRounded(this, TDir.DOWN) And IsEmpty(this, TDir.LEFT) And IsEmpty(this, TDir.DOWNLEFT)
			MoveWithTileType(this, TDir.LEFT, TTileEntity.FALLINGDIAMOND)
		ElseIf IsRounded(this, TDir.DOWN) And IsEmpty(this, TDir.RIGHT) And IsEmpty(this, TDir.DOWNRIGHT)
			MoveWithTileType(this, TDir.RIGHT, TTileEntity.FALLINGDIAMOND)
		EndIf
	End Method
	

	Method UpdateFallingDiamond(this:TTileEntity)
		If IsEmpty(this, TDir.DOWN)
			Move(this, TDir.DOWN)
		ElseIf IsMagic(this, TDir.DOWN)
			DoMagic(this, TDir.DOWN)
		ElseIf IsExplodable(this, TDir.DOWN)
			Explode(this, TDir.DOWN)
		ElseIf IsRounded(this, TDir.DOWN) And IsEmpty(this, TDir.LEFT) And IsEmpty(this, TDir.DOWNLEFT)
			Move(this, TDir.LEFT)
		ElseIf IsRounded(this, TDir.DOWN) And IsEmpty(this, TDir.RIGHT) And IsEmpty(this, TDir.DOWNRIGHT)
			Move(this, TDir.RIGHT)
		Else
			Set(this, TTileEntity.DIAMOND)
		End If
	End Method


	Method UpdateGrowingWall( this:TTileEntity )
		If IsEmpty( this, TDIR.LEFT )
			SetWithDir( this, TTileEntity.GROWINGWALL, TDir.LEFT )
		endif
		If IsEmpty( this, TDIR.RIGHT )
			SetWithDir( this, TTileEntity.GROWINGWALL, TDir.RIGHT )
		endif		
	EndMethod
	


	Method UpdatePlayer(this:TTileEntity, dir:Int)

		'player is alive in this frame!
		playerFound = g_frame

		'set animation according to movement	
		If dir = TDir.LEFT
			Set(this, TTileEntity.PLAYERLEFT)
		ElseIf dir = TDir.RIGHT
			Set(this, TTileEntity.PLAYERRIGHT)
		ElseIf dir = TDir.UP Or dir = TDir.DOWN
			If TMoving.lastXdir = TDir.LEFT
				Set(this, TTileEntity.PLAYERLEFT)
			Else
				Set(this, TTileEntity.PLAYERRIGHT)
				this.animation = TAnim.PLAYER_WALK_RIGHT
			End If
		ElseIf idle = True
			If blink = False And tap = False
				Set(this, TTileEntity.PLAYER)
			ElseIf blink = True And tap = True
				Set(this, TTileEntity.PLAYERTAPBLINK)
			ElseIf blink = True
				Set(this, TTileEntity.PLAYERBLINK)
			ElseIf tap = True
				Set(this, TTileEntity.PLAYERTAP)
			End If
		EndIf
				
				
		If won
			'niks. player is in outbox
		ElseIf time = 0
			'tijd op. dood.
			Explode(this, TDir.NONE)
		ElseIf TMoving.grab
			If IsDirt(this, dir)
				SetWithDir(this, TTileEntity.SPACE, dir)
			ElseIf IsBoulder(this, dir)
				Push(this, dir)
			ElseIf IsDiamond(this, dir)
				CollectDiamond()
				SetWithDir(this, TTileEntity.SPACE, dir)
			EndIf
		ElseIf IsEmpty(this, dir) or IsDirt(this, dir)
			Move(this, dir)
		ElseIf IsBoulder(this, dir)
			Push(this, dir)
		ElseIf IsDiamond(this, dir)
			CollectDiamond()
			Move(this, dir)
		ElseIf IsOutBox(this, dir)
			Move(this, dir)
			WinLevel()
		Else
			If IsBoulder(this, dir)
				Push(this, dir)
			EndIf
		EndIf
	
	End Method


	Method Explode(this:TTileEntity, dir:Int)
		Local tile:TTileEntity = GetWithDir(this, dir)
		Local explodeTo:Int
		If IsButterfly(this, dir)
			explodeTo = TTileEntity.EXPLODETODIAMOND0
		Else
			explodeTo = TTileEntity.EXPLODETOSPACE0
		EndIf
		
		SetWithDir(this, explodeTo, dir)
		For Local i:Int = 1 To 8				'all directions
			If IsExplodable(tile, i)
				Explode(tile, i)
			ElseIf IsConsumable(tile, i)
				SetWithDir(tile, explodeTo, i)
			End If
		Next
	End Method


	Method DoMagic(this:TTileEntity, dir:Int)
		If magic.active = False
			magic.active = True
		End If
	
		Local tile:TTileEntity = GetWithDir(this, dir)
		If IsEmpty(tile, dir)
			If this.id = TTileEntity.FALLINGBOULDER
				SetWithDir(tile, TTileEntity.DIAMOND, dir)
			ElseIf this.id = TTileEntity.FALLINGDIAMOND
				SetWithDir(tile, TTileEntity.BOULDER, dir)
			End If
		EndIf
		SetWithDir(this, TTileEntity.SPACE, TDir.NONE)
	End Method


	Method Push(this:TTileEntity, dir:Int)
		If TDir.IsHorizontal(dir) = False Then Return
		Local tile:TTileEntity = GetWithDir(this, dir)
		If IsEmpty(tile, dir)
			If Rand(0,8) = 2
				MoveWithTileType(tile, dir, TTileEntity.BOULDER)
				If Not TMoving.grab
					Move(this, dir)
				End If
			End If
		EndIf
	End Method


	Method WinLevel()
		won = True
	End Method
	
	
	Method LoseLevel()
		lives:- 1
		If lives > 0
			Self.Reset(index)
		Else
			'GameOver!!!
		End If
	End Method



	Method DecreaseTimer:Int(amount:Int)
		time = Max(0, time - amount)
		Return time = 0
	End Method
	
	
	Method AutoDecreaseTimer()
		If g_frame > playerBirthFrame
			If g_frame Mod 60 = 0 Then DecreaseTimer(1)
		End If
	End Method
	
	
	Method RunOutTimer()
		Local amount:Int = 1
		score:+ amount
		If DecreaseTimer(amount) Then NextCave()
	End Method
	
	
	Method NextCave()
		If index < maps.Length - 1 Then Self.Reset(index + 1)
	End Method



	Method CollectDiamond()
		diamonds.collected:+ 1
		If diamonds.collected = diamonds.needed Then flash = g_frame + 5
		If diamonds.collected <= diamonds.needed
			score:+ diamonds.value
		Else
			score:+ diamonds.extraValue
		End If
	End Method


	Method GetKeyInput()
		If KeyControlDown("UP")
			TMoving.StartUp()
		Else
			TMoving.StopUp()
		EndIf
		If KeyControlDown("DOWN")
			TMoving.StartDown()
		Else
			TMoving.StopDown()
		EndIf
		If KeyControlDown("RIGHT")
			TMoving.StartRight()
		Else
			TMoving.StopRight()
		EndIf
		If KeyControlDown("LEFT")
			TMoving.StartLeft()
		Else
			TMoving.StopLeft()
		EndIf
		If KeyControlDown("GRAB")
			TMoving.StartGrab()
		Else
			TMoving.StopGrab()
		End If
	End Method



	Method IsExplodable:Int(this:TTileEntity, dir:Int)
		Return map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].explodeable
	End Method
	
	
	Method IsConsumable:Int(this:TTileEntity, dir:Int)
		Return map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].consumable
	End Method	

	
	Method IsRounded:Int(this:TTileEntity, dir:Int)
		Return map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].rounded
	End Method
	
		
	Method IsEmpty:Int(this:TTileEntity, dir:Int)
		Return map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].id = TTileEntity.SPACE
	End Method

	
	Method IsDirt:Int(this:TTileEntity, dir:Int)
		Return map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].id = TTileEntity.DIRT
	End Method
	
	
	Method IsBoulder:Int(this:TTileEntity, dir:Int)
		Return map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].id = TTileEntity.BOULDER
	End Method
	
	
	Method IsPlayer:Int(this:TTileEntity, dir:Int)
		Local id:Int = map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].id
		Return id = TTileEntity.PLAYER or id = TTileEntity.PLAYERBLINK or ..
			id = TTileEntity.PLAYERLEFT or id = TTileEntity.PLAYERRIGHT or ..
			id = TTileEntity.PLAYERTAP or id = TTileEntity.PLAYERTAPBLINK
	End Method

	
	Method IsButterfly:Int(this:TTileEntity, dir:Int)
		Local id:Int = map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].id
		Return id = TTileEntity.BUTTERFLYLEFT or ..
			id = TTileEntity.BUTTERFLYRIGHT or ..
			id = TTileEntity.BUTTERFLYDOWN or ..
			id = TTileEntity.BUTTERFLYUP
	End Method
	
	
	Method IsFirefly:Int(this:TTileEntity, dir:Int)
		Local id:Int = map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].id
		Return id = TTileEntity.FIREFLYLEFT or ..
			id = TTileEntity.FIREFLYRIGHT or ..
			id = TTileEntity.FIREFLYDOWN or ..
			id = TTileEntity.FIREFLYUP
	End Method
	
	
	Method IsAmoeba:Int(this:TTileEntity, dir:Int)
		Return map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].id = TTileEntity.AMOEBA
	End Method

	
	Method IsDiamond:Int(this:TTileEntity, dir:Int)
		Return map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].id = TTileEntity.DIAMOND
	End Method
	

	Method IsOutBox:Int(this:TTileEntity, dir:Int)
		Return map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].id = TTileEntity.OUTBOX
	End Method
		
	
	Method IsMagic:Int(this:TTileEntity, dir:Int)
		Local id:Int = map.map[ this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir] ].id
		Return id = TTileEntity.MAGICWALL or id = TTileEntity.MAGICWALLACTIVE
	End Method




	Method UpdateMap()
		Local entities:TBag = GetEntityGroup("tiles")
		For local index:Int = 0 until entities.GetSize()
			local tile:TTileEntity = TTileEntity( entities.Get(index) )
			If tile.lastUpdateFrame < g_frame
				Self.TileCheck(tile)
				Select tile.id
					Case TTileEntity.PLAYER, TTileEntity.PLAYERBLINK, ..
						TTileEntity.PLAYERLEFT, TTileEntity.PLAYERRIGHT, ..
						TTileEntity.PLAYERTAP, TTileEntity.PLAYERTAPBLINK

						UpdatePlayer(tile, TMoving.dir)
						g_cam.SetTarget(tile)

					Case TTileEntity.AMOEBA
						UpdateAmoeba(tile)
					Case TTileEntity.BOULDER
						UpdateRock(tile)
					Case TTileEntity.FALLINGBOULDER
						UpdateFallingRock(tile)
					Case TTileEntity.DIAMOND
						UpdateDiamond(tile)
					Case TTileEntity.FALLINGDIAMOND
						UpdateFallingDiamond(tile)
					Case TTileEntity.BUTTERFLYLEFT
						UpdateButterfly(tile, TDir.LEFT)
					Case TTileEntity.BUTTERFLYRIGHT
						UpdateButterfly(tile, TDir.RIGHT)
					Case TTileEntity.BUTTERFLYUP
						UpdateButterfly(tile, TDir.UP)
					Case TTileEntity.BUTTERFLYDOWN
						UpdateButterfly(tile, TDir.DOWN)
					Case TTileEntity.FIREFLYLEFT
						UpdateFirefly(tile, TDir.LEFT)
					Case TTileEntity.FIREFLYRIGHT
						UpdateFirefly(tile, TDir.RIGHT)
					Case TTileEntity.FIREFLYUP
						UpdateFirefly(tile, TDir.UP)
					Case TTileEntity.FIREFLYDOWN
						UpdateFirefly(tile, TDir.DOWN)

					'the following cases are essentialy animations.
					Case TTileEntity.EXPLODETOSPACE0
						tile.SetType(TTileEntity.EXPLODETOSPACE1)
					Case TTileEntity.EXPLODETOSPACE1
						tile.SetType(TTileEntity.EXPLODETOSPACE2)
					Case TTileEntity.EXPLODETOSPACE2
						tile.SetType(TTileEntity.EXPLODETOSPACE3)
					Case TTileEntity.EXPLODETOSPACE3
						tile.SetType(TTileEntity.EXPLODETOSPACE4)
					Case TTileEntity.EXPLODETOSPACE4
						tile.SetType(TTileEntity.SPACE)
					Case TTileEntity.EXPLODETODIAMOND0
						tile.SetType(TTileEntity.EXPLODETODIAMOND1)
					Case TTileEntity.EXPLODETODIAMOND1
						tile.SetType(TTileEntity.EXPLODETODIAMOND2)
					Case TTileEntity.EXPLODETODIAMOND2
						tile.SetType(TTileEntity.EXPLODETODIAMOND3)
					Case TTileEntity.EXPLODETODIAMOND3
						tile.SetType(TTileEntity.EXPLODETODIAMOND4)
					Case TTileEntity.EXPLODETODIAMOND4
						tile.SetType(TTileEntity.DIAMOND)							
					Case TTileEntity.PREPLAYER0
						If g_frame > playerBirthFrame
							tile.SetType(TTileEntity.PREPLAYER1)
						End If

						'force camera to go to this tile when the level starts.
						g_cam.SetTarget(tile)
					Case TTileEntity.PREPLAYER1
						tile.SetType(TTileEntity.PREPLAYER2)
					Case TTileEntity.PREPLAYER2
						tile.SetType(TTileEntity.PREPLAYER3)
					Case TTileEntity.PREPLAYER3
						tile.SetType(TTileEntity.PLAYER)
					Case TTileEntity.PREOUTBOX
						If diamonds.collected >= diamonds.needed
							tile.SetType(TTileEntity.OUTBOX)
						End If
					Case TTileEntity.GROWINGWALL
						UpdateGrowingWall( tile )
				End Select
			EndIf
		Next
	End Method	


	'we can change tile according to cave state
	Method TileCheck(this:TTileEntity)
	
		If flash > g_frame
			If this.id = TTileEntity.SPACE
				this.SetType(TTileEntity.FLASH)
			EndIf
		Else
			If this.id = TTileEntity.FLASH
				this.SetType(TTileEntity.SPACE)
			End If
		EndIf
		
		If magic.active = True
			If this.id = TTileEntity.MAGICWALL
				this.SetType(TTileEntity.MAGICWALLACTIVE)
			End If
		Else
			If this.id = TTileEntity.MAGICWALLACTIVE
				this.SetType(TTileEntity.WALL)
			End If
		End If
				
	End Method



	Method Move(this:TTileEntity, dir:Int)
		Self.SetWithDir(this, this.id, dir)
		this.SetType( TTileEntity.SPACE )
	End Method

	
	Method MoveWithTileType(this:TTileEntity, dir:Int, tileType:Int)
		Self.SetWithDir(this, tileType, dir)
		this.SetType( TTileEntity.SPACE )
	End Method



	Method Get:TTileEntity(mapX:Int, mapY:Int)
		Return map.map[mapX, mapY]
	End Method
	
	
	Method GetWithDir:TTileEntity(this:TTileEntity, dir:Int)
		Return map.map[this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir]]
	End Method
	

	Method Set(this:TTileEntity, tileType:Int)
		this.SetType( tiletype )
		this.lastUpdateFrame = g_frame
	End Method
	
	
	Method SetWithDir(this:TTileEntity, tileType:Int, dir:Int)
		map.map[this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir]].SetType(tileType)
		map.map[this.x + TDir.DIRX[dir], this.y + TDir.DIRY[dir]].lastUpdateFrame = g_frame
	End Method



	Method PreRender(tween:Double)
	End Method


	Method Render(tween:Double)

		TRenderState.Push()
		TRenderState.Reset()

		SetOrigin(TVirtualGfx.VG.vxoff, TVirtualGfx.VG.vyoff)

		SetGameColor( BLACK)
		DrawRect( 0, 0, GameWidth(), 34 )


		Local d1:String = diamonds.collected
		If diamonds.collected < 10 Then d1 = "0" + d1
		Local d2:String = diamonds.needed
		If diamonds.needed < 10 Then d2 = "0" + d2
		Local t1:String = Rset(time, 3).Replace(" ", "0")
		Local s1:String = Rset(score, 7).Replace(" ", "0")
		
		Local l1:String = lives
		If lives < 10 Then l1 = "0" + l1

		SetGameColor( CYAN )
		RenderText( d1 + "/" + d2 + "   " + l1 + "   " + t1 + "  " + s1, 0, 2, true, true )

		SetGameColor( WHITE )
		SetScale( 0.8, 0.8)

		DrawImage( GetResourceImage("tiles","images"), 75, 5, TAnim.FRAME_DIAMOND+2 )
		DrawImage( GetResourceImage("tiles","images"), 265, 5, TAnim.FRAME_FRONT )

		TRenderState.Pop()
	EndMethod
	


	Method PostRender(tween:Double)

	End Method

EndType