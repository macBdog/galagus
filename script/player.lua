-- Player stats
local player = {}
local playerMoveSpeed = 68.0
local playerMoveMax = 60
local playerMaxLives = 3
local rollMax = 20.0
local rollSpeed = 199.0
local rollReturnSpeed = 84.0
local rollAmount = 0

-- Player shooting stats
local shots = {}
local maxShots = 2
local activeShot = 1
local shotSpeed = 512.0
local shotRecyclePosY = 512.0
local shotStartPosY = -200.0
local shootPressed = false
local scorePerEnemy = 100

playerStartPosX = 0.0
playerStartPosY = 65.0
playerStartPosZ = -25.0

function PlayerStartup()
	-- Create the player's ship
	player.health = 100
	player.score = 0
	player.lives = playerMaxLives
	player.gameObject = GameObject:Create("spaceFighter", "game")
	player.gameObject:SetName("player")
	player.gameObject:SetPosition(playerStartPosX, playerStartPosY, playerStartPosZ)
  	player.gameObject:AddToCollisionWorld()
	player.gameObject:SetSleeping()

	-- Create the two shots
	activeShot = 1
	for i = 1, maxShots do
		shots[i] = {}
		shots[i].ready	 = true
		shots[i].active = false
		shots[i].gameObject = GameObject:Create("missile", "game")
		shots[i].gameObject:SetName("playerMissile" .. i)
		shots[i].gameObject:SetPosition(0.0, shotStartPosY, 0.0)
		shots[i].id = shots[i].gameObject:GetId()
    shots[i].gameObject:AddToCollisionWorld();
	end
end

function PlayerBeginLife()
  player.gameObject:SetActive()
  player.gameObject:EnableCollision()
end

function PlayerUpdate()
	local frameDt = GetFrameDelta()
	local x,y,z = player.gameObject:GetPosition()

	-- Move the player if keys held down
	if IsKeyDown(keyCodes.Left) or IsKeyDown(keyCodes.A) then
		x = x - (playerMoveSpeed * frameDt)

		-- Apply yaw to maximum while steering
		rollAmount = rollAmount + (rollSpeed * frameDt)
		if rollAmount > rollMax then
			rollAmount = rollMax
		end
	end

	if IsKeyDown(keyCodes.Right) or IsKeyDown(keyCodes.D) then
		x  = x + (playerMoveSpeed * frameDt)

		-- Apply yaw to maximum while steering
		rollAmount = rollAmount - (rollSpeed * frameDt)
		if rollAmount < -rollMax then
			rollAmount = -rollMax
		end
	end

	-- Limit the player's movement
	if x > playerMoveMax then x = playerMoveMax end
	if x < -playerMoveMax then x = -playerMoveMax end
	player.gameObject:SetPosition(x , y, z)

	-- Roll the player ship and tend the roll to zero
	player.gameObject:SetRotation(0, rollAmount, 0)
	local rollEpsilon = 0.5
	if math.abs(rollAmount) > rollEpsilon then
		if rollAmount > 0 then
			rollAmount = rollAmount - rollReturnSpeed * frameDt;
		else
			rollAmount = rollAmount + rollReturnSpeed * frameDt;
		end
	end

	-- TODO Apply a floating sinewave offset to the player

	-- Shoot if there is a shot available
	if shots[activeShot].ready and IsKeyDown(keyCodes.Space) and shootPressed == false then
		shots[activeShot].gameObject:SetPosition(x, y, z)
		shots[activeShot].ready = false
		shots[activeShot].active = true
		shots[activeShot].gameObject:EnableCollision();
		shootPressed = true

		-- Advance to next shot
		if activeShot < maxShots then
			activeShot = activeShot + 1
		elseif shots[1].ready then
			activeShot = 1
		end
	end

	-- Move shots through space
	for i = 1, maxShots do 
		if shots[i].active then
			local sX,sY,sZ = shots[i].gameObject:GetPosition() 
			shots[i].gameObject:SetPosition(sX, sY + (frameDt * shotSpeed), sZ)

			-- Test shot collision
			local shotDestroyed = false
			local shotCollisions = shots[i].gameObject:GetCollisions()
			for colCount = 1, #shotCollisions do
				local gameObj = shotCollisions[colCount]
				EnemyDestroy(gameObj)
				player.score = player.score + scorePerEnemy
				shotDestroyed = true
			end

			-- Destroy shots that have gone too far
			if sY > shotRecyclePosY then
				shotDestroyed = true
			end

			-- Recycle shots
			if shotDestroyed == true then
				shots[i].active = false
				shots[i].ready = true
				shots[i].gameObject:SetPosition(0.0, shotStartPosY, 0.0)
        		shots[i].gameObject:DisableCollision();
			end
		end
	end

	-- Reset shoot key on release
	if not IsKeyDown(keyCodes.Space) then shootPressed = false end
end

function PlayerGetScore()
	return player.score or 0
end

function PlayerGetLives()
	return math.max(player.lives, 0)
end

function PlayerGetLifetime()
	return player.gameObject:GetLifeTime()
end

function PlayerGet()
	return player
end

function PlayerDestroy()
	ExplosionPlayer(player.gameObject:GetPosition())
	player.lives = player.lives - 1
  	player.gameObject:DisableCollision()
  	player.gameObject:SetSleeping()
  	GameplayDeathState()
end