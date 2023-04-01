local nomJob = "boucher2_"

local Commun = {}
Commun.MaxCycles = 3    -- 15
Commun.QteRecolte = {1,4}  --{1,2}
Commun.CooldownRecolte = 1.5 * 1000
Commun.Zones = { 
    
    Boeuf = {

        {{2295.3198242188, 4911.9555664062},{2278.6188964844, 4898.541015625},{2227.1064453125, 4946.4501953125},{2255.4399414062, 4951.6962890625}},
        -- --minZ = 43.083911895752,  --maxZ = 66.284049987793

        {{2294.5620117188, 4843.8999023438},{2272.4929199219, 4828.7392578125},{2243.5803222656, 4857.1240234375},{2255.8361816406, 4872.4536132812}},
        -- --minZ = 41.261867523193,  --maxZ = 46.669986724854

        {{2207.4392089844, 4970.5756835938},{2162.0649414062, 5019.69140625},{2183.3017578125, 5045.7231445312},{2232.7819824219, 5001.2866210938}},
        -- --minZ = 45.127433776855,  --maxZ = 55.217365264893

        {{2141.1538085938, 5021.0424804688},{2116.9592285156, 4997.3876953125},{2099.1540527344, 5017.98828125},{2120.6376953125, 5037.7202148438}},
        -- --minZ = 40.972248077393,  --maxZ = 47.752170562744

        {{2218.05859375, 4931.4887695312},{2205.5407714844, 4924.6840820312},{2251.646484375, 4876.6494140625},{2265.8898925781, 4883.6489257812}},
        -- --minZ = 41.00354385376,  --maxZ = 47.4460105896        

    }, 

    Porc = {
        {{2285.0029296875, 4932.25},{2302.126953125, 4947.5249023438},{2315.4487304688, 4933.5380859375},{2298.7365722656, 4914.296875}},
        -- --minZ = 43.951156616211,  --maxZ = 48.629165649414

        {{2192.1889648438, 4976.1962890625},{2184.6840820312, 4984.3393554688},{2158.3127441406, 4958.5063476562},{2165.8063964844, 4949.4399414062}, },
        -- --minZ = 41.395034790039,  --maxZ = 60.600955963135
    },

}


