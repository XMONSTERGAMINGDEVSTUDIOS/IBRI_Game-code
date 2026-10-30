# check_config.gd
# Dev-only sanity check for res://config/game_config.gd.
# Run headless:  godot --headless --path . --script res://tools/check_config.gd
# Exits 0 when every rule passes, 1 when one fails. Not part of the game.

extends SceneTree

var _failures := 0


func _initialize() -> void:
	print("IBRI config check - version ", GameConfig.GAME_VERSION)

	_check_player_counts()
	_check_health()
	_check_weapons()
	_check_zone()
	_check_resolution()
	_check_bots()

	if _failures == 0:
		print("PASS - all config rules hold")
		quit(0)
	else:
		print("FAIL - %d rule(s) broken" % _failures)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if condition:
		print("  ok   ", message)
	else:
		print("  FAIL ", message)
		_failures += 1


func _check_player_counts() -> void:
	_expect(GameConfig.PLAYER_COUNT == 10, "player count is 10")
	_expect(GameConfig.HUMAN_COUNT == 1, "one human")
	_expect(GameConfig.BOT_COUNT == 9, "nine bots")
	_expect(
		GameConfig.BOT_NAMES.size() >= GameConfig.BOT_COUNT,
		"enough bot names for every bot"
	)


func _check_health() -> void:
	_expect(GameConfig.MAX_HEALTH == 100.0, "max health 100")
	_expect(
		GameConfig.STARTING_HEALTH > 0.0
		and GameConfig.STARTING_HEALTH <= GameConfig.MAX_HEALTH,
		"starting health inside range"
	)
	_expect(
		GameConfig.STARTING_SHIELD >= 0.0
		and GameConfig.STARTING_SHIELD <= GameConfig.MAX_SHIELD,
		"starting shield inside range"
	)


func _check_weapons() -> void:
	var required := ["damage", "fire_rate", "spread", "range", "mag", "reload", "pellets", "automatic"]
	_expect(GameConfig.WEAPONS.size() == 3, "exactly three weapons")
	for id in ["pistol", "rifle", "shotgun"]:
		_expect(GameConfig.WEAPONS.has(id), "weapon '%s' exists" % id)
		if not GameConfig.WEAPONS.has(id):
			continue
		var w: Dictionary = GameConfig.WEAPONS[id]
		for key in required:
			_expect(w.has(key), "  %s has '%s'" % [id, key])
		_expect(float(w.get("damage", 0.0)) > 0.0, "  %s damage is positive" % id)
		_expect(float(w.get("fire_rate", 0.0)) > 0.0, "  %s fire rate is positive" % id)
		_expect(int(w.get("mag", 0)) > 0, "  %s magazine holds rounds" % id)
	_expect(GameConfig.WEAPONS.has(GameConfig.STARTING_WEAPON), "starting weapon exists")
	_expect(GameConfig.weapon("does_not_exist").is_empty(), "unknown weapon returns empty")


func _check_zone() -> void:
	_expect(GameConfig.ZONE_START_RADIUS > GameConfig.ZONE_END_RADIUS, "zone shrinks inward")
	_expect(GameConfig.ZONE_END_RADIUS > 0.0, "zone never collapses to zero")
	_expect(GameConfig.ZONE_STEP_COUNT >= 1, "at least one zone step")
	_expect(GameConfig.ZONE_DAMAGE_PER_SECOND > 0.0, "outside the zone hurts")


func _check_resolution() -> void:
	var steps: Array = GameConfig.RESOLUTION_STEPS
	_expect(steps.size() >= 2, "resolution ladder has at least two steps")
	var previous := Vector2i(99999, 99999)
	for step in steps:
		_expect(step.x < previous.x, "step %s is smaller than the one above" % str(step))
		previous = step
	var lowest: Vector2i = steps[GameConfig.MIN_RESOLUTION_INDEX]
	_expect(lowest.y >= 480, "floor is 480p or better (got %s)" % str(lowest))
	_expect(steps[0] == Vector2i(1280, 720), "top step is 1280x720")
	_expect(GameConfig.TARGET_FPS == 60, "target is 60 FPS")
	_expect(GameConfig.MIN_ACCEPTABLE_FPS == 30, "30 FPS is the floor")


func _check_bots() -> void:
	_expect(GameConfig.BOT_SPEED > 0.0, "bots can move")
	_expect(
		GameConfig.BOT_SPEED <= GameConfig.PLAYER_SPEED,
		"bots are not faster than the player"
	)
	_expect(GameConfig.BOT_VIEW_DISTANCE > 0.0, "bots can see")
	_expect(GameConfig.BOT_FIRE_ACCURACY_DEGREES > 0.0, "bots fire with error")
