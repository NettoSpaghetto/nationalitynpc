util.AddNetworkString( "nation_button_click" )
util.AddNetworkString("nation_button_response")

--American is 0
--Mexican is 1

local function Initialize()
	if not file.IsDir( "nationality", "DATA" ) then
		file.CreateDir( "nationality", "DATA" )
	end
end
hook.Add( "Initialize", "InitializeNationality", Initialize )
local function loadPlayer( ply )
	local userDataFile = "nationality/" ..  ply:SteamID64() .. ".txt"
	if !file.Exists( userDataFile, "DATA" ) then
		file.Write( userDataFile, "0" )
	end
end
hook.Add( "PlayerInitialSpawn", "LoadPlayerNationality", loadPlayer )

net.Receive( "nation_button_click", function( len, pl )
	local userDataFile = "nationality/" ..  pl:SteamID64() .. ".txt"
	local nationalitybool = net.ReadBool()
	if ( IsValid( pl ) and pl:IsPlayer() ) then
		if nationalitybool == true then
			if file.Read( userDataFile, "DATA" ) == "1" then 
				net.Start("nation_button_response")
				net.WriteUInt(3, 4)
				net.Send(pl)
			else 
				file.Write( userDataFile, NATION_MEX )
				net.Start("nation_button_response")
				net.WriteUInt(1, 4)
				net.Send(pl)
				pl:SetNWFloat("Nation", NATION_MEX)
				pl:Spawn()
			end
		elseif nationalitybool == false then
			if file.Read( userDataFile, "DATA" ) == "0" then 
				net.Start("nation_button_response")
				net.WriteUInt(2, 4)
				net.Send(pl)
			else 
				file.Write( userDataFile, NATION_AM )
				net.Start("nation_button_response")
				net.WriteUInt(0, 4)
				net.Send(pl)
				pl:SetNWFloat("Nation", NATION_AM)
				pl:Spawn()
			end
		end
	end
end )

