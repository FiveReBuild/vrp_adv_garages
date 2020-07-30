local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vRPg = {}
Tunnel.bindInterface("vrp_adv_garages",vRPg)
Proxy.addInterface("vrp_adv_garages",vRPg)

local vehicles = {}
local mods = {}
local toggles = {}
local colors = {}
local wheel = 0

function vRPg.toggleNeon(neon)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(veh) then
		if not toggles[neon] then toggles[neon] = false end
		toggles[neon] = not toggles[neon]
		SetVehicleNeonLightEnabled(veh,neon,toggles[neon])
	end
end

function vRPg.setNeonColour(r,g,b)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(veh) then
		SetVehicleNeonLightsColour(veh,r,g,b)
	end
end

function vRPg.setSmokeColour(r,g,b)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(veh) then
		SetVehicleTyreSmokeColor(veh,r,g,b)
	end
end

function vRPg.scrollVehiclePrimaryColour(pmod)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(veh) then
		if not colors[1] then colors[1] = 0 end
		colors[1] = colors[1]+pmod
		if colors[1] > 160 then colors[1] = 0 end
		if colors[1] < 0 then colors[1] = 160 end
		SetVehicleModKit(veh,0)
		ClearVehicleCustomPrimaryColour(veh)
		SetVehicleColours(veh,colors[1],colors[2])
	end
end

function vRPg.scrollVehicleSecondaryColour(smod)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(veh) then
		if not colors[2] then colors[2] = 0 end
		colors[2] = colors[2]+smod
		if colors[2] > 160 then colors[2] = 0 end
		if colors[2] < 0 then colors[2] = 160 end
		SetVehicleModKit(veh,0)
		ClearVehicleCustomSecondaryColour(veh)
		SetVehicleColours(veh,colors[1],colors[2])
	end
end

function vRPg.setCustomPrimaryColour(r,g,b)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(veh) then
		SetVehicleCustomPrimaryColour(veh,r,g,b)
	end
end

function vRPg.setCustomSecondaryColour(r,g,b)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(veh) then
		SetVehicleCustomSecondaryColour(veh,r,g,b)
	end
end

function vRPg.scrollVehiclePearlescentColour(emod)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(veh) then
		if not colors[3] then colors[3] = 0 end
		SetVehicleModKit(veh,0)
		colors[3] = colors[3]+emod
		if colors[3] > 160 then colors[3] = 0 end
		if colors[3] < 0 then colors[3] = 160 end
		SetVehicleExtraColours(veh,colors[3],colors[4])
	end
end

function vRPg.scrollVehicleWheelColour(wmod)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(veh) then
		if not colors[4] then colors[4] = 0 end
		SetVehicleModKit(veh,0)
		colors[4] = colors[4]+wmod
		if colors[4] > 160 then colors[4] = 0 end
		if colors[4] < 0 then colors[4] = 160 end
		SetVehicleExtraColours(veh,colors[3],colors[4])
	end
end
  
function vRPg.scrollVehicleMods(mod,add)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(veh) then
		local num = GetNumVehicleMods(veh,mod)

		if mod == 35 or mod == 26 then 
			num = GetNumberOfVehicleNumberPlates() 
		elseif mod == 46 then
			num = 6 
		end

		SetVehicleModKit(veh,0)
		if not mods[mod] then mods[mod] = 0 end
		mods[mod] = mods[mod] + add
	  
		if mod > 17 and mod < 23 then
			if toggles[mod] == nil then toggles[mod] = false end
			toggles[mod] = not toggles[mod]
			ToggleVehicleMod(veh,mod,toggles[mod])
			if toggles[mod] then
				TriggerEvent("Notify","sucesso","Aplicada com sucesso.")
			else
				TriggerEvent("Notify","negado","Removida com sucesso.")
			end

		elseif (mod == 23 or mod == 24) and add == 0 then
			wheel = wheel+1
			if wheel > 7 then wheel = 0 end
			SetVehicleWheelType(veh,wheel)
			SetVehicleMod(veh,mod,mods[mod])

		elseif mod == 49 then
			if GetVehicleModVariation(veh,23) == 1 then
				SetVehicleMod(veh,23,mods[23],false)
				SetVehicleMod(veh,24,mods[24],false)
			else
				SetVehicleMod(veh,23,mods[23],true)
				SetVehicleMod(veh,24,mods[24],true)
			end

		elseif num == 0 then
			TriggerEvent("Notify","importante","Nenhuma modificação disponível para este veículo.")
		elseif mods[mod] > num then
			mods[mod] = num
			TriggerEvent("Notify","importante","Atingiu o máximo.")
		elseif mods[mod] < 0 then
			mods[mod] = 0
			TriggerEvent("Notify","importante","Atingiu o mínimo.")
		elseif mod == 35 or mod == 26 then
			SetVehicleNumberPlateTextIndex(veh,mods[mod])
		elseif mod == 46 then
			SetVehicleWindowTint(veh,mods[mod])
		else
			SetVehicleMod(veh,mod,mods[mod],false)
			if mod == 16 and mods[mod] > 3 then
				SetVehicleTyresCanBurst(veh,true)
			elseif mod == 16 then
				SetVehicleTyresCanBurst(veh,false)
			end
		end
	end
