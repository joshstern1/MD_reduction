#Purpose: Python scripts to generate the network.v to connect all the nodes and switches in the 3D torus
#Author: Jiayi Sheng
#Organization: CAAD lab @ Boston University
#Start date: Dec 20th 2015
#

import sys
import os
import getopt


def module_gen():
    module='''module network#(
    parameter DataSize=8'd172,
    parameter PayloadLen=128,
    parameter DataWidth=256,
    parameter WeightPos=144,
    parameter WeightWidth=8,
    parameter IndexPos=128,
    parameter IndexWidth=16,
    parameter PriorityPos=152,
    parameter PriorityWidth=8,
    parameter ExitPos=160,
    parameter ExitWidth=4,
    parameter InterNodeFIFODepth=128,
    parameter IntraNodeFIFODepth=1,
    parameter RoutingTableWidth=32,
    parameter RoutingTablesize=256,
    parameter MulticastTableWidth=103,
    parameter MulticastTablesize=256,
    parameter ReductionTableWidth=162,
    parameter ReductionTablesize=256,
    parameter PcktTypeLen=4,
    parameter LinkDelay=20
)(
    input clk,
    input rst
);\n'''
    return module

def parameter_gen():
    parameter=""
    return parameter

def var_gen(xsize,ysize,zsize):
    var=""
    tag=""
    tmp=""
    tmp+="\treg[15:0] xpos_link_sum, xneg_link_sum, ypos_link_sum, yneg_link_sum, zpos_link_sum, zneg_link_sum;\n"
    tmp+="\treg[15:0] xpos_ClockwiseUtil_sum, xneg_ClockwiseUtil_sum, ypos_ClockwiseUtil_sum, yneg_ClockwiseUtil_sum, zpos_ClockwiseUtil_sum, zneg_ClockwiseUtil_sum;\n"
    tmp+="\treg[15:0] xpos_CounterClockwiseUtil_sum, xneg_CounterClockwiseUtil_sum, ypos_CounterClockwiseUtil_sum, yneg_CounterClockwiseUtil_sum, zpos_CounterClockwiseUtil_sum, zneg_CounterClockwiseUtil_sum;\n"
    tmp+="\treg[15:0] xpos_InjectUtil_sum, xneg_InjectUtil_sum, ypos_InjectUtil_sum, yneg_InjectUtil_sum, zpos_InjectUtil_sum, zneg_InjectUtil_sum;\n"
    tmp+="\treg[15:0] link_sum,Clockwise_sum,CounterClockwise_sum,Inject_sum,port_sum;\n"
    tmp+="\treg[15:0] counter, time_counter;\n"
    var+=tmp;
    for i in range(0,xsize):
        for j in range(0,ysize):
            for k in range(0,zsize):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                tmp="\twire[DataWidth-1:0] inject_xpos_ser"+tag+", eject_xpos_ser"+tag+";\n"
                tmp+="\twire[DataWidth-1:0] inject_xneg_ser"+tag+", eject_xneg_ser"+tag+";\n"
                tmp+="\twire[DataWidth-1:0] inject_ypos_ser"+tag+", eject_ypos_ser"+tag+";\n"
                tmp+="\twire[DataWidth-1:0] inject_yneg_ser"+tag+", eject_yneg_ser"+tag+";\n"
                tmp+="\twire[DataWidth-1:0] inject_zpos_ser"+tag+", eject_zpos_ser"+tag+";\n"
                tmp+="\twire[DataWidth-1:0] inject_zneg_ser"+tag+", eject_zneg_ser"+tag+";\n"

                tmp+="\twire[7:0] xpos_ClockwiseUtil"+tag+",xpos_CounterClockwiseUtil"+tag+",xpos_InjectUtil"+tag+";\n"
                tmp+="\twire[7:0] xneg_ClockwiseUtil"+tag+",xneg_CounterClockwiseUtil"+tag+",xneg_InjectUtil"+tag+";\n"
                tmp+="\twire[7:0] ypos_ClockwiseUtil"+tag+",ypos_CounterClockwiseUtil"+tag+",ypos_InjectUtil"+tag+";\n"
                tmp+="\twire[7:0] yneg_ClockwiseUtil"+tag+",yneg_CounterClockwiseUtil"+tag+",yneg_InjectUtil"+tag+";\n"
                tmp+="\twire[7:0] zpos_ClockwiseUtil"+tag+",zpos_CounterClockwiseUtil"+tag+",zpos_InjectUtil"+tag+";\n"
                tmp+="\twire[7:0] zneg_ClockwiseUtil"+tag+",zneg_CounterClockwiseUtil"+tag+",zneg_InjectUtil"+tag+";\n\n"

                var+=tmp
    return var




