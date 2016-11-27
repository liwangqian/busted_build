module("multitask", package.seeall)

local tm = require("timer")

local task_list = {}

local function create_task(callable, ...)
	local atask = {}

	atask.callable 		= callable
	atask.params		= {...}
	atask.resume_after 	= 0			-- in msecond
	atask.time  		= 0			-- in msecond
	atask.co 			= coroutine.create(callable)

	return atask
end

local function run_task( task )
	local ret, resume_after = coroutine.resume(task.co)
	local status = coroutine.status(task.co)
	if ret and status == 'suspended' then
		task.resume_after = resume_after
		task.time = tm.gettime()
	end

	return status
end

local function is_timeout( task )
	local elapse = math.floor((tm.gettime() - task.time) * 1000)
	if elapse >= task.resume_after then
		task.resume_after = 0
		return true
	end

	return false
end

function new( callable, ... )
	local task = create_task(callable, ...)
	table.insert(task_list, task)
end

function run( ... )
	repeat
		for i, task in ipairs(task_list) do
			if is_timeout(task) then

				local state = run_task(task)
				if state == 'dead' then
					table.remove(task_list, i)
				end
			end

			tm.msleep(1)
		end
	until (#task_list == 0)
end

function delay( mseconds )
	coroutine.yield(mseconds)
end