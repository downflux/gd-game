package main

import (
	"github.com/downflux/gd-game/nodes/example"
	// "github.com/downflux/gd-game/nodes/map/map_layer/terrain"
	"grow.graphics/gd"
	"grow.graphics/gd/gdextension"
)

func main() {
	godot, ok := gdextension.Link()
	if !ok {
		return
	}

	gd.Register[example.N](godot)
	// gd.Register[terrain.N](godot)
}
