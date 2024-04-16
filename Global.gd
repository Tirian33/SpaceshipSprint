extends Node

var gold = 100
signal gold_update

#status: 0 = unpurchased, 1 = purchased, 2 = unequipped, 3 = equipped 
@onready var items = {
	"0":{
		"Name": "item1",
		"Cost": 10,
		"Status": 0,
		"Description": "The first item",
		"image": "add the link to the item image here"
	},
	"1":{
		"Name": "item2",
		"Cost": 20,
		"Status": 0,
		"Description": "The second item",
		"image": "add the link to the item image here"
	},
	"2":{
		"Name": "item3",
		"Cost": 30,
		"Status": 0,
		"Description": "The thrid item",
		"image": "add the link to the item image here"
	},
	"3":{
		"Name": "item4",
		"Cost": 40,
		"Status": 0,
		"Description": "The third item",
		"image": "add the link to the item image here"
	}
}

