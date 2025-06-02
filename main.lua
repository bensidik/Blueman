local pacman
local dots = {}
local score = 0



function love.load()
    love.window.setTitle("Blueman")
    love.window.setMode(800, 600, {resizable = true, vsync = true})
    pacman = {
        image = love.graphics.newImage("pacman.png"), -- Load Pacman image
        x = 100,
        y = 300,
        speed = 100,
        width = 32,
        height = 32
        }
        dots = love.graphics.newImage("food.png")

    -- Create dots
    for i = 1, 10 do
        table.insert(dots, {
            x = math.random(0, 600),
            y = math.random(0, 400),
            width = 16,
            height = 16,
            collected = false
        })
    end
end

function love.update(dt)
    if love.keyboard.isDown("up") then
        pacman.y = pacman.y - pacman.speed * dt
    elseif love.keyboard.isDown("down") then
        pacman.y = pacman.y + pacman.speed * dt
    end

    if love.keyboard.isDown("left") then
        pacman.x = pacman.x - pacman.speed * dt
    elseif love.keyboard.isDown("right") then
        pacman.x = pacman.x + pacman.speed * dt
    end

    -- Check collision with dots
    for _, dot in ipairs(dots) do
        if not dot.collected and checkCollision(pacman, dot) then
            dot.collected = true
            score = score + 1
        end
    end
end

function love.draw()
    love.graphics.clear(0.1, 0.1, 0.1) -- Clear the screen with a dark color
    love.graphics.setBackgroundColor(0, 0, 0) -- Set color to black
    love.graphics.setColor(255, 0, 0)
    love.graphics.print("Welcome to Blueman!", 350, 280) -- Display a welcome message
    love.graphics.draw(pacman.image, pacman.x, pacman.y)
    for _, dot in ipairs(dots) do
        if not dot.collected then
            love.graphics.draw(dots, dot.x, dot.y)
        end
    end
    love.graphics.print("Score: " .. score, 10, 10)
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end
