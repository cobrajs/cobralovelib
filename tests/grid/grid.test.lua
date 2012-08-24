require 'grid'

g = grid.Grid(10, 10)

g:clear(1)

assert(g[0][0] == 1, "clear failed")

g:iterset(function(x, y, cell) return x*y end)

assert(g[3][3] == 9, "iterset failed")

g:set(-2, 2, 5)

assert(g[2][0] == 5 and g:get(-2, 2) == 5, "setting failed")

g:clear(0)
g:lineiterset(0,0,2,2, function(x,y,cell) return 1 end)
assert(
  g:get(0,0) == 1 and 
  g:get(1,1) == 1 and 
  g:get(2,2) == 1,
  "line for 0,0 to 2,2 failed"
)

g:clear(0)
g:lineiterset(0,0,4,2, function(x,y,cell) return 1 end)
assert(
  g:get(0,0) == 1 and 
  g:get(1,0) == 1 and 
  g:get(2,1) == 1 and 
  g:get(3,1) == 1 and 
  g:get(4,2) == 1,
  "line for 0,0 to 4,2 failed"
)

g:clear(0)
g:lineiterset(0,0,2,0, function(x,y,cell) return 1 end)
assert(
  g:get(0,0) == 1 and 
  g:get(1,0) == 1 and 
  g:get(2,0) == 1,
  "line for 0,0 to 2,0 failed"
)

g:clear(0)
g:lineiterset(0,0,0,2, function(x,y,cell) return 1 end)
assert(
  g:get(0,0) == 1 and 
  g:get(0,1) == 1 and 
  g:get(0,2) == 1,
  "line for 0,0 to 0,2 failed"
)

print("all tests passed")
