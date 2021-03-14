# UNIX_TheHyruleCastle

## I) Introduction

For this project I created a turn by turn RPG that you can execute in **Bash**. In this game you find yourself at the bottom of the Hyrule castle and you will have to fight the enemies on each floor in order to reach the last floor (number 10) and defeat the final boss. 

## II) Game mechanics

The selection of your character, the enemies and the boss is random and depends on their rarity. You can find the rarity of a character in the csv files. A rarity of 1 has a probability of 50%, 2 has a probability of 30%, 3 15%, 4 4% and 5 only 1%. There are 4 different actions that you can perform every turn during a fight : 

- **"Attack"** allows you to deal damages equal to your strength (see the csv file for stats).

- **"Heal"** lets you gain an amout equal to half your max HP.

- **"Protect"** allows you to reduce the damage received by half.

- **"Escape"** lets save yourself but you will have to go back to floor 1.

## III) Ho to launch the game

In order to launch this game you need to download all the csv files, better_combat_options.sh and hyrule_castle.sh in the same directory. Then in the terminal go to the right directory and execute hyrule_castle.sh with the command : `./hyrule_castle.sh` 
