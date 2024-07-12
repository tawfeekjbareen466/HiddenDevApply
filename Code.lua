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

local Default = {
  ----Sliding Frame
	["Sliding"] = {
		["Checks"] = {"Punching", "Dashing", "Blocking", "Stunned", "Attacking", "Evasive", "Cutscene", "DoupleJump"},
		["Function"] = function(Player, Character, Key)
			if ClientInformation.FetchKey(Player)["W"] == false then return end
			Cooldown.AddCooldown(Character, "Sliding")
			
			local clock = 0
			local debounce = 0.1
			
			StunModule.Effect(Character, nil, {Tag = "Sliding", JumpPower = 0, WalkSpeed = 1.5, AutoRotate = true})
			Character.Mechanics.TiltWalk:SetAttribute("Enabled", false)
			
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Include 
			params.FilterDescendantsInstances = { workspace.Map }
			
			local last_Yaxis = Character.HumanoidRootPart.Position.Y
			
			local maxSpeed = 60
			local speed = math.min(maxSpeed, (Character.HumanoidRootPart.Position - (Character.HumanoidRootPart.Position + Character.HumanoidRootPart.Velocity)).Magnitude) + 25
			
			local slidingTrack = Character.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.Main.Assets.Animations.Movement.Sliding)
			slidingTrack.Priority = Enum.AnimationPriority.Action3
			slidingTrack:Play()
			
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(20000, 1000, 20000)
			bodyVelocity.P = 600
			bodyVelocity.Velocity = Character.Humanoid.MoveDirection  * speed  + Vector3.new(0,-10,0)
			bodyVelocity.Parent = Character.HumanoidRootPart
			
			
			local connection = nil
			connection = RunService.Heartbeat:Connect(function()
				if clock > os.clock() then return end
				
				if speed == 0 then
					connection:Disconnect()
					slidingTrack:Stop()
					bodyVelocity:Destroy()

					Character.Mechanics.TiltWalk:SetAttribute("Enabled", true)

					StunModule.RemoveEffect(Character, "Sliding")

					task.delay(1, function()
						Cooldown.RemoveCooldown(Character, "Sliding")
					end)
					return
				end
				
				if not Character:HasTag("Sliding") then 
					connection:Disconnect()
					slidingTrack:Stop()
					bodyVelocity:Destroy()

					Character.Mechanics.TiltWalk:SetAttribute("Enabled", true)

					StunModule.RemoveEffect(Character, "Sliding")

					task.delay(1, function()
						Cooldown.RemoveCooldown(Character, "Sliding")
					end)
					return
				end
				
				clock = os.clock() + debounce
				
				local originPos = Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0) + Character.HumanoidRootPart.CFrame.LookVector * 7
				local targetPos = Vector3.new(0, -15, 0)
				
				local raycast = workspace:Raycast(originPos, targetPos)
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
			
			repeat
				task.wait()
			until ClientInformation.FetchKey(Player)[Key] == false
			
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
		["Checks"] = {"Punching", "Dashing", "Stunned", "Blocking", "Attacking", "Sliding", "Cutscene", "DoupleJump"},
		["Function"] = function(Player, Character, Key)
			Cooldown.AddCooldown(Character, "Sprint")
			Character:AddTag("Running")
			
			local RunAnimation = game.ReplicatedStorage.Main.Assets.Animations.Movement.Running
			local RunTrack = Character.Humanoid.Animator:LoadAnimation(RunAnimation)
			RunTrack.Priority = Enum.AnimationPriority.Action2
			
			if Character.Humanoid.MoveDirection.Magnitude > 0.05 then
				if Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
					RunTrack:Play()
				end	
			end
			
			Character.Humanoid.WalkSpeed = 32
			
			if Connections[Character] == nil then
				Connections[Character] = { }
			end
			
			Connections[Character]["Running"] = nil
			Connections[Character]["Running"] = Character.Humanoid.Running:Connect(function()
				if Character.Humanoid.MoveDirection.Magnitude > 0.05 then
						if not RunTrack.IsPlaying then
							RunTrack:Play()
						end
				else
					if RunTrack.IsPlaying then
						RunTrack:Stop()
					end
				end
			end)
			
			Connections[Character]["Jump"] = nil
			Connections[Character]["Jump"] = Character.Humanoid.Changed:Connect(function()
				if Character.Humanoid.Jump then
					if RunTrack.IsPlaying then
						RunTrack:Stop()
					end
				end
			end)
			
			Connections[Character]["StopSprinting"] = nil
			Connections[Character]["StopSprinting"] = Collection_Service:GetInstanceRemovedSignal("Running"):Connect(function(object)
				if object == Character then
					Connections[Character]["Jump"]:Disconnect()
					Connections[Character]["Running"]:Disconnect()
					Connections[Character]["StopSprinting"]:Disconnect()
					
					RunTrack:Stop()
					Cooldown.RemoveCooldown(Character, "Sprint")
					return
				end
			end)
	
			repeat
				task.wait()
			until ClientInformation.FetchKey(Player)[Key] == false
			
			if Character:HasTag("Running") then
				Connections[Character]["Jump"]:Disconnect()
				Connections[Character]["Running"]:Disconnect()
				Connections[Character]["StopSprinting"]:Disconnect()
				RunTrack:Stop()
				Character:RemoveTag("Running")
				

				Character.Humanoid.WalkSpeed = 16
				
				-- Cooldown
				task.delay(0.5, function()
					Cooldown.RemoveCooldown(Character, "Sprint")
				end)
			
			end
		end,
	},
