## Astrology Skill
## Contains training methods for the Astrology skill
extends Node

## Create and return all astrology training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	var moon := TrainingMethodData.new()
	moon.id = "observe_moon"
	moon.name = "Observe Moon"
	moon.description = "Study the phases and movements of the moon."
	moon.level_required = 1
	moon.xp_per_action = 15.0
	moon.action_time = 3.0
	moon.produced_items = {"stardust": 1}
	methods.append(moon)
	
	var aries := TrainingMethodData.new()
	aries.id = "aries"
	aries.name = "Aries Constellation"
	aries.description = "Chart the ram constellation in the night sky."
	aries.level_required = 5
	aries.xp_per_action = 25.0
	aries.action_time = 3.5
	aries.produced_items = {"stardust": 1}
	methods.append(aries)
	
	var taurus := TrainingMethodData.new()
	taurus.id = "taurus"
	taurus.name = "Taurus Constellation"
	taurus.description = "Map the bull constellation and its stars."
	taurus.level_required = 10
	taurus.xp_per_action = 35.0
	taurus.action_time = 4.0
	taurus.produced_items = {"stardust": 2}
	methods.append(taurus)
	
	var gemini := TrainingMethodData.new()
	gemini.id = "gemini"
	gemini.name = "Gemini Constellation"
	gemini.description = "Study the twins constellation in detail."
	gemini.level_required = 15
	gemini.xp_per_action = 45.0
	gemini.action_time = 4.5
	gemini.produced_items = {"stardust": 2}
	methods.append(gemini)
	
	var cancer := TrainingMethodData.new()
	cancer.id = "cancer"
	cancer.name = "Cancer Constellation"
	cancer.description = "Observe the crab constellation's faint stars."
	cancer.level_required = 20
	cancer.xp_per_action = 55.0
	cancer.action_time = 5.0
	cancer.produced_items = {"stardust": 2, "celestial_essence": 1}
	methods.append(cancer)
	
	var leo := TrainingMethodData.new()
	leo.id = "leo"
	leo.name = "Leo Constellation"
	leo.description = "Track the lion constellation across the sky."
	leo.level_required = 25
	leo.xp_per_action = 65.0
	leo.action_time = 5.0
	leo.produced_items = {"stardust": 3, "celestial_essence": 1}
	methods.append(leo)
	
	var virgo := TrainingMethodData.new()
	virgo.id = "virgo"
	virgo.name = "Virgo Constellation"
	virgo.description = "Chart the maiden constellation's position."
	virgo.level_required = 30
	virgo.xp_per_action = 75.0
	virgo.action_time = 5.5
	virgo.produced_items = {"stardust": 3, "celestial_essence": 1}
	methods.append(virgo)
	
	var libra := TrainingMethodData.new()
	libra.id = "libra"
	libra.name = "Libra Constellation"
	libra.description = "Study the scales constellation in the zodiac."
	libra.level_required = 35
	libra.xp_per_action = 85.0
	libra.action_time = 6.0
	libra.produced_items = {"stardust": 3, "celestial_essence": 2}
	methods.append(libra)
	
	var scorpio := TrainingMethodData.new()
	scorpio.id = "scorpio"
	scorpio.name = "Scorpio Constellation"
	scorpio.description = "Observe the scorpion constellation's bright stars."
	scorpio.level_required = 40
	scorpio.xp_per_action = 95.0
	scorpio.action_time = 6.0
	scorpio.produced_items = {"stardust": 4, "celestial_essence": 2}
	methods.append(scorpio)
	
	var sagittarius := TrainingMethodData.new()
	sagittarius.id = "sagittarius"
	sagittarius.name = "Sagittarius Constellation"
	sagittarius.description = "Track the archer constellation toward the galactic center."
	sagittarius.level_required = 45
	sagittarius.xp_per_action = 105.0
	sagittarius.action_time = 6.5
	sagittarius.produced_items = {"stardust": 4, "celestial_essence": 2}
	methods.append(sagittarius)
	
	var capricorn := TrainingMethodData.new()
	capricorn.id = "capricorn"
	capricorn.name = "Capricorn Constellation"
	capricorn.description = "Map the sea-goat constellation in the southern sky."
	capricorn.level_required = 50
	capricorn.xp_per_action = 115.0
	capricorn.action_time = 7.0
	capricorn.produced_items = {"stardust": 5, "celestial_essence": 2}
	methods.append(capricorn)
	
	var aquarius := TrainingMethodData.new()
	aquarius.id = "aquarius"
	aquarius.name = "Aquarius Constellation"
	aquarius.description = "Study the water-bearer constellation's patterns."
	aquarius.level_required = 55
	aquarius.xp_per_action = 125.0
	aquarius.action_time = 7.0
	aquarius.produced_items = {"stardust": 5, "celestial_essence": 3}
	methods.append(aquarius)
	
	var pisces := TrainingMethodData.new()
	pisces.id = "pisces"
	pisces.name = "Pisces Constellation"
	pisces.description = "Observe the fish constellation's circlet."
	pisces.level_required = 60
	pisces.xp_per_action = 135.0
	pisces.action_time = 7.5
	pisces.produced_items = {"stardust": 5, "celestial_essence": 3}
	methods.append(pisces)
	
	var orion := TrainingMethodData.new()
	orion.id = "orion"
	orion.name = "Orion Constellation"
	orion.description = "Map the hunter constellation with its distinctive belt."
	orion.level_required = 65
	orion.xp_per_action = 145.0
	orion.action_time = 8.0
	orion.produced_items = {"stardust": 6, "celestial_essence": 3}
	methods.append(orion)
	
	var ursa_major := TrainingMethodData.new()
	ursa_major.id = "ursa_major"
	ursa_major.name = "Ursa Major"
	ursa_major.description = "Study the great bear and the big dipper."
	ursa_major.level_required = 70
	ursa_major.xp_per_action = 155.0
	ursa_major.action_time = 8.5
	ursa_major.produced_items = {"stardust": 6, "celestial_essence": 4, "astral_shard": 1}
	methods.append(ursa_major)
	
	var cassiopeia := TrainingMethodData.new()
	cassiopeia.id = "cassiopeia"
	cassiopeia.name = "Cassiopeia Constellation"
	cassiopeia.description = "Observe the distinctive W-shaped constellation."
	cassiopeia.level_required = 75
	cassiopeia.xp_per_action = 165.0
	cassiopeia.action_time = 9.0
	cassiopeia.produced_items = {"stardust": 7, "celestial_essence": 4, "astral_shard": 1}
	methods.append(cassiopeia)
	
	var andromeda := TrainingMethodData.new()
	andromeda.id = "andromeda"
	andromeda.name = "Andromeda Galaxy"
	andromeda.description = "Study the distant spiral galaxy visible to the naked eye."
	andromeda.level_required = 80
	andromeda.xp_per_action = 180.0
	andromeda.action_time = 9.5
	andromeda.produced_items = {"stardust": 8, "celestial_essence": 5, "astral_shard": 2}
	methods.append(andromeda)
	
	var pleiades := TrainingMethodData.new()
	pleiades.id = "pleiades"
	pleiades.name = "Pleiades Star Cluster"
	pleiades.description = "Chart the seven sisters star cluster."
	pleiades.level_required = 85
	pleiades.xp_per_action = 200.0
	pleiades.action_time = 10.0
	pleiades.produced_items = {"stardust": 10, "celestial_essence": 6, "astral_shard": 2}
	methods.append(pleiades)
	
	var supernova := TrainingMethodData.new()
	supernova.id = "supernova"
	supernova.name = "Supernova Remnant"
	supernova.description = "Study the remains of an exploded star."
	supernova.level_required = 90
	supernova.xp_per_action = 225.0
	supernova.action_time = 11.0
	supernova.produced_items = {"stardust": 12, "celestial_essence": 7, "astral_shard": 3}
	methods.append(supernova)
	
	var black_hole := TrainingMethodData.new()
	black_hole.id = "black_hole"
	black_hole.name = "Black Hole"
	black_hole.description = "Observe the mysterious gravitational anomaly from a safe distance."
	black_hole.level_required = 95
	black_hole.xp_per_action = 250.0
	black_hole.action_time = 12.0
	black_hole.produced_items = {"stardust": 15, "celestial_essence": 10, "astral_shard": 5, "void_crystal": 1}
	methods.append(black_hole)
	
	return methods
