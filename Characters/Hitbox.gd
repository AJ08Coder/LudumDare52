class_name HitBox
extends Area2D

export var damage = 10


func _init():
	collision_layer = 8 # layer 4 (hitbox)
	collision_mask = 0