---Dash Frame
	["Dash"] = {
		["Checks"] = {"Punching", "Stunned", "Blocking", "Attacking", "Sliding", "DoupleJump"},
		["Function"] = function(Player, Character, Key)

			local Humanoid = Character:WaitForChild("Humanoid")
			local Root = Character:WaitForChild("HumanoidRootPart")
			local Animations = game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Assets"):WaitForChild("Animations"):WaitForChild("Dashes")
			Cooldown.AddCooldown(Character, "Dash",1.2)

			-- ANIMATIONS --
			local DashAnims = {
				["Front"] = Character.Humanoid.Animator:LoadAnimation(Animations.DashFront),
				["Back"] = Character.Humanoid.Animator:LoadAnimation(Animations.DashBack),
				["Right"] = Character.Humanoid.Animator:LoadAnimation(Animations.DashRight),
				["Left"] = Character.Humanoid.Animator:LoadAnimation(Animations.DashLeft),
			}

			Character:AddTag("Dashing")
			Character:AddTag("IFrame")

			task.delay(1, function()
				Character:RemoveTag("IFrame")
				Character:RemoveTag("Dashing")

			end)
			local Direction = 0
			local DashType = "Front"	
			if ClientInformation.FetchKey(Player)["A"] == true then
				if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then Direction = 0 DashType = "Front" else
					Direction = 90
					DashType = "Left"
				end
			end	
			if  ClientInformation.FetchKey(Player)["S"] == true then
				if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then Direction = 0 DashType = "Front" else
					Direction = 180
					DashType = "Back"
				end
			end
			if  ClientInformation.FetchKey(Player)["D"] == true then
				if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then Direction = 0 DashType = "Front" else
					Direction = -90
					DashType = "Right"
				end
			end

			local BV = Instance.new("BodyVelocity")
			BV.MaxForce, BV.Velocity = Vector3.new(5e4, 5e2, 5e4), (Root.CFrame * CFrame.Angles(0, math.rad(Direction), 0)).lookVector * 0
			BV.Parent = Root


			coroutine.wrap(function()
				local DashAnim = DashAnims[DashType]
				DashAnim.Priority = Enum.AnimationPriority.Action3


				DashAnim:Play()
				DashAnim:AdjustSpeed(1.2)

				local Length = DashAnim.Length/DashAnim.Speed * .75

				local DashSpeed = Humanoid.WalkSpeed == 24 and 50 or 45

				if not Root or not Humanoid then
					return
				end

				local BaseSpeed = 45

				local DashSound = script.Sound:Clone()
				DashSound.Parent = Character
				DashSound:Play()
				game.Debris:AddItem(DashSound,1)

				local SmokeClock = os.clock()
				local debrisFolder = workspace.Debris


				local function CreateSmoke()
					local Paramaters = RaycastParams.new()
					Paramaters.FilterDescendantsInstances = {Character, debrisFolder}



					local RayResult = workspace:Raycast(Root.Position, Vector3.new(0, -6, 0), Paramaters)

					if RayResult then


						local DashSmoke = script.DashSmoke:Clone()
						DashSmoke.Parent = debrisFolder
						DashSmoke.Position = RayResult.Position
						DashSmoke.DashEffect.Color = ColorSequence.new(RayResult.Instance.Color)
						DashSmoke.DashEffect.Enabled = true

						task.spawn(function()
							task.wait(.07)
							DashSmoke.DashEffect.Enabled = false
							game.Debris:AddItem(DashSmoke, DashSmoke.DashEffect.Lifetime.Max)
						end)

						SmokeClock = os.clock()
					end

				end

				local Connection; Connection = game:GetService("RunService").Heartbeat:Connect(function()
					if os.clock() - SmokeClock >= (.07 / (DashSpeed/BaseSpeed)) then
						CreateSmoke()
					end
				end)

				task.delay(Length, function()
					if Connection then
						Connection:Disconnect()
						CreateSmoke()
					end
				end)



				local Tick = os.clock()

				while os.clock() - Tick < Length do
					if BV then
						BV.Velocity = (Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Direction), 0)).lookVector * DashSpeed
					else
						break
					end
					RunService.Stepped:Wait()
				end

				BV:Destroy()
			end)()
		end,
	},
