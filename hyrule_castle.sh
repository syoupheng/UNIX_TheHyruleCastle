#!/bin/bash

#Importation des mods

source better_combat_options.sh
action3="3. Escape"
action4="4. Protect"

#Stockage des caractéristiques du personnage

function GetPlayerStats {
    First_line=0
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity; do
        if [[ $First_line -ne 0 ]]; then
            if [[ $id -eq $1 ]]; then
                PlayerName=$name
                PlayerHP=$hp
                PlayerMP=$mp
                PlayerSTR=$str
                PlayerINT=$int
                PlayerDEF=$def
                PlayerRES=$res
                PlayerSPD=$spd
                PlayerLuck=$luck
                PlayerRarity=$rarity
            fi
        else
            First_line=1
        fi
    done < players.csv
}

#Stockage des caractéristiques des ennemies

function GetEnemyStats {
    First_line=0
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity; do
        if [[ $First_line -ne 0 ]]; then
            if [[ $id -eq $1 ]]; then
                EnemyName=$name
                EnemyHP=$hp
                EnemyMP=$mp
                EnemySTR=$str
                EnemyINT=$int
                EnemyDEF=$def
                EnemyRES=$res
                EnemySPD=$spd
                EnemyLuck=$luck
                EnemyRarity=$rarity
            fi
        else
            First_line=1
	fi
    done < enemies.csv
}

function GetBossStats {
    First_line=0
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity; do
        if [[ $First_line -ne 0 ]]; then
            if [[ $id -eq $1 ]]; then
                BossName=$name
                BossHP=$hp
                BossMP=$mp
                BossSTR=$str
                BossINT=$int
                BossDEF=$def
                BossRES=$res
                BossSPD=$spd
                BossLuck=$luck
                BossRarity=$rarity
            fi
        else
	    First_line=1
        fi
    done < bosses.csv
}

#Fonction qui gère les combats contre les ennemies

function FightTurnEnemy {
    echo -e "===== FIGHT "$Turn" ======\nEnemy: "$EnemyName"\nHP: "$EnemyCurrHP"/"$EnemyHP"\n"
    echo -e "Player: "$PlayerName"\nHP: "$PlayerCurrHP"/"$PlayerHP
    echo -e "---Options--------\n1. Attack  2. Heal  "$action3  $action4"\nTapez le numéro suivi du nom de l'action à executer (avec le point et l'espace)"
    read action
    if [[ $action = "1. Attack" ]]; then
        EnemyCurrHP=$((EnemyCurrHP-PlayerSTR))
        PlayerCurrHP=$((PlayerCurrHP-EnemySTR))
        Turn=$((Turn+1))
        echo -e "You attacked and dealt "$PlayerSTR" damages !\n\n"$EnemyName "attacked and dealt "$EnemySTR" damages !"
    elif [[ $action = "2. Heal"  ]]; then
        PlayerCurrHP=$((PlayerCurrHP-EnemySTR))
        PlayerCurrHP=$((PlayerCurrHP+(PlayerHP/2)))
        if [[ $PlayerCurrHP -gt $PlayerHP ]]; then
            PlayerCurrHP=$PlayerHP
        fi
        Turn=$((Turn+1))
        echo -e "You used heal !\n"$EnemyName" attacked and dealt "$EnemySTR "damages !"
    elif [[ $action = "4. Protect" ]]; then
        ProtectEnemy
    fi
    if [[ $PlayerCurrHP -le 0 ]]; then
        echo "You are dead !"
        exit 0
    fi
}

