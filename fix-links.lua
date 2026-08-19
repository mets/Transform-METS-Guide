--- Created with using Google Gemini AI

function Link(el)
  local path, fragment = el.target:match("^([^#]+)%.md#(.+)$")
  if path and fragment then
    -- Keep explicit section fragments from cross-file links.
    el.target = "#" .. fragment
    return el
  end

  local only_path = el.target:match("^([^#]+)%.md$")
  if only_path then
    -- Resolve file links to the first-header anchor injected by add-anchor.lua.
    el.target = "#" .. only_path:gsub(".*/", "")
    return el
  end

  return el
end

