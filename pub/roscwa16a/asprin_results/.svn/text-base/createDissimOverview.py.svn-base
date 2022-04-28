#!/usr/bin/env python

import os
import re
import sys
import codecs
import numpy as np
from scipy.sparse import lil_matrix
import argparse
import csv
from ezodf import *
from operator import itemgetter


def createRankingITC(configs):
    result=[]
    nr_configs=len(configs)
    
    if nr_configs != 0:
        nr_instances=len(configs[configs.keys()[0]])
        
    config_map={}
    instance_map={}
    instance_map_reverse={}
    vals=np.zeros((nr_configs, nr_instances))
    
    n,i=0,0
    for config in configs:
        config_map[n]=config
        for inst in configs[config]:
            if inst in instance_map_reverse.keys():
                index=instance_map_reverse[inst]
            else:
                instance_map[i]=inst
                instance_map_reverse[inst]=i
                index=i
                i+=1
            vals[n,index]=configs[config][inst]
        n+=1
     
    completed=0    
    for n in range(0,nr_configs):
        mean=0.0
        instance_rank={}
        for i in range(0,nr_instances):
            val=vals[n,i]
            instance_vals=vals[:,i]
            instance_vals=np.delete(instance_vals,n)
            better=instance_vals[instance_vals<val].size
            same=instance_vals[instance_vals==val].size
            rank=((nr_configs-better) + (nr_configs-better-same))/2.0
            instance_rank[instance_map[i]]=rank
            mean+=rank
        result.append((config_map[n],mean/nr_instances,dict(instance_rank)))
        completed+=1
        print "Rankings completed (ITC): "+str(completed)+"/"+str(nr_configs)
            
    result.sort(key=itemgetter(1))
    return result
    
def createRankingTimeless(configs):
    print configs.keys()
    result=[]
    nr_configs=len(configs)
    
    if nr_configs != 0:
        nr_instances=len(configs[configs.keys()[0]])
        
    config_map={}
    instance_map={}
    instance_map_reverse={}
    vals=np.zeros((nr_configs, nr_instances))
    
    n,i=0,0
    for config in configs:
        config_map[n]=config
        for inst in configs[config]:
            if inst in instance_map_reverse.keys():
                index=instance_map_reverse[inst]
            else:
                instance_map[i]=inst
                instance_map_reverse[inst]=i
                index=i
                i+=1
            vals[n,index]=configs[config][inst]
        n+=1
     
    pairs=[]
    for n in range(0,nr_configs):
        for m in range(n+1,nr_configs):
            pairs.append((n,m))
     
    score={} 
    completed=0    
    for pair in pairs:
        better=0
        for i in range(0,nr_instances):
            val1=vals[pair[0],i]
            val2=vals[pair[1],i]
            if val1 + val2 == -float('Inf'):
                continue
            if val1>val2:
                better+=1
            elif val1<val2:
                better-=1
        if better>0:
            score.setdefault(config_map[pair[0]],0)
            score.setdefault(config_map[pair[1]],0)
            score[config_map[pair[0]]]+=1
        elif better<0:
            score.setdefault(config_map[pair[1]],0)
            score.setdefault(config_map[pair[0]],0)
            score[config_map[pair[1]]]+=1
        completed+=1
        print "Rankings pairs completed (javier): "+str(completed)+"/"+str(len(pairs))
        
    for config in score:
        result.append((config,score[config],{}))
            
    result.sort(key=itemgetter(1),reverse=True)
    return result

if __name__ == '__main__':
    
    parser = argparse.ArgumentParser(description='Create overview table for similarity.')
    parser.add_argument('--results', dest='results', help='Ods file with new results.') 
    parser.add_argument('--out', dest='out', default='./result.ods', help='Output ods file.')     
    parser.add_argument('--mode', dest='mode', default='timeless', help='Mode of ranking.')            
    
    args = parser.parse_args()
    out=args.out
    mode=args.mode
    
    resdoc=opendoc(args.results)
    sheet=resdoc.sheets[0]
    
    configs=[]
    n=1
    for cell in sheet.row(0)[2:]:
        n+=1
        if str(cell.value) != "" and cell.value != None:
            configs.append((str(cell.value),n))    
    
    count_of_rows = sheet.nrows()      
    res_dict={}
    instance_names=[]
    for n in range(1,count_of_rows):
        row=sheet.row(n)
        instance=str(row[0].value)+"_"+str(row[1].value)
        if instance == "_" or row[0].value==None or row[1].value==None:
            break
        
        instance_names.append(instance)
            
        for config in configs:
            val=row[config[1]].value
            if val == '' or val==None:
                val=-float('Inf')   
            if config[0] not in res_dict:
                res_dict[config[0]]={}
            res_dict.setdefault(config[0],{})[instance]=val
        
    doc = newdoc(doctype='ods', filename=out)
    doc.sheets += Sheet('Ranking')
    
    ranking = doc.sheets[0]
    
    if mode == "timeless":
        result=createRankingTimeless(res_dict)
    else:
        result=createRankingITC(res_dict)
    
        
    ranking[(0,0)].set_value("Configurations")
    ranking[(0,1)].set_value("Mean ranking")
    instance_pos={}
    instance_names.sort()
    for i in range(0,len(instance_names)):
        ranking.append_columns(1)      
        ranking[(0,i+2)].set_value(instance_names[i])
        instance_pos[instance_names[i]]=i+2
    
    print result
    row=1    
    for conf in result:
        ranking.append_rows(1)      
        name=str(conf[0])
        rank=conf[1]
        instance_rank=conf[2]
        ranking[(row,0)].set_value(name)
        ranking[(row,1)].set_value(rank)
        for inst in instance_rank:
            pos=instance_pos[inst]
            inst_rank=instance_rank[inst]
            ranking[(row,pos)].set_value(inst_rank)
        row+=1
    
    doc.save()                        


