#Purpose: Python scripts to generate the testbench for network.v to connect all the nodes and switches in the 3D torus
#Author: Jiayi Sheng
#Organization: CAAD lab @ Boston University
#Start date: Dec 27th 2015
#
import sys
import os
import getopt


def module_gen():
    module="module network_tb;\n"
    return module

def parameter_gen():
    parameter='''	parameter PayloadLen=128;
    parameter DataWidth=256;
    parameter WeightPos=144;
    parameter WeightWidth=8;
    parameter IndexPos=128;
    parameter IndexWidth=16;
    parameter PriorityPos=152;
    parameter PriorityWidth=8;
    parameter ExitPos=160;
    parameter ExitWidth=4;
    parameter InterNodeFIFODepth=128;
    parameter IntraNodeFIFODepth=1;
    parameter RoutingTableWidth=32;
    parameter RoutingTablesize=256;
    parameter MulticastTableWidth=103;
    parameter MulticastTablesize=256;
    parameter ReductionTableWidth=162;
    parameter ReductionTablesize=256;
    parameter PcktTypeLen=4;
    parameter profiling_freq=10;\n
\n '''
    return parameter

def var_gen(size):
    var="\treg clk,rst;\n\n"
    return var

def always_gen(size):
    always="\talways #5 clk=~clk;\n\n"
    return always

def unit_gen(size):
    node="\tnetwork net0(clk,rst);\n"
    return node

def initial_gen(size):
    initial=""
    tag=""
    tmp=""
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                tmp="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/routing_tables/routing_table"+tag+"_local.txt\",net0.n"+tag+".local_unit_inst.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/routing_tables/routing_table"+tag+"_xpos.txt\",net0.n"+tag+".switch_inst.XPOS.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/routing_tables/routing_table"+tag+"_xneg.txt\",net0.n"+tag+".switch_inst.XNEG.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/routing_tables/routing_table"+tag+"_ypos.txt\",net0.n"+tag+".switch_inst.YPOS.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/routing_tables/routing_table"+tag+"_yneg.txt\",net0.n"+tag+".switch_inst.YNEG.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/routing_tables/routing_table"+tag+"_zpos.txt\",net0.n"+tag+".switch_inst.ZPOS.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/routing_tables/routing_table"+tag+"_zneg.txt\",net0.n"+tag+".switch_inst.ZNEG.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/multicast_tables/multicast_table"+tag+"_xpos.txt\",net0.n"+tag+".switch_inst.XPOS.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/multicast_tables/multicast_table"+tag+"_xneg.txt\",net0.n"+tag+".switch_inst.XNEG.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/multicast_tables/multicast_table"+tag+"_ypos.txt\",net0.n"+tag+".switch_inst.YPOS.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/multicast_tables/multicast_table"+tag+"_yneg.txt\",net0.n"+tag+".switch_inst.YNEG.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/multicast_tables/multicast_table"+tag+"_zpos.txt\",net0.n"+tag+".switch_inst.ZPOS.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/multicast_tables/multicast_table"+tag+"_zneg.txt\",net0.n"+tag+".switch_inst.ZNEG.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/reduction_tables/reduction_table"+tag+"_xpos.txt\",net0.n"+tag+".switch_inst.XPOS.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/reduction_tables/reduction_table"+tag+"_xneg.txt\",net0.n"+tag+".switch_inst.XNEG.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/reduction_tables/reduction_table"+tag+"_ypos.txt\",net0.n"+tag+".switch_inst.YPOS.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/reduction_tables/reduction_table"+tag+"_yneg.txt\",net0.n"+tag+".switch_inst.YNEG.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/reduction_tables/reduction_table"+tag+"_zpos.txt\",net0.n"+tag+".switch_inst.ZPOS.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction/tables/reduction_tables/reduction_table"+tag+"_zneg.txt\",net0.n"+tag+".switch_inst.ZNEG.reduction_table);\n"


                initial+=tmp
    initial+='''	initial begin
		clk=0;
		rst=1;

		#100 rst=0;
	end\n'''
    return initial






def network_gen(size):
    module=module_gen()
    paramter=parameter_gen()
    var=var_gen(size)
    always=always_gen(size)
    unit=unit_gen(size)
    initial=initial_gen(size)
    return module+paramter+var+always+unit+initial+"endmodule\n"

def usage():
    print ('''Usage: ./network_tb.py -h (helper)
    ./network_tb.py -s [size] denote the size of the 3D torus network default value=2''')


def main(argv):
    print(argv)
    try:
        opts,args=getopt.getopt(argv,"hs:",["help","size"])
    except getopt.GetoptError:
        usage()
        sys.exit(2);

    size=2
   # print(opts)
  #  print(args)
    for opt,arg in opts:
        if opt in ("-h","--help"):
            usage()
            sys.exit()
        elif opt in("-s","--size"):
   #         print(opt)
            size=int(arg)
    code=network_gen(size)
    f=open("..\HDL\\network_tb.v",'w')
    f.write(code)
    f.close()


if __name__=="__main__":
    main(sys.argv[1:])



