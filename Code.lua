--Hello, My Name Is Tawfeek I'm Advanced Scripter, My Name Tawfeek in Discord in roblox ahmd1234567890qwe, My Youtube Name is Normal guy - UserName = Tawfeekjb, My Discord Portfolio to prove everything = [https://discord.gg/9QP4qqAa] i am a roblox studio scripter apply for you guys to get comms to get money yo ucan see info about this colde under this line ⬇⬇⬇⬇⬇⬇ : 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- this is a full framework i worked for someone its combat module with server connectted with framework its include --Sliding-Dash-Ground Slam(fly and destroy the ground),combat(5m1-uptilit-groundslam), Sprit,Counter Skill,Evasive,(Its a full System i worked if you want to see it the combat with skills you can test the game i putted)
--- Yeah i'm Talented with roblox studio Scripting i Can Script all types of scripts ,CFrame math, physics, metatables, frameworks like Knit, etc
--Game Link : https://www.roblox.com/games/18257299430/System-By-Tawfeek
---------------------------------------------------------------

---KeyBind Is Here : 
--Left Click = Combat Punch--
--Duple Jump + Right Click = Ground Slam--
--C = Counter --
--R = Sliding--
--E = Evasive While in Combat--
--LeftShift = Sprint --
--Q = Dash--
--Douple Space = Douple Jump--
---------------------------------------------------------------
--- Videos : For Some Old Work
-- My Youtube Name is Normal guy - UserName = Tawfeekjb
-- My Discord Portfolio to prove everything = https://discord.gg/9QP4qqAa
-- Hollow Purple = https://streamable.com/v6yag9
-- Old Combat = https://streamable.com/x75tkw
-- Flame Skill = https://streamable.com/5um5lq
-- Hollow Purple 200% = https://youtu.be/d33tMIZ7R_o?si=RYs5LedOf4WqfF2_
-- Title System = https://youtu.be/LqBSmKFrMZk?si=CgqdQG9_5Qo1Y7KH
-- Customize + Menu = https://youtu.be/1A4tJwFa17E?si=tzRzowuizyF2YyC5
------------ Thank You For Reading -----------------
---------------------------------------------------------------
--Service
local Players = game:GetService("Players")
local Replicated_Storage = game:GetService("ReplicatedStorage")
local Server_Storage = game:GetService("ServerStorage")
local Collection_Service = game:GetService("CollectionService")
local AssetsFolder = Replicated_Storage:FindFirstChild("Assets")

local UtilsFolder = script.Parent.Parent:FindFirstChild("CombatUtils")
local ReplicatorEvent = game.ReplicatedStorage.Main.Remotes.RemoteEvents:WaitForChild("Replicator")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Modules
local ClientInformation = require(game.ServerStorage.Modules:FindFirstChild("ClientInformation"))
local Shared_Functions = require(game.ReplicatedStorage.Main.Modules:FindFirstChild("SharedFunctions"))
local Keybinds = require(UtilsFolder.Parent.Keybinds)

-- Util modules
local Damage_Module = require(UtilsFolder:FindFirstChild("Damage"))
local StunModule = require(UtilsFolder:FindFirstChild("Stun"))
local HitboxModule = require(UtilsFolder:FindFirstChild("Hitbox"))
local Cooldown = require(UtilsFolder:FindFirstChild("Cooldown"))
local Animations = game:GetService("ReplicatedStorage").Main.Assets.Animations.Dashes
local Cooldowns = { }
local Combat = { }
local Connections = { }


--Here The function for module

