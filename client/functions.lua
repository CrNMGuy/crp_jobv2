---- Librairie de fonctions
-- auteur : Florian__#4413 (D)


-- Détection du contexte
serverSide = false
clientSide = false

if IsDuplicityVersion()  then
    serverSide = true
else
    clientSide = true
end

function string:padstart(len, str)
	str = str or " "
	local selflen = self:len()
	return (str:rep(math.ceil((len - selflen) / str:len()))..self):sub(-(selflen < len and len or selflen))
end


function spawnProp(_model, _pos, _heading, blipobj)
        
    local pedId = 0 
    local spawnTry = 0

    if clientSide then
        -- spawn coté client
        while not HasModelLoaded(_model) do
            RequestModel(_model)
            Wait(0)                 -- Attends la prochaine frame
        end

        -- ground,posZ = GetGroundZFor_3dCoord(_pos.x +.0,_pos.y+.0, _pos.z + 999.0, 1 )--set Z pos as on ground

        while pedId == 0 and spawnTry < 5 do
            
            pedId = CreateObjectNoOffset(_model, _pos.x, _pos.y, _pos.z, true, false, true)
            spawnTry += 1

            Wait(0)                 -- Attends la prochaine frame

        end
    else
        -- spawn coté server
        pedId = CreateObjectNoOffset(_model, _pos.x, _pos.y, _pos.z, true, false, true)
    end

    
    local blip

    if pedId > 0 then 
        
        FreezeEntityPosition(pedId,true)
       
        if clientSide then
            -- client side
            PlaceObjectOnGroundProperly(pedId)
        else
            -- server side
        end

        -- blip sur entité
        blip = AddBlipForEntity(pedId)
        setupBlip(blip, blipobj)

        printConsole ("    Spawn d'un prop ".. _model, "  >> Succès   pedId=" .. pedId .. " blip=" .. blip)
    else
        printConsole ("    Spawn d'un prop ".. _model, "  >> Erreur   ")
    end

    return pedId, blip
    
end


