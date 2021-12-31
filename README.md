# GEMS

A minimal **G**lobally **E**ditable **M**usic **S**equencer.

![banner](/priv/static/images/banner.png)

## Code

GEMS relies heavily on:

- Elixir

- [Phoenix Framework](https://www.phoenixframework.org/)

  - [LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html): real-time SSR
  - [Presence](https://hexdocs.pm/phoenix/Phoenix.Presence.html): cross-cluster socket tracking
  - [PubSub](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html): cross-cluster socket events

- [libcluser](https://github.com/bitwalker/libcluster)

  - connecting nodes into a cluster

- [Tonejs](https://tonejs.github.io/)

  - synth
  - audio effects

- [Flyio](http://fly.io/)
  - hosting: globally distributed cluster

## Usage

If you'd like to use GEMS locally, you'll need to install Elixir. I'd suggest using [asdf](https://github.com/asdf-vm/asdf-elixir)
for that.

GEMS doesn't rely on a DB so:

```
# install dependencies
mix deps.get

# install js dependencies
mix setup

# start the server
mix phx.server

# server should be available at http://localhost:4000
```

### Using Clustered Nodes Locally

1. Start the first node:

```
PORT=4000 iex --sname abc@localhost -S mix phx.server
```

2. Start a second node:

```
PORT=4001 iex --sname xyz@localhost -S mix phx.server
```

## Future Ideas

- output MIDI via the [WEB MIDI API](https://developer.mozilla.org/en-US/docs/Web/API/Web_MIDI_API)
- add more synths, effects, and controls

## Contributions

Contributions or ideas are welcome, espeically fixes. But I'd also encourage you to fork it and make it your own.
