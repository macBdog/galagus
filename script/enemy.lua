local enemySpawnTime = 2.0										-- How long it takes an enemy to move from it's spawn pos to it's home pos
local enemyDeathTime = 1.0										-- How long it takes an enemy to die

local enemyGridSizeX = 10
local enemyGridSizeY = 5
local numEnemies = enemyGridSizeX * enemyGridSizeY

local cellHeight = 20											-- How close each enemy is to the next space on the grid
local cellWidth = 13

local enemyGridStartX = -enemyGridSizeX * (cellWidth-1) * 0.5	-- Starting position of the enemy grid
local enemyGridStartY = playerStartPosY + 50
local enemyGridStartZ = playerStartPosZ

local enemySpawnPosLeftX = -100.0								-- Where the enemies start spawning left of screen
local enemySpawnPosLeftY = 0.0
local enemySpawnPosLeftZ = playerStartPosZ + 100

local enemySpawnPosRightX = 100.0								-- Where the enemies start spawning right of screen
local enemySpawnPosRightY = 0.0
local enemySpawnPosRightZ = playerStartPosZ + 100

local enemies = {}

local shots = {}
local maxShots = 8
local shotSpeed = 72.0											-- How fast enemy shots move towards the player
local shotRecyclePosY = -20.0									-- How far the enemy shots need to get behind the player before they are recycled

function EnemyStartup()
	-- Create as many enemies as there are grid spaces
	local celPosX = enemyGridStartX
	local celPosY = enemyGridStartY
	for i = 1, numEnemies do 

		-- Determine row and column
		if (i - 1) % enemyGridSizeX == 0 then
			celPosY = celPosY + cellHeight
			celPosX = enemyGridStartX
		else
			celPosX = celPosX + cellWidth
		end
		
		-- Set initial properties
		enemies[i] = {}
		enemies[i].life = 0.0
		enemies[i].active = false
		enemies[i].spawned = false
		enemies[i].dead = false
		enemies[i].timeOfDeath = 0.0
		enemies[i].fireTimer = 0.0
		enemies[i].fireRate = 0.0

		-- First two rows are bees, the rest are bugs (ships to come later)
		if i < enemyGridSizeX * 2 then
			enemies[i].gameObject = GameObject:Create("enemyBee", "game")
		else
			enemies[i].gameObject = GameObject:Create("enemyBug", "game")
		end
		enemies[i].gameObject:SetName("enemy" .. i)
		enemies[i].gameObject:SetSleeping()
		enemies[i].id = enemies[i].gameObject:GetId()
		
		-- Set home pos
		enemies[i].homePosX = celPosX
		enemies[i].homePosY = celPosY
		enemies[i].homePosZ = enemyGridStartZ
		
		-- Set alternating spawn pos
		if i % 2 == 0 then
			enemies[i].spawnPosX = enemySpawnPosLeftX
			enemies[i].spawnPosY = enemySpawnPosLeftY
			enemies[i].spawnPosZ = enemySpawnPosLeftZ
		else
			enemies[i].spawnPosX = enemySpawnPosRightX
			enemies[i].spawnPosY = enemySpawnPosRightY
			enemies[i].spawnPosZ = enemySpawnPosRightZ
		end
		
		enemies[i].gameObject:SetPosition(enemies[i].spawnPosX, enemies[i].spawnPosY, enemies[i].spawnPosZ)
	end

	-- Create the enemy shots
	for i = 1, maxShots do
		shots[i] = {}
		shots[i].gameObject = nil
	end
end

function EnemyLerpHome(enemyTable)
	-- Lerp from spawn pos to home spot on the grid
	local pctHome = enemyTable.life / enemySpawnTime
	local newPosX = enemyTable.spawnPosX + ((enemyTable.homePosX - enemyTable.spawnPosX) * pctHome)
	local newPosY = enemyTable.spawnPosY + ((enemyTable.homePosY - enemyTable.spawnPosY) * pctHome)
	local newPosZ = enemyTable.spawnPosZ + ((enemyTable.homePosZ - enemyTable.spawnPosZ) * pctHome)
	return newPosX, newPosY, newPosZ
end

