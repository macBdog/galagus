-- Starfield parameters
local numStars = 16
local stars = {}
local fieldSizeX = 300
local fieldSizeY = 800
local fieldSizeZ = 256
local starMaxSpeed = 1024
local starRecyclePosY = -10

function StarfieldStartup()
	-- Generate a field of stars around the player
	for count = 1, numStars do
		stars[count] = {}
		stars[count].speed = math.random(starMaxSpeed * 0.1, starMaxSpeed)
		stars[count].gameObject = GameObject:Create("star", "game")
		stars[count].gameObject:SetName("star" .. count)
		stars[count].gameObject:SetPosition(math.random(-fieldSizeX, fieldSizeX), math.random(10, fieldSizeY), math.random(-fieldSizeZ, fieldSizeZ))
		stars[count].gameObject:SetLifeTime(math.random(0, numStars))
		stars[count].gameObject:SetSleeping()
	end
end

function StarfieldUpdate()
	-- Move the stars passed the player
	for count = 1, numStars do
		if stars[count].gameObject:IsSleeping() then
			stars[count].gameObject:SetActive()
		end
		
		local x,y,z = stars[count].gameObject:GetPosition()
		y = y - (stars[count].speed * GetFrameDelta())

		-- Recycle the star position after it's behind the player
		if y < starRecyclePosY then
			y = fieldSizeY
		end

		stars[count].gameObject:SetPosition(x,y,z)
	end
end

function StarfieldShutdown()
	
end
