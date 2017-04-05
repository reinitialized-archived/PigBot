--[[
	LuaSignal LuaSignal.new()
	bool LuaSignal.IsLuaSignal( Variant testValue )
	bool LuaSignal.IsLuaConnection( Variant testValue )

	LuaConnection [LuaSignal]:connect( function fn )
	void [LuaSignal]:disconnect( LuaConnection cn )
	Tuple [LuaSignal]:wait()
	void [LuaSignal]:fire( Tuple arguments )

	void [LuaConnection]:disconnect()
	bool [LuaConnection].connected
--]]

-- Require Dependancies
local Scheduler = require("./Scheduler.lua")

local LuaSignal do
	local created_lua_signals, created_lua_connections = setmetatable({}, {__mode = "k"}), setmetatable({}, {__mode = "k"});

	local function is_lua_signal( lua_signal )
		return not not created_lua_signals[lua_signal];
	end
	local function is_lua_connection( lua_connection )
		return not not created_lua_connections[lua_connection];
	end

	local function lua_connection_constructor( lua_signal )
		local self = setmetatable(
			{
				connected = true;
			},
			{
				__tostring = function()
					return "LuaConnection"
				end
			}
		);
		function self:disconnect()
			if (self.connected) then
				self.connected = false;
				lua_signal:disconnect( self );
			else
				warn("Attempt to disconnect already disconnected LuaConnection")
			end
		end

		created_lua_connections[self] = true;
		return self;
	end
	local function lua_signal_constructor()
		local self = setmetatable(
			{},
			{
				__tostring = function()
					return "LuaSignal"
				end
			}
		);
		local connections = {};

		function self:connect( fn )
			assert( type(fn) == "function", "Attempt to connect to LuaSignal with non-function (type " .. tostring(fn) .. ")" );
			local cn = lua_connection_constructor(self);
			connections[cn] = fn;
			return cn;
		end
		function self:disconnect( cn )
			if (connections[cn]) then
				connections[cn] = nil;
			else
				warn("Attempt to disconnect " .. tostring(cn) .. ", not a valid connection")
			end
		end
		function self:fire( ... )
			local args = {...};
			for cn, fn in pairs(connections) do
				Scheduler.spawn(function()
					fn( unpack(args) );
				end)
			end
		end
		function self:wait()
			local args, cn = {}; cn = self:connect(function(...) args = {...}; cn:disconnect(); end);
			while (cn.connected) do
				Scheduler.wait()
			end
			return unpack(args);
		end

		created_lua_signals[self] = true;
		return self;
	end

	LuaSignal = {
		new = lua_signal_constructor;
		IsLuaSignal = is_lua_signal;
		IsLuaConnection = is_lua_connection;
	}
end

return LuaSignal;
