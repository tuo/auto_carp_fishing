---- Create new software UART with baudrate of 9600, D2 as Tx pin and D3 as Rx pin


function writeCMD(s, cmd)
    print("\n"..tostring(tmr.now())..": send cmd", cmd);    
    s:write(cmd.."\n");   
end

if not s then 
    print("\n"..tostring(tmr.now())..": initilized su\n");
    s = softuart.setup(9600, 2, 3)
    -- Set callback to run when 10 characters show up in the buffer
    s:on("data", "\n", function(data)
      local txt = string.gsub(data, "[\r\n]", "")
      print("\n"..tostring(tmr.now())..": receive from uart:", txt)
      local pattern = "^HTTPACTION"
      if txt:find(pattern) ~= nil then
          print("\n"..tostring(tmr.now())..": RECIEVED HTTP ACTION DONE:", txt)
--          tmr.delay(20 * 1000)
--          writeCMD(s, 'AT+HTTPTERM')
--          tmr.delay(20 * 1000)          
--          writeCMD(s, 'AT+SAPBR=0,1')
--          tmr.delay(20 * 1000)
          
      end
   
    end)
else
  print("\n"..tostring(tmr.now())..": existed su\n");  
end
 
if not configed then
    configed = true
 
end



writeCMD(s, 'AT+SAPBR=3,1,"Contype","GPRS"')
tmr.delay(20 * 1000)
writeCMD(s, 'AT+SAPBR=3,1,"APN","CMNET"')
tmr.delay(20 * 1000)
writeCMD(s, 'AT+SAPBR=1,1')
tmr.delay(20 * 1000)
writeCMD(s, 'AT+SAPBR=2,1')
tmr.delay(20 * 1000)
    
writeCMD(s, 'AT+HTTPINIT')
tmr.delay(20 * 1000)

writeCMD(s, 'AT+HTTPPARA="CID",1')
tmr.delay(20 * 1000)

local url = "nfs.staging.6edigital.com/api/dashboard?tuotime="..tostring(tmr.now())
--url = "jsonplaceholder.typicode.com/todos/1"
writeCMD(s, 'AT+HTTPPARA="URL","'..url..'"')
tmr.delay(20 * 1000)
writeCMD(s, 'AT+HTTPACTION=0')
tmr.delay(20 * 1000)
s:write(0x1a);  

tmr.delay(20000 * 1000)
print("---------------call");
writeCMD(s, 'ATD18621325227;')

--tmr.delay(50 * 1000)
--writeCMD(s, 'AT+HTTPTERM')
--tmr.delay(50 * 1000)          
--writeCMD(s, 'AT+SAPBR=0,1')
--tmr.delay(50 * 1000)




