---- CRP_JOBV2
-- auteur : Florian__#4413 (D)



local activePolyZone = {}
local cfgJob = nil
local l = {}        -- objet local de stockage des variables spécifiques au service
local Statut = {}   -- consignation des initialisations pour debug

local serverDEV = GetConvar("serverDEV", "")
local modeleTable = {}
-- local pedServerSide = nil
local pedPermanent = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)
    

-- Function de démarrage
AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end

    --- Chargement de ESX
    while ESX.PlayerLoaded ~= true do Wait(0) end

    --- Chargement des ped permanents, meme si non employé
    initPermanentPublic()

    
    --- Chargement de la suite
    initModel()                                 -- Force le chargement des models généré coté client
    initJob()       
end)

function initPermanentPublic()
    
    detectPermanent(Config)
    
    for k, v in pairs(pedPermanent) do

        -- print ("^5initPermanentPublic()^7 Spawn Permanent Public       ^3"..k .. "^7 localId="..tostring(cNV (v, "localId", "value")))

        if cNV (v, "localId") == "nil" 
           and (cNV (v, "Spawn.Ped.Mode", "value") == "local" or cNV (v, "Spawn.Ped.Mode", "value") == "net")  then

            pedPermanent[k].localId, _ = spawnPed(v.Spawn.Ped, v.Spawn.Pos, v.Spawn.Heading, nil)

            -- print ("      localId="..tostring(pedPermanent[k].localId))
        end
    end
    
end


function detectPermanent(obj)
    
    for k, v in pairs(obj) do
        if k == "Permanent" then
            for _, w in pairs(v) do
                if cNV (w, "Spawn.idInterne") then
                    pedPermanent[w.Spawn.idInterne] = w
                end
            end
        elseif type(v) == "table" then
            detectPermanent(v)
        end
    end

end

