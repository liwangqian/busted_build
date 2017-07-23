
local jsonify = {}

local luacov_reporter = require("luacov.reporter")
local json = require("dkjson")
local unix_path = require("path").new("/")

local ReporterBase = luacov_reporter.ReporterBase

---------------------------------------------------
local JsonifyReporter = setmetatable({}, ReporterBase)
JsonifyReporter.__index = JsonifyReporter

local function debug_print(obj, ...)
   if not obj._debug then return end
   io.stdout:write(...)
end

function JsonifyReporter:new(conf)
    local obj, err = ReporterBase.new(self, conf)
    if not obj then return nil, err end

    local cc = conf.jsonify or {}
    self._debug = not not cc.debug
    self._source_files = {}

    return obj
end

function JsonifyReporter:correct_path(path)
   debug_print(self, "correct path: ", path, "=>")

   path = unix_path:normolize(path)

   debug_print(self, path, "\n")
   return path
end

function JsonifyReporter:on_start()
    debug_print(self, "on_start", "\n")
end

function JsonifyReporter:on_new_file(filename)
    local name = self:correct_path(filename)
    local source_file

    source_file = {
        name     = name,
        source   = {},
        coverage = {},
        count    = 0,
        hits     = 0,
        miss     = 0,
    }

    self._current_file = source_file
end

function JsonifyReporter:on_empty_line(filename, lineno, line)
    local i = self._current_file.count + 1

    self._current_file.count       = i
    self._current_file.coverage[i] = -1     -- empty line
    self._current_file.source[i]   = line
end

function JsonifyReporter:on_mis_line(filename, lineno, line)
    local i = self._current_file.count + 1

    self._current_file.count       = i
    self._current_file.miss        = self._current_file.miss + 1
    self._current_file.coverage[i] = 0
    self._current_file.source[i]   = line
end

function JsonifyReporter:on_hit_line(filename, lineno, line, hits)
    local i = self._current_file.count + 1

    self._current_file.count       = i
    self._current_file.hits        = self._current_file.hits + 1
    self._current_file.coverage[i] = hits
    self._current_file.source[i]   = line
end

function JsonifyReporter:on_end_file(filename, hits, miss)
    local source_file = self._current_file

    local total = source_file.hits + source_file.miss
    local cover = 0
    if total ~= 0 then cover = 100 * (source_file.hits / total) end

    print( string.format("File '%s'", source_file.name) )
    print( string.format("Lines executed:%.2f%% of %d\n", cover, total) )

    source_file.cover = cover

    table.insert(self._source_files, source_file)
end

function JsonifyReporter:on_end()
   for _, source_file in ipairs(self._source_files) do
      if type(source_file.source) == 'table' then
         source_file.source = table.concat(source_file.source, "\n")
      end
   end

   local msg = json.encode(self._source_files)
   self:write(msg)
end

function jsonify.report()
    return luacov_reporter.report(JsonifyReporter)
end

return jsonify