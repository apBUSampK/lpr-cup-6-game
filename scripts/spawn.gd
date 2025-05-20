extends Button

@export var element_sc : PackedScene
@export var count = 0

@onready var c_label = $Count_Label

func _ready() -> void:
	c_label.text = "x"+str(count)

func _pressed() -> void:
	if count > 0 and not PickupController.has_pickup:
		var element : Element = element_sc.instantiate()
		element.carry = true
		element.pickable_removed.connect(return_element)
		var node = get_parent().get_parent().get_parent()
		node.add_child(element)
		PickupController.has_pickup = true
		count -= 1
		c_label.text = "x"+str(count)

func return_element() -> void:
	count += 1
	c_label.text = "x"+str(count)
