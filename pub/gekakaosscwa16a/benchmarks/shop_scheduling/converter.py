#!/usr/bin/env python
     
import argparse
import os

def convert(filename,out,mode):
    f=open(filename, 'r')        
    name, fileext = os.path.splitext(os.path.basename(filename))
    id=1
    first=True
    start=False
    start_times=False
    start_machines=False
    for line in f:
        if line.strip() == "":
            continue
        if mode == "flow":
            if line.startswith("processing times"): 
                inst=open(os.path.join(out,name+"_"+str(id)+".lp"),"w")    
                start=True
                machine=1
                if first:
                    first=False
            elif line.startswith("number of jobs") and not first:
                inst.close()
                id+=1
                start=False
            elif start:
                times=[int(x.replace(" ","")) for x in line[:-1].split(" ") if x.replace(" ","")!=""]
                task=1
                for time in times:
                    inst.write("executionTime("+str(task)+","+str(machine)+","+str(time)+").\n")    
                    task+=1
                machine+=1   
        if mode == "job":
            if line.startswith("Times"): 
                inst=open(os.path.join(out,name+"_"+str(id)+".lp"),"w")    
                start_times=True
                task=1
                if first:
                    first=False       
            elif line.startswith("Machines"):   
                start_times=False
                start_machines=True
                task=1
            elif line.startswith("Nb of jobs") and not first:
                inst.close()
                id+=1
                start_times=False
                start_machines=False
            elif start_times:
                times=[int(x.replace(" ","")) for x in line[:-1].split(" ") if x.replace(" ","")!=""]
                machine=1
                for time in times:
                    inst.write("executionTime("+str(task)+","+str(machine)+","+str(time)+").\n")    
                    machine+=1
                task+=1      
            elif start_machines:
                seqs=[int(x.replace(" ","")) for x in line[:-1].split(" ") if x.replace(" ","")!=""]
                machine=1
                for seq in seqs:
                    inst.write("sequence("+str(task)+","+str(machine)+","+str(seq)+").\n")    
                    machine+=1
                task+=1         
        if mode == "open":
            if line.startswith("processing times"): 
                inst=open(os.path.join(out,name+"_"+str(id)+".lp"),"w")    
                start_times=True
                task=1
                if first:
                    first=False       
            elif line.startswith("machines "):   
                start_times=False
                start_machines=True
                task=1
            elif line.startswith("number of jobs") and not first:
                inst.close()
                id+=1
                start_times=False
                start_machines=False
            elif start_times:
                times=[int(x.replace(" ","")) for x in line[:-1].split(" ") if x.replace(" ","")!=""]
                operation=1
                for time in times:
                    inst.write("executionTime("+str(task)+","+str(operation)+","+str(time)+").\n")    
                    operation+=1
                task+=1      
            elif start_machines:
                assignments=[int(x.replace(" ","")) for x in line[:-1].split(" ") if x.replace(" ","")!=""]
                operation=1
                for assign in assignments:
                    inst.write("assign("+str(task)+","+str(operation)+","+str(assign)+").\n")    
                    operation+=1
                task+=1
    inst.close()
                

if __name__ == '__main__':
    
    parser = argparse.ArgumentParser(description='Convert scheduling instances.')        
    parser.add_argument('--mode', dest="mode", default="flow", choices=["flow","job","open"], help='Instance type')     
    parser.add_argument('--out', dest="out", default="./asp", help='Output directory')
    parser.add_argument('folders', metavar='N', nargs='+', help='List of folders with instances')

    args = parser.parse_args()
    folders = args.folders       
    mode = args.mode
    out = args.out
    
    if not os.path.isdir(out):
        os.makedirs(out)
    
    for folder in folders:
        if os.path.isdir(folder):
            for subdir, dirs, files in os.walk(folder):
                for f in files:
                    filename, fileext = os.path.splitext(os.path.basename(f))
                    if fileext == '.txt':
                        convert(os.path.join(subdir,f),out,mode)
        else:
            filename, fileext = os.path.splitext(os.path.basename(folder))
            if fileext == '.txt':
                convert(folder,out,mode)
            