#adb shell tcpdump -i any -p -s 0 -w /sdcard/capture.pcap
# "-i any": listen on any network interface
# "-p": disable promiscuous mode (doesn't work anyway)
# "-s 0": capture the entire packet
# "-w": write packets to a file (rather than printing to stdout)
adb shell "tcpdump -i any -n -s 0 -w - | netcat -l -p 11233"
