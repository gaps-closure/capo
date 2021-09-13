#!/usr/bin/python3

import os

if __name__ == '__main__':
    os.system("./conflictAnalyzer.sh test/example1.c > /dev/null 2> /dev/null")
    with open('result.txt') as rf:
        data = rf.readlines()
        correctStr = "Enclave Assingment: [E_purple, E_purple, E_purple, E_purple, E_purple, E_orange, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_orange, E_orange, E_orange, E_orange, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_orange, E_purple, E_purple, E_orange, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, nullEnclave]"
        if correctStr in data[0]:
            print("Pass")
    
    os.system("./conflictAnalyzer.sh test/example2.c > /dev/null 2> /dev/null")
    with open('result.txt') as rf:
        data = rf.readlines()
        correctStr = "[E_purple, E_purple, E_orange, E_orange, E_orange, E_orange, E_purple, E_purple, E_purple, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_purple, E_purple, E_purple, E_purple, E_purple, E_orange, E_orange, E_orange, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, nullEnclave, E_purple, E_purple, E_orange, E_purple, E_orange, nullEnclave]"
        if correctStr in data[0]:
            print("Pass")

    os.system("./conflictAnalyzer.sh test/example3.c > /dev/null 2> /dev/null")
    with open('result.txt') as rf:
        data = rf.readlines()
        correctStr = "[E_orange, E_orange, E_orange, E_purple, E_purple, E_purple, E_orange, E_orange, E_purple, E_orange, E_orange, E_purple, E_purple, E_purple, E_purple, E_purple, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, E_purple, E_purple, E_purple, E_purple, E_purple, E_purple, E_orange, E_orange, E_orange, E_orange, E_orange, E_purple, E_orange, E_orange, E_purple, E_orange, E_orange, E_purple, E_purple, E_purple, E_orange, E_orange, E_purple, E_purple, E_purple, E_orange, E_orange, E_orange, E_orange, E_orange, E_orange, nullEnclave]"
        if correctStr in data[0]:
            print("Pass")
