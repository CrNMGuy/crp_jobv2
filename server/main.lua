---- CRP_JOBV2
-- auteur : Florian__#4413 (D)

local serverDEV = GetConvar("serverDEV", "")
local playersWorking = {}


AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end

end)



function getUniqueId(playerId)

    local obj = {}

    for _, v in pairs(GetPlayerIdentifiers(playerId))do
        local w = split(v, ":")
        obj[w[1]] = w[2]
    end
 
    return firstvalid2(obj.license, obj.discord, obj.steam, playerId)

end


RegisterServerEvent(app..'transaction', function(data)
    -- Recoit .Action  (interet pour Progress, Transaction)

    local etape 
    if type(data.etape) ~= "nil" then etape = data.etape end
    if type(data.permanent) ~= "nil" then etape = "permanent_"..data.permanent end


    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local uniqueId = getUniqueId(playerId)
 

    if type(playersWorking[tostring(uniqueId)]) == "nil" then 
        playersWorking[tostring(uniqueId)] = { Items = {}, }
        
    end
    if type(playersWorking[tostring(uniqueId)][etape]) == "nil" then
        playersWorking[tostring(uniqueId)][etape] = { count = 0, } 
    end



    data.totalTxCount = 0
    local totalPay = 0

    local bilanError = {
        pasdeplace = {
            count = 0,
            msg = U["pasdeplace"],
        },
        pasditem = {
            count = 0,
            msg = U["pasditem"],
        },
    }
    


    for i ,v in ipairs(data.Transaction) do

        
        -- printConsole("Exec : transaction   ".. i.."/" .. tableLength(data.Transaction),  "dump(v) = ",  dump(v))
            
        local errorCount = 0
        local errorMsg = ""

        if cNV(data, "Spawn.MaxCycles") == "number" then
            playersWorking[tostring(uniqueId)][etape].max = data.Spawn.MaxCycles
        end

        data.totalCooldown = 0
        data.totalCooldown += firstvalid2 (cNV(v, "Remove.Cooldown", "value"), 0)
        data.totalCooldown += firstvalid2 (cNV(v, "RemoveServer.Cooldown", "value"), 0)
        data.totalCooldown += firstvalid2 (cNV(v, "Give.Cooldown", "value"), 0)
        data.totalCooldown += firstvalid2 (cNV(v, "GiveServer.Cooldown", "value"), 0)
        data.totalCooldown += firstvalid2 (cNV(v, "Pay.Cooldown", "value"), 0)
        
        


        -- Vérifications
        if cNV(v, "Remove", "type") ~= "nil" then


            if cNV(v, "Remove.Qte", "value") == -1 then
                v.Remove.Qte = xPlayer.getInventoryItem(v.Remove.Item).count
            end


            if xPlayer.getInventoryItem(v.Remove.Item).count < v.Remove.Qte or xPlayer.getInventoryItem(v.Remove.Item).count == 0 then
                errorCount += 1
                errorMsg = U["pasditem"]
                bilanError.pasditem.count += 1
            end

    
            if cNV(v, "Give", "type") ~= "nil" then
                if not xPlayer.canSwapItem(v.Remove.Item, v.Remove.Qte, v.Give.Item, v.Remove.Qte * v.Give.Qte)  then
                    errorCount += 1
                    errorMsg = U["pasdeplace"]
                    bilanError.pasdeplace.count += 1
                end
            end
            

            -- GiveServer = pas de limite de capacité
            -- elseif cNV(v, "GiveServer", "type") ~= "nil" then

            -- Pay = pas de gestion d'inventaire

        elseif cNV(v, "RemoveServer", "type") ~= "nil" then

            if v.RemoveServer.Qte == -1 then 
                v.RemoveServer.Qte = countItemServer(uniqueId, v.RemoveServer.Item)
            end

            if cNV(v, "Give", "type") ~= "nil" then

                if not xPlayer.canCarryItem(v.Give.Item, v.Give.Qte * v.RemoveServer.Qte) then
                    -- joueur ne peut pas emporter la qte, on teste la qte maxi

                    local maxQte = 0
                    while xPlayer.canCarryItem(v.Give.Item, maxQte+1 ) do
                        maxQte += 1
                    end
                    
                    maxQte -=  maxQte % v.Give.Qte

                    if maxQte == 0 then 
                        errorCount += 1
                        errorMsg = U["pasdeplace"]
                        bilanError.pasdeplace.count += 1
                    end

                    v.RemoveServer.Qte = maxQte

                end

            end

            -- GiveServer = pas de limite de capacité
            -- elseif cNV(v, "GiveServer", "type") ~= "nil" then

            -- Pay = pas de gestion d'inventaire

        elseif cNV(v, "Give", "type") ~= "nil" then

            if not xPlayer.canCarryItem(v.Give.Item, v.Give.Qte) then
                errorCount += 1
                errorMsg = U["pasdeplace"]
                bilanError.pasdeplace.count += 1
            end

        end



        local txCount = 0
        
        -- Transaction
        if errorCount > 0 then
            -- Erreur
            
            -- xPlayer.showNotification(errorMsg, false, true, 120)
        else
            local totalRemove = 0

            playersWorking[tostring(uniqueId)][etape].count += 1

            if type(playersWorking[tostring(uniqueId)][etape].max) == "number" then
                if playersWorking[tostring(uniqueId)][etape].count >= playersWorking[tostring(uniqueId)][etape].max then
                    data.TriggerEtapeSuivante = true
                end
            end


            -- affiche la progressbar coté client et lance la suite
            TriggerClientEvent(app..'process', playerId, data)


            -- fait les actions sans attendre la fin de la progressbar
            if cNV(v, "Remove.Qte", "type") ~= "nil" then
                if v.Remove.Qte > 0 then
                    txCount += 1

                    -- printConsole ("~b~Remove~s~ ".. v.Remove.Item .. " x " .. v.Remove.Qte)
                    xPlayer.removeInventoryItem(v.Remove.Item, v.Remove.Qte)

                    totalRemove += v.Remove.Qte
                end
            end
        
            if cNV(v, "RemoveServer.Qte", "type") ~= "nil" then
                if v.RemoveServer.Qte > 0 then
                    txCount += 1

                    -- printConsole ("~b~RemoveServer~s~ ".. v.RemoveServer.Item .. " x " .. v.RemoveServer.Qte)
                    removeItemServer(uniqueId, v.RemoveServer.Item, v.RemoveServer.Qte)

                    totalRemove += v.RemoveServer.Qte
                end
            end
    
            if cNV(v, "RemoveServer.Qte", "type") == "nil" and cNV(v, "Remove.Qte", "type") == "nil" then
                -- On a pas d'action de remove, c'est give sans condition de quantité
                totalRemove = 1
            end

            if cNV(v, "Give.Qte", "type") ~= "nil" then
                if v.Give.Qte > 0 then
                    txCount += 1

                    -- printConsole ("~b~Give~s~ ".. v.Give.Item .. " x " .. v.Give.Qte .. " * " .. totalRemove .. " txcount=" .. txCount)
                    xPlayer.addInventoryItem(v.Give.Item, v.Give.Qte * totalRemove)
                    
                end
            end
        
            if cNV(v, "GiveServer.Qte", "type") ~= "nil" then
                if v.GiveServer.Qte > 0 then
                    -- printConsole ("~b~GiveServer~s~ ".. v.GiveServer.Item .. " x " .. v.GiveServer.Qte .. " * " .. totalRemove .. " txcount=" .. txCount )
                    addItemServer(uniqueId, v.GiveServer.Item, v.GiveServer.Qte * totalRemove)
                    
                    txCount += 1
                end
            end
    
            if cNV(v, "Pay.Qte", "type") ~= "nil" then
                if v.Pay.Qte > 0 and totalRemove > 0 then
                    txCount += 1

                    -- printConsole ("~b~Pay~s~  " .. v.Pay.Qte .. " * " .. totalRemove .. " txcount=" .. txCount)
                    xPlayer.addMoney(v.Pay.Qte * totalRemove, "Vente de l'article")
                    
                    totalPay += v.Pay.Qte * totalRemove
                end
            end
        end



        if type(playersWorking[tostring(uniqueId)][etape].max) == "number" then

            if playersWorking[tostring(uniqueId)][etape].count >= playersWorking[tostring(uniqueId)][etape].max then
                xPlayer.showNotification(U["finmission"], false, true, 120)
            end
            
        elseif txCount >= 1 then 

            data.totalTxCount += txCount

        end
    end



    if bilanError.pasdeplace.count > 0 then
        xPlayer.showNotification(bilanError.pasdeplace.msg, false, true, 120)
    elseif bilanError.pasditem.count== tableLength(data.Transaction) then
        xPlayer.showNotification(bilanError.pasditem.msg, false, true, 120)
    end


    if totalPay > 0 then
        xPlayer.showNotification(U["paiement"]..formatNumber(totalPay), false, true, 120)
    end


    if data.totalTxCount > 0 then
        -- printConsole ("exec finishAction")

        if type(data.etape) ~= nil then 
            TriggerClientEvent(app..'finishAction', playerId, { etape = data.etape })
        elseif type(data.permanent) ~= nil then 
            TriggerClientEvent(app..'finishAction', playerId, { permanent = data.permanent })
        end
    elseif data.totalTxCount == 0 then
       --  xPlayer.showNotification("Tu n'as rien qui m'intéresse", false, true, 120)
    end

end)