local Default = {
  ----Sliding Frame
	["Sliding"] = {
		
		["Checks"] = {"Punching", "Dashing", "Blocking", "Stunned", "Attacking", "Evasive", "Cutscene", "DoupleJump"}, -- Checking If Player Has Any Tag Wi5th Named (If He Attacking Skill Or punching or Using thing)
		["Function"] = function(Player, Character, Key)-- Here The Function When Player Start With Key
			if ClientInformation.FetchKey(Player)["W"] == false then return end -- check if player doesn't pressing W Key
			Cooldown.AddCooldown(Character, "Sliding") -- Add CoolDown With another Module
			
			local clock = 0
			local debounce = 0.1 - -- time
			
			StunModule.Effect(Character, nil, {Tag = "Sliding", JumpPower = 0, WalkSpeed = 1.5, AutoRotate = true})-- Give Player Stun to dont use any thingwhile he slideing
			Character.Mechanics.TiltWalk:SetAttribute("Enabled", false)
			
			local params = RaycastParams.new()-- Params For RayCast
			params.FilterType = Enum.RaycastFilterType.Include -- Filter the raycast to get all part
			params.FilterDescendantsInstances = { workspace.Map }-- get The Part In Folder in WorkSpce
			
			local last_Yaxis = Character.HumanoidRootPart.Position.Y
			
			local maxSpeed = 60 --max Speed Of SLIDE
			local speed = math.min(maxSpeed, (Character.HumanoidRootPart.Position - (Character.HumanoidRootPart.Position + Character.HumanoidRootPart.Velocity)).Magnitude) + 25 -- SPEED WHEN SLIDE
			
			local slidingTrack = Character.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.Main.Assets.Animations.Movement.Sliding)-- Play Animation For Slide
			slidingTrack.Priority = Enum.AnimationPriority.Action3 -- Do It Action3 to be the first animation playing
			slidingTrack:Play()-- Start Animation
			
			local bodyVelocity = Instance.new("BodyVelocity")-- Bodt Velocity to Start Sliding
			bodyVelocity.MaxForce = Vector3.new(20000, 1000, 20000) -- The Force
			bodyVelocity.P = 600 -- Position
			bodyVelocity.Velocity = Character.Humanoid.MoveDirection  * speed  + Vector3.new(0,-10,0) -- the final speed
			bodyVelocity.Parent = Character.HumanoidRootPart -- in HRP
			
			
			local connection = nil
			connection = RunService.Heartbeat:Connect(function() -- Do loop for sliding
				if clock > os.clock() then return end
				
				if speed == 0 then
					connection:Disconnect()--StopSlide
					slidingTrack:Stop()--StopSlide
					bodyVelocity:Destroy()--StopSlide

					Character.Mechanics.TiltWalk:SetAttribute("Enabled", true)--StopSlide

					StunModule.RemoveEffect(Character, "Sliding")--Remove Slide EFFECT (DUST)

					task.delay(1, function()
						Cooldown.RemoveCooldown(Character, "Sliding")--- remove cooldown
					end)
					return
				end
				
				if not Character:HasTag("Sliding") then  -- when sliding tag remove
					connection:Disconnect()--StopSlide
					slidingTrack:Stop()--StopSlide
					bodyVelocity:Destroy()--StopSlide

					Character.Mechanics.TiltWalk:SetAttribute("Enabled", true)--StopSlide

					StunModule.RemoveEffect(Character, "Sliding")--Remove Slide EFFECT (DUST)

					task.delay(1, function()
						Cooldown.RemoveCooldown(Character, "Sliding")--- remove cooldown
					end)
					return
				end
				
				clock = os.clock() + debounce
				
				local originPos = Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0) + Character.HumanoidRootPart.CFrame.LookVector * 7
				local targetPos = Vector3.new(0, -15, 0)
				
				local raycast = workspace:Raycast(originPos, targetPos)-- SLIDE SYSTEM HERE AND CALCULATE FOR SLIDE
				if raycast then
					local y_axis = raycast.Position.Y
					
					local attachment = Instance.new("Attachment")
					attachment.Parent = raycast.Instance
					attachment.WorldCFrame = CFrame.new(raycast.Position)
					task.delay(2, function()
						attachment:Destroy()
					end)
					
					if (Character.HumanoidRootPart.Position.Y - y_axis) > 3.5 and (Character.HumanoidRootPart.Position.Y - y_axis) > 3 then
						speed = math.min(speed + 7, maxSpeed)
					else
						speed = math.max(speed - 4.5, 0)
					end
				else
					speed = math.max(speed - 4.5, 0)
				end
				
				if ClientInformation.FetchKey(Player)["W"] == false then
					speed = math.max(speed - 4.5, 0)
				end
				
				local direction = Character.Humanoid.MoveDirection
				if direction.Magnitude < 0.05 then
					direction = Character.HumanoidRootPart.CFrame.LookVector
				end
				
				bodyVelocity.Velocity = direction * speed + Vector3.new(0,-10,0)
			end)
			
			repeat -- stop scrtipt here when for when removed his finger from the key to stop
				task.wait()
			until ClientInformation.FetchKey(Player)[Key] == false
			--SAME THING from top to sop slide
			if Character:HasTag("Sliding") then 
				slidingTrack:Stop()
				connection:Disconnect()
				bodyVelocity:Destroy()
			
				Character.Mechanics.TiltWalk:SetAttribute("Enabled", true)
				
				StunModule.RemoveEffect(Character, "Sliding")
			
				task.delay(1, function()
					Cooldown.RemoveCooldown(Character, "Sliding")
				end)
			end	
		end,
	},
	--Sprint Frame
	["Sprint"] = {
		["Checks"] = {"Punching", "Dashing", "Stunned", "Blocking", "Attacking", "Sliding", "Cutscene", "DoupleJump"},-- Checking If Player Has Any Tag Wi5th Named (If He Attacking Skill Or punching or Using thing)
		["Function"] = function(Player, Character, Key))-- Here The Function When Player Start With Key
			Cooldown.AddCooldown(Character, "Sprint")-- Add CoolDown With another Module
			Character:AddTag("Running")-- Add running tag
			
			local RunAnimation = game.ReplicatedStorage.Main.Assets.Animations.Movement.Running --get run animation
			local RunTrack = Character.Humanoid.Animator:LoadAnimation(RunAnimation)--- load it
			RunTrack.Priority = Enum.AnimationPriority.Action2 --put it
			
			if Character.Humanoid.MoveDirection.Magnitude > 0.05 then --if palyer move
				if Character.Humanoid.FloorMaterial ~= Enum.Material.Air then -- if player not in the air to start
					RunTrack:Play()-- Start aniamtion
				end	
			end
			
			Character.Humanoid.WalkSpeed = 32-- new player speed
			
			if Connections[Character] == nil then
				Connections[Character] = { }
			end
			
			Connections[Character]["Running"] = nil
			Connections[Character]["Running"] = Character.Humanoid.Running:Connect(function() --check if player running
				if Character.Humanoid.MoveDirection.Magnitude > 0.05 then -- if palyer move
						if not RunTrack.IsPlaying then -- check if animation stopped to play it 
							RunTrack:Play()-- start aniamtion
						end
				else
					if RunTrack.IsPlaying then -- if it play to stop bc he is not moveing
						RunTrack:Stop()-- stop 
					end
				end
			end)
			
			Connections[Character]["Jump"] = nil -- when player jump
			Connections[Character]["Jump"] = Character.Humanoid.Changed:Connect(function() -- get humanoid change if jump
				if Character.Humanoid.Jump then -- if player jump stop animation
					if RunTrack.IsPlaying then -- check if animation paly
						RunTrack:Stop() -- to stop
					end
				end
			end)
			
			Connections[Character]["StopSprinting"] = nil
			Connections[Character]["StopSprinting"] = Collection_Service:GetInstanceRemovedSignal("Running"):Connect(function(object)-- if player stop of running
				if object == Character then -- check the player
					Connections[Character]["Jump"]:Disconnect()-- stop all connections
					Connections[Character]["Running"]:Disconnect()-- stop all connections
					Connections[Character]["StopSprinting"]:Disconnect()-- stop all connections
					
					RunTrack:Stop()
					Cooldown.RemoveCooldown(Character, "Sprint") -- remove cooldown
					return
				end
			end)
	
			repeat -- stuck the script for when the player removed his finger from the key
				task.wait()
			until ClientInformation.FetchKey(Player)[Key] == false
			
			if Character:HasTag("Running") then -- check if player have running tag
				Connections[Character]["Jump"]:Disconnect() -- stop all connefctions
				Connections[Character]["Running"]:Disconnect() -- stop all connefctions
				Connections[Character]["StopSprinting"]:Disconnect() -- stop all connefctions
				RunTrack:Stop()-- stop animation
				Character:RemoveTag("Running") -- remove tag
				

				Character.Humanoid.WalkSpeed = 16-- return the normal speed
				
				-- Cooldown
				task.delay(0.5, function()
					Cooldown.RemoveCooldown(Character, "Sprint") -- remove cooldown
				end)
			
			end
		end,
	},
