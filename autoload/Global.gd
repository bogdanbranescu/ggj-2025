extends Node


enum ITEM_TYPE {
    SHOVEL,
    HEALTH,
    COLLECTOR,
    SHOOTER,
}

enum TILE_TYPE {
    BUBBLE,
    URCHIN,
    SHOOTER,
    COLLECTOR,
    SAND,
    SHELL,
    BULLET,
}

var item_schedules = {
    ITEM_TYPE.SHOVEL: {price = 10, increment = 5},
    ITEM_TYPE.HEALTH: {price = 25, increment = 10},
    ITEM_TYPE.COLLECTOR: {price = 30, increment = 20},
    ITEM_TYPE.SHOOTER: {price = 40, increment = 50}
}

const TILE_SIZE = 20
const MAX_HP = 100
const BUBBLES_PER_BUBBLE = 1
const BUBBLES_PER_COLLECTOR = 2
const HEAL_AMOUNT = 20
const DAMAGE_PER_OCTOPUS_HIT = 8
const SHELL_INTERVAL = 3
const TICKS_PER_PEACE_PHASE := 30
const BULLET_DAMAGE := 1


var world_path = "/root/World"
