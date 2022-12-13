import sys
import re

package_pattern = r'(?P<package>(?:\w+::)*\w+)'

using = set()
for row, line in enumerate(open(sys.argv[1])):
    if line.startswith("package "):
        continue
    if line.startswith("use "):
        for name in re.findall('(?<=use )' + package_pattern, line):
            using.add(name)
    else:
        for usage in re.finditer(r'(?P<sigillum>(\$|->)?)' + package_pattern + '(?=->)', line):
            if usage.group('sigillum') != '':
                continue
            if usage.group('package') not in using:
                name = usage.group('package')
                col = usage.span()[0]
                print('use of unused package {} at ({}, {})'.format(name, row+1, col))
                print('> {}'.format(line))
                print("")