Config.Jobs.boucher2 = {

    Permanent = {
        {  
            Etape = "viande_transfo_depose",

            Spawn = {
                Pos = vector3(967.9561, -2183.6426, 30.0213),
                Heading = 140.4875,
                
                idInterne = nomJob.."2_transfodepose",
                ServerSide = true,
                

                Ped = {
                    Model = "s_f_y_migrant_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    Blip = {
                        AddBlipForCoord = true, 
                        Icon = 280, -- radar_friend
                        SetBlipAsFriendly = true,
                        Name = "Boucher : Déposer la viande",
                        SetBlipDisplay = 4,
                        SetBlipAsShortRange = true,
                    }
                },
            },
        
            Action = {
                Condition = {
                    Target = {
                        Label = "Déposer la viande",

                        
                        Progress = {

                            Anim = {
                                type = "anim",
                                dict = "anim@amb@clubhouse@mini@darts@", 
                                lib = "wait_idle",
                            },
                            
                            FreezePlayer = true, 
                            Label = "Déposes la viande",
                        },

                        Transaction = {
                            {
                                Remove = { Item = "viande_boeuf", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                GiveServer = { Item = "viande_boeuf_emballe", Qte = 1, },
                            },
                            {
                                Remove = { Item = "viande_boeuf_qualite", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                GiveServer = { Item = "viande_boeuf_emballe", Qte = 5, },
                            },
                            {
                                Remove = { Item = "viande_porc", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                GiveServer = { Item = "viande_porc_emballe", Qte = 1, },
                            },
                            {
                                Remove = { Item = "viande_porc_qualite", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                GiveServer = { Item = "viande_porc_emballe", Qte = 5, },
                            },
                        },
                    }, 
                }, 

                
            },
        },

        {
            Etape = "viande_transfo_reprise",

            Spawn = {
                Pos = vector3(995.9519, -2186.6060, 29.9801),
                -- Pos = vector3( 2237.0234, 5153.5107, 56.9551 ),  --- position test
                Heading = 89.1730,

                idInterne = nomJob.."3_transforetour",
                ServerSide = true,
                

                Ped = {
                    Model = "s_m_m_migrant_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    Blip = {
                        AddBlipForCoord = true, 
                        Icon = 280, -- radar_friend
                        SetBlipAsFriendly = true,
                        Name = "Boucher : Récupérer la viande",
                        SetBlipDisplay = 4,
                        SetBlipAsShortRange = true,
                    }
                },
            },

          
            Action = {
                Condition = {
                    Target = {
                        Label = "Récupérer la viande emballée",
                        Icon = "hand-holding-box",

                        Progress = {

                            Anim = {
                                type = "anim",
                                dict = "anim@amb@clubhouse@mini@darts@", 
                                lib = "wait_idle",
                            },
                            
                            FreezePlayer = true, 
                            Label = "Récupères la viande",
                        },
        
                        Transaction = {
                            {
                                RemoveServer = { Item = "viande_boeuf_emballe", Qte = -1, },
                                Give = { Item = "viande_boeuf_emballe", Qte = 1, },
                            },
                            {
                                RemoveServer = { Item = "viande_porc_emballe", Qte = -1, },
                                Give = { Item = "viande_porc_emballe", Qte = 1, },
                            },
                        },
                    }, 
                }, 

                
                
            },

        },

        
        {
            Etape = "lait_transfo",
            
            Spawn = {
                -- Pos = vector3(2238.2708, 5156.9946, 57.6869),  -- debug
                Pos = vector3(1704.4043, 4737.2524, 42.1264),
                Heading = 216.8988,
                
                idInterne = nomJob.."2_transfolait",
                ServerSide = true,
                

                Ped = {
                    Model = "s_f_y_migrant_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",
                    
                    Blip = {
                        AddBlipForCoord = true, 
                        Icon = 280, -- radar_friend
                        SetBlipAsFriendly = true,
                        Name = "Boucher : Mise en bouteille",
                        SetBlipDisplay = 4,
                        SetBlipAsShortRange = true,
                    }
                },
            },
    

            Action = {
                Condition = {
                    Target = {
                        Label = "Mettre le lait en bouteille",
                        Icon = "bottle-droplet",

                        Progress = {

                            Anim = {
                                type = "anim",
                                dict = "anim@amb@clubhouse@mini@darts@", 
                                lib = "wait_idle",
                            },
                            
                            FreezePlayer = true, 
                            Label = "Mise en bouteille",
                        },
        
                        Transaction = {
                            {
                                Remove = { Item = "lait", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                Give = { Item = "lait_bouteille", Qte = 1, },
                            },
                            {
                                Remove = { Item = "lait_qualite", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                Give = { Item = "lait_bouteille", Qte = 5, },
                            },
                        }
                    }, 
                }, 

                
                
            },
        },   


        { -- Vente
            Etape = "vente",

            Spawn = {
                Pos = vector3(-603.0498, -1032.3932, 21.7875),
                -- Pos = vector3(2236.5134, 5155.2202, 57.2395 ),  --- position test
                Heading = 104.6607,

                idInterne = nomJob.."global_vente",
                ServerSide = true,
                

                Ped = {
                    Model = "s_m_m_strvend_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    Blip = {
                        AddBlipForCoord = true, 
                        Icon = 500, -- radar_production_money
                        SetBlipAsFriendly = true,
                        Name = "Boucher : Vente",
                        SetBlipDisplay = 4,
                        SetBlipAsShortRange = true,
                    }
                },
            },
        

            Action = {
                Condition = {
                    Target = {
                        Label = "Vendre la marchandise",
                        Icon = "money-bill",

                        Progress = {

                            Anim = {
                                type = "anim",                    --   "mp_common", "givetake1_a"
                                dict = "anim@amb@clubhouse@mini@darts@", 
                                lib = "wait_idle",
                            },
                            
                            FreezePlayer = true, 
                            Label = "Vente de la marchandise",
                        },
        
                        Transaction = {
                            {
                                Remove = { Item = "viande_boeuf_emballe", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                Pay = { Qte = 100, },
                            },
                            {
                                Remove = { Item = "viande_porc_emballe", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                Pay = { Qte = 100, },
                            },
                            {
                                Remove = { Item = "lait_bouteille", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                Pay = { Qte = 100, },
                            },                        
                        },
                    }, 
                }, 

                
  
            },
    
        },

        { -- Prise de service
            Etape = "priseservice",

            Spawn = {
                Pos = vector3(2243.4351, 5154.3672, 57.8871),
                Heading = 129.8723,
                
                idInterne = nomJob.."1_prisedeservice",
                ServerSide = true,
                

                Ped = {
                    Model = "a_m_m_farmer_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    Blip = {
                        AddBlipForCoord = true, 
                        Icon = 280, -- radar_friend
                        SetBlipAsFriendly = true,
                        Name = "Boucher : Prise de service",
                        SetBlipDisplay = 4,
                        SetBlipAsShortRange = true,
                    }
                },
            },
        

            Action = {
                Condition = {

                    Target = {
                        {
                            Label = "Prendre le service : Lait",
                            Icon = "cow",
                            GoTo = {
                                Tache = "lait",
                                Notification = "On a besoin de Lait, vas m'en récupérer là-bas",
                                EtapeSet = 2,
                            },
                        },
                        {
                            Label = "Prendre le service : Boeuf",
                            Icon = "steak",
                            GoTo = {
                                Tache = "boeuf",
                                Notification = "On a besoin de Viande de boeuf, vas m'en récupérer là-bas",
                                EtapeSet = 2,
                            },
                        },
                        {
                            Label = "Prendre le service : Porc",
                            Icon = "meat",
                            GoTo = {
                                Tache = "porc",
                                Notification = "On a besoin de Viande de porc, vas m'en récupérer là-bas",
                                EtapeSet = 2,
                            },
                        },                      
                    }, 

                }, 
            },
        },
    },

    Etapes = {

        { --Vestiaire / prise de service
            Etape = 1,

            default = {
                GoToStep = {
                    Notification = "La boucherie a besoin de main d'oeuvre, va demander au contre-maitre",
                    GPS = vector2(2242.9902, 5153.3359),
                },
            },
        },

        { --Recolte = {
            Etape = 2,


            boeuf = {

                -- PolyZoneRandom = { 
                --     name = app.."recolte", 
                --     type = "CircleZone", 
                --     Radius = Commun.Radius +10,                -- 10 au dela de la zone de spawn pour bien détecter la sortie de zone

                --     Zones = Commun.Zones.Boeuf,
                -- },

                Polygone = Commun.Zones.Boeuf,


                DisplayRadar = true,

                Action = {
                    Spawn = {
                        MaxCycles = Commun.MaxCycles,  -- 15
                        
                        Ped = {
                            Model = "a_c_cow",                  -- https://docs.fivem.net/docs/game-references/ped-models/
                            ServerSide = false,
                            Mode = "net",
                            GetGroundZFor_3dCoord = true,
                            
                            Blip = {
                                AddBlipForEntity = true, 

                                SetBlipAsFriendly = true,
                                Name = "Boucher : Récolte", 
                                SetBlipDisplay = 2,             -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                                -- SetBlipAsShortRange = true,
                            },

                            Target = {
                                Icon = "steak",
                                Label = "Récupérer de la viande",
                            },
        
                        },
                    },

                    
                    Progress = {
                        Anim = {
                            type = "anim",
                            dict = "amb@code_human_cower@male@base", 
                            lib = "base",
                        },
                        
                        FreezePlayer = true, 
                        Label = "Récupères de la viande",
                    },

                    -- GoTo = {    Tache = "viande",   }, 

                    Transaction = {
                        {
                            Remove = nil,
                            Give = {
                                { Item = "viande_boeuf", Qte = Commun.QteRecolte, Poids = 1000, Cooldown = Commun.CooldownRecolte },
                                { Item = "viande_boeuf_qualite", Qte = 1, Poids = 1, Cooldown = Commun.CooldownRecolte},
                            },
                        },
                    },
                },
            },

            lait = {

                -- PolyZoneRandom = { 
                --     name = app.."recolte", 
                --     type = "CircleZone", 
                --     Radius = Commun.Radius + 10,                -- 10 au dela de la zone de spawn pour bien détecter la sortie de zone
                --     Zones = Commun.Zones.Boeuf,
                -- },

                Polygone = Commun.Zones.Boeuf,

                DisplayRadar = true,

                Action = {
                    Spawn = {
                        MaxCycles = Commun.MaxCycles,  -- 15
                        
                        Ped = {
                            Model = "a_c_cow",                  -- https://docs.fivem.net/docs/game-references/ped-models/
                            ServerSide = false,
                            Mode = "net",
                            
                            GetGroundZFor_3dCoord = true,
                            
                            Blip = {
                                AddBlipForEntity = true, 
                                SetBlipAsFriendly = true,
                                Name = "Boucher : Récolte", 
                                SetBlipDisplay = 2,             -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                                SetBlipAsShortRange = true,
                                SetBlipPriority = 100,
                            },

                            Target = {
                                Icon = "cow",
                                Label = "Traire la vache",
                            },
        
                        },
                    },

                    
                    Progress = {
                        Anim = {
                            type = "anim",
                            dict = "amb@code_human_cower@male@base", 
                            lib = "base",
                        },
                        
                        FreezePlayer = true, 
                        Label = "Récupères le lait",
                    },

                    Transaction = {
                        {
                            Remove = nil,
                            Give = {
                                { Item = "lait", Qte = Commun.QteRecolte, Poids = 1000, Cooldown = Commun.CooldownRecolte },
                                { Item = "lait_qualite", Qte = 1, Poids = 10, Cooldown = Commun.CooldownRecolte},
                            },
                        },
                    },
                },
            },

            porc = {

                -- PolyZoneRandom = { 
                --     name = app.."recolte", 
                --     type = "CircleZone", 
                --     Radius = Commun.Radius + 10,                -- 10 au dela de la zone de spawn pour bien détecter la sortie de zone

                --     Zones = Commun.Zones.Porc,
                -- },

                Polygone = Commun.Zones.Porc,

                DisplayRadar = true,

                Action = {
                    Spawn = {
                        MaxCycles = Commun.MaxCycles,  -- 15
                        
                        Ped = {
                            Model = "a_c_pig",                  -- https://docs.fivem.net/docs/game-references/ped-models/
                            ServerSide = false,
                            Mode = "net",
                            
                            GetGroundZFor_3dCoord = true,
                            
                            Blip = {
                                AddBlipForEntity = true, 
                                -- Icon = 2, -- radar_lower
                                SetBlipAsFriendly = true,
                                Name = "Boucher : Récolte", 
                                SetBlipDisplay = 2,             -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                                SetBlipAsShortRange = true,
                                SetBlipPriority = 100,
                            },

                            Target = {
                                Icon = "meat",
                                Label = "Récupérer de la viande",
                            },
        
                        },
                    },

                    
                    Progress = {
                        Anim = {
                            type = "anim",
                            dict = "amb@code_human_cower@male@base", 
                            lib = "base",
                        },
                        
                        FreezePlayer = true, 
                        Label = "Récupères de la viande",
                    },

                    -- GoTo = {    Tache = "viande",   }, 
                    
                    Transaction = {
                        {
                            Remove = nil,
                            Give = {
                                { Item = "viande_porc", Qte = Commun.QteRecolte, Poids = 1000, Cooldown = Commun.CooldownRecolte },
                                { Item = "viande_porc_qualite", Qte = 1, Poids = 10, Cooldown = Commun.CooldownRecolte},
                            },
                        },
                    },
                },
            },
        },
    }
}