#!/bin/bash

function PlayerEscape {
    echo "You escaped ! You have to go back to Floor 1 !"
    Floor=1
}

function ProtectEnemy {
    Damage=$((EnemySTR/2))
    PlayerCurrHP=$((PlayerCurrHP-Damage))
    Turn=$((Turn+1))
    echo -e "You protected yourself !\n"$EnemyName" attacked and dealt "$Damage "damages !"
}

function ProtectBoss {
    Damage=$((BossSTR/2))
    PlayerCurrHP=$((PlayerCurrHP-Damage))
    Turn=$((Turn+1))
    echo -e "You protected yourself !\n"$BossName" attacked and dealt "$Damage "damages !"
}
