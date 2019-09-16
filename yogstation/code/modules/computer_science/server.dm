/obj/machinery/rnd/modular_server
	name = "modular server"
	icon_state = "RD-server-on"
	desc = "A machine used to process large quantities of data."
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 15
	circuit = /obj/item/circuitboard/machine/rnd/modular_server
	var/datum/modular_server/server_datum = new /datum/modular_server()

/obj/machinery/rnd/modular_server/Initialize()
	. = ..()
	name += " [num2hex(rand(1,65535), -1)]" //gives us a random four-digit hex number as part of the name. Y'know, for fluff.
	updateDatum()
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/machinery/rnd/modular_server/proc/updateDatum()
	server_datum.temp = get_env_temp()

/obj/machinery/rnd/modular_server/proc/get_env_temp()
	var/turf/L = loc
	if(isturf(L))
		return L.temperature
	return 0

/obj/machinery/rnd/modular_server/process()
	updateDatum()