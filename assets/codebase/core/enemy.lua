enemy = class("enemy")
enemies = {}

local enemyImage = love.graphics.newImage("assets/gfx/sheets/enemy.png")

function enemy:initialize(x, y)
	self.x = x
	self.y = y

	self.width = 30
	self.height = 56

	self.id = #enemies + 1

	self.direction = -1

	self.speed = 50

	self.type = "enemy"


	self.sensor = { -- Better Name?
		x = self.x - 16,
		y = self.y + self.height,
		width = 16,
		height = 16,
		solid = false 
	}


	collisionWorld:add(self, self.x, self.y, self.width, self.height)
	collisionWorld:add(self.sensor, self.sensor.x, self.sensor.y, self.sensor.width, self.sensor.height)

	table.insert(enemies, self)
end

function enemy:update(dt)
	self.x = self.x + self.speed * self.direction * dt

	if self.direction == 1 then 
		self.sensor.x = self.x + self.width
	else
		self.sensor.x = self.x - 16
	end

	collisionWorld:update(self, self.x, self.y)
	collisionWorld:update(self.sensor, self.sensor.x, self.sensor.y)

	local x, y, cols, len = collisionWorld:check(self.sensor, self.sensor.x, self.sensor.y)

	if #cols < 1 then 
		self.direction = -self.direction
	end

end

function enemy:draw()
	love.graphics.setColor(1,1,1)
	if self.direction == 1 then  --This is kinda dumb, but don't have time to do it properly
		love.graphics.draw(enemyImage, self.x + self.width, self.y, 0, -1, 1)
	else
		love.graphics.draw(enemyImage, self.x, self.y, 0, 1, 1)
	end
end

function updateEnemies(dt)
	for i,v in pairs(enemies) do
		v:update(dt)
	end	
end

function drawEnemies()
	for i,v in pairs(enemies) do
		v:draw()
	end		
end