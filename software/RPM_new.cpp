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
int x_link_counter[X*Y*Z];
int y_link_counter[X*Y*Z];
int z_link_counter[X*Y*Z];


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
	int src_id;
	int dst_id; 
	struct xyz cur_xyz;
	struct src_dst_list* head;
	struct src_dst_list* tail;
	struct src_dst_list* new_dst;
	struct src_dst_list* prev_node;
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
			cur_xyz = extract_node_from_line(line);
			//found a new source dst list, the cur xyz is the src node
			//init the src node
			src_id = cur_xyz.x*Y*Z + cur_xyz.y*Z + cur_xyz.z;
			src_list[src_id]->valid = true;
			src_list[src_id]->src_or_dst = true;
			src_list[src_id]->next = NULL;
			src_list[src_id]->x = cur_xyz.x;
			src_list[src_id]->y = cur_xyz.y;
			src_list[src_id]->z = cur_xyz.z;
			head = src_list[src_id];
			tail = src_list[src_id];
			prev_node = src_list[src_id];
			

			
			
		}
		else if (line[0] == 'D'){
			cur_xyz = extract_node_from_line(line);
			dst_id = cur_xyz.x*Y*Z + cur_xyz.y*Z + cur_xyz.z;
			//create a new dst node that linked behind the right src list
			if (!(new_dst = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			new_dst->valid = true;
			new_dst->src_or_dst = false;
			new_dst->next = NULL;
			new_dst->x = cur_xyz.x;
			new_dst->y = cur_xyz.y;
			new_dst->z = cur_xyz.z;
			prev_node->next = new_dst;
			prev_node = new_dst;
				
		}

		
	}
		

	

}
int evaluate_plane(struct src_dst_list* src, int direction){//return the count of the fanout links on the plance
	//if the direction is 0, this is the yz plane
	//if the direction is 1, this is the zx plane
	//if the direction is 2, this is the xy plane
	//divide the plane into 8 regions beyond src
	// ____________________
	// |       |  |       |
    // |   2   |1 |   0   |
    // |_______|__|_______|
	// |___3___|S_|___7___|
	// |       |  |       |
	// |   4   |5 |   6   |
	// |_______|__|_______|
	//if yz plane
	//---> y
	//|
	//\/
	//z
	//if zx plane
	//---> x
	//|
	//\/
	//z
	//if xy plane
	//---> x
	//|
	//\/
	//y
	int region0_count = 0;
	int region1_count = 0;
	int region2_count = 0;
	int region3_count = 0;
	int region4_count = 0;
	int region5_count = 0;
	int region6_count = 0;
	int region7_count = 0;
	int xpos_enable = 0;
	int xneg_enable = 0;
	int ypos_enable = 0;
	int yneg_enable = 0;
	int zpos_enable = 0;
	int zneg_enable = 0;
	int src_x = src->x;
	int src_y = src->y;
	int src_z = src->z;
	int relative_x;
	int relative_y;
	int relative_z;
	struct src_dst_list* node_ptr = src->next;
	if (direction == 0){
		while (node_ptr){
			relative_y = node_ptr->y - src->y<0 ? node_ptr->y - src->y + Y : node_ptr->y - src->y;
			relative_z = node_ptr->z - src->z<0 ? node_ptr->z - src->z + Z : node_ptr->z - src->z;
			if (relative_y > Y / 2){
				if (relative_z > Z/2){
					region2_count++;

				}
				else if (relative_z <= Z / 2 && relative_z > 0){
					region4_count++;
				}
				else if (relative_z == 0){
					region3_count++;
				}


			}
			else if (relative_y < Y / 2){
				if (relative_z > Z / 2){
					region0_count++;

				}
				else if (relative_z <= Z / 2 && relative_z > 0){
					region6_count++;
				}
				else if (relative_z == 0){
					region7_count++;
				}

			}
			else{
				if (relative_z > Z / 2){
					region1_count++;

				}
				else if (relative_z <= Z / 2 && relative_z > 0){
					region5_count++;
				}



			}
			node_ptr = node_ptr->next;

		}
	}
	else if (direction == 1){
		while (node_ptr){
			relative_x = node_ptr->x - src->x<0 ? node_ptr->x - src->x + X : node_ptr->x - src->x;
			relative_z = node_ptr->z - src->z<0 ? node_ptr->z - src->z + Z : node_ptr->z - src->z;
			if (relative_x > X / 2){
				if (relative_z > Z / 2){
					region2_count++;

				}
				else if (relative_z <= Z / 2 && relative_z > 0){
					region4_count++;
				}
				else if (relative_z == 0){
					region3_count++;
				}


			}
			else if (relative_x < X / 2){
				if (relative_z > Z / 2){
					region0_count++;

				}
				else if (relative_z <= Z / 2 && relative_z > 0){
					region6_count++;
				}
				else if (relative_z == 0){
					region7_count++;
				}

			}
			else{
				if (relative_z > Z / 2){
					region1_count++;

				}
				else if (relative_z <= Z / 2 && relative_z > 0){
					region5_count++;
				}



			}
			node_ptr = node_ptr->next;

		}

	}
	else if (direction == 2){
		while (node_ptr){
			relative_x = node_ptr->x - src->x<0 ? node_ptr->x - src->x + X : node_ptr->x - src->x;
			relative_y = node_ptr->y - src->y<0 ? node_ptr->y - src->y + Y : node_ptr->y - src->y;
			if (relative_x > X / 2){
				if (relative_y > Y / 2){
					region2_count++;

				}
				else if (relative_y <= Y / 2 && relative_y > 0){
					region4_count++;
				}
				else if (relative_y == 0){
					region3_count++;
				}


			}
			else if (relative_x < X / 2){
				if (relative_y > Y / 2){
					region0_count++;

				}
				else if (relative_y <= Y / 2 && relative_y > 0){
					region6_count++;
				}
				else if (relative_y == 0){
					region7_count++;
				}

			}
			else{
				if (relative_y > Y / 2){
					region1_count++;

				}
				else if (relative_y <= Y / 2 && relative_y > 0){
					region5_count++;
				}



			}
			node_ptr = node_ptr->next;

		}

	}
	return xpos_enable+xneg_enable+ypos_enable+yneg_enable+zpos_enable+zneg_enable;


}

