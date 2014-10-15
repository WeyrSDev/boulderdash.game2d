
'map2d
'tailered for boulderdash
'this type contains specific fields and tiles for that game.
Type TMap2d
	
	Field map:TTileEntity[,]
	Field tileSize:Int
	field width:Int
	field height:Int

	field playTime:Int
	field diamondquota:Int
	field diamondscore:Int
	field diamondextrascore:Int

	field millingTime:Int
	field amoebamax:Int
	field amoebaslow:Int

	field renderLayer:Int
	field entityGroup:String


	'map data is put into this array by the Create() function
	'Reset() method will read this array and reset the entire map.
	field mapdata:String[]


	'these are the index definitions of the first line
	'in the map array
	Const TILESETNAME:Int = 0
	Const TILEDIMENSION:Int = 1
	Const MAPWIDTH:Int = 2
	Const MAPHEIGHT:Int = 3
	Const DIAMONDSNEEDED:Int = 4
	Const TIME:Int = 5
	Const DIAMONDVALUE:Int = 6
	Const EXTRASCORE:Int = 7
	Const MAXAMOEBASIZE:Int = 8
	Const AMOEBADELAY:Int = 9
	Const MAGICTIME:Int = 10


	Function Create:TMap2d( fileName:String, layer:Int, group:String )
		local in:TStream = ReadStream( fileName )
		if not in
			RuntimeError("cannot load map data: " + fileName )
		endif

		'create the map object
		Local this:TMap2d = new TMap2d

		'set size of map array
		'1st line is map definitions
		local line:String = ReadLine(in)
		local settings:String[] = line.Split(",")
		'get height (# of lines)
		local h:Int = Int( settings[TMap2d.MAPHEIGHT])
		'set size of mapdata array
		this.mapdata = new String[h+1]

		'put first line in array
		local index:Int = 0
		this.mapdata[index] = line

		'do the rest (actual map data)
		while not eof(in)
			line = ReadLine( in )
			index:+1
			this.mapdata[index] = line
		wend

		this.renderLayer = layer
		this.entityGroup = group

		'done
		CloseStream( in )
		return this
	End Function


	Method Reset()
		local index:Int = 0
		'get settings line
		local line:string = mapdata[index]
		local settings:String[] = line.Split(",")

		'set definitions
		tileSize = Int( settings[TMap2d.TILEDIMENSION] )
		width = Int( settings[TMap2d.MAPWIDTH])
		height = Int( settings[TMap2d.MAPHEIGHT])
		playTime = Int( settings[TMap2d.TIME] )
		diamondquota = Int( settings[TMap2d.DIAMONDSNEEDED] )
		diamondscore = Int( settings[TMap2d.DIAMONDVALUE] )
		diamondextrascore = Int( settings[TMap2d.EXTRASCORE] )
		millingTime = Int( settings[TMap2d.MAGICTIME] )
		amoebamax = Int( settings[TMap2d.MAXAMOEBASIZE] )
		amoebaslow = Int( settings[TMap2d.AMOEBADELAY] )
		'....

		'define map array

		'this destroys the old map..
		'entity deletion and stuff should be here as well.

		ClearEntityGroup(entityGroup)

		map = New TTileEntity[ width, height ]




		' --------------------------------------------
		'read map data and place in array
		'create entities
		local y:Int = 0
		local tile:TTileEntity
		index:+ 1
		while index < mapdata.length
			local line:string = mapdata[index]
			for local x:Int = 0 until line.length
				tile = Null
				select line[x..x+1]
					Case " "
						tile = TTileEntity.Create( x, y, TTileEntity.SPACE )
					Case "."
						tile = TTileEntity.Create( x, y, TTileEntity.DIRT )
					Case "a"
						tile = TTileEntity.Create( x, y, TTileEntity.AMOEBA )
					Case "b"
						tile = TTileEntity.Create( x, y, TTileEntity.BUTTERFLYLEFT )
					Case "d"
						tile = TTileEntity.Create( x, y, TTileEntity.DIAMOND )
					Case "f"
						tile = TTileEntity.Create( x, y, TTileEntity.FIREFLYLEFT )
					Case "g"
						tile = TTileEntity.Create( x, y, TTileEntity.GROWINGWALL )
					Case "m"
						tile = TTileEntity.Create( x, y, TTileEntity.MAGICWALL )
					Case "P"
						tile = TTileEntity.Create( x, y, TTileEntity.PREOUTBOX )
					Case "X"
						tile = TTileEntity.Create( x, y, TTileEntity.PREPLAYER0 )
					Case "r"
						tile = TTileEntity.Create( x, y, TTileEntity.BOULDER )
					Case "W"
						tile = TTileEntity.Create( x, y, TTileEntity.STEELWALL )
					Case "w"
						tile = TTileEntity.Create( x, y, TTileEntity.WALL )

					Default
						RuntimeError( "Unrecognized tile id: '" + settings[ x ] + "'." )
				end select

				if tile
					map[ x,y ] = tile
					tile.SetPosition( x * tileSize, y * tileSize )
					AddEntity( tile, renderLayer, entityGroup )	
				endif
			next
			index:+1
			y:+1
		wend
	End Method

End Type



'these types hold settings only

Type TDiamonds
	Field collected:Int
	Field needed:Int
	Field value:Int
	Field extraValue:Int
End Type


Type TAmoeba
	Field dead:Int
	Field enclosed:Int
	Field size:Int
	Field maxsize:Int
	Field slow:Int
End Type


Type TMagic
	Field active:Int
	Field millingTime:Int
End Type
