# GEMS

## Using Clustered Nodes Locally

1. Start the first node:

```
PORT=4000 iex --sname abc@localhost -S mix phx.server
```

2. Start a second node:

```
PORT=4001 iex --sname xyz@localhost -S mix phx.server
```

Useful:

```elixir
# List other nodes
Node.list([:this, :visible])

# List all nodes (including self)
Node.list([:this, :visible])
```
