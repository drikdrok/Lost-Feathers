game = class("game")

local islandImage = love.graphics.newImage("assets/gfx/images/far-grounds.png")
local seaImage = love.graphics.newImage("assets/gfx/images/sea.png")
local cloudsImage = love.graphics.newImage("assets/gfx/images/clouds.png")
local skyImage = love.graphics.newImage("assets/gfx/images/sky.png")

function game:initialize()
	self.width = love.graphics.getWidth()
	self.height = love.graphics.getHeight()

	self.font = love.graphics.newFont("assets/gfx/fonts/pixelmix.ttf", 12)
	self.fonts = {}

	self.islandOffsetX = 0
	self.islandOffsetY = 0 

	self.cloudsOffsetX = 0
	self.cloudsOffsetY = 0 

	self.timer = 0 


end

function game:update(dt)

	if player.feathers < 4 then
		self.timer = self.timer + dt
	end

	player:update(dt)
	map:update(dt)

	--Update background parralax

	self.islandOffsetX = -(camera.x - 6804) / 10
	self.islandOffsetY = -(camera.y - 7000) / 10
	self.cloudsOffsetX = -(camera.x - 6804) / 40
	self.cloudsOffsetY = -(camera.y - 7000) / 40
end

function game:draw()
	--love.graphics.setColor(158/255, 194/255, 1)
	--love.graphics.rectangle("fill", 0, 0, game.width, game.height) -- Temporary blue sky

	love.graphics.setColor(1,1,1)

	--Background
	for i = -1, 4 do
		love.graphics.draw(skyImage, i*112*3, 0, 0, 3, 3)
	end	
	for i = -1, 4 do
		love.graphics.draw(cloudsImage, i*112*2 + self.cloudsOffsetX, 100 + self.cloudsOffsetY, 0, 2, 2)
	end	

	love.graphics.draw(seaImage, 0, 450, 0, 12, 12)
	love.graphics.draw(islandImage, -100 + self.islandOffsetX, 400 + self.islandOffsetY, 0, 3, 3)

	--Actual game
	camera:attach()
		map:draw()
		player:draw()

		if debug then 
			local items, len = collisionWorld:getItems()
			for i,v in pairs(items) do
				love.graphics.rectangle("line", v.x, v.y, v.width, v.height)
			end
		end
	camera:detach()


	--GUI

	self:fontSize(20)
	love.graphics.setColor(0,0,0)
	love.graphics.print(player.feathers.."/4", self.width - self.font:getWidth(player.feathers.."/4") - 36, 13)
	love.graphics.setColor(1,1,1)
	love.graphics.draw(featherImage, self.width - 36, 7, 0, 2, 2)


	if debug then 
		love.graphics.print(love.timer.getFPS())
		love.graphics.print("Press f1 to go out of debug mode", 0, 15)
	end

	love.graphics.setColor(0,0,0)
	
	if player.feathers >= 4 then 
		self:fontSize(20)
		local s = "You won in ".. round(self.timer, 2).." seconds!" 
		love.graphics.print(s, self.width / 2 - self.font:getWidth(s) / 2, 30)
	else
	love.graphics.print(round(self.timer, 2).."s", self.width / 2 - self.font:getWidth(round(self.timer, 2).."s") / 2, 15)

	end

	love.graphics.setColor(0,0,0)
	love.graphics.print("Made For KMG GameJam In 12 Hours")
	love.graphics.print("By Christian Schwenger 1.B", 0, 20)
	love.graphics.setColor(1,1,1)
end

function game:fontSize(size)
	if self.fonts[size] then 
		self.font = self.fonts[size]
	else
		local font = love.graphics.newFont("assets/gfx/fonts/pixelmix.ttf", size)
		self.fonts[size] = font
		self.font = font
	end
	love.graphics.setFont(self.font)
end

function game:print(text, posX, posY, color)
	love.graphics.setColor(color or {1,1,1})

	local x,y = camera:cameraCoords(posX, posY)
	test = posX
	
	camera:detach()
		love.graphics.print(text, x, y)
	camera:attach()

	love.graphics.setColor(1,1,1)
end