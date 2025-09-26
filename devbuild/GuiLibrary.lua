local GuiLibrary = {
	API = {},
	Connections = {},
}

local RunService = game:GetService('RunService')
local HttpService = game:GetService('HttpService')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')

function GuiLibrary.Initialize()
	if shared.AutumnLoaded then
		return end;
	
	shared.AutumnLoaded = true;

	local Windows = {}
	
	local ScreenGui = Instance.new('ScreenGui')
	ScreenGui.Parent = game:GetService('CoreGui')
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ResetOnSpawn = false
	local ArrayFrame = Instance.new('Frame')
	ArrayFrame.Parent = ScreenGui
	ArrayFrame.Position = UDim2.fromScale(0.79, 0.2)
	ArrayFrame.Size = UDim2.fromScale(0.2, 0.7)
	ArrayFrame.BackgroundTransparency = 1
	local ArraySort = Instance.new('UIListLayout')
	ArraySort.Parent = ArrayFrame
	ArraySort.SortOrder = Enum.SortOrder.LayoutOrder

	local MobileButton = Instance.new('TextButton')
	MobileButton.Parent = ScreenGui
	MobileButton.Size = UDim2.fromOffset(40, 40)
	MobileButton.Position = UDim2.fromScale(0.85, 0.15)
	MobileButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MobileButton.BackgroundTransparency = 0.35
	MobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MobileButton.TextSize = 22
	MobileButton.Text = 'A'
	MobileButton.Font = Enum.Font.SourceSans
	MobileButton.Active = true
	MobileButton.Draggable = true
	local MobileCorner = Instance.new('UICorner')
	MobileCorner.Parent = MobileButton
	MobileCorner.CornerRadius = UDim.new(1, 0)

	MobileButton.Visible = (not UserInputService.KeyboardEnabled)

	table.insert(GuiLibrary.Connections, MobileButton.MouseButton1Down:Connect(function()
		for _, Window in GuiLibrary.API.GetWindows() do
			Window.Inst.Visible = not Window.Inst.Visible
		end
	end))
	
	GuiLibrary.ScreenGui = ScreenGui
	
	if not RunService:IsStudio() then
		if not isfolder('AutumnV3') then
			makefolder('AutumnV3')
			makefolder('AutumnV3/Games')
			makefolder('AutumnV3/Configs')
		end
	end
	
	local Config = {}
	local ConfigSys = {
		canSave = true,
		file = 'AutumnV3/Configs/'..game.PlaceId..'.json',
		saveConfig = function(self)
			if RunService:IsStudio() then
				return end;
			
			if not self.canSave then
				return end;
			
			if isfile(self.file) then
				delfile(self.file)
				task.wait(0.05)
			end
			writefile(self.file, HttpService:JSONEncode(Config))
		end,
		loadConfig = function(self)
			if RunService:IsStudio() then
				return end;
			
			if isfile(self.file) then
				Config = HttpService:JSONDecode(readfile(self.file))
			end
		end,
	}
	
	ConfigSys:loadConfig();
	task.wait(0.1)
	
	local Index = 0
	GuiLibrary.API.Uninject = function()
		ConfigSys.canSave = false
		
		for i,v in GuiLibrary.Connections do
			v:Disconnect();
		end
		
		for _, Window in Windows do
			for MName, MTable in Window.Modules do
				if MTable.Enabled then
					MTable:Toggle()
				end
			end
		end
		
		ScreenGui:Destroy()
		
		shared.AutumnLoaded = false
		shared.GuiLibrary = nil
		GuiLibrary = nil
	end
	GuiLibrary.API.GetWindow = function(Name: string)
		return Windows[Name]
	end
	GuiLibrary.API.GetWindows = function()
		return Windows
	end
	GuiLibrary.API.CreateWindow = function(Name: string)
		local WindowFrame = Instance.new('Frame')
		WindowFrame.Parent = ScreenGui
		WindowFrame.Position = UDim2.fromScale(0.1 + (Index / 8), 0.2)
		WindowFrame.Size = UDim2.new(0.12, 0, 0, 32)
		WindowFrame.BorderSizePixel = 0
		WindowFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		local WindowLabel = Instance.new('TextLabel')
		WindowLabel.Parent = WindowFrame
		WindowLabel.Size = UDim2.fromScale(1, 1)
		WindowLabel.Position = UDim2.fromScale(0.05, 0)
		WindowLabel.BackgroundTransparency = 1
		WindowLabel.TextXAlignment = Enum.TextXAlignment.Left
		WindowLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
		WindowLabel.TextSize = 11
		WindowLabel.Text = Name
		local ModuleFrame = Instance.new('Frame')
		ModuleFrame.Parent = WindowFrame
		ModuleFrame.Position = UDim2.fromScale(0, 1)
		ModuleFrame.Size = UDim2.fromScale(1, 0)
		ModuleFrame.AutomaticSize = Enum.AutomaticSize.Y
		ModuleFrame.BackgroundTransparency = 1
		local ModuleSort = Instance.new('UIListLayout')
		ModuleSort.Parent = ModuleFrame
		ModuleSort.SortOrder = Enum.SortOrder.LayoutOrder
		
		table.insert(GuiLibrary.Connections, UserInputService.InputBegan:Connect(function(Key, Gpe)
			if Gpe then
				return end;
			
			if Key.KeyCode == Enum.KeyCode.RightShift then
				WindowFrame.Visible = not WindowFrame.Visible
			end
		end))
		
		Index += 1
		
		Windows[Name] = {
			Inst = WindowFrame,
			Modules = {},
			CreateModule = function(self, Table)
				if not Config[Table.Name] then
					Config[Table.Name] = {
						Enabled = false,
						Keybind = 'Unknown',
						Toggles = {},
						Pickers = {},
					}
				end
				
				local ModuleButton = Instance.new('Frame')
				ModuleButton.Parent = ModuleFrame
				ModuleButton.Size = UDim2.new(1, 0, 0, 32)
				ModuleButton.BorderSizePixel = 0
				ModuleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				local ModuleText = Instance.new('TextButton')
				ModuleText.Parent = ModuleButton
				ModuleText.Position = UDim2.fromScale(0.05, 0)
				ModuleText.Size = UDim2.fromScale(1, 1)
				ModuleText.BackgroundTransparency = 1
				ModuleText.TextXAlignment = Enum.TextXAlignment.Left
				ModuleText.TextColor3 = Color3.fromRGB(255, 255, 255)
				ModuleText.TextSize = 11
				ModuleText.Text = Table['Name']
				local DropdownFrame = Instance.new('Frame')
				DropdownFrame.Parent = ModuleFrame
				DropdownFrame.Size = UDim2.fromScale(1, 0)
				DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
				DropdownFrame.BackgroundTransparency = 1
				DropdownFrame.Visible = not DropdownFrame.Visible
				local DropdownSort = Instance.new('UIListLayout')
				DropdownSort.Parent = DropdownFrame
				DropdownSort.SortOrder = Enum.SortOrder.LayoutOrder

				local KeybindFrame = Instance.new('Frame')
				KeybindFrame.Parent = DropdownFrame
				KeybindFrame.Size = UDim2.new(1, 0, 0, 32)
				KeybindFrame.BorderSizePixel = 0
				KeybindFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				local KeybindText = Instance.new('TextButton')
				KeybindText.Parent = KeybindFrame
				KeybindText.Position = UDim2.fromScale(0.05, 0)
				KeybindText.Size = UDim2.fromScale(1, 1)
				KeybindText.BackgroundTransparency = 1
				KeybindText.TextXAlignment = Enum.TextXAlignment.Left
				KeybindText.TextColor3 = Color3.fromRGB(255, 255, 255)
				KeybindText.TextSize = 10
				KeybindText.Text = 'Keybind'
				local BindChosenText = Instance.new('TextLabel')
				BindChosenText.Parent = KeybindFrame
				BindChosenText.Position = UDim2.fromScale(0.05, 0)
				BindChosenText.Size = UDim2.fromScale(0.9, 1)
				BindChosenText.BackgroundTransparency = 1
				BindChosenText.TextXAlignment = Enum.TextXAlignment.Right
				BindChosenText.TextColor3 = Color3.fromRGB(150, 150, 150)
				BindChosenText.TextSize = 10
				BindChosenText.Text = Config[Table.Name].Keybind

				table.insert(GuiLibrary.Connections, KeybindText.MouseButton1Click:Connect(function()
					local conn
					conn = UserInputService.InputBegan:Connect(function(Key, Gpe)
						task.wait(0.01)
						if not Gpe and Key.KeyCode ~= Enum.KeyCode.Unknown then
							Config[Table.Name].Keybind = tostring(Key.KeyCode):gsub('Enum.KeyCode.', '')
							BindChosenText.Text = Config[Table.Name].Keybind
							conn:Disconnect()
						end
					end)
				end))

				local ModuleReturn = {
					Enabled = false,
					Toggle = function(self)
						self.Enabled = not self.Enabled
						Config[Table.Name].Enabled = self.Enabled
						TweenService:Create(ModuleText, TweenInfo.new(0.1), {TextColor3 = self.Enabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(255, 255, 255)}):Play()
						
						if Table['Function'] then
							task.spawn(Table['Function'], self.Enabled)
						end
						
						if not self.Enabled then
							self:End();
						end
						
						ConfigSys:saveConfig();
					end,
				}
				
				function ModuleReturn.CreateToggle(Tab)
					if not Config[Table.Name].Toggles[Tab.Name] then
						Config[Table.Name].Toggles[Tab.Name] = {Enabled = false}
					end
					
					local ToggleFrame = Instance.new('Frame')
					ToggleFrame.Parent = DropdownFrame
					ToggleFrame.Size = UDim2.new(1, 0, 0, 32)
					ToggleFrame.BorderSizePixel = 0
					ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
					local ToggleText = Instance.new('TextButton')
					ToggleText.Parent = ToggleFrame
					ToggleText.Position = UDim2.fromScale(0.05, 0)
					ToggleText.Size = UDim2.fromScale(1, 1)
					ToggleText.BackgroundTransparency = 1
					ToggleText.TextXAlignment = Enum.TextXAlignment.Left
					ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
					ToggleText.TextSize = 10
					ToggleText.Text = Tab['Name']
					
					local ToggleReturn = {
						Enabled = false,
						Inst = ToggleFrame,
						Toggle = function(self)
							self.Enabled = not self.Enabled
							Config[Table.Name].Toggles[Tab.Name].Enabled = self.Enabled
							TweenService:Create(ToggleText, TweenInfo.new(0.1), {TextColor3 = self.Enabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(255, 255, 255)}):Play()
							
							if Tab['Function'] then
								task.spawn(Tab['Function'], self.Enabled)
							end
							
							ConfigSys:saveConfig();
						end,
					}
					
					table.insert(GuiLibrary.Connections, ToggleText.MouseButton1Down:Connect(function()
						ToggleReturn:Toggle();
					end))
					
					if Config[Table.Name].Toggles[Tab.Name].Enabled then
						task.delay(0.1, function()
							ToggleReturn:Toggle();
						end)
					end
					
					return ToggleReturn
				end
				
				function ModuleReturn.CreatePicker(Tab)
					if not Config[Table.Name].Pickers[Tab.Name] then
						Config[Table.Name].Pickers[Tab.Name] = {Value = Tab['Default'] or Tab['Options'][1]}
					end
					
					local PickerFrame = Instance.new('Frame')
					PickerFrame.Parent = DropdownFrame
					PickerFrame.Size = UDim2.new(1, 0, 0, 32)
					PickerFrame.BorderSizePixel = 0
					PickerFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
					local PickerText = Instance.new('TextButton')
					PickerText.Parent = PickerFrame
					PickerText.Position = UDim2.fromScale(0.05, 0)
					PickerText.Size = UDim2.fromScale(1, 1)
					PickerText.BackgroundTransparency = 1
					PickerText.TextXAlignment = Enum.TextXAlignment.Left
					PickerText.TextColor3 = Color3.fromRGB(255, 255, 255)
					PickerText.TextSize = 10
					PickerText.Text = Tab['Name']
					local OptionText = Instance.new('TextLabel')
					OptionText.Parent = PickerFrame
					OptionText.Position = UDim2.fromScale(0.05, 0)
					OptionText.Size = UDim2.fromScale(0.9, 1)
					OptionText.BackgroundTransparency = 1
					OptionText.TextXAlignment = Enum.TextXAlignment.Right
					OptionText.TextColor3 = Color3.fromRGB(150, 150, 150)
					OptionText.TextSize = 10
					OptionText.Text = Config[Table.Name].Pickers[Tab.Name].Value
					
					local Index = 1
					local PickerReturn = {
						Value = Config[Table.Name].Pickers[Tab.Name].Value,
						Inst = PickerFrame,
						Set = function(self, ind)
							Index = ind
							
							self.Value = Tab['Options'][Index]
							OptionText.Text = Tab['Options'][Index]
							Config[Table.Name].Pickers[Tab.Name].Value = Tab['Options'][Index]
							
							ConfigSys:saveConfig();
						end,
					}
					
					for i,v in Tab['Options'] do
						if PickerReturn.Value == v then
							Index = i
						end
					end
					
					table.insert(GuiLibrary.Connections, PickerText.MouseButton1Down:Connect(function()
						Index += 1

						if Index > #Tab['Options'] then
							Index = 1
						end

						PickerReturn:Set(Index)
					end))
					table.insert(GuiLibrary.Connections, PickerText.MouseButton2Down:Connect(function()
						Index -= 1

						if Index < 1 then
							Index = #Tab['Options']
						end

						PickerReturn:Set(Index)
					end))
					
					return PickerReturn
				end
				
				local Connections = {}
				function ModuleReturn:Start(func)
					table.insert(Connections, RunService.Heartbeat:Connect(func))
				end
				function ModuleReturn:End(func)
					for i,v in Connections do
						v:Disconnect()
					end
					
					if func then
						task.spawn(func)
					end
				end

				table.insert(GuiLibrary.Connections, ModuleText.MouseButton1Down:Connect(function()
					ModuleReturn:Toggle();
				end))
				table.insert(GuiLibrary.Connections, ModuleText.MouseButton2Down:Connect(function()
					DropdownFrame.Visible = not DropdownFrame.Visible
				end))

				table.insert(GuiLibrary.Connections, UserInputService.InputBegan:Connect(function(Key, Gpe)
					if not Gpe and Key.KeyCode ~= Enum.KeyCode.Unknown and Key.KeyCode == Enum.KeyCode[Config[Table.Name].Keybind] then
						ModuleReturn:Toggle();
					end
				end))
				
				if Config[Table.Name].Enabled then
					task.delay(0.1, function()
						ModuleReturn:Toggle();
					end)
				end
				
				self.Modules[Table.Name] = ModuleReturn

				return ModuleReturn
			end,
		}
		
		return Windows[Name]
	end

	table.freeze(GuiLibrary)
end

shared.GuiLibrary = GuiLibrary

return GuiLibrary
