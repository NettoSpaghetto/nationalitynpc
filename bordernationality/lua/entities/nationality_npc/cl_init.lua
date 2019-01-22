include('shared.lua')

surface.CreateFont('nationality_frame', {font = 'roboto', size = 19, weight = 500})

surface.CreateFont('nationality_header', {font = 'roboto', size = 30, weight = 350})

surface.CreateFont('nationality_little', {font = 'roboto', size =11, weight = 350})

surface.CreateFont('nationality_header_npc', {font = 'roboto', size = 50, weight = 500})

/*
---------------->
NPC Header Draw
---------------->
*/

local v = Vector()

function ENT:Draw()
    self:DrawModel()
    if self:GetPos():Distance( LocalPlayer():GetPos() ) < 2000 then
        local entityAngle = self:GetAngles()

        entityAngle:RotateAroundAxis( entityAngle:Forward(), 90)
        entityAngle:RotateAroundAxis( entityAngle:Right(), -90)

        v.z = math.sin( CurTime() ) * 50

        cam.Start3D2D(self:GetPos()+self:GetUp()*85,Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.075)
                surface.SetDrawColor( 55, 55, 55, 150 )
                surface.DrawRect( v.x - 255, ( v.z / 2 ) - 80, 125 * 4, 45 * 4 )
                surface.SetDrawColor( 55,55,55, 200 )
                surface.DrawRect( v.x - 250, ( v.z / 2 ) - 75, 122 * 4, 42.5 * 4 )

                draw.DrawText( "Nationality NPC", "nationality_header_npc", -10, ( v.z / 2 ) - 45, self.NPCColor, TEXT_ALIGN_CENTER)
                draw.DrawText( "Change your nationality here!", "nationality_header", -10, ( v.z / 2 ) + 40, self.NPCColor, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end

/*
--------------->
GUI
--------------->
*/

local blur = Material("pp/blurscreen")

local scrw, scrh = ScrW(), ScrH()

local surface = surface

local Color = Color

local LocalPlayer = LocalPlayer

local draw = draw

local vgui = vgui

local gui = gui

local white = Color(255,255,255)

local white2 = Color(240,240,240)

local la = Color(0,0,0,150)

surface.CreateFont('nationality_maintext', {font = 'roboto', size =18, weight = 350})

surface.CreateFont('nationality_bigtext', {font = 'roboto', size =60, weight = 350})

surface.CreateFont('nationality_mediumtext', {font = 'roboto', size =20, weight = 350})

local PLAYER = FindMetaTable("Player")

local function draw_blur( p, a, d )



	local x, y = p:LocalToScreen(0, 0)

	surface.SetDrawColor( 100, 100, 100 )

	surface.SetMaterial( blur )

	for i = 1, d do

	

		blur:SetFloat( "$blur", (i / d ) * ( a ) )

		blur:Recompute()

		render.UpdateScreenEffectTexture()

		surface.DrawTexturedRect( x * -1, y * -1, scrw, scrh )

		

	end

	

end

function PLAYER:OpenNationalityFrame()

	if IsValid(NationalityMenu) then NationalityMenu:Remove() end

	NationalityMenu = vgui.Create("DFrame")

    NationalityMenu:SetSize(450, 300)

    NationalityMenu:SetAlpha(0)

    NationalityMenu:AlphaTo(200, 0.1)

    NationalityMenu:Center()

    NationalityMenu:SetTitle("Nationality")

    NationalityMenu:ShowCloseButton(true)

    NationalityMenu:SetDraggable(false)

    NationalityMenu:MakePopup()

	

	local x,y = NationalityMenu:GetSize()

	

	local ButtonMexican = vgui.Create("DButton",NationalityMenu)

	ButtonMexican:SetSize(180, 125)

	ButtonMexican:SetPos(450/2+20, 120)

	ButtonMexican:SetText("")

	ButtonMexican.Paint = function(self,w,h) 

		draw.RoundedBox(0,0,0,1,h,Color(255,255,255,120))

		draw.RoundedBox(0,w-1,0,1,h,Color(255,255,255,120))

		draw.RoundedBox(0,0,0,w,1,Color(255,255,255,120))

		draw.RoundedBox(0,0,h-1,w,1,Color(255,255,255,120))

		draw.SimpleText( "MEXICAN", "nationality_mediumtext", w / 2  , h / 2  , Color(255,255,255), 1, 1 )

		

	end

	ButtonMexican.DoClick = function()

		net.Start("nation_button_click")
  
		net.WriteBool(true)

		net.SendToServer()

		NationalityMenu:Remove()

	end



	local ButtonAmerican = vgui.Create("DButton",NationalityMenu)

	ButtonAmerican:SetSize(180, 125)

	ButtonAmerican:SetPos(450/2-200, 120)

	ButtonAmerican:SetText("")

	ButtonAmerican.Paint = function(self,w,h) 

		draw.RoundedBox(0,0,0,1,h,Color(255,255,255,120))

		draw.RoundedBox(0,w-1,0,1,h,Color(255,255,255,120))

		draw.RoundedBox(0,0,0,w,1,Color(255,255,255,120))

		draw.RoundedBox(0,0,h-1,w,1,Color(255,255,255,120))

		draw.SimpleText( "AMERICAN", "nationality_mediumtext", w / 2  , h / 2  , Color(255,255,255), 1, 1 )

		

	end

	ButtonAmerican.DoClick = function()

		net.Start("nation_button_click")

		net.WriteBool(false)
  
		net.SendToServer()

		NationalityMenu:Remove()

	end

	NationalityMenu.Paint = function(self,w,h) 

		draw_blur( self, 1, 15 ) 

		surface.SetDrawColor(20,20,20)

		surface.DrawRect(0, 0, w, h)

		draw.RoundedBox(0,0,0,1,h,Color(255,255,255,120))

		draw.RoundedBox(0,w-1,0,1,h,Color(255,255,255,120))

		draw.RoundedBox(0,0,0,w,1,Color(255,255,255,120))

		draw.RoundedBox(0,0,h-1,w,1,Color(255,255,255,120))

		draw.DrawText( "Your nationality determines where you spawn and \n what side of the border you are allowed on!", "nationality_mediumtext", w/2, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)



	end

end

net.Receive( "nation_open_menu", function()
	LocalPlayer():OpenNationalityFrame()
end )

local nationnotify = {
	[0] = {"You are now American!", NOTIFY_GENERIC, "buttons/button15.wav"},
	[1] = {"You are now Mexican!", NOTIFY_GENERIC, "buttons/button15.wav"},
	[2] = {"You are already American!", NOTIFY_ERROR, "buttons/button8.wav"},
	[3] =  {"You are already Mexican!", NOTIFY_ERROR, "buttons/button8.wav"},
}

NATION_AM = 0
NATION_MEX = 1
local ply = LocalPlayer()

net.Receive( "nation_button_response", function()
	local nationalityuint = net.ReadUInt(4)
	notification.AddLegacy(nationnotify[nationalityuint][1], nationnotify[nationalityuint][2], 3)
	surface.PlaySound(nationnotify[nationalityuint][3])
end )
