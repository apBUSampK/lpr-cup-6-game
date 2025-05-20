extends Node

var max_id := 1000
var available_ids : Array

func _init() -> void:
	available_ids = range(1, max_id + 1)

func get_id() -> Variant:
	if !available_ids.is_empty():
		var id = available_ids.min()
		available_ids.erase(id)
		return id
	else:
		return null

func return_id(id: int) -> void:
	available_ids.push_back(id)

func reset() -> void:
	available_ids = range(1, max_id + 1)
