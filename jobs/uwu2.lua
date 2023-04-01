
local nomJob = "uwu2_"


local Commun = {}
Commun.MaxCycles = 4    -- 15
Commun.QteRecolte = {1,2}  --{1,2}
Commun.CooldownRecolte = 4 * 1000

Commun.Points = {
    
    BaraqueFruits = {
        vector3 (-1043.46924, 5326.102, 43.6015),
        vector3 (-1380.7666, 734.592834, 181.965759),
        vector3 (-1553.51611, 1373.58557, 125.759956),
        vector3 (-2510.07471, 3615.43823, 12.6518145),
        vector3 (-3026.03638, 369.674927, 13.5692978),
        vector3 (-458.8947, 2863.29419, 34.10668),
        vector3 (1045.17322, 696.9411, 157.8391),
        vector3 (1088.16663, 6510.43652, 20.07833),
        vector3 (1263.157, 3547.17456, 34.1465874),
        vector3 (1476.846, 2723.04443, 36.64265),
        vector3 (149.080566, 1669.90137, 227.688675),
        vector3 (2474.28955, 4445.74951, 34.3875275),
        vector3 (2527.41162, 2038.05542, 18.80867),
    },

    Hamburger = {
        vector3 (-1233.102, -1486.16052, 3.370811),
        vector3 (-1268.60669, -1434.20935, 3.353512),
        vector3 (-1692.64355, -1135.11926, 12.1433067),
        vector3 (-1694.761, -1072.51941, 12.0125084),
        vector3 (-1785.74048, -1175.47961, 12.0172691),
        vector3 (-1856.30225, -1223.41248, 12.0172691),
        vector3 (245.265945, 163.195892, 103.945236),
        vector3 (404.8329, 105.872932, 100.374619),
        vector3 (822.927, -2976.33032, 5.018059),
    },

    Hotdog = {
        vector3 (-1221.01343, -1504.70581, 3.370811),
        vector3 (-1248.62634, -1473.69983, 3.257412),
        vector3 (-1285.17676, -1697.57483, 1.934682),
        vector3 (-1322.23352, -1653.38159, 1.791185),
        vector3 (-1407.26184, -1494.77124, 1.745582),
        vector3 (-1515.91309, -951.260254, 8.328915),
        vector3 (-1630.15234, -1076.751, 12.0172691),
        vector3 (-1637.45557, -1083.62317, 12.0526543),
        vector3 (-1684.05664, -1124.66858, 12.1475945),
        vector3 (-1720.64209, -1103.36829, 12.0133438),
        vector3 (-1772.72681, -1160.243, 12.0179558),
        vector3 (-1835.7417, -1233.31372, 12.0179558),
        vector3 (240.669724, 166.028931, 104.057434),
        vector3 (823.0388, -2973.354, 5.01828),
    },

    RestoAmbulant = {       --- Attention soumis au CarGenerator
        vector3 (-1041.35376, -519.5451, 36.2450638 ),
        vector3 (-1074.08252, -468.291016, 36.8681335 ),
        vector3 (-1157.353, -521.8199, 32.78885 ),
        vector3 (-1211.198, -2052.00366, 14.6418524 ),
        vector3 (-1215.93286, -2066.06226, 14.6334372 ),
        vector3 (-1354.08667, -1024.88855, 8.211914 ),
        vector3 (-2299.69141, 428.422852, 174.656082 ),
        vector3 (-271.5581, 6074.043, 31.6318665 ),
        vector3 (-2973.913, 20.7411613, 7.550224 ),
        vector3 (151.687012, 6505.56348, 31.7861328 ),
        vector3 (1604.24036, 3828.157, 34.44756 ),
        vector3 (1606.96252, 3823.92749, 34.8031921 ),
        vector3 (1745.15, 3901.51221, 35.0447845 ),
        vector3 (1968.86829, 3260.495, 45.8442879 ),
        vector3 (1983.81934, 3706.56177, 32.5184174 ),
        vector3 (2013.72168, 3126.96313, 46.93247 ),
        vector3 (2017.20557, 3130.59131, 46.78145 ),
        vector3 (2083.22583, 3554.63745, 42.1929474 ),
        vector3 (2410.86279, 4297.76172, 35.3058243 ),
        vector3 (2464.54736, 3829.54468, 40.2104454 ),
        vector3 (2527.00024, 4866.63135, 38.5650673 ),
    }
}


