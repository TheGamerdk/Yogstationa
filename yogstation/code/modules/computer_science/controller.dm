/obj/machinery/computer/computer_controller
	name = "Controller Console"
	desc = "A console used to interface with servers."
	icon_screen = "rdcomp"
	icon_keyboard = "rd_key"
	circuit = /obj/item/circuitboard/computer/computer_controller

	var/list/linked = list() //List of linked servers

	req_access = list(ACCESS_TOX)	//Access needed to use the console

	var/list/tester = list()


/obj/machinery/computer/computer_controller/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.not_incapacitated_state)

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "computer_controller", name, 600, 600, master_ui, state)
		ui.open()


/obj/machinery/computer/computer_controller/proc/getCpuPower()
	/*
		TODO: Add this
	*/
	return 10

/obj/machinery/computer/computer_controller/ui_data()
	var/list/data = list()
	data["cpu_power"] = getCpuPower()

	var/list/servers = list()
	for(var/X in linked)
		var/obj/machinery/rnd/modular_server/server = X
		var/datum/modular_server/S = server.server_datum
		servers += list(list(
			"name" = server.name,
			"temp" = S.temp,
			"minTemp" = S.minTemp,
			"maxTemp" = S.maxTemp,
			"dangerTemp" = S.dangerTemp
		))

	data["servers"] = servers
	tester = data
	return data

/obj/machinery/computer/computer_controller/ui_act(action, params)
	if(..())
		return
	. = TRUE


/obj/item/circuitboard/computer/computer_controller
	name = "Controller Console (Computer Board)"
	icon_state = "science"
	build_path = /obj/machinery/computer/computer_controller

