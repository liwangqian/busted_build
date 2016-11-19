module ("utility", package.seeall)
local global_env = _G

function export_module(mod, module_name)
	global_env[module_name] = mod
	package.loaded[module_name] = mod
end

function export_api(callable, name)
	global_env[name] = callable
end

--[[
	向mod模块中增加动态绑定功能
--]]
function add_dynamic_binding(mod, module_name)
	setmetatable(mod, 
	{
		__index = function ( self, name )
			local proxy = {}
			setmetatable(proxy, 
			{
				-- 针对类似external.class:abc()的调用，生成相应的abc接口
				__index = function ( self, name_ )
					self[name_] = function ( self, ... )
						local msg = string.format("call %s.%s:%s with:", module_name, name, name_)
						print(msg, ...)
					end
					return self[name_]
				end,

				-- 针对devm.abc()的调用，由于我们返回的是一个表，因此需要定义表的call元方法
				__call = function ( self, ... )
					print("call "..module_name.."."..name.." with:", ...)
				end
			})

			-- 这里返回的是一张表，是为了保证external.abc()以及external.class:abc()都能够成功
			mod[name] = proxy
			return proxy
		end
	})
end

function get_global_env( name )
	if name then
		return global_env[name]
	else
		return global_env
	end
end

local function external_module( name )
	if global_env[name] then
		assert(type(global_env[name]) == 'table', string.format("module %s conflicted with existing one", name))
		return global_env[name]
	end

	local ext_mod = {}
	add_dynamic_binding(ext_mod, name)
	export_module(ext_mod, name)

	return ext_mod
end

local orig_require = global_env['require']
local function safe_require( ... )
	local ret, mod = pcall(orig_require, ...)
	if ret then
		return mod or ret
	else
		return ret, mod
	end
end

-- 将接口导出到公共环境变量中，方便使用
export_api(external_module, 'external_module')
export_api(safe_require, 'safe_require')