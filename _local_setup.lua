if(os.getComputerID() == 0)
then
    os.setComputerLabel("Server01")
    periphemu.create("top", "modem", "dispatcher01")
    periphemu.create(1, "computer", "client01")
    periphemu.create(2, "computer", "client02")
    periphemu.create("left", "monitor", "monitor01")
elseif os.getComputerID() == 1
then
    os.setComputerLabel("Client01")
    periphemu.create("right", "modem", "reciever01")
elseif os.getComputerID() == 2
then
    os.setComputerLabel("Client02")
    periphemu.create("right", "modem", "reciever02")
end