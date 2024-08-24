-- main.lua file

--[[ This is how a long, multiline comment is done in Lua,
by using 'long brackets' (i.e. double square brackets) ]]

-- [[ MY FUNCTIONS ]]
-- Function for moving object to where mouse is when it is grabbed
function drag(obj)
    cursorX, cursorY = love.mouse.getPosition( )
    obj.posX = cursorX
    obj.posY = cursorY
end

function clearGrabbed()
    for i=1, #potionObjectList do
        potionObjectList[i].grabbed = false
    end
end

function checkMousePosition()
    -- Check if mouse clicked on any of the potions
    for i=1, #potionObjectList do
        if(
            (love.mouse.getX() > potionObjectList[i].posX - delta and love.mouse.getX() < potionObjectList[i].posX + delta) and
            (love.mouse.getY() > potionObjectList[i].posY - delta and love.mouse.getY() < potionObjectList[i].posY + delta)
        ) then
            potionObjectList[i].grabbed = true
        end
    end
end


-- [[ LUA FUNCTIONS ]]
function love.load()
    cursor = love.mouse.getCursor( )
    delta = 50

    background = love.graphics.newImage("assets/background.png")

    potionObject = {
        image = love.graphics.newImage('assets/potion.png'),
        posX = 100,
        posY = 100,
        grabbed = false
    }

    potionObject2 = {
        image = love.graphics.newImage('assets/potion.png'),
        posX = 300,
        posY = 400,
        grabbed = false
    }

    potionObjectList = { potionObject, potionObject2 }
end

function love.draw()
    love.graphics.draw(background, 0, 0)

    for i=1, #potionObjectList do
        love.graphics.draw(potionObjectList[i].image, potionObjectList[i].posX, potionObjectList[i].posY)
    end
end

function love.update()
    if(love.mouse.isDown("1")) then
        checkMousePosition()
    else
        clearGrabbed()
    end

    for i=1, #potionObjectList do
        if(potionObjectList[i].grabbed) then
            drag(potionObjectList[i])
        end
    end
end