function spawnPed(obj, _pos, _heading, objBlip)

    --obj = checkCfgData(obj)
    
    local pedId = 0 
    local spawnTry = 0

    local isNetworked = true
    if cNV(obj, "Mode") == "nil" then 
        obj.Mode = "net"
    elseif cNV(obj, "Mode", "value") == "local"  then
        isNetworked = false
    end


    -- print ("      spawnPed() ".. tostring(obj.Model).."  mode="..tostring(obj.Mode))

    local posZ


    if clientSide then
        -- spawn coté client
        while not HasModelLoaded(obj.Model) do
            RequestModel(obj.Model)
            Wait(0)                 -- Attends la prochaine frame
        end
    
        if cNV(obj, "GetGroundZFor_3dCoord", "value") == true then
            _,posZ = GetGroundZFor_3dCoord(_pos.x +.0,_pos.y+.0, _pos.z + 999.0, true )
        else
            _,posZ = GetGroundZFor_3dCoord(_pos.x +.0,_pos.y+.0, _pos.z, true ) 
        end


        while pedId == 0 and spawnTry < 5 do

            pedId = CreatePed(1, obj.Model, _pos.x, _pos.y, posZ, _heading , isNetworked, true)
            spawnTry += 1

            Wait(0)                 -- Attends la prochaine frame

        end
    else
        -- spawn coté server
        pedId = CreatePed(1, obj.Model, _pos.x, _pos.y, _pos.z, _heading , true, true)
    end

    
    local blip

    if pedId > 0 then 
        FreezeEntityPosition(pedId, true)

        SetPedConfigFlag(pedId, 17  , true)      -- CPED_CONFIG_FLAG_BlockNonTemporaryEvents 
        SetPedConfigFlag(pedId, 188 , true)      -- CPED_CONFIG_FLAG_DisableHurt 
        SetPedConfigFlag(pedId, 208 , true)      -- CPED_CONFIG_FLAG_DisableExplosionReactions 
        SetPedConfigFlag(pedId, 294 , true)      -- CPED_CONFIG_FLAG_DisableShockingEvents 
        SetPedConfigFlag(pedId, 2   , true)      -- CPED_CONFIG_FLAG_NoCriticalHits 
        SetPedConfigFlag(pedId, 33  , true)      -- CPED_CONFIG_FLAG_DieWhenRagdoll  
        SetPedConfigFlag(pedId, 42  , true)      -- CPED_CONFIG_FLAG_DontInfluenceWantedLevel   
        SetPedConfigFlag(pedId, 43  , true)      -- CPED_CONFIG_FLAG_DisablePlayerLockon 
        SetPedConfigFlag(pedId, 107 , true)      -- CPED_CONFIG_FLAG_DontActivateRagdollFromBulletImpact
        SetPedConfigFlag(pedId, 128 , false)     -- CPED_CONFIG_FLAG_CanBeAgitated
        -- SetPedConfigFlag(pedId, 292 , true)      -- _CPED_CONFIG_FLAG_FreezePosition >> Fige le ped 
        SetPedConfigFlag(pedId, 318 , false)     -- CPED_CONFIG_FLAG_ActivateRagdollFromMinorPlayerContact
        SetPedConfigFlag(pedId, 456 , false)     -- CPED_CONFIG_FLAG_CanBeIncapacitated

        SetPedArmour(pedId, 100)
        SetPedCanRagdoll(pedId, false)

        SetPedRandomProps(pedId)
        SetPedRandomComponentVariation(pedId, 0)

        -- if type(obj.SetEntityHealth) == "number" then

        --     -- SetEntityHealth(pedId, obj.SetEntityHealth)
        --     SetPedCanRagdoll(pedId, true)
        --     SetPedRagdollForceFall(pedId)

        -- end

        if type(obj.TaskStartScenarioInPlace) == "string" then

            SetPedCanPlayInjuredAnims(pedId, true)
            TaskStartScenarioInPlace(pedId, obj.TaskStartScenarioInPlace, 0, true)

        end

        if clientSide then

            SetEntityInvincible(pedId, true)

            if type(objBlip) ~= "nil" then
                
                if cNV(objBlip, "AddBlipForEntity", "value") == true then
                    
                    -- blip sur entité
                    blip = AddBlipForEntity(pedId)
                    setupBlip(blip, objBlip)

                elseif cNV(objBlip, "AddBlipForCoord", "value") == true then
                    
                    -- blip sur position
                    blip = AddBlipForCoord(_pos.x, _pos.y, _pos.z)
                    setupBlip(blip, objBlip)

                end
            end
            
        else
            SetPlayerInvincible(pedId, true)
        end

        -- printConsole ("    Spawn d'un ped ".. tostring(obj.Model), "  >> ^2Succès^7   pedId=" .. tostring(pedId) .. " blip=" .. tostring(blip))
    else
        printConsole ("    Spawn d'un ped ".. tostring(obj.Model), "  >> ^1Erreur^7   ")
    end

    return pedId, blip
    
end

function deletePedServer(pedId)
    DeleteEntity(pedId)    
end

function tableLength(T)
    if type(T) ~= "table" then return nil end
    
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
  
function setupBlip (blip, obj)

    if type(obj) == "nil" then return end

    if type(obj.Icon) == "number" then                  SetBlipSprite(blip, obj.Icon) end

    if clientSide then 

        if type(obj.SetBlipAsFriendly) == "boolean" then    SetBlipAsFriendly(blip, obj.SetBlipAsFriendly) end
        if type(obj.SetBlipRoute) == "boolean" then         SetBlipRoute(blip, obj.SetBlipRoute) end
        if type(obj.SetBlipDisplay) == "number" then        SetBlipDisplay(blip, obj.SetBlipDisplay) end
        if type(obj.SetBlipAsShortRange) == "boolean" then  SetBlipAsShortRange(blip, obj.SetBlipAsShortRange) end
        if type(obj.SetBlipPriority) == "number" then       SetBlipPriority(blip, obj.SetBlipPriority) end
        if type(obj.SetBlipCategory) == "number" then       SetBlipCategory(blip, obj.SetBlipCategory) end
        if type(obj.SetBlipColor) == "number" then          SetBlipColor(blip, obj.SetBlipColor) end

       
        if type(obj.Name) == "string" then
            -- Ajout de " " pour mettre le blip en haut de la liste
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(" " .. obj.Name)
            EndTextCommandSetBlipName(blip)
        end
    
    end