---Dash Frame
	["Dash"] = {
		["Checks"] = {"Punching", "Stunned", "Blocking", "Attacking", "Sliding", "DoupleJump"},-- Checking If Player Has Any Tag Wi5th Named (If He Attacking Skill Or punching or Using thing)
		["Function"] = function(Player, Character, Key))-- Here The Function When Player Start With Key

			local Humanoid = Character:WaitForChild("Humanoid")--get character humanoid
			local Root = Character:WaitForChild("HumanoidRootPart")--get character RootPart
			local Animations = game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Assets"):WaitForChild("Animations"):WaitForChild("Dashes")--get animation folder
			Cooldown.AddCooldown(Character, "Dash",1.2) -- add cooldown

			-- ANIMATIONS --
			local DashAnims = {-- load animation with table
				["Front"] = Character.Humanoid.Animator:LoadAnimation(Animations.DashFront),
				["Back"] = Character.Humanoid.Animator:LoadAnimation(Animations.DashBack),
				["Right"] = Character.Humanoid.Animator:LoadAnimation(Animations.DashRight),
				["Left"] = Character.Humanoid.Animator:LoadAnimation(Animations.DashLeft),
			}

			Character:AddTag("Dashing")-- add dashing tag
			Character:AddTag("IFrame") -- adding dashing tag

			task.delay(1, function()
				Character:RemoveTag("IFrame")-- removing dashing tag after 1 sec
				Character:RemoveTag("Dashing")-- removing dashing tag after 1 sec

			end)
			local Direction = 0-- player dash direction
			local DashType = "Front"-- dash type [LEFT,RIGHT,FRONT,BACK]
			if ClientInformation.FetchKey(Player)["A"] == true then -- IF PLAYER pressing A HE WILL GOT TO LEFT 
				if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then Direction = 0 DashType = "Front" else -- CHECK IF PLAYER SET SHIFTLOCK if bot using shift lock he will go to front and set everything front
					Direction = 90 -- CHANGE DIRECTION TO LEFT
					DashType = "Left" -- CHANGE TYPE TO LEFT 
				end
			end	
			if  ClientInformation.FetchKey(Player)["S"] == true then -- IF PLAYER pressing S HE WILL GOT TO Back 
				if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then Direction = 0 DashType = "Front" else -- CHECK IF PLAYER SET SHIFTLOCK if bot using shift lock he will go to front and set everything front
					Direction = 180-- CHANGE DIRECTION TO Back
					DashType = "Back"-- CHANGE DIRECTION TO Back
				end
			end
			if  ClientInformation.FetchKey(Player)["D"] == true then  -- IF PLAYER pressing D HE WILL GOT TO Right 
				if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then Direction = 0 DashType = "Front" else -- CHECK IF PLAYER SET SHIFTLOCK if bot using shift lock he will go to front and set everything front
					Direction = -90-- CHANGE DIRECTION TO Right
					DashType = "Right"-- CHANGE DIRECTION TO Right
				end
			end

			local BV = Instance.new("BodyVelocity")-- add Body Speed 
			BV.MaxForce, BV.Velocity = Vector3.new(5e4, 5e2, 5e4), (Root.CFrame * CFrame.Angles(0, math.rad(Direction), 0)).lookVector * 0 -- set speed and where he will go
			BV.Parent = Root -- put body speed into character root


			coroutine.wrap(function()
				local DashAnim = DashAnims[DashType] -- get dash animation
				DashAnim.Priority = Enum.AnimationPriority.Action3 -- set it action3 to play good


				DashAnim:Play()-- play animation
				DashAnim:AdjustSpeed(1.2) -- change animation speed to 1.2

				local Length = DashAnim.Length/DashAnim.Speed * .75 -- Dash Length

				local DashSpeed = Humanoid.WalkSpeed == 24 and 50 or 45 -- And Dash Speed based on player speed

				if not Root or not Humanoid then -- not found root or humanoid the scripot with stuck
					return
				end

				local BaseSpeed = 45 -- normal speed of dashing

				local DashSound = script.Sound:Clone() --get dash sound
				DashSound.Parent = Character -- put it into character
				DashSound:Play() -- play it
				game.Debris:AddItem(DashSound,1) --remove it after 1 second

				local SmokeClock = os.clock() -- smoke clock the time
				local debrisFolder = workspace.Debris -- get debris folder in the workspace


				local function CreateSmoke() -- function to make smoke effect
					local Paramaters = RaycastParams.new() -- params for raycast
					Paramaters.FilterDescendantsInstances = {Character, debrisFolder} -- fillter in character and debris folder

					local RayResult = workspace:Raycast(Root.Position, Vector3.new(0, -6, 0), Paramaters)-- Ray Result 

					if RayResult then -- check it if player touch ground


						local DashSmoke = script.DashSmoke:Clone() --clone dash effect
						DashSmoke.Parent = debrisFolder -- put it in debrisfolder in workspace
						DashSmoke.Position = RayResult.Position --the position on the ground 
						DashSmoke.DashEffect.Color = ColorSequence.new(RayResult.Instance.Color) -- make a color on ground coilor 
						DashSmoke.DashEffect.Enabled = true -- enable effect

						task.spawn(function()--in same time after 0.7 second effect will disappear
							task.wait(.07)
							DashSmoke.DashEffect.Enabled = false
							game.Debris:AddItem(DashSmoke, DashSmoke.DashEffect.Lifetime.Max)
						end)

						SmokeClock = os.clock()
					end

				end

				local Connection; Connection = game:GetService("RunService").Heartbeat:Connect(function()-- do a loop to use smoke function
					if os.clock() - SmokeClock >= (.07 / (DashSpeed/BaseSpeed)) then
						CreateSmoke()
					end
				end)

				task.delay(Length, function()-- here delay function when dash done
					if Connection then -- check the connection if play
						Connection:Disconnect() -- stop it
						CreateSmoke() -- add the last dust effect
					end
				end)



				local Tick = os.clock() -- add time clock speed

				while os.clock() - Tick < Length do -- check the time for dash
					if BV then -- and check body velcoity if is here
						BV.Velocity = (Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Direction), 0)).lookVector * DashSpeed -- achange speed now here
					else
						break
					end
					RunService.Stepped:Wait()-- stuck the script
				end

				BV:Destroy()-- remove the body speed
			end)()
		end,
	},
