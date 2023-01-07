extends Node2D

var souls = 0

var enemy = preload("res://Characters/Enemy/Enemy.tscn")

var wave = [3,10,20,0]
			# amount of enemies, last is win
onready var player = get_node("Player")

