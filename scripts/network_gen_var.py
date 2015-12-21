import sys
import os
import getopt
import random


def module_gen():
    module="module network(clk,rst);\n"
    return module

def parameter_gen():
    parameter='''	parameter srcID=3'd0;
	parameter DataLenInside=48;
	parameter DataLenOutside=40;
	parameter IntraRingFIFODepth=2;
	parameter IDLen=3;
	parameter PriorityLen=5; //priority field has 5 bits, 0 is the lowest priority
	parameter TableIndexFieldLen=16;

	parameter InterRingFIFODepth=10;
	parameter table_size=1024;
    parameter profiling_freq=10;\n '''
    return parameter


def var_gen(size):
    var="\tinput clk,rst;\n\n"
    tag=""
    tmp=""
    tmp+="\treg[31:0] xpos_link_sum, xneg_link_sum, ypos_link_sum, yneg_link_sum, zpos_link_sum, zneg_link_sum;\n"
    tmp+="\treg[31:0] xpos_ClockwiseUtil_sum, xneg_ClockwiseUtil_sum, ypos_ClockwiseUtil_sum, yneg_ClockwiseUtil_sum, zpos_ClockwiseUtil_sum, zneg_ClockwiseUtil_sum;\n"
    tmp+="\treg[31:0] xpos_CounterClockwiseUtil_sum, xneg_CounterClockwiseUtil_sum, ypos_CounterClockwiseUtil_sum, yneg_CounterClockwiseUtil_sum, zpos_CounterClockwiseUtil_sum, zneg_CounterClockwiseUtil_sum;\n"
    tmp+="\treg[31:0] xpos_InjectUtil_sum, xneg_InjectUtil_sum, ypos_InjectUtil_sum, yneg_InjectUtil_sum, zpos_InjectUtil_sum, zneg_InjectUtil_sum;\n"
    tmp+="\treg[31:0] link_sum,Clockwise_sum,CounterClockwise_sum,Inject_sum,port_sum;\n"
    tmp+="\treg[31:0] counter, time_counter;\n"
    var+=tmp;
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                tmp="\twire inject_receive_xpos"+tag+" ,EjectSlotAvail_xpos"+tag+";\n"
                tmp+="\twire inject_receive_xneg"+tag+" ,EjectSlotAvail_xneg"+tag+";\n"
                tmp+="\twire inject_receive_ypos"+tag+" ,EjectSlotAvail_ypos"+tag+";\n"
                tmp+="\twire inject_receive_yneg"+tag+" ,EjectSlotAvail_yneg"+tag+";\n"
                tmp+="\twire inject_receive_zpos"+tag+" ,EjectSlotAvail_zpos"+tag+";\n"
                tmp+="\twire inject_receive_zneg"+tag+" ,EjectSlotAvail_zneg"+tag+";\n"
                tmp+="\twire[DataLenOutside-1:0] inject_xpos"+tag+",inject_xneg"+tag+",inject_ypos"+tag+",inject_yneg"+tag+",inject_zpos"+tag+",inject_zneg"+tag+";\n\n"
                tmp+="\twire eject_send_xpos"+tag+", InjectSlotAvail_xpos"+tag+";\n"
                tmp+="\twire eject_send_xneg"+tag+", InjectSlotAvail_xneg"+tag+";\n"
                tmp+="\twire eject_send_ypos"+tag+", InjectSlotAvail_ypos"+tag+";\n"
                tmp+="\twire eject_send_yneg"+tag+", InjectSlotAvail_yneg"+tag+";\n"
                tmp+="\twire eject_send_zpos"+tag+", InjectSlotAvail_zpos"+tag+";\n"
                tmp+="\twire eject_send_zneg"+tag+", InjectSlotAvail_zneg"+tag+";\n"
                tmp+="\twire[DataLenOutside-1:0] eject_xpos"+tag+",eject_xneg"+tag+",eject_ypos"+tag+",eject_yneg"+tag+",eject_zpos"+tag+",eject_zneg"+tag+";\n\n"
                tmp+="\twire[31:0] xpos_ClockwiseUtil"+tag+",xpos_CounterClockwiseUtil"+tag+",xpos_InjectUtil"+tag+";\n"
                tmp+="\twire[31:0] xneg_ClockwiseUtil"+tag+",xneg_CounterClockwiseUtil"+tag+",xneg_InjectUtil"+tag+";\n"
                tmp+="\twire[31:0] ypos_ClockwiseUtil"+tag+",ypos_CounterClockwiseUtil"+tag+",ypos_InjectUtil"+tag+";\n"
                tmp+="\twire[31:0] yneg_ClockwiseUtil"+tag+",yneg_CounterClockwiseUtil"+tag+",yneg_InjectUtil"+tag+";\n"
                tmp+="\twire[31:0] zpos_ClockwiseUtil"+tag+",zpos_CounterClockwiseUtil"+tag+",zpos_InjectUtil"+tag+";\n"
                tmp+="\twire[31:0] zneg_ClockwiseUtil"+tag+",zneg_CounterClockwiseUtil"+tag+",zneg_InjectUtil"+tag+";\n\n"

                var+=tmp
    return var


