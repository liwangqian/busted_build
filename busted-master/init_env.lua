
-- 定义成module，防止重复初始化
module('init_env', package.seeall)

require("utility")

-- 用safe_require替换require，用于解决找不到外部依赖模块的问题
utility.export_api(safe_require, 'require')

-- 初始化随机发生器种子
math.randomseed(tostring(os.time()):reverse():sub(1, 6))

-- 全局id生成器，必须是唯一的
local id_generator = guid.new()

-- 生成唯一的类id
local function gen_class_id( name )
	local cid = id_generator:gen()
	rawset(utility.get_global_env(), name, cid)
	return cid
end

-- 生成唯一的类域表
local function gen_field_id_class( name )
	local fid_class = {indx = 0}
	setmetatable(fid_class, {__index = function ( self, key )
		self.indx = self.indx + 1
		self[key] = self.indx
		return self[key]
	end})

	return fid_class
end

-- 处理全局未定义的符号
local function process_unknown_symbol( symbol )
	if symbol:match('^_cid_') then
		return gen_class_id(symbol)
	end

	if symbol:match('^_fid_') then
		return gen_field_id_class(symbol)
	end

	return external_module(symbol)
end

-- 自动生成未定义模块或者classid，fieldid
setmetatable(utility.get_global_env(), {
	__index = function ( self, key )
		local symbol = process_unknown_symbol(key)
		if symbol then
			rawset(self, key, symbol)
		end

		return symbol
	end
})