end

function vRPg.getVehicleMods()
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsEntityAVehicle(veh) then
		local placa,vname,vnet = vRP.ModelName(7)
		if vname then
			local custom = {}
			if DoesEntityExist(veh) then
				local colours = table.pack(GetVehicleColours(veh))
				local extra_colors = table.pack(GetVehicleExtraColours(veh))

				custom.plate = {}
				custom.plate.text = GetVehicleNumberPlateText(veh)
				custom.plate.index = GetVehicleNumberPlateTextIndex(veh)

				custom.colour = {}
				custom.colour.primary = colours[1]
				custom.colour.secondary = colours[2]
				custom.colour.pearlescent = extra_colors[1]
				custom.colour.wheel = extra_colors[2]

				colors[1] = custom.colour.primary
				colors[2] = custom.colour.secondary
				colors[3] = custom.colour.pearlescent
				colors[4] = custom.colour.wheel

				custom.colour.neon = table.pack(GetVehicleNeonLightsColour(veh))
				custom.colour.smoke = table.pack(GetVehicleTyreSmokeColor(veh))

				custom.colour.custom = {}
				custom.colour.custom.primary = table.pack(GetVehicleCustomPrimaryColour(veh))
				custom.colour.custom.secondary = table.pack(GetVehicleCustomSecondaryColour(veh))

				custom.mods = {}
				for i=0,49 do
					custom.mods[i] = GetVehicleMod(veh, i)
				end

				custom.mods[46] = GetVehicleWindowTint(veh)
				custom.mods[18] = IsToggleModOn(veh,18)
				custom.mods[20] = IsToggleModOn(veh,20)
				custom.mods[22] = IsToggleModOn(veh,22)
				custom.turbo = IsToggleModOn(veh,18)
				custom.janela = GetVehicleWindowTint(veh)
				custom.fumaca = IsToggleModOn(veh,20)
				custom.farol = IsToggleModOn(veh,22)
				custom.tyres = GetVehicleMod(veh,23)
				custom.tyresvariation = GetVehicleModVariation(veh,23)

				mods = custom.mods
				toggles[18] = custom.mods[18]
				toggles[20] = custom.mods[20]
				toggles[22] = custom.mods[22]

				custom.neon = {}
				custom.neon.left = IsVehicleNeonLightEnabled(veh,0)
				custom.neon.right = IsVehicleNeonLightEnabled(veh,1)
				custom.neon.front = IsVehicleNeonLightEnabled(veh,2)
				custom.neon.back = IsVehicleNeonLightEnabled(veh,3)

				custom.wheel = GetVehicleWheelType(veh)
				wheel = custom.wheel
				return vname,custom
			end
		end
	end
	return false,false
end

