

Type TCaveCam Extends TCameraEntity

	field timesTomoveX:Int
	field timesTomoveY:Int
	field xdir:Int
	field ydir:Int


	'override!!!
	Method UpdateEntity()

		if _target = Null then return

		'extra code.
		'target is allowed to travel 200 px from camera center
		'then, the camera scrolls 200 px. 4 pixels each update, is 50 updates
		if timesTomoveX = 0
			'move camera horizontal?
			if Abs( EntityX(_target) - EntityX(Self) ) > 200
				timesTomoveX = 50
				if EntityX(Self) > EntityX( _target )
					xdir = -4
				else
					xdir = 4
				endif
			endif
		endif

		'as vertical resolution is lower, scroll earlier
		if timesTomoveY = 0 
			'move camera vertical?
			if Abs( EntityY(_target) - EntityY(Self) ) > 150
				timesTomoveY = 37
				if EntityY(Self) > EntityY( _target )
					ydir = -4
				else
					ydir = 4
				endif
			endif
		endif


		'move?
		if timesTomoveX > 0
			MoveEntity(Self, xdir, 0)
			timesTomoveX:-1
		endif
		if timesTomoveY > 0
			MoveEntity(Self, 0, ydir)
			timesTomoveY:-1
		endif

		'shake?
		if _shaking
			Local angle:Float = Rand(360) 
			_shakeVector.Set(Sin(angle), Cos(angle))
			_shakeVector.Multiply(_shakeRadius)

			_shakeRadius:* 0.95
			if _shakeRadius < 0.001 then _shaking = false
		endif


		'extra code.
		'restrict camera movement to cave
		'get the world bounds of the map
		'assumes map top left is at 0,0
		Local state:TPlayState = TPlayState(g_game.GetGameStateByID(STATE_PLAY))
		local map:TMap2d = state.map
		local mapwidth:Int = map.width * map.tilesize
		local mapheight:Int = map.height * map.tilesize

		local newx:int = EntityX(self)
		local newy:Int = EntityY(self)
		local changex:int = false
		local changey:Int = false


		
		if EntityX( Self ) <= GameWidth() / 2
			'check left side
			newx = GameWidth() / 2
			changex = true
		elseif EntityX( self ) => mapwidth - GameWidth()/2
			'and right side
			newx = mapwidth - GameWidth() / 2
			changex = true
		endif

		if EntityY( Self ) <= (GameHeight() / 2) - map.tilesize	' for top status
			'check top side
			newy = (GameHeight() / 2) - map.tilesize
			changey = true
		elseif EntityY( self ) => mapheight - GameHeight()/2
			'and right side
			newy = mapheight - GameHeight() / 2
			changey = true
		endif

		'map bounds, if needed.
		if changex
			SetEntityPosition(Self, newx, EntityY(self) )
		endif
		if changey
			SetEntityPosition(Self, EntityX(self), newy )
		endif


		'original code.
		'set new draw offset
		'add the virtual resolution viewport
		local originX:Float = GameWidth() / 2 - EntityX(Self) + _shakeVector.GetX() + TVirtualGfx.VG.vxoff
		local originY:Float = GameHeight() / 2 - EntityY(Self) + _shakeVector.GetY() + TVirtualGfx.VG.vyoff
		SetOrigin ( originX, originY )

		'determine camera viewPort (visible area)
		_viewPort.SetPosition( _position.GetX() - GameWidth() / 2 + _shakeVector.GetX(), ..
		                       _position.GetY() - GameHeight() / 2 + _shakeVector.GetY() )
		_viewPort.SetDimension( GameWidth(), GameHeight() )

	EndMethod


End Type