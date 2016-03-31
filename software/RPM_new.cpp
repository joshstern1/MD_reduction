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

struct chunk{
	//data structure to express a divided chunk
	int x_downlim;
	int x_uplim;
	int y_downlim;
	int y_uplim;
	int z_downlim;
	int z_uplim;
	bool x_wrap(){
		return x_uplim + 1 == x_downlim || x_uplim + 1 - X == x_downlim;
	}
	bool y_wrap(){
		return y_uplim + 1 == y_downlim || y_uplim + 1 - Y == y_downlim;
	}
	bool z_wrap(){
		return z_uplim + 1 == z_downlim || z_uplim + 1 - Z == z_downlim;
	}

	int get_x_size(){
		if (x_downlim >= x_uplim){
			return x_downlim - x_uplim + 1;
		}
		else if (x_uplim>x_downlim){
			return X - x_uplim + x_downlim;
		}
	}
	int get_y_size(){
		if (y_downlim >= y_uplim){
			return y_downlim - y_uplim + 1;
		}
		else if (y_uplim>y_downlim){
			return Y - y_uplim + y_downlim;
		}
	}
	int get_z_size(){
		if (z_downlim >= z_uplim){
			return z_downlim - z_uplim + 1;
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

struct src_dst_list** src_list; 
int xpos_link_counter[X*Y*Z];
int ypos_link_counter[X*Y*Z];
int zpos_link_counter[X*Y*Z];
int xneg_link_counter[X*Y*Z];
int yneg_link_counter[X*Y*Z];
int zneg_link_counter[X*Y*Z];


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
int evaluate_plane(struct src_dst_list* src, struct chunk plane_trunk, int direction){
	//return the count of the fanout links on the plance
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
	int plane_X = plane_trunk.get_x_size();
	int plane_Y = plane_trunk.get_y_size();
	int plane_Z = plane_trunk.get_z_size();
	int x_dir;
	int y_dir;
	int z_dir;
	while (node_ptr){
		if (plane_trunk.x_wrap()){
			relative_x = node_ptr->x - src->x<0 ? node_ptr->x - src->x + X : node_ptr->x - src->x;
			if (relative_x> X / 2)
				x_dir = -1;
			else if (relative_x == 0)
				x_dir = 0;
			else
				x_dir = 1;
		}
		else{
			if (plane_trunk.x_downlim<plane_trunk.x_uplim){
				if (node_ptr->x>src->x)
					x_dir = 1;
				else if (node_ptr->x == src->x)
					x_dir = 0;
				else
					x_dir = -1;
			}
			else if (plane_trunk.x_downlim > plane_trunk.x_uplim){
				int src_x_relative_to_downlim;// the distance between src->y to the y downlim
				int node_ptr_x_relative_to_downlim; // the distance between node_ptr->y to the y downlim
				src_x_relative_to_downlim = (src->x >= plane_trunk.x_downlim) ? src_x - plane_trunk.x_downlim : src_x - plane_trunk.x_downlim + X;
				node_ptr_x_relative_to_downlim = (node_ptr->x >= plane_trunk.x_downlim) ? node_ptr->x - plane_trunk.x_downlim : node_ptr->x - plane_trunk.x_downlim + X;
				if (node_ptr_x_relative_to_downlim > src_x_relative_to_downlim)
					x_dir = 1;
				else if (node_ptr_x_relative_to_downlim < src_x_relative_to_downlim)
					x_dir = -1;
				else
					x_dir = 0;
			}
			else
				x_dir = 0;
		}
		if (plane_trunk.y_wrap()){
			relative_y = node_ptr->y - src->y<0 ? node_ptr->y - src->y + Y : node_ptr->y - src->y;
			if (relative_y> Y / 2)
				y_dir = -1;
			else if (relative_y == 0)
				y_dir = 0;
			else
				y_dir = 1;
		}
		else{
			if (plane_trunk.y_downlim<plane_trunk.y_uplim){
				if (node_ptr->y>src->y)
					y_dir = 1;
				else if (node_ptr->y == src->y)
					y_dir = 0;
				else
					y_dir = -1;
			}
			else if (plane_trunk.y_downlim > plane_trunk.y_uplim){
				int src_y_relative_to_downlim;// the distance between src->y to the y downlim
				int node_ptr_y_relative_to_downlim; // the distance between node_ptr->y to the y downlim
				src_y_relative_to_downlim = (src->y >= plane_trunk.y_downlim) ? src_y - plane_trunk.y_downlim : src_y - plane_trunk.y_downlim + Y;
				node_ptr_y_relative_to_downlim = (node_ptr->y >= plane_trunk.y_downlim) ? node_ptr->y - plane_trunk.y_downlim : node_ptr->y - plane_trunk.y_downlim + Y;
				if (node_ptr_y_relative_to_downlim > src_y_relative_to_downlim)
					y_dir = 1;
				else if (node_ptr_y_relative_to_downlim < src_y_relative_to_downlim)
					y_dir = -1;
				else
					y_dir = 0;
			}
			else
				y_dir = 0;
		}
		if (plane_trunk.z_wrap()){
			relative_z = node_ptr->z - src->z<0 ? node_ptr->z - src->z + Z : node_ptr->z - src->z;
			if (relative_z> Z / 2)
				z_dir = -1;
			else if (relative_z == 0)
				z_dir = 0;
			else
				z_dir = 1;
		}
		else{
			if (plane_trunk.z_downlim<plane_trunk.z_uplim){
				if (node_ptr->z>src->z)
					z_dir = 1;
				else if (node_ptr->z == src->z)
					z_dir = 0;
				else
					z_dir = -1;
			}
			else if (plane_trunk.z_downlim > plane_trunk.z_uplim){
				int src_z_relative_to_downlim;// the distance between src->y to the y downlim
				int node_ptr_z_relative_to_downlim; // the distance between node_ptr->y to the y downlim
				src_z_relative_to_downlim = (src->z >= plane_trunk.z_downlim) ? src_z - plane_trunk.z_downlim : src_z - plane_trunk.z_downlim + Z;
				node_ptr_z_relative_to_downlim = (node_ptr->z >= plane_trunk.z_downlim) ? node_ptr->z - plane_trunk.z_downlim : node_ptr->z - plane_trunk.z_downlim + Z;
				if (node_ptr_z_relative_to_downlim > src_z_relative_to_downlim)
					z_dir = 1;
				else if (node_ptr_z_relative_to_downlim < src_z_relative_to_downlim)
					z_dir = -1;
				else
					z_dir = 0;
			}
			else
				z_dir = 0;
		}

		if (direction == 0){
			if (y_dir == 1){
				if (z_dir == 1)
					region6_count++;
				else if (z_dir == 0)
					region7_count++;
				else if (z_dir == -1)
					region0_count++;
			}
			else if (y_dir == 0){
				if (z_dir == 1)
					region5_count++;

				else if (z_dir == -1)
					region1_count++;


			}
			else if (y_dir == -1){
				if (z_dir == 1)
					region4_count++;
				else if (z_dir == 0)
					region3_count++;
				else if (z_dir == -1)
					region2_count++;

			}
		}
		else if (direction == 1){
			if (x_dir == 1){
				if (z_dir == 1)
					region6_count++;
				else if (z_dir == 0)
					region7_count++;
				else if (z_dir == -1)
					region0_count++;
			}
			else if (x_dir == 0){
				if (z_dir == 1)
					region5_count++;

				else if (z_dir == -1)
					region1_count++;


			}
			else if (x_dir == -1){
				if (z_dir == 1)
					region4_count++;
				else if (z_dir == 0)
					region3_count++;
				else if (z_dir == -1)
					region2_count++;

			}
		}
		else if (direction == 2){
			if (x_dir == 1){
				if (y_dir == 1)
					region6_count++;
				else if (y_dir == 0)
					region7_count++;
				else if (y_dir == -1)
					region0_count++;
			}
			else if (x_dir == 0){
				if (y_dir == 1)
					region5_count++;

				else if (y_dir == -1)
					region1_count++;


			}
			else if (x_dir == -1){
				if (y_dir == 1)
					region4_count++;
				else if (y_dir == 0)
					region3_count++;
				else if (y_dir == -1)
					region2_count++;

			}
		}
	}

	if (direction == 0){
		if (region7_count > 0)
			ypos_enable = 1;
		if (region5_count > 0)
			zpos_enable = 1;
		if (region1_count > 0)
			yneg_enable = 1;
		if (region3_count > 0)
			zneg_enable = 1;
		if (region0_count > 0){
			if (zneg_enable == 0 && ypos_enable == 0){
				if (region2_count > 0 && region6_count == 0)
					zneg_enable = 1;
				else if (region2_count == 0 && region6_count > 0)
					ypos_enable = 1;
				else if (region2_count > 0 && region6_count > 0){
					//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
					int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int zneglink_id = src->x*Y*Z + src->y*Z + src->z - 1;
					if (ypos_link_counter[yposlink_id] <= zneg_link_counter[zneglink_id])
						ypos_enable = 1;
					else
						zneg_enable = 1;
				}	
			}
		}
		if (region2_count > 0){
			if (zneg_enable == 0 && yneg_enable == 0){
				if (region0_count > 0 && region4_count == 0)
					zneg_enable = 1;
				else if (region0_count == 0 && region4_count > 0)
					yneg_enable = 1;
				else if (region0_count > 0 && region4_count > 0){
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int yneglink_id = src->x*Y*Z + (src->y-1)*Z + src->z;
					int zneglink_id = src->x*Y*Z + src->y*Z + src->z - 1;
					if (yneg_link_counter[yneglink_id] <= zneg_link_counter[zneglink_id])
						yneg_enable = 1;
					else
						zneg_enable = 1;
				}
			}
		}
		if (region4_count > 0){
			if (zpos_enable == 0 && yneg_enable == 0){
				if (region6_count > 0 && region2_count == 0)
					zpos_enable = 1;
				else if (region6_count == 0 && region2_count > 0)
					yneg_enable = 1;
				else if (region6_count > 0 && region2_count > 0){
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int yneglink_id = src->x*Y*Z + (src->y - 1)*Z + src->z;
					int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (yneg_link_counter[yneglink_id] <= zpos_link_counter[zposlink_id])
						yneg_enable = 1;
					else
						zpos_enable = 1;
				}
			}
		}
		if (region6_count > 0){
			if (zpos_enable == 0 && ypos_enable == 0){
				if (region4_count > 0 && region0_count == 0)
					zpos_enable = 1;
				else if (region4_count == 0 && region0_count > 0)
					ypos_enable = 1;
				else if (region4_count > 0 && region0_count > 0){
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (ypos_link_counter[yposlink_id] <= zpos_link_counter[zposlink_id])
						ypos_enable = 1;
					else
						zpos_enable = 1;
				}
			}
		}

	}
	if (direction == 1){
		if (region7_count > 0)
			xpos_enable = 1;
		if (region5_count > 0)
			zpos_enable = 1;
		if (region1_count > 0)
			xneg_enable = 1;
		if (region3_count > 0)
			zneg_enable = 1;
		if (region0_count > 0){
			if (zneg_enable == 0 && xpos_enable == 0){
				if (region2_count > 0 && region6_count == 0)
					zneg_enable = 1;
				else if (region2_count == 0 && region6_count > 0)
					xpos_enable = 1;
				else if (region2_count > 0 && region6_count > 0){
					//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
					int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int zneglink_id = src->x*Y*Z + src->y*Z + src->z - 1;
					if (xpos_link_counter[xposlink_id] <= zneg_link_counter[zneglink_id])
						xpos_enable = 1;
					else
						zneg_enable = 1;
				}
			}
		}
		if (region2_count > 0){
			if (zneg_enable == 0 && xneg_enable == 0){
				if (region0_count > 0 && region4_count == 0)
					zneg_enable = 1;
				else if (region0_count == 0 && region4_count > 0)
					xneg_enable = 1;
				else if (region0_count > 0 && region4_count > 0){
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xneglink_id = (src->x-1)*Y*Z + src->y*Z + src->z;
					int zneglink_id = src->x*Y*Z + src->y*Z + src->z - 1;
					if (xneg_link_counter[xneglink_id] <= zneg_link_counter[zneglink_id])
						xneg_enable = 1;
					else
						zneg_enable = 1;
				}
			}
		}
		if (region4_count > 0){
			if (zpos_enable == 0 && xneg_enable == 0){
				if (region6_count > 0 && region2_count == 0)
					zpos_enable = 1;
				else if (region6_count == 0 && region2_count > 0)
					xneg_enable = 1;
				else if (region6_count > 0 && region2_count > 0){
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xneglink_id = (src->x-1)*Y*Z + src->y*Z + src->z;
					int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (xneg_link_counter[xneglink_id] <= zpos_link_counter[zposlink_id])
						xneg_enable = 1;
					else
						zpos_enable = 1;
				}
			}
		}
		if (region6_count > 0){
			if (xpos_enable == 0 && zpos_enable == 0){
				if (region4_count > 0 && region0_count == 0)
					xpos_enable = 1;
				else if (region4_count == 0 && region0_count > 0)
					zpos_enable = 1;
				else if (region4_count > 0 && region0_count > 0){
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (zpos_link_counter[zposlink_id] <= xpos_link_counter[xposlink_id])
						zpos_enable = 1;
					else
						xpos_enable = 1;
				}
			}
		}

	}
	if (direction == 2){
		if (region7_count > 0)
			xpos_enable = 1;
		if (region5_count > 0)
			ypos_enable = 1;
		if (region1_count > 0)
			xneg_enable = 1;
		if (region3_count > 0)
			yneg_enable = 1;
		if (region0_count > 0){
			if (yneg_enable == 0 && xpos_enable == 0){
				if (region2_count > 0 && region6_count == 0)
					yneg_enable = 1;
				else if (region2_count == 0 && region6_count > 0)
					xpos_enable = 1;
				else if (region2_count > 0 && region6_count > 0){
					//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
					int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int yneglink_id = src->x*Y*Z + (src->y-1)*Z + src->z;
					if (xpos_link_counter[xposlink_id] <= yneg_link_counter[yneglink_id])
						xpos_enable = 1;
					else
						yneg_enable = 1;
				}
			}
		}
		if (region2_count > 0){
			if (yneg_enable == 0 && xneg_enable == 0){
				if (region0_count > 0 && region4_count == 0)
					yneg_enable = 1;
				else if (region0_count == 0 && region4_count > 0)
					xneg_enable = 1;
				else if (region0_count > 0 && region4_count > 0){
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xneglink_id = (src->x - 1)*Y*Z + src->y*Z + src->z;
					int yneglink_id = src->x*Y*Z + (src->y-1)*Z + src->z;
					if (xneg_link_counter[xneglink_id] <= yneg_link_counter[yneglink_id])
						xneg_enable = 1;
					else
						yneg_enable = 1;
				}
			}
		}
		if (region4_count > 0){
			if (ypos_enable == 0 && xneg_enable == 0){
				if (region6_count > 0 && region2_count == 0)
					ypos_enable = 1;
				else if (region6_count == 0 && region2_count > 0)
					xneg_enable = 1;
				else if (region6_count > 0 && region2_count > 0){
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xneglink_id = (src->x - 1)*Y*Z + src->y*Z + src->z;
					int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (xneg_link_counter[xneglink_id] <= ypos_link_counter[yposlink_id])
						xneg_enable = 1;
					else
						ypos_enable = 1;
				}
			}
		}
		if (region6_count > 0){
			if (xpos_enable == 0 && ypos_enable == 0){
				if (region4_count > 0 && region0_count == 0)
					xpos_enable = 1;
				else if (region4_count == 0 && region0_count > 0)
					ypos_enable = 1;
				else if (region4_count > 0 && region0_count > 0){
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (ypos_link_counter[yposlink_id] <= xpos_link_counter[xposlink_id])
						ypos_enable = 1;
					else
						xpos_enable = 1;
				}
			}
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
	int xpos_enable = 0;
	int xneg_enable = 0;
	int ypos_enable = 0;
	int yneg_enable = 0;
	int zpos_enable = 0;
	int zneg_enable = 0;
	
	struct src_dst_list* plane_dst_list;
	struct chunk plane_chunk;

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

	plane_chunk.x_downlim = src_x;
	plane_chunk.x_uplim = src_x;
	plane_chunk.y_downlim = region.y_downlim;
	plane_chunk.y_uplim = region.y_uplim;
	plane_chunk.z_downlim = region.z_downlim;
	plane_chunk.z_uplim = region.z_uplim;


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
		else{
			// now determine the dst should be reached from xpos or xneg
			if (region.x_wrap()){
				if (dst->x > src_x){
					if (dst->x - src_x <= X / 2){
						xpos_enable = 1;
						partition_along_yz_count++;
					}
					else{
						xneg_enable = 1;
						partition_along_yz_count++;
					}
				}
				else{
					if (src_x - dst->x < X / 2){
						xneg_enable = 1;
						partition_along_yz_count++;
					}
					else{
						xpos_enable = 1;
						partition_along_yz_count++;
					}
					

				}
			}
			else{
				if (region.x_downlim<region.x_uplim){
					if (dst->x>src_x){
						xpos_enable = 1;
						partition_along_yz_count++;
					}
					else{
						xneg_enable = 1;
						partition_along_yz_count++;
					}

				}
				else if (region.x_downlim > region.x_uplim){
					int xdistance_between_src_downlim = (src_x >= region.x_downlim) ? (src_x - region.x_downlim) : (src_x - region.x_downlim + X);
					int xdistance_between_dst_downlim = (dst->x >= region.x_downlim) ? (dst->x - region.x_downlim) : (dst->x - region.x_downlim + X);
					if (xdistance_between_src_downlim < xdistance_between_dst_downlim){
						xpos_enable = 1;
						partition_along_yz_count++;
					}
					else{
						xneg_enable = 1;
						partition_along_yz_count++;
					}


				}


			}

		}




		dst = dst->next;	
	}
	patition_along_yz_count += evaluate_plane(plane_dst_list,)

}



int main(){
	string filename = "C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/destination.txt";
	for (int i = 0; i < X; i++){
		for (int j = 0; j < Y; j++){
			for (int k = 0; k < Z; k++){
				xpos_link_counter[i*Y*Z+j*Z+k] = 0;
				ypos_link_counter[i*Y*Z + j*Z + k] = 0;
				zpos_link_counter[i*Y*Z + j*Z + k] = 0;
				xneg_link_counter[i*Y*Z + j*Z + k] = 0;
				yneg_link_counter[i*Y*Z + j*Z + k] = 0;
				zneg_link_counter[i*Y*Z + j*Z + k] = 0;
			}
		}
	}
	return 0;
}
