# Ree

Run local scripts on remote Elixir nodes.

It's easy to run scripts that are already exist on the remote Elixir/Erlang nodes, but when the scripts only exist on your local node or you can't upload scripts to the remote nodes, you may need `Ree`.

## Usage

``` bash
ree ./some.exs [args..] [-s|-l] -c cookie -t [nodes..]
```

You can define multiple modules in every scripts (`*.exs`), but module `:__Main__` must be defined, and also function `:__Main__.main/1`, which is the entry of script.  Args are all strings, argument conversion is left to the users' scripts, see examples for more details.

## Example

```bash
# suppose there's a node called twin_peaks@localhost with cookie :BGCI
ree ./examples/set_app_env.exs people name Cooper -s -c BGCI -t twin_peaks@localhost
# twin_peaks@localhost:	ok

ree ./examples/get_app_env.exs people name -s -c BGCI -t twin_peaks@localhost
# twin_peaks@localhost:	<<"Cooper">>

ree ./examples/a.exs -s -c BGCI -t twin_peak@localtost
# twin_peaks@localhost:	42

ree ./examples/a.exs -s -c BGCI -t twin_peak@localtost none@localhost
# twin_peaks@localhost:	<<"Cooper">>
# none@localhost:	{badrpc,nodedown}
```

