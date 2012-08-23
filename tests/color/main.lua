--
-- Tests for Color
--

package.path = package.path .. ';../../?.lua'
require('color')

function love.load()
  trans = color.blue
  col = color.green
end

function love.update(dt)
  love.timer.sleep(0.1)
end

function love.draw()
  love.graphics.setColor(color.white.rgba)
  love.graphics.print('Transition from Green to Blue', 5, 5)
  for i=1,100 do
    love.graphics.setColor(col:transition(trans, i).rgba)
    love.graphics.rectangle('fill', i * 3, 20, 3, 200)
  end

  love.graphics.setColor(color.white.rgba)
  love.graphics.print('Average of pure Green and pure Blue', 5, 230)
  love.graphics.setColor(col.rgba)
  love.graphics.rectangle('fill', 1, 250, 50, 50)
  love.graphics.setColor(col:average(trans).rgba)
  love.graphics.rectangle('fill', 51, 250, 50, 50)
  love.graphics.setColor(trans.rgba)
  love.graphics.rectangle('fill', 101, 250, 50, 50)

  love.graphics.setColor(color.white.rgba)
  love.graphics.print('Fade to 50%', 5, 330)
  love.graphics.setColor(col.rgba)
  love.graphics.rectangle('fill', 1, 350, 50, 50)
  love.graphics.setColor(col:fade(50).rgba)
  love.graphics.rectangle('fill', 51, 350, 50, 50)
end

function love.keypressed(key, uni)
  if key == 'escape' or key == 'q' then
    love.event.push('quit')
  end
end