function vRPg.setVehicleMods(custom,veh)
	if not veh then
		veh = GetVehiclePedIsUsing(PlayerPedId())
	end
	if custom and veh then
		SetVehicleModKit(veh,0)
		if custom.colour then
			SetVehicleColours(veh,tonumber(custom.colour.primary),tonumber(custom.colour.secondary))
			SetVehicleExtraColours(veh,tonumber(custom.colour.pearlescent),tonumber(custom.colour.wheel))
			if custom.colour.neon then
				SetVehicleNeonLightsColour(veh,tonumber(custom.colour.neon["1"]),tonumber(custom.colour.neon["2"]),tonumber(custom.colour.neon["3"]))
			end
			if custom.colour.smoke then
				SetVehicleTyreSmokeColor(veh,tonumber(custom.colour.smoke["1"]),tonumber(custom.colour.smoke["2"]),tonumber(custom.colour.smoke["3"]))
			end
			if custom.colour.custom then
				if custom.colour.custom.primary then
					SetVehicleCustomPrimaryColour(veh,tonumber(custom.colour.custom.primary["1"]),tonumber(custom.colour.custom.primary["2"]),tonumber(custom.colour.custom.primary["3"]))
				end
				if custom.colour.custom.secondary then
					SetVehicleCustomSecondaryColour(veh,tonumber(custom.colour.custom.secondary["1"]),tonumber(custom.colour.custom.secondary["2"]),tonumber(custom.colour.custom.secondary["3"]))
				end
			end
		end

		if custom.plate then
			SetVehicleNumberPlateTextIndex(veh,tonumber(custom.plate.index))
		end

		SetVehicleWindowTint(veh,tonumber(custom.janela))
		SetVehicleWheelType(veh,tonumber(custom.wheel))

		ToggleVehicleMod(veh,18,tonumber(custom.turbo))
		ToggleVehicleMod(veh,20,tonumber(custom.fumaca))
		ToggleVehicleMod(veh,22,tonumber(custom.farol))

		if custom.neon then
			SetVehicleNeonLightEnabled(veh,0,tonumber(custom.neon.left))
			SetVehicleNeonLightEnabled(veh,1,tonumber(custom.neon.right))
			SetVehicleNeonLightEnabled(veh,2,tonumber(custom.neon.front))
			SetVehicleNeonLightEnabled(veh,3,tonumber(custom.neon.back))
		end

		if custom.mods then
			for i,mod in pairs(custom.mods) do
				if i ~= 18 and i ~= 20 and i ~= 22 and i ~= 46 then
					SetVehicleMod(veh,tonumber(i),tonumber(mod))
				end
			end
		end
		
		SetVehicleMod(veh,23,tonumber(custom.tyres),custom.tyresvariation)
		SetVehicleMod(veh,24,tonumber(custom.tyres),custom.tyresvariation)
	end
end

