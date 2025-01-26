extends Node


enum ITEM_TYPE {
    SHOVEL,
    HEALTH,
    COLLECTOR,
    SHOOTER
}

enum TILE_TYPE {
    BUBBLE,
    URCHIN,
    SHOOTER,
    COLLECTOR,
    SAND,
    SHELL
}

var item_schedules = {
    ITEM_TYPE.SHOVEL: {price = 20, increment = 5},
    ITEM_TYPE.HEALTH: {price = 40, increment = 10},
    ITEM_TYPE.COLLECTOR: {price = 100, increment = 20},
    ITEM_TYPE.SHOOTER: {price = 100, increment = 50}
}

const TILE_SIZE = 20
const MAX_HP = 100
const BUBBLES_PER_BUBBLE = 1
const HEAL_AMOUNT = 20
const DAMAGE_PER_OCTOPUS_HIT = 5
const SHELL_INTERVAL = 4

var world_path = "/root/World"