function initModel()
    
    -- Force le chargement des modèles
    detectPedModel (Config)
    local countTryLoad = 0


    local timerinitModel = ESX.SetTimeout(2000, function() 
        print('^3Warning :^1 initModel(): toujours en chargement des modèles')
    end)
    for _model, v in pairs(modeleTable) do
        -- print ("Modèle : " .. _model)

        while not HasModelLoaded(_model) do
            RequestModel(_model)
            countTryLoad += 1

            Wait(0)                 -- Attends la prochaine frame
        end
    end
    ESX.ClearTimeout(timerinitModel)

    -- print ("Fin de chargement de ".. #modeleTable .. " modèles, " .. countTryLoad+#modeleTable .. " essais. Démarrage du script")

end


function initPermanent()

    -- Gestion des ped permanents et de leurs actions
    if cNV(cfgJob, "Permanent") == "nil" then return end

    for k, v in pairs(cfgJob.Permanent) do
        local idInterne = v.Spawn.idInterne

        if cNV(v, "Etape") ~= "string" then
            v.Etape = "rnd" .. math.random(0,99999):padstart(5,"0")         --- pas sécurisé
            print ("^3Warning : .Etape non défini. Utilisation de \"".. v.Etape .. "\"")
        end


        l.Permanent[v.Etape] = {}
        if cNV(v, "Action") == "table" then l.Permanent[v.Etape].Action = checkCfgData(checkCfgCycle, v.Action)  end

        if cNV(pedPermanent, idInterne..".localId") == "number" then
            -- local ou net
            if cNV(pedPermanent[idInterne].Spawn, "Ped.Mode", "value") == "local" 
               or cNV(pedPermanent[idInterne].Spawn, "Ped.Mode", "value") == "net" then
                
                -- Gestion des blips
                if cNV(pedPermanent[idInterne].Spawn, "Ped.Blip") then
                    
                    if cNV(pedPermanent[idInterne].Spawn.Ped.Blip, "AddBlipForCoord", "value") == true then

                        -- blip sur position
                        blip = AddBlipForCoord(pedPermanent[idInterne].Spawn.Pos.x, pedPermanent[idInterne].Spawn.Pos.y, pedPermanent[idInterne].Spawn.Pos.z)
                        setupBlip(blip, pedPermanent[idInterne].Spawn.Ped.Blip)

                    else    -- if cNV(pedPermanent[idInterne].Spawn.Ped.Blip, "AddBlipForEntity", "value") == true then
                    
                        -- blip sur entité
                        blip = AddBlipForEntity(pedPermanent[idInterne].localId)
                        setupBlip(blip, pedPermanent[idInterne].Spawn.Ped.Blip)
    
                    end
                    
                end

                -- Gestion des qtarget
                if cNV(pedPermanent[idInterne], "Action.Condition.Target", "type") == "table" then

                    initQtargetPermanent (
                        pedPermanent[idInterne].Action.Condition.Target, 
                        pedPermanent[idInterne].localId,
                        pedPermanent[idInterne].Etape
                    )

                end
            end
        end

    end

end

function initQtargetPermanent(obj, pedId, etape)
     -- Normalisation du Target
     if checkDeepWhileTable(obj) == "table.nil" then
        obj = { obj }
    end
    
    local qTargetOptions = {}
    for i,w in ipairs(obj) do
        table.insert(qTargetOptions, {
            event = app.."passConditionTarget",
            icon = "fas fa-box-circle-check",
            label = w.Label,
            num = i, 
            permanent = etape,
            Action = w,
        })
    end

    exports.qtarget:AddTargetEntity(pedId, {
        options = qTargetOptions,
        distance = 2
    })

    l.Permanent[etape].qTargetEntity = pedId

end


function initJob ()

    ---- Gestion des fonctions permanentes
    

    ---- Gestion des étapes
    CreateThread(function()
        local Etape

            
        -- print ("initJob: Attente du chargement du client")
        while ESX.PlayerLoaded ~= true do Wait(0) end
        -- print ("initJob: Fin du chargement du client")

        while true do

            -- le refresh zone et spawn n'a pas besoin d'être agressif
            local Sleep = 1.5 * 1000


            --- Vérification du job en cours
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name ~= 'unemployed' then
                
                -- print("Job actif : ".. ESX.PlayerData.job2.name )

                if l.currentJob2 == ESX.PlayerData.job2.name  then
                    -- print ("  Déjà initialisé")
                    goto demarrage_job
                end

                if type (Config.Jobs[ESX.PlayerData.job2.name]) ~= "table" then

                    if not (l.NettoyageFait == true) then
                        -- print("  Nouveau job mais pas géré ici - Nettoyage mémoire")

                        cleanMemory(l)
                        Etape = {}
                        cfgJob = {}
                        initService(nil)
                        l.NettoyageFait = true
                    end

                    goto skip
                end


                -- print("  Nouveau job ! et c'est ici - Initialisation")

                -- nettoyage ancien job
                cleanMemory(l)
                Etape = nil

                -- initialisation
                cfgJob = Config.Jobs[ESX.PlayerData.job2.name]
                initService(ESX.PlayerData.job2.name)
                
            
            else
                -- print("  Job unemployed")
                goto skip
            end

            ::demarrage_job::
            -- print("  Démarrage job")

            


            if type(cfgJob.Etapes[l.currentEtape]) == "table" then
                
                ------ ==================================================== -------
                ------ ======       CHANGEMENT D'ETAPE                ===== -------
                ------ ==================================================== -------
                if (l.lastEtape ~= l.currentEtape) then
                -- Mise à jour suite au changement d'Etape
                  

                    if l.currentEtape == 1 then
                        -- Reinitialisation stockage coté serveur
                        TriggerServerEvent(app..'initJob')
                    end


                    -- Nettoyage mémoire
                    if type(l.Etape["e"..l.lastEtape]) == "table" then
                        cleanMemory(l.Etape["e"..l.lastEtape])
                        l.Etape["e"..l.lastEtape] = {}
                    end

                    local tmpEtape = checkCfgData(checkCfgInitialisation, 
                        firstvalid2 ( 
                            cfgJob.Etapes[l.currentEtape][l.Tache],
                            cfgJob.Etapes[l.currentEtape].default
                        )
                    )

                    Etape = checkCfgData(checkCfgCycle, tmpEtape)
                    -- print ("dump(Etape)",dump(Etape))

                    Etape._Source = tmpEtape


                    if type(Etape) == "nil" then
                        print ("Warning: Possible oubli d'une action dans l'étape. Utilisez `default` pour l'action par défaut.")
                    end

                    
                    l.Etape["e"..l.currentEtape] = {}
                    
                    -- print ("Changement d'étape ".. l.lastEtape .. ">" .. l.currentEtape)
                    -- on vient de changer d'étape, nettoyage de l'ancienne, paramétrage de la nouvelle

                    if #activePolyZone > 0 then
                        print ("pz: Zones actives : " .. #activePolyZone)
                        -- Des PolyZone sont actives, à effacer
                        
                        for k, v in pairs(activePolyZone) do
                            print ("pz: Delete "..k .. " handle=" .. tostring(v))
                            v:destroy()
                        end
                    end

    
                    if cNV (Etape, "PolyZone") == "table" then
                        -- Zone unique


                        local pz = polyzoneCreation (Etape.PolyZone)
                        l.Etape["e"..l.currentEtape].Pos = { Etape.PolyZone.vector.x, Etape.PolyZone.vector.y, Etape.PolyZone.vector.z } 
                        l.Etape["e"..l.currentEtape].PolyZone = pz 

                        -- print ("pz: Création Circle Zone handle=" .. dump(pz))
                    end

                    if cNV (Etape, "PolyZones") == "table" then
                        -- Zones multiples, random à faire pour selectionner la zone
                        -- local pz = polyzoneCreation (Etape.PolyZones[math.random(#Etape.PolyZones)])
                        local pz = polyzoneCreation (Etape.PolyZones)
                        
                        l.Etape["e"..l.currentEtape].PolyZone = pz 

                        -- print ("pz: Création PolyZone handle=" .. dump(pz))
                    end

                    if cNV (Etape, "Polygone") == "table" then
                        
                        l.Etape["e"..l.currentEtape].Zone = Etape.Polygone

                    end

                    if cNV (Etape, "Points") == "table" then
                        
                        l.Etape["e"..l.currentEtape].Points = Etape.Points

                    end


                    if cNV (Etape, "PolyZoneRandom") == "table" then
                        -- Plusieurs Polygones disponibles, choix aléatoire
                        --  + choix aléatoire d'un point dans le Polygone

                        if      type(Etape.PolyZoneRandom.name) == "string" 
                            and type(Etape.PolyZoneRandom.type) == "string" 
                            and type(Etape.PolyZoneRandom.Radius) == "number"  
                            and type(Etape.PolyZoneRandom.Zones) == "table"  
                            then
                            -- datas ok    
                                -- print ("PolyZoneRandom")
                                

                                local x, y = randomPointInPolygon( Etape.PolyZoneRandom.Zones[math.random(#Etape.PolyZoneRandom.Zones)] )

                                -- print ("posXY ",  dump(posXY))

                                l.Etape["e"..l.currentEtape].Pos = { x, y}

                                local pz = polyzoneCreation({ 
                                    type = Etape.PolyZoneRandom.type, 
                                    vector = vector2(x, y), 
                                    radius = Etape.PolyZoneRandom.Radius, 
                                    params = { name = Etape.PolyZoneRandom.name, debugPoly = true }
                                })

                                l.Etape["e"..l.currentEtape].PolyZone = pz 

                                

                                -- print ("pz: Création CircleZone à partir d'un polygone  handle=" .. dump(pz))
                        end
                    end

                    
                    if cNV (Etape, "DisplayRadar", "value") == true then
                        l.DisplayRadar = true
                    else
                        l.DisplayRadar = false
                    end

                    ------ ==================================================== -------
                    ------ ======       GOTOSTEP                          ===== -------
                    ------ ==================================================== -------
                    if cNV(Etape, "GoToStep", "type") == "table" then
                        l.Etape["e"..l.currentEtape].GoToStep = {}

                        if cNV(Etape.GoToStep, "GPS", "type") == "vector2" then
                            -- GOTO ====== Si besoin d'aller à un autre endroit
                            -- Etape.GoToStep.GPS = checkCfgData(checkCfgCycle, Etape.GoToStep.GPS)
                            ClearGpsPlayerWaypoint()
                            SetNewWaypoint(Etape.GoToStep.GPS.x, Etape.GoToStep.GPS.y)

                        end

                        if cNV (Etape.GoToStep, "Notification") ~= "nil" then
                            -- Etape.GoToStep.Notification = checkCfgData(checkCfgCycle, Etape.GoToStep.Notification)

                            showNotification (Etape.GoToStep.Notification) 
                        end

                        if cNV (Etape.GoToStep, "Spawn.Ped") ~= "nil"  then
                            
                            -- Etape.GoToStep.Spawn.Ped = checkCfgData(checkCfgCycle, Etape.GoToStep.Spawn.Ped)

                            if cNV (Etape.GoToStep, "Spawn.Ped.Mode", "value") ~= "server" then
                                -- Génération coté client

                                l.Etape["e"..l.currentEtape].GoToStep.pedId, l.Etape["e"..l.currentEtape].GoToStep.blip  = 
                                    spawnPed(Etape.GoToStep.Spawn.Ped, 
                                        Etape.GoToStep.Spawn.Pos, Etape.GoToStep.Spawn.Heading, 
                                        Etape.GoToStep.Spawn.Blip
                                    )
                                
                                if l.Etape["e"..l.currentEtape].GoToStep.pedId > 0 
                                and cNV(Etape, "Action.Condition.Target", "type") == "table" then

                                    exports.qtarget:AddTargetEntity(l.Etape["e"..l.currentEtape].GoToStep.pedId, {
                                        options = {
                                            {
                                                event = app.."passConditionTarget",
                                                icon = firstvalid2(
                                                            cNV(Etape.Action.Condition, "Target.Icon", "value"),
                                                            "fas fa-box-circle-check"),
                                                label = Etape.Action.Condition.Target.Label,
                                                num = 1, 
                                                etape = l.currentEtape, 
                                            },
                                        },
                                        distance = 2
                                    })

                                else 
                                    -- Dans le cas d'une erreur de spawn de ped, on refait l'initialisation de l'étape
                                    l.lastEtape = l.currentEtape -1 
                                end

                            end
                        end
                    end
                    
                    
                    -- A faire : 
                    --  * Affichage des blips et effacement des anciens
                    --  * Navigation GPS


                    -- on confirme que la configuration est faite pour l'étape
                    l.lastEtape = l.currentEtape
                end


                ------ ==================================================== -------
                ------ ======       ACTION DANS UNE ETAPE             ===== -------
                ------ ==================================================== -------
                if  cNV(Etape, "Action", "type") == "table" 
                    and not (cNV(l.Etape["e"..l.currentEtape], "finishAction", "value") == true) then

                    local pass = 0
                    local debugConditionErrors = ""
                    local passCondition = false

                    
                    if cNV (Etape, "DisplayRadar", "value") == true then
                        exports.dx_hud:forceDisplayRadar()

                        -- if pcall(exports.dx_hud:forceDisplayRadar()) then
                        --     print("forceDisplayRadar()")
                        -- else
                        --     print("^3forceDisplayRadar() non disponible")
                        -- end
                        
                    end
                    
                    if cNV(Etape.Action, "Condition", "type") == "table" then
                        -- print("Action : Conditions")
                        
                        if pass >= 0 
                           and cNV(Etape.Action.Condition, "PolyZone", "type") == "string" then
                            if l.Etape["e"..l.currentEtape].PolyZone:isPointInside(GetEntityCoords(PlayerPedId())) then
                                -- print ("  Succès de la valisation Polyzone")
                                debugConditionErrors = debugConditionErrors ..  "+PolyZone "
                                pass = 1
                            else 
                                -- print ("  Echec de la valisation Polyzone")
                                debugConditionErrors = debugConditionErrors ..  "-PolyZone "
                                pass = -1 
                            end
                        end

                        if pass >= 0 
                           and cNV(Etape.Action.Condition, "Target", "type") ~= "nil" then

                            if l.Etape["e"..l.currentEtape].passConditionTarget then 
                                -- print ("  Succès de la valisation Target")
                                debugConditionErrors = debugConditionErrors ..  "+passConditionTarget "

                                pass = 1
                            else 
                                -- print ("  Echec de la valisation Target")
                                debugConditionErrors = debugConditionErrors ..  "-passConditionTarget "
                                pass = -1 
                            end

                        end
                        
                        if pass >= 0 
                           and cNV(Etape.Action.Condition, "Hint", "type") == "string" then
                            showHelpNotification(Etape.Action.Condition.Hint)
                        end

                        if pass >= 0 
                           and cNV(Etape.Action.Condition, "Touche", "type") == "number" then

                            Sleep = 0   -- On passe en test toutes les frames pour recupérer l'appui de touches
                            if  IsControlJustReleased(0, Etape.Action.Condition.Touche) then
                                -- print ("  Succès de la valisation Touche")
                                debugConditionErrors = debugConditionErrors .. "+Touche "
                                pass = 1
                            else 
                                -- print ("  Echec de la valisation Touche")
                                debugConditionErrors = debugConditionErrors .. "-Touche "
                                pass = -1 
                            end
                        end


                    else
                        -- Pas de conditions pour déclencher l'Action
                        debugConditionErrors = debugConditionErrors ..  "Pas de conditions "
                        pass = 1
                    end
                    
                    
                    if pass == 1 then 
                        passCondition = true 
                    end
                    l.Etape["e"..l.currentEtape].passCondition = passCondition


                    if cNV(l.Etape["e"..l.currentEtape], "passCondition", "value") == true then

                        if cNV(Etape.Action, "GoTo", "type") == "table" then

                            -- GOTO ====== Si besoin d'aller à un autre endroit
                            -- Etape.Action.GoTo = checkCfgData(checkCfgCycle, Etape.Action.GoTo)

                            if cNV(Etape.Action.GoTo, "Notification", "type") == "string" then
                                showNotification (Etape.Action.GoTo.Notification) end

                            if cNV(Etape.Action.GoTo, "Tache", "type") == "string" then
                                l.Tache = Etape.Action.GoTo.Tache   end
                        end



                        if cNV(Etape.Action, "Spawn", "type") == "table" then

                            -- SPAWN ====== Si l'action nécessite un spawn 
                            -- print("Action : Spawn")

                            
                            local x,y

                            if type(l.Etape["e"..l.currentEtape].propSpawned) == "nil"
                                and type(l.Etape["e"..l.currentEtape].pedSpawned) == "nil" 
                                and type(l.Etape["e"..l.currentEtape].TargetCircleBoxSpawned) == "nil" 
                                and type(l.Etape["e"..l.currentEtape].TargetModelZoneSpawned) == "nil" 
                                then
                                
                                local tmpSource = Etape._Source
                                Etape = checkCfgData(checkCfgCycle, tmpSource)
                                Etape._Source = tmpSource


                                if type(l.Etape["e"..l.currentEtape].Zone) == "table" then
                                    
                                    -- .Zone : c'est un polygone, trouve un point dedans
                                    x,y = randomPointInPolygon(l.Etape["e"..l.currentEtape].Zone)

                                elseif  type(l.Etape["e"..l.currentEtape].Pos) == "table" then

                                    -- .Pos : c'est un centre, trouve un point dans le cercle de ce centre sur le rayon Radius
                                    x,y = randomPositionCercle(l.Etape["e"..l.currentEtape].Pos[1],l.Etape["e"..l.currentEtape].Pos[2], Etape.Action.Spawn.Radius)

                                elseif  type(l.Etape["e"..l.currentEtape].Points) == "table" then

                                    -- .Points : c'est un liste de point à choisir pour le spawn
                                    local lePoint = l.Etape["e"..l.currentEtape].Points[math.random(#l.Etape["e"..l.currentEtape].Points)]

                                    x = lePoint.x
                                    y = lePoint.y

                                end

                                -- print ("Spawn en ".. x .. ", " .. y .. ", 30")


                                if cNV(Etape.Action.Spawn, "Notification", "type") == "string" then
                                    showNotification (Etape.Action.Spawn.Notification) 
                                end
                               
                            end

                            if  cNV(Etape.Action.Spawn, "TargetModelZone", "type") == "table" then
                                if type(l.Etape["e"..l.currentEtape].TargetModelZoneSpawned) == "nil" then

                                    -- local qTargetName = tostring(x).. "-" .. tostring(y)

                                    local blip = AddBlipForCoord(x, y, 30)
                                    setupBlip(blip, Etape.Action.Spawn.TargetModelZone.Blip)

                                    exports.qtarget:AddTargetModel( cNV(Etape.Action.Spawn.TargetModelZone, "ModelHash", "value"), 
                                        {
                                            options = {
                                                {
                                                    event = app.."recolte_spawn_ped",

                                                    icon = firstvalid2(
                                                                cNV(Etape.Action.Spawn, "TargetModelZone.Target.Icon", "value"),
                                                                "fas fa-box-circle-check"),
                                                    label = firstvalid2(
                                                                cNV(Etape.Action.Spawn, "TargetModelZone.Target.Label", "value"), 
                                                                "Action"),
                                                    blip = blip, 
                                                    num = 1, 

                                                    Action = checkCfgData(checkCfgCycle, Etape.Action),
                                                    etape = l.currentEtape,
                                                    progressLabel = cNV(Etape.Action, "Progress.Label", "value"),
                                                    
                                                    Radius = firstvalid2( cNV(Etape.Action.Spawn, "Radius", "value"), 4),
                                                    Pos = vector3(x,y,30),

                                                    canInteract = function(entity, distance, data)
                                                        return (GetDistanceBetweenCoords( data.Pos.x, data.Pos.y, 0, 
                                                        GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, 0, false) < data.Radius)
                                                    end, 

                                                },
                                            },
                                            distance = 7
                                        })


                                    -- sauvegarde
                                    l.Etape["e"..l.currentEtape].TargetModelZoneSpawned = {
                                        qTargetModel = cNV(Etape.Action.Spawn.TargetModelZone, "ModelHash", "value"),
                                        blip = blip, 
                                        Action = checkCfgData(checkCfgCycle, Etape.Action),
                                    }

                                end
                            end

                            if  cNV(Etape.Action.Spawn, "TargetCircleBox", "type") == "table" then
                                if type(l.Etape["e"..l.currentEtape].TargetCircleBoxSpawned) == "nil" then

                                    local qTargetName = tostring(x).. "-" .. tostring(y)

                                    local blip = AddBlipForCoord(x, y, 30)
                                    setupBlip(blip, Etape.Action.Spawn.TargetCircleBox.Blip)


                                    exports.qtarget:AddCircleZone(qTargetName, vector3(x,y,30), Etape.Action.Spawn.Radius, 
                                        {
                                            name = qTargetName,
                                            heading=7,
                                            debugPoly=true,
                                        }, {
                                            options = {
                                                {
                                                    event = app.."recolte_spawn_ped",
                                                    icon = firstvalid2(
                                                                cNV(Etape.Action.Spawn, "TargetCircleBox.Target.Icon", "value"),
                                                                "fas fa-box-circle-check"),
                                                    label = firstvalid2(
                                                                cNV(Etape.Action.Spawn, "TargetCircleBox.Target.Label", "value"), 
                                                                "Action"),
                                                    blip = blip, 
                                                    num = 1, 
                                                    -- canInteract = true, 
                                                    Action = checkCfgData(checkCfgCycle, Etape.Action),
                                                    etape = l.currentEtape,
                                                    progressLabel = cNV(Etape.Action, "Progress.Label", "value"),
                                                },
                                            },
                                            distance = 2
                                        })

                                    -- sauvegarde
                                    l.Etape["e"..l.currentEtape].TargetCircleBoxSpawned = {
                                        -- targetId = pedId, 
                                        qTargetZone = qTargetName,
                                        blip = blip, 
                                        Action = checkCfgData(checkCfgCycle, Etape.Action),
                                    }

                                end
                            end

                            if  cNV(Etape.Action.Spawn, "Prop", "type") == "table" then
                                if type(l.Etape["e"..l.currentEtape].propSpawned) == "nil" then

                                    -- Si le spawn n'a pas été fait ou disparu
                                    local z = 42
                                    local SpawnPos = vector3(x+0.0,y+0.0,z)

                                    local pedId, blip = spawnProp(Etape.Action.Spawn.Prop.Model, SpawnPos, math.random(0,360)+0.0, Etape.Action.Spawn.Prop.Blip)

                                    -- print ("spawned pedId=" .. pedId .. " blip=" .. tostring(blip) )

                                    

                                    if pedId > 0 then 

                                        -- action qtarget
                                        exports.qtarget:AddTargetEntity(pedId, {
                                            options = {
                                                {
                                                    event = app.."recolte_spawn_ped",
                                                    icon = firstvalid2(
                                                                cNV(Etape.Action.Spawn, "Prop.Target.Icon", "value"),
                                                                "fas fa-box-circle-check"),

                                                    label = firstvalid2(
                                                                cNV(Etape.Action.Spawn, "Prop.Target.Label", "value"), 
                                                                "Action"),
                                                    blip = blip, 
                                                    num = 1, 
                                                    Action = checkCfgData(checkCfgCycle, Etape.Action),
                                                    etape = l.currentEtape,
                                                    progressLabel = cNV(Etape.Action, "Progress.Label", "value"),
                                                },
                                            },
                                            distance = 2
                                        })

                                        -- sauvegarde
                                        l.Etape["e"..l.currentEtape].propSpawned = {
                                            Model = Etape.Action.Spawn.Prop.Model,
                                            propId = pedId, 
                                            blip = blip, 
                                            propPos = GetEntityCoords( pedId, true ),
                                            Action = checkCfgData(checkCfgCycle, Etape.Action),
                                        }
                                    end

                                end
                            end

                            if  cNV(Etape.Action.Spawn, "Ped", "type") == "table" then
                                -- Si l'action nécessite un spawn de ped

                                
                                if type(l.Etape["e"..l.currentEtape].pedSpawned) == "nil" then

                                    -- Si le spawn n'a pas été fait ou disparu
                                
                                    local z = 35.0
                                    local SpawnPos = vector3(x+0.0,y+0.0,z)

                                    local pedId, blip = spawnPed(Etape.Action.Spawn.Ped, SpawnPos, math.random(0,360)+0.0, Etape.Action.Spawn.Ped.Blip)

                                    -- print ("spawned pedId=" .. pedId .. " blip=" .. tostring(blip) )

                                    

                                    if pedId > 0 then 

                                        -- action qtarget
                                        exports.qtarget:AddTargetEntity(pedId, {
                                            options = {
                                                {
                                                    event = app.."recolte_spawn_ped",
                                                    entity = pedId,
                            
                                                    
                                                    icon = firstvalid2(
                                                                cNV(Etape.Action.Spawn, "Ped.Target.Icon", "value"),
                                                                "fas fa-box-circle-check"),

                                                    label = firstvalid2(
                                                                cNV(Etape.Action.Spawn, "Ped.Target.Label", "value"), 
                                                                "Action"),
                                                    blip = blip, 
                                                    num = 1, 
                                                    Action = checkCfgData(checkCfgCycle, Etape.Action),
                                                    etape = l.currentEtape,
                                                    progressLabel = cNV(Etape.Action, "Progress.Label", "value"),
                                                },
                                            },
                                            distance = 2
                                        })

                                        -- sauvegarde
                                        l.Etape["e"..l.currentEtape].pedSpawned = {
                                            Model = Etape.Action.Spawn.Ped.Model,
                                            pedId = pedId, 
                                            blip = blip, 
                                            pedPos = GetEntityCoords( pedId, true ),
                                            Action = checkCfgData(checkCfgCycle, Etape.Action),
                                        }
                                    end

                                end

                            end
                        end

                        if cNV(Etape.Action, "Transaction", "type") == "table" 
                           and not (cNV(Etape.Action, "Spawn", "type") == "table") then

                            -- print("Action : Transaction")

                            Etape.Action.etape =  "e" .. l.currentEtape
                            TriggerEvent(app.."transaction", Etape.Action )
                        
                        end

                        if cNV(Etape.Action, "GoTo", "type") == "table" then
                            -- print("Action : Goto EtapeIncremente")
                            if cNV(Etape.Action.GoTo, "EtapeIncremente", "type") == "number" then
                                l.currentEtape += Etape.Action.GoTo.EtapeIncremente   end

                        end
                    end
                end
            
            else
                -- On a dépasser le nombre d'étapes, on reboucle à 1
                l.currentEtape = 1
            end

            ------ ==================================================== -------
            ------ ======       ACTION  DES PERMANENTS            ===== -------
            ------ ==================================================== -------
            for k, v in pairs(l.Permanent) do
                
                if cNV(v, "passConditionTarget", "value") == true then
                    v = checkCfgData(checkCfgInitialisation, v)
                
                    l.Permanent[k].passConditionTarget = false

                    if cNV(v, "Action.Transaction", "type") == "table" then

                        v.Action.permanent = k
                        TriggerEvent(app.."transaction", v.Action )
                    
                    end

                    if cNV(v, "Action.GoTo", "type") == "table" then

                        if cNV(v.Action.GoTo, "Notification", "type") == "string" then
                            showNotification (v.Action.GoTo.Notification) 
                        end

                        if cNV(v.Action.GoTo, "Tache", "type") == "string" then
                            l.Tache = v.Action.GoTo.Tache   
                        end

                        if cNV(v.Action.GoTo, "EtapeIncremente", "type") == "number" then
                            l.currentEtape += v.Action.GoTo.EtapeIncremente   
                        end

                        if cNV(v.Action.GoTo, "EtapeSet", "type") == "number" then
                            cleanMemory(l.Etape["e"..l.currentEtape])
                            l.currentEtape = v.Action.GoTo.EtapeSet   
                            l.lastEtape = l.currentEtape -1
                        end

                    end
                end
            end

            ::skip::
            Wait(Sleep)

        end
    end)
    

    --- Local
    AddEventHandler(app.."recolte_spawn_ped", function(data)

        data.Action.entity = data.entity
        data.Action.blip = data.blip
        data.Action.etape = "e".. data.etape

        print("recolte_spawn_ped",dump (data))

        -- print("TriggerServerEvent Transaction recolte_spawn_ped")
        TriggerServerEvent(app..'transaction', data.Action)
    end)

    --- Local
    AddEventHandler(app.."transaction", function(data)
        -- print("TriggerServerEvent Transaction ", dump(data))
        TriggerServerEvent(app..'transaction', data)
    end)

    --- appelé par qtarget 
    AddEventHandler(app.."passConditionTarget", function(data)

        -- print ("passConditionTarget : dump(data) ", dump(data))
        if type(data.etape) ~= "nil" then
            
            if type(data.Action) == "table" then
                l.Etape["e"..data.etape].Action = data.Action
            end
            l.Etape["e"..data.etape].passConditionTarget = true

        elseif type(data.permanent) ~= "nil" then

            if type(data.Action) == "table" then
                l.Permanent[data.permanent].Action = data.Action
            end
            l.Permanent[data.permanent].passConditionTarget = true

        end

    end)

    --- appelé par Serveur
    RegisterNetEvent(app.."finishAction") 
    AddEventHandler(app.."finishAction", function(data)
        if type(data.etape) ~= "nil" then
            l.Etape[data.etape].finishAction = true
            l.currentEtape = l.currentEtape + 1
        end
    end)

    
    --- appelé par Serveur
    RegisterNetEvent(app.."process") 
    AddEventHandler(app..'process', function(data)

        if data.totalCooldown > 0 then 

            -- TaskLookAtEntity( ESX.PlayerData.ped, data.entity, 500, 2048, 3)
            StopAnimPlayback(data.entity,1,true)
            TaskLookAtCoord(ESX.PlayerData.ped, 0,0,0,1000)

            ESX.Progressbar(
                firstvalid2(data.Progress.Label, "En cours..."), 
                data.totalCooldown, 
                {
                    FreezePlayer =  firstvalid2(data.Progress.FreezePlayer, true), 
                    animation =     firstvalid2(data.Progress.Anim, {}), 
                }
            )
            
        end

        if data.TriggerEtapeSuivante == true then
            l.currentEtape += 1
        end

        if type(data.etape ) ~= "nil" then


            if l.Etape[data.etape].TargetCircleBoxSpawned ~= nil then
                -- print ("process, TargetCircleBoxSpawned ", dump(data))

                exports.qtarget:RemoveTargetModel(l.Etape[data.etape].TargetCircleBoxSpawned.qTargetModel )
                RemoveBlip (l.Etape[data.etape].TargetCircleBoxSpawned.blip)

                l.Etape[data.etape].TargetCircleBoxSpawned = nil
            end

            if l.Etape[data.etape].TargetModelZoneSpawned ~= nil then
                -- print ("process, TargetModelZoneSpawned ", dump(data))
                
                exports.qtarget:RemoveTargetModel(l.Etape[data.etape].TargetModelZoneSpawned.qTargetModel )
                RemoveBlip (l.Etape[data.etape].TargetModelZoneSpawned.blip)
                
                l.Etape[data.etape].TargetModelZoneSpawned = nil
            end

            if l.Etape[data.etape].pedSpawned ~= nil then
                -- print ("process, pedSpawned ")
                deletePed("despawn", data.entity, data.blip, data.etape) 
                l.Etape[data.etape].pedSpawned = nil
            end

            if l.Etape[data.etape].propSpawned ~= nil then
                -- print ("process, propSpawned ")
                deleteProp ("despawn", data.entity)
                l.Etape[data.etape].propSpawned = nil
            end
        
        end
    end)
end


RegisterNetEvent(app.."ShowNotification") 
AddEventHandler(app..'ShowNotification', function(msg)
    
    -- print ("Notification : " .. msg)
    ESX.ShowNotification(msg, true, true, nil)

end)

function showNotification (msg)
    TriggerEvent(app.."ShowNotification", msg) 
end



RegisterNetEvent(app.."ShowHelpNotification") 
AddEventHandler(app..'ShowHelpNotification', function(msg)
    
    print ("HelpNotification : " .. msg)
    -- Bug à corriger, n'envoit pas la notif, fait une erreur
    -- ESX.ShowHelpNotification(msg, false, true, nil)
    
end)

function showHelpNotification (msg)
    TriggerEvent(app.."ShowHelpNotification", msg) 
    
end


function deleteProp (mode, propId)
    exports.qtarget:RemoveTargetEntity(propId)

    
    if mode == "despawn" then
        -- SetEntityAsNoLongerNeeded(propId)
        FreezeEntityPosition(propId,false)
        SetTimeout(3*1000, function()
            DeleteObject(propId)
        end)
        
    elseif mode == "fast" then                
        DeleteObject(propId)
    end
end



function deletePed (mode, pedId, blip, etape)

    exports.qtarget:RemoveTargetEntity(pedId)
    
    print ("deletePed ".. tostring(mode) .. " " .. tostring(pedId) .. " " .. tostring(blip) .. " " .. tostring(etape))

    if etape ~= nil then 
        if cNV (l.Etape[etape], "pedSpawned") == "table" then
            print ("   RAZ du .pedSpawned")
            l.Etape[etape].pedSpawned = nil
        end
    end

    if not DoesEntityExist(pedId) then 
        -- print ("pedId " .. pedId .. " n'existe pas. ")
        return  
    end

    if mode == "despawn" then
        -- TaskSetBlockingOfNonTemporaryEvents(pedId, false)
        FreezeEntityPosition(pedId, false)
        TaskWanderStandard(pedId, 10.0, 10)

        RemoveBlip(blip)
        SetEntityAsNoLongerNeeded(pedId)

        -- SetTimeout(5*1000, function()
        --     DeletePed(pedId)
        -- end)

    elseif mode == "fast" then

        DeletePed(pedId)

    else

        NetworkFadeOutEntity(pedId , true, true)
        while NetworkIsEntityFading(pedId) do Wait(0) end

        DeletePed(pedId)

    end
end


function polyzoneCreation (obj)
    local pz

    if obj.type == "CircleZone" then
        pz = CircleZone:Create(obj.vector, obj.radius, obj.params)
    elseif obj.type == "PolyZone" then
        pz = PolyZone:Create(obj.vector, obj.params)
    end

    activePolyZone [obj.params.name] = pz
    return pz
end



--- Initialisation 


function detectPedModel(obj)
    -- Detection de pedmodel qui seront générés localement

    for k, v in pairs(obj) do
        if k == "Model" and (type(v) == "number" or type(v) == "string") then

            if cNV(obj, "Ped.Mode", "value") ~= "server" then 
                modeleTable[tostring(v)] = true
            end
            
            -- table.insert(modeleTable, v)
        elseif type(v) == "table" then
            detectPedModel(v)
        end
    end
    
end

function initService(job)
    l = {
        lastEtape = 0,
        currentEtape = 1,

        lastJob2 = job,
        currentJob2 = job, 

        Etape = {}, 
        Permanent = {}, 
    }

    
    initPermanent()

end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    cleanMemory (pedPermanent)
    cleanMemory (l)
end)

RegisterNetEvent(app..'printConsole', function(...)
    print ("Server: ", ...)
end)

RegisterCommand(app..'viewStatut', function()
    print ("======= viewStatut ======")
    print(dump(Statut))
end, false)


if serverDEV or IsPlayerAceAllowed(source, "admin") then 

    --- Outils de dev
    RegisterCommand(app..'restartEtape', function(source, args)
    
        l.lastEtape = 0
    
        if tonumber(args[1]) > 0 then
    
            for i=1,tonumber(args[1]) do
                l.Etape["e"..i] = {}
            end
    
            print ("Redemarre Etape ".. args[1])
            l.currentEtape = tonumber(args[1])
        end
    
    end, false)
    
    RegisterCommand(app..'resetInventory', function()
        TriggerServerEvent(app..'resetInventory')
    end, false)
    
    
    RegisterCommand(app..'getjob', function(source, args)
        local job2 = "boucher2"
        if type(args[1]) ~= "nil" then job2 = args[1] end

        ExecuteCommand("setjob2 ".. GetPlayerServerId(PlayerId()) .. " " .. job2 .. " 0")
    end, false)

    
    RegisterCommand(app..'dump', function(source, args)

        local dumpvar = ""
        if #args >= 1 then
            dumpvar = args[1]

            print ("^5======= dump(".. dumpvar .. ") ======")
            -- if dumpvar == "pedServerSide" then print(dump(pedServerSide)) end
            if dumpvar == "recolte2" then print(dump(Config.Jobs.recolte2)) end
            if dumpvar == "Config" then print(dump(l)) end

            if dumpvar == "Working" then TriggerServerEvent(app..'dumpWorking') end
            -- if dumpvar == "server:pedServerSide" then TriggerServerEvent(app..'dumpPedServerSide') end

            if dumpvar == "pedPermanent" then
                for k,v in pairs(pedPermanent) do
                    print (k, "Id=".. tostring(v.localId), "Dying? " .. tostring(IsPedDeadOrDying(v.localId, true)))
                end
            end
        else
            print("^1Erreur : Nom de la variable manquante - Working/Config/recolte2")
        end

    end, false)

end
