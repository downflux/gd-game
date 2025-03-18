package mover

import (
	"fmt"

	"github.com/downflux/gd-game/internal/fsm/move/amphibious"
	"graphics.gd/classdb"
	"graphics.gd/classdb/Node2D"
	"graphics.gd/classdb/Tween"
	"graphics.gd/variant/Enum"
	"graphics.gd/variant/Object"
	"graphics.gd/variant/Vector2"
)

type T Enum.Int[struct {
	Unknown  T `gd:"MOVE_TYPE_UNKNOWN"`
	Walk     T `gd:"MOVE_TYPE_WALK"`
	Teleport T `gd:"MOVE_TYPE_TELEPORT"`
}]

var MoveTypes = Enum.Values[T]()

type M struct {
	Position Vector2.XY
	MoveType T
}

type N struct {
	classdb.Extension[N, Node2D.Instance] `gd:"DFMover"`

	Speed float32

	tween Tween.Instance

	head  M
	tail  []M
	state *amphibious.FSM
}

func (n *N) Ready() { n.state = amphibious.New() }

func (n *N) Head() M { return n.head }

func (n *N) SetPath(path []M) {
	n.tail = nil
	n.AppendPath(path)
}

func (n *N) AppendPath(path []M) {
	n.tail = append(n.tail, path...)

	if len(n.tail) > 0 {
		if s := n.state.State(); s == amphibious.StateIdle || s == amphibious.StateUnknown {
			if err := n.state.SetState(amphibious.StateCheckpoint); err != nil {
				panic(err)
			}
		}
	}
}

func (n *N) Process(d float32) {
	Object.Use(n.tween)

	switch s := n.state.State(); s {
	case amphibious.StateUnknown:
		fallthrough
	case amphibious.StateTransit:
		fallthrough
	case amphibious.StateIdle:
		return
	case amphibious.StateCheckpoint:
		if len(n.tail) == 0 {
			if err := n.state.SetState(amphibious.StateIdle); err != nil {
				panic(err)
			}
			return
		}

		n.head, n.tail = n.tail[0], n.tail[1:]

		dt := float32(0)
		if n.head.MoveType == MoveTypes.Walk {
			dv := Vector2.Length(
				Vector2.Sub(
					n.Super().AsNode2D().Position(),
					n.head.Position,
				),
			)
			dt = dv / n.Speed
		}

		if err := n.state.SetState(amphibious.StateTransit); err != nil {
			panic(err)
		}

		n.tween = n.Super().AsNode().CreateTween()
		n.tween.SetProcessMode(Tween.TweenProcessPhysics)
		n.tween.TweenProperty(
			n.AsObject(), "position", n.head.Position, dt,
		)
		n.tween.TweenCallback(func() {
			if err := n.state.SetState(amphibious.StateCheckpoint); err != nil {
				panic(err)
			}
		})
		n.tween.Play()
	default:
		panic(fmt.Errorf("invalid state encountered: %v", s))
	}
}
