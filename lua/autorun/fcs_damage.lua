FCS_DMGDIR_UNKNOWN = 0
FCS_DMGDIR_FRONT = 1
FCS_DMGDIR_SIDE = 2
FCS_DMGDIR_BACK = 4
FCS_DMGDIR_TOP = 8

FCS_DMGDIR_ALL = FCS_DMGDIR_FRONT + FCS_DMGDIR_SIDE + FCS_DMGDIR_BACK + FCS_DMGDIR_TOP

function FCS.GetHeadDamageDirection(ply, dmginfo)
    local p = ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_Head1")):GetTranslation()
    local v = dmginfo:GetDamagePosition()

    local dir = (p - v):GetNormalized()

    local dot1 = dir:Dot(Vector(0, 0, -1))
    local dot2 = dir:Dot(-ply:GetForward())
    -- print(math.Round(dot1, 3), math.Round(dot2, 3))

    if dot1 > 0.3 then
        return FCS_DMGDIR_TOP
    end

    if dot2 > 0.707 then
        return FCS_DMGDIR_FRONT
    elseif dot2 < 0 then
        return FCS_DMGDIR_BACK
    else
        return FCS_DMGDIR_SIDE
    end

    return FCS_DMGDIR_UNKNOWN
end

hook.Add("HandlePlayerArmorReduction", "FCS_Armor", function(ply, dmginfo)
    local hitgroup = ply:LastHitGroup()

    local ent, areas = ply:FCSGetArmorAreas(hitgroup)

    if IsValid(ent) then
        local dir = FCS.GetHeadDamageDirection(ply, dmginfo)
        if areas == true or bit.band(areas, dir) ~= 0 then
            -- print("Blocked", ply, ent:GetID(), dir)

            local eff = EffectData()
            eff:SetOrigin(dmginfo:GetDamagePosition())
            eff:SetNormal((dmginfo:GetDamageForce() * -1):GetNormalized())
            util.Effect("MetalSpark", eff)
        end
    end
end)