---GroundSlam Frame
	["GroundSlam"] = {
		["Checks"] = {"Blocking", "Stunned", "Dashing", "Cutscene", "Attacking", "Evasive","Punching", "DoupleJump"},-- Checking If Player Has Any Tag Wi5th Named (If He Attacking Skill Or punching or Using thing)
		["StaminaConsume"] = 0,-- take stamina 
		["Function"] = function(Player, Character, Key))-- Here The Function When Player Start With Key
			-- Get player from character
			local DoupleJumping = Player:WaitForChild("DoupleJumping") -- douple jump bolean value
			if DoupleJumping.Value ~= true then return end -- if value not true its mean player isnt using douple jump so the script will end here
			Cooldown.AddCooldown(Character, "GroundSlam")	-- ad cooldown
			Character:AddTag("Attacking")-- add attack tag bc this is a skill
			local HRP = Character.HumanoidRootPart -- get character HumanoidRootPart

			-- Play hold anim
			local HoldingTrack = Shared_Functions.PlayAnim(Character, "GroundSlam", Enum.AnimationPriority.Action2)--play animation by a module 
			HoldingTrack:GetMarkerReachedSignal("Flying"):Connect(function()--when get animation event called flying the animation will change speed to 0 to freeze
				HoldingTrack:AdjustSpeed(0)-- change speed to 0 to freeze
			end)
			
			local Params = RaycastParams.new()-- get params raycast
			local lookVector = Character.HumanoidRootPart.CFrame.LookVector -- player lookvector

			local humanoids = {}-- humanoids table in workspace
			for i, v in pairs(workspace:GetDescendants()) do -- get humanoids from workspace and put 
				if v:IsA("Humanoid") then -- check if thing is a humanoid
					table.insert(humanoids, v.Parent) -- insert in table with
				end
			end

			Params.FilterDescendantsInstances = {Character, HRP.Parent, workspace.Debris, humanoids}-- filter the params
			
			-- Damage data
			local Data = {-- Data thing for hitbox and damage module 
				Attacker = Character,-- get attacker
				Damage = 5.5, -- the damage
				HitEffect = "None",-- hiteffect
				HitAnimation = "None",-- hit animation
				HitSound = "None",-- hitsound all is none bc i'd want to use it in this skill
				ScreenShake = {
					Type = "Target",
					Intensity = .8,
				},

				Block_Data = { -- block settings
					Blockable = false,-- block will break 
					Break = true,--break block ye
				},

				Stun = { -- stun settings
					Duration = 1.2, 
					WalkSpeed = 0,
					JumpPower = 0,
					AutoRotate = false,	
				},

				Ragdoll = {-- ragdoll settings
					Duration = 1.2,
				},
				Combo = nil,
				duration = 0.2,--settings duration
			}
			
			
			
			local raycastOrigin = HRP.Position --origine player hrp
			local raycastDirection = (HRP.CFrame * CFrame.Angles(math.rad(60), 0, 0)).UpVector * -100 --raycast direction
			local ray = workspace:Raycast(raycastOrigin, raycastDirection, Params) -- get ray 
			if ray then --check if ray on ground
				if ray.Instance then --ray setting
					if (ray.Position - raycastOrigin).Magnitude < 40 then --if rayposition and humnaoid root part < 40 then it will work
						--print((ray.Position - raycastOrigin).Magnitude)
							ReplicatorEvent:FireClient(Player, "Universal", "RemoveMovers", { }) -- remove all movers like

						local EnemyBP = Instance.new("BodyPosition")--Add body Positon
						EnemyBP.Name = "AirDown"-- Enemy Air down
						EnemyBP.MaxForce = Vector3.new(4e4,4e4,4e4)-- add max force
						EnemyBP.Position = ray.Position --put enemy positon with ray position
						EnemyBP.P = 4e4 -- positoopn
						EnemyBP.Parent = HRP -- put it in humanoidRootPart
						game.Debris:AddItem(EnemyBP, 1)--Remove After second
						task.delay(.3, function()-- delay .3

							
							Shared_Functions.PlaySound("GroundSmash",{Parent = Character.HumanoidRootPart})-- play ground slam sound by modulke
							
							ReplicatorEvent:FireAllClients("Universal", "FX", {Name = "GroundSlam", Type = "Part", EmitType = "Emit", CFrame = CFrame.new(ray.Position)}) -- add effect in all players clients

							ReplicatorEvent:FireAllClients("Universal", "Crater2", {origin = ray.Position + Vector3.new(0, 3, 0), direction =  Vector3.new(0, -25, 0), segments = 18, radius = 8, height = 2, width = 2, xAngle = 45, speed =0.1, lifeTime = 4})-- add rock 
							ReplicatorEvent:FireAllClients("Universal", "RockDebris", {origin = ray.Position + Vector3.new(0, 3, 0), direction =  Vector3.new(0, -25, 0), amount = 13, params = nil,duration = 4,onFire = false}) -- ad block explositon

							ReplicatorEvent:FireClient(Player, "Universal", "ScreenShake", {Intensity = Data.ScreenShake.Intensity})--add screenshake to me

							local cframe =  CFrame.new(ray.Position)-- cframe
							local Hitbox = HitboxModule.new(Character, Vector3.new(15,5,15), CFrame.new(ray.Position), nil, HitboxModule.DetectionTypes.OnceReturn)-- make hitbox
							-- Hitbox on hit
							Hitbox.OnHit:Connect(function(Entity)--if someone touched hitbox
								task.spawn(function()-- make aspawn function
									Data.HitSound = "None"--- edit data hit sound to none sound
									--Damage.Damage(Entity, Data)
								end)	

									Damage_Module.Damage(Entity, Data)-- damage module to damag ethe player who touched it
							end)

							Hitbox:HitStart(5/20)-- start the hitbox function


							HoldingTrack:AdjustSpeed(1)--- make aniamtion play again
							Shared_Functions.StopAnim(Character,"GroundSlam")--- stop animation 
							
						end)
					else
						HoldingTrack:AdjustSpeed(1)--- make aniamtion play again
						Shared_Functions.StopAnim(Character,"GroundSlam")-- stop animation 
					end
				else
					HoldingTrack:AdjustSpeed(1)--- make aniamtion play again
					Shared_Functions.StopAnim(Character,"GroundSlam")-- stop animation 
				end
			else
				HoldingTrack:AdjustSpeed(1)--- make aniamtion play again
				Shared_Functions.StopAnim(Character,"GroundSlam")-- stop animation 
			end
			
			HoldingTrack.Stopped:Connect(function()-- track when animation stop
				Character:RemoveTag("Attacking")-- remove attacking tag
				task.delay(3, function()-- delay
					Cooldown.RemoveCooldown(Player, "GroundSlam")---remove cooldow
				end)
			end)
			
			
			
		end,
	},
  -- COPUNTER fRAME
	["Counter"] = {-- counter skill
		["Checks"] = {"Blocking", "Stunned", "Dashing", "Cutscene", "Attacking", "Evasive","Punching", "DoupleJump"},-- Checking If Player Has Any Tag Wi5th Named (If He Attacking Skill Or punching or Using thing)
		["StaminaConsume"] = 0,-- take stamina
		["Function"] = function(Player, Character, Key))-- Here The Function When Player Start With Key
			-- Get player from character
			
			Cooldown.AddCooldown(Character, "Counter")	-- add cooldown
			Character:AddTag("Attacking")-- add attacking tag
			local HRP = Character.HumanoidRootPart -- get humanoidrootpart

			-- Play hold anim
			--[[local HoldingTrack = Shared_Functions.PlayAnim(Character, "GroundSlam", Enum.AnimationPriority.Action2)
			HoldingTrack:GetMarkerReachedSignal("Flying"):Connect(function()
				HoldingTrack:AdjustSpeed(0)
			end)--]]

			local CounterChecker = Instance.new("StringValue")--add string value to check the counter in daamge module
			CounterChecker.Name = "CombatCountering"-- edit the name
			CounterChecker.Value = "CombatCountering"-- edit the value 
			CounterChecker.Parent = Character -- put the value in the character

				wait(1)-- wait 
			CounterChecker:Destroy()-- destroy the value
				Character:RemoveTag("Attacking")-- remove attack tag
				task.delay(3, function()-- function to delay
					Cooldown.RemoveCooldown(Player, "Counter")-- remove cooldown after 3 secobd
				end)

		end,
	},
	["Evasive"] = {
		["Checks"] = {"Evasive"},-- Checking If Player Has Any Tag Wi5th Named (If He Attacking Skill Or punching or Using thing)
		["Function"] = function(Player, Character, Key))-- Here The Function When Player Start With Key
			Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
			local EvasiveBar = Player:WaitForChild("EvasiveBar")-- find evasive bar in the character its a value
			
			if EvasiveBar.Value == nil then return end -- check if the value nil the script will stop

			-- Check if character health is equal or under 60%
			if Character.Humanoid.MaxHealth * 0.6 >= Character.Humanoid.Health  then -- check if player health correct to setup it
				
				-- Check if evsaive meter is 100
				if EvasiveBar.Value == 100 then		-- if value is 100 work		
					Character:AddTag("Evasive") --add tag
					EvasiveBar.Value = 0 --set evasive 0 after use it

					-- Make character invisible
					for _, v in ipairs(Character:GetChildren()) do
						if v:IsA("BasePart") then
							v.Transparency = 1-- disappear the character parts
						end
					end
					
					local dashPos = Character.HumanoidRootPart.Position
					local moveDirection = nil
					
					if Character.Humanoid.MoveDirection.Magnitude > 0.05 then
						moveDirection = Character.Humanoid.MoveDirection
					else
						moveDirection = Character.HumanoidRootPart.CFrame.RightVector
					end
					
					Character.Humanoid.AutoRotate = false -- player cant rotate now
					Character.HumanoidRootPart.CFrame = CFrame.lookAt(Character.HumanoidRootPart.Position, Character.HumanoidRootPart.Position + moveDirection)-- change player cframe
				
					
					-- Replicate evasive FX 
					ReplicatorEvent:FireAllClients("Universal", "FX", {Name = "Evasive", Type = "PartFollow", Parent = Character.HumanoidRootPart, EmitType = "Enabled", Duration = 0.5})-- add evasive effect
					
					-- Create body position
					if Player then
						ReplicatorEvent:FireClient(Player, "Universal", "RemoveMovers", {})--- remove movers like body position or body velocity
						ReplicatorEvent:FireClient(Player, "Universal", "BodyMover", {-- add body position
							Type = "BodyPosition",
							MaxForce = Vector3.new(20000,0,20000),
							Position = dashPos + moveDirection * 25,
							P = 600,
							Duration = 0.5,
							Parent = Character.HumanoidRootPart
						})
					else
						Shared_Functions.RemoveMovers(Character)--- remove movers like body position or body velocity
						Shared_Functions.BodyMover("BodyPosition",-- add body position
							{
								MaxForce = Vector3.new(20000,0,20000),
								Position = dashPos + moveDirection * 25,
								P = 600,
								Duration = 0.5,
								Parent = Character.HumanoidRootPart
							}
						)
					end

					task.delay(0.5,function()
						Character:RemoveTag("Evasive")-- remove evasive tag
						Character.Humanoid.AutoRotate = true -- return the auto rotate to nraml
						for _, v in ipairs(Character:GetChildren()) do 
							if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
								v.Transparency = 0 -- appear the chracter parts
							end
						end
					end)
				end
			end


		end,
	},
	-- bLOCK fRAME
	["Block"] = {
		["Checks"] = {"Stunned", "Punching", "Dashing", "Attacking", "DoupleJump"},,-- Checking If Player Has Any Tag Wi5th Named (If He Attacking Skill Or punching or Using thing)
		["Function"] = function(Player, Character, Key)-- Here The Function When Player Start With Key
			if Cooldowns[Character] == nil then
				Cooldowns[Character] = { }
			end
			local isBlocking = Player:WaitForChild("isBlocking")
			if Cooldowns[Character]["Block"] == nil then
				Cooldowns[Character]["Block"] = false
			end

			if Cooldowns[Character]["Block"] == true or Shared_Functions.CheckTag(Character, {"Stunned", "Punching", "Dashing", "Cutscene"}) == false then return end -- check if anycooldown or smt

			Character:RemoveTag("Running")-- remove all other movment tags
			Character:RemoveTag("Sliding")-- remove all other movment tags
			Character:AddTag("Blocking")-- add blocking tag
			Character:AddTag("PerfectBlocking") -- add perfectblock tag to do parry
			isBlocking.Value = true -- add player blocking value
			Cooldown.AddCooldown(Character, "Block", 1.2) -- add cooldown
			task.delay(0.15,function()
				Character:RemoveTag("PerfectBlocking")-- remove perfect block tag
			end)
			Character.Humanoid.WalkSpeed = 4-- change player walkl speed

			local track = Character.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.Main.Assets.Animations.Combat.Blocking)-- get block animation
			track.Priority = Enum.AnimationPriority.Action3 -- change the action of player
			track:Play(0.05)-- play aniamtion

			repeat -- stuck the script here for when the player remove his finger fro mthe key
				task.wait()
			until ClientInformation.FetchKey(Player)[Key] == false

			if Character:HasTag("Blocking") then -- check if player blocking tag
				track:Stop(0.05)-- stop animation
				Character:RemoveTag("Blocking") -- remove blocking tag
				Character.Humanoid.WalkSpeed = 16 -- retuern walk speed normal
				isBlocking.Value = false -- change is blocking value to fdalse
			end	

			Character.ChildRemoved:Connect(function(Value)
				if Value.Name == "BlockBar" then -- checkl if blockbar removed
					track:Stop(0.05) -- stop animation
					Character:RemoveTag("Blocking")-- remove blocking tag
					Character.Humanoid.WalkSpeed = 16 -- retuern walk speed normal
					isBlocking.Value = false -- change is blocking value to fdalse

				end
			end)

		end,
	},
	-- Final Is Combat Frame Here
	["Regular Punch"] = { 
		["Checks"] = {"Blocking", "Stunned", "Dashing", "Cutscene", "Attacking", "Evasive", "DoupleJump"},,-- Checking If Player Has Any Tag Wi5th Named (If He Attacking Skill Or punching or Using thing)
		["StaminaConsume"] = 0,--take stamina
		["Function"] = function(Player, Character, Key)-- Here The Function When Player Start With Key
			-- Get player from character
			Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
			Character:RemoveTag("Sliding") -- remove mobment tags
			Character:RemoveTag("Running") -- remove mobment tags
			
			
			-- Create combat table for character if it's nil
			if Combat[Character] == nil then
				Combat[Character] = { 
					Combo = 1,
					AirCombo = false,
					Uptilt = false,
					Prev = os.clock(),
					Y_axis = nil,
					Curr = 0,
				}
			end	
			
			-- Combo reset
			Combat[Character].Curr = os.clock()

		
			if Combat[Character].AirCombo == true and Combat[Character].Combo == 5 then --if player aircombo true and in combo 5 go to top
				if (Combat[Character].Curr - Combat[Character].Prev) > 0.8 then
					Combat[Character] = { 
						Combo = 1,
						AirCombo = false,
						Prev = os.clock(),
						Curr = 0,
					}
					
					Cooldown.AddCooldown(Character, "Regular Punch", 1)--add cooldown to punch
					
					return
				end
			else
				if (Combat[Character].Curr - Combat[Character].Prev) > 1 then
					Combat[Character] = { 
						Combo = 1,
						AirCombo = false,
						Prev = os.clock(),
						Curr = 0,
					}
				end
			end	
			Combat[Character].Prev = os.clock()
			
			local CurrCombo = Combat[Character].Combo -- add a varible for current combo to make easy scripting
			
			-- Visualizer propertie
			local config = ClientInformation["Configurations"][Player]--get keybind
			local visualizer = false -- vaible
			if config ~= nil then -- if confige true or not nil its will eidt 
				visualizer = ClientInformation["Configurations"][Player]["Visualizer"]
				if visualizer == nil then
					visualizer = false
				end
			end
			
			-- Add effects to character
			local effectData = {AutoRotate = true, JumpPower = 0, Tag = "Punching", WalkSpeed = 4} -- effect data table
			if visualizer then -- if Visualizer true from previus function will change the color screen
				effectData.Visualizer = {Tint = Color3.fromRGB(220, 184, 26)}
			end
			
			StunModule.Effect(Character, 0.7, effectData) --add effectr
			
			-- Damage data
			local Data = {--data tabel 
				Attacker = Character,--who attacking
				Damage = 5,--damage
				HitEffect = "Basic Hit",--hiteffect
				HitAnimation = "Hit" .. CurrCombo,--hitanimation
				HitSound = "Hit" .. CurrCombo,--hitsound
				CurrCombo = CurrCombo,-- current combo
				ScreenShake = {--screenshake sttings
					Type = "Both",
					Intensity = 0.8,
				},
				
				Block_Data = {--block settings if its blockabvle or instance break
					Blockable = true,
					Break = false,
				},
				
				BodyMover = {-- body mover
					Type = "BodyVelocity",
					MaxForce = Vector3.new(20000, 0, 20000),
					Velocity = Character.HumanoidRootPart.CFrame.LookVector * 10,
					Duration = 0.15,
				},
				
				Stun = { --stun settings
					Duration = 1, 
					WalkSpeed = 0,
					JumpPower = 0,
					AutoRotate = false,	
				},
	
				
				Ragdoll = nil,--ragdol settings
				Combo = nil, -- combo settings
			}
			
			-- Get the punch animation and add cooldown
			local PunchAnimation = Shared_Functions.GetAnimation(CurrCombo)-- get punch animation
			local CooldownDuration = 0.3 -- Default cooldown
			
			if CurrCombo == 4 then -- cuurent combo 4 settings here
				if Player then
					if ClientInformation.FetchKey(Player)["Space"] == true and not Combat[Character].AirCombo then
						PunchAnimation = Shared_Functions.GetAnimation("Uptilt")-- uptilit aniamtion
						CooldownDuration = 0.5-- cooldown duratioin 
						
						Data.Stun.Duration = 1 -- stun duration editing
						Data.BodyMover = nil --body mover setting to nil bc he will go in air
						Data.Combo = "Uptilt" -- data comob is uptilit set
						
						Combat[Character].Y_axis = Character.HumanoidRootPart.Position.Y + 0.5 -- player fly when uptilit
						
						Data.AirCombo = {-- aircombo setting to air
							Y_axis = Combat[Character].Y_axis
						}
						
						Combat[Character].AirCombo = true -- air combo value true
						Combat[Character].Uptilt = true -- uptililt combo value true
						--Combat[Character].Combo = 0--
					end
				end
			elseif CurrCombo == 5 then -- combo 5 settings
				CooldownDuration = 1.5 --cooldown
				
				Data.BodyMover.Velocity = Character.HumanoidRootPart.CFrame.LookVector * 50 -- konck back
				Data.Block_Data.Break = false -- block break false
				
				
				if Combat[Character].AirCombo == true then -- airdown
					Data.AirCombo = {-- air down settings to ground effect
						Y_axis = Combat[Character].Y_axis
					}
					PunchAnimation = Shared_Functions.GetAnimation("Downslam") --get down animation
					
					Data.Stun.Duration = 1 -- stun duration set to 1
					Data.BodyMover = nil -- body mover nil
					Data.Ragdoll = nil -- ragdoll nil bc he will dropo and play animation
					Data.Combo = "Downslam" -- change combo data
				end
			end
			
			-- Apply cooldown
			Cooldown.AddCooldown(Character, "Regular Punch", CooldownDuration)  -- add cooldown
			
			-- Push the player
			if Combat[Character].AirCombo == true then -- Push the player
				if Combat[Character].Uptilt ~= true then
					Data.AirCombo = {
						Y_axis = Combat[Character].Y_axis
					}
					if Player then
						ReplicatorEvent:FireClient(Player, "Universal", "RemoveMovers", { })-- remove movers 
						ReplicatorEvent:FireClient(Player, "Universal", "BodyMover", { --ad bodyposition
							Type = "BodyPosition", 
							MaxForce = Vector3.new(math.huge, math.huge, math.huge),
							Position = Vector3.new(Character.HumanoidRootPart.Position.X, Combat[Character].Y_axis, Character.HumanoidRootPart.Position.Z) + Character.HumanoidRootPart.CFrame.LookVector * 3.5,
							
							Duration = 1
						})
					else
						Shared_Functions.RemoveMovers(Character)-- remove movers
						Shared_Functions.BodyMover("BodyPosition",--ad bodyposition
							{
								Position = Vector3.new(Character.HumanoidRootPart.Position.X, Combat[Character].Y_axis, Character.HumanoidRootPart.Position.Z) + Character.HumanoidRootPart.CFrame.LookVector * 3.5,
								Duration = 1,
								MaxForce = Vector3.new(math.huge, math.huge, math.huge),
								Parent = Character.HumanoidRootPart
							}
						)
					end
				end	
			else
				if Combat[Character].Uptilt ~= true then
					if Player then
						ReplicatorEvent:FireClient(Player, "Universal", "BodyMover", {--ad BodyVelocity
							Type = "BodyVelocity", 
							Velocity = Character.HumanoidRootPart.CFrame.LookVector * 5,
							MaxForce = Vector3.new(20000, 0, 20000),
							Duration = 0.15
						})
					else
						Shared_Functions.BodyMover("BodyVelocity",--ad BodyVelocity
							{
								Velocity = Character.HumanoidRootPart.CFrame.LookVector * 5,
								MaxForce = Vector3.new(20000, 0, 20000),
								Duration = 0.15,
								Parent = Character.HumanoidRootPart
							}
						)
					end
				end
			end	
			
		
			-- Create the hitbox
			if visualizer then
				Data.Stun.Visualizer = {Tint = Color3.fromRGB(188, 0, 0)}
			end
			
			local Hitbox = HitboxModule.new(Character, Vector3.new(5,5,5), nil, nil, HitboxModule.DetectionTypes.OnceReturn, visualizer)-- add hitbox here
			local PunchMissed = true
			
			-- On hit connection
			Hitbox.OnHit:Connect(function(Entity)--check who touched hitbox
				PunchMissed = false -- if punch not touched anyone
				Combat[Character].Y_axis = Character.HumanoidRootPart.Position.Y + 20-- the target will go to top
					Damage_Module.Damage(Entity, Data)-- use damage module to damage and get effects
					
			end)
			
			-- Stop anims
			Shared_Functions.StopAnims(Character)-- stop punch animation

			-- Play punch animation
			local PunchTrack = Character.Humanoid.Animator:LoadAnimation(PunchAnimation)-- get punch animation
			PunchTrack.Priority = Enum.AnimationPriority.Action4 --change action to last one
			
			local delayTime = PunchAnimation.Attack.Value-- delay the hitbox
			
			PunchTrack:Play()
			
			
			task.delay(delayTime, function() -- the delay
				Hitbox:HitStart(0.2)-- start hitbox
				
				-- Uptilt
				if Combat[Character].Uptilt == true and CurrCombo == 4 then
					Combat[Character].Uptilt = false -- uptilit false drop the player
				end
				
				-- Play missed sound if player missed the punch
				if PunchMissed then
					--Shared_Functions.PlaySound("Miss" .. CurrCombo, {Parent = Character.HumanoidRootPart})
				end
			end)

			-- Update the combo counter
			if Combat[Character].Combo < 5 then
				Combat[Character].Combo += 1
			elseif Combat[Character].Combo == 5 then
				Combat[Character].Combo = 1
				Combat[Character].AirCombo = false
			end
		end,
	},
}

return Default
