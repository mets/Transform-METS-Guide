--- Created with using Google Gemini AI

function Link(el)
  if el.target:match("%.md$") or el.target:match("%.md#") then
    local base = el.target:gsub("%.md", "")
    if not base:match("^#") then
      el.target = "#" .. base:gsub(".*/", "")
    else
      el.target = base
    end
  end
  return el
end

