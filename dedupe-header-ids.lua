-- Ensure header identifiers are unique across the merged document.
-- Keep the original identifier if available, otherwise append a numeric suffix.

local used = {}

local function next_unique_id(base)
  if not used[base] then
    return base
  end

  local n = 2
  local candidate = base .. '-' .. tostring(n)
  while used[candidate] do
    n = n + 1
    candidate = base .. '-' .. tostring(n)
  end
  return candidate
end

function Header(h)
  local id = h.identifier
  if not id or id == '' then
    return h
  end

  local unique = next_unique_id(id)
  used[unique] = true
  h.identifier = unique
  return h
end
