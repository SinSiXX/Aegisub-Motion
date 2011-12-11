﻿--[[ 
I THOUGHT I SHOULD PROBABLY INCLUDE SOME LICENSING INFORMATION IN THIS
BUT I DON'T REALLY KNOW VERY MUCH ABOUT COPYRIGHT LAW AND IT ALSO SEEMS LIKE MOST
COPYRIGHT NOTICES JUST KIND OF YELL AT YOU IN ALL CAPS. AND APPARENTLY PUBLIC
DOMAIN DOES NOT EXIST IN ALL COUNTRIES, SO I FIGURED I'D STICK THIS HERE SO
YOU KNOW THAT YOU, HENCEFORTH REFERRED TO AS "THE USER" HAVE THE FOLLOWING
INALIABLE RIGHTS:

  0. THE USER should realize that starting a list with 0 in a document that contains 
    lua code is actually SOMEWHAT IRONIC.
  1. THE USER can use this piece of poorly written code, henceforth referred to as
    THE SCRIPT, to do the things that it claims it can do. 
  2. THE USER should not expect THE SCRIPT to do things that it does not expressly
    claim to be able to do, such as make coffee or print money. 
  3. THE WRITER, henceforth referred to as I or ME, depending on the context, holds
    no responsibility for any problems that THE SCRIPT may cause, such as if it 
    murders your dog.
  4. THE USER is expected to understand that this is just some garbage that I made
    up and that any and all LEGALLY BINDING AGREEMENTS THAT THE USER HAS AGREED
    TO UPON USAGE OF THE SCRIPT ARE UP TO THE USER TO DISCOVER ON HIS OR HER OWN,
    POSSIBLY THROUGH CLAIRVOYANCE OR MAYBE A SPIRITUAL MEDIUM.
  5. For fear of someone else attempting to steal my INTELLECTUAL PROPERTY, which
    is the result of MY OWN PERSONAL EFFORT and has come at the consequence of the
    EVAPORATION of ALL OF MY FREE TIME, I have decided to make ARBITRARY PARTS of
    this script PROPRIETARY CODE that THE USER IS ABSOLUTELY AND EXPLICITLY VERBOTEN
    FROM LOOKING AT AT ANY TIME.
  6. This LICENSE AGREEMENT, which is IMPLICITLY AGREED TO upon usage of the script,
    regardless of whether or not THE USER has actually read it, IS RETROACTIVELY
    EXTENSIBLE. This means that ANY SUBSEQUENT TERMS ADDED TO IT IMMEDIATELY APPLY
    TO ALL OF THE USER'S ACTIONS IN THE PAST, and THE USER should be VERY CAREFUL
    that they have not previously VIOLATED any FUTURE TERMS AND CONDITIONS lest they 
    be legally OPPRESSED by ME in a COURT OF LAW.
  7. Should THE SCRIPT turn out to secretly be a cleverly disguised COMPUTER VIRUS in
    disguise, THE USER has agreed that any or all information it has gathered hereby
    belongs to ME and I CLAIM FULL RIGHTS OF IT, INCLUDING THE RIGHT TO REDISTRIBUTE
    IT AS I SEE FIT. THE USER also agrees to make NO PREVENTATIVE MEASURES to keep
    HIS OR HER computer from becoming PART OF THE BOTNET HIVEMIND. FURTHERMORE, THE
    USER agrees to take FULL PERSONAL RESPONSIBILITY for ANY ILLEGAL ACTIVITIES that
    HIS OR HER computer partakes in while under the CONTROL OF THE BOTNET.
--]]

script_name = "Aegisub-Motion"
script_description = "Adobe After Effects 6.0 keyframe data parser for Aegisub" -- also it suffers from memory leaks
script_author = "torque"
script_version = "010011101" -- no, I have no idea how this versioning system works either.
include("karaskel.lua")

