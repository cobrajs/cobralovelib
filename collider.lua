module(..., package.seeall)

require 'utils'
require 'vector'

function Collider()
  local self = {}

  self.elems = {}

  self.functions = {}

  local id = 1

  self.register = function(self, object, shapes, functions)
    assert(type(object) == 'table' and type(shapes) == 'table' and #shapes > 0 and type(functions) == 'table', 'Invalid types passed to register')

    table.insert(self.elems, ColliderElement(object, shapes, functions))
  end

  self.update = function(self, dt)
    for i, elem in ipairs(self.elems) do
      for j, collideElem in ipairs(self.elems) do
        if elem ~= collideElem and elem.collidesWith[collideElem] then
        end
      end
    end
  end

  return self
end

function ColliderElement(object, shapes, functions)
  local self = {
    object = object,
    shapes = shapes
    collidesWith = functions
  }

  return self
end

function Rect(x, y, width, height)
  self = vector.Vector:new(x,y)
  self.type = 'rect'
  self.width = width
  self.height = height

  return self
end

function Circle(x, y, r)
  self = vector.Vector:new(x, y)
  self.type = 'circle'
  self.r = r
  self.width = r * 2
  self.height = r * 2

  self.updatePos = function(self, x, y)
    self.x, self.y = x, y
  end

  return self
end
