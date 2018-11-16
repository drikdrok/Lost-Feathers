--Made for KMG Game Jam 2018 in 12 hours
-- All graphics used are from itch.io, except for the beautiful bird, feather and sign.

debug = false

love.graphics.setDefaultFilter("nearest", "nearest")
require("assets/codebase/core/require")


function love.load()
	collisionWorld = bump.newWorld()
	
	camera = Camera(6804, 7000)
	camera:zoom(2)
	camera.smoother = camera.smooth.damped(6)

	game = game:new()
	player = player:new()
	map = map:new("map")
end

function love.update(dt)
	game:update(dt)

	camera:lockX(player.x)
	camera:lockY(player.y)
end

function love.draw()
	game:draw()
end

function love.keypressed(key)
	if key == "escape" then 
		love.event.quit()
	elseif key == "f1" then 
		debug = not debug
	end

	player:keypressed(key)
end

function round(num, n)
    local mult = 10^(n or 0)
    return math.floor(num * mult + 0.5) / mult
end