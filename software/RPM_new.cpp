//Purpose: A better Recursive Partioning Multicast algorithm than Wang_NoC09
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Mar 28th 2015
//Input:  a file describes the src and destination lists
//output: reduction_tree.txt that feeds to the table_gen.cpp

#define X 4
#define Y 4
#define Z 4
#include<iostream>
#include<fstream>
#include<string>
using namespace std;

struct src_dst_list{
	int x;
	int y;
	int z;
	bool src_or_dst;//true is src, false is dst
	src_dst_list* next;
};

struct src_dst_list** src_list; 

struct chunk{
	//data structure to express a divided chunk
	int x_downlim;
	int x_uplim;
	int y_downlim;
	int y_uplim;
	int z_downlim;
	int z_uplim;
	int get_x_size(){
		if (x_downlim >= x_uplim){
			return x_downlim-x_uplim+1;
		}
		else if (x_uplim>x_downlim){
			return X - x_uplim + x_downlim;
		}
	}
	int get_y_size(){
		if (y_downlim >= y_uplim){
			return y_downlim - y_uplim+1;
		}
		else if (y_uplim>y_downlim){
			return Y - y_uplim + y_downlim;
		}
	}
	int get_z_size(){
		if (z_downlim >= z_uplim){
			return z_downlim - z_uplim+1;
		}
		else if (z_uplim>z_downlim){
			return Z - z_uplim + z_downlim;
		}
	}
	bool within_x(int x){
		if (x_uplim > x_downlim){
			return x >= x_downlim && x <= x_uplim;
		}
		else{
			return x <= x_downlim && x >= x_uplim;
		}
	}

	bool within_y(int y){
		if (y_uplim > y_downlim){
			return y >= y_downlim && y <= y_uplim;
		}
		else{
			return y <= y_downlim && y >= y_uplim;
		}
	}
	bool within_z(int z){
		if (z_uplim > z_downlim){
			return z >= z_downlim && z <= z_uplim;
		}
		else{
			return z <= z_downlim && z >= z_uplim;
		}
	}

	
	

};

void read_src_dst_file(string filename){
	ifstream input_file;
	input_file.open(filename);
	int line_counter = 0;
	while (!input_file.eof){
		
	}
		

	

}

int main(){
	string filename = "C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/destination.txt";
	return 0;
}
