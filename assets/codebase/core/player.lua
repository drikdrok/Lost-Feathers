player = class("player")

local featherSound = love.audio.newSource("assets/sfx/feather.wav", "static")
local deathSound = love.audio.newSource("assets/sfx/death.wav", "static")

local function playerFilter(item, other)
	if other.solid then 
		return "slide"
	else
		return "cross"
	end
end


function player:initialize()
	self.x = 6804
	self.y = 7000

	self.drawX = 6804
	self.drawY = 7000

	self.xvel = 0
	self.yvel = 0
	self.gravity = 1350

	self.width = 16*1.4
	self.height = 28*1.4

	self.speed = 300

	self.canJump = false

	self.canWallJump = false
	self.wallJumpDirection = 1

	self.feathers = 0


	self.sheet = love.graphics.newImage("assets/gfx/sheets/player.png")
	self.grid = anim8.newGrid(50, 37, self.sheet:getWidth(), self.sheet:getHeight())


	self.animations = {
		idle_right = anim8.newAnimation(self.grid("1-4", 1), 0.2),
		idle_left = anim8.newAnimation(self.grid("1-4", 2), 0.2),
		run_right = anim8.newAnimation(self.grid("1-6", 3), 0.1),
		run_left = anim8.newAnimation(self.grid("1-6", 4), 0.1),
		hang_right = anim8.newAnimation(self.grid("1-2", 5), 0.1),
		hang_left = anim8.newAnimation(self.grid("1-2", 6), 0.1),
	}
	self.currentAnimation = self.animations["idle_right"]
	self.animationDirection = "right"
	self.hasMoved = false

	collisionWorld:add(self, self.x, self.y, self.width, self.height)
end

function player:update(dt)
	self:control(dt)
	self:physics(dt)
	self:handleAnimations(dt)
	self:handleOffset()
end

function player:draw()
	love.graphics.setColor(1,1,1)
	self.currentAnimation:draw(self.sheet, self.drawX-5, self.drawY, 0, 1.4, 1.4)
end




function player:control(dt)
	local isDown = love.keyboard.isDown

	if isDown("a") or isDown("left") then 
		self.x = self.x - self.speed*dt
		self.animationDirection = "left"
	end
	if isDown("d") or isDown("right") then 
		self.x = self.x + self.speed*dt
		self.animationDirection = "right"
	end

	if isDown("a") or isDown("left") or isDown("d") or isDown("right") then
		self.hasMoved = true
	else
		self.hasMoved = false
	end

	self.x = self.x + self.xvel * dt
	self.y = self.y + self.yvel * dt
end

function player:physics(dt)

	--Collision

	self.x, self.y, cols, len = collisionWorld:move(self, self.x, self.y, playerFilter)

	if #cols > 0 then 
		self.xvel = 0
		for i,v in pairs(cols) do
			if v.normal.y == 1 then  -- Hit environment
				self.yvel = 0
			elseif v.normal.y == -1 then 
				self.yvel = 0
				self.canJump = true
			end

			if v.normal.x == 1 or v.normal.x == -1 then
				self.canWallJump = true
				self.wallJumpDirection = v.normal.x
			else
				self.canWallJump = false
			end


			if v.other.type == "feather" then -- Hit other objects
				v.other:destroy()
				featherSound:play()
				if self.feathers >= 4 then 
					love.system.openURL("https://www.youtube.com/watch?v=_EO43T07Xcg")
				end
			elseif v.other.type == "enemy" then
				self.x = 6804
				self.y = 7000
				deathSound:play()
				collisionWorld:update(self, self.x, self.y)
			end
		end

	else
		self.canJump = false
		self.canWallJump = false
	end

	--Gravity
	self.yvel = self.yvel + self.gravity*dt


	if self.xvel > 0 then -- Air friction
		self.xvel = self.xvel - 1000*dt
	elseif self.xvel < 0 then 
		self.xvel = self.xvel + 1000*dt
	end

	--Fall out of world
	if self.y > 8000 then
		self.x = 6804
		self.y = 7000
		self.yvel = 0

		deathSound:play()

		collisionWorld:update(self, self.x, self.y)
	end
end


function player:keypressed(key)
	if key == "space" or key == "up" then 
		if self.canJump then 
			self.yvel = -550
			self.canJump = false
		elseif self.canWallJump then
			self.canWallJump = false
			self.yvel = -400
			self.xvel = 400*self.wallJumpDirection
		end
	end
end	

function player:handleAnimations(dt)
	if self.hasMoved then 
		self.currentAnimation = self.animations["run_"..self.animationDirection]
	else
		self.currentAnimation = self.animations["idle_"..self.animationDirection]
	end

	if self.canWallJump then 
		if self.wallJumpDirection == -1 then 
			self.animationDirection = "right"
		else
			self.animationDirection = "left"
		end
		self.currentAnimation = self.animations["hang_"..self.animationDirection]--..self.wallJumpDirection]
	end

	self.currentAnimation:update(dt)
end	

function player:handleOffset() -- This is dumb, I am tired, I dont care
	if self.currentAnimation == self.animations["idle_left"] then 
		self.drawX = self.x - 8
		self.drawY = self.y - 8
	elseif self.currentAnimation == self.animations["idle_right"] then
		self.drawX = self.x - 15
		self.drawY = self.y - 8
	elseif self.currentAnimation == self.animations["run_left"] then 
		self.drawX = self.x - 30
		self.drawY = self.y - 2
	elseif self.currentAnimation == self.animations["run_right"] then 
		self.drawX = self.x - 20
		self.drawY = self.y - 2
	elseif self.currentAnimation == self.animations["hang_left"] or self.currentAnimation == self.animations["hang_right"] then 
		self.drawX = self.x - 20
		self.drawY = self.y - 2
	end
end