def var_extra_gen(size):
    var_extra=""
    tmp=""
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag0="_"+str((i+1)%size)+"_"+str(j)+"_"+str(k)
                tag1="_"+str(i)+"_"+str((j+1)%size)+"_"+str(k)
                tag2="_"+str(i)+"_"+str(j)+"_"+str((k+1)%size)
                tmp="\twire[31:0] link_util"+tag+"_to"+tag0+";\n"
                tmp+="\twire[31:0] link_util"+tag+"_to"+tag1+";\n"
                tmp+="\twire[31:0] link_util"+tag+"_to"+tag2+";\n"
                tmp+="\twire[31:0] link_util"+tag0+"_to"+tag+";\n"
                tmp+="\twire[31:0] link_util"+tag1+"_to"+tag+";\n"
                tmp+="\twire[31:0] link_util"+tag2+"_to"+tag+";\n"

                var_extra+=tmp
    return var_extra


def assign_gen(size):
    assign=""
    tag0=""
    tag1=""
    tag2=""
    tmp=""
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag0="_"+str((i-1+size)%size)+"_"+str(j)+"_"+str(k)
                tag1="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag2="_"+str((i+1)%size)+"_"+str(j)+"_"+str(k)
                tmp="\tassign inject_xpos"+tag1+"=eject_xneg"+tag2+";\n"
                tmp+="\tassign inject_receive_xpos"+tag1+"=eject_send_xneg"+tag2+";\n"
                tmp+="\tassign EjectSlotAvail_xpos"+tag1+"=InjectSlotAvail_xneg"+tag2+";\n"
                tmp+="\tassign inject_xneg"+tag1+"=eject_xpos"+tag0+";\n"
                tmp+="\tassign inject_receive_xneg"+tag1+"=eject_send_xpos"+tag0+";\n"
                tmp+="\tassign EjectSlotAvail_xneg"+tag1+"=InjectSlotAvail_xpos"+tag0+";\n\n"
                assign+=tmp

    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag0="_"+str(i)+"_"+str((j-1+size)%size)+"_"+str(k)
                tag1="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag2="_"+str(i)+"_"+str((j+1)%size)+"_"+str(k)
                tmp="\tassign inject_ypos"+tag1+"=eject_yneg"+tag2+";\n"
                tmp+="\tassign inject_receive_ypos"+tag1+"=eject_send_yneg"+tag2+";\n"
                tmp+="\tassign EjectSlotAvail_ypos"+tag1+"=InjectSlotAvail_yneg"+tag2+";\n"
                tmp+="\tassign inject_yneg"+tag1+"=eject_ypos"+tag0+";\n"
                tmp+="\tassign inject_receive_yneg"+tag1+"=eject_send_ypos"+tag0+";\n"
                tmp+="\tassign EjectSlotAvail_yneg"+tag1+"=InjectSlotAvail_ypos"+tag0+";\n\n"
                assign+=tmp

    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag0="_"+str(i)+"_"+str(j)+"_"+str((k-1+size)%size)
                tag1="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag2="_"+str(i)+"_"+str(j)+"_"+str((k+1)%size)
                tmp="\tassign inject_zpos"+tag1+"=eject_zneg"+tag2+";\n"
                tmp+="\tassign inject_receive_zpos"+tag1+"=eject_send_zneg"+tag2+";\n"
                tmp+="\tassign EjectSlotAvail_zpos"+tag1+"=InjectSlotAvail_zneg"+tag2+";\n"
                tmp+="\tassign inject_zneg"+tag1+"=eject_zpos"+tag0+";\n"
                tmp+="\tassign inject_receive_zneg"+tag1+"=eject_send_zpos"+tag0+";\n"
                tmp+="\tassign EjectSlotAvail_zneg"+tag1+"=InjectSlotAvail_zpos"+tag0+";\n\n"
                assign+=tmp
    return assign

