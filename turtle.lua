fuelswap = false
inv = {{"minecraft:coal", 2, 0}}

blacklist_blocks = {
      "minecraft:cobblestone",
      "minecraft:dirt",
      "minecraft:andesite",
      "minecraft:granite",
      "minecraft:gravel",
      "minecraft:tuff",
      "minecraft:deepslate",
      "minecraft:diorite"
      }
      
function moveItem (item)
    local itemname = item.name
    for i = 3, #inv do
        print(inv[i][1])
        for j = 1, #inv[i] do
            if inv[i][j] == itemname then
                turtle.transferTo(inv[i][2])
                inv[i][3] = inv[i][3] + 1
                return true
            end
        end
    end
    table.insert(inv, {itemname,#inv + 1, 1})
    turtle.transferTo(inv[#inv][2])
    return -1 
end
      
function addFuel ()
    turtle.transferTo(inv[1][2])
    inv[1][3] = inv[1][3] + 1
end

function search (block_list, item)
    local itemname = item.name
    for _, item in ipairs(block_list) do
        if item == itemname then
          return true
        end
    end
    return false
end
    
function mine ()
    if turtle.detect() then
        turtle.dig()
        turtle.forward(1)
        turtle.select(1)
        if search(blacklist_blocks, turtle.getItemDetail()) then
            turtle.drop()
        end
        turtle.select(1)
        if turtle.getItemDetail() != nil then
            item = turtle.getItemDetail()
            if item.name == "minecraft:coal" then
                if fuelswap == true then
                    addFuel(item)
                    fuelswap = false
                else
                    fuelswap = true
                    moveItem(item)
                end
                moveItem(item)
            end
            
        end
    else
        turtle.forward(1)
    end
end
