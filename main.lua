--
-- This is just a simple testing file to make sure these libraries work
-- Probably won't work if you don't have all the same images I have :P
--

require 'vector'
require 'camera'
require 'loader'
require 'utils'
require 'tileset'
require 'player'
require 'keyhandler'
require 'screenhandler'
require 'menuhandler'

function love.load()
  WIDTH = love.graphics.getWidth()
  HEIGHT = love.graphics.getHeight()
  center = vector.Vector:new(WIDTH/2,HEIGHT/2)

  image = utils.loadImage('gfx/ball.png')
  map = loader.LoadMapLove('maps/level1.tmx')
  --utils.PrintTable(map.objectgroups)
  for i,v in ipairs(map.tilesets.images) do
    v.image = tileset.Tileset(v.source, v.tileX, v.tileY)
  end

  camera = camera.Camera(WIDTH - map.width, HEIGHT - map.height)

  -- Get player start
  local start = map:FindObject('start', 'player')

  p = player.Player(start.x, start.y)

  love.keyboard.setKeyRepeat(0.1, 0.01)

  gravity = vector.Vector:new(0, 0.2)

  keyhandle = keyhandler.KeyHandler('test.xml')

  screens = screenhandler.ScreenHandler()
  menu = menuhandler.MenuHandler()
  menu:addItem("Start", function() screens.current = 2 end)
  menu:addItem("Controls")
  menu:addItem("UP",nil,"Controls")
  menu:addItem("DOWN",nil,"Controls")
  menu:addItem("LEFT",nil,"Controls")
  menu:addItem("RIGHT",nil,"Controls")
  menu:addItem(function() return "Bunnies: " .. p.pos.x end)
  menu:addItem("Quit", function() love.event.push('quit') end)
  screens:addScreen(menu.screen)
  screens:addScreen({
    camera = camera,
    map = map,
    draw = function(self)
      for tile, x, y in loader.tileIter(self.camera, self.map:FindLayer('Display'), self.map.tilesets.images[1]) do
        local usetile = self.map.tilesets.tiles[tonumber(tile)]
        if usetile then
          usetile.image.image:draw(x, y, tonumber(tile))
        end
      end

      p:draw(camera:drawPos(p.pos.x, p.pos.y))

      love.graphics.print('X: '.. p.pos.x .. ' Y: ' .. p.pos.y, 10, 10)
      love.graphics.print('X: '.. camera.x .. ' Y: ' .. camera.y, 10, 30)
    end,
    update = function(self, dt)
      p:update(dt)
      p:collide(map:FindLayer('Collision'))

      --p.vel:add(gravity)

      camera:update(
        math.floor(-p.pos.x + center.x),
        math.floor(-p.pos.y + center.y)
      )
    end,
    keyhandle = function(self, keys, key)
      p:handleKeyPress(keys.keys, key)
    end
  })
  screens:addScreen({
    fade = 1,
    enter = function(self) self.fade = 1 end,
    draw = function(self)
      love.graphics.setColor(255,255,255, self.fade)
      love.graphics.print('BLARGH', 200, 200)
    end,
    update = function(self, dt)
      if self.fade % 2 == 1 then
        self.fade = self.fade + 2
        if self.fade >= 255 then self.fade = 254 end
      else
        self.fade = self.fade - 2
        if self.fade <= 0 then self.fade = 1 end
      end
    end,
    keyhandle = function(self, keys, key)
    end
  })
end

function love.update(dt)
  screens:update(dt)
end

function love.draw()
  screens:draw()
end

function love.keypressed(key, uni)
  if key == 'escape' or key == 'q' then
    love.event.push('quit')
  elseif key == ' ' then
    screens:switchScreen(screens.current < 3 and screens.current + 1 or 1)
  end
  screens:keyhandle(keyhandle, key)
end

function love.quit()
  keyhandle:write()
end
