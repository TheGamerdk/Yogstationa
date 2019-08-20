#define CONTRABAND_TELEPORTER_COOLDOWN 6000

/obj/machinery/contraband_teleporter
	name = "contraband teleporter"
	desc = "A visibly sinister device. Looks like you can break it if you hit it enough."
	icon = 'icons/obj/machines/dominator.dmi'
	icon_state = "dominator"
	density = TRUE
	anchored = TRUE
	layer = HIGH_OBJ_LAYER
	max_integrity = 300
	integrity_failure = 100
	move_resist = INFINITY
	armor = list("melee" = 20, "bullet" = 50, "laser" = 50, "energy" = 50, "bomb" = 10, "bio" = 100, "rad" = 100, "fire" = 10, "acid" = 70)
	var/datum/team/gang/gang
	var/cooldown = 0
	var/static/list/buyable_items = list()


/obj/machinery/contraband_teleporter/Initialize()
	set_light(1)
	if(buyable_items.len)
		return ..()
	for(var/i in subtypesof(/datum/gang_item/contraband))
		var/datum/gang_item/G = i
		var/id = initial(G.id)
		var/cat = initial(G.category)
		if(id)
			if(!islist(buyable_items[cat]))
				buyable_items[cat] = list()
			buyable_items[cat][id] = new G
	.=..()

/obj/machinery/contraband_teleporter/Destroy()
	return ..()

/obj/machinery/contraband_teleporter/examine(mob/user)
	. = ..()
	if(stat & BROKEN)
		return


	if(cooldown > world.time)
		. += "<span class='notice'>The teleporter is spinning up! It will be ready in [DisplayTimeText(cooldown - world.time)]</span>"
	else
		. += "<span class='notice'>The teleporter is ready!</span>"

	. += "<span class='danger'>System Integrity: [round((obj_integrity/max_integrity)*100,1)]%</span>"

/obj/machinery/contraband_teleporter/attack_hand(mob/user)


	var/datum/team/gang/tempgang

	var/datum/antagonist/gang/GA = user.mind.has_antag_datum(/datum/antagonist/gang)
	if(!gang)
		gang = GA.gang
	if(GA)
		tempgang = GA.gang
	if(!tempgang)
		examine(user)
		return

	if(cooldown > world.time)
		examine(user)
		return

	if(istype(GA, /datum/antagonist/gang/boss))
		var/dat
		dat += "<h2>Contraband Teleporter v2.0</h2><br>"
		dat += "The following Equipment is provided courtesy of the Syndicate<br>"
		dat += "<b>Influence: [gang.influence]</b>"
		dat += "<br><br>"
		dat += "Available Items: <br>"
		for(var/cat in buyable_items)
			dat += "<b>[cat]</b><br>"
			for(var/id in buyable_items[cat])
				var/datum/gang_item/G = buyable_items[cat][id]
				if(!G.can_see(user, gang, src))
					continue

				var/cost = G.get_cost_display(user, gang, src)
				if(cost)
					dat += cost + " "

				var/toAdd = G.get_name_display(user, gang, src)
				if(G.can_buy(user, gang, src))
					toAdd = "<a href='?src=[REF(src)];purchase=1;id=[id];cat=[cat]'>[toAdd]</a>"
				dat += toAdd
				var/extra = G.get_extra_info(user, gang, src)
				if(extra)
					dat += "<br><i>[extra]</i>"
				dat += "<br>"
			dat += "<br>"

		var/datum/browser/popup = new(user, "Contraband", "Contraband Teleporter", 400, 500)
		popup.set_content(dat)
		popup.open()
		onclose(user, "Contraband")
	else
		to_chat(user, "<span class='warning'>Only gang leaders can use this machine!</span>")
		return

/obj/machinery/contraband_teleporter/Topic(href, href_list)
	if(cooldown > world.time)
		to_chat(usr, "<span class='warning'>The teleporter is recharging! Please wait!</span>")
		return

	cooldown = CONTRABAND_TELEPORTER_COOLDOWN + world.time
	add_fingerprint(usr)

	if(href_list["purchase"])
		if(islist(buyable_items[href_list["cat"]]))
			var/list/L = buyable_items[href_list["cat"]]
			var/datum/gang_item/G = L[href_list["id"]]
			if(G && G.can_buy(usr, gang, src))
				G.purchase(usr, gang, src, FALSE)

	ui_interact(usr)

/obj/machinery/contraband_teleporter/proc/excessive_walls_check()
	var/open = FALSE
	for(var/turf/T in view(2, src))
		if(!isclosedturf(T))
			open++
	if(open < 7)
		return TRUE
	else
		return FALSE


#undef CONTRABAND_TELEPORTER_COOLDOWN