---GroundSlam Frame
	["GroundSlam"] = {
		["Checks"] = {"Blocking", "Stunned", "Dashing", "Cutscene", "Attacking", "Evasive","Punching", "DoupleJump"},
		["StaminaConsume"] = 0,
		["Function"] = function(Player, Character, Key)
			-- Get player from character
			local DoupleJumping = Player:WaitForChild("DoupleJumping")
			if DoupleJumping.Value ~= true then return end
			Cooldown.AddCooldown(Character, "GroundSlam")	
			Character:AddTag("Attacking")
			local HRP = Character.HumanoidRootPart

			-- Play hold anim
			local HoldingTrack = Shared_Functions.PlayAnim(Character, "GroundSlam", Enum.AnimationPriority.Action2)
			HoldingTrack:GetMarkerReachedSignal("Flying"):Connect(function()
				HoldingTrack:AdjustSpeed(0)
			end)
			
			local Params = RaycastParams.new()
			local lookVector = Character.HumanoidRootPart.CFrame.LookVector

			local humanoids = {}
			for i, v in pairs(workspace:GetDescendants()) do
				if v:IsA("Humanoid") then
					table.insert(humanoids, v.Parent)
				end
			end

			Params.FilterDescendantsInstances = {Character, HRP.Parent, workspace.Debris, humanoids}
			
			-- Damage data
			local Data = {
				Attacker = Character,
				Damage = 5.5,
				HitEffect = "None",
				HitAnimation = "None",
				HitSound = "None",
				ScreenShake = {
					Type = "Target",
					Intensity = .8,
				},

				Block_Data = {
					Blockable = false,
					Break = true,
				},

				Stun = { 
					Duration = 1.2, 
					WalkSpeed = 0,
					JumpPower = 0,
					AutoRotate = false,	
				},

				Ragdoll = {
					Duration = 1.2,
				},
				Combo = nil,
				duration = 0.2,
			}
			
			
			
			local raycastOrigin = HRP.Position
			local raycastDirection = (HRP.CFrame * CFrame.Angles(math.rad(60), 0, 0)).UpVector * -100
			local ray = workspace:Raycast(raycastOrigin, raycastDirection, Params)
			if ray then
				if ray.Instance then
					if (ray.Position - raycastOrigin).Magnitude < 40 then
						--print((ray.Position - raycastOrigin).Magnitude)
							ReplicatorEvent:FireClient(Player, "Universal", "RemoveMovers", { })

						local EnemyBP = Instance.new("BodyPosition")
						EnemyBP.Name = "AirDown"
						EnemyBP.MaxForce = Vector3.new(4e4,4e4,4e4)
						EnemyBP.Position = ray.Position
						EnemyBP.P = 4e4
						EnemyBP.Parent = HRP
						game.Debris:AddItem(EnemyBP, 1)
						task.delay(.3, function()

							
							Shared_Functions.PlaySound("GroundSmash",{Parent = Character.HumanoidRootPart})
							
							ReplicatorEvent:FireAllClients("Universal", "FX", {Name = "GroundSlam", Type = "Part", EmitType = "Emit", CFrame = CFrame.new(ray.Position)})

							ReplicatorEvent:FireAllClients("Universal", "Crater2", {origin = ray.Position + Vector3.new(0, 3, 0), direction =  Vector3.new(0, -25, 0), segments = 18, radius = 8, height = 2, width = 2, xAngle = 45, speed =0.1, lifeTime = 4})
							ReplicatorEvent:FireAllClients("Universal", "RockDebris", {origin = ray.Position + Vector3.new(0, 3, 0), direction =  Vector3.new(0, -25, 0), amount = 13, params = nil,duration = 4,onFire = false})

							ReplicatorEvent:FireClient(Player, "Universal", "ScreenShake", {Intensity = Data.ScreenShake.Intensity})

							local cframe =  CFrame.new(ray.Position)
							local Hitbox = HitboxModule.new(Character, Vector3.new(15,5,15), CFrame.new(ray.Position), nil, HitboxModule.DetectionTypes.OnceReturn)
							-- Hitbox on hit
							Hitbox.OnHit:Connect(function(Entity)
								task.spawn(function()
									Data.HitSound = "None"
									--Damage.Damage(Entity, Data)
								end)	

									Damage_Module.Damage(Entity, Data)
							end)

							Hitbox:HitStart(5/20)


							HoldingTrack:AdjustSpeed(1)
							Shared_Functions.StopAnim(Character,"GroundSlam")
							
						end)
					else
						HoldingTrack:AdjustSpeed(1)
						Shared_Functions.StopAnim(Character,"GroundSlam")
					end
				else
					HoldingTrack:AdjustSpeed(1)
					Shared_Functions.StopAnim(Character,"GroundSlam")
				end
			else
				HoldingTrack:AdjustSpeed(1)
				Shared_Functions.StopAnim(Character,"GroundSlam")
			end
			
			HoldingTrack.Stopped:Connect(function()
				Character:RemoveTag("Attacking")
				task.delay(3, function()
					Cooldown.RemoveCooldown(Player, "GroundSlam")
				end)
			end)
			
			
			
		end,
	},
  -- COPUNTER fRAME
	["Counter"] = {
		["Checks"] = {"Blocking", "Stunned", "Dashing", "Cutscene", "Attacking", "Evasive","Punching", "DoupleJump"},
		["StaminaConsume"] = 0,
		["Function"] = function(Player, Character, Key)
			-- Get player from character
			
			Cooldown.AddCooldown(Character, "Counter")	
			Character:AddTag("Attacking")
			local HRP = Character.HumanoidRootPart

			-- Play hold anim
			--[[local HoldingTrack = Shared_Functions.PlayAnim(Character, "GroundSlam", Enum.AnimationPriority.Action2)
			HoldingTrack:GetMarkerReachedSignal("Flying"):Connect(function()
				HoldingTrack:AdjustSpeed(0)
			end)--]]

			local CounterChecker = Instance.new("StringValue")
			CounterChecker.Name = "CombatCountering"
			CounterChecker.Value = "CombatCountering"
			CounterChecker.Parent = Character

				wait(1)
			CounterChecker:Destroy()
				Character:RemoveTag("Attacking")
				task.delay(3, function()
					Cooldown.RemoveCooldown(Player, "Counter")
				end)

		end,
	},
	["Evasive"] = {
		["Checks"] = {"Evasive"},
		["Function"] = function(Player, Character, Key)
			Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
			local EvasiveBar = Player:WaitForChild("EvasiveBar")
			
			if EvasiveBar.Value == nil then return end

			-- Check if character health is equal or under 60%
			if Character.Humanoid.MaxHealth * 0.6 >= Character.Humanoid.Health  then
				
				-- Check if evsaive meter is 100
				if EvasiveBar.Value == 100 then				
					Character:AddTag("Evasive")
					EvasiveBar.Value = 0

					-- Make character invisible
					for _, v in ipairs(Character:GetChildren()) do
						if v:IsA("BasePart") then
							v.Transparency = 1
						end
					end
					
					local dashPos = Character.HumanoidRootPart.Position
					local moveDirection = nil
					
					if Character.Humanoid.MoveDirection.Magnitude > 0.05 then
						moveDirection = Character.Humanoid.MoveDirection
					else
						moveDirection = Character.HumanoidRootPart.CFrame.RightVector
					end
					
					Character.Humanoid.AutoRotate = false
					Character.HumanoidRootPart.CFrame = CFrame.lookAt(Character.HumanoidRootPart.Position, Character.HumanoidRootPart.Position + moveDirection)
				
					
					-- Replicate evasive FX 
					ReplicatorEvent:FireAllClients("Universal", "FX", {Name = "Evasive", Type = "PartFollow", Parent = Character.HumanoidRootPart, EmitType = "Enabled", Duration = 0.5})
					
					-- Create body position
					if Player then
						ReplicatorEvent:FireClient(Player, "Universal", "RemoveMovers", {})
						ReplicatorEvent:FireClient(Player, "Universal", "BodyMover", {
							Type = "BodyPosition",
							MaxForce = Vector3.new(20000,0,20000),
							Position = dashPos + moveDirection * 25,
							P = 600,
							Duration = 0.5,
							Parent = Character.HumanoidRootPart
						})
					else
						Shared_Functions.RemoveMovers(Character)
						Shared_Functions.BodyMover("BodyPosition",
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
						Character:RemoveTag("Evasive")
						Character.Humanoid.AutoRotate = true
						for _, v in ipairs(Character:GetChildren()) do
							if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
								v.Transparency = 0
							end
						end
					end)
				end
			end


		end,
	},
	-- bLOCK fRAME
	["Block"] = {
		["Checks"] = {"Stunned", "Punching", "Dashing", "Attacking", "DoupleJump"},
		["Function"] = function(Player, Character, Key)
			if Cooldowns[Character] == nil then
				Cooldowns[Character] = { }
			end
			local isBlocking = Player:WaitForChild("isBlocking")
			if Cooldowns[Character]["Block"] == nil then
				Cooldowns[Character]["Block"] = false
			end

			if Cooldowns[Character]["Block"] == true or Shared_Functions.CheckTag(Character, {"Stunned", "Punching", "Dashing", "Cutscene"}) == false then return end

			Character:RemoveTag("Running")
			Character:RemoveTag("Sliding")
			Character:AddTag("Blocking")
			Character:AddTag("PerfectBlocking")
			isBlocking.Value = true
			Cooldown.AddCooldown(Character, "Block", 1.2)
			task.delay(0.15,function()
				Character:RemoveTag("PerfectBlocking")
			end)
			Character.Humanoid.WalkSpeed = 4

			local track = Character.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.Main.Assets.Animations.Combat.Blocking)
			track.Priority = Enum.AnimationPriority.Action3
			track:Play(0.05)

			repeat
				task.wait()
			until ClientInformation.FetchKey(Player)[Key] == false

			if Character:HasTag("Blocking") then
				track:Stop(0.05)
				Character:RemoveTag("Blocking")
				Character.Humanoid.WalkSpeed = 16
				isBlocking.Value = false
			end	

			Character.ChildRemoved:Connect(function(Value)
				if Value.Name == "BlockBar" then
					track:Stop(0.05)
					Character:RemoveTag("Blocking")
					Character.Humanoid.WalkSpeed = 16
					isBlocking.Value = false

				end
			end)

		end,
	},
	-- Final Is Combat Frame Here
	["Regular Punch"] = { 
		["Checks"] = {"Blocking", "Stunned", "Dashing", "Cutscene", "Attacking", "Evasive", "DoupleJump"},
		["StaminaConsume"] = 0,
		["Function"] = function(Player, Character, Key)
			-- Get player from character
			Player = game:GetService("Players"):GetPlayerFromCharacter(Character)
			Character:RemoveTag("Sliding")
			Character:RemoveTag("Running")
			
			
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
			
			if Combat[Character].AirCombo == true and Combat[Character].Combo == 5 then
				if (Combat[Character].Curr - Combat[Character].Prev) > 0.8 then
					Combat[Character] = { 
						Combo = 1,
						AirCombo = false,
						Prev = os.clock(),
						Curr = 0,
					}
					
					Cooldown.AddCooldown(Character, "Regular Punch", 1)
					
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
			
			local CurrCombo = Combat[Character].Combo
			
			-- Visualizer propertie
			local config = ClientInformation["Configurations"][Player]
			local visualizer = false
			if config ~= nil then
				visualizer = ClientInformation["Configurations"][Player]["Visualizer"]
				if visualizer == nil then
					visualizer = false
				end
			end
			
			-- Add effects to character
			local effectData = {AutoRotate = true, JumpPower = 0, Tag = "Punching", WalkSpeed = 4}
			if visualizer then
				effectData.Visualizer = {Tint = Color3.fromRGB(220, 184, 26)}
			end
			
			StunModule.Effect(Character, 0.7, effectData)
			
			-- Damage data
			local Data = {
				Attacker = Character,
				Damage = 5,
				HitEffect = "Basic Hit",
				HitAnimation = "Hit" .. CurrCombo,
				HitSound = "Hit" .. CurrCombo,
				CurrCombo = CurrCombo,
				ScreenShake = {
					Type = "Both",
					Intensity = 0.8,
				},
				
				Block_Data = {
					Blockable = true,
					Break = false,
				},
				
				BodyMover = {
					Type = "BodyVelocity",
					MaxForce = Vector3.new(20000, 0, 20000),
					Velocity = Character.HumanoidRootPart.CFrame.LookVector * 10,
					Duration = 0.15,
				},
				
				Stun = { 
					Duration = 1, 
					WalkSpeed = 0,
					JumpPower = 0,
					AutoRotate = false,	
				},
	
				
				Ragdoll = nil,
				Combo = nil,
			}
			
			-- Get the punch animation and add cooldown
			local PunchAnimation = Shared_Functions.GetAnimation(CurrCombo)
			local CooldownDuration = 0.3 -- Default cooldown
			
			if CurrCombo == 4 then
				if Player then
					if ClientInformation.FetchKey(Player)["Space"] == true and not Combat[Character].AirCombo then
						PunchAnimation = Shared_Functions.GetAnimation("Uptilt")
						CooldownDuration = 0.5
						
						Data.Stun.Duration = 1
						Data.BodyMover = nil
						Data.Combo = "Uptilt"
						
						Combat[Character].Y_axis = Character.HumanoidRootPart.Position.Y + 0.5
						
						Data.AirCombo = {
							Y_axis = Combat[Character].Y_axis
						}
						
						Combat[Character].AirCombo = true
						Combat[Character].Uptilt = true
						--Combat[Character].Combo = 0--
					end
				end
			elseif CurrCombo == 5 then
				CooldownDuration = 1.5
				
				Data.BodyMover.Velocity = Character.HumanoidRootPart.CFrame.LookVector * 50
				Data.Block_Data.Break = false
				
				
				if Combat[Character].AirCombo == true then
					Data.AirCombo = {
						Y_axis = Combat[Character].Y_axis
					}
					PunchAnimation = Shared_Functions.GetAnimation("Downslam")
					
					Data.Stun.Duration = 1
					Data.BodyMover = nil
					Data.Ragdoll = nil
					Data.Combo = "Downslam"
				end
			end
			
			-- Apply cooldown
			Cooldown.AddCooldown(Character, "Regular Punch", CooldownDuration) 
			
			-- Push the player
			if Combat[Character].AirCombo == true then
				if Combat[Character].Uptilt ~= true then
					Data.AirCombo = {
						Y_axis = Combat[Character].Y_axis
					}
					if Player then
						ReplicatorEvent:FireClient(Player, "Universal", "RemoveMovers", { })
						ReplicatorEvent:FireClient(Player, "Universal", "BodyMover", {
							Type = "BodyPosition", 
							MaxForce = Vector3.new(math.huge, math.huge, math.huge),
							Position = Vector3.new(Character.HumanoidRootPart.Position.X, Combat[Character].Y_axis, Character.HumanoidRootPart.Position.Z) + Character.HumanoidRootPart.CFrame.LookVector * 3.5,
							
							Duration = 1
						})
					else
						Shared_Functions.RemoveMovers(Character)
						Shared_Functions.BodyMover("BodyPosition",
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
						ReplicatorEvent:FireClient(Player, "Universal", "BodyMover", {
							Type = "BodyVelocity", 
							Velocity = Character.HumanoidRootPart.CFrame.LookVector * 5,
							MaxForce = Vector3.new(20000, 0, 20000),
							Duration = 0.15
						})
					else
						Shared_Functions.BodyMover("BodyVelocity",
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
			
			local Hitbox = HitboxModule.new(Character, Vector3.new(5,5,5), nil, nil, HitboxModule.DetectionTypes.OnceReturn, visualizer)
			local PunchMissed = true
			
			-- On hit connection
			Hitbox.OnHit:Connect(function(Entity)
				PunchMissed = false
				Combat[Character].Y_axis = Character.HumanoidRootPart.Position.Y + 20

					Damage_Module.Damage(Entity, Data)
					
			end)
			
			-- Stop anims
			Shared_Functions.StopAnims(Character)

			-- Play punch animation
			local PunchTrack = Character.Humanoid.Animator:LoadAnimation(PunchAnimation)
			PunchTrack.Priority = Enum.AnimationPriority.Action4
			
			local delayTime = PunchAnimation.Attack.Value
			
			PunchTrack:Play()
			
			
			task.delay(delayTime, function()
				Hitbox:HitStart(0.2)
				
				-- Uptilt
				if Combat[Character].Uptilt == true and CurrCombo == 4 then
					Combat[Character].Uptilt = false
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
