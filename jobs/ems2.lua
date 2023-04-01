
local nomJob = "ems2_"


local Commun = {}
Commun.MaxCycles = 3    -- 15
Commun.QteRecolte = {1,2}  --{1,2}
Commun.CooldownRecolte = 13 * 1000
Commun.Zones = { 
    
    Rue = {

        {{166.43740844726, -919.17486572266},{158.1483001709, -919.4849243164},{150.8911895752, -933.74841308594},{142.04832458496, -957.84643554688},{133.55783081054, -982.51068115234},{137.24909973144, -990.17877197266},{136.18310546875, -994.85528564454},{127.3378982544, -991.32891845704},{127.30044555664, -984.47119140625},{127.19529724122, -984.2280883789},{134.21086120606, -971.57586669922},{150.2917022705, -928.1322631836},{151.5763244629, -917.34020996094},{155.35720825196, -909.66369628906},{158.95059204102, -901.39056396484},{163.07423400878, -903.087890625},{162.64576721192, -907.30004882812},{170.03381347656, -911.00305175782},{175.7767791748, -913.59783935546},{181.7584991455, -917.52062988282},{193.121383667, -925.44274902344},{186.53649902344, -934.46905517578}}   

    }, 

}



Config.Jobs.ems2 = {
    

    Etapes = {
        
        { --Vestiaire / prise de service
            Etape = 1,

            default = {
                GoToStep = {
                    Notification = "Le médecin-chef a des patients pour toi",
                    GPS = vector2(  165.5684, -921.3956),
                },
            },
        },
        { --Recolte = {
            Etape = 2,

            default = {
                
                Polygone = Commun.Zones.Rue, 
                
                -- Polygone = { -- zone test à proximité de la prise de service
                --     {{166.99975585938, -917.59942626954},{167.87219238282, -915.92126464844},{169.90963745118, -916.78546142578}}
                -- }, 

                DisplayRadar = true,

                Action = {
                    Spawn = {

                        MaxCycles = Commun.MaxCycles, 
                        
                        Notification = {    -- recherche google 'bobologie'
                            "En pleine crise d’asthme sévère.",
                            "Se plaignant d’importantes douleurs abdominales.",
                            "Présentant de la fièvre à 39°C, une lymphangite aiguë de l’avant-bras et une adénopathie axillaire à la suite d’une plaie de la main.",
                            "Souffrant d’une atroce douleur dans le côté et le bas-ventre.",
                            "A fait un appel de détresse car elle veut aller se jeter dans le Rhône.",
                            "Devient folle à cause d’un bruit insupportable dans son oreille.",
                            "A glissé dans les escaliers et qui s’est fracturé la cheville.",
                            "En proie à d’importantes angoisses et qui présente en fait les premiers symptômes d’une psychose avec idées délirantes.",
                            "A glissé sur le verglas et qui s’est fracturé le poignet et blessé l’épaule.",
                            "Ne peut plus uriner depuis 24 heures et qui s’agite à cause de fortes douleurs vésicales.",
                        },

                        Ped = {
                            {   -- Femmes
                                Model = {   -- https://docs.fivem.net/docs/game-references/ped-models/
                                    "a_f_m_bevhills_01", "a_f_m_bevhills_02", "a_f_m_business_02",
                                    "a_f_m_downtown_01", "a_f_m_eastsa_01", "a_f_m_eastsa_02",
                                    "a_f_m_fatbla_01", "a_f_m_fatwhite_01", "a_f_m_ktown_01",
                                    "a_f_m_ktown_02", "a_f_m_prolhost_01", "a_f_m_salton_01",
                                    "a_f_m_skidrow_01", "a_f_m_soucent_01", "a_f_m_soucentmc_01",
                                    "a_f_m_soucent_02", "a_f_m_tourist_01", "a_f_m_trampbeac_01",
                                    "a_f_m_tramp_01", "a_f_o_genstreet_01", "a_f_o_indian_01",
                                    "a_f_o_ktown_01", "a_f_o_soucent_01", "a_f_o_salton_01",
                                    "a_f_y_bevhills_01", "a_f_o_soucent_02", "a_f_y_bevhills_02",
                                    "a_f_y_bevhills_03", "a_f_y_hipster_02", "a_f_y_eastsa_03",
                                    "a_f_y_vinewood_03", "a_f_y_indian_01",
                                },

                                Mode = "net",
                                GetGroundZFor_3dCoord = true,
                                
                                TaskStartScenarioInPlace = {
                                    "WORLD_HUMAN_PARTYING",
                                    "WORLD_HUMAN_PICNIC",
                                    "WORLD_HUMAN_SMOKING",
                                    "WORLD_HUMAN_SMOKING_POT",
                                    "WORLD_HUMAN_STAND_IMPATIENT",
                                    "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT",
                                    "WORLD_HUMAN_STAND_MOBILE",
                                    "WORLD_HUMAN_TOURIST_MAP",
                                    "CODE_HUMAN_CROSS_ROAD_WAIT",
                                    "WORLD_HUMAN_AA_SMOKE",
                                    "EAR_TO_TEXT",         --- femme uniquement
                                },


                                Blip = {
                                    AddBlipForEntity = true, 

                                    SetBlipAsFriendly = true,
                                    Name = "EMS : Soigner", 
                                    SetBlipDisplay = 2,             -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                                },

                                Target = {
                                    Icon = "steak",
                                    Label = "Soigner le patient",
                                },
            
                            },
                            {   -- Hommes
                                Model = {   -- https://docs.fivem.net/docs/game-references/ped-models/
                                    "a_m_m_bevhills_01", "a_m_m_acult_01",
                                    "a_m_m_bevhills_02", "a_m_m_business_01", "a_m_m_fatlatin_01",
                                    "a_m_m_genfat_02", "a_m_m_eastsa_02", "a_m_m_genfat_01",
                                    "a_m_m_hillbilly_01", "a_m_m_hasjew_01", "a_m_m_indian_01",
                                    "a_m_m_mexlabor_01", "a_m_m_og_boss_01", "a_m_m_paparazzi_01",
                                    "a_m_m_salton_01", "a_m_m_salton_03", "a_m_m_soucent_01",
                                    "a_m_m_skater_01", "a_m_m_socenlat_01", "a_m_m_skidrow_01",
                                    "a_m_o_acult_02", "a_m_m_tramp_01", "a_m_o_soucent_03",
                                    "a_m_y_bevhills_02", "a_m_y_clubcust_01", "a_m_y_busicas_01",
                                    "a_m_y_business_02", "a_m_y_epsilon_01", "a_m_y_hipster_01",
                                    "a_m_y_hippy_01", "a_m_y_hasjew_01", "a_m_y_mexthug_01",
                                    "a_m_y_roadcyc_01", "a_m_y_runner_02", "a_m_y_sunbathe_01",
                                },

                                Mode = "net",
                                GetGroundZFor_3dCoord = true,
                                
                                TaskStartScenarioInPlace = {
                                    "WORLD_HUMAN_PARTYING",
                                    "WORLD_HUMAN_PICNIC",
                                    "WORLD_HUMAN_SMOKING",
                                    "WORLD_HUMAN_SMOKING_POT",
                                    "WORLD_HUMAN_STAND_IMPATIENT",
                                    "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT",
                                    "WORLD_HUMAN_STAND_MOBILE",
                                    "WORLD_HUMAN_TOURIST_MAP",
                                    "CODE_HUMAN_CROSS_ROAD_WAIT",
                                    "WORLD_HUMAN_AA_SMOKE",
                                    "WORLD_HUMAN_STUPOR",  --- homme uniquement
                                },

                                Blip = {
                                    AddBlipForEntity = true, 

                                    SetBlipAsFriendly = true,
                                    Name = "EMS : Soigner", 
                                    SetBlipDisplay = 2,             -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                                },

                                Target = {
                                    Icon = "steak",
                                    Label = "Soigner le patient",
                                },
            
                            },
                        },
                    },

                    Progress = {
                        -- Anim = {
                        --     type = "anim",
                        --     dict = "amb@code_human_cower@male@base", 
                        --     lib = "base",
                        -- },


                        Anim = {
                            type = "Scenario",
                            Scenario = "CODE_HUMAN_MEDIC_KNEEL", 
                        },
                        
                        FreezePlayer = true, 
                        Label = "Soignes le patient",
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
                Pos = vector3(  165.5684, -921.3956, 30.692 ),
                Heading = 329.8723,
                
                idInterne = nomJob.."1_prisedeservice",
                ServerSide = true,

                Ped = {
                    Model = "s_m_m_paramedic_01",       --   https://docs.fivem.net/docs/game-references/ped-models/
                    Mode = "local",

                    TaskStartScenarioInPlace = "CODE_HUMAN_POLICE_INVESTIGATE",

                    Blip = {
                        Icon = 280, -- radar_friend
                        SetBlipAsFriendly = true,
                        Name = "EMS : Prise de service",
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
                                Tache = "soins",
                                Notification = "Un patient a besoin de soins",
                                EtapeSet = 2,
                            },
                        },
                    }, 
                }, 
            },
        },
        
    },

}
