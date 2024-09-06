-- main.lua file

local moonshine = require 'moonshine'

-- [[GLOBAL OBJECTS]]
-- IMAGE_ITEMBOX = love.graphics.newImage("assets/itembox.png")
IMAGE_BACKGROUND = love.graphics.newImage("graphics/background.png")
IMAGE_POTION_ONE = love.graphics.newImage("graphics/potion.png")

IMAGE_POTION_WIDTH, IMAGE_POTION_HEIGHT = IMAGE_POTION_ONE:getDimensions() -- Items all have the same dimensions

ITEM_LIST = { IMAGE_POTION_ONE }

-- [[ MY FUNCTIONS ]]
-- Function for moving object to where mouse is when it is grabbed
function drag(obj)
    cursorX, cursorY = love.mouse.getPosition( )
    obj.posX = cursorX
    obj.posY = cursorY
    obj.left = cursorX - IMAGE_POTION_WIDTH
    obj.right = cursorX + IMAGE_POTION_WIDTH
    obj.top = cursorY - IMAGE_POTION_HEIGHT
    obj.bottom = cursorY + IMAGE_POTION_HEIGHT
end

function clearGrabbed()
    for i=1, #potionObjectList do
        potionObjectList[i].grabbed = false
    end
end

function checkMousePosition()
    -- Check if mouse clicked on any of the potions
    currentMousePosX = love.mouse.getX()
    currentMousePosY = love.mouse.getY()

    for i=1, #potionObjectList do
        if(
            (currentMousePosX > potionObjectList[i].left and currentMousePosX < potionObjectList[i].right) and
            (currentMousePosY > potionObjectList[i].top and currentMousePosY < potionObjectList[i].bottom) and
            not isGrabbed
        ) then
            potionObjectList[i].grabbed = true
            isGrabbed = true
        end
    end
end

function checkMouseHover()
    currentMousePosX = love.mouse.getX()
    currentMousePosY = love.mouse.getY()

    for i=1, #interactableObjectList do
        if(
            (currentMousePosX > interactableObjectList[i].left and currentMousePosX < interactableObjectList[i].right) and
            (currentMousePosY > interactableObjectList[i].top and currentMousePosY < interactableObjectList[i].bottom)
        ) then
            interactableObjectList[i].outline = true
        else
            interactableObjectList[i].outline = false
        end
    end
end

function createObject(image, x, y, width, height)
    return {
        image = image,
        posX = x,
        posY = y,
        left = x - width,
        right = x + width,
        top = y - height,
        bottom = y + height,
        outline = false,
        grabbed = false
    }
end


-- [[ LUA FUNCTIONS ]]
function love.load()
    potionObjectList = {}
    interactableObjectList = {}

    -- Testing shaders
    shaderTest = love.graphics.newShader("outline.glsl")
    shaderTest:send("stepSize",0.02)

    -- Global variable to keep track on whether mouse is already grabbing item or not
    isGrabbed = false

    -- Generate potion objects
    local x = 40
    local y = 410

    for i=1, #ITEM_LIST do
        local potion = createObject(ITEM_LIST[i], x, y, IMAGE_POTION_WIDTH, IMAGE_POTION_HEIGHT)
        x = x + 100
        table.insert(potionObjectList, potion)
        table.insert(interactableObjectList, potion)
    end
end

function love.draw()
    love.graphics.draw(IMAGE_BACKGROUND, 0, 0)

    love.graphics.draw(
        interactableObjectList[1].image,
        interactableObjectList[1].posX,
        interactableObjectList[1].posY,
        0,
        interactableObjectList[1].scale,
        interactableObjectList[1].scale
    )

    if (interactableObjectList[1].outline) then
        love.graphics.setShader(shaderTest)
        love.graphics.draw(
            interactableObjectList[1].image,
            interactableObjectList[1].posX,
            interactableObjectList[1].posY,
            0,
            interactableObjectList[1].scale,
            interactableObjectList[1].scale
        )
        love.graphics.setShader()
    end


    --[[
    for i=1, #interactableObjectList do
        effect(function()
            love.graphics.draw(
                interactableObjectList[i].image,
                interactableObjectList[i].posX,
                interactableObjectList[i].posY,
                0,
                interactableObjectList[i].scale,
                interactableObjectList[i].scale
            )
        end)
    end
    --]]
end

function love.update()
    checkMouseHover()

    if(love.mouse.isDown("1")) then
        checkMousePosition()
    else
        clearGrabbed()
        isGrabbed = false
    end

    for i=1, #potionObjectList do
        if(potionObjectList[i].grabbed) then
            drag(potionObjectList[i])
        end
    end
end