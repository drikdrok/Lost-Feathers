map = class("map")

function map:initialize(name)

	self.tileset = tileset:new("assets/gfx/tilesets/tileset.png", 16, 16)
	
	self.data = require("assets/maps/"..name)

	self.layers = self.data.layers

	self.canvases = {}
	self.rects = {}

	for i,v in pairs(self.layers) do
		if v.name == "background" then
			self:createStaticCanvas(v, "background")
		elseif v.name == "foreground" then 
			self:createStaticCanvas(v, "foreground")
		elseif v.name == "solids" then 
			self:createSolids(v)
		elseif v.name == "feathers" then 
			self:createFeathers(v)
		elseif v.name == "enemies" then 
			self:createEnemies(v)
		end	
	end
end

function map:update(dt)
	updateFeathers(dt)
	updateEnemies(dt)
end

function map:draw()
	for i,v in pairs(self.canvases) do
		love.graphics.draw(v, 0, 0)
	end		

	drawFeathers()
	drawEnemies()

	--Sign text

	game:fontSize(18)
	game:print("Up Hard, Down Easy", 6670, 7040, {0,0,0})
	game:print("Up Easy, Down Hard", 7302, 7040, {0,0,0})
	game:print("You Can Wall Jump!", 8171, 6834, {0,0,0})
	game:print("You Can Wall Jump!", 5065, 7590, {0,0,0})
	game:print("Please Find The Feathers I've Lost,", 6918, 7000, {0,0,0})
	game:print("So I Can Fly Again!", 6955, 7020, {0,0,0})
end

function map:createStaticCanvas(layer, name)
	local canvas = love.graphics.newCanvas(layer.width*16, layer.height*16)

	love.graphics.setCanvas(canvas)
	for y = 0, layer.height do
		for x = 0, layer.width do
			local index = y*layer.width + (x+1)
			if layer.data[index] then  
				if layer.data[index] > 0 then --There is no 0th quad
					love.graphics.draw(self.tileset.image, self.tileset.quads[layer.data[index]], x * 16, y * 16)
				end
			end
		end
	end

	if name == "background" then 
		
	end
	love.graphics.setCanvas()

	table.insert(self.canvases, canvas)
end


function map:createSolids(layer)
	for i,v in pairs(layer.objects) do
		local rect = {x = v.x, y = v.y, width = v.width, height = v.height, walljump = false, solid = true}

		if v.walljump then 
			rect.walljump = true
		end  

		collisionWorld:add(rect, rect.x, rect.y, rect.width, rect.height)

		table.insert(self.rects, rect)
	end
end

function map:createFeathers(layer)
	for i,v in pairs(layer.objects) do
		feather:new(v.x-16, v.y-16) -- -16 to align it as it is seen in tiled editor
	end
end

function map:createEnemies(layer)
	for i,v in pairs(layer.objects) do
		enemy:new(v.x, v.y - 56)
	end
end