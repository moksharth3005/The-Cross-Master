function love.load()
    game_state = 3
    socket = require 'socket'
    love.window.setMode(800, 550)
    lives = 1
    speed = 200
    wave_count = 0
    x = 50
    y = 50
    X = 100
    Y = 100
    bullet = {}
    bullet.shoot = false
    bullet.x_bullet = X + 80
    bullet.y_bullet = Y + 15
    bullet.speed = speed + 100
    bullet.bullet_count = 0
    math.randomseed(os.time())
    enemy_y = {}
    enemy_y.a = math.random(5, 70)
    enemy_y.b = math.random(100, 170)
    enemy_y.c = math.random(200, 270)
    enemy_y.d = math.random(300, 370)
    enemy_y.e = math.random(430, 500)
    enemy = {}
    enemy.speeda = 70
    enemy.speedb = 80
    enemy.speedc = 60
    enemy.speedd = 75
    enemy.speede = 85
    enemy.image = love.graphics.newImage("frame-1.png")
    enemy_x = {}
    enemy_x.a = (math.random(810, 920))
    enemy_x.b = (math.random(810, 920))
    enemy_x.c = (math.random(810, 920))
    enemy_x.d = (math.random(810, 920))
    enemy_x.e = (math.random(810, 920))
    score = 0
    background = love.graphics.newImage("ground.png")
    love.audio.setVolume(0.4)
    background_sound = love.audio.newSource("background.mp3", "stream")
    player = love.graphics.newImage("Hotpot.png")
    enemy2 = {}
    enemy2.exist = false
    enemy2.image = love.graphics.newImage("frame1.png")
    enemy2.y = math.random(20, 500)
    enemy2.x = 900
    enemy2.up = true
    home = love.graphics.newImage("home.png")
    game = love.graphics.newImage("game.png")
    fence = love.graphics.newImage("fence.png")
    print(game_state)
end
function love.update(dt)
    if game_state == 1 then
        love.audio.play(background_sound)
    end
    if game_state == 1 then
        if love.keyboard.isDown("left") then
            X = X - speed * dt
        elseif love.keyboard.isDown("right") then
            X = X + speed * dt
        elseif love.keyboard.isDown("up") then
            Y = Y - speed * dt
        elseif love.keyboard.isDown("down") then
            Y = Y + speed * dt            
        end
        if love.keyboard.isDown("space") then
            if bullet.bullet_count == 7 then
                bullet.shoot = false 
            else
                bullet.x_bullet = X + 80
                bullet.y_bullet = Y + 15
                bullet.shoot = true
                shoot()
            end
        end
        if enemy_x.a <= 45 then
            lives = lives- 1
        end
        if enemy_x.b <= 45 then
            lives = lives-1
        end
        if enemy_x.c <= 45 then
            lives = lives-1
        end
        if enemy_x.d <= 45 then
            lives = lives-1
        end
        if enemy_x.e <= 45 then
            lives = lives-1
        end
        if enemy2.x <= 45 then
            lives = lives- 1
        end
        if lives <= 0 then
            lives = 0
            game_state = 2
        end

        bulletmovement(dt)
        if X <= 100 then
            X = 100
        end
        if Y <= 0 then
            Y = 0
        end
        if Y + 70 >= 550 then
            Y = 550 - 70
        end
        enemy_movment(dt)
        detect_collision()
    end
    if score >= 10 then
        monster(dt)
    end
    if game_state ==  2 then
        love.audio.stop(background_sound)
    end
end

function love.draw()
    if game_state == 1 then
        love.graphics.draw(background)
        love.graphics.draw(background, 0, -200)
        love.graphics.draw(background, 0, 200)
        love.graphics.draw(player, X, Y)
        shootimage()
        spawn()
        love.graphics.draw(fence, 13, 0)
        love.graphics.draw(fence, 13, 63)
        love.graphics.draw(fence, 13, 63*2)
        love.graphics.draw(fence, 13, 63*3)
        love.graphics.draw(fence, 13, 63*4)
        love.graphics.draw(fence, 13, 63*5)
        love.graphics.draw(fence, 13, 63*6)
        love.graphics.draw(fence, 13, 63*7)
        love.graphics.draw(fence, 13, 63*8)
        love.graphics.print("Your score is "..score)
        if enemy2.exist == true then
            love.graphics.draw(enemy2.image, enemy2.x, enemy2.y)
        end
    end
    if game_state == 3 then
        love.graphics.draw(home, 0, 0)
        if love.mouse.isDown(1) then
            game_state = 1
        end
    end
    if game_state == 2 then
        if love.mouse.isDown(1) then
            love.load()
        end
        love.graphics.draw(game)
        score = 0
    end
end
function shoot() 
    if game_state == 1 then
        if bullet.shoot == true then
            if bullet.x_bullet > 500 then
                bullet.shoot = false          
            end
        end
    end
end
function shootimage() 
    if game_state == 1 then
        if bullet.shoot == true then
            love.graphics.rectangle("fill", bullet.x_bullet, bullet.y_bullet, 15, 10)
        end
    end
end
function bulletmovement(dt)
    if game_state == 1 then
        if bullet.shoot == true then
            bullet.x_bullet = bullet.x_bullet + bullet.speed * dt
        end
    end
end
function spawn()
    if game_state == 1 then
        love.graphics.draw(enemy.image, enemy_x.a, enemy_y.a)
        love.graphics.draw(enemy.image, enemy_x.b, enemy_y.b)
        love.graphics.draw(enemy.image, enemy_x.c, enemy_y.c)
        love.graphics.draw(enemy.image, enemy_x.d, enemy_y.d)
        love.graphics.draw(enemy.image, enemy_x.e, enemy_y.e)
    end
end
function enemy_movment(dt)
    if game_state == 1 then
        enemy_x.a = enemy_x.a - enemy.speeda * dt
        enemy_x.b = enemy_x.b - enemy.speedb * dt
        enemy_x.c = enemy_x.c - enemy.speedc * dt
        enemy_x.d = enemy_x.d - enemy.speedd * dt
        enemy_x.e = enemy_x.e - enemy.speede * dt
    end
end
function detect_collision()
    for i = 1, 5 do
        if bullet.shoot == true and bullet.x_bullet + 15 >= enemy_x[string.char(96+i)] and bullet.x_bullet <= enemy_x[string.char(96+i)] + 70 and bullet.y_bullet + 10 >= enemy_y[string.char(96+i)] and bullet.y_bullet <= enemy_y[string.char(96+i)] + 70 then
            bullet.shoot = false
            enemy_x[string.char(96+i)] = 950
            enemy_y[string.char(96+i)] = math.random(5, 500)
            score = score + 1
        end
    end
    if enemy2.exist == true then
        if check_collision(bullet.x_bullet, bullet.y_bullet, 15, 10, enemy2.x, enemy2.y, 64, 64) then
            score = score + 5
            bullet.shoot = false
            enemy2.y = math.random(20, 500)
            enemy2.x = 980
        end
    end
end
function monster(dt)
    enemy2.exist = true
    enemy2.x = enemy2.x - enemy.speedb * dt
    if enemy2.y + 70 >= 550 then
        enemy2.up = true
    end
    if enemy2.y <= 0 then
        enemy2.up = false
    end
    if enemy2.up == true then
        enemy2.y = enemy2.y - enemy.speede * dt
    end
    if enemy2.up == false then
        enemy2.y = enemy2.y + enemy.speede * dt
    end
end
function check_collision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end
