import re

def max(a,b):
    if a >= b: return a 
    else: return b;
def min(a,b):
    if a <= b: return a 
    else: return b;
with open("quality.txt") as f:
    content = f.readlines()
# you may also want to remove whitespace characters like `\n` at the end of each line
content = [x.strip() for x in content] 
i=0
string = ''
maxEntropy = 0
minEpsilon=1000
lnumber=0
for line in content:
    if i == 0:
        lnumber += 1
        m=re.search('^[^a-zA-Z]*',line)
        #string = ((m.group(0)) + '&').replace("_","\\_")
        applications = line[0]
        series=0
        curIndex=0
        for k in range(int(applications)):
            before = line.find('_', curIndex) + 1
            after = line.find('_', before)
            series += int(line[before:after])
            curIndex = before
        parallel=0
        for k in range(int(applications)):
            before = line.find('_', curIndex) + 1
            after = line.find('_', before)
            parallel += int(line[before:after])
            curIndex = before
        if (lnumber % 2) == 0:
            string = "\\rowcolor{HRO1!50}[6pt][7pt]"
        else:
            string = "\\rowcolor{HRO1!25}[6pt][7pt]"
        string += applications + "&" + str(series) + "&" + str(parallel) + "& $3\\times 3\\times 1$&"
        maxEntropy = 0
        minEpsilon=1000
    first = line.find('=')
    second = line.find('=',first+1)
    comma = line.find(',')
    
    try:
        entropyF=float(line[first+1:comma])
        maxEntropy=max(maxEntropy, entropyF)
        entropy="{0:.3f}".format(round(entropyF,3))
    except:
        entropy=line[first+1:comma]
        
    try:
        epsilonF=float(line[second+1:])
        minEpsilon=min(minEpsilon,epsilonF)
        epsilon="{0:.3f}".format(round(epsilonF,3))
    except:
        epsilon=line[second+1:]    
    
    string += '\\quality{'+entropy+'}{'+epsilon+'}'
    
    i = (i+1)%9
    if i == 0:
        maxEntropyS="{0:.3f}".format(round(maxEntropy,3))
        minEpsilonS="{0:.3f}".format(round(minEpsilon,3))
        string += '\\\\'
        string = string.replace(maxEntropyS, "\\textbf{"+maxEntropyS+"}")
        string = string.replace(minEpsilonS, "\\textbf{"+minEpsilonS+"}")
        print string
    else:
        string += '&'
    