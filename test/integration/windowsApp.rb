require "Win32API"
require "timeout"


def user32(name, param_types, return_value)
  Win32API.new 'user32', name, param_types, return_value
end

find_window = user32 'FindWindow', ['P','P'], 'L'

system 'start "" "C:\Users\Prashant\Downloads\locknote-1.0.5-src+binary-win32\LockNote 1.0.5\LockNote.exe"'

sleep 0.2 while ( main_window = find_window.call nil, 'LockNote - Steganos LockNote' ) <= 0

puts "The window handle is: #{main_window}"

keybd_event = user32 'keybd_event' , ['I' , 'I' , 'L' , 'L' ], 'V'

KEYEVENTF_KEYDOWN = 0
KEYEVENTF_KEYUP = 2

# Code to write text in the window
"this is some text".upcase.each_byte do |b|
keybd_event.call b, 0, KEYEVENTF_KEYDOWN, 0
sleep 0.05
keybd_event.call b, 0, KEYEVENTF_KEYUP, 0
sleep 0.05
end

# Code to close the window
post_message = user32 'PostMessage' , ['L' , 'L' , 'L' , 'L' ], 'L'
WM_SYSCOMMAND = 0x0112
SC_CLOSE = 0xF060
post_message.call main_window, WM_SYSCOMMAND, SC_CLOSE, 0

# Overriding the save dialog box
get_dlg_item = user32 'GetDlgItem' , ['L' , 'L' ], 'L'
dialog = timeout(3) do
sleep 0.2 while (h = find_window.call nil, 'Steganos LockNote' ) <= 0; h
end
IDNO = 7
button = get_dlg_item.call dialog, IDNO

get_window_rect = user32 'GetWindowRect' , ['L' , 'P' ], 'I'
rectangle = [0, 0, 0, 0].pack 'L*'
get_window_rect.call button, rectangle
left, top, right, bottom = rectangle.unpack 'L*'
puts "The No button is #{right - left} pixels wide."