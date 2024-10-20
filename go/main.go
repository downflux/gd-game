package main

import (
	"github.com/downflux/gd-game/nodes/example"
	"github.com/downflux/gd-game/nodes/level"
	"github.com/downflux/gd-game/nodes/tile"
	"grow.graphics/gd"
	"grow.graphics/gd/gdextension"
)

func main() {
	godot, ok := gdextension.Link()
	if !ok {
		return
	}

	gd.Register[level.N](godot)
	gd.Register[example.N](godot)
	gd.Register[tile.N](godot)
}