local spawnLocs = {
	[1] = {
		[1] = { ['x'] = 50.92, ['y'] = -872.96, ['z'] = 30.44, ['h'] = 339.16 },
		[2] = { ['x'] = 47.28, ['y'] = -872.43, ['z'] = 30.44, ['h'] = 339.160 },
		[3] = { ['x'] = 44.22, ['y'] = -871.12, ['z'] = 30.45, ['h'] = 339.16 }
	},
	[2] = {
		[1] = { ['x'] = 220.42138671875, ['y'] = -806.44274902344, ['z'] = 30.695117950439, ['h'] = 245.46 },
		[2] = { ['x'] = 221.51976013184, ['y'] = -804.11529541016, ['z'] = 30.687194824219, ['h'] = 245.46 },
		[3] = { ['x'] = 222.51850891113, ['y'] = -801.56689453125, ['z'] = 30.672052383423, ['h'] = 245.46 },
		[3] = { ['x'] = 223.62869262695, ['y'] = -799.00433349609, ['z'] = 30.663942337036, ['h'] = 245.46 }
	},
	[3] = {
		[1] = { ['x'] = 336.57772827148, ['y'] = 2619.5407714844, ['z'] = 44.495624542236, ['h'] = 32.37 },
		[2] = { ['x'] = 342.09909057617, ['y'] = 2622.1567382813, ['z'] = 44.509521484375, ['h'] = 32.37 },
		[3] = { ['x'] = 348.72161865234, ['y'] = 2624.4672851563, ['z'] = 44.500102996826, ['h'] = 32.37 }
	},
	[4] = {
		[1] = { ['x'] = -771.54510498047, ['y'] = 5578.5610351563, ['z'] = 33.48571395874, ['h'] = 86.23 },
		[2] = { ['x'] = -771.50537109375, ['y'] = 2622.1567382813, ['z'] = 33.48571395874, ['h'] = 86.23 },
		[3] = { ['x'] = -771.30285644531, ['y'] = 5572.5991210938, ['z'] = 33.485710144043, ['h'] = 86.23 }
	},
	[5] = {
		[1] = { ['x'] = 277.95211791992, ['y'] = -340.42749023438, ['z'] = 44.919876098633, ['h'] = 75.24 },
		[2] = { ['x'] = 279.03942871094, ['y'] = -336.99353027344, ['z'] = 44.919876098633, ['h'] = 75.24 },
		[3] = { ['x'] = 280.07949829102, ['y'] = -333.8171081543, ['z'] = 44.919876098633, ['h'] = 75.24 },
		[4] = { ['x'] = 281.1159362793, ['y'] = -330.29486083984, ['z'] = 44.919876098633, ['h'] = 75.24 }
	},
	[6] = {
		[1] = { ['x'] = 609.17950439453, ['y'] = 104.06450653076, ['z'] = 92.805686950684, ['h'] = 66.66 },
		[2] = { ['x'] = 610.55987548828, ['y'] = 107.03285980225, ['z'] = 92.847328186035, ['h'] = 66.66 },
		[3] = { ['x'] = 611.7802734375, ['y'] = 110.64740753174, ['z'] = 92.889739990234, ['h'] = 66.66 }
	},
	[7] = {
		[1] = { ['x'] = -348.66006469727, ['y'] = 272.48403930664, ['z'] = 85.150253295898, ['h'] = 270.47 },
		[2] = { ['x'] = -348.97134399414, ['y'] = 275.90878295898, ['z'] = 85.052696228027, ['h'] = 270.47 },
		[3] = { ['x'] = -349.11267089844, ['y'] = 279.38897705078, ['z'] = 84.963981628418, ['h'] = 270.47 }
	},
	[8] = {
		[1] = { ['x'] = -2024.3364257813, ['y'] = -472.07769775391, ['z'] = 11.402521133423, ['h'] = 145.28 },
		[2] = { ['x'] = -2022.0838623047, ['y'] = -474.03396606445, ['z'] = 11.402057647705, ['h'] = 145.28 },
		[3] = { ['x'] = -2019.7467041016, ['y'] = -476.11596679688, ['z'] = 11.400670051575, ['h'] = 145.28 }
	},
	[9] = {
		[1] = { ['x'] = -1183.5888671875, ['y'] = -1495.6879882813, ['z'] = 4.3796696662903, ['h'] = 124.27 },
		[2] = { ['x'] = -1185.0529785156, ['y'] = -1493.1766357422, ['z'] = 4.3796696662903, ['h'] = 124.27 },
		[3] = { ['x'] = -1186.7431640625, ['y'] = -1490.6295166016, ['z'] = 4.3796696662903, ['h'] = 124.27 }
	},
	[10] = {
		[1] = { ['x'] = -77.495796203613, ['y'] = -2005.3350830078, ['z'] = 18.016967773438, ['h'] = 352.49 },
		[2] = { ['x'] = -81.155143737793, ['y'] = -2004.3492431641, ['z'] = 18.016967773438, ['h'] = 352.49 },
		[3] = { ['x'] = -84.957641601563, ['y'] = -2003.7944335938, ['z'] = 18.016967773438, ['h'] = 352.49 }
	},
	[11] = {
		[1] = { ['x'] = 1876.2651367188, ['y'] = 2615.0126953125, ['z'] = 45.672016143799, ['h'] = 271.42 },
		[2] = { ['x'] = 1876.4738769531, ['y'] = 2618.6394042969, ['z'] = 45.672016143799, ['h'] = 271.42 },
		[3] = { ['x'] = 1876.4997558594, ['y'] = 2622.0026855469, ['z'] = 45.672016143799, ['h'] = 271.42 }
	},
	[12] = {
		[1] = { ['x'] = 832.6298828125, ['y'] = -2911.9609375, ['z'] = 5.9008622169495, ['h'] = 131.090 },
		[2] = { ['x'] = 837.79931640625, ['y'] = -2912.1613769531, ['z'] = 5.9008612632751, ['h'] = 131.090 },
		[3] = { ['x'] = 843.39178466797, ['y'] = -2911.919921875, ['z'] = 5.9005885124207, ['h'] = 131.090 }
	},
	[13] = {
		[1] = { ['x'] = -376.63784790039, ['y'] = -146.3419342041, ['z'] = 38.684467315674, ['h'] = 309.218 },
		[2] = { ['x'] = -378.55236816406, ['y'] = -143.44760131836, ['z'] = 38.684616088867, ['h'] = 309.218 },
		[3] = { ['x'] = -380.39010620117, ['y'] = -140.38914489746, ['z'] = 38.685009002686, ['h'] = 309.218 }
	},
	[14] = {
		[1] = { ['x'] = -1061.71, ['y'] = -854.15, ['z'] = 4.86, ['h'] = 221.24 },
		[2] = { ['x'] = -1055.15, ['y'] = -849.27, ['z'] = 4.86, ['h'] = 211.21 }
	},
	[15] = {
		[1] = { ['x'] = -1096.2628173828, ['y'] = -832.291015625, ['z'] = 37.70076751709, ['h'] = 307.91 }
	},
	[16] = {
		[1] = { ['x'] = 292.93524169922, ['y'] = -613.99328613281, ['z'] = 43.408443450928, ['h'] = 70.0 },
		[2] = { ['x'] = 294.72369384766, ['y'] = -610.56182861328, ['z'] = 43.35083770752, ['h'] = 70.0 },
		[3] = { ['x'] = 295.85064697266, ['y'] = -607.62683105469, ['z'] = 43.331336975098, ['h'] = 70.0 }
	},
	[17] = {
		[1] = { ['x'] = 351.94223022461, ['y'] = -588.14910888672, ['z'] = 74.165725708008, ['h'] = 247.48 }
	},
	[18] = {
		[1] = { ['x'] = -370.96542358398, ['y'] = -107.64348602295, ['z'] = 38.680793762207, ['h'] = 247.65 }
	},
	[19] = {
		[1] = { ['x'] = 898.45861816406, ['y'] = -184.34251403809, ['z'] = 73.799140930176, ['h'] = 238.56 },
		[2] = { ['x'] = 900.32946777344, ['y'] = -180.86457824707, ['z'] = 73.881271362305, ['h'] = 238.56 },
		[3] = { ['x'] = 907.36883544922, ['y'] = -182.58013916016, ['z'] = 74.175621032715, ['h'] = 238.56 }
	},
	[20] = {
		[1] = { ['x'] = -366.09942626953, ['y'] = -1529.5574951172, ['z'] = 27.747529983521, ['h'] = 170.0 },
		[2] = { ['x'] = -370.71710205078, ['y'] = -1529.0771484375, ['z'] = 27.792840957642, ['h'] = 170.0 }
	},
	[21] = {
		[1] = { ['x'] = 462.95623779297, ['y'] = -605.54583740234, ['z'] = 28.499687194824, ['h'] = 220.0 },
		[2] = { ['x'] = 461.72274780273, ['y'] = -612.82684326172, ['z'] = 28.499750137329, ['h'] = 220.0 },
		[3] = { ['x'] = 460.72906494141, ['y'] = -620.05950927734, ['z'] = 28.499767303467, ['h'] = 220.0 }
	},
	[22] = {
		[1] = { ['x'] = -1028.6411132813, ['y'] = -2727.6674804688, ['z'] = 13.606596946716, ['h'] = 220.0 },
		[2] = { ['x'] = -1026.0526123047, ['y'] = -2729.0649414063, ['z'] = 13.606610298157, ['h'] = 220.0 },
		[3] = { ['x'] = -1023.0905761719, ['y'] = -2730.9616699219, ['z'] = 13.606609344482, ['h'] = 220.0 }
	},
	[23] = {
		[1] = { ['x'] = 1187.6497802734, ['y'] = -3246.0053710938, ['z'] = 6.02876329422, ['h'] = 91.07 },
		[2] = { ['x'] = 1187.9967041016, ['y'] = -3239.6384277344, ['z'] = 6.0287637710571, ['h'] = 91.07 },
		[3] = { ['x'] = 1188.6524658203, ['y'] = -3232.9948730469, ['z'] = 6.0287637710571, ['h'] = 91.07 }
	},
	[24] = {
		[1] = { ['x'] = -795.85, ['y'] = 303.96, ['z'] = 85.70, ['h'] = 179.0 }
	},
	[25] = {
		[1] = { ['x'] = 14.77, ['y'] = 546.51, ['z'] = 176.06, ['h'] = 265.67 }
	},
	[26] = {
		[1] = { ['x'] = -189.72, ['y'] = 504.08, ['z'] = 134.38, ['h'] = 265.67 }
	},
	[27] = {
		[1] = { ['x'] = -823.3, ['y'] = 180.82, ['z'] = 71.65, ['h'] = 265.67 }
	},
	[28] = {
		[1] = { ['x'] = 212.59, ['y'] = 760.38, ['z'] = 204.79, ['h'] = 265.67 }
	},
	[29] = {
		[1] = { ['x'] = -683.02, ['y'] = 605.46, ['z'] = 143.84, ['h'] = 265.67 }
	},
	[30] = {
		[1] = { ['x'] = -1116.4956054688, ['y'] = -856.29431152344, ['z'] = 13.514740943909, ['h'] = 216.17 },
		[2] = { ['x'] = -1113.4248046875, ['y'] = -853.83032226563, ['z'] = 13.51163482666, ['h'] =216.17 }
--		[3] = { ['x'] = 124.94253540039, ['y'] = -1081.0489501953, ['z'] = 29.193290710449, ['h'] = 1.75 }
	},
	[31] = {
		[1] = { ['x'] = -2042.8787841797, ['y'] = -446.13140869141, ['z'] = 12.213403701782, ['h'] = 6.53 }
	},
	[32] = {
		[1] = { ['x'] = -190.14483642578, ['y'] = -1290.9643554688, ['z'] = 31.29598236084, ['h'] = 270.21 },
		[2] = { ['x'] = -190.33177185059, ['y'] = -1284.6940917969, ['z'] = 31.233489990234, ['h'] = 270.21 }
	},
	[33] = {
		[1] = { ['x'] = -47.664951324463, ['y'] = -1116.5921630859, ['z'] = 26.434022903442, ['h'] = 5.43 },
		[2] = { ['x'] = -50.676860809326, ['y'] = -1116.3870849609, ['z'] = 26.434568405151, ['h'] = 5.43 },
		[3] = { ['x'] = -53.601726531982, ['y'] = -1116.4259033203, ['z'] = 26.434829711914, ['h'] = 5.43 }
	},
	[36] = {
		[1] = { ['x'] = 861.33135986328, ['y'] = -1155.6551513672, ['z'] = 24.62836265564, ['h'] = 359.94 }
	},
	[37] = {
		[1] = { ['x'] = 1162.8791503906, ['y'] = -285.77670288086, ['z'] = 68.865097045898, ['h'] = 7.61 }
	},
	[38] = {
		[1] = { ['x'] = -468.57235717773, ['y'] = -1717.9315185547, ['z'] = 18.689121246338, ['h'] = 285.28 }
	},
	[39] = {
		[1] = { ['x'] = 708.54296875, ['y'] = -295.2001953125, ['z'] = 59.183494567871, ['h'] = 13.34 }
	},
	[40] = {
		[1] = { ['x'] = 1373.2054443359, ['y'] = -583.21893310547, ['z'] = 74.351997375488, ['h'] = 74.68 }
	},
	[41] = {
		[1] = { ['x'] = 2636.7404785156, ['y'] = 269.74221801758, ['z'] = 100.23501586914, ['h'] = 79.68 }
	},
	[42] = {
		[1] = { ['x'] = 1493.5151367188, ['y'] = 767.37170410156, ['z'] = 77.453659057617, ['h'] = 157.19 }
	},
	[43] = {
	    [1] = { ['x'] = -1879.1818847656, ['y'] = 190.62942504883, ['z'] = 84.052505493164, ['h'] = 298.17 }
	},
	[44] = {
	    [1] = { ['x'] = 183.67239379883, ['y'] = -2228.0461425781, ['z'] = 5.9514741897583, ['h'] = 0.73 }
	},
	[34] = {
		[1] = { ['x'] = 3262.248046875, ['y'] = 5175.708984375, ['z'] = 19.681400299072, ['h'] = 174.40 }
	}
} 


