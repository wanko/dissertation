"""
Converts an instance given as a set of excel tables
into a set of asp facts.

Input: Excel xlsx file

Output: Logic program instance file
"""

import argparse
import sys
import os
import ezodf
import re

def main():
    parser = argparse.ArgumentParser(
        description="Converts an input table to facts"
    )
    parser.add_argument('--output', '-o', metavar='<file>',
                   help='Write output into %(metavar)s', required=True)
    parser.add_argument('--input',  '-i', metavar='<input>', required=True,
                   help='Read from %(metavar)s (default: <stdin>)')

    args = parser.parse_args()
    wb = ezodf.opendoc(args.input)
    sheet = wb.sheets[0]
    offsets = {}
    values = {}
    conf_heurs = []
    prop_heurs = []
    temp = re.compile("clingo-5-seq/fluto-(.*)-c(.*)p(.*)h([01])-n1")
    o = 0
    for cell in sheet.column(0):
        offsets[cell.value] = o
        o += 1
    o = 0
    for cell in sheet.row(1):
        if cell.value == None or str(cell.value) == "":
            continue
        if str(cell.value) in offsets and str(cell.value) != "":
            break
        offsets[cell.value] = o
        o += 1
    o = 0
    
    for cell in sheet.row(0):
        m = temp.match(str(cell.value))
        if m:
            offsets[(m.group(1),m.group(4))] = o
            if int(m.group(2)) not in conf_heurs:
                conf_heurs.append(int(m.group(2)))
            if int(m.group(3)) not in prop_heurs:
                prop_heurs.append(int(m.group(3)))
            values.setdefault((m.group(1),m.group(4)),{}).setdefault(int(m.group(2)),{}).setdefault(int(m.group(3)),{})
            values[(m.group(1),m.group(4))][int(m.group(2))][int(m.group(3))]['time'] = round(float(sheet[offsets['AVG'],offsets[(m.group(1),m.group(4))]+offsets['time']].value),2)
            values[(m.group(1),m.group(4))][int(m.group(2))][int(m.group(3))]['timeout'] = int(sheet[offsets['SUM'],offsets[(m.group(1),m.group(4))]+offsets['timeout']].value)
        o += 1
    
    
    
    conf_heurs.sort()
    prop_heurs.sort()
    for value in values.keys():
        with open(os.path.join(args.output,'opt{}_heur{}.tex'.format(str(value[0]),str(value[1]))),'w') as f:
            header = "\\backslashbox{\\core{}}{\\prop{}} & "
            header += " & ".join([str(i) for i in prop_heurs]) + "\\\\\\hline\n"
            f.write(header)
            for ch in conf_heurs:
                f.write(str(ch))
                for ph in prop_heurs:
                    f.write(' & \\shade{{{}}}{{600}}({})'.format(values[value][ch][ph]['time'],values[value][ch][ph]['timeout']))
                f.write("\\\\\n")

if __name__ == '__main__':
    sys.exit(main())