gui = {} -- I'm really beginning to think this shouldn't be a global variable
gui.main = {
  [1] = { class = "textbox"; -- 1 - because it is best if it starts out highlighted.
      x =0; y = 1; height = 4; width = 10;
    name = "mocpat"; hint = "Full path to file. No quotes or escapism needed."},
  [2] = { class = "textbox";
      x = 0; y = 18; height = 4; width = 10;
    name = "preerr"; hint = "Any lines that didn't pass the prerun checks are noted here."},
  [3] = { class = "textbox";
      x = 0; y = 13; height = 4; width = 10;
    name = "mocper"; hint = "YOUR FRIENDLY NEIGHBORHOOD MATH.RANDOM() AT WORK"},
  [4] = { class = "label";
      x = 0; y = 12; height = 1; width = 10;
    label = "                                                      MOTD"}, --"  Enter the file to the path containing your shear/perspective data."},
  [5] = { class = "label";
      x = 0; y = 0; height = 1; width = 10;
    label = " Either give the filepath to the motion data, or paste it in its entirety."},
  -- GIVE ME SOME (WHITE)SPACE
  [6] = { class = "label";
      x = 0; y = 6; height = 1; width = 10;
    label = "What tracking data should be applied?              Rounding"}, -- allows more accurate positioning >_>
  [7] = { class = "label";
      x = 0; y = 7; height = 1; width = 1;
    label = "Position:"},
  [8] = { class = "checkbox";
      x = 1; y = 7; height = 1; width = 1;
    value = true; name = "pos"},
  [9] = { class = "label";
      x = 0; y = 8; height = 1; width = 1;
    label = "Scale:"},
  [10] = { class = "checkbox";
      x = 1; y = 8; height = 1; width = 1;
    value = true; name = "scl"},
  [11] = { class = "label";
      x = 2; y = 8; height = 1; width = 1;
    label = "Border:"},
  [12] = { class = "checkbox";
      x = 3; y = 8; height = 1; width = 1;
    value = true; name = "bord"},
  [13] = { class = "label";
      x = 4; y = 8; height = 1; width = 1;
    label = "Shadow:"},
  [14] = { class = "checkbox";
      x = 5; y = 8; height = 1; width = 1;
    value = true; name = "shad"},
  [15] = { class = "label";
      x = 0; y = 9; height = 1; width = 1;
    label = "Rotation:"},
  [16] = { class = "checkbox";
      x = 1; y = 9; height = 1; width = 1;
    value = false; name = "rot"},
  [17] = { class = "intedit"; -- these are both retardedly wide and retardedly tall. They are downright frustrating to position in the interface.
      x = 7; y = 7; height = 1; width = 3;
    value = 2; name = "pround"; min = 0; max = 5;},
  [18] = { class = "intedit";
      x = 7; y = 8; height = 1; width = 3;
    value = 2; name = "sround"; min = 0; max = 5;},
  [19] = { class = "intedit";
      x = 7; y = 9; height = 1; width = 3;
    value = 2; name = "rround"; min = 0; max = 5;},
  ---[[
  [20] = { class = "label";
      x = 0; y = 10; height = 1; width = 5;
    label = "Read/write script header:"},
  [21] = { class = "checkbox";
      x = 5; y = 10; height = 1; width = 1;
    value = true; name = "conf"},
  --]]
  [22] = { class = "label";
      x = 0; y = 11; height = 1; width = 3;
    label = "VSfilter Compatibility:"},
  [23] = { class = "checkbox";
      x = 3; y = 11; height = 1; width = 1;
    value = false; name = "vsfilter"},
  [24] = { class = "label";
      x = 9; y = 11; height = 1; width = 2;
    label = ":esreveR"},
  [25] = { class = "checkbox";
      x = 8; y = 11; height = 1; width = 1;
    value = false; name = "reverse"}
}

gui.motd = { -- pointless because math.random doesn't work properly - BUT WHAT ABOUT OS.EXECUTE
  "The culprit was a huge truck.";
  "Error 0x0045AF: Runtime requested to be terminated in an unusual fashion.";
  "Powered by 100% genuine sweatshop child laborers.";
  "vsfilter hates you."
}

gui.halp = { -- okay, yeah, I'm an asshole. Fine. Whatever.
  { class = "label";
      x = 0; y = 0; height = 1; width = 1;
    label = "YOU MOTION TRACK THE DATAS"},
  { class = "label";
      x = 0; y = 1; height = 1; width = 1;
    label = "AND THEN YOU CLICK THE BUTTONS"}
}

