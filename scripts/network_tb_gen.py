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
    parameter=''' parameter DataSize=16'd64;
    parameter PayloadLen=128;
    parameter DataWidth=256;
    parameter WeightPos=144;
    parameter WeightWidth=8;
    parameter IndexPos=128;
    parameter IndexWidth=16;
    parameter PriorityPos=152;
    parameter PriorityWidth=8;
    parameter ExitPos=160;
    parameter ExitWidth=4;
    parameter InterNodeFIFODepth=1024;
    parameter IntraNodeFIFODepth=1;
    parameter RoutingTableWidth=32;
    parameter RoutingTablesize=128;
    parameter MulticastTableWidth=123;
    parameter MulticastTablesize=32;
    parameter ReductionTableWidth=170;
    parameter ReductionTablesize=512;
    parameter PcktTypeLen=4;
    parameter LinkDelay=20;\n
\n '''
    return parameter

def var_gen(xsize,ysize,zsize):
    var="\treg clk,rst;\n\n"
    return var

def always_gen(xsize,ysize,zsize):
    always="\talways #5 clk=~clk;\n\n"
    return always

def unit_gen(xsize,ysize,zsize):
    node='''\tnetwork#(
        .DataSize(DataSize),
        .PayloadLen(PayloadLen),
        .DataWidth(DataWidth),
        .WeightPos(WeightPos),
        .WeightWidth(WeightWidth),
        .IndexPos(IndexPos),
        .IndexWidth(IndexWidth),
        .PriorityPos(PriorityPos),
        .PriorityWidth(PriorityWidth),
        .ExitPos(ExitPos),
        .ExitWidth(ExitWidth),
        .InterNodeFIFODepth(InterNodeFIFODepth),
        .IntraNodeFIFODepth(IntraNodeFIFODepth),
        .RoutingTableWidth(RoutingTableWidth),
        .RoutingTablesize(RoutingTablesize),
        .MulticastTableWidth(MulticastTableWidth),
        .MulticastTablesize(MulticastTablesize),
        .ReductionTableWidth(ReductionTableWidth),
        .ReductionTablesize(ReductionTablesize),
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
    )
    net0(clk,rst);\n'''
    return node

def initial_gen(xsize,ysize,zsize):
    initial=""
    tag=""
    tmp=""
    for i in range(0,xsize):
        for j in range(0,ysize):
            for k in range(0,zsize):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                tmp="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/routing_table"+tag+"_LOCAL.txt\",net0.n"+tag+".local_unit_inst.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/routing_table"+tag+"_LOCAL.txt\",net0.n"+tag+".switch_inst.LOCAL.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/routing_table"+tag+"_XPOS.txt\",net0.n"+tag+".switch_inst.XPOS.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/routing_table"+tag+"_XNEG.txt\",net0.n"+tag+".switch_inst.XNEG.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/routing_table"+tag+"_YPOS.txt\",net0.n"+tag+".switch_inst.YPOS.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/routing_table"+tag+"_YNEG.txt\",net0.n"+tag+".switch_inst.YNEG.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/routing_table"+tag+"_ZPOS.txt\",net0.n"+tag+".switch_inst.ZPOS.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/routing_table"+tag+"_ZNEG.txt\",net0.n"+tag+".switch_inst.ZNEG.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/multicast_table"+tag+"_LOCAL.txt\",net0.n"+tag+".switch_inst.LOCAL.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/multicast_table"+tag+"_XPOS.txt\",net0.n"+tag+".switch_inst.XPOS.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/multicast_table"+tag+"_XNEG.txt\",net0.n"+tag+".switch_inst.XNEG.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/multicast_table"+tag+"_YPOS.txt\",net0.n"+tag+".switch_inst.YPOS.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/multicast_table"+tag+"_YNEG.txt\",net0.n"+tag+".switch_inst.YNEG.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/multicast_table"+tag+"_ZPOS.txt\",net0.n"+tag+".switch_inst.ZPOS.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/multicast_table"+tag+"_ZNEG.txt\",net0.n"+tag+".switch_inst.ZNEG.multicast_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/reduction_table"+tag+"_LOCAL.txt\",net0.n"+tag+".switch_inst.mux_local.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/reduction_table"+tag+"_XPOS.txt\",net0.n"+tag+".switch_inst.mux_xpos.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/reduction_table"+tag+"_XNEG.txt\",net0.n"+tag+".switch_inst.mux_xneg.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/reduction_table"+tag+"_YPOS.txt\",net0.n"+tag+".switch_inst.mux_ypos.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/reduction_table"+tag+"_YNEG.txt\",net0.n"+tag+".switch_inst.mux_yneg.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/reduction_table"+tag+"_ZPOS.txt\",net0.n"+tag+".switch_inst.mux_zpos.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/reduction_table"+tag+"_ZNEG.txt\",net0.n"+tag+".switch_inst.mux_zneg.reduction_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/input_data/data_to_send"+tag+".txt\",net0.n"+tag+".local_unit_inst.data);\n"


                initial+=tmp
    initial+='''	initial begin
		clk=0;
		rst=1;

		#100 rst=0;
	end\n'''
    return initial






def network_gen(xsize,ysize,zsize):
    module=module_gen()
    paramter=parameter_gen()
    var=var_gen(xsize,ysize,zsize)
    always=always_gen(xsize,ysize,zsize)
    unit=unit_gen(xsize,ysize,zsize)
    initial=initial_gen(xsize,ysize,zsize)
    return module+paramter+var+always+unit+initial+"endmodule\n"

def usage():
    print ('''Usage: ./network_tb.py -h (helper)
    ./network_tb.py -s [size] denote the size of the 3D torus network default value=2''')


def main(argv):
    print(argv)
    try:
        opts,args=getopt.getopt(argv,"hx:y:z:",["help","xsize","ysize","zsize"])
    except getopt.GetoptError:
        usage()
        sys.exit(2);

    size=2
    print(opts)
    print(args)
    for opt,arg in opts:
        if opt in ("-h","--help"):
            usage()
            sys.exit()
        elif opt in("-x","--xsize"):
            xsize=int(arg)
            print(xsize)
        elif opt in("-y","--ysize"):
            ysize=int(arg)
            print(ysize)
        elif opt in("-z","--zsize"):
            zsize=int(arg)
            print(zsize)
    code=network_gen(xsize,ysize,zsize)
    f=open("..\HDL\\network_tb.v",'w')
    f.write(code)
    f.close()


if __name__=="__main__":
    main(sys.argv[1:])



