


local nomJob = "mineur2_"


local Commun = {}
Commun.MaxCycles = 3    -- 15
Commun.QteRecolte = {1,3}  --{1,2}
Commun.CooldownRecolte = 0.1 * 1000
Commun.Zones = { 

    Mine = {
        {{2956.3251953125, 2803.8100585938},{2969.5537109375, 2799.6752929688},{2979.1213378906, 2786.3083496094},{2963.7570800781, 2773.1286621094},{2938.3642578125, 2764.0939941406},{2918.0529785156, 2798.9995117188},{2931.1262207031, 2819.4716796875},{2948.7834472656, 2825.9672851562},{2961.8151855469, 2817.5029296875},},
        --minZ = 39.598339080811, --maxZ = 46.396465301514
      
    },
}


Config.Jobs.mineur2 = {
    Permanent = {
        
        { -- Prise de service
            Etape = "priseService",

            Spawn = {
                Pos = vector3( 2964.4253, 2760.2573, 43.1969   ),
                Heading = 50.9996,

                idInterne = nomJob.."prisedeservice",
                ServerSide = true,

                Ped = {
                    Model = "s_m_m_dockwork_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    Blip = {
                        Icon = 500, -- radar_production_money
                        SetBlipAsFriendly = true,
                        Name = "Mineur : Prise de service",
                        SetBlipDisplay = 4,
                        SetBlipAsShortRange = true,
                    }
                },
            },
            
            Action = {
                Condition = {
                    Target = {
                        Label = "Prendre le service",

                        GoTo = {
                            {
                                Notification = "On a besoin de Pierres, vas m'en récupérer là-bas",
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
                Pos = vector3(2832.2754, 2798.0798, 57.454 ),
                Heading = 104.6607,

                idInterne = nomJob.."global_vente",
                ServerSide = true,

                Ped = {
                    Model = "cs_joeminuteman",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    Blip = {
                        Icon = 280, -- radar_production_money
                        SetBlipAsFriendly = true,
                        Name = "Mineur : Vente",
                        SetBlipDisplay = 4,
                        SetBlipAsShortRange = true,
                    }
                },
            },
        

            Action = {
                Condition = {
                    Target = {
                        Label = "Vendre la marchandise",

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
                                Remove = { Item = "pierre", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                Pay = { Qte = 100, },
                            },
                            {
                                Remove = { Item = "minerai_or", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                Pay = { Qte = 200, },
                            },
                            {
                                Remove = { Item = "minerai_diamant", Qte = -1, Cooldown = 1.5 * 1000,}, 
                                Pay = { Qte = 1500, },
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
                    Notification = "La mine a besoin de main d'oeuvre, va demander au contre-maitre",
                    GPS = vector2( 2963.1758, 2760.9167 ),
                },
            },
        },
        

        { --Recolte = {
            Etape = 2,


            default = {

                Polygone = Commun.Zones.Mine,

                DisplayRadar = true,

                Action = {
                    Spawn = {
                        MaxCycles = Commun.MaxCycles,  -- 15

                        Prop = {
                            Model = {"prop_rock_1_b", "prop_rock_1_a", "prop_rock_1_c", "prop_rock_1_d", "prop_rock_1_e", "prop_rock_1_f", "prop_rock_1_g", "prop_rock_1_h"},
                            -- https://gta-objects.xyz/objects/search?text=rock&page=2

                            ServerSide = false,
                            Mode = "net",
                            
                            Blip = {
                                -- Icon = 2, -- radar_lower
                                SetBlipAsFriendly = true,
                                Name = "Mineur : Récolte", 
                                SetBlipDisplay = 2,             -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                                SetBlipAsShortRange = true,
                                SetBlipPriority = 100,
                            },

                            Target = {
                                Label = "Taper dans la roche",
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
                        Label = "Récupères des pierres",
                    },
                    
                    Transaction = {
                        {
                            Remove = nil,
                            Give = {
                                { Item = "pierre", Qte = Commun.QteRecolte, Poids = 1000, Cooldown = Commun.CooldownRecolte },
                                { Item = "minerai_or", Qte = 1, Poids = 10, Cooldown = Commun.CooldownRecolte},
                                { Item = "minerai_diamant", Qte = 1, Poids = 1, Cooldown = Commun.CooldownRecolte},
                            },
                        },
                    },
                },
            },

        },

    },

}
