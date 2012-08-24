module(..., package.seeall)

function Grid(w, h)
  local self = {w = w, h = h}

  for y = 0, self.h - 1 do self[y] = {}
    for x = 0, self.w - 1 do
      self[y][x] = 0
    end
  end

  --
  -- Passed in function should have params:
  --   function(x, y, cell)
  --   
  self.iter = function(self, func) 
    for y = 0, #self do
      for x = 0, #self[y]  do
        func(x, y, self[y][x])
      end
    end
  end

  -- 
  -- Setter iter
  -- In case the values are simple
  -- Function gets x, y, and cell
  -- Should return a value to set
  --
  self.iterset = function(self, func)
    self:iter(function(x, y, cell)
      self[y][x] = func(x, y, cell)
    end)
  end

  --
  -- Clears the grid with one var 
  -- Should be a simple type, i.e. not a table or usertable
  --
  self.clear = function(self, clearVar)
    self:iterset(function(x, y, cell) return clearVar end)
  end

  --
  -- Returns the closest legal cell for given coords
  --
  self.get = function(self, x, y)
    return self[clamp(0, #self-1, y)][clamp(0, #self[0]-1, x)]
  end

  --
  -- Sets the value of the closest legal cell for given coords
  --
  self.set = function(self, x, y, val)
    self[clamp(0, #self-1, y)][clamp(0, #self[0]-1, x)] = val
  end

  self.lineiterset = function(self, x1, y1, x2, y2, func)
    local xstep, ystep = tosteps(x1, y1, x2, y2)
    --xstep, ystep = math.round(xstep, 2), math.round(ystep, 2)
    local xplus, yplus = xstep > 0 and 1 or -1, ystep > 0 and 1 or -1
    local xd, yd = xplus * 0.5, yplus * 0.5
    local x, y = x1, y1
    self:set(x, y, func(x,y, self:get(x,y)))
    local max = math.floor(math.sqrt(math.pow(math.abs(x1-x2), 2)+math.pow(math.abs(y1-y2), 2)))
    while not (math.floor(x) == x2 and math.floor(y) == y2) and max > 0 do
      xd = xd + xstep
      yd = yd + ystep
      if math.abs(xstep) == 1 then
        if math.abs(xd) >= 1 and math.abs(yd) < 1 then 
          x, xd = x + xplus, 0 
        elseif math.abs(yd) >= 1 then 
          y, yd = y + yplus, 0 
          if xd >= 1 then xd, max = 0, max + 1 end
        end
      else
        if math.abs(yd) >= 1 and math.abs(xd) < 1 then 
          y, yd = y + yplus, 0 
        elseif math.abs(xd) >= 1 then
          x, xd = x + xplus, 0 
          if yd >= 1 then yd, max = 0, max + 1 end
        end
      end
      self:set(x, y, func(x, y, self:get(x,y)))
      max = max - 1
    end
    --assert(max ~= 0, "Error finding end: xstep: "..xstep.." ystep: "..ystep)
  end

  self.lineflat = function(self, x1, y1, x2, y2, div, func) 
    if div == 1 then
      --local mid = x1 + math.random(math.abs((x1 - 1) - (x2 - 1)))
      local mid = x1 + math.floor((math.abs((x1 - 1) - (x2 - 1))) / 2)
      self:lineiterset(x1, y1, mid, y1, func)
      self:lineiterset(mid, y1, mid, y2, func)
      self:lineiterset(mid, y2, x2, y2, func)
    else
      --local mid = y1 + math.floor((math.abs((y1 - 1) - (y2 - 1))) / 2)
      local mid = y1 + math.random(math.abs((y1 - 1) - (y2 - 1)))
      self:lineiterset(x1, y1, x1, mid, func)
      self:lineiterset(x1, mid, x2, mid, func)
      self:lineiterset(x2, mid, x2, y2, func)
    end
  end

  self.midspread = function(self, xstart, ystart, div, func)
    if div == 1 then
      for x=xstart, 0, -1 do
        if self:get(x, ystart) ~= 0 then
          break
        end
        self:set(x, ystart, func(x, ystart, self:get(x, ystart)))
      end
      for x=xstart + 1, self.w, 1 do
        if self:get(x, ystart) ~= 0 then
          break
        end
        self:set(x, ystart, func(x, ystart, self:get(x, ystart)))
      end
    else
      for y=ystart, 0, -1 do
        if self:get(xstart, y) ~= 0 then
          break
        end
        self:set(xstart, y, func(xstart, y, self:get(xstart, y)))
      end
      for y=ystart + 1, self.h, 1 do
        if self:get(xstart, y) ~= 0 then
          break
        end
        self:set(xstart, y, func(xstart, y, self:get(xstart, y)))
      end
    end
  end

  return self
end

function clamp(min, max, n)
  return math.max(min, math.min(max, n))
end

function tosteps(x1, y1, x2, y2)
  local xdiff = x2 - x1
  local ydiff = y2 - y1
  local xstep, ystep = xdiff > 0 and 1 or -1, ydiff > 0 and 1 or -1
  if math.abs(xdiff) > math.abs(ydiff) then
    xstep, ystep = xdiff > 0 and 1 or -1, ydiff / xdiff
  elseif math.abs(ydiff) > math.abs(xdiff) then
    ystep, xstep = ydiff > 0 and 1 or -1, xdiff / ydiff
  end
  return xstep, ystep
end

math.round = function(number, pos) 
  if pos > 0 then
    number = number * math.pow(10, pos)
  end

  if number % 1 >= 0.5 then
    number = math.ceil(number)
  else
    number = math.floor(number)
  end

  if pos > 0 then
    number = number / math.pow(10, pos)
  end

  return number
end

