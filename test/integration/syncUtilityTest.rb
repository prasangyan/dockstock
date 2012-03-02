require "win32ole"
require "Win32API"

fileName = rand(1000000)
saveFile = 'C:\Users\Prashant\Documents\VersaVault\ ' + fileName.to_s + '.xlsx'
versavaultProcessName = "versavaultsynctool.exe"
application = WIN32OLE.new('Excel.Application')
application.visible = TRUE
workbook = application.Workbooks.Add()
worksheet = workbook.Worksheets(1)
worksheet.Range('A1:D1').value = ['North','South','East','West']
workbook.SaveAs saveFile
application.ActiveWorkbook.Close(0);
application.Quit();
puts "Successfully created a file"

# Checking to see if VersaVault is running otherwise starting it
# Assuming the executable is in C:
def get_process_info()
  processList = Array.new
  procs = WIN32OLE.connect("winmgmts:\\\\.")
  procs.InstancesOf("win32_process").each do |p|
     processList.push p
  end
  return processList
end

processList = Array.new
processList = get_process_info

isVersaVaultRunning = false
processList.each do |p|
  if p == versavaultProcessName
    isVersaVaultRunning = true
  end
end

if isVersaVaultRunning == false
  puts "Starting up the VersaVault client"
  system 'start "" "C:\Program Files (x86)\VersaVault\VersaVaultSyncTool.exe"'
end
