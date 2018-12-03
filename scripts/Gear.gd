enum Tiers {TIER_NORMAL, TIER_MAGIC, TIER_RARE, TIER_LEGENDARY}
enum Properties {PROPERTY_HEALTH, PROPERTY_LPH, PROPERTY_CRIT, PROPERTY_DUD}

class Gear:
	var level = 1
	var max_level
	var total_xp = 0
	var xp_growth = 1.5
	var xp_this_level = 0
	var xp_to_level
	var tier = TIER_NORMAL
	var icon = null
	
	var health = 0
	var lph = 0
	var properties = []
	
	func set_xp(value):
		assert(value >= total_xp)
		var diff = value - total_xp
		total_xp = value
		xp_this_level += diff
		if xp_this_level >= xp_to_level:
			if level < max_level:
				level_up()
	
	func level_up():
		level += 1
		if level < max_level:
			# Leave values on max if level can't be increased further.
			xp_this_level -= xp_to_level
			xp_to_level *= xp_growth

class Weapon:
	extends Gear
	var attack_damage = Vector2()
	var attack_damage_growth = Vector2()
	var critical_hit_chance = 0
	
	func level_up():
		.level_up()
		attack_damage += attack_damage_growth
		
		if attack_damage[0] > attack_damage[1]:
			attack_damage[1] = attack_damage[0]
	
	static func generate(tier = -1):
		var weapon = new()
		weapon.tier = tier
		var num_properties
		
		match tier:
			-1:
				weapon.icon = preload("res://assets/images/Basic Sword 1.png")
				weapon.max_level = 2
				weapon.xp_to_level = 500
				weapon.attack_damage = Vector2(3, 5)
				weapon.attack_damage_growth = Vector2(0, 1)
				num_properties = 0
			TIER_NORMAL:
				weapon.max_level = randi() % 2 + 1 # 1-2
				weapon.xp_to_level = (randi() % 3 + 1) * 500 # 500/1000/1500/2000
				weapon.attack_damage = Vector2(randf() * 2 + 3, randf() * 2 + 4) # (3-5) - (4-6)
				weapon.attack_damage_growth = Vector2(randf() * 1, randf() * 2) # (0-1) - (0-2)
				num_properties = 0
			TIER_MAGIC:
				weapon.max_level = randi() % 3 + 1 # 1-3
				weapon.xp_to_level = (randi() % 4 + 1) * 500 # 500/1000/1500/2000/2500
				weapon.attack_damage = Vector2(randf() * 3 + 3, randf() * 4 + 4) # (3-6) - (4-8)
				weapon.attack_damage_growth = Vector2(randf() * 2, randf() * 3) # (0-2) - (0-3)
				num_properties = randi() % 2 + 1 # 1-2
			TIER_RARE:
				weapon.max_level = randi() % 4 + 1 # 1-4
				weapon.xp_to_level = (randi() % 5 + 2) * 500 # 1000/1500/2000/2500/3000
				weapon.attack_damage = Vector2(randf() * 4 + 4, randf() * 4 + 6) # (4-8) - (6-10)
				weapon.attack_damage_growth = Vector2(randf() * 2 + 1, randf() * 3 + 1) # (1-3) - (1-4)
				num_properties = randi() % 2 + 2 # 2-3
			TIER_LEGENDARY:
				weapon.max_level = randi() % 5 + 1 # 1-4
				weapon.xp_to_level = (randi() % 6 + 3) * 500 # 1500/2000/2500/3000/3500/4000
				weapon.attack_damage = Vector2(randf() * 5 + 6, randf() * 6 + 8) # (6-11) - (8-14)
				weapon.attack_damage_growth = Vector2(randf() * 3 + 2, randf() * 4 + 2) # (2-5) - (2-6)
				num_properties = randi() % 3 + 2 # 2-4
			_:
				assert(false)
		
		for i in range(num_properties):
			var property = randi() % Properties.size()
			match property:
				PROPERTY_HEALTH:
					weapon.properties.append({ PROPERTY_HEALTH: randi() % 10 + 5 }) # 5-15
					weapon.health += weapon.properties.back()[PROPERTY_HEALTH]
				PROPERTY_LPH:
					weapon.properties.append({ PROPERTY_LPH: randi() % 2 + 1 }) # 1-2
					weapon.lph += weapon.properties.back()[PROPERTY_LPH]
				PROPERTY_CRIT:
					weapon.properties.append({ PROPERTY_CRIT: randi() % 3 * 5 }) # 0/5/10
					weapon.critical_hit_chance += weapon.properties.back()[PROPERTY_CRIT]
				PROPERTY_DUD:
					weapon.properties.append({ PROPERTY_DUD: null })
				_:
					assert(false)
		
		if weapon.attack_damage[0] > weapon.attack_damage[1]:
			weapon.attack_damage[1] = weapon.attack_damage[0]
		if weapon.max_level == 1:
			weapon.xp_this_level = 10
			weapon.xp_to_level = 10
		
		return weapon