def node_gen(size):
    node=""
    tag=""
    tmp=""
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                tmp="node_active n"+tag+"(\n"+'''//input\n'''+"clk,rst,\n"
                tmp+="\tinject_xpos"+tag+",inject_receive_xpos"+tag+",EjectSlotAvail_xpos"+tag+",\n"
                tmp+="\tinject_xneg"+tag+",inject_receive_xneg"+tag+",EjectSlotAvail_xneg"+tag+",\n"
                tmp+="\tinject_ypos"+tag+",inject_receive_ypos"+tag+",EjectSlotAvail_ypos"+tag+",\n"
                tmp+="\tinject_yneg"+tag+",inject_receive_yneg"+tag+",EjectSlotAvail_yneg"+tag+",\n"
                tmp+="\tinject_zpos"+tag+",inject_receive_zpos"+tag+",EjectSlotAvail_zpos"+tag+",\n"
                tmp+="\tinject_zneg"+tag+",inject_receive_zneg"+tag+",EjectSlotAvail_zneg"+tag+",\n"
                tmp+='''//output\n'''
                tmp+="\teject_xpos"+tag+",eject_send_xpos"+tag+",InjectSlotAvail_xpos"+tag+",\n"
                tmp+="\teject_xneg"+tag+",eject_send_xneg"+tag+",InjectSlotAvail_xneg"+tag+",\n"
                tmp+="\teject_ypos"+tag+",eject_send_ypos"+tag+",InjectSlotAvail_ypos"+tag+",\n"
                tmp+="\teject_yneg"+tag+",eject_send_yneg"+tag+",InjectSlotAvail_yneg"+tag+",\n"
                tmp+="\teject_zpos"+tag+",eject_send_zpos"+tag+",InjectSlotAvail_zpos"+tag+",\n"
                tmp+="\teject_zneg"+tag+",eject_send_zneg"+tag+",InjectSlotAvail_zneg"+tag+",\n"

                tmp+="\txpos_ClockwiseUtil"+tag+",xpos_CounterClockwiseUtil"+tag+",xpos_InjectUtil"+tag+",\n"
                tmp+="\txneg_ClockwiseUtil"+tag+",xneg_CounterClockwiseUtil"+tag+",xneg_InjectUtil"+tag+",\n"
                tmp+="\typos_ClockwiseUtil"+tag+",ypos_CounterClockwiseUtil"+tag+",ypos_InjectUtil"+tag+",\n"
                tmp+="\tyneg_ClockwiseUtil"+tag+",yneg_CounterClockwiseUtil"+tag+",yneg_InjectUtil"+tag+",\n"
                tmp+="\tzpos_ClockwiseUtil"+tag+",zpos_CounterClockwiseUtil"+tag+",zpos_InjectUtil"+tag+",\n"
                tmp+="\tzneg_ClockwiseUtil"+tag+",zneg_CounterClockwiseUtil"+tag+",zneg_InjectUtil"+tag+");\n\n"

                node+=tmp
                node+="\tdefparam n"+tag+".u0.x="+str(i)+";\n"
                node+="\tdefparam n"+tag+".u0.y="+str(j)+";\n"
                node+="\tdefparam n"+tag+".u0.z="+str(k)+";\n\n"
    return node

def link_gen(size):
    tag0=""
    tag1=""
    link=""
    #x dimension
    #delay=50
    tmp=""
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                delay=int(random.gauss(26.355,1.8))
                tag0="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag1="_"+str((i+1)%size)+"_"+str(j)+"_"+str(k)
                tmp="\tinternode_link link"+tag0+"_to"+tag1+"(\n"+'''//input\n'''+".clk(clk),\t.rst(rst),\n"
                tmp+="\t.data_in(eject_xpos"+tag0+"),\n"
                tmp+="\t.DataOutSlotAvail(InjectSlotAvail_xneg"+tag1+"),\n"
                tmp+="\t.data_in_en(eject_send_xpos"+tag0+"),\n"
                tmp+='''//output\n'''
                tmp+="\t.data_out(inject_xneg"+tag1+"),\n"
                tmp+="\t.DataInSlotAvail(EjectSlotAvail_xpos"+tag0+"),\n"
                tmp+="\t.data_out_en(inject_receive_xneg"+tag1+"),\n"
                tmp+="\t.utilization(link_util"+tag0+"_to"+tag1+")\n);\n"

                tmp+="\tdefparam link"+tag0+"_to"+tag1+".src_x="+str(i)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".src_y="+str(j)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".src_z="+str(k)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".dst_x="+str((i+1)%size)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".dst_y="+str(j)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".dst_z="+str(k)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".delay="+str(delay)+";\n\n"

                if(size!=2):

                    tmp+="\tinternode_link link"+tag1+"_to"+tag0+"(\n"+'''//input\n'''+".clk(clk),\t.rst(rst),\n"
                    tmp+="\t.data_in(eject_xneg"+tag1+"),\n"
                    tmp+="\t.DataOutSlotAvail(InjectSlotAvail_xpos"+tag0+"),\n"
                    tmp+="\t.data_in_en(eject_send_xneg"+tag1+"),\n"
                    tmp+='''//output\n'''
                    tmp+="\t.data_out(inject_xpos"+tag0+"),\n"
                    tmp+="\t.DataInSlotAvail(EjectSlotAvail_xneg"+tag1+"),\n"
                    tmp+="\t.data_out_en(inject_receive_xpos"+tag0+"),\n"
                    tmp+="\t.utilization(link_util"+tag1+"_to"+tag0+")\n);\n"



                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".src_x="+str((i+1)%size)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".src_y="+str(j)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".src_z="+str(k)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".dst_x="+str(i)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".dst_y="+str(j)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".dst_z="+str(k)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".delay="+str(delay)+";\n\n"


                link+=tmp