def assign_gen(xsize,ysize,zsize):
    assign=""
    tag0=""
    tag1=""
    tag2=""
    tmp=""
    for i in range(0,xsize):
        for j in range(0,ysize):
            for k in range(0,zsize):
                tag0="_"+str((i-1+xsize)%xsize)+"_"+str(j)+"_"+str(k)
                tag1="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag2="_"+str((i+1)%xsize)+"_"+str(j)+"_"+str(k)
                tmp="\tassign inject_xpos_ser"+tag1+"=eject_xneg_ser"+tag2+";\n"
                tmp+="\tassign inject_xneg_ser"+tag1+"=eject_xpos_ser"+tag0+";\n"
                assign+=tmp

    for i in range(0,xsize):
        for j in range(0,ysize):
            for k in range(0,zsize):
                tag0="_"+str(i)+"_"+str((j-1+ysize)%ysize)+"_"+str(k)
                tag1="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag2="_"+str(i)+"_"+str((j+1)%ysize)+"_"+str(k)
                tmp="\tassign inject_ypos_ser"+tag1+"=eject_yneg_ser"+tag2+";\n"
                tmp+="\tassign inject_yneg_ser"+tag1+"=eject_ypos_ser"+tag0+";\n"
                assign+=tmp

    for i in range(0,xsize):
        for j in range(0,ysize):
            for k in range(0,zsize):
                tag0="_"+str(i)+"_"+str(j)+"_"+str((k-1+zsize)%zsize)
                tag1="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag2="_"+str(i)+"_"+str(j)+"_"+str((k+1)%zsize)
                tmp="\tassign inject_zpos_ser"+tag1+"=eject_zneg_ser"+tag2+";\n"
                tmp+="\tassign inject_zneg_ser"+tag1+"=eject_zpos_ser"+tag0+";\n"
                assign+=tmp
    return assign

def node_gen(xsize,ysize,zsize):
    node=""
    tag=""
    tmp=""
    for i in range(0,xsize):
        for j in range(0,ysize):
            for k in range(0,zsize):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                tmp='''    node#(
        .DataSize(DataSize),
        .X('''+str(i)+'''),
        .Y('''+str(j)+'''),
        .Z('''+str(k)+'''),
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
        )'''
                tmp+="n"+tag+'''(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser'''+tag+'''),
        .eject_xpos_ser(eject_xpos_ser'''+tag+'''),
        .inject_xneg_ser(inject_xneg_ser'''+tag+'''),
        .eject_xneg_ser(eject_xneg_ser'''+tag+'''),
        .inject_ypos_ser(inject_ypos_ser'''+tag+'''),
        .eject_ypos_ser(eject_ypos_ser'''+tag+'''),
        .inject_yneg_ser(inject_yneg_ser'''+tag+'''),
        .eject_yneg_ser(eject_yneg_ser'''+tag+'''),
        .inject_zpos_ser(inject_zpos_ser'''+tag+'''),
        .eject_zpos_ser(eject_zpos_ser'''+tag+'''),
        .inject_zneg_ser(inject_zneg_ser'''+tag+'''),
        .eject_zneg_ser(eject_zneg_ser'''+tag+'''),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil'''+tag+'''),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil'''+tag+'''),
        .xpos_InjectUtil(xpos_InjectUtil'''+tag+'''),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil'''+tag+'''),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil'''+tag+'''),
        .xneg_InjectUtil(xneg_InjectUtil'''+tag+'''),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil'''+tag+'''),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil'''+tag+'''),
        .ypos_InjectUtil(ypos_InjectUtil'''+tag+'''),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil'''+tag+'''),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil'''+tag+'''),
        .yneg_InjectUtil(yneg_InjectUtil'''+tag+'''),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil'''+tag+'''),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil'''+tag+'''),
        .zpos_InjectUtil(zpos_InjectUtil'''+tag+'''),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil'''+tag+'''),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil'''+tag+'''),
        .zneg_InjectUtil(zneg_InjectUtil'''+tag+''')
);\n'''
                node+=tmp
    return node



def network_gen(xsize,ysize,zsize):
    module=module_gen()
    paramter=parameter_gen()
    var=var_gen(xsize,ysize,zsize)
   # var_extra=var_extra_gen(size)
    assign=assign_gen(xsize,ysize,zsize)
    unit=node_gen(xsize,ysize,zsize)
    #profiling=profiling_gen(size)
    return module+paramter+var+assign+unit+"endmodule\n"

def usage():
    print ('''Usage: ./network -h (helper)
    ./network -x [xsize] -y [ysize] -z [zsize] denote the size of the 3D torus network default value=2''')


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
    f=open("..\HDL\\network.v",'w')
    f.write(code)
    f.close()


if __name__=="__main__":
    main(sys.argv[1:])



