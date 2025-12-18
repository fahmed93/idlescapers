## Agility Skill
## Contains training methods for the Agility skill
extends Node

## Create and return all agility training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	var gnome_stronghold := TrainingMethodData.new()
	gnome_stronghold.id = "gnome_stronghold"
	gnome_stronghold.name = "Gnome Stronghold Course"
	gnome_stronghold.description = "Navigate the obstacle course in the Gnome Stronghold."
	gnome_stronghold.level_required = 1
	gnome_stronghold.xp_per_action = 86.5
	gnome_stronghold.action_time = 35.0
	gnome_stronghold.produced_items = {"marks_of_grace": 1}
	gnome_stronghold.success_rate = 0.15
	methods.append(gnome_stronghold)
	
	var draynor := TrainingMethodData.new()
	draynor.id = "draynor"
	draynor.name = "Draynor Village Course"
	draynor.description = "A rooftop agility course in Draynor Village."
	draynor.level_required = 10
	draynor.xp_per_action = 120.0
	draynor.action_time = 43.2
	draynor.produced_items = {"marks_of_grace": 1}
	draynor.success_rate = 0.18
	methods.append(draynor)
	
	var al_kharid := TrainingMethodData.new()
	al_kharid.id = "al_kharid"
	al_kharid.name = "Al Kharid Course"
	al_kharid.description = "An agility course in the desert city of Al Kharid."
	al_kharid.level_required = 20
	al_kharid.xp_per_action = 180.0
	al_kharid.action_time = 64.8
	al_kharid.produced_items = {"marks_of_grace": 1}
	al_kharid.success_rate = 0.20
	methods.append(al_kharid)
	
	var varrock := TrainingMethodData.new()
	varrock.id = "varrock"
	varrock.name = "Varrock Course"
	varrock.description = "A rooftop course running across Varrock."
	varrock.level_required = 30
	varrock.xp_per_action = 238.0
	varrock.action_time = 66.0
	varrock.produced_items = {"marks_of_grace": 1}
	varrock.success_rate = 0.22
	methods.append(varrock)
	
	var canifis := TrainingMethodData.new()
	canifis.id = "canifis"
	canifis.name = "Canifis Course"
	canifis.description = "A challenging rooftop course in the werewolf town."
	canifis.level_required = 40
	canifis.xp_per_action = 240.0
	canifis.action_time = 75.0
	canifis.produced_items = {"marks_of_grace": 1}
	canifis.success_rate = 0.24
	methods.append(canifis)
	
	var wilderness := TrainingMethodData.new()
	wilderness.id = "wilderness"
	wilderness.name = "Wilderness Course"
	wilderness.description = "A dangerous course deep in the Wilderness."
	wilderness.level_required = 52
	wilderness.xp_per_action = 498.9
	wilderness.action_time = 60.0
	wilderness.produced_items = {"marks_of_grace": 1}
	wilderness.success_rate = 0.26
	methods.append(wilderness)
	
	var seers := TrainingMethodData.new()
	seers.id = "seers"
	seers.name = "Seers' Village Course"
	seers.description = "An advanced rooftop course in Seers' Village."
	seers.level_required = 60
	seers.xp_per_action = 570.0
	seers.action_time = 45.6
	seers.produced_items = {"marks_of_grace": 1}
	seers.success_rate = 0.28
	methods.append(seers)
	
	var pollnivneach := TrainingMethodData.new()
	pollnivneach.id = "pollnivneach"
	pollnivneach.name = "Pollnivneach Course"
	pollnivneach.description = "A desert rooftop course with challenging obstacles."
	pollnivneach.level_required = 70
	pollnivneach.xp_per_action = 890.0
	pollnivneach.action_time = 61.2
	pollnivneach.produced_items = {"marks_of_grace": 1}
	pollnivneach.success_rate = 0.30
	methods.append(pollnivneach)
	
	var rellekka := TrainingMethodData.new()
	rellekka.id = "rellekka"
	rellekka.name = "Rellekka Course"
	rellekka.description = "A frigid rooftop course in the Fremennik Province."
	rellekka.level_required = 80
	rellekka.xp_per_action = 780.0
	rellekka.action_time = 52.8
	rellekka.produced_items = {"marks_of_grace": 1}
	rellekka.success_rate = 0.32
	methods.append(rellekka)
	
	var ardougne := TrainingMethodData.new()
	ardougne.id = "ardougne"
	ardougne.name = "Ardougne Course"
	ardougne.description = "The most challenging rooftop agility course."
	ardougne.level_required = 90
	ardougne.xp_per_action = 793.0
	ardougne.action_time = 51.6
	ardougne.produced_items = {"marks_of_grace": 1}
	ardougne.success_rate = 0.35
	methods.append(ardougne)
	
	return methods