#y dimension
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):

                delay=int(random.gauss(26.355,1.8))
                tag0="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag1="_"+str(i)+"_"+str((j+1)%size)+"_"+str(k)
                tmp="\tinternode_link link"+tag0+"_to"+tag1+"(\n"+'''//input\n'''+".clk(clk),\t.rst(rst),\n"
                tmp+="\t.data_in(eject_ypos"+tag0+"),\n"
                tmp+="\t.DataOutSlotAvail(InjectSlotAvail_yneg"+tag1+"),\n"
                tmp+="\t.data_in_en(eject_send_ypos"+tag0+"),\n"
                tmp+='''//output\n'''
                tmp+="\t.data_out(inject_yneg"+tag1+"),\n"
                tmp+="\t.DataInSlotAvail(EjectSlotAvail_ypos"+tag0+"),\n"
                tmp+="\t.data_out_en(inject_receive_yneg"+tag1+"),\n"
                tmp+="\t.utilization(link_util"+tag0+"_to"+tag1+")\n);\n"


                tmp+="\tdefparam link"+tag0+"_to"+tag1+".src_x="+str(i)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".src_y="+str(j)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".src_z="+str(k)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".dst_x="+str(i)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".dst_y="+str((j+1)%size)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".dst_z="+str(k)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".delay="+str(delay)+";\n\n"

                if(size!=2):

                    tmp+="\tinternode_link link"+tag1+"_to"+tag0+"(\n"+'''//input\n'''+".clk(clk),\t.rst(rst),\n"
                    tmp+="\t.data_in(eject_yneg"+tag1+"),\n"
                    tmp+="\t.DataOutSlotAvail(InjectSlotAvail_ypos"+tag0+"),\n"
                    tmp+="\t.data_in_en(eject_send_yneg"+tag1+"),\n"
                    tmp+='''//output\n'''
                    tmp+="\t.data_out(inject_ypos"+tag0+"),\n"
                    tmp+="\t.DataInSlotAvail(EjectSlotAvail_yneg"+tag1+"),\n"
                    tmp+="\t.data_out_en(inject_receive_ypos"+tag0+"),\n"
                    tmp+="\t.utilization(link_util"+tag1+"_to"+tag0+")\n);\n"



                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".src_x="+str(i)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".src_y="+str((j+1)%size)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".src_z="+str(k)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".dst_x="+str(i)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".dst_y="+str(j)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".dst_z="+str(k)+";\n"
                    tmp+="\tdefparam link"+tag1+"_to"+tag0+".delay="+str(delay)+";\n\n"
                link+=tmp

#z dimension
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):

                delay=int(random.gauss(26.355,1.8))
                tag0="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag1="_"+str(i)+"_"+str(j)+"_"+str((k+1)%size)
                tmp="\tinternode_link link"+tag0+"_to"+tag1+"(\n"+'''//input\n'''+".clk(clk),\t.rst(rst),\n"
                tmp+="\t.data_in(eject_zpos"+tag0+"),\n"
                tmp+="\t.DataOutSlotAvail(InjectSlotAvail_zneg"+tag1+"),\n"
                tmp+="\t.data_in_en(eject_send_zpos"+tag0+"),\n"
                tmp+='''//output\n'''
                tmp+="\t.data_out(inject_zneg"+tag1+"),\n"
                tmp+="\t.DataInSlotAvail(EjectSlotAvail_zpos"+tag0+"),\n"
                tmp+="\t.data_out_en(inject_receive_zneg"+tag1+"),\n"
                tmp+="\t.utilization(link_util"+tag0+"_to"+tag1+")\n);\n"


                tmp+="\tdefparam link"+tag0+"_to"+tag1+".src_x="+str(i)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".src_y="+str(j)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".src_z="+str(k)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".dst_x="+str(i)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".dst_y="+str(j)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".dst_z="+str((k+1)%size)+";\n"
                tmp+="\tdefparam link"+tag0+"_to"+tag1+".delay="+str(delay)+";\n\n"

                if(size!=2):

                   tmp+="\tinternode_link link"+tag1+"_to"+tag0+"(\n"+'''//input\n'''+".clk(clk),\t.rst(rst),\n"
                   tmp+="\t.data_in(eject_zneg"+tag1+"),\n"
                   tmp+="\t.DataOutSlotAvail(InjectSlotAvail_zpos"+tag0+"),\n"
                   tmp+="\t.data_in_en(eject_send_zneg"+tag1+"),\n"
                   tmp+='''//output\n'''
                   tmp+="\t.data_out(inject_zpos"+tag0+"),\n"
                   tmp+="\t.DataInSlotAvail(EjectSlotAvail_zneg"+tag1+"),\n"
                   tmp+="\t.data_out_en(inject_receive_zpos"+tag0+"),\n"
                   tmp+="\t.utilization(link_util"+tag1+"_to"+tag0+")\n);\n"



                   tmp+="\tdefparam link"+tag1+"_to"+tag0+".src_x="+str(i)+";\n"
                   tmp+="\tdefparam link"+tag1+"_to"+tag0+".src_y="+str(j)+";\n"
                   tmp+="\tdefparam link"+tag1+"_to"+tag0+".src_z="+str((k+1)%size)+";\n"
                   tmp+="\tdefparam link"+tag1+"_to"+tag0+".dst_x="+str(i)+";\n"
                   tmp+="\tdefparam link"+tag1+"_to"+tag0+".dst_y="+str(j)+";\n"
                   tmp+="\tdefparam link"+tag1+"_to"+tag0+".dst_z="+str(k)+";\n"
                   tmp+="\tdefparam link"+tag1+"_to"+tag0+".delay="+str(delay)+";\n\n"
                link+=tmp

    return link

