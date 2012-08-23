module(..., package.seeall)

require 'utils'
require 'xml'

--
-- Inputs:
--    image : Already loaded image from love
--    xtiles : Number of tiles along x axis
--    ytiles : Number of tiles along y axis
-- Returns a new tileset
--
function Tileset(image, xtiles, ytiles)
  assert(type(xtiles) == 'number' and type(ytiles) == 'number', 'xtiles and ytiles must be numbers') 
  local self = {}
  if type(image) == 'string' then
    self.image = utils.loadImage(image)
  end
  self.quads = {};
  self.xtiles = xtiles
  self.ytiles = ytiles
  self.tilewidth = self.image:getWidth() / self.xtiles
  self.tileheight = self.image:getHeight() / self.ytiles
  for y=0,ytiles - 1 do
    for x=0,xtiles - 1 do
      table.insert(self.quads, love.graphics.newQuad(
                x * self.tilewidth, y * self.tileheight,
                self.tilewidth, self.tileheight,
                self.image:getWidth(), self.image:getHeight()
      ))
    end
  end

  --
  -- Inputs: 
  --    X : X position of where to draw
  --    Y : Y position of where to draw
  --
  --    tileNum : Number of tile to draw
  --      or
  --    tileX : X position of tile to draw
  --    tileY : Y position of tile to draw
  --
  --
  self.drawXY = function(self, x, y, tileX, tileY, r, sx, sy, ox, oy)
    local tileNum = tileY and tileY * self.xtiles + tileX + 1 or tileX
    self:draw(x, y, tileNum, r, sx, sy, ox, oy)
  end

  self.draw = function(self, x, y, tileNum, r, sx, sy, ox, oy)
    assert(tileNum > 0 and tileNum <= #self.quads, 'Invalid tileNum: ' .. tileNum)
    love.graphics.drawq(self.image, self.quads[tileNum], x, y, r, sx, sy, ox, oy)
  end

  return self
end

function LuaTileset(luasource)
  local tileset = dofile(luasource)
  if type(tileset) == 'table' then
    local self = Tileset(tileset.image.source, tileset.tilesx, tileset.tilesy)
    self.anims = tileset.anims
    return self
  else
    return nil
  end
end