function EnemyUpdate()
	local frameDt = GetFrameDelta()
	local lerpFactor = ((1 + math.sin(PlayerGetLifetime()*1.5)) * 0.5) * 30.0

	-- Spawn enemies and move them
	for i = 1, numEnemies do 
		if enemies[i].active then

			-- Tic enemy life
			enemies[i].life = enemies[i].life + frameDt

			-- And fire timer if applicable
			if enemies[i].fireRate > 0.0 and enemies[i].fireTimer >= enemies[i].fireRate then
				EnemyFire(enemies[i])
				enemies[i].fireTimer = 0.0
			else
				enemies[i].fireTimer = enemies[i].fireTimer + frameDt
			end

			-- Move enemy towards it's life or death
			local newPosX, newPosY, newPosZ = 0

			-- Pulsate enemies forth and back on the horizontal
			local rowFrac = (i-1) % enemyGridSizeX
			local enemyLerpX = lerpFactor
			local halfGridSizeX =  enemyGridSizeX / 2
			if rowFrac < halfGridSizeX then
				--enemyLerpX = -(lerpFactor * ((halfGridSizeX - rowFrac) / halfGridSizeX))
			else
				--enemyLerpX = ((1 - lerpFactor) * ((halfGridSizeX - rowFrac) / halfGridSizeX))
			end

			if enemies[i].life <= enemySpawnTime then
				newPosX, newPosY, newPosZ = EnemyLerpHome(enemies[i])
				newPosX = newPosX + enemyLerpX
			else
				-- Or send it to it's home spot on the grid
				newPosX = enemies[i].homePosX + enemyLerpX
				newPosY = enemies[i].homePosY
				newPosZ = enemies[i].homePosZ				
			end

			enemies[i].gameObject:SetPosition(newPosX, newPosY, newPosZ)
		end
	end

	-- Move enemy shots through space
	for i = 1, maxShots do 
		if shots[i].gameObject and shots[i].gameObject:IsActive() then
			local sX,sY,sZ = shots[i].gameObject:GetPosition()
			shots[i].gameObject:SetPosition(sX, sY - (frameDt * shotSpeed), sZ)

			-- TODO lerp shots towards player with a factor of hardness
			--local targetPosX, targetPosY, targetPosZ = GameplayGetHardness() * 

			-- Test shot collision
			local shotDestroyed = false
			local shotCollisions = shots[i].gameObject:GetCollisions()
			for colCount = 1, #shotCollisions do
				local gameObj = shotCollisions[colCount]
				shotDestroyed = true
				PlayerDestroy()
			end

			-- Destroy shots that have gone too far
			if sY < shotRecyclePosY then
				shotDestroyed = true
			end

			-- Recycle shots
			if shotDestroyed == true then
				shots[i].gameObject:SetSleeping()
        shots[i].gameObject:DisableCollision()
			end
		end
	end
end

function EnemyDestroy(gameObject)
	local gameObjectId = gameObject:GetId()

	local foundEnemy = -1
	for i = 1, numEnemies do 
		if 	enemies[i].active == true and 
			enemies[i].spawned == true and 
			enemies[i].id == gameObjectId and
			foundEnemy == -1 then
			foundEnemy = i
		end
	end

	if foundEnemy ~= -1 then
		enemies[foundEnemy].dead = true
		enemies[foundEnemy].active = false
		enemies[foundEnemy].gameObject:SetSleeping()
		enemies[foundEnemy].timeOfDeath = enemies[foundEnemy].life
		enemies[foundEnemy].deadPosX, enemies[foundEnemy].deadPosY, enemies[foundEnemy].deadPosZ = enemies[foundEnemy].gameObject:GetPosition()
	
		-- Explosion to show the player the enemy is dead
		ExplosionEnemy(enemies[foundEnemy].deadPosX, enemies[foundEnemy].deadPosY, enemies[foundEnemy].deadPosZ)
	end
end

function EnemySpawn(homePositionId, fireRateMin, fireRateMax)
	if enemies[homePositionId].active == false and enemies[homePositionId].spawned == false then
		enemies[homePositionId].active = true
		enemies[homePositionId].spawned = true
		enemies[homePositionId].gameObject:SetActive()
		enemies[homePositionId].gameObject:AddToCollisionWorld()
		
		-- Set fire rate and randomise starting timer
		enemies[homePositionId].fireRate = fireRateMin + math.random(0, fireRateMax - fireRateMin)
		enemies[homePositionId].fireTimer = math.random(0, enemies[homePositionId].fireRate)
	end
end

function EnemyFire(enemyTable)
	for i = 1, #shots do
		local foundNewShot = false
		if shots[i].gameObject == nil then
			shots[i].gameObject = GameObject:Create("enemyMissile", "game")
      shots[i].gameObject:AddToCollisionWorld()
			foundNewShot = true
		elseif shots[i].gameObject:IsSleeping() then
			shots[i].gameObject:SetActive()
      shots[i].gameObject:EnableCollision()
			foundNewShot = true
		end

		if foundNewShot then
			local enemyPosX, enemyPosY, enemyPosZ = enemyTable.gameObject:GetPosition()	
			shots[i].gameObject:SetName("enemyMissile" .. i)
			shots[i].targetPosX, shots[i].targetPosY, shots[i].targetPosZ = PlayerGet().gameObject:GetPosition()
			shots[i].gameObject:SetPosition(enemyPosX, enemyPosY, enemyPosZ)  
      break
		end
	end
end