def profiling_gen(size):
    profiling=""
    profiling="//the link profiling block\n"
    profiling+="always@(*)\n"
    profiling+="\tbegin\n"
    profiling+="\tif(rst)\n"
    profiling+="\t\tbegin\n"
    profiling+="\t\txpos_link_sum=0;\n"
    profiling+="\t\txneg_link_sum=0;\n"
    profiling+="\t\typos_link_sum=0;\n"
    profiling+="\t\tyneg_link_sum=0;\n"
    profiling+="\t\tzpos_link_sum=0;\n"
    profiling+="\t\tzneg_link_sum=0;\n"
    profiling+="\tend\n"
    profiling+="\telse\n"
    profiling+="\t\tbegin\n"
    profiling+="\t\txpos_link_sum="
    delay=50
    IntraRingDepth=2
    InterRingDepth=999
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag0="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag1="_"+str((i+1)%size)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="link_util"+tag0+"_to"+tag1+";\n"
                else:
                    profiling+="link_util"+tag0+"_to"+tag1+"+"
    profiling+="\t\txneg_link_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag0="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag1="_"+str((i+1)%size)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="link_util"+tag1+"_to"+tag0+";\n"
                else:
                    profiling+="link_util"+tag1+"_to"+tag0+"+"
    profiling+="\t\typos_link_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag0="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag1="_"+str(i)+"_"+str((j+1)%size)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="link_util"+tag0+"_to"+tag1+";\n"
                else:
                    profiling+="link_util"+tag0+"_to"+tag1+"+"
    profiling+="\t\tyneg_link_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag0="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag1="_"+str(i)+"_"+str((j+1)%size)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="link_util"+tag1+"_to"+tag0+";\n"
                else:
                    profiling+="link_util"+tag1+"_to"+tag0+"+"
    profiling+="\t\tzpos_link_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag0="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag1="_"+str(i)+"_"+str(j)+"_"+str((k+1)%size)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="link_util"+tag0+"_to"+tag1+";\n"
                else:
                    profiling+="link_util"+tag0+"_to"+tag1+"+"
    profiling+="\t\tzneg_link_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag0="_"+str(i)+"_"+str(j)+"_"+str(k)
                tag1="_"+str(i)+"_"+str(j)+"_"+str((k+1)%size)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="link_util"+tag1+"_to"+tag0+";\n"
                else:
                    profiling+="link_util"+tag1+"_to"+tag0+"+"
    profiling+="\t\tend\n"
    profiling+="end\n"

    profiling+="//the counterclockwise port profiling block\n"
    profiling+="always@(*)\n"
    profiling+="\tbegin\n"
    profiling+="\tif(rst)\n"
    profiling+="\t\tbegin\n"
    profiling+="\t\txpos_CounterClockwiseUtil_sum=0;\n"
    profiling+="\t\txneg_CounterClockwiseUtil_sum=0;\n"
    profiling+="\t\typos_CounterClockwiseUtil_sum=0;\n"
    profiling+="\t\tyneg_CounterClockwiseUtil_sum=0;\n"
    profiling+="\t\tzpos_CounterClockwiseUtil_sum=0;\n"
    profiling+="\t\tzneg_CounterClockwiseUtil_sum=0;\n"
    profiling+="\tend\n"
    profiling+="\telse\n"
    profiling+="\t\tbegin\n"
    profiling+="\t\txpos_CounterClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="xpos_CounterClockwiseUtil"+tag+";\n"
                else:
                    profiling+="xpos_CounterClockwiseUtil"+tag+"+"
    profiling+="\t\txneg_CounterClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="xneg_CounterClockwiseUtil"+tag+";\n"
                else:
                    profiling+="xneg_CounterClockwiseUtil"+tag+"+"
    profiling+="\t\typos_CounterClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="ypos_CounterClockwiseUtil"+tag+";\n"
                else:
                    profiling+="ypos_CounterClockwiseUtil"+tag+"+"
    profiling+="\t\tyneg_CounterClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="yneg_CounterClockwiseUtil"+tag+";\n"
                else:
                    profiling+="yneg_CounterClockwiseUtil"+tag+"+"
    profiling+="\t\tzpos_CounterClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="zpos_CounterClockwiseUtil"+tag+";\n"
                else:
                    profiling+="zpos_CounterClockwiseUtil"+tag+"+"
    profiling+="\t\tzneg_CounterClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="zneg_CounterClockwiseUtil"+tag+";\n"
                else:
                    profiling+="zneg_CounterClockwiseUtil"+tag+"+"
    profiling+="\t\tend\n"
    profiling+="\tend\n"

    profiling+="//the clockwise port profiling block\n"
    profiling+="always@(*)\n"
    profiling+="\tbegin\n"
    profiling+="\tif(rst)\n"
    profiling+="\t\tbegin\n"
    profiling+="\t\txpos_ClockwiseUtil_sum=0;\n"
    profiling+="\t\txneg_ClockwiseUtil_sum=0;\n"
    profiling+="\t\typos_ClockwiseUtil_sum=0;\n"
    profiling+="\t\tyneg_ClockwiseUtil_sum=0;\n"
    profiling+="\t\tzpos_ClockwiseUtil_sum=0;\n"
    profiling+="\t\tzneg_ClockwiseUtil_sum=0;\n"
    profiling+="\tend\n"
    profiling+="\telse\n"
    profiling+="\t\tbegin\n"
    profiling+="\t\txpos_ClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="xpos_ClockwiseUtil"+tag+";\n"
                else:
                    profiling+="xpos_ClockwiseUtil"+tag+"+"
    profiling+="\t\txneg_ClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="xneg_ClockwiseUtil"+tag+";\n"
                else:
                    profiling+="xneg_ClockwiseUtil"+tag+"+"
    profiling+="\t\typos_ClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="ypos_ClockwiseUtil"+tag+";\n"
                else:
                    profiling+="ypos_ClockwiseUtil"+tag+"+"
    profiling+="\t\tyneg_ClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="yneg_ClockwiseUtil"+tag+";\n"
                else:
                    profiling+="yneg_ClockwiseUtil"+tag+"+"

    profiling+="\t\tzpos_ClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="zpos_ClockwiseUtil"+tag+";\n"
                else:
                    profiling+="zpos_ClockwiseUtil"+tag+"+"

    profiling+="\t\tzneg_ClockwiseUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="zneg_ClockwiseUtil"+tag+";\n"
                else:
                    profiling+="zneg_ClockwiseUtil"+tag+"+"
    profiling+="\t\tend\n"
    profiling+="\tend\n"

    profiling+="//the inject port profiling block\n"
    profiling+="always@(*)\n"
    profiling+="\tbegin\n"
    profiling+="\tif(rst)\n"
    profiling+="\t\tbegin\n"
    profiling+="\t\txpos_InjectUtil_sum=0;\n"
    profiling+="\t\txneg_InjectUtil_sum=0;\n"
    profiling+="\t\typos_InjectUtil_sum=0;\n"
    profiling+="\t\tyneg_InjectUtil_sum=0;\n"
    profiling+="\t\tzpos_InjectUtil_sum=0;\n"
    profiling+="\t\tzneg_InjectUtil_sum=0;\n"
    profiling+="\tend\n"
    profiling+="\telse\n"
    profiling+="\t\tbegin\n"
    profiling+="\t\txpos_InjectUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="xpos_InjectUtil"+tag+";\n"
                else:
                    profiling+="xpos_InjectUtil"+tag+"+"
    profiling+="\t\txneg_InjectUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="xneg_InjectUtil"+tag+";\n"
                else:
                    profiling+="xneg_InjectUtil"+tag+"+"
    profiling+="\t\typos_InjectUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="ypos_InjectUtil"+tag+";\n"
                else:
                    profiling+="ypos_InjectUtil"+tag+"+"
    profiling+="\t\tyneg_InjectUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="yneg_InjectUtil"+tag+";\n"
                else:
                    profiling+="yneg_InjectUtil"+tag+"+"

    profiling+="\t\tzpos_InjectUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="zpos_InjectUtil"+tag+";\n"
                else:
                    profiling+="zpos_InjectUtil"+tag+"+"

    profiling+="\t\tzneg_InjectUtil_sum="
    for i in range(0,size):
        for j in range(0,size):
            for k in range(0,size):
                tag="_"+str(i)+"_"+str(j)+"_"+str(k)
                if(i==size-1 and j==size-1 and k==size-1):
                    profiling+="zneg_InjectUtil"+tag+";\n"
                else:
                    profiling+="zneg_InjectUtil"+tag+"+"
    profiling+="\t\tend\n"
    profiling+="\tend\n"

    profiling+="\talways@(*) link_sum=xpos_link_sum+xneg_link_sum+ypos_link_sum+yneg_link_sum+zpos_link_sum+zneg_link_sum;\n"
    profiling+="\talways@(*) Clockwise_sum=xpos_ClockwiseUtil_sum+xneg_ClockwiseUtil_sum+ypos_ClockwiseUtil_sum+yneg_ClockwiseUtil_sum+zpos_ClockwiseUtil_sum+zneg_ClockwiseUtil_sum;\n"
    profiling+="\talways@(*) CounterClockwise_sum=xpos_CounterClockwiseUtil_sum+xneg_CounterClockwiseUtil_sum+ypos_CounterClockwiseUtil_sum+yneg_CounterClockwiseUtil_sum+zpos_CounterClockwiseUtil_sum+zneg_CounterClockwiseUtil_sum;\n"
    profiling+="\talways@(*) port_sum=Inject_sum+Clockwise_sum+CounterClockwise_sum;\n"
    profiling+="\talways@(*) Inject_sum=xpos_InjectUtil_sum+xneg_InjectUtil_sum+ypos_InjectUtil_sum+yneg_InjectUtil_sum+zpos_InjectUtil_sum+zneg_InjectUtil_sum;\n"

    profiling+="always@(posedge clk)\n"
    profiling+="\tbegin\n"
    profiling+="\tif(rst)\n"
    profiling+="\tbegin\n"
    profiling+="\t\tcounter<=0;\n"
    profiling+="\t\ttime_counter<=0;\n"
    profiling+="end\n"
    profiling+="\telse\n"
    profiling+="\tbegin\n"
    profiling+="\t\tcounter<=(counter==profiling_freq-1)?0:counter+1;\n"
    profiling+="\t\ttime_counter<=time_counter+1;\n"
    profiling+="\tend\n"
    profiling+="end\n"

    profiling+="\tinteger fd;\n"
    profiling+="always@(posedge clk)\n"
    profiling+="\tif(counter==profiling_freq-1)\n"
    profiling+="\t\tbegin\n"
    profiling+="\t\tfd=$fopen(\"profiling.txt\",\"a\");\n"
    profiling+="\t\tif(fd)\n"
    profiling+="\t\t\tbegin\n"
    profiling+="\t\t\t$display(\"file: profiling.txt open successfully\\n\");\n"
    profiling+="\t\tend\n"
    profiling+="\t\telse\n"
    profiling+="\t\t\tbegin\n"
    profiling+="\t\t\t$display(\"file open failed\\n\");\n"
    profiling+="\t\tend\n"

    profiling+="\t\t$fdisplay(fd,\"* %d This is %d cycles\\n\",time_counter, time_counter);\n"
    profiling+="\t\t$fdisplay(fd,\"A %d "+str(size*size*size*6*delay)+" link utilization is %d out of"+str(size*size*size*6*delay)+"\\n\",link_sum,link_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"B %d "+str(size*size*size*delay)+" link utilization of x pos dimension is %d out of "+str(size*size*size*delay)+"\\n\",xpos_link_sum,xpos_link_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"C %d "+str(size*size*size*delay)+" link utilization of x neg dimension is %d out of "+str(size*size*size*delay)+"\\n\",xneg_link_sum,xneg_link_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"D %d "+str(size*size*size*delay)+" link utilization of y pos dimension is %d out of "+str(size*size*size*delay)+"\\n\",ypos_link_sum,ypos_link_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"E %d "+str(size*size*size*delay)+" link utilization of y neg dimension is %d out of "+str(size*size*size*delay)+"\\n\",yneg_link_sum,yneg_link_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"F %d "+str(size*size*size*delay)+" link utilization of z pos dimension is %d out of "+str(size*size*size*delay)+"\\n\",zpos_link_sum,zpos_link_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"G %d "+str(size*size*size*delay)+" link utilization of z neg dimension is %d out of "+str(size*size*size*delay)+"\\n\",zneg_link_sum,zneg_link_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"H %d "+str(12*size*size*size*IntraRingDepth+6*size*size*size*InterRingDepth)+" port utilization is %d out of "+str(12*size*size*size*IntraRingDepth+6*size*size*size*InterRingDepth)+"\\n\",port_sum,port_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"I %d "+str(6*size*size*size*IntraRingDepth)+" Clockwise port utilization is %d out of "+str(6*size*size*size*IntraRingDepth)+"\\n\",Clockwise_sum,Clockwise_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"J %d "+str(6*size*size*size*IntraRingDepth)+" CounterClockwise port utilization is %d out of "+str(6*size*size*size*IntraRingDepth)+"\\n\",CounterClockwise_sum,CounterClockwise_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"K %d "+str(6*size*size*size*InterRingDepth)+" Inject port utilization is %d out of "+str(6*size*size*size*InterRingDepth)+"\\n\",Inject_sum,Inject_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"L %d "+str(size*size*size*IntraRingDepth)+" xpos clockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",xpos_ClockwiseUtil_sum,xpos_ClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"M %d "+str(size*size*size*IntraRingDepth)+" xneg clockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",xneg_ClockwiseUtil_sum,xneg_ClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"N %d "+str(size*size*size*IntraRingDepth)+" ypos clockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",ypos_ClockwiseUtil_sum,ypos_ClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"O %d "+str(size*size*size*IntraRingDepth)+" yneg clockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",yneg_ClockwiseUtil_sum,yneg_ClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"P %d "+str(size*size*size*IntraRingDepth)+" zpos clockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",zpos_ClockwiseUtil_sum,zpos_ClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"Q %d "+str(size*size*size*IntraRingDepth)+" zneg clockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",zneg_ClockwiseUtil_sum,zneg_ClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"R %d "+str(size*size*size*IntraRingDepth)+" xpos counterclockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",xpos_CounterClockwiseUtil_sum,xpos_CounterClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"S %d "+str(size*size*size*IntraRingDepth)+" xneg counterclockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",xneg_CounterClockwiseUtil_sum,xneg_CounterClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"T %d "+str(size*size*size*IntraRingDepth)+" ypos counterclockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",ypos_CounterClockwiseUtil_sum,ypos_CounterClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"U %d "+str(size*size*size*IntraRingDepth)+" yneg counterclockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",yneg_CounterClockwiseUtil_sum,yneg_CounterClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"V %d "+str(size*size*size*IntraRingDepth)+" zpos counterclockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",zpos_CounterClockwiseUtil_sum,zpos_CounterClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"W %d "+str(size*size*size*IntraRingDepth)+" zneg counterclockwise port utilization is %d out of "+str(size*size*size*IntraRingDepth)+"\\n\",zneg_CounterClockwiseUtil_sum,zneg_CounterClockwiseUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"X %d "+str(size*size*size*InterRingDepth)+" xpos inject port utilization is %d out of "+str(size*size*size*InterRingDepth)+"\\n\",xpos_InjectUtil_sum,xpos_InjectUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"Y %d "+str(size*size*size*InterRingDepth)+" xneg inject port utilization is %d out of "+str(size*size*size*InterRingDepth)+"\\n\",xneg_InjectUtil_sum,xneg_InjectUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"Z %d "+str(size*size*size*InterRingDepth)+" ypos inject port utilization is %d out of "+str(size*size*size*InterRingDepth)+"\\n\",ypos_InjectUtil_sum,ypos_InjectUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"0 %d "+str(size*size*size*InterRingDepth)+" yneg inject port utilization is %d out of "+str(size*size*size*InterRingDepth)+"\\n\",yneg_InjectUtil_sum,yneg_InjectUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"1 %d "+str(size*size*size*InterRingDepth)+" zpos inject port utilization is %d out of "+str(size*size*size*InterRingDepth)+"\\n\",zpos_InjectUtil_sum,zpos_InjectUtil_sum);\n"
    profiling+="\t\t$fdisplay(fd,\"2 %d "+str(size*size*size*InterRingDepth)+" zneg inject port utilization is %d out of "+str(size*size*size*InterRingDepth)+"\\n\",zneg_InjectUtil_sum,zneg_InjectUtil_sum);\n"
    profiling+="\t\t$fclose(fd);\n"
    profiling+="\tend\n"
    return profiling

def network_gen(size):
    module=module_gen()
    paramter=parameter_gen()
    var=var_gen(size)
    var_extra=var_extra_gen(size)
    #assign=assign_gen(size)
    unit=node_gen(size)
    link=link_gen(size)
    profiling=profiling_gen(size)
    return module+paramter+var+var_extra+unit+link+profiling+"endmodule\n"

def usage():
    print ('''Usage: ./network -h (helper)
    ./network -s [size] denote the size of the 3D torus network default value=2''')


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
    f=open("..\src\\network.v",'w')
    f.write(code)
    f.close()


if __name__=="__main__":
    main(sys.argv[1:])