function vRPg.spawnGarageVehicle(name,custom,enginehealth,bodyhealth,fuellevel,loc)
	local vehicle = vehicles[name]
	if vehicle == nil then
		local mhash = GetHashKey(name)
		while not HasModelLoaded(mhash) do
			RequestModel(mhash)
			Citizen.Wait(10)
		end

		if HasModelLoaded(mhash) then
			rand = 1
			while true do
				checkPos = GetClosestVehicle(spawnLocs[loc][rand].x,spawnLocs[loc][rand].y,spawnLocs[loc][rand].z,3.001,0,71)
				if DoesEntityExist(checkPos) and checkPos ~= nil then
					rand = rand + 1
					if rand > #spawnLocs[loc] then
						rand = -1
						TriggerEvent("Notify","importante","Todas as vagas estão ocupadas no momento.")
						break
					end
				else
					break
				end
				Citizen.Wait(1)
			end

			if rand ~= -1 then
				nveh = CreateVehicle(mhash,spawnLocs[loc][rand].x,spawnLocs[loc][rand].y,spawnLocs[loc][rand].z+0.5,spawnLocs[loc][rand].h,true,false)
				netveh = VehToNet(nveh)

				NetworkRegisterEntityAsNetworked(nveh)
				while not NetworkGetEntityIsNetworked(nveh) do
					NetworkRegisterEntityAsNetworked(nveh)
					Citizen.Wait(1)
				end

				if NetworkDoesNetworkIdExist(netveh) then
					SetEntitySomething(nveh,true)
					if NetworkGetEntityIsNetworked(nveh) then
						SetNetworkIdExistsOnAllMachines(netveh,true)
					end
				end

				NetworkFadeInEntity(NetToEnt(netveh),true)
				SetVehicleIsStolen(NetToVeh(netveh),false)
				SetVehicleNeedsToBeHotwired(NetToVeh(netveh),false)
				SetEntityInvincible(NetToVeh(netveh),false)
				SetVehicleNumberPlateText(NetToVeh(netveh),vRP.getRegistrationNumber())
				SetEntityAsMissionEntity(NetToVeh(netveh),true,true)
				SetVehicleHasBeenOwnedByPlayer(NetToVeh(netveh),true)

				SetVehRadioStation(NetToVeh(netveh),"OFF")

				if custom then
					vRPg.setVehicleMods(custom,NetToVeh(netveh))
				end

				SetVehicleEngineHealth(NetToVeh(netveh),enginehealth+0.0)
				SetVehicleBodyHealth(NetToVeh(netveh),bodyhealth+0.0)
				SetVehicleFuelLevel(NetToVeh(netveh),fuellevel+0.0)

				SetModelAsNoLongerNeeded(mhash)

				vehicles[name] = { name,nveh }
			end

			return true,VehToNet(nveh),name
		end
	end
	return false,0,nil