function FightTurnBoss {
    echo -e "===== FIGHT "$Turn" ======\nBoss: "$BossName"\nHP: "$BossCurrHP"/"$BossHP"\n"
    echo -e "Player: "$PlayerName"\nHP: "$PlayerCurrHP"/"$PlayerHP
    echo -e "---Options--------\n1. Attack  2. Heal  "$action3  $action4"\nTapez le numéro suivi du nom de l'action à executer (avec le point et l'espace)
"
    read action
    if [[ $action = "1Attack" ]]; then
        BossCurrHP=$((BossCurrHP-PlayerSTR))
        PlayerCurrHP=$((PlayerCurrHP-BossSTR))
        Turn=$((Turn+1))
        echo -e "You attacked and dealt "$PlayerSTR" damages !\n\n"$BossName "attacked and dealt "$BossSTR" damages !"
    elif [[ $action = "2Heal"  ]]; then
        PlayerCurrHP=$((PlayerCurrHP-BossSTR))
        PlayerCurrHP=$((PlayerCurrHP+(PlayerHP/2)))
        if [[ $PlayerCurrHP -gt $PlayerHP ]]; then
            PlayerCurrHP=$PlayerHP
        fi
        Turn=$((Turn+1))
        echo -e "You used heal !\n"$BossName" attacked and dealt "$BossSTR "damages !"
    elif [[ $action = "4. Protect" ]]; then
        ProtectBoss
    fi
    if [[ $PlayerCurrHP -le 0 ]]; then
        echo "You are dead !"
        exit 0
    fi
}

#Génération aléatoire de la rareté : on crée une liste qui contient 50 fois 1, 30 fois 2, 15 fois 3, 4 fois 4 et une fois 5

declare -a array=($(for i in {1..50}; do echo 1; done))
array+=($(for i in {1..30}; do echo 2; done))
array+=($(for i in {1..15}; do echo 3; done))
array+=($(for i in {1..4}; do echo 4; done))
array+=(5)

#On selectionne au hasard une valeur de la liste array pour determiner la rareté
#Ensuite on cherche dans les fichiers csv les personnages qui ont la bonne rareté et on selectionne au hasard le personnage

function GenerPlayerID {
    GenRarity=${array[$(shuf -i 0-99 -n 1)]}
    declare -a listID
    lenlist=0
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity; do
        if [[ $rarity -eq $GenRarity ]] 2> /dev/null; then
            listID+=($id)
            lenlist=$((lenlist+1))
        fi
    done < players.csv
    PlayerID=${listID[$(shuf -i 0-$((lenlist-1)) -n 1)]}
}

function GenerEnemyID {
    GenRarity=${array[$(shuf -i 0-99 -n 1)]}
    declare -a listID
    lenlist=0
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity; do
        if [[ $rarity -eq $GenRarity ]] 2> /dev/null; then
            listID+=($id)
            lenlist=$((lenlist+1))
        fi
    done < enemies.csv
    EnemyID=${listID[$(shuf -i 0-$((lenlist-1)) -n 1)]}
}

function GenerBossID {
    GenRarity=${array[$(shuf -i 0-99 -n 1)]}
    declare -a listID
    lenlist=0
    while IFS=',' read -r id name hp mp str int def res spd luck race class rarity; do
        if [[ $rarity -eq $GenRarity ]] 2> /dev/null; then
            listID+=($id)
            lenlist=$((lenlist+1))
        fi
    done < bosses.csv
    BossID=${listID[$(shuf -i 0-$((lenlist-1)) -n 1)]}
}

#Initialisation du jeu

GenerPlayerID

GetPlayerStats $PlayerID

Floor=1
MaxFloor=10
PlayerCurrHP=$PlayerHP

#On itère sur les différents étages

while [[ $Floor -lt $MaxFloor ]]; do
    GenerEnemyID
    GetEnemyStats $EnemyID
    EnemyCurrHP=$EnemyHP
    Turn=1
    echo "====== FLOOR" $Floor "======"
    echo "You encountered a "$EnemyName
    while [[ $EnemyCurrHP -gt 0 ]]; do
        FightTurnEnemy
        if [[ $action = $action3 ]]; then
            PlayerEscape
            break
        fi
    done
    if [[ $EnemyCurrHP -le 0 ]]; then
        echo $EnemyName "died !"
        Floor=$((Floor+1))
    fi
done

#Après avoir battu tous les ennemies on arrive contre le boss

GenerBossID
GetBossStats $BossID
BossCurrHP=$BossHP
Turn=1
echo -e "====== FLOOR" $Floor "========\nYou find yourself against "$BossName "!"
while [[ $BossCurrHP -gt 0 ]]; do
    FightTurnBoss
    if [[ $action = $action3 ]]; then
        PlayerEscape
        break
    fi
done
echo $BossName "died ! Congratulations !"
