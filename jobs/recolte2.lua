


local nomJob = "recolte2_"


local Commun = {}
Commun.MaxCycles = 2    -- 15
Commun.QteRecolte = {8,10}  --{1,2}
Commun.CooldownRecolte = 0.1 * 1000
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
}

Commun.Points = {

    Radius = 2,
    
    PommeOrange = {
        {
            vector2(2304.5061, 4996.4785),
            vector2(2317.2949, 4984.4594),
            vector2(2317.4143, 4993.8291),
            vector2(2317.3593, 5008.7231),
            vector2(2316.2944, 5024.0356),
            vector2(2329.2595, 5036.4345),
            vector2(2329.8203, 5021.9262),
            vector2(2331.1584, 5007.2338),
            vector2(2331.2548, 4996.9321),
            vector2(2335.8847, 4976.3793),
            vector2(2348.6396, 4975.5849),
            vector2(2349.4323, 4989.0375),
            vector2(2344.8959, 5007.6049),
            vector2(2344.0954, 5022.2768),
            vector2(2341.8669, 5035.5214),
            vector2(2356.7314, 5020.2929),
            vector2(2360.3496, 5002.8369),
            vector2(2360.9748, 4988.7016),
            vector2(2361.7729, 4976.9169),
            vector2(2374.1428, 4988.5009),
            vector2(2369.0129, 5010.5644),
            vector2(2375.9643, 5016.3530),
            vector2(2377.3906, 5004.7651),
            vector2(2390.1728, 5004.5795),
            vector2(2389.9868, 4992.9677)
        }, 
        --minZ = 41.8045,  --maxZ = 45.7562


        {
            vector2(2327.8757, 4771.3515),
            vector2(2326.0949, 4762.2041),
            vector2(2324.1669, 4747.1142),
            vector2(2339.0617, 4740.8388),
            vector2(2343.2104, 4756.0078),
            vector2(2339.8356, 4766.8583),
            vector2(2352.7067, 4760.7504),
            vector2(2350.4208, 4734.5498),
            vector2(2358.6813, 4723.6899),
            vector2(2364.7141, 4729.2016),
            vector2(2367.2685, 4750.4199),
            vector2(2374.5886, 4735.6596),
            vector2(2386.4414, 4736.0883),
            vector2(2386.4472, 4724.7075),
            vector2(2401.3867, 4716.7934),
            vector2(2411.7807, 4707.9638),
            vector2(2423.6574, 4698.2783),
            vector2(2433.8715, 4678.9584),
            vector2(2443.0690, 4671.9409),
            vector2(2424.5112, 4659.1821),
            vector2(2419.2485, 4673.7788),
            vector2(2406.9980, 4676.3095),
            vector2(2401.9694, 4687.8203),
            vector2(2390.4345, 4691.0317),
            vector2(2404.9172, 4703.4023),
            vector2(2382.0168, 4701.1293),
            vector2(2383.7490, 4713.1059),
            vector2(2367.3642, 4716.0883)
        },
        --minZ = 33.0001,   --maxZ = 36.0762

        {
            vector2(2122.4279, 4883.8940),
            vector2(2145.9206, 4867.9145),
            vector2(2122.5026, 4861.4218),
            vector2(2117.1870, 4841.5825),
            vector2(2098.8940, 4841.3994),
            vector2(2086.5720, 4826.0610),
            vector2(2064.1914, 4820.0219),
            vector2(2059.8132, 4842.9223),
            vector2(2082.8066, 4853.2197),
            vector2(2102.4912, 4877.9477),
            vector2(2031.6026, 4802.1586),
            vector2(2016.3653, 4800.8422),
            vector2(2003.6319, 4787.3881),
            vector2(1981.4144, 4771.4541)
        },
        --minZ = 40.6511,   --maxZ = 41.9905
    },

    Tomate = {
        {
            vector2(1936.6268, 5010.5937),
            vector2(1937.5957, 5011.2998),
            vector2(1935.4240, 5009.4443),
            vector2(1934.2852, 5008.4702),
            vector2(1932.9332, 5007.3178),
            vector2(1932.2633, 5006.7001),
            vector2(1904.5952, 4983.2192),
            vector2(1903.4517, 4982.2431),
            vector2(1902.3189, 4981.2822),
            vector2(1901.0612, 4980.2944),
            vector2(1900.1076, 4979.3989),
            vector2(1898.8917, 4978.3208),
            vector2(1892.3061, 4980.3173),
            vector2(1893.4425, 4981.2021),
            vector2(1894.3897, 4982.1308),
            vector2(1895.5832, 4983.0810),
            vector2(1896.9855, 4984.2192),
            vector2(1898.1381, 4985.2011),
            vector2(1931.5721, 5013.8056),
            vector2(1932.6441, 5014.6899),
            vector2(1934.0408, 5015.8769),
            vector2(1934.9564, 5016.6669),
            vector2(1936.3800, 5017.8325),
            vector2(1937.2111, 5018.6230),
            vector2(1883.2187, 4999.7397),
            vector2(1881.9958, 4998.6499),
            vector2(1880.6163, 4997.5961),
            vector2(1879.4599, 4996.6157),
            vector2(1878.3652, 4995.6884),
            vector2(1877.1677, 4994.6694),
            vector2(1883.3400, 4991.3183),
            vector2(1884.9050, 4992.6523),
            vector2(1886.5654, 4994.0659),
            vector2(1887.7398, 4995.0654),
            vector2(1889.0888, 4996.2158)
        },
        --minZ = 42.9673,  --maxZ = 52.3338

        {
            vector2(1876.6145, 5028.2187),
            vector2(1875.2988, 5027.1494),
            vector2(1876.9930, 5028.6098),
            vector2(1878.6015, 5029.9824),
            vector2(1879.7196, 5030.9379),
            vector2(1880.7954, 5031.8530),
            vector2(1858.6369, 5021.3671),
            vector2(1860.0643, 5022.5795),
            vector2(1860.6972, 5023.1166),
            vector2(1861.9266, 5024.1723),
            vector2(1863.2042, 5025.2661),
            vector2(1864.2843, 5026.1962),
            vector2(1847.2812, 5023.6987),
            vector2(1848.3874, 5024.6445),
            vector2(1849.3238, 5025.4169),
            vector2(1850.6085, 5026.4067),
            vector2(1851.8768, 5027.6376),
            vector2(1852.8454, 5028.4599),
            vector2(1842.2397, 5028.0581),
            vector2(1843.7739, 5029.3774),
            vector2(1844.3973, 5029.9130),
            vector2(1845.7492, 5031.0673),
            vector2(1847.1528, 5032.2651),
            vector2(1848.2445, 5033.3276),
            vector2(1830.0023, 4998.3393),
            vector2(1828.9859, 4997.5205),
            vector2(1827.5264, 4996.2856),
            vector2(1826.5212, 4995.4248),
            vector2(1825.6981, 4994.7275),
            vector2(1824.0988, 4993.4248),
            vector2(1834.3912, 4993.6206),
            vector2(1833.0854, 4992.5053),
            vector2(1832.0246, 4991.5976),
            vector2(1830.8669, 4990.6186),
            vector2(1829.8154, 4989.7333),
            vector2(1828.9790, 4988.9375)
        },
        --minZ = 49.7460,  --maxZ = 56.3016

        {
            vector2(1809.8624, 5010.4086),
            vector2(1811.2189, 5011.5751),
            vector2(1812.9826, 5013.0800),
            vector2(1814.3258, 5014.2207),
            vector2(1815.3455, 5015.0810),
            vector2(1810.3500, 5021.9907),
            vector2(1809.1867, 5021.0029),
            vector2(1808.0417, 5020.0283),
            vector2(1806.9737, 5019.0771),
            vector2(1805.8105, 5018.1196),
            vector2(1804.5521, 5017.0429),
            vector2(1806.0054, 5026.6992),
            vector2(1804.8568, 5025.7226),
            vector2(1803.6705, 5024.7060),
            vector2(1802.3850, 5023.6098),
            vector2(1801.3933, 5022.8066),
            vector2(1800.0064, 5021.5854),
            vector2(1796.2623, 5018.1152),
            vector2(1795.3101, 5017.3105),
            vector2(1793.9074, 5016.1083),
            vector2(1793.0322, 5015.3627),
            vector2(1791.1373, 5013.7543),
            vector2(1828.2008, 5045.2104),
            vector2(1829.8323, 5046.5786),
            vector2(1830.5181, 5047.1660),
            vector2(1831.0882, 5047.6606),
            vector2(1832.6667, 5049.0039),
            vector2(1833.8945, 5050.0629),
            vector2(1832.2410, 5039.8037),
            vector2(1833.2277, 5040.9990),
            vector2(1834.3293, 5041.9409),
            vector2(1835.4212, 5042.8774),
            vector2(1836.7159, 5043.9794),
            vector2(1837.5323, 5044.6816)
        },
        --minZ = 55.1500,   --maxZ = 58.7432

    },

}


