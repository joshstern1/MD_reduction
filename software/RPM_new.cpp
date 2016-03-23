//Purpose: A better Recursive Partioning Multicast algorithm than Wang_NoC09
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Mar 28th 2015
//Input:  a file describes the src and destination lists
//output: reduction_tree.txt that feeds to the table_gen.cpp

#define X 4
#define Y 4
#define Z 4
#define LINEMAX 100
#include<iostream>
#include<fstream>
#include<string>
using namespace std;

struct xyz{
	int x;
	int y;
	int z;
};

struct src_dst_list{
	int x;
	int y;
	int z;
	bool valid;
	bool src_or_dst;//true is src, false is dst
	src_dst_list* next;
};

struct src_dst_list** src_list; 


struct xyz extract_node_from_line(char* line){
	struct xyz ret;
	int i = 0;
	char x_str[3];
	char y_str[3];
	char z_str[3];
	int cur_root_x; // the current x of the root node 
	int cur_root_y; // current y of the root node
	int cur_root_z; // current z of the root node
	while (line[i]){
		if (line[i] != '('){
			i++;
			continue;//searching for the bracket
		}
		else{
			x_str[0] = line[i + 1];
			if (line[i + 2] != ','){
				x_str[1] = line[i + 2];
				x_str[2] = '\0';
				i = i + 4;
			}
			else{
				i = i + 3;
				x_str[1] = '\0';
			}
			y_str[0] = line[i];
			if (line[i + 1] != ','){
				y_str[1] = line[i + 1];
				y_str[2] = '\0';
				i = i + 3;
			}
			else{
				i = i + 2;
				y_str[1] = '\0';
			}
			z_str[0] = line[i];
			if (line[i + 1] != ')'){
				z_str[1] = line[i + 1];
				z_str[2] = '\0';
				i = i + 3;
			}
			else{
				i = i + 2;
				z_str[1] = '\0';
			}
			break; // the root node xyz have all acquired
		}
	}

	//create a new node as root
	ret.x = atoi(x_str);
	ret.y = atoi(y_str);
	ret.z = atoi(z_str);
	return ret;

}
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
	char line[LINEMAX];
	//init the src list
	if (!(src_list = (struct src_dst_list**)malloc(X*Y*Z*sizeof(struct src_dst_list)))){
		cout << "No mem" << endl;
		exit(-1);
	}
	for (int i = 0; i < X*Y*Z; i++){
		src_list[i]->valid = false;
	}
	while (!input_file.eof){
		input_file.getline(line, LINEMAX);
		line_counter++;
		if (line[0] == '{' && line[1] == 'S'){
			struct xyz cur_xyz = extract_node_from_line(line);
			//found a new source dst list, the cur xyz is the src node
			//init the src node
			cur_xyz
			
			
		}

		
	}
		

	

}

int main(){
	string filename = "C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/destination.txt";
	return 0;
}
