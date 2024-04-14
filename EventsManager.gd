extends Node

class_name EventsManager

#Manages all signals from the game
#Special conditions are made here
#to be subbed to or emitted from
#mainly signals are being used for obtaining skills
#later can be used for achievements
#extra rewards and such

signal OnPickUpStone
signal OnEnemyKilled(type)
signal OnHitBy(type,amount_damage)
signal OnDeath
signal OnFamilyKilled
signal OnExplored(area)
signal OnNpcDeath(type)
signal OnNpcKilled(type)
signal OnPriestDeath
signal OnSkillUsed(skill)
signal OnSkillProgress(skill,progress)
signal OnSkillObtained(skill)
signal OnNpcTalkToggle(player)
signal OnToolsPickUp()
signal OnNewGame()
signal OnHendersonDeath
