local UI = require "ui"
local TextureC = include "mi-eng/lib/TextureC_engine"

engine.name = "TextureC"

local pitch = 0 -- (+-48.0)
local position = 0.6 -- (0 -- 1)
local size = 0.2 -- (0 -- 1)
local dens = 0.25 -- (0 -- 1)
local texture = 0.1 -- (0 -- 1)
local drywet = 0.5 -- (0 -- 1)
local in_gain = 2 -- 0.125 -- 8
local spread = 1 -- (0 -- 1)
local rvb = 0.2 -- (0 -- 1)
local feedback = 0.2 -- (0 -- 1)
local freeze = 0 -- (0 -- 1)
local mode = 0 -- (0 -- 3)
local lofi = 0 -- (0 -- 1)
local trig = 0 -- (0 -- 1)

local controls = {}
local param_assign = {"pitch","position","grainsize","density","texture","drywet","in_gain","reverb","spread","feedback","freeze","mode","lofi"}
local clouds_mode = {"Granular","Stretch","Looping_Delay","Spectral"}
local legend = ""
local defualt_midicc = 32

function init()

  -- Add params
  TextureC.add_params()
  TextureC.add_lfo_params()

  -- initialize params
  params:set("pitch", pitch)
  params:set("position",position)
  params:set("grainsize",size)
  params:set("density",dens)
  params:set("texture",texture)
  params:set("drywet",drywet)
  params:set("in_gain",in_gain)
  params:set("reverb",rvb)
  params:set("spread",spread)
  params:set("feedback",feedback)
  params:set("freeze",freeze)
  params:set("mode",mode)
  params:set("lofi",lofi)
  params:set("trig",trig)

  legend = clouds_mode[params:get("mode")+1]

  -- UI controls
  controls = {}
  controls.pitch = {ui = nil, midi = nil,}
  controls.position = {ui = nil, midi = nil,}
  controls.grainsize = {ui = nil, midi = nil,}
  controls.density = {ui = nil, midi = nil,}
  controls.texture = {ui = nil, midi = nil,}
  controls.drywet = {ui = nil, midi = nil,}
  controls.in_gain = {ui = nil, midi = nil,}
  controls.reverb = {ui = nil, midi = nil,}
  controls.spread = {ui = nil, midi = nil,}
  controls.feedback = {ui = nil, midi = nil,}
  controls.freeze = {ui = nil, midi = nil,}
  controls.mode = {ui = nil, midi = nil,}
  controls.lofi = {ui = nil, midi = nil,}



  -- UI
  local row1 = 12
  local row2 = 30
  local row3 = 48

  local offset = 19
  local col1 = 3
  local col2 = col1+offset
  local col3 = col2+offset
  local col4 = col3+offset
  local col5 = col4+offset
  local col6 = col5+offset
  local col7 = col6+offset

  local col8 = 116
  
  controls.pitch.ui = UI.Dial.new(col1, row1, 10, 0, 0, 1, 0.01, 0, {},"", "pit")
  controls.position.ui = UI.Dial.new(col2, row1, 10, 0, 0, 1, 0.01, 0, {},"", "pos")
  controls.grainsize.ui = UI.Dial.new(col3, row1, 10, 0, 0, 1, 0.01, 0, {},"", "size")
  controls.density.ui = UI.Dial.new(col4, row1, 10, 0, 0, 1, 0.01, 0, {},"", "den")
  controls.texture.ui = UI.Dial.new(col5, row1, 10, 0, 0, 1, 0.01, 0, {},"", "tex")

  controls.drywet.ui = UI.Dial.new(col1, row2, 10, 0, 0, 1, 0.01, 0, {},"", "d-w")
  controls.in_gain.ui = UI.Dial.new(col2, row2, 10, 0, 0, 1, 0.01, 0, {},"", "gain")
  controls.reverb.ui = UI.Dial.new(col3, row2, 10, 0, 0, 1, 0.01, 0, {},"", "verb")
  controls.spread.ui = UI.Dial.new(col4, row2, 10, 0, 0, 1, 0.01, 0, {},"", "sprd")
  controls.feedback.ui = UI.Dial.new(col5, row2, 10, 0, 0, 1, 0.01, 0, {},"", "fb")

  controls.freeze.ui = UI.Dial.new(col1, row3, 10, 0, 0, 1, 1, 0, {},"", "frz")
  controls.lofi.ui = UI.Dial.new(col2, row3, 10, 0, 0, 1, 1, 0, {},"", "lofi")
  controls.mode.ui = UI.Dial.new(col4+10, row3, 10, 0, 0, 3, 1, 0, {},"", "mode")

  for k,v in pairs(controls) do
     controls[k].ui:set_value (params:get(k))
  end  
  
  
  redraw()
end

function key(n,z)
  -- key actions: n = number, z = state
  if n == 2 and z == 1 then
    engine.freeze(1)
  else
    engine.freeze(0)
  end
   if n == 3 and z == 1 then
    engine.trig(1)
  else
    engine.trig(0)
  end
  
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
  if n == 1 then
    params:delta("position", d)
    controls.position.ui:set_value (params:get("position"))
    --print("position",string.format("%.2f", params:get("position")))
  elseif n == 2 then
    params:delta("grainsize", d)
    controls.grainsize.ui:set_value (params:get("grainsize"))
  elseif n == 3 then
    params:delta("density", d)
    controls.density.ui:set_value (params:get("density"))
    --print("density",string.format("%.2f", params:get("density")))
--  elseif n == 4 then
--    params:delta("drywet", d)
    --print("density",string.format("%.2f", params:get("drywet")))
  end
  redraw()
end


function redraw()
  -- screen redraw
  screen.clear()
  
  screen.update()
end

function cleanup()
  -- deinitialization
end
