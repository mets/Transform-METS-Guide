--- Created with using Google Gemini AI

function Header(el)
  if not first_header_processed then
    local filename = PANDOC_STATE.input_files[1] or "doc"
    local anchor_id = filename:match("([^/]+)$"):gsub("%.%w+$", "")
    el.identifier = anchor_id
    first_header_processed = true
    return el
  end
end
