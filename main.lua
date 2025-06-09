local pacman
local dots = {}
local score = 0
local ghost
local gameOver = false
local width = 800
local height = 600
local RestartButton = {
            x = 300,
            y = 320,
            width = 200,
            height = 50,
            text = "?restart the game?"
        }




function love.load()
    love.window.setTitle("Blueman")
    love.window.setMode(width, height, {resizable = true, vsync = true})
    maze = {
        image = love.graphics.newImage("Maze.png"), -- Load Maze image
        x = 0,
        y = 0,
        width = width,
        height = height
    }
    pacman = {
        image = love.graphics.newImage("Pacman.png"), -- Load Blueman image
        x = 100,
        y = 300,
        speed = 100,
        width = 32,
        height = 32
        }
        DotImage = love.graphics.newImage("Food.png") -- Load Dot/Food image
        ghost = {
            image = love.graphics.newImage("Red Ghost.png"), -- Load Ghost image
            x = 350,
            y = 0,
            speed = 50,
            width = 32,
            height = 32
        }

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
    if not gameOver then
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

    local dx = pacman.x -ghost.x
    local dy = pacman.y - ghost.y
    local dist = math.sqrt(dx * dx + dy * dy)

    if dist > 1 then
        local dirX = dx / dist
        local dirY = dy / dist
        ghost.x = ghost.x + dirX * ghost.speed * dt
        ghost.y = ghost.y + dirY * ghost.speed * dt
    end

    -- Check collision with dots
    for _, dot in ipairs(dots) do
        if not dot.collected and checkCollision(pacman, dot) then
            dot.collected = true
            score = score + 1
        end
    end
        if checkCollision(pacman, ghost) then
                gameOver = true
                love.window.setTitle("Game Over! Final Score: " .. score)
        end
    end
    
end

function love.draw()
    love.graphics.clear(0.1, 0.1, 0.1) -- Clear the screen with a dark color
    love.graphics.setBackgroundColor(0, 0, 0) -- Set color to black
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Welcome to Blueman!", width/2, 0) -- Display a welcome message
    love.graphics.draw(pacman.image, pacman.x, pacman.y)
    love.graphics.draw(ghost.image, ghost.x, ghost.y)
    love.graphics.draw(maze.image, maze.x, maze.y, 0, maze.width / maze.image:getWidth(),maze.height / maze.image:getHeight())
    love.graphics.setColor(1, 1, 1) -- Reset color to white
    for _, dot in ipairs(dots) do
        if not dot.collected then
            love.graphics.draw(DotImage, dot.x, dot.y)
        end
    end
    love.graphics.print("Score: " .. score, 10, 10)
    if gameOver then
        love.graphics.setBackgroundColor(0, 0, 0) -- Set background color to black
        love.graphics.setColor(1, 0, 0) -- Display game over message in red
        love.graphics.printf("GAME OVER!!!!!", width/2, height/2, 800, "center",
            0, 2, 2)
            love.graphics.rectangle("fill", RestartButton.x, RestartButton.y, RestartButton.width, RestartButton.height)
            love.graphics.printf("Restart", RestartButton.x, RestartButton.y + 15, RestartButton.width, "center")
        love.graphics.setColor(1, 1, 1) -- Reset color to white
        if love.mouse.isDown(1) then
            local mouseX, mouseY = love.mouse.getPosition()
            if mouseX >= RestartButton.x and mouseX <= RestartButton.x + RestartButton.width and
               mouseY >= RestartButton.y and mouseY <= RestartButton.y + RestartButton.height then
                resetGame()
                love.window.setTitle("Blueman")
            end
        end
    end
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

function resetGame()
    pacman.x = 100
    pacman.y = 300
    score = 0
    gameOver = false
    for _, dot in ipairs(dots) do
        dot.collected = false
    end
    ghost.x = 350
    ghost.y = 0
end
