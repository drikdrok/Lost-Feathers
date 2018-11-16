feather = class("feather")
feathers = {}

featherImage = love.graphics.newImage("assets/gfx/images/feather.png")

function feather:initialize(x, y)
	self.x = x
	self.y = y
	self.width = 16
	self.height = 16

	self.id = #feathers + 1
	self.type = "feather"

	self.solid = false

	collisionWorld:add(self, self.x, self.y, self.width, self.height)

	table.insert(feathers, self)
end

function feather:update(dt)

end

function feather:draw()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(featherImage, self.x, self.y)
end

function feather:destroy()
	collisionWorld:remove(self)
	feathers[self.id] = nil
	player.feathers = player.feathers + 1
end

function updateFeathers(dt)
	for i,v in pairs(feathers) do
		v:update(dt)
	end
end

function drawFeathers(dt)
	for i,v in pairs(feathers) do
		v:draw()
	end
end