package = "turbo-multipart-post"
version = "0.1-1"

source = {
 url = "",
 branch = "master"
}

description = {
 summary = "Turbo.lua multipart encoder",
 detailed = [[
Turbo.lua multipart encoder
]],
 homepage = "",
 license = "MIT"
}

dependencies = {
 "turbo"
}

build = {
 type = "builtin",
 modules = {
  ["turbo-multipart-post"] = "turbo-multipart-post.lua"
 },
 copy_directories = {}
}