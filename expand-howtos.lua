-- Expand linked how-to pages under each H2 in the METS How-Tos chapter.

local stringify = (require 'pandoc.utils').stringify
local List = require 'pandoc.List'

local function slugify(text)
  local s = text:lower()
  s = s:gsub('[^%w%s-]', '')
  s = s:gsub('%s+', '-')
  s = s:gsub('%-+', '-')
  s = s:gsub('^%-', ''):gsub('%-$', '')
  return s
end

local function build_h2_index(index_items)
  local list_items = List:new()
  for _, item in ipairs(index_items) do
    local link = pandoc.Link(item.title, '#' .. item.id)
    list_items:insert({ pandoc.Plain({ link }) })
  end

  return List:new({
    pandoc.Para({ pandoc.Strong({ pandoc.Str('Index') }) }),
    pandoc.BulletList(list_items)
  })
end

local function shift_headings(blocks, shift_by)
  local filter = {
    Header = function(h)
      h.level = h.level + shift_by
      return h
    end
  }
  return pandoc.walk_block(pandoc.Div(blocks), filter).content
end

local function collect_links_from_bullet_list(bullet_list)
  local links = List:new()

  for _, item in ipairs(bullet_list.content) do
    for _, blk in ipairs(item) do
      if blk.t == 'Plain' or blk.t == 'Para' then
        for _, inline in ipairs(blk.content) do
          if inline.t == 'Link' and inline.target and inline.target:match('%.md$') then
            links:insert(inline.target)
          end
        end
      end
    end
  end

  return links
end

local function read_markdown_file(path)
  local fh = io.open(path)
  if not fh then
    io.stderr:write('Cannot open howto file ' .. path .. '\n')
    return {}
  end

  local src = fh:read('*a')
  fh:close()

  local parsed = pandoc.read(src, 'markdown', PANDOC_READER_OPTIONS)
  return parsed.blocks
end

function Pandoc(doc)
  local blocks = doc.blocks
  local out = List:new()

  local howto_h2_index = List:new()
  local collecting = false
  for _, b in ipairs(blocks) do
    if b.t == 'Header' and b.level == 1 then
      collecting = (stringify(b.content) == 'METS How-Tos')
    elseif collecting and b.t == 'Header' and b.level == 2 then
      local title = stringify(b.content)
      local id = b.identifier
      if not id or id == '' then
        id = slugify(title)
      end
      howto_h2_index:insert({ title = title, id = id })
    elseif collecting and b.t == 'Header' and b.level == 1 then
      collecting = false
    end
  end

  local in_howtos = false
  local index_inserted = false
  local i = 1

  while i <= #blocks do
    local b = blocks[i]

    if b.t == 'Header' and b.level == 1 then
      in_howtos = (stringify(b.content) == 'METS How-Tos')
      out:insert(b)
      i = i + 1
    elseif in_howtos and b.t == 'Header' and b.level == 2 then
      if not index_inserted and #howto_h2_index > 0 then
        out:extend(build_h2_index(howto_h2_index))
        index_inserted = true
      end

      out:insert(b)

      local j = i + 1
      local section_links = List:new()

      while j <= #blocks do
        local nxt = blocks[j]
        if nxt.t == 'Header' and nxt.level <= 2 then
          break
        end

        out:insert(nxt)
        if nxt.t == 'BulletList' then
          section_links:extend(collect_links_from_bullet_list(nxt))
        end
        j = j + 1
      end

      for _, link_target in ipairs(section_links) do
        local included = read_markdown_file(link_target)
        out:extend(shift_headings(included, 2))
      end

      i = j
    else
      out:insert(b)
      i = i + 1
    end
  end

  doc.blocks = out
  return doc
end