Config.Jobs.uwu2 = {
    
    Etapes = {
        
        { --Vestiaire / prise de service
            Etape = 1,

            default = {
                GoToStep = {
                    Notification = "Prenez votre bon de livraisons au guichet",
                    GPS = vector2(  814.0189, -1645.4144  ),
                },
            },
        },
        { --Recolte = {
            Etape = 2,


            default = {
                -- Livraison des baraques à fruits le long de la route

                Points = Commun.Points.BaraqueFruits,

                DisplayRadar = true,

                Action = {
                    Spawn = {

                        Radius = 5,
                        MaxCycles = Commun.MaxCycles, 

                        Notification = "Voici le prochain magasin à livrer",
                        
                        TargetModelZone = {
                            Model = "prop_fruitstand_b",
                            ModelHash = { 858993389, -2007742866, },

                            Blip = {
                                -- Icon = 2, -- radar_lower
                                SetBlipAsFriendly = true,
                                Name = "Livraison : Fruits", 
                                SetBlipDisplay = 2,
                                -- SetBlipAsShortRange = true,
                                SetBlipRoute = true,
                            },

                            Target = {
                                Label = "Livrer les fruits",
                                Icon = "apple-whole",
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
                        Label = "Livre les fruits",
                    },

                    Transaction = {
                        {
                            Remove = { Item = "pomme", Qte = Commun.QteRecolte, Poids = 1000, Cooldown = Commun.CooldownRecolte },
                            Pay = { Qte = 100, },
                        },
                    },
                },
            },

            hotdog = {
                
                Points = Commun.Points.Hotdog,

                DisplayRadar = true,

                Action = {
                    Spawn = {

                        Radius = 5,
                        MaxCycles = Commun.MaxCycles, 

                        Notification = "Voici le prochain magasin à livrer",
                        
                        TargetModelZone = {
                            -- Model = "prop_food_van_02, prop_food_van_01",
                            ModelHash = { 1257426102, -272361894, },

                            Blip = {
                                -- Icon = 2, -- radar_lower
                                SetBlipAsFriendly = true,
                                Name = "Livraison : Fruits", 
                                SetBlipDisplay = 2,
                                SetBlipAsShortRange = true,
                                SetBlipPriority = 100,
                                SetBlipRoute = true,
                            },

                            Target = {
                                Label = "Livrer les fruits",
                                Icon = "apple-whole",
                            },
                        },
                        
                    },

                    Progress = {
                        Anim = {
                            type = "anim",
                            dict = "amb@code_human_cower@male@base", 
                            lib = "base",
                        },


                        -- Anim = {
                        --     type = "Scenario",
                        --     Scenario = "WORLD_HUMAN_MUSCLE_FLEX", 
                        -- },
                        
                        FreezePlayer = true, 
                        Label = "Livre les fruits",
                    },

                    Transaction = {
                        {
                            Remove = { Item = "pomme", Qte = Commun.QteRecolte, Poids = 1000, Cooldown = Commun.CooldownRecolte },
                            Pay = { Qte = 100, },
                        },
                    },
                },
            },

        },
    },

    Permanent = {
        
        { -- Prise de service
            Etape = "priseservice",

            Spawn = {
                Pos = vector3(  814.0189, -1645.4144, 30.8954  ),
                Heading = 251.2054,
                
                idInterne = nomJob.."1_prisedeservice",
                ServerSide = true,

                Ped = {
                    Model = "csb_bryony",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    -- TaskStartScenarioInPlace = "CODE_HUMAN_POLICE_INVESTIGATE",

                    Blip = {
                        Icon = 280, -- radar_friend
                        SetBlipAsFriendly = true,
                        Name = "Livraison : Prise de service",
                        SetBlipDisplay = 4,
                        SetBlipAsShortRange = true,
                    }
                },
            },
        

            Action = {
                Condition = {

                    Target = {
                        {
                            Label = "Prendre le service",
                            Icon = "apple-whole",
                            GoTo = {
                                Tache = "fruits",
                                EtapeSet = 2,
                            },
                        },
                    }, 
                }, 
            },
        },
        
        -- { -- Vente
        --     Etape = "vente",

        --     Spawn = {
        --         Pos = vector3(  2244.9709, 5171.811, 59.5964  ),
        --         Heading = 50.9996,

        --         idInterne = nomJob.."global_vente",
        --         ServerSide = true,

        --         Ped = {
        --             Model = "s_m_m_dockwork_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
        --             Mode = "local",

        --             Blip = {
        --                 Icon = 500, -- radar_production_money
        --                 SetBlipAsFriendly = true,
        --                 Name = "Récolte : Vente",
        --                 SetBlipPriority = 100,
        --             }
        --         },
        --     },
        

        --     Action = {
        --         Condition = {
        --             Target = {
        --                 Label = "Vendre la marchandise",
        --                 Icon = "money-bill",
        --             }, 
        --         }, 

                
        --         Progress = {
        --             Anim = {
        --                 type = "anim",                    --   "mp_common", "givetake1_a"
        --                 dict = "anim@amb@clubhouse@mini@darts@", 
        --                 lib = "wait_idle",
        --             },
                    
        --             FreezePlayer = true, 
        --             Label = "Vente de la marchandise",
        --         },

        --         Transaction = {
        --             {
        --                 Remove = { Item = "pomme_lave", Qte = -1, Cooldown = 1.5 * 1000,}, 
        --                 Pay = { Qte = 100, },
        --             },
        --             {
        --                 Remove = { Item = "orange_lave", Qte = -1, Cooldown = 1.5 * 1000,}, 
        --                 Pay = { Qte = 100, },
        --             },
        --             {
        --                 Remove = { Item = "tomate_lave", Qte = -1, Cooldown = 1.5 * 1000,}, 
        --                 Pay = { Qte = 100, },
        --             },                        
        --         },
        --     },
    
        -- },
    },

}
