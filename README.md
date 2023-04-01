Pour faire court, voici ce qu'il faut absolument savoir :
=======================================================

Aléatoire :
----------

    GoTo / PolyZones / Zones / Give / Remove / Zones 
    ------------------------------------------------
    Lorsqu'une action a [2,n] objets, le choix est fait aléatoirement 
    Pour pondérer le poids d'un choix, il faut ajouter le paramètre .Poids
    Si le .Poids est omis, il sera mis par défaut à 1

    Exception : Transaction est traité en liste d'action sans aléatoire


    Qte
    ---
    Plusieurs paramètres possibles : 
    2 ou { 2 }  : quantité spécifiée                - 2
    { 2, 4 }    : quantité aléatoire entre 2 et 4   - 2,3,4
    { 2, 4, 7 } : choix aléatoire dans la liste     - 2,4,7




Notice détaillée : 
================



Config.Jobs.nomdujob
    nomdujob est l'identifiant qui sera utilisé dans le setjob2 _idjoueur_ nomdujob _grade_
    exemple : Config.Jobs.boucher2    > setjob2 _idjoueur_ boucher2 0

Etapes
======
    Correspond aux différentes étapes à suivre dans l'ordre pour compléter une mission


    Paramètres pour une Etape : 

    Taches
    ------
    default : ce sont les paramètres qui seront appelés si une Tache n'a pas été affecté
    _tache_ : sera appelé si une tache est affectée 

    "Actions" possibles :
        GoToStep            Invite le joueur à se rendre quelque part
        PolyZone            Créé un Zone d'activité qui peut être utilisée 
                            dans les conditions plus tard
        Action              
            .Condition      Conditions pour que la conclusion de l'action soit faite
                .Target     ... doit avec utilisé le qTarget sur le Ped, Objet, etc.
                .PolyZone   ... doit être dans la zone
            
                            Une fois les conditions validées 

            .Progress       ... affiche un jauge d'attente
            .Transaction    ... effectue une transaction d'items, argent, etc
            .GoTo           ... pas d'action IG, passe à la suite

        DisplayRadar        Active la mini carte en bas à gauche pour cette étape


Etape.GoToStep
==============


Notification : string - optionnel
    pour afficher une notification en bas à gauche avec un timer

GPS : vector3 - optionnel
    Paramètre la destination du GPS avec un marquer sur la carte (tracé violet)

Spawn : pour spawner un Ped
    Pos : vector3() - obligatoire
    Heading : number - obligatoire
    
    Ped : objet
        
    Ped.Model : string ou hash(number) - obligatoire
        https://docs.fivem.net/docs/game-references/ped-models/
    
    Ped.ServerSide : boolean - optionnel
        active la synchronisation du spawn avec les autres joueurs via le server
    
    Ped.Target : string
        Etiquette d'action affichée via le qtarget (focus sur le Ped)
    
    Ped.Blip : objet
        action un repère associé au Ped sur la carte poru le joueur (si le ped bouge, le blip suit)

    Ped.Blip.Name : string - optionnel
        Texte à afficher en légende

    Ped.Blip.Icon : number - optionnel
        icone associé https://docs.fivem.net/docs/game-references/blips/
    
    Ped.Blip.SetBlipAsFriendly : boolean - optionnel
        identifie le blip comme amical
        https://docs.fivem.net/natives/?_0x6F6F290102C02AB4 

    Ped.Blip.SetBlipRoute : boolean - optionnel
        active le routage secondaire vers ce blip (tracé jaune)
    
    Ped.Blip.SetBlipPriority : number - optionnel
        Priorise le blip en tete de légende sur la carte plein écran
        Semble non fonctionnel sous fiveM 

    Ped.Blip.SetBlipAsShortRange : boolean - optionnel
        Affiche le blip unquement à proximité


Etape.Action
============

Etape.Action.Condition
======================
    Condition : objet
        L'ensemble des conditions doit être validé pour la conclusion de l'étape

    Condition.Target : objet - optionnel
        Attend un action qTarget 

    Condition.Target.Label : string - optionnel
        Etiquette d'action affichée via le qtarget (focus sur le Ped)
    
    Condition.PolyZone : string - optionnel
        Nom de la PolyZone dans laquelle le joueur doit être 

    Condition.Touche : number - optionnel
        Attend un release de touche 
        https://docs.fivem.net/docs/game-references/controls/#controls

    Condition.Hint : string - optionnel
        Affiche un message d'aide à l'action (haut gauche)


Etape.Action.GoTo
=================
    GoTo : objet d'objets - Voir introduction "Aléatoire"
        passe à l'étape suivante 

        Dans le cas de [2,n] objets, le choix est fait aléatoirement 
        Pour pondérer le poids d'un choix, il faut ajouter le paramètre .Poids
        Si le .Poids est omis, il sera mis par défaut à 1

    GoTo.Tache : string - optionnel
        Affectation d'un tache. Sera appelé plutot que default

    GoTo.Hint : string - optionnel
        Affiche une notification avant de passer à l'étape suivante

    GoTo.EtapeIncremente : number - optionnel
        Incremente l'étape courante de nombre. Permet de skip une etape par exemple


