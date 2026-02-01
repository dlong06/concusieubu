-- Fast Attack cho M1 Fruit
getgenv().FastAttackDelay = 0.08  -- tốc đánh, chỉnh 0.05–0.1

spawn(function()
    while task.wait(getgenv().FastAttackDelay) do
        pcall(function()
            local args = {
                [1] = "Attack",
                [2] = game.Players.LocalPlayer.Character
            }
            -- Thay đúng remote M1 fruit ở đây
            game:GetService("ReplicatedStorage").Remotes.FruitRemote:FireServer(unpack(args))
        end)
    end
end)
