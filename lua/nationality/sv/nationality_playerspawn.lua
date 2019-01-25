NATION_AM = 0
NATION_MEX = 1
nation = nation or {}
nation.mex = nation.mex or {}
nation.am = nation.am or {}

local function addMexSpawn(ply)
	table.insert(nation.mex, {pos = ply:GetPos()})
end

local function addAmSpawn(ply)
	table.insert(nation.am, {pos = ply:GetPos()})
end

local function saveSpawns()
    file.Write("nationality/"..game.GetMap().."_mex.txt", util.TableToJSON(nation.mex))
    file.Write("nationality/"..game.GetMap().."_am.txt", util.TableToJSON(nation.am))
end

local function nationalitySpawn(ply)
    local userDataFile = "nationality/" ..  ply:SteamID64() .. ".txt" 
    local userDataContents = file.Read(userDataFile, "DATA")
    local mexicanSpawn = util.JSONToTable( "nationality/" .. game.GetMap() .. "_mex.txt" )
    local americanSpawn = util.JSONToTable( "nationality/" .. game.GetMap() .. "_am.txt" )

    if not file.Exists( "nationality/" .. game.GetMap() .. "_mex.txt", "DATA" ) then return end
    if not file.Exists( "nationality/" .. game.GetMap() .. "_am.txt", "DATA" ) then return end

    if ply:IsValid() and ply:IsPlayer() then
        ply:SetNWFloat("Nation", userDataContents)
    end
    if file.Exists( userDataFile, "DATA" ) then
        if ply:IsValid() and ply:IsPlayer() then
            if tonumber(userDataContents, 2)  == NATION_MEX then
                timer.Simple(0.5, function() ply:SetPos( mexicanSpawn[math.random( table.Count( mexicanSpawn ) ) ] ) end )
            else
                timer.Simple(0.5, function() ply:SetPos( americanSpawn[math.random( table.Count( americanSpawn ) ) ] ) end )
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
	if string.sub(string.lower(text), 1, 12) == "/addmexspawn" then
		if ply:IsSuperAdmin() then
			addMexSpawn(ply)
			ply:ChatPrint("A Mexican spawn has been added for the map "..game.GetMap().."!")
		else
			ply:ChatPrint("You do not have permission to perform this action.")
		end
        return ""
	end
	if string.sub(string.lower(text), 1, 11) == "/addamspawn" then
		if ply:IsSuperAdmin() then
			addAmSpawn(ply)
			ply:ChatPrint("An American spawn has been added for the map "..game.GetMap().."!")
		else
			ply:ChatPrint("You do not have permission to perform this action.")
		end
        return ""
	end
	if string.sub(string.lower(text), 1, 14) == "/savenatspawns" then
		if ply:IsSuperAdmin() then
			saveSpawns()
			ply:ChatPrint("You have successfully saved spawns for the map "..game.GetMap().."!")
		else
			ply:ChatPrint("You do not have permission to perform this action.")
		end
        return ""
	end
end)

