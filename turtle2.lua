fuelswap = false
inv = {{"minecraft:coal", 2, 4}, {"enderstorage:ender_chest", 16, 1}}

blacklist_blocks = {"minecraft:cobblestone",
"minecraft:dirt",
"minecraft:andesite",
"minecraft:granite",
"minecraft:gravel",
"minecraft:tuff",
"minecraft:deepslate",
"minecraft:diorite"}

function depositLoot () -- Deposit to Chest
    for i = 1, 2, 1 do
        turtle.turnLeft()
    end
    turtle.select(16)
    turtle.place()
    for i=3,#inv do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(1)
    turtle.drop()
    turtle.select(2)
    data = turtle.getItemDetail()
    turtle.select(1)
    turtle.dig()
    turtle.transferTo(16)
    inv = {{"minecraft:coal", 2, data.count}, {"enderstorage:ender_chest", 16, 1}}
    turtle.select(1)
    for i = 1, 2, 1 do
        turtle.turnLeft()
    end
end

function refuel () -- Refuel
    turtle.select(2)
    turtle.refuel()
end

function moveItem (item)
    local itemname = item.name
    for i = 3, #inv do
        for j = 1, #inv[i] do
            if inv[i][j] == itemname then
                turtle.transferTo(inv[i][2])
                inv[i][3] = inv[i][3] + 1
                if inv[i][3] >= 64 then
                    depositLoot()
                end
                return true
            end
        end
    end
    table.insert(inv, {itemname,#inv + 1, 1})
    turtle.transferTo(inv[#inv][2])
    if #inv == 16 then
        depositLoot()
    end
    return -1 
end

function search (block_list, item) -- Check if block is blacklisted
    local itemname = item.name
    for _, item in ipairs(block_list) do
        if item == itemname then
          return true
        end
    end
    return false
end

function turnRight () -- Turn Right
    turtle.turnRight()
    mine()
    turtle.turnRight()
end
      
function turnLeft () -- Turn Left
    turtle.turnLeft()
    mine()
    turtle.turnLeft()
end

function addFuel () -- Add Fuel to Fuel Slot
    turtle.transferTo(inv[1][2])
    inv[1][3] = inv[1][3] + 1
    if inv[1][3] >= 32 then
        refuel()
    end
end

function checkCoal(item) -- Checks if item is coal
    if item.name == "minecraft:coal" then
        return true
    else
        return false
    end
end


function invCheck() -- Check inventory after dig
    turtle.select(1)
    item = turtle.getItemDetail()
    if item ~= nil then
        if search(blacklist_blocks,item) then
            turtle.drop()
        else
            if checkCoal(item) and fuelswap then
                addFuel(item)
                fuelswap = false
            elseif checkCoal(item) and not fuelswap then
                fuelswap = true
                moveItem(item)
            else
                moveItem(item)
            end
        end
    else
        return false
    end
end

function dig() -- Move forward and Dig
    turtle.select(1)
    while not turtle.forward() do
        turtle.select(1)
        turtle.dig()
        invCheck()
    end
    turtle.select(1)
    turtle.digUp()
    invCheck()
    turtle.select(1)
    turtle.digDown()
    invCheck()
end

for x=1,20,1 do
    dig()
    print(x)
end