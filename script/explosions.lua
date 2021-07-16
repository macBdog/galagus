-- Explosion parameters
local maxExplosions = 8
local explosions = {}
local explosionSizeStart = 0.5
local explosionLifeTime = 0.8
local explosionLife = 1.0

function ExplosionsStartup()
	for i = 1, maxExplosions do 
		explosions[i] = {}
		explosions[i].active = false
		explosions[i].gameObject = nil
	end
end

function ExplosionsUpdate()
	-- Update the explosions scale in chorus with its lifetime
	for i = 1, #explosions do
		if explosions[i].active == true then
			local curLife = explosions[i].gameObject:GetLifeTime()

			-- Scale explosion by a factor of it's short, sad life
			local curScale = 0.2 + (curLife * 2)
			explosions[i].gameObject:ResetScale()
			explosions[i].gameObject:SetScale(curScale, curScale, curScale)

			-- End the explosion
			if curLife >= explosionLifeTime then
				explosions[i].active = false
				explosions[i].gameObject:Destroy()
				explosions[i].gameObject = nil
			end
		end
	end
end

function ExplosionEnemy(posX, posY, posZ)
	for i = 1, #explosions do
		if explosions[i].active == false then
			explosions[i].active = true
			explosions[i].gameObject = GameObject:Create("enemyExplosion")
			explosions[i].gameObject:SetName("explosion" .. i)
			explosions[i].gameObject:SetPosition(posX, posY, posZ)
			explosions[i].gameObject:SetScale(explosionSizeStart, explosionSizeStart, explosionSizeStart)
			explosions[i].gameObject:ResetScale()
			break
		end
	end
end

function ExplosionPlayer(posX, posY, posZ)
	for i = 1, #explosions do
		if explosions[i].active == false then
			explosions[i].active = true
			explosions[i].gameObject = GameObject:Create("playerExplosion")
			explosions[i].gameObject:SetName("explosion" .. i)
			explosions[i].gameObject:SetPosition(posX, posY, posZ)
			explosions[i].gameObject:SetScale(explosionSizeStart, explosionSizeStart, explosionSizeStart)
			break
		end
	end
end

