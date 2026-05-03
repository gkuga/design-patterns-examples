# State Pattern (Ruby)

A minimal music player demonstrating the GoF State pattern.

## Run

```sh
make install   # bundle install
make run       # bundle exec ruby player.rb
```

Ruby version is pinned in `Gemfile` (`ruby '3.3.4'`); `bundle exec` enforces it.

## Structure

- `Player` — Context. Holds the current state and delegates operations to it.
- `State` — Abstract interface (`play` / `pause` / `stop`).
- `StoppedState` / `PlayingState` / `PausedState` — Concrete states. Each one defines its own behavior **and** decides the next state.

## Why this design

### Tell, Don't Ask

The client tells the player to `play`; it never asks "what state are you in?". The player likewise tells `@state.play(self)` instead of branching on it. The anti-pattern is a `case @state` chain in every method — every new state forces edits to every method.

### Encapsulation

Each state's allowed operations and transitions live entirely inside its class. To know what "stopped" can do, read `StoppedState`. Nothing else.

### Polymorphism over conditionals

`@state.play(self)` dispatches dynamically. Adding a state means **adding a class**, not editing branches across methods.

### SOLID

- **S** — Each state owns one state's behavior; `Player` only delegates.
- **O** — Add a new state by adding a class. `Player` and most existing states stay untouched.
- **L** — Any concrete state is substitutable for `State`.
- **I** — `State` exposes only the three operations the context needs.
- **D** — `Player` depends on the `State` abstraction. (Concrete states still `new` each other directly — the usual State-pattern compromise.)

### State vs Strategy

Same shape, different intent. Strategy is chosen **from the outside**; State **transitions itself** (`player.state = PlayingState.new` from within a state).

## Trade-offs

- More classes than a `case` chain — overkill for 2 states that will never grow.
- Sharing data between states means routing it through the context.
- New `State.new` on every transition; singletons are an option if states are stateless.

Rule of thumb: when you catch yourself writing `case @state`, reach for this pattern.
