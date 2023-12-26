extends StaticBody2D

var finished_building : bool = false
var current_builder : CharacterBody2D
var destroyed : bool = false

var constructing_texture = preload("res://Art/Tiny Swords/Factions/Knights/Buildings/House/House_Construction.png")
var normal_texture = preload("res://Art/Tiny Swords/Factions/Knights/Buildings/House/House_Blue.png")
var destroyed_texture = preload("res://Art/Tiny Swords/Factions/Knights/Buildings/House/House_Destroyed.png")

func _ready():
	$Sprite2D.modulate.a = 0.4
	$Sprite2D.texture = normal_texture

func _process(delta):
	pass

func toggle_collision():
	$CollisionShape2D.disabled = not $CollisionShape2D.disabled

func switch_texture(texture : String):
	$Sprite2D.modulate.a = 1
	if texture == "constructing":
		$Sprite2D.texture = constructing_texture
	elif texture == "normal":
		$Sprite2D.texture = normal_texture
	elif texture == "destroyed":
		$Sprite2D.texture = destroyed_texture


func _on_build_area_body_entered(body):
	if not current_builder and body is Villager and body.current_state.name.to_lower() == "build":
		current_builder = body
		$Timer.start()
	
func _on_build_area_body_exited(body):
	if current_builder and current_builder == body and not finished_building:
		destroyed = true
		switch_texture("destroyed")
		$Timer.start()

func _on_timer_timeout():
	if not destroyed:
		switch_texture("normal")
		finished_building = true
	else:
		queue_free()


func _on_taken_space_mouse_entered():
	Global.mouse_on_used_area.append(1)

func _on_taken_space_mouse_exited():
	Global.mouse_on_used_area.remove_at(0)