function prerun_czechs(sub, sel, act) -- for some reason, act always returns -1 for me.
  local strt
  for x = 1,#sub do -- so if there are like 10000 different styles then this is probably a really bad idea but I DON'T GIVE A FUCK
    if sub[x].class == "dialogue" then -- BECAUSE I SAID SO
      strt = x-1 -- start line of dialogue subs
      break
    end
  end
  aegisub.progress.title("Collecting Gerbils")
  local accd = {}
  local _ = nil
  accd.meta, accd.styles = karaskel.collect_head(sub, false) -- dump everything I need later into the table so I don't have to pass o9k variables to the other functions
  accd.lines = {}
  accd.endframe = aegisub.frame_from_ms(sub[sel[1]].end_time) -- get the end frame of the first selected line
  accd.startframe = aegisub.frame_from_ms(sub[sel[1]].start_time) -- get the start frame of the first selected line
  accd.poserrs, accd.alignerrs = {}, {}
  accd.errmsg = ""
  local numlines = #sel
  for i, v in pairs(sel) do -- burning cpu cycles like they were no thing
    local opline = table.copy(sub[v]) -- I have no idea if a shallow copy is even an intelligent thing to do here
    opline.xscl, opline.yscl, opline.zrot, opline.trans = {}, {}, {}, {} -- have to make table skeletons so we can use table.insert
    opline.bord, opline.xbord, opline.ybord = {}, {}, {}
    opline.shad, opline.xshad, opline.yshad = {}, {}, {}
    opline.num = v -- this is for, uh, later.
    karaskel.preproc_line(sub, accd.meta, accd.styles, opline) -- get that extra position data
    aegisub.log(5,"Line %d's style name is: %s\n",v-strt,opline.style) -- lines with more than one style can suck a dick (see: \r[stylename])
    opline.sdxscl = accd.styles[opline.style].scale_x
    aegisub.log(5,"Line %d's style's xscale is: %g\n",v-strt,opline.xscl)
    opline.sdyscl = accd.styles[opline.style].scale_y
    aegisub.log(5,"Line %d's style's yscale is: %g\n",v-strt,opline.yscl)
    opline.ali = accd.styles[opline.style].align
    aegisub.log(5,"Line %d's style's alignment is: %d\n",v-strt,opline.ali)
    opline.sdzrot = accd.styles[opline.style].angle
    aegisub.log(5,"Line %d's style's z-rotation is: %d\n",v-strt,opline.zrot)
    opline.sdbord = accd.styles[opline.style].outline
    aegisub.log(5,"Line %d's style's border is: %d\n",v-strt,opline.xbord)
    opline.sdshad = accd.styles[opline.style].shadow
    aegisub.log(5,"Line %d's style's shadow is: %d\n",v-strt,opline.xshad)
    local pre,ftag = opline.text:match("(.-){(.-)}") -- so this is what they mean by an edge case. I think. Either way, it's annoying as hell.
    if pre ~= "" then
      opline.dsx,opline.dsy,opline.dbord,opline.dshad,opline.drot = true,true,true,true,true -- this table is getting rly hueg. >____>
    else
      if not ftag:match("\\fscx([%d%.]+)") then
        opline.dsx = true -- inconsistent naming ftw?
      end
      if not ftag:match("\\fscy([%d%.]+)") then
        opline.dsy = true
      end
      if not ftag:match("\\bord([%d%.]+)") then
        opline.dbord = true
      end
      if not ftag:match("\\shad([%-%d%.])") then
        opline.dshad = true
      end
      if not ftag:match("\\frz?([%-%d%.]+)") then
        opline.drot = true
      end
    end
    opline.xpos,opline.ypos = opline.text:match("\\pos%(([%-%d%.]+),([%-%d%.]+)%)") -- always the first one
    opline.xorg,opline.yorg = opline.text:match("\\org%(([%-%d%.]+),([%-%d%.]+)%)") -- idklol
    opline.startframe, opline.endframe = aegisub.frame_from_ms(opline.start_time), aegisub.frame_from_ms(opline.end_time)
    local length = opline.end_time - opline.start_time
    --local one = aegisub.ms_from_frame(opline.start_frame)
    --local two = aegisub.ms_from_frame(opline.start_frame+1)
    --local transtart = round(one - opline.start_time + (two - one) / 2,0) -- right.
    for a in string.gfind(opline.text,"%{(.-)%}") do -- this will find comment/override tags yo (on an unrelated note, the .- lazy repition is nice. It's shorter than .+? at least.)
      -- for b in string.gfind(a,"(\\[^\\]+)") do --find any thing between \ and \. Real comment lines should be separate from override tag blocks.
      aegisub.log(5,"Found a comment/override command in line %d: %s\n",v-strt,a)
      local fx = a:match("\\fscx([%d%.]+)") -- why was I using string.find before? I can't even remember.
      local fy = a:match("\\fscy([%d%.]+)") -- these should all be gc'd after this loop
      local ali = a:match("\\an([1-9])")
      local frz = a:match("\\frz?([%-%d%.]+)") -- \fr is an alias for \frz
      local bord = a:match("\\bord([%d%.]+)")
      local xbord = a:match("\\xbord([%d%.]+)") 
      local ybord = a:match("\\ybord([%d%.]+)")
      local shad = a:match("\\shad([%-%d%.])")
      local xshad = a:match("\\xshad([%-%d%.]+)")
      local yshad = a:match("\\yshad([%-%d%.]+)")
      local resetti = a:match("\\r([^\\|}]+)") -- not sure I actually want to support this
      local fad_s,fad_e = a:match("\\fad%(([%d]+),([%d]+)%)") -- uint
      if fad_s then
        if fad_s == 0 and fad_e > 0 then
          string.gsub(a,"\\fad%(([%d]+),([%d]+)%)",string.format("\\alpha&H00&\\t(%d,%d,1,\\alpha&HFF&)",length-fad_e,length))
        elseif fad_s > 0 and fad_e == 0 then
          string.gsub(a,"\\fad%(([%d]+),([%d]+)%)",string.format("\\alpha&HFF&\\t(%d,%d,1,\\alpha&H00&)",0,fad_s))
        elseif fad_s > 0 and fad_e > 0 then
          string.gsub(a,"\\fad%(([%d]+),([%d]+)%)",string.format("\\alpha&HFF&\\t(%d,%d,1,\\alpha&H00&)\\t(%d,%d,1,\\alpha&HFF&)",0,fad_s,length-fad_e,length))
        else 
          string.gsub(a,"\\fad%(([%d]+),([%d]+)%)","") -- GET RID OF THAT USELESS SHIT
        end
      end
      local fade_a,fade_a2,fade_a3,fade_s,fade_m,fade_m2,fade_e = a:match("\\fade%(([%d]+),([%d]+),([%d]+),([%d]+),([%d]+),([%d]+),([%d]+)%)") -- This is a large pita fuck you fuck you fuck you fuck you fuck you fuck you if you use this
      for t_start,t_end,t_exp,t_eff in string.gfind(a,"\\t%(([%-%d]+),([%-%d]+),([%d%.]*),?([\\%.%-&%w%(%)]+)%)") do -- this will return an empty string for t_exp if no exponential factor is specified
        if t_exp == "" then t_exp = 1 end -- set it to 1 because stuff and things
        table.insert(opline.trans,{tonumber(t_start),tonumber(t_end),tonumber(t_exp),t_eff}); aegisub.log(5,"Line %d: \\t(%g,%g,%g,%s) found\n",v-strt,t_start,t_end,t_exp,t_eff)
      end
      if fx then table.insert(opline.xscl,tonumber(fx)); aegisub.log(5,"Line %d: \\fscx%g found\n",v-strt, fx) end
      if fy then table.insert(opline.yscl,tonumber(fy)); aegisub.log(5,"Line %d: \\fscy%g found\n",v-strt, fy) end
      if bord then table.insert(opline.bord,tonumber(bord)); aegisub.log(5,"Line %d: \\bord%g found\n",v-strt, bord) end
      if xbord then table.insert(opline.xbord,tonumber(xbord)); aegisub.log(5,"Line %d: \\xbord%g found\n",v-strt, xbord) end
      if ybord then table.insert(opline.ybord,tonumber(ybord)); aegisub.log(5,"Line %d: \\ybord%g found\n",v-strt, ybord) end
      if shad then table.insert(opline.bord,tonumber(shad)); aegisub.log(5,"Line %d: \\shad%g found\n",v-strt, shad) end
      if xshad then table.insert(opline.xbord,tonumber(xshad)); aegisub.log(5,"Line %d: \\xshad%g found\n",v-strt, xshad) end
      if yshad then table.insert(opline.ybord,tonumber(yshad)); aegisub.log(5,"Line %d: \\yshad%g found\n",v-strt, yshad) end
      if frz then table.insert(opline.zrot,tonumber(frz)); aegisub.log(5,"Line %d: \\frz%g found\n",v-strt, frz) end
      if ali then opline.ali = tonumber(ali); aegisub.log(5,"Line %d: \\an%d found\n",v-strt, ali) end -- the final \an is the one that's used.
    end
    if not opline.xpos or not opline.ypos then -- just to be safe
      table.insert(accd.poserrs,{i,v})
      accd.errmsg = accd.errmsg..string.format("Line %d does not seem to have a position override tag.\n", v-strt)
    end
    --aegisub.log(5,"%d",opline.ali)
    if tonumber(opline.ali) ~= 5 then
      table.insert(accd.alignerrs,{i,v})
      accd.errmsg = accd.errmsg..string.format("Line %d does not seem aligned \\an5.\n", v-strt)
    end
    if opline.startframe < accd.startframe then -- make timings flexible. Number of frames total has to match the tracked data but
      aegisub.log(5,"Line %d: startframe changed from %d to %d\n",v-strt,accd.startframe,opline.startframe)
      accd.startframe = opline.startframe
    end
    if opline.endframe > accd.endframe then -- individual lines can be shorter than the whole scene
      aegisub.log(5,"Line %d: endframe changed from %d to %d\n",v-strt,accd.endframe,opline.endframe)
      accd.endframe = opline.endframe
    end
    if opline.endframe-opline.startframe>1 then
      table.insert(accd.lines,opline) -- SOLVED
    end
    opline.comment = true
    sub[v] = opline
    opline.comment = false -- because fuck you shallow copy.
  end
  local length = #accd.lines
  local copy = {}
  for i,v in ipairs(accd.lines) do
    copy[length-i+1] = v
  end
  accd.lines = copy -- this is probably going to do something horrible and fuck everything up because the table "copying" mechanics are ashdsiuhaslhasd
  length = nil
  copy = nil -- DOING MY OWN GARBAGE COLLECTION NOW LIKE A PRO
  accd.lvidx, accd.lvidy = aegisub.video_size()
  accd.shx, accd.shy = accd.meta.res_x, accd.meta.res_y
  accd.totframes = accd.endframe - accd.startframe
  accd.toterrs = #accd.alignerrs + #accd.poserrs
  if accd.shx ~= accd.lvidx or accd.shy ~= accd.lvidy then -- check to see if header video resolution is same as loaded video resolution
    accd.errmsg = string.format("Header x/y res (%d,%d) does not match video (%d,%d).\n", accd.shx, accd.shy, accd.lvidx, accd.lvidy)..accd.errmsg
  end
  if accd.toterrs > 0 then
    accd.errmsg = "The lines noted below need to be checked.\n"..accd.errmsg
  else
    accd.errmsg = "None of the selected lines seem to be problematic.\n"..accd.errmsg 
  end
  assert(#accd.lines>0,"You have to select at least one line that is longer than one frame long.") -- pro error checking
  init_input(sub,accd)
end

function init_input(sub,accd) -- THIS IS PROPRIETARY CODE YOU CANNOT LOOK AT IT
  aegisub.progress.title("Selecting Gerbils")
  local ourkeys = check_head(sub)
  gui.main[2].text = accd.errmsg -- insert our error messages
  -- local randfile = io.popen("echo %RANDOM% $RANDOM")
  -- local rand = randfile:read("*l"):match("[0-9]+")
  -- randfile:close() -- close file handle without waiting for gc to do it manually
  --[[
      works (tested windows and linux), and is a lot less messy than the previous shell-based method I had
      but it still pops up that terminal window, and since we don't need anything like a cryptographically
      secure random number generator (not like the environmental variables are anyway) I don't see a reason
      to use it
  --]]
  local rand = ((os.clock()*os.time()+os.clock())*100) -- I suppose it's bad if this gives more variation than does math.random().
  gui.main[3].text = gui.motd[math.floor(rand%4)+1] -- this would work a lot better with more than 4 items
  local button, config = aegisub.dialog.display(gui.main, {"Go","Abort","Help"})
  if button == "Go" then
    if config.conf then
      doThingsLikeWriteTheConfigurationToTheScriptWhileSuddenlyAdoptingOOStyleMethodNomenclature(config,sub,ourkeys)
    end
    if config.reverse then
      aegisub.progress.title("slibreG gnicniM") -- BECAUSE ITS FUNNY GEDDIT
    else
      aegisub.progress.title("Mincing Gerbils")
    end
    frame_by_frame(sub,accd,config)
  elseif button == "Help" then
    aegisub.progress.title("Helping Gerbils?")
    help(sub,accd)
  else
    aegisub.progress.task("ABORT")
  end
  aegisub.set_undo_point("Motion Data")
end

function check_head(sub)
  local keytab = {}
  for i = 1, #sub do -- so it's like shooting in the dark
		if aegisub.progress.is_cancelled() then error("User cancelled") end
		local l = sub[i]
    if l.class == "info" then
      if l.key:match("aa%-mou") then
        keytab[l.key] = l.value..":"..tostring(i) -- really not sure how I want to structure this
      end
    end
  end
  return keytab
end

function doThingsLikeWriteTheConfigurationToTheScriptWhileSuddenlyAdoptingOOStyleMethodNomenclature(TableOfTheCollectedOptions,TheSubtitlesObjectToWriteTo,aTableOfRelevantHeaderKeyValuePairs)
  -- if no known values, always write to line 4 of the subtitles object
  for theKeysToTheTableOfTheOptions, theValuesThatCorrespondToTheKeys in pairs(TableOfTheCollectedOptions) do
    if aTableOfRelevantHeaderKeyValuePairs["aa-mou-"..theKeysToTheTableOfTheOptions] then
      local val,index = aTableOfRelevantHeaderKeyValuePairs["aa-mou-"..theKeysToTheTableOfTheOptions]:split()
    end
  end
  --[[
  -tracking options:
    Postion   [08]  Rounding  [17]
    Scale     [10]  Rounding  [18]
      Bord    [12]
      Shad    [14]
    Rotation  [12]  Rounding  [19]
  -miscellaneous:
    VSfilter  [23]
    Reverse   [25]
  --]]
end

function help(su,ac)
  local button,config = aegisub.dialog.display(gui.halp,{"Close"})
  if button=="Close" then
    init_input(su,ac)
  end
end
  
function parse_input(input)
  local ftab = {}
  local sect, care = 0, 0
  local mocha = {}
  mocha.xpos, mocha.ypos, mocha.xscl, mocha.yscl, mocha.zrot = {}, {}, {}, {}, {}
  local datams = io.open(input,"r")
  if datams then
    for line in datams:lines() do
      line = string.gsub(line,"[\r\n]*","") -- FUCK YOU CRLF
      table.insert(ftab,line) -- dump the lines from the file into a table.
    end
    datams:close()
  else
    input = string.gsub(input,"[\r]*","") -- SERIOUSLY FUCK THIS SHIT
    ftab = input:split("\n")
  end
  for keys, valu in ipairs(ftab) do -- idk it might be more flexible now or something
    ---[[
    if valu == "Position" then
    sect = sect + 1
    elseif valu == "Scale" then
    sect = sect + 2
    elseif valu == "Rotation" then
    sect = sect + 4
    elseif valu == nil then
    sect = 0
    end
    if sect == 1 then
      if valu:match("%d") then
        val = valu:split("\t")
        table.insert(mocha.xpos,tonumber(val[2]))
        table.insert(mocha.ypos,tonumber(val[3]))
      end
    elseif sect <= 3 and sect >= 2 then
      if valu:match("%d") then
        val = valu:split("\t")
        table.insert(mocha.xscl,tonumber(val[2]))
        table.insert(mocha.yscl,tonumber(val[3]))
      end
    elseif sect <= 7 and sect >= 4 then
      if valu:match("%d") then
        val = valu:split("\t")
        table.insert(mocha.zrot,-tonumber(val[2]))
      end
    end--]]
  end
  mocha.flength = #mocha.xpos
  assert(mocha.flength == #mocha.ypos and mocha.flength == #mocha.xscl and mocha.flength == #mocha.yscl and mocha.flength == #mocha.zrot,"The mocha data is not internally equal length.") -- make sure all of the elements are the same length (because I don't trust my own code).
  return mocha -- hurr durr
end

function frame_by_frame(sub,accd,opts)
  local mocha = parse_input(opts.mocpat) -- global variables have no automatic gc
  assert(accd.totframes==mocha.flength,"Number of frames from selected lines differs from number of frames tracked.")
  local _ = nil
  if not opts.scl then
    for k,d in ipairs(mocha.xscl) do
      d = 100
      mocha.yscl[k] = 100 -- so that yscl is changed too. 
    end
  end
  local operations = {} -- create a table and put the necessary functions into it, which will save a lot of if operations in the inner loop. This was the most elegant solution I came up with.
  --local eraser = {}
  if opts.pos then
    table.insert(operations,possify)
  end
  table.insert(operations,transformate) -- Just... always do it. Always.
  if opts.scl then
    if opts.vsfilter then
      table.insert(operations,VScalify)
    else
      table.insert(operations,scalify)
    end
    if opts.bord then
      table.insert(operations,bordicate)
    end
    if opts.shad then
      table.insert(operations,shadinate)
    end
  end
  if opts.vsfilter then
    opts.pround = 2 -- make it look better with libass?
    opts.sround = 2
    opts.rround = 2
  end
  if opts.rot then
    table.insert(operations,rotate)
  end
  for i,v in ipairs(accd.lines) do
    local fixit = ""
    if opts.scl then
      if accd.dsx then
        fixit = fixit.."\\fscx"..accd.sdxscl
      end
      if accd.dsy then
        fixit = fixit.."\\fscy"..accd.sdyscl
      end
      if opts.bord then
        if accd.dbord then
          fixit = fixit.."\\bord"..accd.sdbord
        end
      end
      if opts.shad then
        if accd.dshad then
          fixit = fixit.."\\shad"..accd.sdshad
        end
      end
    end
    if opts.rot and accd.drot then
      fixit = fixit.."\\frz"..accd.sdzrot
    end
    if fixit ~= "" then
      fixit = "{"..fixit.."}"
    end
    v.text = fixit..v.text
    fixit = nil -- lol gc
    local rstartf = v.startframe - accd.startframe + 1 -- start frame of line relative to start frame of tracked data
    local rendf = v.endframe - accd.startframe -- end frame of line relative to start frame of tracked data
    if opts.reverse then
      rstartf, rendf = rendf, rstartf -- reverse them to set the differences
    end
    if opts.rot then
      v.zrotd = {}
      for m,n in ipairs(v.zrot)
        table.insert(v.zrotd,mocha.zrot[rstartf] - n) -- idr there was something silly about this
      end
      if v.xorg then
        v.xorgd, v.yorgd = mocha.xpos[rstartf] - v.xorg, mocha.ypos[rstartf] - v.yorg -- not going to actually use this until I test it more.
      end
    end
    if v.xpos and opts.pos then
      v.xdiff, v.ydiff = mocha.xpos[rstartf] - v.xpos, mocha.ypos[rstartf] - v.ypos
    end
    --[[for ie, ei in ipairs(eraser) do
      v.text = string.gsub(v.text,ei,"")
    end--]]
    --v.text = string.gsub(v.text,"{}","") -- Aesthetics, my friend. Aesthetics.
    local orgtext = v.text -- tables are passed as references.
    if opts.pos and not v.xpos then
      aegisub.log(1,"Line %d is being skipped because it is missing a \\pos() tag and you said to track position. Moron.",v.num) -- yeah that should do it.
    else
      if opts.reverse then -- donkey dongs
        rstartf, rendf = rendf, rstartf -- un-reverse them
        for x = rstartf,rendf do
          if aegisub.progress.is_cancelled() then error("User cancelled") end
          local iter = rendf-x+1 -- hm
          v.ratx = mocha.xscl[iter]/mocha.xscl[rendf] -- DIVISION IS SLOW
          v.raty = mocha.yscl[iter]/mocha.yscl[rendf]
          v.start_time = aegisub.ms_from_frame(accd.startframe+iter-1)
          v.end_time = aegisub.ms_from_frame(accd.startframe+iter)
          v.time_delta = aegisub.ms_from_frame(accd.startframe+iter-1) - aegisub.ms_from_frame(accd.startframe)
          for vk,kv in ipairs(operations) do -- iterate through the necessary operations
            v.text = kv(v,mocha,opts,iter)
          end
          v.text = string.gsub(v.text,string.char(1),"")
          sub.insert(v.num+1,v)
          v.text = orgtext
        end
      else
        for x = rstartf,rendf do
          if aegisub.progress.is_cancelled() then error("User cancelled") end -- probably should have put this in here a long time ago
          v.ratx = mocha.xscl[x]/mocha.xscl[rstartf] -- DIVISION IS SLOW
          v.raty = mocha.yscl[x]/mocha.yscl[rstartf]
          v.start_time = aegisub.ms_from_frame(accd.startframe+x-1)
          v.end_time = aegisub.ms_from_frame(accd.startframe+x)
          v.time_delta = aegisub.ms_from_frame(accd.startframe+x-1) - aegisub.ms_from_frame(accd.startframe)
          for vk,kv in ipairs(operations) do -- iterate through the necessary operations
            v.text = kv(v,mocha,opts,x)
          end
          v.text = string.gsub(v.text,string.char(1),"") -- clean those suckers up
          sub.insert(v.num+x-rstartf+1,v)
          v.text = orgtext
        end
      end
    end
  end
end

function possify(line,mocha,opts,iter)
  local xpos = mocha.xpos[iter]-(line.xdiff*line.ratx) -- allocating memory like a bawss
  local ypos = mocha.ypos[iter]-(line.ydiff*line.raty)
  return string.gsub(line.text,"\\pos%([%-%d%.]+,[%-%d%.]+%)","\\"..string.char(1)..string.format("pos(%g,%g)",round(xpos,opts.pround),round(ypos,opts.pround))) -- ☺
end

function transformate(line,mocha,opts,iter)
  for ix,vx in ipairs(line.trans) do
    local t_s = ix[1] - line.time_delta -- well, that was easy
    local t_e = ix[2] - line.time_delta
    string.gsub(ix,"\\t%([%-%d]+,[%-%d]+,[%d%.]*,?[\\%.%-&%w%(%)]+%)","\\"..string.char(1)..string.format("t(%i,%i,%g,%s)",t_s,t_e,ix[3],ix[4]),1) -- I hate how messy this expression is
  end
end

function scalify(line,mocha,opts)
  for ix,vx in ipairs(line.xscl) do
    string.gsub(line.text,"\\fscx[%d%.]+","\\"..string.char(1)..string.format("fscx%g)",round(vx*line.ratx,opts.sround)),1)
  end
  for ix,vx in ipairs(line.yscl) do
    string.gsub(line.text,"\\fscy[%d%.]+","\\"..string.char(1)..string.format("fscy%g)",round(vx*line.raty,opts.sround)),1)
  end
  return line.text
end

function bordicate(line,mocha,opts)
  for ix, vx in ipairs(line.bord) do -- this is actually the very WRONG way to do this... fuck.
    string.gsub(line.text,"\\bord[%d%.]+","\\"..string.char(1)..string.format("bord%g)",round(vx*line.ratx,opts.sround)),1)
  end
  for ix, vx in ipairs(line.xbord) do
    string.gsub(line.text,"\\xbord[%d%.]+","\\"..string.char(1)..string.format("xbord%g)",round(vx*line.ratx,opts.sround)),1)
  end
  for ix, vx in ipairs(line.ybord) do
    string.gsub(line.text,"\\ybord[%d%.]+","\\"..string.char(1)..string.format("ybord%g)",round(vx*line.raty,opts.sround)),1)
  end
  return line.text
end

function shadinate(line,mocha,opts)
  for ix, vx in ipairs(line.shad) do
    string.gsub(line.text,"\\shad[%d%.]+","\\"..string.char(1)..string.format("shad%g)",round(vx*line.ratx,opts.sround)),1)
  end
  for ix, vx in ipairs(line.xshad) do
    string.gsub(line.text,"\\xshad[%d%.]+","\\"..string.char(1)..string.format("xshad%g)",round(vx*line.ratx,opts.sround)),1)
  end
  for ix, vx in ipairs(line.yshad) do
    string.gsub(line.text,"\\yshad[%d%.]+","\\"..string.char(1)..string.format("yshad%g)",round(vx*line.raty,opts.sround)),1)
  end
  return line.text
end

function VScalify(line,mocha,opts)
  for ix, vx in ipairs(line.xscl) do
    local xscl = round(line.xscl*line.ratx,2)
    local xlowend, xhighend, xdecimal = math.floor(xscl),math.ceil(xscl),xscl%1*100
    local xstart, xend = -xdecimal, 100-xdecimal
    string.gsub(line.text,"\\fscx[%d%.]+","\\"..string.char(1)..string.format("fscx%d\\t(%d,%d,\\"..string.char(1).."fscx%d)",xlowend,xstart,xend,xhighend),1)
  end
  for ix, vx in ipairs(line.yscl) do
    local yscl = round(line.yscl*line.raty,2)
    local ylowend, yhighend, ydecimal = math.floor(yscl),math.ceil(yscl),yscl%1*100
    local ystart, yend = -ydecimal, 100-ydecimal
    string.gsub(line.text,"\\fscy[%d%.]+","\\"..string.char(1)..string.format("fscy%d\\t(%d,%d,\\"..string.char(1).."fscy%d)",ylowend,ystart,yend,yhighend),1)
  end
  return line.text
end

function rotate(line,mocha,opts,iter)
  local orgx = mocha.xpos[iter]
  local orgy = mocha.ypos[iter] -- lol orgy
  string.gsub(line.text,"\\org%([%-%d%.]+,[%-%d%.]+%)","")
  string.gsub(line.text,"{",string.format("{\\org(%g,%g)",round(orgx,opts.rround),round(orgy,opts.rround)),1) -- INSERT
  for ix, vx in ipairs(line.zrotd) do
    local frz = mocha.zrot[iter]-vx
    string.gsub(line.text,"\\frz?[%d%.]+",string.format("\\"..string.char(1).."frz%g",round(frz,opts.rround)),1)
  end
  return line.text
end

function round(num, idp) -- borrowed from the lua-users wiki (all of the intelligent code you see in here is)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function string:split(sep) -- borrowed from the lua-users wiki (single character split ONLY)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

function isvideo() -- a very rudimentary (but hopefully efficient) check to see if there is a video loaded.
  return aegisub.video_size() and true or false -- (aegisub.video_size() and true) or false - if video_size() returns a value then the first part of the statement is true and therefore it returns true. Otherwise, it returns false.
end

aegisub.register_macro("Apply motion data","Applies properly formatted motion tracking data to selected subtitles.", prerun_czechs, isvideo)