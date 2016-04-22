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
#define MODE 1 //mode 0 is synthetic pattern, mode 1 is the neighour neighbor pattern
#define MULTICAST_RATIO 0.1// the number of dst nodes / the total number of nodes
#define SRC_RATIO 0.1 //the number of src nodes/ the total number of nodes
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

int abs(int a, int b){
	return a > b ? a - b : b - a;
}

int oneD_distance(int src, int dst, int direction){
	int size;
	if (direction == 0){
		size = X;
	}
	else if (direction == 1){
		size = Y;
	}
	else if (direction == 2){
		size = Z;
	}
	return abs(src, dst) <= size / 2 ? abs(src, dst): (size - abs(src, dst));

}

int distance(int srcx, int srcy, int srcz, int dstx, int dsty, int dstz){
	int ret0 = oneD_distance(srcx, dstx, 0);
	int ret1 = oneD_distance(srcy, dsty, 1);
	int ret2 = oneD_distance(srcz, dstz, 2);
	return ret0 + ret1 + ret2;
}

inline int change_value(int value, int change,int direction){
	if(change==-1)
		return value==0?direction-1:value-1;
	else if(change==1)
		return value==direction-1?0:value+1;
	else
		return value;

}


void print_nearest_neighbour(int neighbour_distance){
	string output_file="C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/destination.txt";
	ofstream fout;
	fout.open(output_file);
	if(neighbour_distance==3){
		for(int i=0;i<X*Y*Z;i++){
			int src_x=get_x(i);
			int src_y=get_y(i);
			int src_z=get_z(i);
			fout<<"{Src("<<src_x<<","<<src_y<<","<<src_z<<")"<<endl;
			for(int j0=-1;j0<=1;j0++){
				for(int j1=-1;j1<=1;j1++){
					for(int j2=-1;j2<=1;j2++){
						if(j0!=0&&j1!=0&&j2!=0)
							fout<<"Dst("<<change_value(src_x, j0,X)<<","<<change_value(src_y, j1,Y)<<","<<change_value(src_z, j2,Z)<<")"<<endl;
					}
				}
			}
			fout<<"}"<<endl;
		}
	}
}


int main(){
	int max_distance = 0;
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
				if (distance(src_x, src_y, src_z, dst_x, dst_y, dst_z) > max_distance)
					max_distance = distance(src_x, src_y, src_z, dst_x, dst_y, dst_z);
			}
			fout<<"}"<<endl;
		}

		fout.close();
			
		cout << "max distance is" << max_distance << endl;
			

		cout << "ideal latency is" << 20 * max_distance + 8 * (max_distance + 1) << endl;

	}
	
	else if(mode==1){
		print_nearest_neighbour(3);
	}
	
	return 0;
}