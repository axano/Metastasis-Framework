# Metastasis Framework

[582cb8a8c3618835758b4583(1).png](https://postimg.org/image/6kewsydkj/)

Metastasis Framework assists you in generating FUD trojan horses.

## The first Method generates C-Style Shellcode,injects it into memory and executes it using Python,the meterpreter session is handled through an https like connection.

 - It generates a SSL Certificate to handle the Meterpreter Session between the victim and the attacker,many Antivirus Companies still haven't utilised SSL interception/termination,so it aids on bypassing antivirus software.
 - Then it generates C-style shellcode using Metasploit-Framework's msfvenom.It will be XOR encoded multiple times using Metasploit's preincluded xor encoders.
 - It uses a python script that after it will be executed it will inject the C-style shellcode into memory.
 - After it uses PyInstaller in Wine to make the .py an executable (.exe) it will setup a listener on msfconsole,so when our victim executes our Trojan Horse it will handle our meterpreter session.
