--[[
LuCI - Lua Configuration Interface

Copyright 2010 Jo-Philipp Wich <xm@subsignal.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

local sid = arg[1]

m = Map("radvd", translatef("Radvd - Prefix"),
	translate("Radvd is a router advertisement daemon for IPv6. " ..
		"It listens to router solicitations and sends router advertisements " ..
		"as described in RFC 4861."))

m.redirect = luci.dispatcher.build_url("admin/network/radvd")

if m.uci:get("radvd", sid) ~= "prefix" then
	luci.http.redirect(m.redirect)
	return
end


s = m:section(NamedSection, sid, "interface", translate("Prefix Configuration"))
s.addremove = false

s:tab("general", translate("General"))
s:tab("advanced",  translate("Advanced"))


--
-- General
--

o = s:taboption("general", Value, "interface", translate("Interface"),
	translate("Specifies the logical interface name this section belongs to"))

o.template = "cbi/network_netlist"
o.nocreate = true
o.optional = false

function o.formvalue(...)
	return Value.formvalue(...) or "-"
end

function o.validate(self, value)
	if value == "-" then
		return nil, translate("Interface required")
	end
	return value
end

function o.write(self, section, value)
	m.uci:set("radvd", section, "ignore", 0)
	m.uci:set("radvd", section, "interface", value)
end


o = s:taboption("general", Value, "prefix", translate("Prefix"),
	translate("Advertised IPv6 prefix. If empty, the current interface prefix is used"))

o.optional = true
o.datatype = "ip6addr"


o = s:taboption("general", Flag, "AdvOnLink", translate("On-link determination"),
	translate("Indicates that this prefix can be used for on-link determination (RFC4861)"))

o.rmempty = false
o.default = "1"


o = s:taboption("general", Flag, "AdvAutonomous", translate("Autonomous"),
	translate("Indicates that this prefix can be used for autonomous address configuration (RFC4862)"))

o.rmempty = false
o.default = "1"


--
-- Advanced
--

o = s:taboption("advanced", Flag, "AdvRouterAddr", translate("Advertise router address"),
	translate("Indicates that the address of interface is sent instead of network prefix, as is required by Mobile IPv6"))


o = s:taboption("advanced", Value, "AdvValidLifetime", translate("Valid lifetime"),
	translate("Advertises the length of time in seconds that the prefix is valid for the purpose of on-link determination. Use 0 to specify an infinite lifetime"))

o.datatype = "uinteger"
o.placeholder = 86400

function o.cfgvalue(self, section)
	local v = Value.cfgvalue(self, section)
	if v == "infinity" then
		return 0
	else
		return v
	end
end

function o.write(self, section, value)
	if value == "0" then
		Value.write(self, section, "infinity")
	else
		Value.write(self, section, value)
	end
end


o = s:taboption("advanced", Value, "AdvPreferredLifetime", translate("Preferred lifetime"),
	translate("Advertises the length of time in seconds that addresses generated from the prefix via stateless address autoconfiguration remain preferred. Use 0 to specify an infinite lifetime"))

o.datatype = "uinteger"
o.placeholder = 14400

function o.cfgvalue(self, section)
	local v = Value.cfgvalue(self, section)
	if v == "infinity" then
		return 0
	else
		return v
	end
end

function o.write(self, section, value)
	if value == "0" then
		Value.write(self, section, "infinity")
	else
		Value.write(self, section, value)
	end
end


o = s:taboption("advanced", Value, "Base6to4Interface", translate("6to4 interface"),
	translate("Specifies a logical interface name to derive a 6to4 prefix from. The interfaces public IPv4 address is combined with 2002::/3 and the value of the prefix option"))

o.template = "cbi/network_netlist"
o.nocreate = true
o.unspecified = true


return m
