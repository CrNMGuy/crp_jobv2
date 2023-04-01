


local nomJob = "agriculteur2_"


local Commun = {}
Commun.MaxCycles = 2    -- 15
Commun.QteRecolte = 10  --{1,2}
Commun.CooldownRecolte = 0.1 * 1000
Commun.Zones = { 

    Champs = {

        {{2187.5087890625, 5153.3959960938},{2136.6857910156, 5209.4892578125},{2109.2841796875, 5198.7133789062},{2163.1066894531, 5140.3413085938}},
        --minZ = 50.482105255127,  --maxZ = 58.100677490234

        {{2263.9445800781, 5135.5625},{2295.1564941406, 5165.7978515625},{2349.6772460938, 5117.4272460938},{2319.0344238281, 5099.19140625}},
        --minZ = 49.551666259766,  --maxZ = 60.974700927734

        {{2049.2104492188, 4972.21484375},{2022.3049316406, 4944.7548828125},{2037.9146728516, 4915.2705078125},{2067.5358886719, 4943.716796875}},
        --minZ = 46.330738067627,  --maxZ = 54.353824615479

        {{1961.6690673828, 4878.515625},{1976.8323974609, 4865.4145507812},{1952.3531494141, 4837.6806640625},{1929.9962158203, 4846.5952148438}},
        --minZ = 46.627292633057,  --maxZ = 55.646167755127

    },
}


Config.Jobs.agriculteur2 = {
    Permanent = {
        

        { -- Prise de service
            Etape = "priseservice",

            Spawn = {
                Pos = vector3( 2242.8948, 5168.1245, 59.136  ),
                Heading = 129.8723,
                
                idInterne = nomJob.."1_prisedeservice",
                ServerSide = true, 


                Ped = {
                    Model = "a_m_m_farmer_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    Blip = {
                        Icon = 280, -- radar_friend
                        SetBlipAsFriendly = true,
                        Name = "Agriculteur : Prise de service",
                        SetBlipDisplay = 4,
                        SetBlipAsShortRange = true,
                    }
                },
            },
        

            Action = {
                Condition = {

                    Target = {
                        {
                            Label = "Prendre le service : Salade",
                            Icon = "fa-solid fa-salad",
                            GoTo = {
                                Tache = "salade",
                                Notification = "On a besoin de Salades, vas m'en récupérer là-bas",
                                EtapeSet = 2,
                            },
                        },
                        {
                            Label = "Prendre le service : Blé",
                            Icon = "fa-solid fa-corn",
                            GoTo = {
                                Tache = "ble",
                                Notification = "On a besoin de Blé, vas m'en récupérer là-bas",
                                EtapeSet = 2,
                            },
                        },
                        {
                            Label = "Prendre le service : Pomme de terre",
                            Icon = "fa-solid fa-potato",
                            GoTo = {
                                Tache = "patate",
                                Notification = "On a besoin de Pommes de terre, vas m'en récupérer là-bas",
                                EtapeSet = 2,
                            },
                        },                      
                    }, 

                }, 
                

            },

        },
        { -- Vente
            Etape = "vente",

            Spawn = {
                Pos = vector3(  2245.094, 5169.8154, 59.1548  ),
                Heading = 50.9996,

                idInterne = nomJob.."global_vente",
                ServerSide = true,
                Mode = "local",

                Ped = {
                    Model = "s_m_m_dockwork_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    Blip = {
                        Icon = 500, -- radar_production_money
                        SetBlipAsFriendly = true,
                        Name = "Agriculteur : Vente",
                        SetBlipPriority = 100,
                    }
                },
            },
        

            Action = {
                Condition = {
                    Target = {
                        Label = "Vendre la marchandise",
                    }, 
                }, 

                
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
                        Remove = { Item = "salade_lave", Qte = -1, Cooldown = 1.5 * 1000,}, 
                        Pay = { Qte = 100, },
                    },
                    {
                        Remove = { Item = "ble_lave", Qte = -1, Cooldown = 1.5 * 1000,}, 
                        Pay = { Qte = 100, },
                    },
                    {
                        Remove = { Item = "patate_lave", Qte = -1, Cooldown = 1.5 * 1000,}, 
                        Pay = { Qte = 100, },
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
                    Notification = "La ferme a besoin de main d'oeuvre, va demander au contre-maitre",
                    GPS = vector2( 2242.8948, 5168.1245 ),
                },
            },
        },

        { --Recolte = {
            Etape = 2,

            default = {

                Polygone = Commun.Zones.Champs,

                DisplayRadar = true,

                Action = {
                    Spawn = {
                        MaxCycles = Commun.MaxCycles,  -- 15
                        Mode = "net",

                        Prop = {
                            Model = "prop_pot_plant_inter_03a", 
                            Mode = "net",

                            ServerSide = false,
                            
                            Blip = {
                                -- Icon = 2, -- radar_lower
                                SetBlipAsFriendly = true,
                                Name = "Agriculture : Récolte", 
                                SetBlipDisplay = 2,             -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                                SetBlipAsShortRange = true,
                                SetBlipPriority = 100,
                            },

                            Target = {
                                Label = "Ramasser une salade",
                                Icon = "fa-solid fa-salad",
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
                        Label = "Ramasses une salade",
                    },

                    Transaction = {
                        {
                            Remove = nil,
                            Give = {
                                { Item = "salade", Qte = Commun.QteRecolte, Poids = 1000, Cooldown = Commun.CooldownRecolte },
                            },
                        },
                    },
                },
            },
        },
    },
}
