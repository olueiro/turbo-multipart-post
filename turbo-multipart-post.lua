--[[
The MIT License (MIT)
Copyright (c) 2016 olueiro <github.com/olueiro>
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local multipart = {}

multipart.encoder = function(turbo, parts, tableParser)
  tableParser = tableParser or tostring
  local data = {}
  local boundary = turbo.hash.SHA1(turbo.util.rand_str()):hex()
  for key, value in pairs(parts) do
    data[#data + 1] = "--" .. boundary .. "\r\n"
    data[#data + 1] = "Content-Disposition: form-data; name=\"" .. key .. "\""
    if type(value) == "table" and value.__type == "file" then
      data[#data + 1] = "; filename=\"" .. value.name .. "\"\r\n"
      data[#data + 1] = "Content-Type: " .. value.mime .. "\r\n"
      data[#data + 1] = "Content-Transfer-Encoding: binary\r\n"
      data[#data + 1] = "\r\n"
      data[#data + 1] = value.data
    else
      data[#data + 1] = "\r\n\r\n"
      data[#data + 1] = type(value) == "table" and tableParser(value) or tostring(value)
    end
    data[#data + 1] = "\r\n"
  end
  data[#data + 1] = "--" .. boundary .. "--\r\n\r\n"
  return table.concat(data), "multipart/form-data; boundary=" .. boundary, boundary, "multipart/form-data"
end

multipart.file = function(turbo, path, mime)
  return {
    __type = "file",
    name = path:match(".-([ %w%-%.]+)$") or "unknown",
    mime = mime or "application/octet-stream",
    data = turbo.util.read_all(path)
  }
end

return multipart
