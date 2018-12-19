defmodule :__Main__ do
  def main([app, key, value]) do
    app = String.to_atom(app)
    key = String.to_atom(key)
    #value, left as string here
    
    Application.put_env(app, key, value)
  end
end