end


function cleanMemory(obj)
    -- Nettoyage des pedId et Blip 
    for k, v in pairs(obj) do
        if k == "blip" then
            RemoveBlip(v)
        elseif k == "pedId" or k == "entity" then
            deletePed("fast", v, 0)
        elseif k == "propId" then
            deleteProp("fast", v)
        elseif k == "qTargetEntity" then
            exports.qtarget:RemoveTargetEntity(v)
        elseif k == "qTargetZone" then
            exports.qtarget:RemoveZone(v)          
        elseif k == "qTargetModel" then
            exports.qtarget:RemoveTargetModel(v)     
        elseif k == "PolyZone" then
            v:destroy()
        elseif type(v) == "table" then
            cleanMemory(v)
        end
    end

end



function randomPositionCercle (centrex, centrey, radius)
    local angle = math.random(0,360)
    local x = centrex + math.random(radius) * math.cos(angle)
    local y = centrey + math.random(radius) * math.sin(angle)

    return x, y
end


function randomPointInPolygon (poly)        
    -- poly = {{x1,y1},{x2,y2}, {xn,yn}}
    -- à vérifier : résultat correct avec les coordonnées de points négatives

    local xmin, xmax, ymin, ymax
    local posConcat = {}

    for i,v in ipairs(poly) do
        if xmin == nil or v[1] < xmin then xmin = v[1] end
        if xmax == nil or v[1] > xmax then xmax = v[1] end
        if ymin == nil or v[2] < ymin then ymin = v[2] end
        if ymax == nil or v[2] > ymax then ymax = v[2] end

        table.insert(posConcat, v[1])
        table.insert(posConcat, v[2])
    end

    
--    print ("bounds ", math.floor(xmin), math.floor(xmax), math.floor(ymin), math.floor(ymax))
    
    local i = 0
    local x, y = 99999,99999
    
    while not isPointInPolygon(x, y, posConcat)  do
        i+= 1  

        x = xmin + (math.random(math.floor(xmax) - math.ceil(xmin)))
        y = ymin + (math.random(math.floor(ymax) - math.ceil(ymin)))

        -- print ("Random pos : x="..x .. " y="..y .. "  test=".. tostring(isPointInPolygon(x, y, posConcat)))
    end

    -- print ("Position trouvée en "..i.." occurences en x="..x .. " y="..y )

    return x, y
end

function isPointInPolygon(x, y, ...)

    if type(x) == nil or type(y) == nil then 
        -- print("pas de x, y") 
        return false 
    end

    -- print ("type de ... = ", type(...))
    
    local poly = table.pack(...)
    if type(...) == "table" then
        poly = ...
    end
--     print("x,y=".. x .. "," .. y .. "  poly ", dump(poly))


    local x1, y1, x2, y2
    local len = #poly
    x2, y2 = poly[len - 1], poly[len]
    local wn = 0
    for idx = 1, len, 2 do
        x1, y1 = x2, y2
        x2, y2 = poly[idx], poly[idx + 1]

        if y1 > y then
            if (y2 <= y) and (x1 - x) * (y2 - y) < (x2 - x) * (y1 - y) then
            wn = wn + 1
            end
        else
            if (y2 > y) and (x1 - x) * (y2 - y) > (x2 - x) * (y1 - y) then
            wn = wn - 1
            end
        end
    end
    return wn % 2 ~= 0 
end


