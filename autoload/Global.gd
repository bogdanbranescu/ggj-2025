extends Node


var IS_DEBUGGING = true

const COLORS = {
    TEXT_AVAILABLE = Color("c0d1cc"),
    TEXT_UNAVAILABLE = Color("603b3a"),
}

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

var item_data = {
    ITEM_TYPE.SHOVEL: {
        price = 10,
        increment = 5,
        description = "Remove one sand patch",
    },
    ITEM_TYPE.HEALTH: {
        price = 25,
        increment = 10,
        description = "Restore " + str(Global.HEAL_AMOUNT) + " HP",
    },
    ITEM_TYPE.COLLECTOR:
        {price = 30,
        increment = 20,
        description = "Collects incoming bubbles\n(value x 2)",
    },
    ITEM_TYPE.SHOOTER: {
        price = 40,
        increment = 20,
        description = "Turns incoming bubbles into bullets",
    },
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
