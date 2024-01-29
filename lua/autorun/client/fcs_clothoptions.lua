FCS.ClothOptionMenu = FCS.ClothOptionMenu or nil
FCS.ClothOptions = {}

function FCS.RemoveClothOptionMenu()
    if FCS.ClothOptionMenu then
        FCS.ClothOptionMenu:Remove()
        FCS.ClothOptionMenu = nil
    end
end

function FCS.CreateClothOptionMenu(ID)
    FCS.RemoveClothOptionMenu()

    local item = FCS.GetItem(ID)
    if not item or not item.Options then return end

    FCS.ClothOptionMenu = vgui.Create("DFrame")
    FCS.ClothOptionMenu:SetSize(300, 500)
    FCS.ClothOptionMenu:Center()
    FCS.ClothOptionMenu:MakePopup()
    FCS.ClothOptionMenu:SetTitle("Clothing Options")

    FCS.ClothOptions = {}

    if item.Options.Skins then
        local panel = vgui.Create("DPanel", FCS.ClothOptionMenu)
        panel:SetTall(48)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 8)

        local text = vgui.Create("DLabel", panel)
        text:DockMargin(16, 16, 16, 16)
        text:Dock(LEFT)
        text:SetText("Skin Option")
        text:SetFont("DermaDefaultBold")
        text:SetTextColor(color_black)
        text:SizeToContents()

        local cbox = vgui.Create("DComboBox", panel)
        cbox:DockMargin(16, 12, 16, 12)
        cbox:SetSortItems(false)
        cbox:SetWide(160)
        cbox:Dock(RIGHT)
        function cbox:OnSelect(index, value, data)
            FCS.ClothOptions.Skin = data
        end
        for k, v in pairs(item.Options.Skins) do
            cbox:AddChoice(v, k, k == (item.Skin or 0))
        end
    end

    if item.Options.Bodygroups then
        local panel = vgui.Create("DPanel", FCS.ClothOptionMenu)
        panel:SetTall(48)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 8)

        local text = vgui.Create("DLabel", panel)
        text:DockMargin(16, 16, 16, 16)
        text:Dock(LEFT)
        text:SetText("Variants")
        text:SetFont("DermaDefaultBold")
        text:SetTextColor(color_black)
        text:SizeToContents()

        local cbox = vgui.Create("DComboBox", panel)
        cbox:DockMargin(16, 12, 16, 12)
        cbox:SetWide(160)
        cbox:SetSortItems(false)
        cbox:Dock(RIGHT)
        function cbox:OnSelect(index, value, data)
            FCS.ClothOptions.Bodygroup = data
        end
        cbox:AddChoice("Default", 1, true)
    end

    if item.Options.Color then
        local panel = vgui.Create("DPanel", FCS.ClothOptionMenu)
        panel:SetTall(280)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 8)

        local text = vgui.Create("DLabel", panel)
        text:DockMargin(16, 8, 16, 8)
        text:Dock(TOP)
        text:SetText("Custom Color")
        text:SetFont("DermaDefaultBold")
        text:SetTextColor(color_black)
        text:SizeToContents()

        local mixer = vgui.Create("DColorMixer", panel)
        mixer:Dock(FILL)
        mixer:DockMargin(4, 0, 4, 4)
        mixer:SetAlphaBar(false)
        function mixer:ValueChanged(col)
            FCS.ClothOptions.Color = col
        end
    end

    local apply = vgui.Create("DButton", FCS.ClothOptionMenu)
    apply:SetTall(48)
    apply:DockMargin(16, 16, 16, 8)
    apply:Dock(BOTTOM)
    apply:SetText("Apply Changes")
    apply:SetFont("DermaDefaultBold")
    function apply:DoClick()
        net.Start("FCS_Option")
            net.WriteString(ID)
            if item.Options.Skins then
                net.WriteUInt(FCS.ClothOptions.Skin or 0, 6)
            end
            if item.Options.Bodygroups then
                net.WriteUInt(FCS.ClothOptions.Bodygroup or 0, 6)
            end
            if item.Options.Color then
                net.WriteColor(FCS.ClothOptions.Color or color_white)
            end
        net.SendToServer()
        LocalPlayer():EmitSound("garrysmod/content_downloaded.wav", 0, 100, 0.75, CHAN_STATIC)
        FCS.ClothOptionMenu:Close()
    end
end