//Purpose: generate the traffic pattern (random synthetic or application pattern
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Mar 20th 2015
//Input; X Y Z, mulitcast ratio ( the number of multicast ratio/(X*Y*Z)), mode
//Output: traffic pattern

#include<iostream>
#include<fstream>
#include<string>
#include<stdlib.h>
#include<time.h>
#define MODE 0 //mode 0 is synthetic pattern
#define MULTICAST_RATIO 0.5// the number of dst nodes / the total number of nodes
#define SRC_RATIO 0.5 //the number of src nodes/ the total number of nodes
#define X 4
#define Y 4
#define Z 4

int compute_node_id(int x, int y, int z){
	return x*Y*Z+y*Z+z;
}

int get_x(int id){
	return id/(Y*Z);
}

int get_y(int id){
	return (id%(Y*Z))/Z;
}

int get_z(int id){
	return id%Z;
}


using namespace std;

int mode =MODE;


int main(){
	if(mode==0){
		string output_file="C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/destination.txt";
		ofstream fout;
		fout.open(output_file);
		srand(time(NULL));
		//random mode
		int src_num=X*Y*Z*SRC_RATIO;
		int dst_num=X*Y*Z*MULTICAST_RATIO;
		int* src_list;
		int* dst_list;
		if(!(src_list=(int*)malloc(src_num*sizeof(int)))){
			cout<<"no mem"<<endl;
			exit(-1);
		}
		if(!(dst_list=(int*)malloc(dst_num*sizeof(int)))){
			cout<<"no mem"<<endl;
			exit(-1);
		}
		//init src list
		for(int i=0;i<src_num;i++){
			src_list[i]=-1;
		}
		//init dst list
		for(int i=0;i<dst_num;i++){
			dst_list[i]=-1;
		}
		
		for(int i=0;i<src_num;i++){
			int j=0;
			bool no_dup=false;
			//check whether duplicate
			while(!no_dup){
				int new_random=rand()%(X*Y*Z);
				for(j=0;j<i;j++){
					if(src_list[j]==new_random){
						no_dup=false;
						break;
					}
				}
				if(j==i){
					no_dup=true;
					src_list[i]=new_random;
					break;
				}
			}
		}
		for(int i=0;i<dst_num;i++){
			int j=0;
			bool no_dup=false;
			//check whether duplicate
			while(!no_dup){
				int new_random=rand()%(X*Y*Z);
				for(j=0;j<i;j++){
					if(dst_list[j]==new_random){
						no_dup=false;
						break;
					}
				}
				if(j==i){
					no_dup=true;
					dst_list[i]=new_random;
					break;
				}
			}
		}
		for(int i=0;i<src_num;i++){
			int src_x=get_x(src_list[i]);
			int src_y=get_y(src_list[i]);
			int src_z=get_z(src_list[i]);
			fout<<"{Src("<<src_x<<","<<src_y<<","<<src_z<<")"<<endl;
			for(int j=0;j<dst_num;j++){
				int dst_x=(src_x+get_x(dst_list[j])>X-1)?src_x+get_x(dst_list[j])-X:src_x+get_x(dst_list[j]);
				int dst_y=(src_y+get_y(dst_list[j])>Y-1)?src_y+get_y(dst_list[j])-Y:src_y+get_y(dst_list[j]);
				int dst_z=(src_z+get_z(dst_list[j])>Z-1)?src_z+get_z(dst_list[j])-Z:src_z+get_z(dst_list[j]);
				fout<<"Dst("<<dst_x<<","<<dst_y<<","<<dst_z<<")"<<endl;
			}
			fout<<"}"<<endl;
		}

		fout.close();
			
			

		

	}
	
	
	return 0;
}