function weightedRandom(obj, index)
    local summ = 0

    -- print ("weightedRandom : n=" .. #obj .. " type(obj[1])=" .. type(obj[1]))
    if #obj <= 1 then return obj[1] end

    if type(obj[1]) == "table" then
        -- tableau de tableau

        -- Normalisation du Poids des objets
        for i, v in ipairs(obj) do
            if type(v[index]) == "number" then
                summ += v[index]
            else
                obj[i][index] = 1
            end
        end

        summ = 0
        -- Second tour 
        for i, v in ipairs(obj) do
            summ += v[index]
        end
        
        local rnd = math.random(summ)
        
        summ = 0
        for i, v in ipairs(obj) do
            summ += v[index]
            if rnd <= summ then 
                v[index] = nil      -- on supprime le Poids
                return v 
            end
        end
    else
        -- tableau de string, number...
        -- random simple sans poids

        return obj[math.random(#obj)]

    end
end




function checkDeepWhileTable(obj, path)
    if path == nil then path = "" end
    
    local ret = ""

    if type(obj) == "table" then   
        ret =  checkDeepWhileTable(obj[1]) .. ret
    end 

    if ret ~= "" then 
        ret = type(obj) .. "." .. ret 
    else
        ret = type(obj) .. ret 
    end

    return ret
end


checkCfgInitialisation = { 

    Points = {          
        -- debug = true,    
        niveauType = "table.vector2",
        methodCorrection = "weightedRandom", 
    },

    Polygone = {          
        -- debug = true,    
        niveauType = "table.table.number",
        methodCorrection = "weightedRandom", 
        next = "skip",
    },

    GoTo = {          
        -- debug = true,    
        pathRegex = "^Action.GoTo",
        niveauType = "table.nil",
        methodCorrection = "weightedRandom", 
    },

    _Source = {
        -- debug = true,    
        methodCorrection = "skip", 
    },

}



checkCfgCycle = { 

    _Source = {
        -- debug = true,    
        methodCorrection = "skip", 
    },

    Ped = {      
        -- debug = true,    
        niveauType = "table.nil",
        methodCorrection = "weightedRandom", 
    },

    Notification = {
        -- debug = true,    
        niveauType = "string",
        methodCorrection = "weightedRandom", 
    },

    Model = {
        {
            -- debug = true,    
            niveauType = "string",
            methodCorrection = "weightedRandom", 
        },
        {
            -- debug = true,    
            niveauType = "number",
            methodCorrection = "weightedRandom", 
        },
    },

    TaskStartScenarioInPlace = {
        -- debug = true,    
        niveauType = "string",
        methodCorrection = "weightedRandom", 
    },

    Qte = {      
        -- debug = true,    
        niveauType = "number",
        methodCorrection = "choixQte", 
    },

    Transaction = {      
        {
            -- debug = true,    
            methodCorrection = "follow", 
        },
    },

    Give = {      
        -- debug = true,    
        -- pathRegex = "Transaction%.%d*%.?Give",
        niveauType = "table.nil",
        methodCorrection = "weightedRandom", 
    },

    Remove = {      
        -- debug = true,    
        -- pathRegex = "Transaction%.%d*%.?Remove",
        niveauType = "table.nil",
        methodCorrection = "weightedRandom", 
    },

    GiveServer = {      
        -- debug = true,    
        -- pathRegex = "Transaction%.%d*%.?GiveServer",
        niveauType = "table.nil",
        methodCorrection = "weightedRandom", 
    },

    RemoveServer = {      
        -- debug = true,    
        -- pathRegex = "Transaction%.%d*%.?RemoveServer",
        niveauType = "table.nil",
        methodCorrection = "weightedRandom", 
    },

}



function checkCfgData (checkobj, obj, path)
    if path == nil then path = "" end
    
    -- contournement de l'accès au tableau passé en paramètre
    local objcopy = {}
    
    
    for k, v in pairs (obj) do
        objcopy[k] = v
        
        -- print (path .. k .. " (" .. type(v)..")")

        -- if type (v) == "table" then

        --     local countNamedObj = 0
        --     local countItems = 0
        --     for key, val in pairs(v) do
        --         countItems += 1
        --         if type(key) == "string" then
        --             countNamedObj += 1
        --         end
        --     end

        --     print ( "   " ..  countNamedObj .. "/" .. countItems .. " objets nommés ")

        -- end

        if type(checkobj[k]) == "table" then  
            
            if type(checkobj[k][1]) ~= "table" then  
                -- consigne unique, converti en multi
                checkobj[k] = {checkobj[k]}
            end

            

            for k2, checkCfgI in pairs (checkobj[k]) do

                local debug = false
                if checkCfgI.debug == true then debug = true end


                if debug then print (path .. k .. " (" .. type(v)..")") end


                local countErr = 0

                if countErr == 0 and type(checkCfgI.pathNotRegex) ~= "nil" then 
                    if string.find(path .. k, checkCfgI.pathNotRegex) == nil then
                        if debug then print ("   pathNotRegex PASS") end
                    else
                        if debug then print ("   pathNotRegex FAIL") end 
                        countErr += 1  
                    end
                end

                if countErr == 0 and type(checkCfgI.pathRegex) ~= "nil" then 
                    if string.find(path .. k, checkCfgI.pathRegex) ~= nil then
                        if debug then print ("   pathRegex PASS" ) end
                    else
                        if debug then print ("   pathRegex FAIL" ) end
                        countErr += 1  
                    end
                end

                if countErr == 0 and type(checkCfgI.niveauType) ~= "nil" then 
                    local pathtype = checkDeepWhileTable(v)

                    if pathtype == checkCfgI.niveauType then
                        if debug then print ("   niveauType ".. pathtype.. " PASSE") end
                        
                        if type(v) == "table" then
                            objcopy[k] = checkCfgData (checkobj, v, path..k .. ".")
                        end

                    elseif string.find(pathtype, "^(.+)".. checkCfgI.niveauType.."$") ~= nil then
                        -- La fin de pathtype est correct
                        if debug then  print ("   niveauType ".. pathtype.. " CORRIGE") end



                        if checkCfgI.methodCorrection == "weightedRandom" then
                            local prefixATraiter = string.sub(pathtype, 1, string.find(pathtype, "".. checkCfgI.niveauType.."$") - 1 )

                            for w in string.gmatch(prefixATraiter, "table") do
                                v = weightedRandom(v, "Poids")
                            end
                            
                            if type(v) == "table" and cNV(checkCfgI, "next", "value") ~= "skip" then
                                objcopy[k] = checkCfgData (checkobj, v, path..k .. ".")
                            else
                                objcopy[k] = v
                            end

                            if debug then  print("   methodCorrection = weightedRandom PASSE") end 
                        elseif checkCfgI.methodCorrection == "choixQte" then
                            if #v == 1 then 
                                objcopy[k] = v[1]
                            elseif #v == 2 then 
                                objcopy[k] = math.random(v[1], v[2])
                            else
                                objcopy[k] = v[math.random(#v)]
                            end
                            if debug then  print("   methodCorrection = choixQte PASSE") end 
                        
                        elseif checkCfgI.methodCorrection == "skip" then
                            -- skip la branche complète
                            if debug then  print("   methodCorrection = skip PASSE") end 
                        
                        elseif checkCfgI.methodCorrection == "follow" then
                            -- continue la branche
                            if debug then  print("   methodCorrection = follow PASSE") end 
    
                            objcopy[k] = checkCfgData (checkobj, v, path..k .. ".")
                        else    
                            if debug then  print ("   niveauType ".. pathtype.. " ECHEC (pas de méthode de correction)") end
                            countErr += 1  
                        end
                    else
                        if debug then print ("   niveauType ".. pathtype.. " ECHEC (expect ".. checkCfgI.niveauType .. ")") end
                        countErr += 1  
                    end


                elseif countErr == 0 and type(checkCfgI.methodCorrection) ~= "nil" then 
                    -- pas de niveauType mais methodCorrection

                    if checkCfgI.methodCorrection == "skip" then
                        -- skip la branche complète
                        if debug then  print("   methodCorrection = skip PASSE") end 
                    elseif checkCfgI.methodCorrection == "follow" then
                        -- continue la branche
                        if debug then  print("   methodCorrection = follow PASSE") end 

                        objcopy[k] = checkCfgData (checkobj, v, path..k .. ".")
                    end

                end

                if countErr == 0 then 
                    break 
                end
               
            end

            

        elseif type(v) == "table" then
            objcopy[k] = checkCfgData (checkobj, v, path..k .. ".")
        end

    end

    return objcopy 
end



function cNV (obj, path, ret)
    -- checkNestedValue : Controle sur le chemin existe dans l'objet
    -- ret = "type" | "value"
    
    local objtest = obj
    local paths = split(path, "\\.")

    -- print ("cNV ".. path .. " (".. #paths.. " dossiers)")

    for i, line in ipairs(paths) do
        -- print ("  Test Path ".. line .. "  type="..type(objtest[line]))
        if line ~= "" and type(objtest) == "table" then
                if type(objtest[line]) == "table" then
                    objtest = objtest[line]
                    if i == #paths then 
                        -- print ("  1 return i="..i .. "/" .. #paths .. " "..type(objtest))
                        
                        if ret == "value" then return objtest 
                        else return type(objtest) end

                    end
                elseif i == #paths then
                    -- print ("  2 return i="..i .. "/" .. #paths .. " "..type(objtest[line]))

                    if ret == "value" then return objtest[line] 
                    else return type(objtest[line]) end

                elseif type(objtest[line]) == "nil" then
                    -- print ("  3 return nil")

                    if ret == "value" then return nil 
                    else return "nil" end
                end
        else
            if ret == "value" then return nil 
            else return "nil" end
        end

    end

    if ret == "value" then return nil 
    else return "nil" end

end


function split(str, sep)
    str = str .. sep
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
       table.insert(result, each)
    end
    return result
 end


function regledetrois (val, min, max, outmin, outmax)
    return math.abs(((minmax(val, max, min) - max) / min) * (outmax - outmin))
end

function minmax(val, min, max)
    return math.min(math.max(val,min), max)
end

function firstvalid (index, ...)
    local args = table.pack(...)

    for i=1, #args do
        local v = args[i]

        if type(v) == "table" and i ~= #args then
            if type(v[index]) ~= "nil" then 
                return v[index] 
            end
        elseif type(v) ~= "nil" then
            return v
        end 
    end
end

function firstvalid2 (...)

    local args = table.pack(...)

    for i=1, #args do
        local v = args[i]

--        print (i .. "/".. #args .. " " ..  type(v))

        if type(v) ~= "nil" then
            return v
        elseif i == #args then
            return nil
        end 
        
    end

end

function exp_cond (cond, vrai, faux)
    if cond then 
        return vrai
    else
        return faux
    end
end




function dump(o, pos)

    -- return ESX.DumpTable(o)


    if not pos then pos = 0 end

    local indent = string.rep("  ", pos)

    if type(o) == 'table' then

        local s  =  "" 
        local _indent = indent

        local hasTable = false
        for k,v in pairs(o) do
            if type(v) == "table" then hasTable = true end
        end


        local sepobj 
        if #o <= 4 and pos > 0 and not hasTable then 
            sepobj = " "
            _indent = ""
        else
            sepobj = "\n"
        end
        
        s = s .. '{' .. sepobj

        for k,v in pairs(o) do

            --- Clé
            if type(k) == 'number' then 
                s = s .. _indent  .. "[" .. k .. "] = "
            else
                s = s .. _indent .. tostring(k) .. " = "
            end

            --- valeur
            if type(v) == "table" then
                
                s = s .. dump(v, pos+1 ) .. "," .. sepobj

            elseif type(v) == 'number' then
                s = s .. tostring(v) .. "," .. sepobj
            elseif type(v) == 'string' then
                s = s .. "\"" .. v .. "\"" .. "," .. sepobj
            else
                s = s .. tostring(v) .. "," .. sepobj           -- "(" .. type(v) .. ") " .. 
            end

        end

        if _indent ~= "" then _indent = string.rep("  ", pos-1) end
        s = s .. _indent .. '}'
        return s 

    elseif type(o) == 'number' then
        return tostring(o)
    elseif type(o) == 'string' then
        return "\"" .. o .. "\""
    else
        return tostring(o)          -- "(" .. type(o) .. ") " .. 
    end
end


function printConsole(...)
    if serverSide then
        local playerId = source
        local xPlayer = ESX.GetPlayerFromId(playerId)

        TriggerClientEvent(app..'printConsole', playerId, ...)
    else
        print (...)
    end
    
end

function formatNumber(num)
    local formatted = num
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
end