Config.Jobs.recolte2 = {
    

    Etapes = {
        
        { --Vestiaire / prise de service
            Etape = 1,

            default = {
                GoToStep = {
                    Notification = "La ferme a besoin de main d'oeuvre, va demander au contre-maitre",
                    GPS = vector2( 2099.1526, 4890.0063 ),
                },
            },
        },
        { --Recolte = {
            Etape = 2,


            pomme = {

                Points = Commun.Points.PommeOrange , 

                DisplayRadar = true,

                Action = {
                    Spawn = {
                        Radius = Commun.Points.Radius,  
                        MaxCycles = Commun.MaxCycles, 
                        
                        -- Prop = {
                        --     Model = "prop_ld_dstpillar_03",

                        --     ServerSide = false,
                            
                        --     Blip = {
                        --         -- Icon = 2, -- radar_lower
                        --         SetBlipAsFriendly = true,
                        --         Name = "Mineur : Récolte", 
                        --         SetBlipDisplay = 2,             -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                        --         SetBlipAsShortRange = true,
                        --         SetBlipPriority = 100,
                        --     },

                        --     Target = {
                        --         Label = "Récupérer des pommes",
                        --     },
        
                        -- },

                        TargetCircleBox = {
                            
                            ServerSide = false,
                            
                            Blip = {
                                -- Icon = 2, -- radar_lower
                                SetBlipAsFriendly = true,
                                Name = "Récolte : Pommes", 
                                SetBlipDisplay = 2,
                                SetBlipAsShortRange = true,
                                SetBlipPriority = 100,
                            },

                            Target = {
                                Label = "Récupérer des pommes",
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
                        Label = "Récupères des pommes",
                    },

                    Transaction = {
                        {
                            Give = {
                                { Item = "pomme", Qte = Commun.QteRecolte, Poids = 1000, Cooldown = Commun.CooldownRecolte },
                            },
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
                Pos = vector3( 2099.1526, 4890.0063, 41.1475 ),
                Heading = 129.8723,
                
                idInterne = nomJob.."1_prisedeservice",
                ServerSide = true,

                Ped = {
                    Model = "a_m_m_farmer_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    Blip = {
                        Icon = 280, -- radar_friend
                        SetBlipAsFriendly = true,
                        Name = "Récolte : Prise de service",
                        SetBlipDisplay = 4,
                        SetBlipAsShortRange = true,
                    }
                },
            },
        

            Action = {
                Condition = {

                    Target = {
                        {
                            Label = "Prendre le service : Pomme",
                            Icon = "apple-whole",
                            GoTo = {
                                Tache = "pomme",
                                Notification = "On a besoin de Pommes, vas m'en récupérer là-bas",
                                EtapeSet = 2,
                            },
                        },
                        {
                            Label = "Prendre le service : Orange",
                            Icon = "citrus",
                            GoTo = {
                                Tache = "orange",
                                Notification = "On a besoin d'Oranges, vas m'en récupérer là-bas",
                                EtapeSet = 2,
                            },
                        },
                        {
                            Label = "Prendre le service : Tomate",
                            Icon = "tomato",
                            GoTo = {
                                Tache = "tomate",
                                Notification = "On a besoin de Tomates, vas m'en récupérer là-bas",
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
                Pos = vector3(  2244.9709, 5171.811, 59.5964  ),
                Heading = 50.9996,

                idInterne = nomJob.."global_vente",
                ServerSide = true,

                Ped = {
                    Model = "s_m_m_dockwork_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    Blip = {
                        Icon = 500, -- radar_production_money
                        SetBlipAsFriendly = true,
                        Name = "Récolte : Vente",
                        SetBlipPriority = 100,
                    }
                },
            },
        

            Action = {
                Condition = {
                    Target = {
                        Label = "Vendre la marchandise",
                        Icon = "money-bill",
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
                        Remove = { Item = "pomme_lave", Qte = -1, Cooldown = 1.5 * 1000,}, 
                        Pay = { Qte = 100, },
                    },
                    {
                        Remove = { Item = "orange_lave", Qte = -1, Cooldown = 1.5 * 1000,}, 
                        Pay = { Qte = 100, },
                    },
                    {
                        Remove = { Item = "tomate_lave", Qte = -1, Cooldown = 1.5 * 1000,}, 
                        Pay = { Qte = 100, },
                    },                        
                },
            },
    
        },
    },

}
