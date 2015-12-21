import sys
import os
import getopt


def module_gen():
    module="module network_tb;\n"
    return module

def parameter_gen():
    parameter='''	parameter DataLenInside=48;
    parameter DataLenOutside=40;
	parameter IntraRingFIFODepth=2;
	parameter IDLen=3;
	parameter PriorityLen=5; //priority field has 5 bits, 0 is the lowest priority
	parameter TableIndexFieldLen=16;

	parameter InterRingFIFODepth=10;
	parameter table_size=8192;\n '''
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
                tmp="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/phd/offline_routing_v2/data/table"+tag+"_local.txt\",net0.n"+tag+".LOCAL.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/phd/offline_routing_v2/data/table"+tag+"_local.txt\",net0.n"+tag+".u0.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/phd/offline_routing_v2/data/table"+tag+"_xpos.txt\",net0.n"+tag+".XPOS.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/phd/offline_routing_v2/data/table"+tag+"_xneg.txt\",net0.n"+tag+".XNEG.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/phd/offline_routing_v2/data/table"+tag+"_ypos.txt\",net0.n"+tag+".YPOS.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/phd/offline_routing_v2/data/table"+tag+"_yneg.txt\",net0.n"+tag+".YNEG.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/phd/offline_routing_v2/data/table"+tag+"_zpos.txt\",net0.n"+tag+".ZPOS.routing_table);\n"
                tmp+="\tinitial $readmemh(\"C:/Users/Jiayi/Documents/phd/offline_routing_v2/data/table"+tag+"_zneg.txt\",net0.n"+tag+".ZNEG.routing_table);\n"
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
    f=open("..\src\\network_tb.v",'w')
    f.write(code)
    f.close()


if __name__=="__main__":
    main(sys.argv[1:])



