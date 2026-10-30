# game_config.gd
# IBRI version 1 - the single file that holds every tunable number.
#
# Nothing else in the project may carry a bare magic number for speed, damage,
# size, colour, distance or time. If a system needs a value, it reads it here.

class_name GameConfig
extends RefCounted

# ---------------------------------------------------------------- identity
const GAME_NAME := "IBRI"
const GAME_VERSION := "0.1.0"

# ---------------------------------------------------------------- match
# One human and nine bots. Last one alive wins.
const HUMAN_COUNT := 1
const BOT_COUNT := 9
const PLAYER_COUNT := HUMAN_COUNT + BOT_COUNT
const BOT_NAMES := [
	"Ravi", "Meera", "Arjun", "Kabir", "Tara",
	"Dev", "Nisha", "Vikram", "Asha", "Rohan",
]

# ---------------------------------------------------------------- health
const MAX_HEALTH := 100.0
const MAX_SHIELD := 100.0
const STARTING_HEALTH := 100.0
const STARTING_SHIELD := 0.0

# ---------------------------------------------------------------- movement
const PLAYER_SPEED := 4.6
const PLAYER_ACCELERATION := 30.0
const PLAYER_TURN_SPEED := 12.0
const GRAVITY := 24.0
const PLAYER_RADIUS := 0.4
const PLAYER_HEIGHT := 1.7

# ---------------------------------------------------------------- camera
const CAMERA_HEIGHT := 2.4
const CAMERA_DISTANCE := 4.5
const CAMERA_PITCH_DEGREES := -12.0
const CAMERA_SMOOTHING := 8.0
const CAMERA_FOV := 70.0

# ---------------------------------------------------------------- weapons
# fire_rate is seconds between shots. spread is the cone half-angle in degrees.
# range is metres. mag is rounds per magazine. reload is seconds.
const WEAPONS := {
	"pistol": {
		"damage": 18.0,
		"fire_rate": 0.32,
		"spread": 1.2,
		"range": 40.0,
		"mag": 12,
		"reload": 1.4,
		"pellets": 1,
		"automatic": false,
	},
	"rifle": {
		"damage": 22.0,
		"fire_rate": 0.12,
		"spread": 2.0,
		"range": 90.0,
		"mag": 30,
		"reload": 2.1,
		"pellets": 1,
		"automatic": true,
	},
	"shotgun": {
		"damage": 9.0,
		"fire_rate": 0.85,
		"spread": 6.0,
		"range": 22.0,
		"mag": 6,
		"reload": 2.6,
		"pellets": 6,
		"automatic": false,
	},
}

# The weapon every player and bot starts the match holding.
const STARTING_WEAPON := "pistol"

# ---------------------------------------------------------------- zone
# The circle closes in steps: hold, shrink, hold, shrink.
const ZONE_START_RADIUS := 120.0
const ZONE_END_RADIUS := 12.0
const ZONE_STEP_COUNT := 4
const ZONE_HOLD_TIME := 20.0
const ZONE_SHRINK_TIME := 18.0
const ZONE_DAMAGE_PER_SECOND := 6.0
const ZONE_RING_COLOR := Color(0.25, 0.55, 0.85, 0.35)
const ZONE_RING_WIDTH := 1.2

# ---------------------------------------------------------------- bots
const BOT_SPEED := 3.8
const BOT_VIEW_DISTANCE := 45.0
const BOT_FIRE_ACCURACY_DEGREES := 4.5
const BOT_TURN_SPEED := 6.0
const BOT_STRAFE_INTERVAL := 1.6
const BOT_TARGET_REFRESH := 0.5
const BOT_STOP_DISTANCE := 12.0

# ---------------------------------------------------------------- spawning
const MAP_SIZE := 260.0
const SPAWN_MIN_DISTANCE := 22.0
const SPAWN_HEIGHT := 1.2

# ---------------------------------------------------------------- world art
# Warm earth palette: terracotta, ochre, dust, deep green, weathered stone.
const COLOR_GROUND := Color(0.72, 0.62, 0.47)
const COLOR_GROUND_DARK := Color(0.58, 0.48, 0.36)
const COLOR_WATER := Color(0.22, 0.42, 0.46)
const COLOR_HUT_WALL := Color(0.66, 0.42, 0.30)
const COLOR_HUT_ROOF := Color(0.45, 0.28, 0.20)
const COLOR_STONE := Color(0.70, 0.68, 0.62)
const COLOR_FOLIAGE := Color(0.26, 0.40, 0.24)
const COLOR_PLAYER := Color(0.30, 0.45, 0.65)
const COLOR_BOT := Color(0.62, 0.30, 0.26)

# ---------------------------------------------------------------- hud
const HUD_COLOR_HEALTH := Color(0.78, 0.22, 0.20)
const HUD_COLOR_SHIELD := Color(0.30, 0.58, 0.86)
const HUD_COLOR_TEXT := Color(0.96, 0.94, 0.88)
const HUD_COLOR_PANEL := Color(0.12, 0.10, 0.08, 0.55)
const HUD_FONT_SIZE := 18
const JOYSTICK_RADIUS := 110.0
const JOYSTICK_DEADZONE := 0.15
const FIRE_BUTTON_RADIUS := 62.0
const TOUCH_SAFE_MARGIN := 24.0

# ---------------------------------------------------------------- screens
# Boot flow: splash -> loading -> login -> menu -> match.
const SPLASH_SECONDS := 2.0
const LOADING_SECONDS := 2.5
const COLOR_BACKGROUND := Color(0.11, 0.09, 0.08)
const COLOR_TITLE := Color(0.95, 0.93, 0.88)
const COLOR_ACCENT := Color(0.91, 0.77, 0.59)
const COLOR_BUTTON := Color(0.54, 0.29, 0.16)
const COLOR_BUTTON_TEXT := Color(1.0, 0.98, 0.95)
const COLOR_MUTED := Color(0.78, 0.74, 0.68)
const UI_TITLE_SIZE := 96
const UI_SUBTITLE_SIZE := 30
const UI_BODY_SIZE := 22
const UI_BUTTON_SIZE := 26
const UI_BUTTON_SIZE_PX := Vector2(440, 74)
const FONT_DEVANAGARI := "res://assets/fonts/NotoSansDevanagari-Regular.ttf"
const FONT_DEVANAGARI_BOLD := "res://assets/fonts/NotoSansDevanagari-Bold.ttf"
const LOGO_PATH := "res://assets/studio_logo.png"

# ---------------------------------------------------------------- performance
# 1280x720 target, 960x540 middle step, 854x480 floor. Never below 480p.
const TARGET_FPS := 60
const MIN_ACCEPTABLE_FPS := 30
const RESOLUTION_STEPS := [
	Vector2i(1280, 720),
	Vector2i(960, 540),
	Vector2i(854, 480),
]
const MIN_RESOLUTION_INDEX := 2
const FRAME_TIME_BUDGET_MS := 16.7


## Returns the weapon dictionary for an id, or an empty dictionary if unknown.
static func weapon(id: String) -> Dictionary:
	if WEAPONS.has(id):
		return WEAPONS[id]
	push_warning("GameConfig: unknown weapon id '%s'" % id)
	return {}