Etape.Action.Polyzone   &   Etape.Action.Polyzones  (avec un S)
===============================================================
    type : string "CircleZone"|""CircleZone""
        Défini le type de PolyZone

    params.name : string
        Identifiant de la zone pour pouvoir controler la présence ensuite

    "CircleZone"
        vector : vector3 - obligatoire
            Centre du cercle 

        radius : number - obligatoire
            Rayon du cercle

    "PolyZone"
        vector : objets de vector2
        Défini un polygone 
        Site utile, peu précis : https://skyrossm.github.io/PolyZoneCreator/index.html 
        Préférable de faire la création en jeu

    Exemple : 
        PolyZone = { type = "CircleZone", 
            vector = vector3(2236.8374, 5155.1519, 57.2684), 
            radius = 30, 
            params = { name = "recolte", useZ = false, debugPoly = DebugPolyzone }} ,

        PolyZone = { type = "PolyZone", 
            vector = { vector2(2092.05, 5002.27), vector2(2170.08, 4921.59), vector2(2238.26, 4985.98), vector2(2152.65, 5063.64) }, 
            params = { name = "recolte", useZ = false, debugPoly = true }
        }

    PolyZones  
        Sera remplacé par PolyZone sans S 
        
        Choisi une PolyZone aléatoirement parmi les entrées 
        (Pas de gestion du .Poids)


Etape.Action.PolyzoneRandom
===========================
    Génère un centre de cercle aléatoirement dans un polygone (.Zones) défini avec .Radius

    .Zones : objet d'objets - obligatoire
        Défini des polygones pour le choix aléatoire d'un point dans le polygone

    .type : string  "CircleZone" - obligatoire
        Uniquement CircleZone géré 


    Exemple : 
        PolyZoneRandom = { 
            name = "recolte", 
            type = "CircleZone", 
            Radius = 30,  

            Zones = {
                {{2092.05, 5002.27}, {2170.08, 4921.59}, {2238.26, 4985.98}, {2152.65, 5063.64}},
                {{2190.53, 4898.11}, {2254.17, 4833.71}, {2307.58, 4889.77}, {2242.42, 4953.03}},
            },
        },




Etape.Action.Spawn
==================
    Voir Etape.GoToStep.Spawn

    Le script va spawner des Ped 
    Nécessite une PolyZone. Le centre de spawn sera la PolyZone active

    Radius : number - obligatoire
        Rayon dans lequel le spawn sera fait. 
        
    MaxCycles : number - obligatoire
        Nombre de cycles de spawn maximum

    Ped.Target.Label : string - obligatoire
        Etiquette d'action sur le Ped


Etape.Action.Progress
=====================
    Affiche une jauge d'attente pendant la transaction

    Anim : objet - optionnel
        Anim = {
            type = "anim",
            dict = "amb@code_human_cower@male@base", 
            lib = "base",
        },

    FreezePlayer : boolean - optionnel
        Immobilise le joueur pendant l'attente

    Label : string - optionnel
        Texte affiché sur la jauge

    

Etape.Action.Transaction
========================
    Liste de transactions à realiser

    Remove          Recupère X item
    RemoveServer    Récupère X items dans le coffre temporaire
    
    Give            Donne X item * quantité Remove/RemoveServer
    GiveServer      Donne X item * quantité Remove/RemoveServer dans le coffre temporaire
    
    Pay             Paye X montant * quantité Remove/RemoveServer
    
    Need            Controle la présence d'un item dans l'inventaire ou licence
                    Non intégré pour le moment (demander si besoin)

    Pour les transactions (Remove, Give, Pay) : Voir Introduction / Aléatoire
        Exemple : choisi en aléatoire pondéré un Give (selon le .Poids, si non spécifié, .Poids = 1)
        Give = {
            { Item = "viande_boeuf", Qte = {8,10}, Poids = 1000, Cooldown = 1.5 * 1000 },
            { Item = "viande_boeuf_qualite", Qte = 1, Poids = 10, Cooldown = 3 * 1000},
        },


    Give / GiveServer / Remove / RemoveServer
        .Item : string - obligatoire
            Nom de l'item "base de donnée"

        .Qte : number ou objet - obligatoire
            Voir Introduction / Aléatoire / Qte
            
            Remove / RemoveServer  .Qte = -1
                retire tout ce qui est disponible dans l'inventaire personnage ou le coffre temporaire



        .Poids : number - optionnel
            Pondère le choix aléatoire 

        .Cooldown : number - optionnel
            Ajoute au temps du Etape.Action.Progress en ms (1sec = 1000 ms)
            Un cooldown pour n'importe quelle quantité


    Pay 
        .Qte : number ou objet - obligatoire        
            Voir Introduction / Aléatoire / Qte
            Somme à payer par item Remove/RemoveServer


Divers 
======
Etape.DisplayRadar : boolean - optionnel
    Actif la mini carte en bas à gauche pour cette étape