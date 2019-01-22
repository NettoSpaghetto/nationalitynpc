AddCSLuaFile( "cl_init.lua" )

AddCSLuaFile( "shared.lua" )



include( "shared.lua" )



function ENT:Initialize()

	self:SetModel( "models/humans/Group01/male_03.mdl" )

	self:SetHullType( HULL_HUMAN )

	self:SetHullSizeNormal()

	self:SetNPCState( NPC_STATE_SCRIPT )

	self:SetSolid( SOLID_BBOX )

	self:CapabilitiesAdd( bit.bor( CAP_ANIMATEDFACE, CAP_TURN_HEAD ) )

	self:SetUseType( SIMPLE_USE )

	self:DropToFloor()

	

	self:SetMaxYawSpeed( 90 )	

end

util.AddNetworkString( "nation_open_menu" )

function ENT:OnTakeDamage()

	return false

end

function ENT:AcceptInput( name, activator, caller )					

	if name == "Use" and caller:IsPlayer() then
  
	  net.Start("nation_open_menu")
  
	  net.WriteEntity(self)
  
	  net.Send(caller)
  
	end
  
  end
