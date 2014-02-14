# adb pull /sdcard/capture.pcap .
# wireshark capture.pcap
adb forward tcp:11233 tcp:11233 && nc 127.0.0.1 11233 | wireshark -k -S -i -
