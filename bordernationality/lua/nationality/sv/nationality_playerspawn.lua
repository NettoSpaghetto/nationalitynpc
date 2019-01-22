NATION_AM = 0
NATION_MEX = 1
local americanSpawn = {
    Vector(-2178.396973, -852.222412, 46.445641),
    Vector(-2035.395630, -852.278931, 45.450115),
    Vector(-1898.510254, -852.332947, 47.652611),
    Vector(-1898.443115, -679.083862, 48.716255),
    Vector(-2042.164307, -679.027283, 48.226990),
    Vector(-2200.868164, -678.964661, 46.589111),
}
local mexicanSpawn = {
    Vector(385.474854, -1631.199463, 57.031250),
    Vector(384.724579, -1568.852783, 57.031250),
    Vector(383.935791, -1503.304688, 57.031250),
    Vector(624.017761, -1500.590210, 57.031250),
    Vector(624.592346, -1575.653076, 57.031250),
    Vector(625.166992, -1650.713013, 57.031250),
}

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
