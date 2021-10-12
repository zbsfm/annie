local TextureC = include "mi-eng/lib/TextureC_engine"

engine.name = "TextureC"

function init()

  -- Add params
  TextureC.add_params()

  -- initialize params
  params:set("pitch", 0)
  params:set("position",0.5)
  params:set("grainsize",0)
  params:set("density",0.5)
  params:set("texture",0.5)
  params:set("drywet",0.5)
  params:set("in_gain",0.5)
  params:set("reverb",0)
  params:set("spread",1)
  params:set("feedback",0)
  params:set("freeze",1)
  params:set("mode",0)
  params:set("lofi",0)
  params:set("trig",0)

  redraw()
end

keys = {0, 0, 0}
function key(k,z)
  keys[k] = z
  if z == 1 then
    if keys[2] == 1 and keys[3] == 0 then -- just k2?
      print("k2 pressed")
      active_group = util.wrap(active_group - 1, 1, 3)
    elseif keys[3] == 1 and keys[2] == 0 then -- just k3?
      print("k3 pressed")
      active_group = util.wrap(active_group + 1, 1, 3)
    end
  elseif(keys[2] == 1 or keys[3] == 1) then -- both k2 and k3?
      print("k2 and k3 pressed")
      if params:get('freeze') == 2 then params:set('freeze', 1)
      else params:set('freeze', 2) end
  end
  redraw()
end

function enc(n,d)
  last_delta = param_names[(active_group * 3 - 2) + (n - 1)]
  params:delta(last_delta, d)
  redraw()
end

names = {'PITCH', 'DENSITY', 'SIZE', 'TEXTURE', 'MIX', 'STEREO', 'FEEDBACK', 'REVERB'}
param_names = {'pitch', 'density', 'grainsize', 'texture', 'drywet', 'spread', 'feedback', 'reverb', 'position'}
active_group = 1
truth_table = {[1] = true, [2] = true, [4] = true} -- params that start from the middle
last_delta = 'reverb'

function redraw()
  -- screen redraw
  screen.clear()
  screen.aa(1)
  screen.line_width(3)
  
  for i=1, 8 do --vertical sliders
    local pos = (i * 16) - 2

    if i >= (active_group * 3 - 2) and (i <= active_group * 3) then -- are we in the active control group?
      screen.level(7)
    else
      screen.level(2)
    end

    screen.text_rotate(pos - 8, 2, names[i], 90) -- draw param names
    screen.level(2)
    screen.move(pos, 40)
    screen.line(pos, 2)
    screen.stroke() -- draw param sliders


    screen.level(15)
    if truth_table[i] then screen.move(pos, 19) -- bipolar param?
    else screen.move(pos, 40) end
    
    if i == 1 then screen.line(pos, 40 - params:get(param_names[i]) * 0.01 * 38 - 19) -- fix pitch scaling for graphic
    else screen.line(pos, 40 - params:get(param_names[i] ) * 38) end -- draw param position bars
    screen.stroke()
  end
  
  screen.level(2) -- last touched param
  screen.move(128, 50)
  screen.text_right(last_delta .. ':  ' .. params:get(last_delta))

  screen.level(2)
  screen.move(0, 56) -- horizontal slider
  screen.line(128, 56)
  screen.stroke()

  screen.level(15)
  screen.move(2 + params:get('position') * 124 - 2, 56) -- horizontal indicator
  screen.line_rel(4, 0)
  screen.stroke()

  screen.move(4, 64)
  if active_group == 3 then screen.level(15)
  else screen.level(2) end
  screen.text("POSITION") -- POSITION text

  screen.move(124, 64)
  if params:get('freeze') == 2 then screen.level(15); screen.text_right("FROZEN!") end

  screen.update()
end
