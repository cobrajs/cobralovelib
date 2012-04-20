module(..., package.seeall)

assert(type(love) ~= nil, 'Love2D is required for this package')

require 'xml'
require 'utils'
require 'loader'

function KeyHandler(filename)
  self = {}

  self.keys = {}
  self.actions = {}
  self.filename = filename

  self.load = function(self)
    f=io.open(self.filename)
    local xmlString = f:read('*a')
    f:close()
    local parsedXML = xml.LoadXML(xmlString)
    local keys = xml.FindAllInXML(parsedXML, 'key')
    for _,v in ipairs(keys) do
      self.keys[v.xarg.key] = v.xarg.action
      if type(self.actions[v.xarg.action]) == 'table' then
        table.insert(self.actions[v.xarg.action], v.xarg.key)
      else
        self.actions[v.xarg.action] = {v.xarg.key}
      end
    end
  end

  self:load()

  self.write = function(self)
    local temp = {keys = {}}
    for k,v in pairs(self.keys) do
      table.insert(temp, {key = k, action = v})
    end
    local xmlString = xml.WriteXML(temp)
    love.filesystem.write(self.filename, xmlString)
  end

  return self
end
