#! /usr/bin/env python

import os
import time
import random
import argparse

if __name__ == '__main__':
    files = []

    parser = argparse.ArgumentParser(description='Path to the image directory')
    parser.add_argument('path', help='Path to the images directory')
    parser.add_argument('time', help='The time between two wallpapers')
    args = parser.parse_args()
    
    path = args.path
    
    for dirpath, dirs, imgfiles in os.walk(path, followlinks=True):
        for f in imgfiles:
            if f[-3:].lower() in ('jpg','png','gif','jpeg'):
                files.append(os.path.join(dirpath,f))

    while True:
        choice = random.randint(0, len(files) - 1)
        os.system('gconftool-2 --set /desktop/gnome/background/picture_filename --type string "%s"' % files[choice])
        print 'choosed file: %s' % files[choice]
        time.sleep(int(args.time))
    

