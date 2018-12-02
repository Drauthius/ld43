class Gear:
	var level = 1
	var max_level
	var xp = 0

class Weapon:
	extends Gear
	var attack_damage = Vector2()
	var attack_damage_growth = Vector2()