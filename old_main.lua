-- main.lua file

--[[ This is how a long, multiline comment is done in Lua,
by using 'long brackets' (i.e. double square brackets) ]]

-- Old file from tileset tutorial

function love.load()
    Tileset = love.graphics.newImage('tilesets/rpgtileset_cyporkador.png')
    TileWidth, TileHeight = 32, 32 -- width and height of one tile (in pixels)
    local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight() -- width and height of entire tileset

    Quads = {
        love.graphics.newQuad(216, 60, TileWidth, TileHeight, tilesetW, tilesetH), -- GrassQuad
        love.graphics.newQuad(264, 156, TileWidth, TileHeight, tilesetW, tilesetH) -- WaterQuad
    }
end

function love.draw()
    TileTable = {
        {1,1,1,1},
        {2,2,2,2,2},
        {1,1,1,1}
    }
    
    for rowIndex=1, #TileTable do -- for index 1 to TileTable.length()
        local row = TileTable[rowIndex] -- {1,1,1} etc.
        for columnIndex=1, #row do
            local index = row[columnIndex]
            local x = (columnIndex-1)*TileWidth
            local y = (rowIndex-1)*TileHeight
            love.graphics.draw(Tileset, Quads[index], x, y) -- Lua is weird and 1-indexes
        end
    end
end

-- 216:60 to 251:95 ==> 35x35