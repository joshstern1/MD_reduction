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
#define MODE 1 //mode 0 is synthetic pattern, mode 1 is the neighour neighbor pattern, mode 2 is the bit rotation
#define MULTICAST_RATIO 1// the number of dst nodes / the total number of nodes
#define SRC_RATIO 1 //the number of src nodes/ the total number of nodes
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
	if(change<0)
		return value+change<0?value+direction+change:value+change;
	else if(change>0)
		return value+change>=direction?value+change-direction:value+change;
	else
		return value;

}

int bit_rotation(int in, int shift_bits,int N){
	if (N == 2){
		if (shift_bits == 0)
			return in;
		else{
			if (in == 1)
				return 2;
			else if (in == 2)
				return 1;
			else
				return in;
		}
	}
	if (N == 3){
		if (shift_bits == 0)
			return in;
		else if (shift_bits == 1){
			if (in == 1)
				return 2;
			else if (in == 3)
				return 6;
			else if (in == 4)
				return 1;
			else if (in == 6)
				return 5;
			else
				return in;
		}
		else{
			if (in == 1)
				return 4;
			else if (in == 2)
				return 1;
			else if (in == 5)
				return 6;
			else if (in == 6)
				return 3;
			else
				return in;
		}
	}

}

void print_bit_rotation(int N){// the bits in index
	string output_file = "C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/destination.txt";
	ofstream fout;
	fout.open(output_file);
	for (int i = 0; i < X*Y*Z; i++){
		int src_x = get_x(i);
		int src_y = get_y(i);
		int src_z = get_z(i);
		if ((src_x == 0 || src_x == 3) && (src_y == 0 || src_y == 3) && (src_z == 0 || src_z == 3))
			continue;
		fout << "{Src(" << src_x << "," << src_y << "," << src_z << ")" << endl;
		for (int j0 = 0; j0 < N; j0++){
			for (int j1 = 0; j1 < N; j1++){
				for (int j2 = 0; j2 < N; j2++){
					if (bit_rotation(src_x, j0, N) == src_x && bit_rotation(src_y, j1, N) == src_y && bit_rotation(src_z, j2, N) == src_z)
						continue;
					else
						fout << "Dst(" << bit_rotation(src_x, j0, N) << "," << bit_rotation(src_y, j1, N) << "," << bit_rotation(src_z, j2, N) << ")" << endl;
				}
			}
		}
		fout << "}" << endl;
	}
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
						if(j0!=0||j1!=0||j2!=0)
							fout<<"Dst("<<change_value(src_x, j0,X)<<","<<change_value(src_y, j1,Y)<<","<<change_value(src_z, j2,Z)<<")"<<endl;
					}
				}
			}
			fout<<"}"<<endl;
		}
	}
	else if (neighbour_distance == 5){
		for (int i = 0; i<X*Y*Z; i++){
			int src_x = get_x(i);
			int src_y = get_y(i);
			int src_z = get_z(i);
			fout << "{Src(" << src_x << "," << src_y << "," << src_z << ")" << endl;
			for (int j0 = -2; j0 <= 2; j0++){
				for (int j1 = -2; j1 <= 2; j1++){
					for (int j2 = -2; j2 <= 2; j2++){
						if (j0 != 0 || j1 != 0 || j2 != 0)
							fout << "Dst(" << change_value(src_x, j0, X) << "," << change_value(src_y, j1, Y) << "," << change_value(src_z, j2, Z) << ")" << endl;
					}
				}
			}
			fout << "}" << endl;
		}
	}
	fout.close();
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
			

		cout << "ideal latency is" << (28 * max_distance + 6 * (max_distance + 1))*6.4 << endl;

	}
	
	else if(mode==1){
		print_nearest_neighbour(3);

		cout << "max distance is" << 3 << endl;


		cout << "ideal latency is" << (28 * 3 + 7 * (3 + 1))*6.4 << endl;
	}
	else if (mode == 2){
		print_bit_rotation(2);

		cout << "max distance is" << 3 << endl;


		cout << "ideal latency is" << (28 * 3 + 7 * (3 + 1))*6.4 << endl;
	}
	
	return 0;
}