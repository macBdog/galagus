-- Starfield parameters
local numMenuStars = 64
local menuStars = {}
local menuFieldSizeX = 300
local menuFieldSizeY = 800
local menuFieldSizeZ = 256
local menuStarMinSpeed = 1.2
local menuStarMaxSpeed = 32
local menuStarRecycleDist = 256
local logoPosX = 0
local logoPosY = 32
local logoPosZ = 10

function MenuStarfieldStartup()
	-- Generate a field of stars
	for count = 1, numMenuStars do
		menuStars[count] = {}
		menuStars[count].gameObject = GameObject:Create("star", "menu")
		menuStars[count].gameObject:SetName("menuStar" .. count)
		menuStars[count].gameObject:SetPosition(math.random(-menuStarRecycleDist, menuStarRecycleDist), 
												math.random(-menuStarRecycleDist, menuStarRecycleDist), 
												math.random(-menuStarRecycleDist, menuStarRecycleDist))
		menuStars[count].gameObject:SetLifeTime(math.random(0, 16))
		menuStars[count].gameObject:SetSleeping()
		menuStars[count].dirX = math.random(-menuStarMaxSpeed, menuStarMaxSpeed)
		menuStars[count].dirY = math.random(-menuStarMaxSpeed, menuStarMaxSpeed)
		menuStars[count].dirZ = math.random(-menuStarMaxSpeed, menuStarMaxSpeed)

		-- Protect against a very slow moving star
		if math.abs(menuStars[count].dirX) + math.abs(menuStars[count].dirY) + math.abs(menuStars[count].dirZ) < menuStarMinSpeed then
			menuStars[count].dirX = menuStars[count].dirX + menuStarMinSpeed
			menuStars[count].dirZ = menuStars[count].dirZ + menuStarMinSpeed
		end
	end

	-- Make the stars regen inside the logo
	if logoObject then
		localPosX, logoPosY, logoPosZ = logoObject:GetPosition()
	end
end

function MenuStarfieldUpdate()
	-- Move the stars away from the logo
	local frameDelta = GetFrameDelta()
	for count = 1, numMenuStars do
		if menuStars[count].gameObject:IsSleeping() then
			menuStars[count].gameObject:SetActive()
		end
		
		local x,y,z = menuStars[count].gameObject:GetPosition()
		x = x + menuStars[count].dirX * frameDelta
		y = y + menuStars[count].dirY * frameDelta
		z = z + menuStars[count].dirZ * frameDelta
		
		-- Recycle the star position if it gets too far away
		local distance = math.sqrt(x*x + y*y + z*z)
		if distance > menuStarRecycleDist then
			x = logoPosX
			y = logoPosY
			z = logoPosZ
		end

		menuStars[count].gameObject:SetPosition(x,y,z)
	end
end

function MenuStarfieldShutdown()
	
end