end

function vRPg.despawnGarageVehicle(name)
	local vehicle = vehicles[name]
	if vehicle then
		vehicles[name] = nil
	end
end

function vRPg.toggleLock()
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then
		local locked = GetVehicleDoorLockStatus(vehicle) >= 2
		if locked then
			TriggerServerEvent("tryLock",VehToNet(vehicle))
			TriggerEvent("Notify","importante","Veículo <b>destrancado</b> com sucesso.")
		else
			TriggerServerEvent("tryLock",VehToNet(vehicle))
			TriggerEvent("Notify","importante","Veículo foi <b>trancado</b> com sucesso.")
		end
		if not IsPedInAnyVehicle(PlayerPedId()) then
			vRP._playAnim(true,{{"anim@mp_player_intmenu@key_fob@","fob_click"}},false)
		end
	end
end

function vRPg.toggleTrunk()
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("trytrunk",VehToNet(vehicle))
	end
end

local ancorado = false
function vRPg.toggleAnchor()
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) and GetVehicleClass(vehicle) == 14 then
		if ancorado then
			FreezeEntityPosition(vehicle,false)
			ancorado = false
		else
			FreezeEntityPosition(vehicle,true)
			ancorado = true
		end
	end
end

local cooldown = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if cooldown > 0 then
			cooldown = cooldown - 1
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,182) and cooldown < 1 then
			cooldown = 1
			TriggerServerEvent("buttonLock")
		end
		if IsControlJustPressed(0,10) and cooldown < 1 then
			cooldown = 1
			TriggerServerEvent("buttonTrunk")
		end
	end
end)

RegisterNetEvent("syncLock")
AddEventHandler("syncLock",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				local locked = GetVehicleDoorLockStatus(v)
				if locked == 1 then
					SetVehicleDoorsLocked(v,2)
				else
					SetVehicleDoorsLocked(v,1)
				end
				SetVehicleLights(v,2)
				Wait(200)
				SetVehicleLights(v,0)
				Wait(200)
				SetVehicleLights(v,2)
				Wait(200)
				SetVehicleLights(v,0)
			end
		end
	end
end)