tileset = class("tileset")

function tileset:initialize(path, quadWidth, quadHeight)
	self.quads = {}
	self.image = love.graphics.newImage(path)

	self.width = quadWidth
	self.height = quadHeight

	local width = self.image:getWidth()
	local height = self.image:getHeight()

	for y=0, height/self.width-1 do
		for x=0, width/self.height-1 do
			local quad 

			quad = love.graphics.newQuad(x*self.width, y*self.height, self.width, self.height, width, height)
			
			table.insert(self.quads, quad)
		end
	end
end