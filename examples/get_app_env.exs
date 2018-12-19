defmodule :__Main__ do
  def main([app, key]) do
    app = String.to_atom(app)
    key = String.to_atom(key)

    Application.get_env(app, key)
  end
end
