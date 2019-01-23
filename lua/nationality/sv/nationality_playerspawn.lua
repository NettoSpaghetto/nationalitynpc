NATION_AM = 0
NATION_MEX = 1
local nation = {}

local function SaveNationSpawns()
end

local function nationalitySpawn(ply)
    local userDataFile = "nationality/" ..  ply:SteamID64() .. ".txt" 
    local userDataContents = file.Read(userDataFile, "DATA")
    if ply:IsValid() and ply:IsPlayer() then
        ply:SetNWFloat("Nation", userDataContents)
    end
    if file.Exists( userDataFile, "DATA" ) then
        if ply:IsValid() and ply:IsPlayer() then
            if tonumber(userDataContents, 2)  == NATION_MEX then
                timer.Simple(0.5, function() ply:SetPos( mexicanSpawn[math.random(#mexicanSpawn)] ) end )
            else
                timer.Simple(0.5, function() ply:SetPos( americanSpawn[math.random(#americanSpawn)] ) end )
            end
        end
    end
end

hook.Add("PlayerInitialSpawn", "NationalityCheck", nationalitySpawn)

local function spawnOnRightSide(ply)
    if ply:IsValid() then
        if ply:GetNWFloat("Nation", NATION_MEX) == NATION_MEX then
            timer.Simple(0.2, function() ply:SetPos( mexicanSpawn[math.random(#mexicanSpawn)] ) end )
        elseif ply:GetNWFloat("Nation", NATION_AM) == NATION_AM then
            timer.Simple(0.2, function() ply:SetPos( americanSpawn[math.random(#americanSpawn)] ) end )
        end
    end
end

hook.Add("PlayerSpawn", "NationalitySpawnOnRightSide", spawnOnRightSide)

--Handle saving and loading of slots
hook.Add("PlayerSay", "HandleBDONCommands" , function(ply, text)
	if string.sub(string.lower(text), 1, 12) == "/addspawnmex" then
		if table.HasValue(BDON_CONFIG.AdminRanks, ply:GetUserGroup()) then
			SaveDoubleOrNothingSlots()
			ply:ChatPrint("Double Or Nothing Slot Machines have been saved for the map "..game.GetMap().."!")
		else
			ply:ChatPrint("You do not have permission to perform this action, please contact an admin.")
		end
	end
end)

