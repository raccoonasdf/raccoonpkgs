#!/usr/bin/env python3

# this code is terribad yw

from configparser import ConfigParser
import json
import os
from subprocess import run, Popen
import sys
import xdg

def main():
    cache = f'{xdg.xdg_cache_home()}/raccoon-entries'

    excludes = ['exo-open', 'steam://', '/usr/bin/wine', '/opt/google/chrome/google-chrome']

    def refresh_cache():
        dirs = xdg.xdg_data_dirs() + [xdg.xdg_data_home()]
        dirs = [dir/'applications' for dir in dirs]

        def walk(path):
            try:
                return next(os.walk(path))[2]
            except StopIteration:
                return []

        files = [ [ f'{path}/{f}'
                    for f
                    in walk(path)
                    if f.endswith('.desktop')
                  ]
                  for path
                  in dirs
                ]

        files = [f for dir in files for f in dir]

        entries = {}
        for f in files:
            parser = ConfigParser(strict=False, interpolation=None)
            parser.read(f)
            try:
                entry = parser['Desktop Entry']
            except KeyError:
                continue
            if entry.get('Type') == 'Application' and entry.get('Name') and entry.get('Exec'):
                cmd = entry['Exec']
                while True:
                    n = cmd.find('%')
                    if n == -1:
                        break
                    cmd = cmd[:n] + cmd[n+2:]
                cmd = ' '.join(cmd.split())
                if all(exclude not in cmd for exclude in excludes):
                    entries[f'{entry["Name"]} ({cmd})'] = cmd

        with open(cache, 'w') as f:
            json.dump(entries, f)

    def entries():
        while True:
            try:
                with open(cache) as f:
                    return json.load(f)
            except FileNotFoundError:
                refresh_cache()

    preferred_entries = {}
    try:
        with open(xdg.xdg_config_home()/'raccoon-dmenu-desktop/preferred.list') as f:
            for line in f.readlines():
                l = line.split('=')
                try:
                    preferred_entries[l[0]] = l[1].rstrip()
                except IndexError:
                    print(f'bad preferred.list entry: {line}')
    except FileNotFoundError:
        print('no preferred.list')

    def preferred(k):
        for j in preferred_entries.keys():
            if k.startswith(j):
                k = preferred_entries[j]+' '+k
                print(k)
        return k.lower()

    dmenu = sys.argv
    dmenu[0] = 'dmenu'

    entries = entries()

    out = run(dmenu, input='\n'.join(sorted(entries.keys(), key=preferred)), capture_output=True, text=True).stdout

    try:
        cmd = entries[out.rstrip()]
    except KeyError:
        sys.exit(1)

    Popen(cmd, shell=True)

if __name__ == '__main__':
    main()