function addItemServer(uniqueId, item, qte)

    if qte <= 0 then return 0 end


    if type(playersWorking[tostring(uniqueId)].Items) ~= "table" then
        playersWorking[tostring(uniqueId)].Items = {}
    end

    if type(playersWorking[tostring(uniqueId)].Items[item]) == "nil" then
        playersWorking[tostring(uniqueId)].Items[item] = 0
    end

    -- pas de limite de capacité
    playersWorking[tostring(uniqueId)].Items[item] += qte


    return qte

end

function removeItemServer(uniqueId, item, qte)

    if qte <= 0 then return 0 end
    
    if type(playersWorking[tostring(uniqueId)].Items) ~= "table" then
        return 0
    end

    if type(playersWorking[tostring(uniqueId)].Items[item]) == "nil" then
        return 0
    end

    local qteAutorise = math.max (math.min (qte, playersWorking[tostring(uniqueId)].Items[item]) , playersWorking[tostring(uniqueId)].Items[item])
    playersWorking[tostring(uniqueId)].Items[item] -= qteAutorise

    return qteAutorise

end


function countItemServer(uniqueId, item)

    if type(playersWorking[tostring(uniqueId)].Items) ~= "table" then
        return 0
    end

    if type(playersWorking[tostring(uniqueId)].Items[item]) == "number" then
        return playersWorking[tostring(uniqueId)].Items[item]
    end

    return 0

end


RegisterServerEvent(app..'initJob', function()

    local playerId = source
    local uniqueId = getUniqueId(playerId)
    playersWorking[tostring(uniqueId)] = { playerId = playerId, Items = {}, }

end)


if serverDEV then 
    
    RegisterServerEvent(app..'dumpWorking', function()
        printConsole (dump(playersWorking))
    end)


    


    RegisterServerEvent(app..'resetInventory', function()

        local playerId = source
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local inventory = xPlayer.getInventory(true)


        if inventory then
            for item,count in pairs(inventory) do
                xPlayer.removeInventoryItem(item, count)
            end
        end

        xPlayer.addInventoryItem("viande_boeuf", 2)
        xPlayer.addInventoryItem("viande_boeuf_qualite", 2)
        xPlayer.addInventoryItem("viande_porc", 2)
        xPlayer.addInventoryItem("viande_porc_qualite", 2)
        xPlayer.addInventoryItem("lait", 2)
        xPlayer.addInventoryItem("lait_qualite", 2)
        xPlayer.addInventoryItem("pomme", 2)

    end)

end