void evaluate_partition(struct src_dst_list* node_list,struct chunk region){
	int src_x = node_list->x; 
	int src_y = node_list->y;
	int src_z = node_list->z;
	bool xpos, xneg, ypos, yneg, zpos, zneg; 
	struct src_dst_list* dst=node_list->next;
	int partition_along_xy_count;//if partition along xy plane, the count of the link outbound from the src
	int partition_along_yz_count;//if partition along yz plane, the count of the link outbound from the src
	int partition_along_zx_count;//if partition along zx plane, the count of the link outbound from the src
	bool xpos_enable = false;
	bool xneg_enable = false;
	bool ypos_enable = false;
	bool yneg_enable = false;
	bool zpos_enable = false;
	bool zneg_enable = false;
	
	struct src_dst_list* plane_dst_list;

	//first partition along yz plane, the entire src_dst_list will be divided into three parts: the nodes that are in the up chunk of the src node, 
	// the nodes that are in the downwards chunk of the src node, the nodes that in the same plane with the src node.
	plane_dst_list->x = src_x;
	plane_dst_list->y = src_y;
	plane_dst_list->z = src_z;
	plane_dst_list->next = NULL;
	plane_dst_list->src_or_dst = true;
	plane_dst_list->valid = true;
	struct src_dst_list* cur_plane_node;
	cur_plane_node = plane_dst_list;

	partition_along_yz_count = 0;
	xpos_enable = false;
	xneg_enable = false;

	while (dst){
		if (dst->x == src_x){
			//create the src-dst list on the yz plane
			//add the dst to the plane_dst_list
			struct src_dst_list* new_plane_node;
			if (!(new_plane_node = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			new_plane_node->x = dst->x;
			new_plane_node->y = dst->y;
			new_plane_node->z = dst->z;
			new_plane_node->next = NULL;
			new_plane_node->src_or_dst = false;
			new_plane_node->valid = true;
			cur_plane_node->next = new_plane_node;
			cur_plane_node = new_plane_node;
		
		}
		else if((dst->x>src_x && dst->x-src_x <= X/2)||(dst->x<src_x && src_x-dst->x>=X/2)){
			if (~xpos_enable){
				xpos_enable = true;
				partition_along_yz_count++;
			}
		}

		else if ((dst->x>src_x && dst->x - src_x > X / 2) || (dst->x < src_x && src_x - dst->x < X / 2)){
			if (~xneg_enable){
				xneg_enable = true;
				partition_along_yz_count++;
			}
		}
		dst = dst->next;	
	}

}



int main(){
	string filename = "C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/destination.txt";
	for (int i = 0; i < X; i++){
		for (int j = 0; j < Y; j++){
			for (int k = 0; k < Z; k++){
				x_link_counter[i][j][k] = 0;
				y_link_counter[i][j][k] = 0;
				z_link_counter[i][j][k] = 0;
			}
		}
	}
	return 0;
}
