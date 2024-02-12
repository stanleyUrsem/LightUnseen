extends Node2D

@export var stats_resource: StatsResource
var stats : Stats

func _ready():
	stats = Stats.new(stats_resource)
