Canard::Abilities.for(:principle) do
  can [:manage], User
  cannot [:destroy], User
end
