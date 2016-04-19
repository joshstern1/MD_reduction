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
#define MAX_NUM_CHILDREN 6


#include<iostream>
#include<fstream>
#include<string>
using namespace std;



ofstream fout;



class node{
public:
	int x;
	int y;
	int z;
	int weight; // the children in the same level share the same weight
	int num_children;
//	int incoming_port_num; // the port num where the packet where come from, could be LOCAL, XPOS, XNEG, YPOS, YNEG, ZPOS, ZNEG
	int depth;//root is 0
	node* parent;
	node* children[MAX_NUM_CHILDREN];
	node(int x_val, int y_val, int z_val, int w_val){
		x = x_val;
		y = y_val;
		z = z_val;
		weight = w_val;
		parent = NULL;
		depth = 0;
		for (int i = 0; i < MAX_NUM_CHILDREN; ++i)
			children[i] = NULL;
		num_children = 0;
//		incoming_port_num = LOCAL; // init as LOCAL first.

	}
};

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
		if (x_downlim <= x_uplim){
			return x_uplim - x_downlim + 1;
		}
		else {
			return X + x_uplim - x_downlim+1;
		}
	}
	int get_y_size(){
		if (y_downlim <= y_uplim){
			return y_uplim - y_downlim + 1;
		}
		else {
			return Y + y_uplim - y_downlim+1;
		}
	}
	int get_z_size(){
		if (z_downlim <= z_uplim){
			return z_uplim - z_downlim + 1;
		}
		else {
			return Z + z_uplim - z_downlim+1;
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


struct plane_evaluation{
	int xpos_enable;
	int xneg_enable;
	int ypos_enable;
	int yneg_enable;
	int zpos_enable;
	int zneg_enable;
	int region0_merge;
	int region2_merge;
	int region4_merge;
	int region6_merge;
};


struct src_dst_list** src_list; 
int xpos_link_counter[X*Y*Z];
int ypos_link_counter[X*Y*Z];
int zpos_link_counter[X*Y*Z];
int xneg_link_counter[X*Y*Z];
int yneg_link_counter[X*Y*Z];
int zneg_link_counter[X*Y*Z];


int global_partition_rr_choice;


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
	if (!(src_list = (struct src_dst_list**)malloc(X*Y*Z*sizeof(struct src_dst_list*)))){
		cout << "No mem" << endl;
		exit(-1);
	}
	for(int i=0;i<X*Y*Z;i++){
		if(!(src_list[i]=(struct src_dst_list*) malloc(sizeof(struct src_dst_list)))){
			cout<<"no mem"<<endl;
			exit(-1);
		}
	}
	for (int i = 0; i < X*Y*Z; i++){
		src_list[i]->valid = false;
	}
	while (!input_file.eof()){
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

void accumulate_link(struct node* head, struct node* tail){
	if(head->y == tail->y && head->z == tail->z){
		if(head->x+1== tail->x || (head->x==X-1 && tail->x==0)){
			xpos_link_counter[head->x*Y*Z+head->y*Z+head->z]++;
		}
		else if(tail->x+1==head->x || (tail->x==X-1 && head->x==0)){
			xneg_link_counter[tail->x*Y*Z+tail->y*Z+tail->z]++;
		}
	}
	else if(head->x == tail->x && head->z == tail->z){
		if(head->y+1== tail->y || (head->y==Y-1 && tail->y==0)){
			ypos_link_counter[head->x*Y*Z+head->y*Z+head->z]++;
		}
		else if(tail->y+1==head->y || (tail->y==Y-1 && head->y==0)){
			yneg_link_counter[tail->x*Y*Z+tail->y*Z+tail->z]++;
		}
	}
	else if(head->y == tail->y && head->x == tail->x){
		if(head->z+1== tail->z || (head->z==Z-1 && tail->z==0)){
			zpos_link_counter[head->x*Y*Z+head->y*Z+head->z]++;
		}
		else if(tail->z+1==head->z || (tail->z==Z-1 && head->z==0)){
			zneg_link_counter[tail->x*Y*Z+tail->y*Z+tail->z]++;
		}
	}

}
inline double square(double x){
	return x*x;
}

double six_link_variance_delta(struct src_dst_list* src, bool xpos_enable, bool xneg_enable, bool ypos_enable, bool yneg_enable, bool zpos_enable, bool zneg_enable){
	int xpos_counter = xpos_link_counter[src->x*Y*Z + src->y*Z + src->z];
	int negx = src->x - 1 < 0 ? X - 1 : src->x - 1;
	int xneg_counter = xneg_link_counter[negx*Y*Z+src->y*Z+src->z];
	int ypos_counter = ypos_link_counter[src->x*Y*Z + src->y*Z + src->z];
	int negy = src->y - 1 < 0 ? Y - 1 : src->y - 1;
	int yneg_counter = yneg_link_counter[src->x*Y*Z + negy*Z + src->z];
	int zpos_counter = zpos_link_counter[src->x*Y*Z + src->y*Z + src->z];
	int negz = src->z - 1 < 0 ? Z - 1 : src->z - 1;
	int zneg_counter = zneg_link_counter[src->x*Y*Z + src->y*Z + negz];
	if (xpos_enable){
		xpos_counter++;
	}
	if (xneg_enable){
		xneg_counter++;
	}
	if (ypos_enable){
		ypos_counter++;
	}
	if (yneg_enable){
		yneg_counter++;

	}
	if (zpos_enable){
		zpos_counter++;
	}
	if (zneg_enable){
		zneg_counter++;
	}
	double avg = (xpos_counter + xneg_counter + ypos_counter + yneg_counter + zpos_counter + zneg_counter) / 6.0;

	double ret;
	ret = square(xpos_counter - avg) + square(ypos_counter - avg) + square(zpos_counter - avg) + square(xneg_counter - avg) + square(yneg_counter - avg) + square(zneg_counter - avg);

	return ret;



	
}

bool within_range(struct chunk Chunk, struct src_dst_list* node){
	bool x_within_range = false;
	bool y_within_range = false;
	bool z_within_range = false;
	if (Chunk.x_downlim < Chunk.x_uplim){
		if (node->x >= Chunk.x_downlim && node->x <= Chunk.x_uplim){
			x_within_range = true;
		}
	}
	else if (Chunk.x_downlim>Chunk.x_uplim){
		if (node->x >= Chunk.x_downlim || node->x <= Chunk.x_uplim){
			x_within_range = true;
		}
	}
	else{
		if (node->x == Chunk.x_downlim){
			x_within_range = true;
		}
	}
	if (Chunk.y_downlim < Chunk.y_uplim){
		if (node->y >= Chunk.y_downlim && node->y <= Chunk.y_uplim){
			y_within_range = true;
		}
	}
	else if (Chunk.y_downlim>Chunk.y_uplim){
		if (node->y >= Chunk.y_downlim || node->y <= Chunk.y_uplim){
			y_within_range = true;
		}
	}
	else{
		if (node->y == Chunk.y_downlim){
			y_within_range = true;
		}
	}
	if (Chunk.z_downlim < Chunk.z_uplim){
		if (node->z >= Chunk.z_downlim && node->z <= Chunk.z_uplim){
			z_within_range = true;
		}
	}
	else if (Chunk.z_downlim>Chunk.z_uplim){
		if (node->z >= Chunk.z_downlim || node->z <= Chunk.z_uplim){
			z_within_range = true;
		}
	}
	else{
		if (node->z == Chunk.z_downlim){
			z_within_range = true;
		}
	}

	return x_within_range && y_within_range && z_within_range;

	
	
}
struct plane_evaluation evaluate_plane(struct src_dst_list* src, struct chunk plane_trunk, int direction){
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

	//there are six possible partition method
	// method 0
	// ____________________
	// |                  |
    // |                  |
    // |__________________|
	// |________S_________|
	// |                  |
	// |                  |
	// |__________________|

	// method 1
	// ____________________
	// |                  |
	// |                  |
	// |__________________|
	// |________S_________|
	// |                  |
	// |                  |
	// |__________________|
	
	// method 2
	// ____________________
	// |       | |        |
	// |       | |        |
	// |       | |        |
	// |_______|S|________|
	// |                  |
	// |                  |
	// |__________________|




	//region0 2 4 and 6 may be merged into 1 3 5 7
	int region0_merge=2;//0 means merging to 1, 1 means merging to 7, 2 means dont use
	int region2_merge=2;//0 means merging to 3, 1 means merging to 1, 2 means dont use
	int region4_merge=2;//0 means merging to 5, 1 means merging to 3, 2 means dont use
	int region6_merge=2;//0 means merging to 7, 1 means merging to 5, 2 means dont use




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
		node_ptr = node_ptr->next;
	}

	if (direction == 0){
		if (region7_count > 0)
			ypos_enable = 1;
		if (region5_count > 0)
			zpos_enable = 1;
		if (region3_count > 0)
			yneg_enable = 1;
		if (region1_count > 0)
			zneg_enable = 1;
		if (region0_count > 0){
			if (zneg_enable == 0 && ypos_enable == 0){
				if (region2_count > 0 && region6_count == 0){
					zneg_enable = 1;
					region0_merge = 0;
				}
				else if (region2_count == 0 && region6_count > 0){
					ypos_enable = 1;
					region0_merge = 1;
				}
				else{
					//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
					int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int zneglink_id = src->x*Y*Z + src->y*Z + (src->z - 1<0?Z-1:src->z-1);
					if (ypos_link_counter[yposlink_id] <= zneg_link_counter[zneglink_id]){
						ypos_enable = 1;
						region0_merge = 1;
					}
					else{
						zneg_enable = 1;
						region0_merge = 0;
					}
				}	
			}
			else if (zneg_enable==0 && ypos_enable==1){
				region0_merge = 1;
			}
			else if (zneg_enable == 1 && ypos_enable == 0){
				region0_merge = 0;
			}
			else{
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
				int zneglink_id = src->x*Y*Z + src->y*Z + (src->z - 1<0 ? Z - 1 : src->z - 1);
				if (ypos_link_counter[yposlink_id] <= zneg_link_counter[zneglink_id]){
					
					region0_merge = 1;
				}
				else{

					region0_merge = 0;
				}
			}
		}
		if (region2_count > 0){
			if (zneg_enable == 0 && yneg_enable == 0){
				if (region0_count > 0 && region4_count == 0){
					zneg_enable = 1;
					region2_merge = 1;
				}
				else if (region0_count == 0 && region4_count > 0){
					yneg_enable = 1;
					region2_merge = 0;
				}
				else{
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int yneglink_id = src->x*Y*Z + (src->y-1<0?Y-1:src->y-1)*Z + src->z;
					int zneglink_id = src->x*Y*Z + src->y*Z + (src->z - 1<0?Z-1:src->z-1);
					if (yneg_link_counter[yneglink_id] <= zneg_link_counter[zneglink_id]){
						yneg_enable = 1;
						region2_merge = 0;
					}
					else{
						zneg_enable = 1;
						region2_merge = 1;
					}
				}
			}
			else if (zneg_enable == 0 && yneg_enable == 1){
				region2_merge = 0;
			}
			else if (zneg_enable == 1 && yneg_enable == 0){
				region2_merge = 1;
			}
			else if(region0_merge==1){ //zneg and yneg are both enabled
				region2_merge=1; // otherwise region1 will be covered by no one
			}
			else if(region0_merge==0){
				region2_merge=1;//region0,1,2 shoud be together
			}
			else{//regoin0 is not used
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int yneglink_id = src->x*Y*Z +(src->y - 1<0 ? Y - 1 : src->y - 1)*Z + src->z;
				int zneglink_id = src->x*Y*Z + src->y*Z + (src->z - 1<0 ? Z - 1 : src->z - 1);
				if (yneg_link_counter[yneglink_id] <= zneg_link_counter[zneglink_id]){
					
					region2_merge = 0;
				}
				else{
					region2_merge = 1;
				}
			}
		}
		if (region4_count > 0){
			if (zpos_enable == 0 && yneg_enable == 0){
				if (region6_count > 0 && region2_count == 0){
					zpos_enable = 1;
					region4_merge = 0;
				}
				else if (region6_count == 0 && region2_count > 0){
					yneg_enable = 1;
					region4_merge = 1;
				}
				else{
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int yneglink_id = src->x*Y*Z + (src->y - 1<0?Y-1:src->y-1)*Z + src->z;
					int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (yneg_link_counter[yneglink_id] <= zpos_link_counter[zposlink_id]){
						yneg_enable = 1;
						region4_merge = 1;
					}
					else{
						zpos_enable = 1;
						region4_merge = 0;
					}
				}

			}
			else if (zpos_enable == 0 && yneg_enable == 1){
				region4_merge = 1;
			}
			else if (zpos_enable == 1 && yneg_enable == 0){
				region4_merge = 0;
			}
			else if(region2_merge==1){ //zpos and yneg are both enabled
				region4_merge=1; // otherwise region1 will be covered by no one
			}
			else if(region2_merge==0){
				region4_merge=1;//region2,3,4 shoud be together
			}
			else{
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int yneglink_id = src->x*Y*Z + (src->y - 1<0 ? Y - 1 : src->y - 1)*Z + src->z;
				int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
				if (yneg_link_counter[yneglink_id] <= zpos_link_counter[zposlink_id]){

					region4_merge = 1;
				}
				else{
					region4_merge = 0;
				}
			}
		}
		if (region6_count > 0){
			if (zpos_enable == 0 && ypos_enable == 0){
				if (region4_count > 0 && region0_count == 0){
					zpos_enable = 1;
					region6_merge = 1;
				}
				else if (region4_count == 0 && region0_count > 0){
					ypos_enable = 1;
					region6_merge = 0;
				}
				else{
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (ypos_link_counter[yposlink_id] <= zpos_link_counter[zposlink_id]){
						ypos_enable = 1;
						region6_merge = 0;
					}
					else{
						zpos_enable = 1;
						region6_merge = 1;
					}
				}
			}
			else if (zpos_enable == 0 && ypos_enable == 1){
				region6_merge = 0;
			}
			else if (zpos_enable == 1 && ypos_enable == 0){
				region6_merge = 1;
			}
			else if(region4_merge==1){ //zpos and ypos are both enabled
				region6_merge=1; // otherwise region5 will be covered by no one
			}
			else if(region4_merge==0){
				region6_merge=1;//region4,5,6 shoud be together
			}
			else{
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
				int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
				if (zpos_link_counter[zposlink_id] <= ypos_link_counter[yposlink_id]){
					
					region6_merge = 1;
				}
				else{

					region6_merge = 0;
				}
			}
		}

	}
	if (direction == 1){
		if (region7_count > 0)
			xpos_enable = 1;
		if (region5_count > 0)
			zpos_enable = 1;
		if (region3_count > 0)
			xneg_enable = 1;
		if (region1_count > 0)
			zneg_enable = 1;
		if (region0_count > 0){
			if (zneg_enable == 0 && xpos_enable == 0){
				if (region2_count > 0 && region6_count == 0){
					zneg_enable = 1;
					region0_merge = 0;
				}
				else if (region2_count == 0 && region6_count > 0){
					xpos_enable = 1;
					region0_merge = 1;
				}
				else{
					//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
					int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int zneglink_id = src->x*Y*Z + src->y*Z + (src->z - 1<0?Z-1:src->z-1);
					if (xpos_link_counter[xposlink_id] <= zneg_link_counter[zneglink_id]){
						xpos_enable = 1;
						region0_merge = 1;
					}
					else{
						zneg_enable = 1;
						region0_merge = 0;
					}
				}
			}
			else if (zneg_enable==0 && xpos_enable==1){
				region0_merge = 1;
			}
			else if (zneg_enable == 1 && xpos_enable == 0){
				region0_merge = 0;
			}
			else{
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
				int zneglink_id = src->x*Y*Z + src->y*Z + (src->z - 1<0 ? Z - 1 : src->z - 1);
				if (xpos_link_counter[xposlink_id] <= zneg_link_counter[zneglink_id]){
					
					region0_merge = 1;
				}
				else{

					region0_merge = 0;
				}
			}
		}
		if (region2_count > 0){
			if (zneg_enable == 0 && xneg_enable == 0){
				if (region0_count > 0 && region4_count == 0){
					zneg_enable = 1;
					region2_merge = 1;
				}
				else if (region0_count == 0 && region4_count > 0){
					xneg_enable = 1;
					region2_merge = 0;
				}
				else{
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xneglink_id = (src->x-1<0?X-1:src->x-1)*Y*Z + src->y*Z + src->z;
					int zneglink_id = src->x*Y*Z + src->y*Z + (src->z - 1<0?Z-1:src->z-1);
					if (xneg_link_counter[xneglink_id] <= zneg_link_counter[zneglink_id]){
						xneg_enable = 1;
						region2_merge = 0;
					}
					else{
						zneg_enable = 1;
						region2_merge = 1;
					}
				}
			}
			else if (zneg_enable == 0 && xneg_enable == 1){
				region2_merge = 0;
			}
			else if (zneg_enable == 1 && xneg_enable == 0){
				region2_merge = 1;
			}
			else if(region0_merge==1){ //zpos and xneg are both enabled
				region2_merge=1; // otherwise region1 will be covered by no one
			}
			else if(region0_merge==0){
				region2_merge=1;//region0,1,2 shoud be together
			}
			else{
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int xneglink_id = (src->x - 1<0 ? X - 1 : src->x - 1)*Y*Z + src->y*Z + src->z;
				int zneglink_id = src->x*Y*Z + src->y*Z + (src->z - 1<0 ? Z - 1 : src->z - 1);
				if (xneg_link_counter[xneglink_id] <= zneg_link_counter[zneglink_id]){
					
					region2_merge = 0;
				}
				else{
					region2_merge = 1;
				}
			}
		}
		if (region4_count > 0){
			if (zpos_enable == 0 && xneg_enable == 0){
				if (region6_count > 0 && region2_count == 0){
					zpos_enable = 1;
					region4_merge = 0;
				}
				else if (region6_count == 0 && region2_count > 0){
					xneg_enable = 1;
					region4_merge = 1;
				}
				else{
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xneglink_id = (src->x-1<0?X-1:src->x-1)*Y*Z + src->y*Z + src->z;
					int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (xneg_link_counter[xneglink_id] <= zpos_link_counter[zposlink_id]){
						xneg_enable = 1;
						region4_merge = 1;
					}
					else{
						zpos_enable = 1;
						region4_merge = 0;
					}
				}
			}
			else if (zpos_enable == 0 && xneg_enable == 1){
				region4_merge = 1;
			}
			else if (zpos_enable == 1 && xneg_enable == 0){
				region4_merge = 0;
			}
			else if(region2_merge==1){ //zpos and xneg are both enabled
				region4_merge=1; // otherwise region3 will be covered by no one
			}
			else if(region2_merge==0){
				region4_merge=1;//region2,3,4 shoud be together
			}
			else{
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int xneglink_id = (src->x - 1<0 ? X - 1 : src->x - 1)*Y*Z + src->y*Z + src->z;
				int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
				if (xneg_link_counter[xneglink_id] <= zpos_link_counter[zposlink_id]){

					region4_merge = 1;
				}
				else{
					region4_merge = 0;
				}
			}
		}
		if (region6_count > 0){
			if (xpos_enable == 0 && zpos_enable == 0){
				if (region4_count > 0 && region0_count == 0){
					zpos_enable = 1;
					region6_merge = 1;
				}
				else if (region4_count == 0 && region0_count > 0){
					xpos_enable = 1;
					region6_merge = 0;
				}
				else{
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (zpos_link_counter[zposlink_id] <= xpos_link_counter[xposlink_id]){
						zpos_enable = 1;
						region6_merge = 1;
					}
					else{
						xpos_enable = 1;
						region6_merge = 1;
					}
				}

			}
			else if (zpos_enable == 0 && xpos_enable == 1){
				region6_merge = 0;
			}
			else if (zpos_enable == 1 && xpos_enable == 0){
				region6_merge = 1;
			}
			else if(region4_merge==1){ //zpos and xneg are both enabled
				region6_merge=1; // otherwise region3 will be covered by no one
			}
			else if(region4_merge==0){
				region6_merge=1;//region2,3,4 shoud be together
			}
			else{
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
				int zposlink_id = src->x*Y*Z + src->y*Z + src->z;
				if (zpos_link_counter[zposlink_id] <= xpos_link_counter[xposlink_id]){
					
					region6_merge = 1;
				}
				else{

					region6_merge = 0;
				}
			}
		}

	}
	if (direction == 2){
		if (region7_count > 0)
			xpos_enable = 1;
		if (region5_count > 0)
			ypos_enable = 1;
		if (region3_count > 0)
			xneg_enable = 1;
		if (region1_count > 0)
			yneg_enable = 1;
		if (region0_count > 0){
			if (yneg_enable == 0 && xpos_enable == 0){
				if (region2_count > 0 && region6_count == 0){
					yneg_enable = 1;
					region0_merge = 0;
				}
				else if (region2_count == 0 && region6_count > 0){
					xpos_enable = 1;
					region0_merge = 1;
				}
				else{
					//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
					int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int yneglink_id = src->x*Y*Z + (src->y-1<0?Y-1:src->y-1)*Z + src->z;
					if (xpos_link_counter[xposlink_id] <= yneg_link_counter[yneglink_id]){
						xpos_enable = 1;
						region0_merge = 1;
					}
					else{
						yneg_enable = 1;
						region0_merge = 0;
					}
				}

			}
			else if (yneg_enable==0 && xpos_enable==1){
				region0_merge = 1;
			}
			else if (yneg_enable == 1 && xpos_enable == 0){
				region0_merge = 0;
			}
			else{
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
				int yneglink_id = src->x*Y*Z + (src->y - 1<0 ? Y - 1 : src->y - 1)*Z + src->z;
				if (xpos_link_counter[xposlink_id] <= yneg_link_counter[yneglink_id]){
					
					region0_merge = 1;
				}
				else{

					region0_merge = 0;
				}
			}
		}
		if (region2_count > 0){
			if (yneg_enable == 0 && xneg_enable == 0){
				if (region0_count > 0 && region4_count == 0){
					yneg_enable = 1;
					region2_merge = 1;
				}
				else if (region0_count == 0 && region4_count > 0){
					xneg_enable = 1;
					region2_merge = 0;
				}
				else{
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xneglink_id = (src->x - 1<0?X-1:src->x-1)*Y*Z + src->y*Z + src->z;
					int yneglink_id = src->x*Y*Z + (src->y-1<0?Y-1:src->y-1)*Z + src->z;
					if (xneg_link_counter[xneglink_id] <= yneg_link_counter[yneglink_id]){
						xneg_enable = 1;
						region2_merge = 0;
					}
					else{
						yneg_enable = 1;
						region2_merge = 1;
					}
				}
			}
			else if (yneg_enable == 0 && xneg_enable == 1){
				region2_merge = 0;
			}
			else if (yneg_enable == 1 && xneg_enable == 0){
				region2_merge = 1;
			}
			else if(region0_merge==1){ //yneg and xneg are both enabled
				region2_merge=1; // otherwise region1 will be covered by no one
			}
			else if(region0_merge==0){
				region2_merge=1;//region0,1,2 shoud be together
			}
			else{
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int xneglink_id = (src->x - 1<0 ? X - 1 : src->x - 1)*Y*Z + src->y*Z + src->z;
				int yneglink_id = src->x*Y*Z + (src->y - 1<0 ? Y - 1 : src->y - 1)*Z + src->z;
				if (xneg_link_counter[xneglink_id] <= yneg_link_counter[yneglink_id]){
					
					region2_merge = 0;
				}
				else{
					region2_merge = 1;
				}
			}
		}
		if (region4_count > 0){
			if (ypos_enable == 0 && xneg_enable == 0){
				if (region6_count > 0 && region2_count == 0){
					ypos_enable = 1;
					region4_merge = 0;
				}
				else if (region6_count == 0 && region2_count > 0){
					xneg_enable = 1;
					region4_merge = 1;
				}
				else{
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xneglink_id = (src->x - 1<0?X-1:src->x-1)*Y*Z + src->y*Z + src->z;
					int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (xneg_link_counter[xneglink_id] <= ypos_link_counter[yposlink_id]){
						xneg_enable = 1;
						region4_merge = 1;
					}
					else{
						ypos_enable = 1;
						region4_merge = 1;
					}
				}
			}
			else if (ypos_enable == 0 && xneg_enable == 1){
				region4_merge = 1;
			}
			else if (ypos_enable == 1 && xneg_enable == 0){
				region4_merge = 0;
			}
			else if(region2_merge==1){ //ypos and xneg are both enabled
				region4_merge=1; // otherwise region1 will be covered by no one
			}
			else if(region2_merge==0){
				region4_merge=1;//region2,3,4 shoud be together
			}
			else{
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int xneglink_id = (src->x - 1<0 ? X - 1 : src->x - 1)*Y*Z + src->y*Z + src->z;
				int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
				if (xneg_link_counter[xneglink_id] <= ypos_link_counter[yposlink_id]){

					region4_merge = 1;
				}
				else{
					region4_merge = 0;
				}
			}
		}
		if (region6_count > 0){
			if (xpos_enable == 0 && ypos_enable == 0){
				if (region4_count > 0 && region0_count == 0){
					xpos_enable = 1;
					region6_merge = 1;
				}
				else if (region4_count == 0 && region0_count > 0){
					ypos_enable = 1;
					region6_merge = 0;
				}
				else{
					//at this point, the selection between the zneg and yneg is decided by the link count of the zneg and yneg
					int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
					int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
					if (ypos_link_counter[yposlink_id] <= xpos_link_counter[xposlink_id]){
						ypos_enable = 1;
						region6_merge = 0;
					}
					else{
						xpos_enable = 1;
						region6_merge = 1;
					}
				}
			}
			else if (ypos_enable == 0 && xpos_enable == 1){
				region6_merge = 0;
			}
			else if (ypos_enable == 1 && xpos_enable == 0){
				region6_merge = 1;
			}
			else if(region4_merge==1){ //ypos and xneg are both enabled
				region6_merge=1; // otherwise region5 will be covered by no one
			}
			else if(region4_merge==0){
				region6_merge=1;//region4,5,6 shoud be together
			}
			else{
				//at this point, the selection between the zneg and ypos is decided by the link count of the zneg and ypos
				int xposlink_id = src->x*Y*Z + src->y*Z + src->z;
				int yposlink_id = src->x*Y*Z + src->y*Z + src->z;
				if (ypos_link_counter[yposlink_id] <= xpos_link_counter[xposlink_id]){
					
					region6_merge = 1;
				}
				else{

					region6_merge = 0;
				}
			}
		}

	}
	struct plane_evaluation ret;
	
	ret.region0_merge = region0_merge;
	ret.region2_merge = region2_merge;
	ret.region4_merge = region4_merge;
	ret.region6_merge = region6_merge;
	ret.xpos_enable = xpos_enable;
	ret.xneg_enable = xneg_enable;
	ret.ypos_enable = ypos_enable;
	ret.yneg_enable = yneg_enable;
	ret.zpos_enable = zpos_enable;
	ret.zneg_enable = zneg_enable;
	

	

	


	return ret;


}

int evaluate_partition(struct src_dst_list* node_list,struct chunk region){
	int src_x = node_list->x; 
	int src_y = node_list->y;
	int src_z = node_list->z;
	bool xpos, xneg, ypos, yneg, zpos, zneg; 
	struct src_dst_list* dst=node_list->next;
	int partition_along_xy_count;//if partition along xy plane, the count of the link outbound from the src
	int partition_along_yz_count;//if partition along yz plane, the count of the link outbound from the src
	int partition_along_xz_count;//if partition along zx plane, the count of the link outbound from the src
	int xpos_enable = 0;
	int xneg_enable = 0;
	int ypos_enable = 0;
	int yneg_enable = 0;
	int zpos_enable = 0;
	int zneg_enable = 0;
	
	

	//first partition along yz plane, the entire src_dst_list will be divided into three parts: the nodes that are in the up chunk of the src node, 
	// the nodes that are in the downwards chunk of the src node, the nodes that in the same plane with the src node.
	struct src_dst_list* yz_plane_dst_list;
	if (!(yz_plane_dst_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
		cout << "no mem" << endl;
		exit(-1);
	}
	struct chunk yz_plane_chunk;
	yz_plane_dst_list->x = src_x;
	yz_plane_dst_list->y = src_y;
	yz_plane_dst_list->z = src_z;
	yz_plane_dst_list->next = NULL;
	yz_plane_dst_list->src_or_dst = true;
	yz_plane_dst_list->valid = true;
	struct src_dst_list* cur_plane_node;
	cur_plane_node = yz_plane_dst_list;

	partition_along_yz_count = 0;
	xpos_enable = false;
	xneg_enable = false;

	yz_plane_chunk.x_downlim = src_x;
	yz_plane_chunk.x_uplim = src_x;
	yz_plane_chunk.y_downlim = region.y_downlim;
	yz_plane_chunk.y_uplim = region.y_uplim;
	yz_plane_chunk.z_downlim = region.z_downlim;
	yz_plane_chunk.z_uplim = region.z_uplim;


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
				//		partition_along_yz_count++;
					}
					else{
						xneg_enable = 1;
					//	partition_along_yz_count++;
					}
				}
				else{
					if (src_x - dst->x < X / 2){
						xneg_enable = 1;
					//	partition_along_yz_count++;
					}
					else{
						xpos_enable = 1;
					//	partition_along_yz_count++;
					}
					

				}
			}
			else{
				if (region.x_downlim<region.x_uplim){
					if (dst->x>src_x){
						xpos_enable = 1;
					//	partition_along_yz_count++;
					}
					else{
						xneg_enable = 1;
					//	partition_along_yz_count++;
					}

				}
				else if (region.x_downlim > region.x_uplim){
					int xdistance_between_src_downlim = (src_x >= region.x_downlim) ? (src_x - region.x_downlim) : (src_x - region.x_downlim + X);
					int xdistance_between_dst_downlim = (dst->x >= region.x_downlim) ? (dst->x - region.x_downlim) : (dst->x - region.x_downlim + X);
					if (xdistance_between_src_downlim < xdistance_between_dst_downlim){
						xpos_enable = 1;
					//	partition_along_yz_count++;
					}
					else{
						xneg_enable = 1;
					//	partition_along_yz_count++;
					}


				}
				//if region.x_downlim == region.x_uplim, the region is a plane


			}

		}




		dst = dst->next;	
	}
	struct plane_evaluation yz_plane_eval = evaluate_plane(yz_plane_dst_list, yz_plane_chunk, 0);
	partition_along_yz_count = yz_plane_eval.ypos_enable + yz_plane_eval.yneg_enable + yz_plane_eval.zpos_enable + yz_plane_eval.zneg_enable + xpos_enable + xneg_enable;
	double yz_link_var = six_link_variance_delta(node_list,xpos_enable,xneg_enable,yz_plane_eval.ypos_enable,yz_plane_eval.yneg_enable,yz_plane_eval.zpos_enable,yz_plane_eval.zneg_enable);
	

	//second partition along xz plane, the entire src_dst_list will be divided into three parts: the nodes that are in the up chunk of the src node along y dimension, 
	// the nodes that are in the downwards chunk of the src node, the nodes that in the same xz plane with the src node.
	dst=node_list->next;
	struct src_dst_list* xz_plane_dst_list;
	if (!(xz_plane_dst_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
		cout << "no mem" << endl;
		exit(-1);
	}
	struct chunk xz_plane_chunk;
	xz_plane_dst_list->x = src_x;
	xz_plane_dst_list->y = src_y;
	xz_plane_dst_list->z = src_z;
	xz_plane_dst_list->next = NULL;
	xz_plane_dst_list->src_or_dst = true;
	xz_plane_dst_list->valid = true;
//	struct src_dst_list* cur_plane_node;
	cur_plane_node = xz_plane_dst_list;

	partition_along_xz_count = 0;
	ypos_enable = false;
	yneg_enable = false;

	xz_plane_chunk.x_downlim = region.x_downlim;
	xz_plane_chunk.x_uplim = region.x_uplim;
	xz_plane_chunk.y_downlim = src_y;
	xz_plane_chunk.y_uplim = src_y;
	xz_plane_chunk.z_downlim = region.z_downlim;
	xz_plane_chunk.z_uplim = region.z_uplim;
	while (dst){
		if (dst->y == src_y){
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
			if (region.y_wrap()){
				if (dst->y > src_y){
					if (dst->y - src_y <= Y / 2){
						ypos_enable = 1;
						//		partition_along_yz_count++;
					}
					else{
						yneg_enable = 1;
						//	partition_along_yz_count++;
					}
				}
				else{
					if (src_y - dst->y < Y / 2){
						yneg_enable = 1;
						//	partition_along_yz_count++;
					}
					else{
						ypos_enable = 1;
						//	partition_along_yz_count++;
					}


				}
			}
			else{
				if (region.y_downlim<region.y_uplim){
					if (dst->y>src_y){
						ypos_enable = 1;
						//	partition_along_yz_count++;
					}
					else{
						yneg_enable = 1;
						//	partition_along_yz_count++;
					}

				}
				else if (region.y_downlim > region.y_uplim){
					int ydistance_between_src_downlim = (src_y >= region.y_downlim) ? (src_y - region.y_downlim) : (src_y - region.y_downlim + Y);
					int ydistance_between_dst_downlim = (dst->y >= region.y_downlim) ? (dst->y - region.y_downlim) : (dst->y - region.y_downlim + Y);
					if (ydistance_between_src_downlim < ydistance_between_dst_downlim){
						ypos_enable = 1;
						//	partition_along_yz_count++;
					}
					else{
						yneg_enable = 1;
						//	partition_along_yz_count++;
					}


				}
				//if region.x_downlim == region.x_uplim, the region is a plane



			}

		}




		dst = dst->next;
	}
	struct plane_evaluation xz_plane_eval = evaluate_plane(xz_plane_dst_list, xz_plane_chunk, 1);
	partition_along_xz_count = xz_plane_eval.xpos_enable + xz_plane_eval.xneg_enable + xz_plane_eval.zpos_enable + xz_plane_eval.zneg_enable + ypos_enable + yneg_enable;
	double xz_link_var = six_link_variance_delta(node_list, xz_plane_eval.xpos_enable, xz_plane_eval.xneg_enable, ypos_enable, yneg_enable, xz_plane_eval.zpos_enable, xz_plane_eval.zneg_enable);
	

	//third partition along xy plane, the entire src_dst_list will be divided into three parts: the nodes that are in the up chunk of the src node along z dimension, 
	// the nodes that are in the downwards chunk of the src node, the nodes that in the same xy plane with the src node.
	struct src_dst_list* xy_plane_dst_list;
	dst=node_list->next;
	if (!(xy_plane_dst_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
		cout << "no mem" << endl;
		exit(-1);
	}
	struct chunk xy_plane_chunk;
	xy_plane_dst_list->x = src_x;
	xy_plane_dst_list->y = src_y;
	xy_plane_dst_list->z = src_z;
	xy_plane_dst_list->next = NULL;
	xy_plane_dst_list->src_or_dst = true;
	xy_plane_dst_list->valid = true;
//	struct src_dst_list* cur_plane_node;
	cur_plane_node = xy_plane_dst_list;

	partition_along_xy_count = 0;
	zpos_enable = false;
	zneg_enable = false;

	xy_plane_chunk.x_downlim = region.x_downlim;
	xy_plane_chunk.x_uplim = region.x_uplim;
	xy_plane_chunk.y_downlim = region.y_downlim;
	xy_plane_chunk.y_uplim = region.y_uplim;
	xy_plane_chunk.z_downlim = src_z;
	xy_plane_chunk.z_uplim = src_z;
	while (dst){
		if (dst->z == src_z){
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
			if (region.z_wrap()){
				if (dst->z > src_z){
					if (dst->z - src_z <= Z / 2){
						zpos_enable = 1;
						//		partition_along_yz_count++;
					}
					else{
						zneg_enable = 1;
						//	partition_along_yz_count++;
					}
				}
				else{
					if (src_z - dst->z < Z / 2){
						zneg_enable = 1;
						//	partition_along_yz_count++;
					}
					else{
						zpos_enable = 1;
						//	partition_along_yz_count++;
					}


				}
			}
			else{
				if (region.z_downlim<region.z_uplim){
					if (dst->z>src_z){
						zpos_enable = 1;
						//	partition_along_yz_count++;
					}
					else{
						zneg_enable = 1;
						//	partition_along_yz_count++;
					}

				}
				else if (region.z_downlim > region.z_uplim){
					int zdistance_between_src_downlim = (src_z >= region.z_downlim) ? (src_z - region.y_downlim) : (src_z - region.z_downlim + Z);
					int zdistance_between_dst_downlim = (dst->z >= region.z_downlim) ? (dst->z - region.y_downlim) : (dst->z - region.z_downlim + Z);
					if (zdistance_between_src_downlim < zdistance_between_dst_downlim){
						zpos_enable = 1;
						//	partition_along_yz_count++;
					}
					else{
						zneg_enable = 1;
						//	partition_along_yz_count++;
					}


				}
				//if region.x_downlim == region.x_uplim, the region is a plane



			}

		}




		dst = dst->next;
	}
	struct plane_evaluation xy_plane_eval = evaluate_plane(xy_plane_dst_list, xy_plane_chunk, 2);
	partition_along_xy_count = xy_plane_eval.xpos_enable + xy_plane_eval.xneg_enable + xy_plane_eval.ypos_enable + xy_plane_eval.yneg_enable + zpos_enable + zneg_enable;
	double xy_link_var = six_link_variance_delta(node_list, xy_plane_eval.xpos_enable, xy_plane_eval.xneg_enable, xy_plane_eval.ypos_enable, xy_plane_eval.yneg_enable, zpos_enable, zneg_enable);

	
	//now get the biggest among the partition_along_xy_count, partition_along_yz_count, partition_along_xz_count
	int biggest_count;
	int middle_count;
	int smallest_count;
	int which_is_smallest;//0 is yz, 1 is xz, 2 is xy
	int which_is_middle;//0 is yz, 1 is xz, 2 is xy

	if (partition_along_xy_count == partition_along_yz_count && partition_along_xy_count == partition_along_xz_count && xy_link_var == yz_link_var && yz_link_var == xz_link_var){
		//everything is the same, depends on the global rr pointer
		int prev_global_partition_rr_choice = global_partition_rr_choice;
		global_partition_rr_choice = (global_partition_rr_choice == 2) ? 0 : global_partition_rr_choice + 1;
		return prev_global_partition_rr_choice;
	}

	if (partition_along_xy_count >= partition_along_yz_count && partition_along_xy_count>=partition_along_xz_count){
		biggest_count = partition_along_xy_count;
		if (partition_along_yz_count > partition_along_xz_count){
			middle_count = partition_along_yz_count;
			smallest_count = partition_along_xz_count;
			which_is_middle = 0;
			which_is_smallest = 1;
			global_partition_rr_choice = 2;
		}
		else if(partition_along_yz_count< partition_along_xz_count){
			middle_count = partition_along_xz_count; 
			smallest_count = partition_along_yz_count;
			which_is_middle = 1;
			which_is_smallest = 0;
			global_partition_rr_choice = 1;
		}
		else{ // they are equal, now depends on the variance
			if (yz_link_var > xz_link_var){
				middle_count = partition_along_yz_count;
				smallest_count = partition_along_xz_count;
				which_is_middle = 0;
				which_is_smallest = 1;
				global_partition_rr_choice = 2;
			}
			else if(yz_link_var<xz_link_var){
				middle_count = partition_along_xz_count;
				smallest_count = partition_along_yz_count;
				which_is_middle = 1;
				which_is_smallest = 0;
				global_partition_rr_choice = 1;
			}
			else{
				//if still same, use the global round robin index
				if (global_partition_rr_choice == 2 || global_partition_rr_choice == 0){
					//select the yz
					middle_count = partition_along_xz_count;
					smallest_count = partition_along_yz_count;
					which_is_middle = 1;
					which_is_smallest = 0;
					global_partition_rr_choice = 1;
				}
				else{
					//select the xz
					middle_count = partition_along_yz_count;
					smallest_count = partition_along_xz_count;
					which_is_middle = 0;
					which_is_smallest = 1;
					global_partition_rr_choice = 2;
				}
			}

		}
	}
	else if (partition_along_yz_count >= partition_along_xz_count){//the xy_count is definitely not the biggest one
		biggest_count = partition_along_yz_count;
		if (partition_along_xy_count > partition_along_xz_count){
			middle_count = partition_along_xy_count;
			smallest_count = partition_along_xz_count;
			which_is_middle = 2;
			which_is_smallest = 1;
			global_partition_rr_choice = 2;
		}
		else if(partition_along_xy_count<partition_along_xz_count){
			middle_count = partition_along_xz_count;
			smallest_count = partition_along_xy_count;
			which_is_middle = 1;
			which_is_smallest = 2;
			global_partition_rr_choice = 1;
		}
		else{
			if (xy_link_var > xz_link_var){
				middle_count = partition_along_xy_count;
				smallest_count = partition_along_xz_count;
				which_is_middle = 2;
				which_is_smallest = 1;
				global_partition_rr_choice = 2;
			}
			else if(xy_link_var<xz_link_var){
				middle_count = partition_along_xz_count;
				smallest_count = partition_along_xy_count;
				which_is_middle = 1;
				which_is_smallest = 2;
				global_partition_rr_choice = 1;
			}
			else{
				//if still same, use the global round robin index
				if (global_partition_rr_choice == 0 || global_partition_rr_choice == 1){
					//select the xz
					middle_count = partition_along_xy_count;
					smallest_count = partition_along_xz_count;
					which_is_middle = 2;
					which_is_smallest = 1;
					global_partition_rr_choice = 2;
				}
				else{
					//select the xy
					middle_count = partition_along_xz_count;
					smallest_count = partition_along_xy_count;
					which_is_middle = 1;
					which_is_smallest = 2;
					global_partition_rr_choice = 0;
				}

			}
			
		}

	}
	else{
		biggest_count = partition_along_xz_count;
		if (partition_along_xy_count > partition_along_yz_count){
			middle_count = partition_along_xy_count;
			smallest_count = partition_along_yz_count;
			which_is_middle = 2;
			which_is_smallest = 0;
			global_partition_rr_choice = 1;
		}
		else if(partition_along_xy_count<partition_along_yz_count){
			middle_count = partition_along_yz_count;
			smallest_count = partition_along_xy_count; 
			which_is_middle = 0;
			which_is_smallest = 2;
			global_partition_rr_choice = 0;
		}
		else{
			if (xy_link_var > yz_link_var){
				middle_count = partition_along_xy_count;
				smallest_count = partition_along_yz_count;
				which_is_middle = 2;
				which_is_smallest = 0;
				global_partition_rr_choice = 1;
			}
			else if (xy_link_var < yz_link_var){
				middle_count = partition_along_yz_count;
				smallest_count = partition_along_xy_count;
				which_is_middle = 0;
				which_is_smallest = 2;
				global_partition_rr_choice = 0;
			}
			else{
				//if still same, use the global round robin index
				if (global_partition_rr_choice == 2 || global_partition_rr_choice == 1){
					//select the xy
					middle_count = partition_along_yz_count;
					smallest_count = partition_along_xy_count;
					which_is_middle = 0;
					which_is_smallest = 2;
					global_partition_rr_choice = 0;
				}
				else{
					middle_count = partition_along_xy_count;
					smallest_count = partition_along_yz_count;
					which_is_middle = 2;
					which_is_smallest = 0;
					global_partition_rr_choice = 1;
				}
			}
		}
	}

	//free all the link lists that are created

	//free the xy_plane_dst_list yz_plane_dst_list xz_plane_dst_list
	struct src_dst_list* free_ptr;

	struct src_dst_list* next_free_ptr;

	free_ptr = xy_plane_dst_list;
	while (free_ptr){
		next_free_ptr = free_ptr->next;
		free(free_ptr);
		free_ptr = next_free_ptr;
	}

	free_ptr = yz_plane_dst_list;
	while (free_ptr){
		next_free_ptr = free_ptr->next;
		free(free_ptr);
		free_ptr = next_free_ptr;
	}

	free_ptr = xz_plane_dst_list;
	while (free_ptr){
		next_free_ptr = free_ptr->next;
		free(free_ptr);
		free_ptr = next_free_ptr;
	}


	//
	return which_is_smallest;



}

void RPM_partition_1D(struct src_dst_list* node_list, struct chunk Chunk_1D, node* tree_src, int direction){
	if (node_list == NULL || node_list->next == NULL)
		return void();
	if(direction==0){
		if (Chunk_1D.get_x_size() == 1){
			return void();
		}
		// this is a pencil that is along the x direction
		int srcx=node_list->x;
		int x_map[X];
		for(int i=0;i<X;i++){
			x_map[i]=0;
		}
		struct src_dst_list* node_ptr;
		node_ptr=node_list->next;
		while(node_ptr){
			x_map[node_ptr->x]=1;
			node_ptr=node_ptr->next;
		}

		int x_counter = 0;
		int find_x_valid;
		for (int i = 0; i < X; i++){
			if (x_map[i] == 1){
				find_x_valid = i;
				x_counter++;
			}
		}
		if (x_counter == 1 && find_x_valid == node_list->x){
			return void();
		}

		bool xpos_enable = false;
		bool xneg_enable = false;
		int xpos_max;
		int xneg_max;
		node* cur_xpos_node= tree_src;
		node* cur_xneg_node=tree_src;
		if(Chunk_1D.x_wrap()){
			for(int i=1;i<=X/2;i++){
				int idx=node_list->x+i>=X?node_list->x+i-X:node_list->x+i;
				if(x_map[idx]!=0){
					xpos_enable=true;
					xpos_max=idx;
				}

			}
			for(int i=1;i<=(X-1)/2;i++){
				int idx = node_list->x - i<0 ? node_list->x - i + X : node_list->x - i;
				if(x_map[idx]!=0){
					xneg_enable=true;
					xneg_max=idx;
				}
			}
			int new_weight=tree_src->weight==1?1:tree_src->weight/2;
			if(xpos_enable){
				tree_src->children[tree_src->num_children]=new node(node_list->x+1>=X?node_list->x+1-X:node_list->x+1, node_list->y,node_list->z,new_weight);
				cur_xpos_node=tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while(cur_xpos_node->x!=xpos_max){
					cur_xpos_node->children[0]=new node(cur_xpos_node->x+1>=X?cur_xpos_node->x+1-X:cur_xpos_node->x+1, node_list->y,node_list->z,new_weight);
					cur_xpos_node->num_children=1;
					cur_xpos_node=cur_xpos_node->children[0];
					new_weight=new_weight==1?1:new_weight/2;
				}
				tree_src->num_children++;
				
			}
			new_weight = tree_src->weight == 1 ? 1 : tree_src->weight / 2;
			if(xneg_enable){
				tree_src->children[tree_src->num_children]=new node(node_list->x-1<0?node_list->x-1+X:node_list->x-1, node_list->y,node_list->z,new_weight);
				cur_xneg_node=tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while(cur_xneg_node->x!=xneg_max){
					cur_xneg_node->children[0]=new node(cur_xneg_node->x-1<0?cur_xneg_node->x-1+X:cur_xneg_node->x-1, node_list->y,node_list->z,new_weight);
					cur_xneg_node->num_children=1;
					cur_xneg_node=cur_xneg_node->children[0];
					new_weight=new_weight==1?1:new_weight/2;
				}
				tree_src->num_children++;
			}


			fout<<"{src:("<<node_list->x<<","<<node_list->y<<","<<node_list->z<<") weight: "<<tree_src->weight<<endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
				accumulate_link(tree_src,tree_src->children[children_idx]);
			}
			fout<<"}"<<endl;

			cout << "{src:(" << node_list->x << "," << node_list->y << "," << node_list->z << ") weight: " << tree_src->weight << endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
				//accumulate_link(tree_src, tree_src->children[children_idx]);
			}
			cout << "}" << endl;
			if(xpos_enable){
				cur_xpos_node=tree_src->children[0];
	
				while(cur_xpos_node->children[0]){
					fout<<"{src:("<<cur_xpos_node->x<<","<<cur_xpos_node->y<<","<<cur_xpos_node->z<<") weight: "<<cur_xpos_node->weight<<endl;
					fout << "dst: (" << cur_xpos_node->children[0]->x << "," << cur_xpos_node->children[0]->y << "," << cur_xpos_node->children[0]->z << ") weight: " <<  cur_xpos_node->children[0]->weight << endl;
					accumulate_link(cur_xpos_node,cur_xpos_node->children[0]);
					fout<<"}"<<endl;
					cout << "{src:(" << cur_xpos_node->x << "," << cur_xpos_node->y << "," << cur_xpos_node->z << ") weight: " << cur_xpos_node->weight << endl;
					cout << "dst: (" << cur_xpos_node->children[0]->x << "," << cur_xpos_node->children[0]->y << "," << cur_xpos_node->children[0]->z << ") weight: " << cur_xpos_node->children[0]->weight << endl;
					//accumulate_link(cur_xpos_node, cur_xpos_node->children[0]);
					cout << "}" << endl;
					cur_xpos_node=cur_xpos_node->children[0];


				}
			}
			if(xneg_enable){
				if(xpos_enable){
					cur_xneg_node=tree_src->children[1];
				}
				else{
					cur_xneg_node=tree_src->children[0];
				}
				while(cur_xneg_node->children[0]){
					fout<<"{src:("<<cur_xneg_node->x<<","<<cur_xneg_node->y<<","<<cur_xneg_node->z<<") weight: "<<cur_xneg_node->weight<<endl;
					fout << "dst: (" << cur_xneg_node->children[0]->x << "," << cur_xneg_node->children[0]->y << "," << cur_xneg_node->children[0]->z << ") weight: " <<  cur_xneg_node->children[0]->weight << endl;
					accumulate_link(cur_xneg_node,cur_xneg_node->children[0]);
					fout<<"}"<<endl;

					cout << "{src:(" << cur_xneg_node->x << "," << cur_xneg_node->y << "," << cur_xneg_node->z << ") weight: " << cur_xneg_node->weight << endl;
					cout << "dst: (" << cur_xneg_node->children[0]->x << "," << cur_xneg_node->children[0]->y << "," << cur_xneg_node->children[0]->z << ") weight: " << cur_xneg_node->children[0]->weight << endl;
					//accumulate_link(cur_xneg_node, cur_xneg_node->children[0]);
					cout << "}" << endl;
					cur_xneg_node=cur_xneg_node->children[0];
				}

			}
		

		}
		else{
			// the chunk is not wrapped around at x dimension

			if (node_list->x == Chunk_1D.x_uplim){
				xpos_enable = false;
			//	xneg_enable = true;
			}
			else if (node_list->x == Chunk_1D.x_downlim){
			//	xpos_enable = true;
				xneg_enable = false;
			}
			if(node_list->x != Chunk_1D.x_uplim){
				for (int i = 0;; i++){
					int idx = node_list->x + i >= X ? node_list->x + i - X : node_list->x + i;
					if (x_map[idx] != 0 && i!=0){
						xpos_enable = true;
						xpos_max = idx;
					}
					if (idx == Chunk_1D.x_uplim)
						break;				
				}
			}
			if(node_list->x!=Chunk_1D.x_downlim){
				for (int i = 0;; i++){
					int idx = node_list->x - i <0 ? node_list->x - i + X : node_list->x - i;
					if (x_map[idx] != 0 && i!=0){
						xneg_enable = true;
						xneg_max = idx;
					}
					if (idx == Chunk_1D.x_downlim)
						break;
				}
			}
			int new_weight = tree_src->weight == 1 ? 1 : tree_src->weight / 2;
			if (xpos_enable){
				tree_src->children[tree_src->num_children] = new node(node_list->x + 1 >= X ? node_list->x + 1 - X : node_list->x + 1, node_list->y, node_list->z, new_weight);
				cur_xpos_node = tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while (cur_xpos_node->x != xpos_max){
					cur_xpos_node->children[0] = new node(cur_xpos_node->x + 1 >= X ? cur_xpos_node->x + 1 - X : cur_xpos_node->x + 1, node_list->y, node_list->z, new_weight);
					cur_xpos_node->num_children = 1;
					cur_xpos_node = cur_xpos_node->children[0];
					new_weight = new_weight == 1 ? 1 : new_weight / 2;
				}
				tree_src->num_children++;

			}
			new_weight = tree_src->weight == 1 ? 1 : tree_src->weight / 2;
			if (xneg_enable){
				tree_src->children[tree_src->num_children] = new node(node_list->x - 1<0 ? node_list->x - 1 + X : node_list->x - 1, node_list->y, node_list->z, new_weight);
				cur_xneg_node = tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while (cur_xneg_node->x != xneg_max){
					cur_xneg_node->children[0] = new node(cur_xneg_node->x - 1<0 ? cur_xneg_node->x - 1 + X : cur_xneg_node->x - 1, node_list->y, node_list->z, new_weight);
					cur_xneg_node->num_children = 1;
					cur_xneg_node = cur_xneg_node->children[0];
					new_weight = new_weight == 1 ? 1 : new_weight / 2;
				}
				tree_src->num_children++;
			}


			fout << "{src:(" << node_list->x << "," << node_list->y << "," << node_list->z << ") weight: " << tree_src->weight << endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
				accumulate_link(tree_src,tree_src->children[children_idx]);
			}
			fout << "}" << endl;

			cout << "{src:(" << node_list->x << "," << node_list->y << "," << node_list->z << ") weight: " << tree_src->weight << endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
//				accumulate_link(tree_src, tree_src->children[children_idx]);
			}
			cout << "}" << endl;

			if (xpos_enable){
				cur_xpos_node = tree_src->children[0];

				while (cur_xpos_node->children[0]){
					fout << "{src:(" << cur_xpos_node->x << "," << cur_xpos_node->y << "," << cur_xpos_node->z << ") weight: " << cur_xpos_node->weight << endl;
					fout << "dst: (" << cur_xpos_node->children[0]->x << "," << cur_xpos_node->children[0]->y << "," << cur_xpos_node->children[0]->z << ") weight: " << cur_xpos_node->children[0]->weight << endl;
					accumulate_link(cur_xpos_node,cur_xpos_node->children[0]);
					fout << "}" << endl;

					cout << "{src:(" << cur_xpos_node->x << "," << cur_xpos_node->y << "," << cur_xpos_node->z << ") weight: " << cur_xpos_node->weight << endl;
					cout << "dst: (" << cur_xpos_node->children[0]->x << "," << cur_xpos_node->children[0]->y << "," << cur_xpos_node->children[0]->z << ") weight: " << cur_xpos_node->children[0]->weight << endl;
//					accumulate_link(cur_xpos_node, cur_xpos_node->children[0]);
					cout << "}" << endl;
					cur_xpos_node = cur_xpos_node->children[0];
				}
			}
			if (xneg_enable){
				if (xpos_enable){
					cur_xneg_node = tree_src->children[1];
				}
				else{
					cur_xneg_node = tree_src->children[0];
				}
				while (cur_xneg_node->children[0]){
					fout << "{src:(" << cur_xneg_node->x << "," << cur_xneg_node->y << "," << cur_xneg_node->z << ") weight: " << cur_xneg_node->weight << endl;
					fout << "dst: (" << cur_xneg_node->children[0]->x << "," << cur_xneg_node->children[0]->y << "," << cur_xneg_node->children[0]->z << ") weight: " << cur_xneg_node->children[0]->weight << endl;
					accumulate_link(cur_xneg_node,cur_xneg_node->children[0]);
					fout << "}" << endl;

					cout << "{src:(" << cur_xneg_node->x << "," << cur_xneg_node->y << "," << cur_xneg_node->z << ") weight: " << cur_xneg_node->weight << endl;
					cout << "dst: (" << cur_xneg_node->children[0]->x << "," << cur_xneg_node->children[0]->y << "," << cur_xneg_node->children[0]->z << ") weight: " << cur_xneg_node->children[0]->weight << endl;
					//accumulate_link(cur_xneg_node, cur_xneg_node->children[0]);
					cout << "}" << endl;
					cur_xneg_node = cur_xneg_node->children[0];
				}

			}
			

		}
		
		
		
	}
	else if (direction == 1){
		if (Chunk_1D.get_y_size() == 1){
			return void();
		}
		// this is a pencil that is along the y direction
		int srcy = node_list->y;
		int y_map[Y];
		for (int i = 0; i<Y; i++){
			y_map[i] = 0;
		}
		struct src_dst_list* node_ptr;
		node_ptr = node_list->next;
		while (node_ptr){
			y_map[node_ptr->y] = 1;
			node_ptr = node_ptr->next;
		}

		int y_counter = 0;
		int find_y_valid;
		for (int i = 0; i < Y; i++){
			if (y_map[i] == 1){
				find_y_valid = i;
				y_counter++;
			}
		}
		if (y_counter == 1 && find_y_valid == node_list->y){
			return void();
		}

		bool ypos_enable = false;
		bool yneg_enable = false;
		int ypos_max;
		int yneg_max;
		node* cur_ypos_node = tree_src;
		node* cur_yneg_node = tree_src;
		if (Chunk_1D.y_wrap()){
			for (int i = 1; i <= Y / 2; i++){
				int idy = node_list->y + i >= Y ? node_list->y + i - Y : node_list->y + i;
				if (y_map[idy] != 0){
					ypos_enable = true;
					ypos_max = idy;
				}

			}
			for (int i = 1; i <= (Y-1) / 2; i++){
				int idy = node_list->y - i<0 ? node_list->y - i + Y : node_list->y - i;
				if (y_map[idy] != 0){
					yneg_enable = true;
					yneg_max = idy;
				}
			}
			int new_weight = tree_src->weight == 1 ? 1 : tree_src->weight / 2;
			if (ypos_enable){
				tree_src->children[tree_src->num_children] = new node(node_list->x, node_list->y + 1 >= Y ? node_list->y + 1 - Y : node_list->y + 1, node_list->z, new_weight);
				cur_ypos_node = tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while (cur_ypos_node->y != ypos_max){
					cur_ypos_node->children[0] = new node(node_list->x, cur_ypos_node->y + 1 >= Y ? cur_ypos_node->y + 1 - Y : cur_ypos_node->y + 1, node_list->z, new_weight);
					cur_ypos_node->num_children = 1;
					cur_ypos_node = cur_ypos_node->children[0];
					new_weight = new_weight == 1 ? 1 : new_weight / 2;
				}
				tree_src->num_children++;

			}
			new_weight = tree_src->weight == 1 ? 1 : tree_src->weight / 2;
			if (yneg_enable){
				tree_src->children[tree_src->num_children] = new node(node_list->x, node_list->y - 1<0 ? node_list->y - 1 + Y : node_list->y - 1, node_list->z, new_weight);
				cur_yneg_node = tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while (cur_yneg_node->y != yneg_max){
					cur_yneg_node->children[0] = new node(node_list->x, cur_yneg_node->y - 1<0 ? cur_yneg_node->y - 1 + Y : cur_yneg_node->y - 1, node_list->z, new_weight);
					cur_yneg_node->num_children = 1;
					cur_yneg_node = cur_yneg_node->children[0];
					new_weight = new_weight == 1 ? 1 : new_weight / 2;
				}
				tree_src->num_children++;
			}


			fout << "{src:(" << node_list->x << "," << node_list->y << "," << node_list->z << ") weight: " << tree_src->weight << endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
				accumulate_link(tree_src, tree_src->children[children_idx]);
			}
			fout << "}" << endl;

			cout << "{src:(" << node_list->x << "," << node_list->y << "," << node_list->z << ") weight: " << tree_src->weight << endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
			//	accumulate_link(tree_src, tree_src->children[children_idx]);
			}
			cout << "}" << endl;

			if (ypos_enable){
				cur_ypos_node = tree_src->children[0];

				while (cur_ypos_node->children[0]){
					fout << "{src:(" << cur_ypos_node->x << "," << cur_ypos_node->y << "," << cur_ypos_node->z << ") weight: " << cur_ypos_node->weight << endl;
					fout << "dst: (" << cur_ypos_node->children[0]->x << "," << cur_ypos_node->children[0]->y << "," << cur_ypos_node->children[0]->z << ") weight: " << cur_ypos_node->children[0]->weight << endl;
					accumulate_link(cur_ypos_node, cur_ypos_node->children[0]);
					fout << "}" << endl;

					cout << "{src:(" << cur_ypos_node->x << "," << cur_ypos_node->y << "," << cur_ypos_node->z << ") weight: " << cur_ypos_node->weight << endl;
					cout << "dst: (" << cur_ypos_node->children[0]->x << "," << cur_ypos_node->children[0]->y << "," << cur_ypos_node->children[0]->z << ") weight: " << cur_ypos_node->children[0]->weight << endl;
				//	accumulate_link(cur_ypos_node, cur_ypos_node->children[0]);
					cout << "}" << endl;
					cur_ypos_node = cur_ypos_node->children[0];
				}
			}
			if (yneg_enable){
				if (ypos_enable){
					cur_yneg_node = tree_src->children[1];
				}
				else{
					cur_yneg_node = tree_src->children[0];
				}
				while (cur_yneg_node->children[0]){
					fout << "{src:(" << cur_yneg_node->x << "," << cur_yneg_node->y << "," << cur_yneg_node->z << ") weight: " << cur_yneg_node->weight << endl;
					fout << "dst: (" << cur_yneg_node->children[0]->x << "," << cur_yneg_node->children[0]->y << "," << cur_yneg_node->children[0]->z << ") weight: " << cur_yneg_node->children[0]->weight << endl;
					accumulate_link(cur_yneg_node, cur_yneg_node->children[0]);
					fout << "}" << endl;

					cout << "{src:(" << cur_yneg_node->x << "," << cur_yneg_node->y << "," << cur_yneg_node->z << ") weight: " << cur_yneg_node->weight << endl;
					cout << "dst: (" << cur_yneg_node->children[0]->x << "," << cur_yneg_node->children[0]->y << "," << cur_yneg_node->children[0]->z << ") weight: " << cur_yneg_node->children[0]->weight << endl;
					//accumulate_link(cur_yneg_node, cur_yneg_node->children[0]);
					cout << "}" << endl;
					cur_yneg_node = cur_yneg_node->children[0];
				}

			}


		}
		else{
			// the chunk is not wrapped around at x dimension

			if (node_list->y == Chunk_1D.y_uplim){
				ypos_enable = false;
			//	yneg_enable = true;
			}
			else if (node_list->y == Chunk_1D.y_downlim){
			//	ypos_enable = true;
				yneg_enable = false;
			}
			if (node_list->y != Chunk_1D.y_uplim){
				for (int i = 0;; i++){
					int idy = node_list->y + i >= Y ? node_list->y + i - Y : node_list->y + i;
					if (y_map[idy] != 0 && i != 0){
						ypos_enable = true;
						ypos_max = idy;
					}
					if (idy == Chunk_1D.y_uplim)
						break;
				}
			}
			if (node_list->y != Chunk_1D.y_downlim){
				for (int i = 0;; i++){
					int idy = node_list->y - i <0 ? node_list->y - i + Y : node_list->y - i;
					if (y_map[idy] != 0 && i != 0){
						yneg_enable = true;
						yneg_max = idy;
					}
					if (idy == Chunk_1D.y_downlim)
						break;
				}
			}
			int new_weight = tree_src->weight == 1 ? 1 : tree_src->weight / 2;
			if (ypos_enable){
				tree_src->children[tree_src->num_children] = new node(node_list->x, node_list->y + 1 >= Y ? node_list->y + 1 - Y : node_list->y + 1, node_list->z, new_weight);
				cur_ypos_node = tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while (cur_ypos_node->y != ypos_max){
					cur_ypos_node->children[0] = new node(node_list->x, cur_ypos_node->y + 1 >= Y ? cur_ypos_node->y + 1 - Y : cur_ypos_node->y + 1, node_list->z, new_weight);
					cur_ypos_node->num_children = 1;
					cur_ypos_node = cur_ypos_node->children[0];
					new_weight = new_weight == 1 ? 1 : new_weight / 2;
				}
				tree_src->num_children++;

			}
			new_weight = tree_src->weight == 1 ? 1 : tree_src->weight / 2;
			if (yneg_enable){
				tree_src->children[tree_src->num_children] = new node(node_list->x, node_list->y - 1<0 ? node_list->y - 1 + Y : node_list->y - 1, node_list->z, new_weight);
				cur_yneg_node = tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while (cur_yneg_node->y != yneg_max){
					cur_yneg_node->children[0] = new node(node_list->x, cur_yneg_node->y - 1<0 ? cur_yneg_node->y - 1 + Y : cur_yneg_node->y - 1, node_list->z, new_weight);
					cur_yneg_node->num_children = 1;
					cur_yneg_node = cur_yneg_node->children[0];
					new_weight = new_weight == 1 ? 1 : new_weight / 2;
				}
				tree_src->num_children++;
			}


			fout << "{src:(" << node_list->x << "," << node_list->y << "," << node_list->z << ") weight: " << tree_src->weight << endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
				accumulate_link(tree_src, tree_src->children[children_idx]);
			}
			fout << "}" << endl;
			
			cout << "{src:(" << node_list->x << "," << node_list->y << "," << node_list->z << ") weight: " << tree_src->weight << endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
				//accumulate_link(tree_src, tree_src->children[children_idx]);
			}
			cout << "}" << endl;
			if (ypos_enable){
				cur_ypos_node = tree_src->children[0];

				while (cur_ypos_node->children[0]){
					fout << "{src:(" << cur_ypos_node->x << "," << cur_ypos_node->y << "," << cur_ypos_node->z << ") weight: " << cur_ypos_node->weight << endl;
					fout << "dst: (" << cur_ypos_node->children[0]->x << "," << cur_ypos_node->children[0]->y << "," << cur_ypos_node->children[0]->z << ") weight: " << cur_ypos_node->children[0]->weight << endl;
					accumulate_link(cur_ypos_node, cur_ypos_node->children[0]);
					fout << "}" << endl;

					cout << "{src:(" << cur_ypos_node->x << "," << cur_ypos_node->y << "," << cur_ypos_node->z << ") weight: " << cur_ypos_node->weight << endl;
					cout << "dst: (" << cur_ypos_node->children[0]->x << "," << cur_ypos_node->children[0]->y << "," << cur_ypos_node->children[0]->z << ") weight: " << cur_ypos_node->children[0]->weight << endl;
					//accumulate_link(cur_ypos_node, cur_ypos_node->children[0]);
					cout << "}" << endl;
					cur_ypos_node = cur_ypos_node->children[0];
				}
			}
			if (yneg_enable){
				if (ypos_enable){
					cur_yneg_node = tree_src->children[1];
				}
				else{
					cur_yneg_node = tree_src->children[0];
				}
				while (cur_yneg_node->children[0]){
					fout << "{src:(" << cur_yneg_node->x << "," << cur_yneg_node->y << "," << cur_yneg_node->z << ") weight: " << cur_yneg_node->weight << endl;
					fout << "dst: (" << cur_yneg_node->children[0]->x << "," << cur_yneg_node->children[0]->y << "," << cur_yneg_node->children[0]->z << ") weight: " << cur_yneg_node->children[0]->weight << endl;
					accumulate_link(cur_yneg_node, cur_yneg_node->children[0]);
					fout << "}" << endl;

					cout << "{src:(" << cur_yneg_node->x << "," << cur_yneg_node->y << "," << cur_yneg_node->z << ") weight: " << cur_yneg_node->weight << endl;
					cout << "dst: (" << cur_yneg_node->children[0]->x << "," << cur_yneg_node->children[0]->y << "," << cur_yneg_node->children[0]->z << ") weight: " << cur_yneg_node->children[0]->weight << endl;
					//accumulate_link(cur_yneg_node, cur_yneg_node->children[0]);
					cout << "}" << endl;

					cur_yneg_node = cur_yneg_node->children[0];
				}

			}


		}



	}
	else if (direction == 2){
		if (Chunk_1D.get_z_size() == 1){
			return void();
		}
		// this is a pencil that is along the y direction
		int srcz = node_list->z;
		int z_map[Z];
		for (int i = 0; i<Z; i++){
			z_map[i] = 0;
		}
		struct src_dst_list* node_ptr;
		node_ptr = node_list->next;
		while (node_ptr){
			z_map[node_ptr->z] = 1;
			node_ptr = node_ptr->next;
		}

		int z_counter = 0;
		int find_z_valid;
		for (int i = 0; i < Z; i++){
			if (z_map[i] == 1){
				find_z_valid = i;
				z_counter++;
			}
		}
		if (z_counter == 1 && find_z_valid == node_list->z){
			return void();
		}

		bool zpos_enable = false;
		bool zneg_enable = false;
		int zpos_max;
		int zneg_max;
		node* cur_zpos_node = tree_src;
		node* cur_zneg_node = tree_src;
		if (Chunk_1D.z_wrap()){
			for (int i = 1; i <= Z / 2 ; i++){
				int idz = node_list->z + i >= Z ? node_list->z + i - Z : node_list->z + i;
				if (z_map[idz] != 0){
					zpos_enable = true;
					zpos_max = idz;
				}

			}
			for (int i = 1; i <= (Z-1) / 2; i++){
				int idz = node_list->z - i<0 ? node_list->z - i + Z : node_list->z - i;
				if (z_map[idz] != 0){
					zneg_enable = true;
					zneg_max = idz;
				}
			}
			int new_weight = tree_src->weight == 1 ? 1 : tree_src->weight / 2;
			if (zpos_enable){
				tree_src->children[tree_src->num_children] = new node(node_list->x, node_list->y, node_list->z + 1 >= Z ? node_list->z + 1 - Z : node_list->z + 1, new_weight);
				cur_zpos_node = tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while (cur_zpos_node->z != zpos_max){
					cur_zpos_node->children[0] = new node(node_list->x, node_list->y, cur_zpos_node->z + 1 >= Z ? cur_zpos_node->z + 1 - Z : cur_zpos_node->z + 1, new_weight);
					cur_zpos_node->num_children = 1;
					cur_zpos_node = cur_zpos_node->children[0];
					new_weight = new_weight == 1 ? 1 : new_weight / 2;
				}
				tree_src->num_children++;

			}
			new_weight = tree_src->weight == 1 ? 1 : tree_src->weight / 2;
			if (zneg_enable){
				tree_src->children[tree_src->num_children] = new node(node_list->x, node_list->y , node_list->z - 1<0 ? node_list->z - 1 + Z : node_list->z - 1, new_weight);
				cur_zneg_node = tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while (cur_zneg_node->z != zneg_max){
					cur_zneg_node->children[0] = new node(node_list->x, node_list->y, cur_zneg_node->z - 1<0 ? cur_zneg_node->z - 1 + Z : cur_zneg_node->z - 1, new_weight);
					cur_zneg_node->num_children = 1;
					cur_zneg_node = cur_zneg_node->children[0];
					new_weight = new_weight == 1 ? 1 : new_weight / 2;
				}
				tree_src->num_children++;
			}


			fout << "{src:(" << node_list->x << "," << node_list->y << "," << node_list->z << ") weight: " << tree_src->weight << endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
				accumulate_link(tree_src, tree_src->children[children_idx]);
			}
			fout << "}" << endl;

			cout << "{src:(" << node_list->x << "," << node_list->y << "," << node_list->z << ") weight: " << tree_src->weight << endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
				//accumulate_link(tree_src, tree_src->children[children_idx]);
			}
			cout << "}" << endl;

			if (zpos_enable){
				cur_zpos_node = tree_src->children[0];

				while (cur_zpos_node->children[0]){
					fout << "{src:(" << cur_zpos_node->x << "," << cur_zpos_node->y << "," << cur_zpos_node->z << ") weight: " << cur_zpos_node->weight << endl;
					fout << "dst: (" << cur_zpos_node->children[0]->x << "," << cur_zpos_node->children[0]->y << "," << cur_zpos_node->children[0]->z << ") weight: " << cur_zpos_node->children[0]->weight << endl;
					accumulate_link(cur_zpos_node, cur_zpos_node->children[0]);
					fout << "}" << endl;

					cout << "{src:(" << cur_zpos_node->x << "," << cur_zpos_node->y << "," << cur_zpos_node->z << ") weight: " << cur_zpos_node->weight << endl;
					cout << "dst: (" << cur_zpos_node->children[0]->x << "," << cur_zpos_node->children[0]->y << "," << cur_zpos_node->children[0]->z << ") weight: " << cur_zpos_node->children[0]->weight << endl;
					//accumulate_link(cur_zpos_node, cur_zpos_node->children[0]);
					cout << "}" << endl;


					cur_zpos_node = cur_zpos_node->children[0];
				}
			}
			if (zneg_enable){
				if (zpos_enable){
					cur_zneg_node = tree_src->children[1];
				}
				else{
					cur_zneg_node = tree_src->children[0];
				}
				while (cur_zneg_node->children[0]){
					fout << "{src:(" << cur_zneg_node->x << "," << cur_zneg_node->y << "," << cur_zneg_node->z << ") weight: " << cur_zneg_node->weight << endl;
					fout << "dst: (" << cur_zneg_node->children[0]->x << "," << cur_zneg_node->children[0]->y << "," << cur_zneg_node->children[0]->z << ") weight: " << cur_zneg_node->children[0]->weight << endl;
					accumulate_link(cur_zneg_node, cur_zneg_node->children[0]);
					fout << "}" << endl;

					cout << "{src:(" << cur_zneg_node->x << "," << cur_zneg_node->y << "," << cur_zneg_node->z << ") weight: " << cur_zneg_node->weight << endl;
					cout << "dst: (" << cur_zneg_node->children[0]->x << "," << cur_zneg_node->children[0]->y << "," << cur_zneg_node->children[0]->z << ") weight: " << cur_zneg_node->children[0]->weight << endl;
				//	accumulate_link(cur_zneg_node, cur_zneg_node->children[0]);
					cout << "}" << endl;

					cur_zneg_node = cur_zneg_node->children[0];
				}

			}


		}
		else{
			// the chunk is not wrapped around at x dimension

			if (node_list->z == Chunk_1D.z_uplim){
				zpos_enable = false;
			//	zneg_enable = true;
			}
			else if (node_list->z == Chunk_1D.z_downlim){
			//	zpos_enable = true;
				zneg_enable = false;
			}
			if (node_list->z != Chunk_1D.z_uplim){
				for (int i = 0;; i++){
					int idz = node_list->z + i >= Z ? node_list->z + i - Z : node_list->z + i;
					if (z_map[idz] != 0 && i != 0){
						zpos_enable = true;
						zpos_max = idz;
					}
					if (idz == Chunk_1D.z_uplim)
						break;
				}
			}
			if (node_list->z != Chunk_1D.z_downlim){
				for (int i = 0;; i++){
					int idz = node_list->z - i <0 ? node_list->z - i + Z : node_list->z - i;
					if (z_map[idz] != 0 && i != 0){
						zneg_enable = true;
						zneg_max = idz;
					}
					if (idz == Chunk_1D.z_downlim)
						break;
				}
			}
			int new_weight = tree_src->weight == 1 ? 1 : tree_src->weight / 2;
			if (zpos_enable){
				tree_src->children[tree_src->num_children] = new node(node_list->x, node_list->y, node_list->z + 1 >= Z ? node_list->z + 1 - Z : node_list->z + 1, new_weight);
				cur_zpos_node = tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while (cur_zpos_node->z != zpos_max){
					cur_zpos_node->children[0] = new node(node_list->x, node_list->y, cur_zpos_node->z + 1 >= Z ? cur_zpos_node->z + 1 - Z : cur_zpos_node->z + 1, new_weight);
					cur_zpos_node->num_children = 1;
					cur_zpos_node = cur_zpos_node->children[0];
					new_weight = new_weight == 1 ? 1 : new_weight / 2;
				}
				tree_src->num_children++;

			}
			new_weight = tree_src->weight == 1 ? 1 : tree_src->weight / 2;
			if (zneg_enable){
				tree_src->children[tree_src->num_children] = new node(node_list->x, node_list->y , node_list->z - 1<0 ? node_list->z - 1 + Z : node_list->z - 1, new_weight);
				cur_zneg_node = tree_src->children[tree_src->num_children];
				new_weight = new_weight == 1 ? 1 : new_weight / 2;
				while (cur_zneg_node->z != zneg_max){
					cur_zneg_node->children[0] = new node(node_list->x, node_list->y , cur_zneg_node->z - 1<0 ? cur_zneg_node->z - 1 + Z : cur_zneg_node->z - 1, new_weight);
					cur_zneg_node->num_children = 1;
					cur_zneg_node = cur_zneg_node->children[0];
					new_weight = new_weight == 1 ? 1 : new_weight / 2;
				}
				tree_src->num_children++;
			}


			fout << "{src:(" << node_list->x << "," << node_list->y << "," << node_list->z << ") weight: " << tree_src->weight << endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
				accumulate_link(tree_src, tree_src->children[children_idx]);
			}
			fout << "}" << endl;

			cout << "{src:(" << node_list->x << "," << node_list->y << "," << node_list->z << ") weight: " << tree_src->weight << endl;
			for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
				cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << tree_src->children[children_idx]->weight << endl;
				//accumulate_link(tree_src, tree_src->children[children_idx]);
			}
			cout << "}" << endl;

			if (zpos_enable){
				cur_zpos_node = tree_src->children[0];

				while (cur_zpos_node->children[0]){
					fout << "{src:(" << cur_zpos_node->x << "," << cur_zpos_node->y << "," << cur_zpos_node->z << ") weight: " << cur_zpos_node->weight << endl;
					fout << "dst: (" << cur_zpos_node->children[0]->x << "," << cur_zpos_node->children[0]->y << "," << cur_zpos_node->children[0]->z << ") weight: " << cur_zpos_node->children[0]->weight << endl;
					accumulate_link(cur_zpos_node, cur_zpos_node->children[0]);
					fout << "}" << endl;

					cout << "{src:(" << cur_zpos_node->x << "," << cur_zpos_node->y << "," << cur_zpos_node->z << ") weight: " << cur_zpos_node->weight << endl;
					cout << "dst: (" << cur_zpos_node->children[0]->x << "," << cur_zpos_node->children[0]->y << "," << cur_zpos_node->children[0]->z << ") weight: " << cur_zpos_node->children[0]->weight << endl;
					//accumulate_link(cur_zpos_node, cur_zpos_node->children[0]);
					cout << "}" << endl;

					cur_zpos_node = cur_zpos_node->children[0];
				}
			}
			if (zneg_enable){
				if (zpos_enable){
					cur_zneg_node = tree_src->children[1];
				}
				else{
					cur_zneg_node = tree_src->children[0];
				}
				while (cur_zneg_node->children[0]){
					fout << "{src:(" << cur_zneg_node->x << "," << cur_zneg_node->y << "," << cur_zneg_node->z << ") weight: " << cur_zneg_node->weight << endl;
					fout << "dst: (" << cur_zneg_node->children[0]->x << "," << cur_zneg_node->children[0]->y << "," << cur_zneg_node->children[0]->z << ") weight: " << cur_zneg_node->children[0]->weight << endl;
					accumulate_link(cur_zneg_node, cur_zneg_node->children[0]);
					fout << "}" << endl;

					cout << "{src:(" << cur_zneg_node->x << "," << cur_zneg_node->y << "," << cur_zneg_node->z << ") weight: " << cur_zneg_node->weight << endl;
					cout << "dst: (" << cur_zneg_node->children[0]->x << "," << cur_zneg_node->children[0]->y << "," << cur_zneg_node->children[0]->z << ") weight: " << cur_zneg_node->children[0]->weight << endl;
					//accumulate_link(cur_zneg_node, cur_zneg_node->children[0]);
					cout << "}" << endl;

					cur_zneg_node = cur_zneg_node->children[0];
				}

			}


		}



	}

}



void RPM_partition_2D(struct src_dst_list* node_list, struct chunk Chunk_2D, node* tree_src,int direction){
	if (node_list==NULL || node_list->next == NULL){
		//the node list only contains leave nodes
		return void();
	}
	//direction: 0 is the yz plane
	//1 is the xz plane
	//2 is the xy plane
	if(Chunk_2D.get_y_size()==1 && Chunk_2D.get_z_size()==1){
		RPM_partition_1D(node_list,Chunk_2D,tree_src,0);
	}
	else if(Chunk_2D.get_x_size()==1 && Chunk_2D.get_z_size()==1){
		RPM_partition_1D(node_list,Chunk_2D,tree_src,1);
	}
	else if(Chunk_2D.get_x_size()==1 && Chunk_2D.get_y_size()==1){
		RPM_partition_1D(node_list,Chunk_2D,tree_src,2);
	}
	else if(direction==0){
		//now partition the yz plane
		//first evalute this plane
		struct chunk yz_plane=Chunk_2D;
		struct src_dst_list* yz_plane_node_list=node_list;
		struct plane_evaluation yz_eval;
		yz_eval = evaluate_plane(yz_plane_node_list, Chunk_2D,0);
		//go around the four possible merged regions
		//at most partition the plane into four parts
		struct chunk part0;
		struct chunk part1;
		struct chunk part2;
		struct chunk part3;
		int part0_srcx, part0_srcy, part0_srcz;
		int part1_srcx, part1_srcy, part1_srcz;
		int part2_srcx, part2_srcy, part2_srcz;
		int part3_srcx, part3_srcy, part3_srcz;
		int part_valid[4] = { 0, 0, 0, 0 };
		if (yz_eval.region0_merge == 0){
			//region 0 is merged with region1
			part_valid[0] = 1;
			part0.x_uplim = yz_plane_node_list->x;
			part0.x_downlim = yz_plane_node_list->x;
			part0.y_downlim = yz_plane_node_list->y;
			part0.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
			part0.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
			part0.z_uplim = yz_plane_node_list->z - 1 <0 ? Z - 1 : yz_plane_node_list->z - 1;

			part0_srcx = part0.x_downlim; 
			part0_srcy = part0.y_downlim;
			part0_srcz = part0.z_uplim;
		}
		
		else if (yz_eval.region0_merge == 1){
			//region0 is merged with regino7
			part_valid[0] = 1;
			part0.x_uplim = yz_plane_node_list->x;
			part0.x_downlim = yz_plane_node_list->x;
			part0.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
			part0.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
			part0.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
			part0.z_uplim = yz_plane_node_list->z;

			part0_srcx = part0.x_downlim;
			part0_srcy = part0.y_downlim;
			part0_srcz = part0.z_uplim;
		}
		else if (yz_eval.region0_merge == 2){ // the region 0 is not used
			part_valid[0] = 0;
		}

		if (yz_eval.region2_merge == 0){
			//region 2 is merged with region 3
			part_valid[1] = 1;
			part1.x_uplim = yz_plane_node_list->x;
			part1.x_downlim = yz_plane_node_list->x;
			part1.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
			part1.y_uplim = yz_plane_node_list->y - 1<0 ? Y - 1 : yz_plane_node_list->y - 1;
			part1.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
			part1.z_uplim = yz_plane_node_list->z;

			part1_srcx = part1.x_downlim;
			part1_srcy = part1.y_uplim;
			part1_srcz = part1.z_uplim;

		}
		else if (yz_eval.region2_merge == 1){
			if (part_valid[0]==1 && yz_eval.region2_merge == 0){
				//region0 and region2 should be merged together
				part_valid[1] = 0;
				part0.y_downlim = yz_plane.y_downlim;
				part0.y_uplim = yz_plane.y_uplim;
				part0.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
				part0.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
				part0_srcx = part0.x_downlim;
				part0_srcy = yz_plane_node_list->y;
				part0_srcz = part0.z_uplim;

			}
			//region2 is merged with region1
			else{
				part_valid[1] = 1;
				part1.x_uplim = yz_plane_node_list->x;
				part1.x_downlim = yz_plane_node_list->x;
				part1.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
				part1.y_uplim = yz_plane_node_list->y;
				part1.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
				part1.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
				part1_srcx = part1.x_downlim;
				part1_srcy = part1.y_uplim;
				part1_srcz = part1.z_uplim;
			}

		}
		else if (yz_eval.region2_merge == 2){ // the region 2 is not used
			part_valid[1] = 0;

		}

		if (yz_eval.region4_merge == 0){
			//region 4 is merged with region 5
			part_valid[2] = 1;
			part2.x_uplim = yz_plane_node_list->x;
			part2.x_downlim = yz_plane_node_list->x;
			part2.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
			part2.y_uplim = yz_plane_node_list->y;
			part2.z_downlim = yz_plane_node_list->z + 1 >= Z ? 0 : yz_plane_node_list->z + 1;
			part2.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
			part2_srcx = part2.x_downlim;
			part2_srcy = part2.y_uplim;
			part2_srcz = part2.z_downlim;

		}
		else if (yz_eval.region4_merge == 1){
			if (part_valid[1]==1 && yz_eval.region2_merge == 0){
				//region2 and region4 should be merged together
				part_valid[2] = 0;
				part1.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
				part1.y_uplim = yz_plane_node_list->y - 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
				part1.z_downlim = yz_plane.z_downlim;
				part1.z_uplim = yz_plane.z_uplim;
				part1_srcx = part1.x_downlim;
				part1_srcy = part1.y_uplim;
				part1_srcz = yz_plane_node_list->z;

			}
			//region4 is merged with region3
			else{
				part_valid[2] = 1;
				part2.x_uplim = yz_plane_node_list->x;
				part2.x_downlim = yz_plane_node_list->x;
				part2.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
				part2.y_uplim = yz_plane_node_list->y - 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
				part2.z_downlim = yz_plane_node_list->z;
				part2.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;

				part2_srcx = part2.x_downlim;
				part2_srcy = part2.y_uplim;
				part2_srcz = part2.z_downlim;
			}

		}
		else if (yz_eval.region4_merge == 2){ // the region 4 is not used
			part_valid[2] = 0;

		}

		if (yz_eval.region6_merge == 0){
			if(part_valid[0]==1 && yz_eval.region0_merge == 1){
				//region0 and region6 should be merged together
				part_valid[3] = 0;
				part0.x_uplim = yz_plane_node_list->x;
				part0.x_downlim = yz_plane_node_list->x;
				part0.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
				part0.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
				part0.z_downlim = yz_plane.z_downlim;
				part0.z_uplim = yz_plane.z_uplim;

				part0_srcx = part0.x_downlim;
				part0_srcy = part0.y_downlim;
				part0_srcz = yz_plane_node_list->z;

				
			}
			//region 6 is merged with region 7
			else{
				part_valid[3] = 1;
				part3.x_uplim = yz_plane_node_list->x;
				part3.x_downlim = yz_plane_node_list->x;
				part3.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
				part3.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
				part3.z_downlim = yz_plane_node_list->z;
				part3.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcy = part3.y_downlim;
				part3_srcz = part3.z_downlim;
			}

		}
		else if (yz_eval.region6_merge == 1){
			if (part_valid[2]==1 && yz_eval.region4_merge == 0){
				//region4 and region6 should be merged together
				part_valid[3] = 0;
				part2.y_downlim = yz_plane.y_downlim;
				part2.y_uplim = yz_plane.y_uplim;
				part2.z_downlim = yz_plane_node_list->z + 1 >= Z ? 0 : yz_plane_node_list->z + 1;
				part2.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
				part2_srcx = part2.x_downlim;
				part2_srcy = yz_plane_node_list->y;
				part2_srcz = part2.z_downlim;
			}
			//region6 is merged with region5
			else{
				part_valid[3] = 1;
				part3.x_uplim = yz_plane_node_list->x;
				part3.x_downlim = yz_plane_node_list->x;
				part3.y_downlim = yz_plane_node_list->y;
				part3.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
				part3.z_downlim = yz_plane_node_list->z + 1 >= Z ? 0 : yz_plane_node_list->z + 1;
				part3.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcy = part3.y_downlim;
				part3_srcz = part3.z_downlim;
			}

		}
		else if (yz_eval.region6_merge == 2){ // the region 6 is not used
			part_valid[3] = 0;

		}

		if (yz_eval.region0_merge != 0 && yz_eval.region2_merge != 1){
			if (yz_eval.zneg_enable){
				if (yz_eval.region0_merge != 1){
					//this is region1, now use part0 to cover it(part1 is also ok, but we use part0 here
					part_valid[0] = 1;
					part0.x_downlim = yz_plane.x_downlim;
					part0.x_uplim = yz_plane.x_uplim;
					part0.y_downlim = yz_plane_node_list->y;
					part0.y_uplim = yz_plane_node_list->y;
					part0.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
					part0.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
					part0_srcy = yz_plane_node_list->y;
					part0_srcx = yz_plane.x_downlim;
					part0_srcz = part0.z_uplim;
				}
				else if (yz_eval.region2_merge != 0){
					part_valid[1] = 1;
					part1.x_downlim = yz_plane.x_downlim;
					part1.x_uplim = yz_plane.x_uplim;
					part1.y_downlim = yz_plane_node_list->y;
					part1.y_uplim = yz_plane_node_list->y;
					part1.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
					part1.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
					part1_srcy = yz_plane_node_list->y;
					part1_srcx = yz_plane.x_downlim;
					part1_srcz = part1.z_uplim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 2){
						part_valid[2] = 1;
						part2.x_downlim = yz_plane.x_downlim;
						part2.x_uplim = yz_plane.x_uplim;
						part2.y_downlim = yz_plane_node_list->y;
						part2.y_uplim = yz_plane_node_list->y;
						part2.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
						part2.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
						part2_srcy = yz_plane_node_list->y;
						part2_srcx = yz_plane.x_downlim;
						part2_srcz = part2.z_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.x_downlim = yz_plane.x_downlim;
						part3.x_uplim = yz_plane.x_uplim;
						part3.y_downlim = yz_plane_node_list->y;
						part3.y_uplim = yz_plane_node_list->y;
						part3.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
						part3.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
						part3_srcy = yz_plane_node_list->y;
						part3_srcx = yz_plane.x_downlim;
						part3_srcz = part3.z_uplim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (yz_eval.region2_merge != 0 && yz_eval.region4_merge != 1){
			if (yz_eval.yneg_enable){
				if (yz_eval.region2_merge != 1){
					part_valid[1] = 1;
					part1.x_downlim = yz_plane.x_downlim;
					part1.x_uplim = yz_plane.x_uplim;
					part1.z_downlim = yz_plane_node_list->z;
					part1.z_uplim = yz_plane_node_list->z;
					part1.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
					part1.y_uplim = yz_plane_node_list->y - 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
					part1_srcy = part1.y_uplim;
					part1_srcx = yz_plane.x_downlim;
					part1_srcz = part1.z_uplim;
				}
				else if (yz_eval.region4_merge != 0){
					part_valid[2] = 1;
					part2.x_downlim = yz_plane.x_downlim;
					part2.x_uplim = yz_plane.x_uplim;
					part2.z_downlim = yz_plane_node_list->z;
					part2.z_uplim = yz_plane_node_list->z;
					part2.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
					part2.y_uplim = yz_plane_node_list->y - 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
					part2_srcy = part2.y_uplim;
					part2_srcx = yz_plane.x_downlim;
					part2_srcz = part2.z_uplim;

				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						part_valid[0] = 1;
						part0.x_downlim = yz_plane.x_downlim;
						part0.x_uplim = yz_plane.x_uplim;
						part0.z_downlim = yz_plane_node_list->z;
						part0.z_uplim = yz_plane_node_list->z;
						part0.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
						part0.y_uplim = yz_plane_node_list->y - 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
						part0_srcy = part0.y_uplim;
						part0_srcx = yz_plane.x_downlim;
						part0_srcz = part0.z_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.x_downlim = yz_plane.x_downlim;
						part3.x_uplim = yz_plane.x_uplim;
						part3.z_downlim = yz_plane_node_list->z;
						part3.z_uplim = yz_plane_node_list->z;
						part3.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
						part3.y_uplim = yz_plane_node_list->y - 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
						part3_srcy = part3.y_uplim;
						part3_srcx = yz_plane.x_downlim;
						part3_srcz = part3.z_uplim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (yz_eval.region4_merge != 0 && yz_eval.region6_merge != 1){
			if (yz_eval.zpos_enable){
				if (yz_eval.region4_merge != 1){
					part_valid[2] = 1;
					part2.x_downlim = yz_plane.x_downlim;
					part2.x_uplim = yz_plane.x_uplim;
					part2.y_downlim = yz_plane_node_list->y;
					part2.y_uplim = yz_plane_node_list->y;
					part2.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
					part2.z_downlim = yz_plane_node_list->z + 1 >= Z ? 0 : yz_plane_node_list->z + 1;
					part2_srcy = part2.y_uplim;
					part2_srcx = yz_plane.x_downlim;
					part2_srcz = part2.z_downlim;
				}
				else if (yz_eval.region6_merge != 0){
					part_valid[3] = 1;
					part3.x_downlim = yz_plane.x_downlim;
					part3.x_uplim = yz_plane.x_uplim;
					part3.y_downlim = yz_plane_node_list->y;
					part3.y_uplim = yz_plane_node_list->y;
					part3.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
					part3.z_downlim = yz_plane_node_list->z + 1 >= Z ? 0 : yz_plane_node_list->z + 1;
					part3_srcy = part3.y_uplim;
					part3_srcx = yz_plane.x_downlim;
					part3_srcz = part3.z_downlim;

				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						part_valid[0] = 1;
						part0.x_downlim = yz_plane.x_downlim;
						part0.x_uplim = yz_plane.x_uplim;
						part0.y_downlim = yz_plane_node_list->y;
						part0.y_uplim = yz_plane_node_list->y;
						part0.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
						part0.z_downlim = yz_plane_node_list->z + 1 >= Z ? 0 : yz_plane_node_list->z + 1;
						part0_srcy = part3.y_uplim;
						part0_srcx = yz_plane.x_downlim;
						part0_srcz = part3.z_downlim;
					}
					else if (part_idx == 1){
						part_valid[1] = 1;
						part1.x_downlim = yz_plane.x_downlim;
						part1.x_uplim = yz_plane.x_uplim;
						part1.y_downlim = yz_plane_node_list->y;
						part1.y_uplim = yz_plane_node_list->y;
						part1.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
						part1.z_downlim = yz_plane_node_list->z + 1 >= Z ? 0 : yz_plane_node_list->z + 1;
						part1_srcy = part1.y_uplim;
						part1_srcx = yz_plane.x_downlim;
						part1_srcz = part1.z_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (yz_eval.region6_merge != 0 && yz_eval.region0_merge != 1){
			if (yz_eval.ypos_enable){
				if (yz_eval.region6_merge != 1){
					part_valid[3] = 1;
					part3.x_downlim = yz_plane.x_downlim;
					part3.x_uplim = yz_plane.x_uplim;
					part3.z_downlim = yz_plane_node_list->z;
					part3.z_uplim = yz_plane_node_list->z;
					part3.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
					part3.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
					part3_srcy = part3.y_downlim;
					part3_srcx = yz_plane.x_downlim;
					part3_srcz = part3.z_downlim;
				}
				else if (yz_eval.region0_merge != 0){
					part_valid[0] = 1;
					part0.x_downlim = yz_plane.x_downlim;
					part0.x_uplim = yz_plane.x_uplim;
					part0.z_downlim = yz_plane_node_list->z;
					part0.z_uplim = yz_plane_node_list->z;
					part0.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
					part0.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
					part0_srcy = part0.y_downlim;
					part0_srcx = yz_plane.x_downlim;
					part0_srcz = part0.z_downlim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 1){
						part_valid[1] = 1;
						part1.x_downlim = yz_plane.x_downlim;
						part1.x_uplim = yz_plane.x_uplim;
						part1.z_downlim = yz_plane_node_list->z;
						part1.z_uplim = yz_plane_node_list->z;
						part1.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
						part1.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
						part1_srcy = part1.y_downlim;
						part1_srcx = yz_plane.x_downlim;
						part1_srcz = part1.z_downlim;
					}
					else if (part_idx == 2){
						part_valid[2] = 1;
						part2.x_downlim = yz_plane.x_downlim;
						part2.x_uplim = yz_plane.x_uplim;
						part2.z_downlim = yz_plane_node_list->z;
						part2.z_uplim = yz_plane_node_list->z;
						part2.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
						part2.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
						part2_srcy = part2.y_downlim;
						part2_srcx = yz_plane.x_downlim;
						part2_srcz = part2.z_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}

		//now distribute the yz_plane_node_list into parts (up to 4)
		struct src_dst_list* yz_plane_node_ptr=yz_plane_node_list->next;
		struct src_dst_list* part0_list=NULL;
		struct src_dst_list* part1_list=NULL;
		struct src_dst_list* part2_list=NULL;
		struct src_dst_list* part3_list=NULL;

		if(part_valid[0]){
			if(!(part0_list=(struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout<<"no mem"<<endl;
				exit(-1);
			}
			part0_list->valid=true;
			part0_list->src_or_dst=true;
			part0_list->next=NULL;
			part0_list->x=part0_srcx;
			part0_list->y=part0_srcy;
			part0_list->z=part0_srcz;
		}
		if(part_valid[1]){
			if(!(part1_list=(struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout<<"no mem"<<endl;
				exit(-1);
			}
			part1_list->valid=true;
			part1_list->src_or_dst=true;
			part1_list->next=NULL;
			part1_list->x=part1_srcx;
			part1_list->y=part1_srcy;
			part1_list->z=part1_srcz;
		}
		if(part_valid[2]){
			if(!(part2_list=(struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout<<"no mem"<<endl;
				exit(-1);
			}
			part2_list->valid=true;
			part2_list->src_or_dst=true;
			part2_list->next=NULL;
			part2_list->x=part2_srcx;
			part2_list->y=part2_srcy;
			part2_list->z=part2_srcz;
		}
		if(part_valid[3]){
			if(!(part3_list=(struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout<<"no mem"<<endl;
				exit(-1);
			}
			part3_list->valid=true;
			part3_list->src_or_dst=true;
			part3_list->next=NULL;
			part3_list->x=part3_srcx;
			part3_list->y=part3_srcy;
			part3_list->z=part3_srcz;
		}

		struct src_dst_list* new_node;

		while (yz_plane_node_ptr){
			if (part_valid[0] && within_range(part0, yz_plane_node_ptr)){
				//insert a node into the part0 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = yz_plane_node_ptr->x;
				new_node->y = yz_plane_node_ptr->y;
				new_node->z = yz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part0_list->next;
				part0_list->next = new_node;	

			}
			else if (part_valid[1] && within_range(part1, yz_plane_node_ptr)){
				
				//insert a node into the part1 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = yz_plane_node_ptr->x;
				new_node->y = yz_plane_node_ptr->y;
				new_node->z = yz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part1_list->next;
				part1_list->next = new_node;
				

			}
			else if (part_valid[2] && within_range(part2, yz_plane_node_ptr)){
				
				//insert a node into the part2 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = yz_plane_node_ptr->x;
				new_node->y = yz_plane_node_ptr->y;
				new_node->z = yz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part2_list->next;
				part2_list->next = new_node;
				

			}
			else if (part_valid[3] && within_range(part3, yz_plane_node_ptr)){
				
					//insert a node into the part3 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = yz_plane_node_ptr->x;
				new_node->y = yz_plane_node_ptr->y;
				new_node->z = yz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part3_list->next;
				part3_list->next = new_node;
				

			}

			yz_plane_node_ptr = yz_plane_node_ptr->next;
		}
		
		int new_weight = (tree_src->weight == 1) ? 1 : tree_src->weight / 2;
		node* part0_src;
		node* part1_src;
		node* part2_src;
		node* part3_src;
		
		if (part_valid[0]){
			tree_src->children[tree_src->num_children] = new node(part0_list->x,part0_list->y,part0_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part0_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[1]){
			tree_src->children[tree_src->num_children] = new node(part1_list->x, part1_list->y, part1_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part1_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[2]){
			tree_src->children[tree_src->num_children] = new node(part2_list->x, part2_list->y, part2_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part2_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[3]){
			tree_src->children[tree_src->num_children] = new node(part3_list->x, part3_list->y, part3_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part3_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		//print the current the src and dst nodes on the current node
		fout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
			accumulate_link(tree_src,tree_src->children[children_idx]);
		}
		fout << "}" << endl;

		cout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
			//accumulate_link(tree_src, tree_src->children[children_idx]);
		}
		cout << "}" << endl;

		struct src_dst_list* free_ptr;

		struct src_dst_list* next_free_ptr;


		if (part_valid[0]){
			RPM_partition_2D(part0_list, part0, part0_src,0);
		}
		//free the four part_list
		free_ptr = part0_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		if (part_valid[1]){
			RPM_partition_2D(part1_list, part1, part1_src,0);
		}


		free_ptr = part1_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		if (part_valid[2]){
			RPM_partition_2D(part2_list, part2, part2_src,0);
		}
		free_ptr = part2_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		if (part_valid[3]){
			RPM_partition_2D(part3_list, part3, part3_src,0);
		}

	
	
		free_ptr = part3_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}


	}
	else if(direction==1){
		//now partition the xz plane
		struct chunk xz_plane= Chunk_2D;
		struct src_dst_list* xz_plane_node_list=node_list;
		//first evalute this plane
		struct plane_evaluation xz_eval;
		xz_eval = evaluate_plane(xz_plane_node_list, xz_plane, 1);
		//go around the four possible merged regions
		//at most partition the plane into four parts
		struct chunk part0;
		struct chunk part1;
		struct chunk part2;
		struct chunk part3;
		int part0_srcx, part0_srcy, part0_srcz;
		int part1_srcx, part1_srcy, part1_srcz;
		int part2_srcx, part2_srcy, part2_srcz;
		int part3_srcx, part3_srcy, part3_srcz;

		int part_valid[4] = { 0, 0, 0, 0 };
		if (xz_eval.region0_merge == 0){
			//region 0 is merged with region1
			part_valid[0] = 1;

			part0.y_uplim = xz_plane_node_list->y;
			part0.y_downlim = xz_plane_node_list->y;
			part0.x_downlim = xz_plane_node_list->x;
			part0.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
			part0.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
			part0.z_uplim = xz_plane_node_list->z - 1<0 ? Z - 1 : xz_plane_node_list->z - 1;
			part0_srcx = part0.x_downlim;
			part0_srcy = part0.y_downlim;
			part0_srcz = part0.z_uplim;
		}

		else if (xz_eval.region0_merge == 1){
			//region0 is merged with regino7
			part_valid[0] = 1;
			part0.y_uplim = xz_plane_node_list->y;
			part0.y_downlim = xz_plane_node_list->y;
			part0.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
			part0.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
			part0.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
			part0.z_uplim = xz_plane_node_list->z;
			part0_srcx = part0.x_downlim;
			part0_srcy = part0.y_downlim;
			part0_srcz = part0.z_uplim;
		}
		else if (xz_eval.region0_merge == 2){ // the region 0 is not used
			part_valid[0] = 0;
		}

		if (xz_eval.region2_merge == 0){
			//region 2 is merged with region 3
			part_valid[1] = 1;

			part1.y_uplim = xz_plane_node_list->y;
			part1.y_downlim = xz_plane_node_list->y;
			part1.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
			part1.x_uplim = xz_plane_node_list->x - 1<0 ? X - 1 : xz_plane_node_list->x - 1;
			part1.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
			part1.z_uplim = xz_plane_node_list->z;
			part1_srcx = part1.x_uplim;
			part1_srcy = part1.y_downlim;
			part1_srcz = part1.z_uplim;
		}
		else if (xz_eval.region2_merge == 1){
			if (part_valid[0] == 1 && xz_eval.region0_merge == 0){
				//region0 and region2 should be merged together
				part_valid[1] = 0;
				part0.x_downlim = xz_plane.x_downlim;
				part0.x_uplim = xz_plane.x_uplim;
				part0.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
				part0.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
				part0_srcx = xz_plane_node_list->x;
				part0_srcy = part0.y_downlim;
				part0_srcz = part0.z_uplim;

			}
			//region2 is merged with region1
			else{
				part_valid[1] = 1;

				part1.y_uplim = xz_plane_node_list->y;
				part1.y_downlim = xz_plane_node_list->y;
				part1.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
				part1.x_uplim = xz_plane_node_list->x;
				part1.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
				part1.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
				part1_srcx = part1.x_uplim;
				part1_srcy = part1.y_downlim;
				part1_srcz = part1.z_uplim;
			}

		}
		else if (xz_eval.region2_merge == 2){ // the region 2 is not used
			part_valid[1] = 0;

		}

		if (xz_eval.region4_merge == 0){
			//region 4 is merged with region 5
			part_valid[2] = 1;
			part2.y_uplim = xz_plane_node_list->y;
			part2.y_downlim = xz_plane_node_list->y;
			part2.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
			part2.x_uplim = xz_plane_node_list->x;
			part2.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
			part2.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
			part2_srcx = part2.x_uplim;
			part2_srcy = part2.y_downlim;
			part2_srcz = part2.z_downlim;

		}
		else if (xz_eval.region4_merge == 1){
			if (part_valid[1] == 1 && xz_eval.region2_merge == 0){
				//region2 and region4 should be merged together
				part_valid[2] = 0;


				part1.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
				part1.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
				part1.z_downlim = xz_plane.z_downlim;
				part1.z_uplim = xz_plane.z_uplim;
				part1_srcx = part1.x_uplim;
				part1_srcy = part1.y_downlim;
				part1_srcz = xz_plane_node_list->z;
			}
			//region4 is merged with region3
			else{
				part_valid[2] = 1;

				part2.y_uplim = xz_plane_node_list->y;
				part2.y_downlim = xz_plane_node_list->y;
				part2.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
				part2.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
				part2.z_downlim = xz_plane_node_list->z;
				part2.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
				part2_srcx = part2.x_uplim;
				part2_srcy = part2.y_downlim;
				part2_srcz = part2.z_downlim;
			}

		}
		else if (xz_eval.region4_merge == 2){ // the region 4 is not used
			part_valid[2] = 0;

		}

		if (xz_eval.region6_merge == 0){
			if (part_valid[0] == 1 && xz_eval.region0_merge == 1){
				//region0 and region6 should be merged together
				part_valid[3] = 0;


				part0.y_uplim = xz_plane_node_list->y;
				part0.y_downlim = xz_plane_node_list->y;
				part0.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
				part0.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
				part0.z_downlim = xz_plane.z_downlim;
				part0.z_uplim = xz_plane.z_uplim;
				part0_srcx = part0.x_downlim;
				part0_srcy = part0.y_downlim;
				part0_srcz = xz_plane_node_list->z;

			}
			//region 6 is merged with region 7
			else{
				part_valid[3] = 1;

				part3.y_uplim = xz_plane_node_list->y;
				part3.y_downlim = xz_plane_node_list->y;
				part3.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
				part3.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
				part3.z_downlim = xz_plane_node_list->z;
				part3.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcy = part3.y_downlim;
				part3_srcz = part3.z_downlim;
			}

		}
		else if (xz_eval.region6_merge == 1){
			if (part_valid[2] == 1 && xz_eval.region4_merge == 0){
				//region4 and region6 should be merged together
				part_valid[3] = 0;

				part2.x_downlim = xz_plane.x_downlim;
				part2.x_uplim = xz_plane.x_uplim;
				part2.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
				part2.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
				part2_srcx = xz_plane_node_list->x;
				part2_srcy = part2.y_downlim;
				part2_srcz = part2.z_downlim;

			}
			//region6 is merged with region5
			else{
				part_valid[3] = 1;


				part3.y_uplim = xz_plane_node_list->y;
				part3.y_downlim = xz_plane_node_list->y;
				part3.x_downlim = xz_plane_node_list->x;
				part3.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
				part3.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
				part3.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcy = part3.y_downlim;
				part3_srcz = part3.z_downlim;
			}

		}
		else if (xz_eval.region6_merge == 2){ // the region 6 is not used
			part_valid[3] = 0;

		}
		if (xz_eval.region0_merge !=0 && xz_eval.region2_merge != 1){
			if (xz_eval.zneg_enable){
				if (xz_eval.region0_merge != 1){
					//this is region1, now use part0 to cover it(part1 is also ok, but we use part0 here
					part_valid[0] = 1;
					part0.y_downlim = xz_plane.y_downlim;
					part0.y_uplim = xz_plane.y_uplim;
					part0.x_downlim = xz_plane_node_list->x;
					part0.x_uplim = xz_plane_node_list->x;
					part0.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
					part0.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
					part0_srcx = xz_plane_node_list->x;
					part0_srcy = xz_plane.y_downlim;
					part0_srcz = part0.z_uplim;
				}
				else if (xz_eval.region2_merge != 0){
					part_valid[1] = 1;
					part1.y_downlim = xz_plane.y_downlim;
					part1.y_uplim = xz_plane.y_uplim;
					part1.x_downlim = xz_plane_node_list->x;
					part1.x_uplim = xz_plane_node_list->x;
					part1.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
					part1.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
					part1_srcx = xz_plane_node_list->x;
					part1_srcy = xz_plane.y_downlim;
					part1_srcz = part1.z_uplim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 2){
						part_valid[2] = 1;
						part2.y_downlim = xz_plane.y_downlim;
						part2.y_uplim = xz_plane.y_uplim;
						part2.x_downlim = xz_plane_node_list->x;
						part2.x_uplim = xz_plane_node_list->x;
						part2.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
						part2.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
						part2_srcx = xz_plane_node_list->x;
						part2_srcy = xz_plane.y_downlim;
						part2_srcz = part2.z_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.y_downlim = xz_plane.y_downlim;
						part3.y_uplim = xz_plane.y_uplim;
						part3.x_downlim = xz_plane_node_list->x;
						part3.x_uplim = xz_plane_node_list->x;
						part3.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
						part3.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
						part3_srcx = xz_plane_node_list->x;
						part3_srcy = xz_plane.y_downlim;
						part3_srcz = part3.z_uplim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (xz_eval.region2_merge != 0 && xz_eval.region4_merge != 1){
			if (xz_eval.xneg_enable){
				if (xz_eval.region2_merge != 1){
					part_valid[1] = 1;
					part1.y_downlim = xz_plane.y_downlim;
					part1.y_uplim = xz_plane.y_uplim;
					part1.z_downlim = xz_plane_node_list->z;
					part1.z_uplim = xz_plane_node_list->z;
					part1.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
					part1.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
					part1_srcx = part1.x_uplim;
					part1_srcy = xz_plane.y_downlim;
					part1_srcz = part1.z_uplim;
				}
				else if (xz_eval.region4_merge != 0){
					part_valid[2] = 1;
					part2.y_downlim = xz_plane.y_downlim;
					part2.y_uplim = xz_plane.y_uplim;
					part2.z_downlim = xz_plane_node_list->z;
					part2.z_uplim = xz_plane_node_list->z;
					part2.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
					part2.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
					part2_srcx = part2.x_uplim;
					part2_srcy = xz_plane.y_downlim;
					part2_srcz = part2.z_uplim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						part_valid[0] = 1;
						part0.y_downlim = xz_plane.y_downlim;
						part0.y_uplim = xz_plane.y_uplim;
						part0.z_downlim = xz_plane_node_list->z;
						part0.z_uplim = xz_plane_node_list->z;
						part0.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
						part0.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
						part0_srcx = part0.x_uplim;
						part0_srcy = xz_plane.y_downlim;
						part0_srcz = part0.z_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.y_downlim = xz_plane.y_downlim;
						part3.y_uplim = xz_plane.y_uplim;
						part3.z_downlim = xz_plane_node_list->z;
						part3.z_uplim = xz_plane_node_list->z;
						part3.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
						part3.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
						part3_srcx = part3.x_uplim;
						part3_srcy = xz_plane.y_downlim;
						part3_srcz = part3.z_uplim;
					}
					else
						cout << "bug" << endl;
				}

			}
		}
		if (xz_eval.region4_merge != 0 && xz_eval.region6_merge != 1){
			if (xz_eval.zpos_enable){
				if (xz_eval.region4_merge != 1){
					part_valid[2] = 1;
					part2.y_downlim = xz_plane.y_downlim;
					part2.y_uplim = xz_plane.y_uplim;
					part2.x_downlim = xz_plane_node_list->x;
					part2.x_uplim = xz_plane_node_list->x;
					part2.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
					part2.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
					part2_srcx = part2.x_uplim;
					part2_srcy = xz_plane.y_downlim;
					part2_srcz = part2.z_downlim;
				}
				else if (xz_eval.region6_merge != 0){
					part_valid[3] = 1;
					part3.y_downlim = xz_plane.y_downlim;
					part3.y_uplim = xz_plane.y_uplim;
					part3.x_downlim = xz_plane_node_list->x;
					part3.x_uplim = xz_plane_node_list->x;
					part3.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
					part3.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
					part3_srcx = part3.x_uplim;
					part3_srcy = xz_plane.y_downlim;
					part3_srcz = part3.z_downlim;

				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						part_valid[0] = 1;
						part0.y_downlim = xz_plane.y_downlim;
						part0.y_uplim = xz_plane.y_uplim;
						part0.x_downlim = xz_plane_node_list->x;
						part0.x_uplim = xz_plane_node_list->x;
						part0.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
						part0.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
						part0_srcx = part0.x_uplim;
						part0_srcy = xz_plane.y_downlim;
						part0_srcz = part0.z_downlim;
					}
					else if (part_idx == 1){
						part_valid[1] = 1;
						part1.y_downlim = xz_plane.y_downlim;
						part1.y_uplim = xz_plane.y_uplim;
						part1.x_downlim = xz_plane_node_list->x;
						part1.x_uplim = xz_plane_node_list->x;
						part1.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
						part1.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
						part1_srcx = part0.x_uplim;
						part1_srcy = xz_plane.y_downlim;
						part1_srcz = part0.z_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (xz_eval.region6_merge != 0 && xz_eval.region0_merge != 1){
			if (xz_eval.xpos_enable){
				if (xz_eval.region6_merge != 1){
					part_valid[3] = 1;
					part3.y_downlim = xz_plane.y_downlim;
					part3.y_uplim = xz_plane.y_uplim;
					part3.z_downlim = xz_plane_node_list->z;
					part3.z_uplim = xz_plane_node_list->z;
					part3.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
					part3.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
					part3_srcx = part3.x_downlim;
					part3_srcy = xz_plane.y_downlim;
					part3_srcz = part3.z_downlim;
				}
				else if (xz_eval.region0_merge != 0){
					part_valid[0] = 1;
					part0.y_downlim = xz_plane.y_downlim;
					part0.y_uplim = xz_plane.y_uplim;
					part0.z_downlim = xz_plane_node_list->z;
					part0.z_uplim = xz_plane_node_list->z;
					part0.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
					part0.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
					part0_srcx = part0.x_downlim;
					part0_srcy = xz_plane.y_downlim;
					part0_srcz = part0.z_downlim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 1){
						part_valid[1] = 1;
						part1.y_downlim = xz_plane.y_downlim;
						part1.y_uplim = xz_plane.y_uplim;
						part1.z_downlim = xz_plane_node_list->z;
						part1.z_uplim = xz_plane_node_list->z;
						part1.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
						part1.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
						part1_srcx = part1.x_downlim;
						part1_srcy = xz_plane.y_downlim;
						part1_srcz = part1.z_downlim;
					}
					else if (part_idx == 2){
						part_valid[2] = 1;
						part2.y_downlim = xz_plane.y_downlim;
						part2.y_uplim = xz_plane.y_uplim;
						part2.z_downlim = xz_plane_node_list->z;
						part2.z_uplim = xz_plane_node_list->z;
						part2.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
						part2.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
						part2_srcx = part2.x_downlim;
						part2_srcy = xz_plane.y_downlim;
						part2_srcz = part2.z_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}

		//now distribute the xz_plane_node_list into parts (up to 4)
		struct src_dst_list* xz_plane_node_ptr = xz_plane_node_list->next;
		struct src_dst_list* part0_list = NULL;
		struct src_dst_list* part1_list = NULL;
		struct src_dst_list* part2_list = NULL;
		struct src_dst_list* part3_list = NULL;

		if (part_valid[0]){
			if (!(part0_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part0_list->valid = true;
			part0_list->src_or_dst = true;
			part0_list->next = NULL;
			part0_list->x = part0_srcx;
			part0_list->y = part0_srcy;
			part0_list->z = part0_srcz;
		}
		if (part_valid[1]){
			if (!(part1_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part1_list->valid = true;
			part1_list->src_or_dst = true;
			part1_list->next = NULL;
			part1_list->x = part1_srcx;
			part1_list->y = part1_srcy;
			part1_list->z = part1_srcz;
		}
		if (part_valid[2]){
			if (!(part2_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part2_list->valid = true;
			part2_list->src_or_dst = true;
			part2_list->next = NULL;
			part2_list->x = part2_srcx;
			part2_list->y = part2_srcy;
			part2_list->z = part2_srcz;
		}
		if (part_valid[3]){
			if (!(part3_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part3_list->valid = true;
			part3_list->src_or_dst = true;
			part3_list->next = NULL;
			part3_list->x = part3_srcx;
			part3_list->y = part3_srcy;
			part3_list->z = part3_srcz;
		}

		struct src_dst_list* new_node;

		while (xz_plane_node_ptr){
			if (part_valid[0] && within_range(part0, xz_plane_node_ptr)){
				//insert a node into the part0 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xz_plane_node_ptr->x;
				new_node->y = xz_plane_node_ptr->y;
				new_node->z = xz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part0_list->next;
				part0_list->next = new_node;

			}
			else if (part_valid[1] && within_range(part1, xz_plane_node_ptr)){

				//insert a node into the part1 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xz_plane_node_ptr->x;
				new_node->y = xz_plane_node_ptr->y;
				new_node->z = xz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part1_list->next;
				part1_list->next = new_node;


			}
			else if (part_valid[2] && within_range(part2, xz_plane_node_ptr)){

				//insert a node into the part2 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xz_plane_node_ptr->x;
				new_node->y = xz_plane_node_ptr->y;
				new_node->z = xz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part2_list->next;
				part2_list->next = new_node;


			}
			else if (part_valid[3] && within_range(part3, xz_plane_node_ptr)){

				//insert a node into the part3 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xz_plane_node_ptr->x;
				new_node->y = xz_plane_node_ptr->y;
				new_node->z = xz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part3_list->next;
				part3_list->next = new_node;


			}

			xz_plane_node_ptr = xz_plane_node_ptr->next;
		}

		int new_weight = (tree_src->weight == 1) ? 1 : tree_src->weight / 2;
		node* part0_src;
		node* part1_src;
		node* part2_src;
		node* part3_src;

		if (part_valid[0]){
			tree_src->children[tree_src->num_children] = new node(part0_list->x, part0_list->y, part0_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part0_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[1]){
			tree_src->children[tree_src->num_children] = new node(part1_list->x, part1_list->y, part1_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part1_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[2]){
			tree_src->children[tree_src->num_children] = new node(part2_list->x, part2_list->y, part2_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part2_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[3]){
			tree_src->children[tree_src->num_children] = new node(part3_list->x, part3_list->y, part3_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part3_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		//print the current the src and dst nodes on the current node
		fout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
			accumulate_link(tree_src,tree_src->children[children_idx]);
		}
		fout << "}" << endl;

		cout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
			//accumulate_link(tree_src, tree_src->children[children_idx]);
		}
		cout << "}" << endl;

		struct src_dst_list* free_ptr;

		struct src_dst_list* next_free_ptr;

		if (part_valid[0]){
			RPM_partition_2D(part0_list, part0, part0_src,1);
		}
		free_ptr = part0_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		if (part_valid[1]){
			RPM_partition_2D(part1_list, part1, part1_src,1);
		}
		free_ptr = part1_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		if (part_valid[2]){
			RPM_partition_2D(part2_list, part2, part2_src,1);
		}
		free_ptr = part2_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}

		if (part_valid[3]){
			RPM_partition_2D(part3_list, part3, part3_src,1);
		}

		//free the four part_list



		free_ptr = part3_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
	}
	else if(direction==2){
		//now partition the xz plane
		//first evalute this plane
		struct chunk xy_plane=Chunk_2D;
		struct src_dst_list* xy_plane_node_list=node_list;
		struct plane_evaluation xy_eval;
		xy_eval = evaluate_plane(xy_plane_node_list, xy_plane, 2);
		//go around the four possible merged regions
		//at most partition the plane into four parts
		struct chunk part0;
		struct chunk part1;
		struct chunk part2;
		struct chunk part3;
		int part0_srcx, part0_srcy, part0_srcz;
		int part1_srcx, part1_srcy, part1_srcz;
		int part2_srcx, part2_srcy, part2_srcz;
		int part3_srcx, part3_srcy, part3_srcz;

		int part_valid[4] = { 0, 0, 0, 0 };
		if (xy_eval.region0_merge == 0){
			//region 0 is merged with region1
			part_valid[0] = 1;

			part0.z_uplim = xy_plane_node_list->z;
			part0.z_downlim = xy_plane_node_list->z;
			part0.x_downlim = xy_plane_node_list->x;
			part0.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
			part0.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
			part0.y_uplim = xy_plane_node_list->y - 1<0 ? Y - 1 : xy_plane_node_list->y - 1;
			part0_srcx = part0.x_downlim;
			part0_srcz = part0.z_downlim;
			part0_srcy = part0.y_uplim;
		}

		else if (xy_eval.region0_merge == 1){
			//region0 is merged with regino7
			part_valid[0] = 1;
			part0.z_uplim = xy_plane_node_list->z;
			part0.z_downlim = xy_plane_node_list->z;
			part0.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
			part0.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
			part0.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
			part0.y_uplim = xy_plane_node_list->y;
			part0_srcx = part0.x_downlim;
			part0_srcz = part0.z_downlim;
			part0_srcy = part0.y_uplim;
		}
		else if (xy_eval.region0_merge == 2){ // the region 0 is not used
			part_valid[0] = 0;
		}

		if (xy_eval.region2_merge == 0){
			//region 2 is merged with region 3
			part_valid[1] = 1;

			part1.z_uplim = xy_plane_node_list->z;
			part1.z_downlim = xy_plane_node_list->z;
			part1.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
			part1.x_uplim = xy_plane_node_list->x - 1<0 ? X - 1 : xy_plane_node_list->x - 1;
			part1.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
			part1.y_uplim = xy_plane_node_list->y;
			part1_srcx = part1.x_uplim;
			part1_srcz = part1.z_downlim;
			part1_srcy = part1.y_uplim;

		}
		else if (xy_eval.region2_merge == 1){
			if (part_valid[0] == 1 && xy_eval.region0_merge == 0){
				//region0 and region2 should be merged together
				part_valid[1] = 0;
				part0.x_downlim = xy_plane.x_downlim;
				part0.x_uplim = xy_plane.x_uplim;
				part0.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
				part0.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
				part0_srcx = xy_plane_node_list->x;
				part0_srcz = part0.z_downlim;
				part0_srcy = part0.y_uplim;

			}
			//region2 is merged with region1
			else{
				part_valid[1] = 1;

				part1.z_uplim = xy_plane_node_list->z;
				part1.z_downlim = xy_plane_node_list->z;
				part1.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
				part1.x_uplim = xy_plane_node_list->x;
				part1.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
				part1.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
				part1_srcx = part1.x_uplim;
				part1_srcz = part1.z_downlim;
				part1_srcy = part1.y_uplim;
			}

		}
		else if (xy_eval.region2_merge == 2){ // the region 2 is not used
			part_valid[1] = 0;

		}

		if (xy_eval.region4_merge == 0){
			//region 4 is merged with region 5
			part_valid[2] = 1;
			part2.z_uplim = xy_plane_node_list->z;
			part2.z_downlim = xy_plane_node_list->z;
			part2.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
			part2.x_uplim = xy_plane_node_list->x;
			part2.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
			part2.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
			part2_srcx = part2.x_uplim;
			part2_srcz = part2.z_downlim;
			part2_srcy = part2.y_downlim;

		}
		else if (xy_eval.region4_merge == 1){
			if (part_valid[1] == 1 && xy_eval.region2_merge == 0){
				//region2 and region4 should be merged together
				part_valid[2] = 0;


				part1.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
				part1.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
				part1.y_downlim = xy_plane.y_downlim;
				part1.y_uplim = xy_plane.y_uplim;
				part1_srcx = part1.x_uplim;
				part1_srcz = part1.z_downlim;
				part1_srcy = xy_plane_node_list->y;

			}
			//region4 is merged with region3
			else{
				part_valid[2] = 1;

				part2.z_uplim = xy_plane_node_list->z;
				part2.z_downlim = xy_plane_node_list->z;
				part2.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
				part2.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
				part2.y_downlim = xy_plane_node_list->y;
				part2.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
				part2_srcx = part2.x_uplim;
				part2_srcz = part2.z_downlim;
				part2_srcy = part2.y_downlim;
			}

		}
		else if (xy_eval.region4_merge == 2){ // the region 4 is not used
			part_valid[2] = 0;

		}

		if (xy_eval.region6_merge == 0){
			if (part_valid[0] == 1 && xy_eval.region0_merge == 1){
				//region0 and region6 should be merged together
				part_valid[3] = 0;


				part0.z_uplim = xy_plane_node_list->z;
				part0.z_downlim = xy_plane_node_list->z;
				part0.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
				part0.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
				part0.y_downlim = xy_plane.y_downlim;
				part0.y_uplim = xy_plane.y_uplim;
				part0_srcx = part0.x_downlim;
				part0_srcz = part0.z_downlim;
				part0_srcy = xy_plane_node_list->y;

			}
			//region 6 is merged with region 7
			else{
				part_valid[3] = 1;

				part3.z_uplim = xy_plane_node_list->z;
				part3.z_downlim = xy_plane_node_list->z;
				part3.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
				part3.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
				part3.y_downlim = xy_plane_node_list->y;
				part3.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcz = part3.z_downlim;
				part3_srcy = part3.y_downlim;
			}

		}
		else if (xy_eval.region6_merge == 1){
			if (part_valid[2] == 1 && xy_eval.region4_merge == 0){
				//region4 and region6 should be merged together
				part_valid[3] = 0;

				part2.x_downlim = xy_plane.x_downlim;
				part2.x_uplim = xy_plane.x_uplim;
				part2.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
				part2.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
				part2_srcx = xy_plane_node_list->x;
				part2_srcz = part2.z_downlim;
				part2_srcy = part2.y_downlim;

			}
			//region6 is merged with region5
			else{
				part_valid[3] = 1;


				part3.z_uplim = xy_plane_node_list->z;
				part3.z_downlim = xy_plane_node_list->z;
				part3.x_downlim = xy_plane_node_list->x;
				part3.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
				part3.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
				part3.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcz = part3.z_downlim;
				part3_srcy = part3.y_downlim;
			}

		}
		else if (xy_eval.region6_merge == 2){ // the region 6 is not used
			part_valid[3] = 0;

		}

		if (xy_eval.region0_merge !=0 && xy_eval.region2_merge !=1){
			if (xy_eval.yneg_enable){
				if (xy_eval.region0_merge != 1){
					//this is region1, now use part0 to cover it(part1 is also ok, but we use part0 here
					part_valid[0] = 1;
					part0.z_downlim = xy_plane.z_downlim;
					part0.z_uplim = xy_plane.z_uplim;
					part0.x_downlim = xy_plane_node_list->x;
					part0.x_uplim = xy_plane_node_list->x;
					part0.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
					part0.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
					part0_srcx = xy_plane_node_list->x;
					part0_srcz = xy_plane.z_downlim;
					part0_srcy = part0.y_uplim;
				}
				else if (xy_eval.region2_merge != 0){
					//this is region1, now use part1 to cover it(part1 is also ok, but we use part0 here
					part_valid[1] = 1;
					part1.z_downlim = xy_plane.z_downlim;
					part1.z_uplim = xy_plane.z_uplim;
					part1.x_downlim = xy_plane_node_list->x;
					part1.x_uplim = xy_plane_node_list->x;
					part1.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
					part1.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
					part1_srcx = xy_plane_node_list->x;
					part1_srcz = xy_plane.z_downlim;
					part1_srcy = part1.y_uplim;

				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 2){
						//this is region1, now use part1 to cover it(part1 is also ok, but we use part0 here
						part_valid[2] = 1;
						part2.z_downlim = xy_plane.z_downlim;
						part2.z_uplim = xy_plane.z_uplim;
						part2.x_downlim = xy_plane_node_list->x;
						part2.x_uplim = xy_plane_node_list->x;
						part2.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
						part2.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
						part2_srcx = xy_plane_node_list->x;
						part2_srcz = xy_plane.z_downlim;
						part2_srcy = part2.y_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.z_downlim = xy_plane.z_downlim;
						part3.z_uplim = xy_plane.z_uplim;
						part3.x_downlim = xy_plane_node_list->x;
						part3.x_uplim = xy_plane_node_list->x;
						part3.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
						part3.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
						part3_srcx = xy_plane_node_list->x;
						part3_srcz = xy_plane.z_downlim;
						part3_srcy = part3.y_uplim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (xy_eval.region2_merge != 0 && xy_eval.region4_merge != 1){
			if (xy_eval.xneg_enable){
				if (xy_eval.region2_merge != 1){
					part_valid[1] = 1;
					part1.z_downlim = xy_plane.z_downlim;
					part1.z_uplim = xy_plane.z_uplim;
					part1.y_downlim = xy_plane_node_list->y;
					part1.y_uplim = xy_plane_node_list->y;
					part1.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
					part1.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
					part1_srcx = part1.x_uplim;
					part1_srcz = xy_plane.z_downlim;
					part1_srcy = part1.y_uplim;
				}
				else if (xy_eval.region4_merge != 0){
					part_valid[2] = 1;
					part2.z_downlim = xy_plane.z_downlim;
					part2.z_uplim = xy_plane.z_uplim;
					part2.y_downlim = xy_plane_node_list->y;
					part2.y_uplim = xy_plane_node_list->y;
					part2.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
					part2.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
					part2_srcx = part2.x_uplim;
					part2_srcz = xy_plane.z_downlim;
					part2_srcy = part2.y_uplim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						//this is region1, now use part1 to cover it(part1 is also ok, but we use part0 here
						part_valid[0] = 1;
						part0.z_downlim = xy_plane.z_downlim;
						part0.z_uplim = xy_plane.z_uplim;
						part0.y_downlim = xy_plane_node_list->y;
						part0.y_uplim = xy_plane_node_list->y;
						part0.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
						part0.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
						part0_srcx = part0.x_uplim;
						part0_srcz = xy_plane.z_downlim;
						part0_srcy = part0.y_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.z_downlim = xy_plane.z_downlim;
						part3.z_uplim = xy_plane.z_uplim;
						part3.y_downlim = xy_plane_node_list->y;
						part3.y_uplim = xy_plane_node_list->y;
						part3.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
						part3.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
						part3_srcx = part0.x_uplim;
						part3_srcz = xy_plane.z_downlim;
						part3_srcy = part0.y_uplim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (xy_eval.region4_merge != 0 && xy_eval.region6_merge != 1){
			if (xy_eval.ypos_enable){
				if (xy_eval.region4_merge != 1){
					part_valid[2] = 1;
					part2.z_downlim = xy_plane.z_downlim;
					part2.z_uplim = xy_plane.z_uplim;
					part2.x_downlim = xy_plane_node_list->x;
					part2.x_uplim = xy_plane_node_list->x;
					part2.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
					part2.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
					part2_srcx = part2.x_uplim;
					part2_srcz = xy_plane.z_downlim;
					part2_srcy = part2.y_downlim;
				}
				else if (xy_eval.region6_merge != 0){
					part_valid[3] = 1;
					part3.z_downlim = xy_plane.z_downlim;
					part3.z_uplim = xy_plane.z_uplim;
					part3.x_downlim = xy_plane_node_list->x;
					part3.x_uplim = xy_plane_node_list->x;
					part3.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
					part3.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
					part3_srcx = part3.x_uplim;
					part3_srcz = xy_plane.z_downlim;
					part3_srcy = part3.y_downlim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						//this is region1, now use part1 to cover it(part1 is also ok, but we use part0 here
						part_valid[0] = 1;
						part0.z_downlim = xy_plane.z_downlim;
						part0.z_uplim = xy_plane.z_uplim;
						part0.x_downlim = xy_plane_node_list->x;
						part0.x_uplim = xy_plane_node_list->x;
						part0.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
						part0.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
						part0_srcx = part0.x_uplim;
						part0_srcz = xy_plane.z_downlim;
						part0_srcy = part0.y_downlim;
					}
					else if (part_idx == 1){
						part_valid[1] = 1;
						part1.z_downlim = xy_plane.z_downlim;
						part1.z_uplim = xy_plane.z_uplim;
						part1.x_downlim = xy_plane_node_list->x;
						part1.x_uplim = xy_plane_node_list->x;
						part1.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
						part1.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
						part1_srcx = part1.x_uplim;
						part1_srcz = xy_plane.z_downlim;
						part1_srcy = part1.y_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (xy_eval.region6_merge !=0 && xy_eval.region0_merge !=1){
			if (xy_eval.xpos_enable){
				if (xy_eval.region6_merge != 1){
					part_valid[3] = 1;
					part3.z_downlim = xy_plane.z_downlim;
					part3.z_uplim = xy_plane.z_uplim;
					part3.y_downlim = xy_plane_node_list->y;
					part3.y_uplim = xy_plane_node_list->y;
					part3.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
					part3.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
					part3_srcx = part3.x_downlim;
					part3_srcz = xy_plane.z_downlim;
					part3_srcy = part3.y_downlim;
				}
				else if (xy_eval.region0_merge != 0){
					part_valid[0] = 1;
					part0.z_downlim = xy_plane.z_downlim;
					part0.z_uplim = xy_plane.z_uplim;
					part0.y_downlim = xy_plane_node_list->y;
					part0.y_uplim = xy_plane_node_list->y;
					part0.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
					part0.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
					part0_srcx = part0.x_downlim;
					part0_srcz = xy_plane.z_downlim;
					part0_srcy = part0.y_downlim;
				}
				else{
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 1){
						//this is region1, now use part1 to cover it(part1 is also ok, but we use part0 here
						part_valid[1] = 1;
						part1.z_downlim = xy_plane.z_downlim;
						part1.z_uplim = xy_plane.z_uplim;
						part1.y_downlim = xy_plane_node_list->y;
						part1.y_uplim = xy_plane_node_list->y;
						part1.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
						part1.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
						part1_srcx = part1.x_downlim;
						part1_srcz = xy_plane.z_downlim;
						part1_srcy = part1.y_downlim;
					}
					else if (part_idx == 2){
						part_valid[2] = 1;
						part2.z_downlim = xy_plane.z_downlim;
						part2.z_uplim = xy_plane.z_uplim;
						part2.y_downlim = xy_plane_node_list->y;
						part2.y_uplim = xy_plane_node_list->y;
						part2.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
						part2.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
						part2_srcx = part2.x_downlim;
						part2_srcz = xy_plane.z_downlim;
						part2_srcy = part2.y_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}

		//now distribute the xy_plane_node_list into parts (up to 4)
		struct src_dst_list* xy_plane_node_ptr = xy_plane_node_list->next;
		struct src_dst_list* part0_list = NULL;
		struct src_dst_list* part1_list = NULL;
		struct src_dst_list* part2_list = NULL;
		struct src_dst_list* part3_list = NULL;

		if (part_valid[0]){
			if (!(part0_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part0_list->valid = true;
			part0_list->src_or_dst = true;
			part0_list->next = NULL;
			part0_list->x = part0_srcx;
			part0_list->y = part0_srcy;
			part0_list->z = part0_srcz;
		}
		if (part_valid[1]){
			if (!(part1_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part1_list->valid = true;
			part1_list->src_or_dst = true;
			part1_list->next = NULL;
			part1_list->x = part1_srcx;
			part1_list->y = part1_srcy;
			part1_list->z = part1_srcz;
		}
		if (part_valid[2]){
			if (!(part2_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part2_list->valid = true;
			part2_list->src_or_dst = true;
			part2_list->next = NULL;
			part2_list->x = part2_srcx;
			part2_list->y = part2_srcy;
			part2_list->z = part2_srcz;
		}
		if (part_valid[3]){
			if (!(part3_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part3_list->valid = true;
			part3_list->src_or_dst = true;
			part3_list->next = NULL;
			part3_list->x = part3_srcx;
			part3_list->y = part3_srcy;
			part3_list->z = part3_srcz;
		}

		struct src_dst_list* new_node;

		while (xy_plane_node_ptr){
			if (part_valid[0] && within_range(part0, xy_plane_node_ptr)){
				//insert a node into the part0 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xy_plane_node_ptr->x;
				new_node->y = xy_plane_node_ptr->y;
				new_node->z = xy_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part0_list->next;
				part0_list->next = new_node;

			}
			else if (part_valid[1] && within_range(part1, xy_plane_node_ptr)){

				//insert a node into the part1 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xy_plane_node_ptr->x;
				new_node->y = xy_plane_node_ptr->y;
				new_node->z = xy_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part1_list->next;
				part1_list->next = new_node;


			}
			else if (part_valid[2] && within_range(part2, xy_plane_node_ptr)){

				//insert a node into the part2 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xy_plane_node_ptr->x;
				new_node->y = xy_plane_node_ptr->y;
				new_node->z = xy_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part2_list->next;
				part2_list->next = new_node;


			}
			else if (part_valid[3] && within_range(part3, xy_plane_node_ptr)){

				//insert a node into the part3 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xy_plane_node_ptr->x;
				new_node->y = xy_plane_node_ptr->y;
				new_node->z = xy_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part3_list->next;
				part3_list->next = new_node;


			}

			xy_plane_node_ptr = xy_plane_node_ptr->next;
		}

		int new_weight = (tree_src->weight == 1) ? 1 : tree_src->weight / 2;

		node* part0_src;
		node* part1_src;
		node* part2_src;
		node* part3_src;

		if (part_valid[0]){
			tree_src->children[tree_src->num_children] = new node(part0_list->x, part0_list->y, part0_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part0_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[1]){
			tree_src->children[tree_src->num_children] = new node(part1_list->x, part1_list->y, part1_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part1_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[2]){
			tree_src->children[tree_src->num_children] = new node(part2_list->x, part2_list->y, part2_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part2_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[3]){
			tree_src->children[tree_src->num_children] = new node(part3_list->x, part3_list->y, part3_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part3_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		//print the current the src and dst nodes on the current node
		fout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
			accumulate_link(tree_src,tree_src->children[children_idx]);
		}
		fout << "}" << endl;

		cout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
	//		accumulate_link(tree_src, tree_src->children[children_idx]);
		}
		cout << "}" << endl;

		//accumulate the link counter
		//free the four part_list
		struct src_dst_list* free_ptr;

		struct src_dst_list* next_free_ptr;

		
		if (part_valid[0]){
			RPM_partition_2D(part0_list, part0, part0_src,2);
		}
		free_ptr = part0_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		if (part_valid[1]){
			RPM_partition_2D(part1_list, part1, part1_src,2);
		}
		free_ptr = part1_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		if (part_valid[2]){
			RPM_partition_2D(part2_list, part2, part2_src,2);
		}
		free_ptr = part2_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		if (part_valid[3]){
			RPM_partition_2D(part3_list, part3, part3_src,2);
		}




	
		free_ptr = part3_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
	}
	
	
	


}
void RPM_partition(struct src_dst_list* node_list, struct chunk Chunk, node* tree_src){
	if (node_list->next == NULL){
		//the node list only contains leave nodes
		return void();
	}
	if (Chunk.get_x_size() == 1){
		RPM_partition_2D(node_list, Chunk, tree_src, 0);
		return void();

	}
	else if (Chunk.get_y_size() == 1){
		RPM_partition_2D(node_list, Chunk, tree_src, 1);
		return void();
	}
	else if (Chunk.get_z_size() == 1){
		RPM_partition_2D(node_list, Chunk, tree_src, 2);
		return void();
	}
	int partition_eval = evaluate_partition(node_list, Chunk);
	if (partition_eval == 0){
		//partition along yz plane
		struct src_dst_list* x_up_node_list=NULL;
		struct src_dst_list* x_down_node_list=NULL;
		struct src_dst_list* yz_plane_node_list;
		//init the three link lists


		if (!(yz_plane_node_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
			cout << "no mem" << endl;
			exit(-1);
		}
		yz_plane_node_list->next = NULL;
		yz_plane_node_list->x = node_list->x;
		yz_plane_node_list->y = node_list->y;
		yz_plane_node_list->z = node_list->z;
		yz_plane_node_list->valid = true;
		yz_plane_node_list->src_or_dst = true;
		if (Chunk.x_wrap() || ((!Chunk.x_wrap()) && node_list->x != Chunk.x_downlim)){
			if (!(x_down_node_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			x_down_node_list->x = node_list->x != 0 ? (node_list->x - 1) : X - 1;
			x_down_node_list->y = node_list->y;
			x_down_node_list->z = node_list->z;
			x_down_node_list->next = NULL;
			x_down_node_list->valid = true;
			x_down_node_list->src_or_dst = true;
		}
		if (Chunk.x_wrap() || ((!Chunk.x_wrap()) && node_list->x != Chunk.x_uplim)){
			if (!(x_up_node_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			x_up_node_list->x = node_list->x != X-1 ? (node_list->x + 1) : 0;
			x_up_node_list->y = node_list->y;
			x_up_node_list->z = node_list->z;
			x_up_node_list->next = NULL;
			x_up_node_list->valid = true;
			x_up_node_list->src_or_dst = true;
		}

		//now distribute the nodes in node_list into three parts
		struct src_dst_list* node_ptr;
		struct src_dst_list* next_node;
		node_ptr = node_list->next;
		while (node_ptr){
			next_node = node_ptr->next;
			if (node_ptr->x == yz_plane_node_list->x){
				//insert this node into yz_plane_node_list
				node_ptr->next = yz_plane_node_list->next;
				yz_plane_node_list->next = node_ptr;
				
			}
			else if (Chunk.x_wrap()){
				if (node_ptr->x > yz_plane_node_list->x){
					if (node_ptr->x - yz_plane_node_list->x <= X / 2){
						//insert this node into the x_up_node_list
						if (x_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = x_up_node_list->next; 
							x_up_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node int othe x_down_node_list
						if (x_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = x_down_node_list->next;
							x_down_node_list->next = node_ptr;
						}
					}

				}
				else{
					if (yz_plane_node_list->x - node_ptr->x <= X / 2){
						//insert this node into the x_down_node_list
						if (x_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = x_down_node_list->next;
							x_down_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node into the x_up_node_list
						if (x_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = x_up_node_list->next;
							x_up_node_list->next = node_ptr;
						}
					}
				}

			}
			else{//x is not wrap up
				if (Chunk.x_downlim < Chunk.x_uplim){
					if (node_ptr->x>yz_plane_node_list->x){
						//insert this node into the x_up_node_list
						if (x_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = x_up_node_list->next;
							x_up_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node into the x_down_node_list
						if (x_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = x_down_node_list->next;
							x_down_node_list->next = node_ptr;
						}
					}
				}
				else if (Chunk.x_downlim > Chunk.x_uplim){
					int x_distance_between_node_ptr_downlim = (node_ptr->x >= Chunk.x_downlim) ? (node_ptr->x - Chunk.x_downlim) : (node_ptr->x - Chunk.x_downlim+X);
					int x_distance_between_src_downlim = (yz_plane_node_list->x >= Chunk.x_downlim) ? (yz_plane_node_list->x - Chunk.x_downlim) : (yz_plane_node_list->x - Chunk.x_downlim+X);
					if (x_distance_between_src_downlim < x_distance_between_node_ptr_downlim){
						//insert this node into the x_up_node_list
						if (x_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = x_up_node_list->next;
							x_up_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node into the x_down_node_list
						if (x_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = x_down_node_list->next;
							x_down_node_list->next = node_ptr;
						}
					}
				
				}
				
			}
			node_ptr = next_node;		
		}
		//now the nodes are all in the three link lists
		//generate the xpos chunk and xneg chunk
		struct chunk xpos_chunk;
		struct chunk xneg_chunk;
		struct chunk yz_plane;
		if (x_up_node_list){
			xpos_chunk.x_downlim = x_up_node_list->x;
			if (Chunk.x_wrap()){
				xpos_chunk.x_uplim = yz_plane_node_list->x + X / 2 >= X ? yz_plane_node_list->x + X / 2 - X : yz_plane_node_list->x + X / 2;
			}
			else{
				xpos_chunk.x_uplim = Chunk.x_uplim;
			}
			xpos_chunk.y_downlim = Chunk.y_downlim;
			xpos_chunk.y_uplim = Chunk.y_uplim;
			xpos_chunk.z_downlim = Chunk.z_downlim;
			xpos_chunk.z_uplim = Chunk.z_uplim;
			
		}
		if (x_down_node_list){
			xneg_chunk.x_uplim = x_down_node_list->x;
			if (Chunk.x_wrap()){
				xneg_chunk.x_downlim = yz_plane_node_list->x - X / 2 + 1<0 ? yz_plane_node_list->x - X / 2 + 1 + X : yz_plane_node_list->x - X / 2 + 1;
			}
			else{
				xneg_chunk.x_downlim = Chunk.x_downlim;
			}
			xneg_chunk.y_downlim = Chunk.y_downlim;
			xneg_chunk.y_uplim = Chunk.y_uplim;
			xneg_chunk.z_downlim = Chunk.z_downlim;
			xneg_chunk.z_uplim = Chunk.z_uplim;
		}
		yz_plane.x_downlim = yz_plane_node_list->x;
		yz_plane.x_uplim = yz_plane_node_list->x;
		yz_plane.y_downlim = Chunk.y_downlim;
		yz_plane.y_uplim = Chunk.y_uplim;
		yz_plane.z_downlim = Chunk.z_downlim;
		yz_plane.z_uplim = Chunk.z_uplim;
		//now partition the yz plane
		//first evalute this plane
		struct plane_evaluation yz_eval;
		yz_eval = evaluate_plane(yz_plane_node_list,yz_plane,0);
		//go around the four possible merged regions
		//at most partition the plane into four parts
		struct chunk part0;
		struct chunk part1;
		struct chunk part2;
		struct chunk part3;
		int part0_srcx, part0_srcy, part0_srcz;
		int part1_srcx, part1_srcy, part1_srcz;
		int part2_srcx, part2_srcy, part2_srcz;
		int part3_srcx, part3_srcy, part3_srcz;
		int part_valid[4] = { 0, 0, 0, 0 };
		if (yz_eval.region0_merge == 0){
			//region 0 is merged with region1
			part_valid[0] = 1;
			part0.x_uplim = yz_plane_node_list->x;
			part0.x_downlim = yz_plane_node_list->x;
			part0.y_downlim = yz_plane_node_list->y;
			part0.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
			part0.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)+ Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
			part0.z_uplim = yz_plane_node_list->z - 1 <0 ? Z - 1 : yz_plane_node_list->z - 1;

			part0_srcx = part0.x_downlim; 
			part0_srcy = part0.y_downlim;
			part0_srcz = part0.z_uplim;
		}
		
		else if (yz_eval.region0_merge == 1){
			//region0 is merged with regino7
			part_valid[0] = 1;
			part0.x_uplim = yz_plane_node_list->x;
			part0.x_downlim = yz_plane_node_list->x;
			part0.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
			part0.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
			part0.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
			part0.z_uplim = yz_plane_node_list->z;

			part0_srcx = part0.x_downlim;
			part0_srcy = part0.y_downlim;
			part0_srcz = part0.z_uplim;
		}
		else if (yz_eval.region0_merge == 2){ // the region 0 is not used
			part_valid[0] = 0;
		}

		if (yz_eval.region2_merge == 0){
			//region 2 is merged with region 3
			part_valid[1] = 1;
			part1.x_uplim = yz_plane_node_list->x;
			part1.x_downlim = yz_plane_node_list->x;
			part1.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
			part1.y_uplim = yz_plane_node_list->y - 1<0 ? Y - 1 : yz_plane_node_list->y - 1;
			part1.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
			part1.z_uplim = yz_plane_node_list->z;

			part1_srcx = part1.x_downlim;
			part1_srcy = part1.y_uplim;
			part1_srcz = part1.z_uplim;

		}
		else if (yz_eval.region2_merge == 1){
			if (part_valid[0]==1 && yz_eval.region0_merge == 0){
				//region0 and region2 should be merged together
				part_valid[1] = 0;
				part0.y_downlim = yz_plane.y_downlim;
				part0.y_uplim = yz_plane.y_uplim;
				part0.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
				part0.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
				part0_srcx = part0.x_downlim;
				part0_srcy = yz_plane_node_list->y;
				part0_srcz = part0.z_uplim;

			}
			//region2 is merged with region1
			else{
				part_valid[1] = 1;
				part1.x_uplim = yz_plane_node_list->x;
				part1.x_downlim = yz_plane_node_list->x;
				part1.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
				part1.y_uplim = yz_plane_node_list->y;
				part1.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
				part1.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
				part1_srcx = part1.x_downlim;
				part1_srcy = part1.y_uplim;
				part1_srcz = part1.z_uplim;
			}

		}
		else if (yz_eval.region2_merge == 2){ // the region 2 is not used
			part_valid[1] = 0;

		}

		if (yz_eval.region4_merge == 0){
			//region 4 is merged with region 5
			part_valid[2] = 1;
			part2.x_uplim = yz_plane_node_list->x;
			part2.x_downlim = yz_plane_node_list->x;
			part2.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
			part2.y_uplim = yz_plane_node_list->y;
			part2.z_downlim = yz_plane_node_list->z+1>=Z?0: yz_plane_node_list->z+1;
			part2.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
			part2_srcx = part2.x_downlim;
			part2_srcy = part2.y_uplim;
			part2_srcz = part2.z_downlim;

		}
		else if (yz_eval.region4_merge == 1){
			if (part_valid[1]==1 && yz_eval.region2_merge == 0){
				//region2 and region4 should be merged together
				part_valid[2] = 0;
				part1.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
				part1.y_uplim = yz_plane_node_list->y- 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
				part1.z_downlim = yz_plane.z_downlim;
				part1.z_uplim =  yz_plane.z_uplim;
				part1_srcx = part1.x_downlim;
				part1_srcy = part1.y_uplim;
				part1_srcz = yz_plane_node_list->z;

			}
			//region4 is merged with region3
			else{
				part_valid[2] = 1;
				part2.x_uplim = yz_plane_node_list->x;
				part2.x_downlim = yz_plane_node_list->x;
				part2.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
				part2.y_uplim = yz_plane_node_list->y- 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
				part2.z_downlim = yz_plane_node_list->z;
				part2.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;

				part2_srcx = part2.x_downlim;
				part2_srcy = part2.y_uplim;
				part2_srcz = part2.z_downlim;
			}

		}
		else if (yz_eval.region4_merge == 2){ // the region 4 is not used
			part_valid[2] = 0;

		}

		if (yz_eval.region6_merge == 0){
			if(part_valid[0]==1 && yz_eval.region0_merge == 1){
				//region0 and region6 should be merged together
				part_valid[3] = 0;
				part0.x_uplim = yz_plane_node_list->x;
				part0.x_downlim = yz_plane_node_list->x;
				part0.y_downlim= yz_plane_node_list->y+1>=Y?0:yz_plane_node_list->y+1;
				part0.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
				part0.z_downlim =yz_plane.z_downlim;
				part0.z_uplim = yz_plane.z_uplim;

				part0_srcx = part0.x_downlim;
				part0_srcy = part0.y_downlim;
				part0_srcz = yz_plane_node_list->z;

				
			}
			//region 6 is merged with region 7
			else{
				part_valid[3] = 1;
				part3.x_uplim = yz_plane_node_list->x;
				part3.x_downlim = yz_plane_node_list->x;
				part3.y_downlim = yz_plane_node_list->y+1>=Y?0:yz_plane_node_list->y+1;
				part3.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
				part3.z_downlim = yz_plane_node_list->z;
				part3.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcy = part3.y_downlim;
				part3_srcz = part3.z_downlim;
			}

		}
		else if (yz_eval.region6_merge == 1){
			if (part_valid[2]==1 && yz_eval.region4_merge == 1){
				//region4 and region6 should be merged together
				part_valid[3] = 0;
				part2.y_downlim = yz_plane.y_downlim;
				part2.y_uplim = yz_plane.y_uplim;
				part2.z_downlim = yz_plane_node_list->z+1>=Z?0: yz_plane_node_list->z+1;
				part2.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
				part2_srcx = part2.x_downlim;
				part2_srcy = yz_plane_node_list->y;
				part2_srcz = part2.z_downlim;

			}
			//region6 is merged with region5
			else{
				part_valid[3] = 1;
				part3.x_uplim = yz_plane_node_list->x;
				part3.x_downlim = yz_plane_node_list->x;
				part3.y_downlim = yz_plane_node_list->y;
				part3.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
				part3.z_downlim = yz_plane_node_list->z+1>=Z?0: yz_plane_node_list->z+1;
				part3.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcy = part3.y_downlim;
				part3_srcz = part3.z_downlim;
			}

		}
		else if (yz_eval.region6_merge == 2){ // the region 6 is not used
			part_valid[3] = 0;

		}

		if (yz_eval.region0_merge != 0 && yz_eval.region2_merge != 1){
			if (yz_eval.zneg_enable){
				if (yz_eval.region0_merge != 1){
					//this is region1, now use part0 to cover it(part1 is also ok, but we use part0 here
					part_valid[0] = 1;
					part0.x_downlim = yz_plane.x_downlim;
					part0.x_uplim = yz_plane.x_uplim;
					part0.y_downlim = yz_plane_node_list->y;
					part0.y_uplim = yz_plane_node_list->y;
					part0.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
					part0.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
					part0_srcy = yz_plane_node_list->y;
					part0_srcx = yz_plane.x_downlim;
					part0_srcz = part0.z_uplim;
				}
				else if (yz_eval.region2_merge != 0){
					part_valid[1] = 1;
					part1.x_downlim = yz_plane.x_downlim;
					part1.x_uplim = yz_plane.x_uplim;
					part1.y_downlim = yz_plane_node_list->y;
					part1.y_uplim = yz_plane_node_list->y;
					part1.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
					part1.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
					part1_srcy = yz_plane_node_list->y;
					part1_srcx = yz_plane.x_downlim;
					part1_srcz = part1.z_uplim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 2){
						part_valid[2] = 1;
						part2.x_downlim = yz_plane.x_downlim;
						part2.x_uplim = yz_plane.x_uplim;
						part2.y_downlim = yz_plane_node_list->y;
						part2.y_uplim = yz_plane_node_list->y;
						part2.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
						part2.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
						part2_srcy = yz_plane_node_list->y;
						part2_srcx = yz_plane.x_downlim;
						part2_srcz = part2.z_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.x_downlim = yz_plane.x_downlim;
						part3.x_uplim = yz_plane.x_uplim;
						part3.y_downlim = yz_plane_node_list->y;
						part3.y_uplim = yz_plane_node_list->y;
						part3.z_downlim = yz_plane.z_wrap() ? (yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? yz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : yz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : yz_plane.z_downlim;
						part3.z_uplim = yz_plane_node_list->z - 1 < 0 ? Z - 1 : yz_plane_node_list->z - 1;
						part3_srcy = yz_plane_node_list->y;
						part3_srcx = yz_plane.x_downlim;
						part3_srcz = part3.z_uplim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (yz_eval.region2_merge != 0 && yz_eval.region4_merge != 1){
			if (yz_eval.yneg_enable){
				if (yz_eval.region2_merge != 1){
					part_valid[1] = 1;
					part1.x_downlim = yz_plane.x_downlim;
					part1.x_uplim = yz_plane.x_uplim;
					part1.z_downlim = yz_plane_node_list->z;
					part1.z_uplim = yz_plane_node_list->z;
					part1.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
					part1.y_uplim = yz_plane_node_list->y - 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
					part1_srcy = part1.y_uplim;
					part1_srcx = yz_plane.x_downlim;
					part1_srcz = part1.z_uplim;
				}
				else if (yz_eval.region4_merge != 0){
					part_valid[2] = 1;
					part2.x_downlim = yz_plane.x_downlim;
					part2.x_uplim = yz_plane.x_uplim;
					part2.z_downlim = yz_plane_node_list->z;
					part2.z_uplim = yz_plane_node_list->z;
					part2.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
					part2.y_uplim = yz_plane_node_list->y - 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
					part2_srcy = part2.y_uplim;
					part2_srcx = yz_plane.x_downlim;
					part2_srcz = part2.z_uplim;

				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						part_valid[0] = 1;
						part0.x_downlim = yz_plane.x_downlim;
						part0.x_uplim = yz_plane.x_uplim;
						part0.z_downlim = yz_plane_node_list->z;
						part0.z_uplim = yz_plane_node_list->z;
						part0.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
						part0.y_uplim = yz_plane_node_list->y - 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
						part0_srcy = part0.y_uplim;
						part0_srcx = yz_plane.x_downlim;
						part0_srcz = part0.z_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.x_downlim = yz_plane.x_downlim;
						part3.x_uplim = yz_plane.x_uplim;
						part3.z_downlim = yz_plane_node_list->z;
						part3.z_uplim = yz_plane_node_list->z;
						part3.y_downlim = yz_plane.y_wrap() ? (yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? yz_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : yz_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : yz_plane.y_downlim;
						part3.y_uplim = yz_plane_node_list->y - 1 < 0 ? Y - 1 : yz_plane_node_list->y - 1;
						part3_srcy = part3.y_uplim;
						part3_srcx = yz_plane.x_downlim;
						part3_srcz = part3.z_uplim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (yz_eval.region4_merge != 0 && yz_eval.region6_merge != 1){
			if (yz_eval.zpos_enable){
				if (yz_eval.region4_merge != 1){
					part_valid[2] = 1;
					part2.x_downlim = yz_plane.x_downlim;
					part2.x_uplim = yz_plane.x_uplim;
					part2.y_downlim = yz_plane_node_list->y;
					part2.y_uplim = yz_plane_node_list->y;
					part2.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
					part2.z_downlim = yz_plane_node_list->z + 1 >= Z ? 0 : yz_plane_node_list->z + 1;
					part2_srcy = part2.y_uplim;
					part2_srcx = yz_plane.x_downlim;
					part2_srcz = part2.z_downlim;
				}
				else if (yz_eval.region6_merge != 0){
					part_valid[3] = 1;
					part3.x_downlim = yz_plane.x_downlim;
					part3.x_uplim = yz_plane.x_uplim;
					part3.y_downlim = yz_plane_node_list->y;
					part3.y_uplim = yz_plane_node_list->y;
					part3.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
					part3.z_downlim = yz_plane_node_list->z + 1 >= Z ? 0 : yz_plane_node_list->z + 1;
					part3_srcy = part3.y_uplim;
					part3_srcx = yz_plane.x_downlim;
					part3_srcz = part3.z_downlim;

				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						part_valid[0] = 1;
						part0.x_downlim = yz_plane.x_downlim;
						part0.x_uplim = yz_plane.x_uplim;
						part0.y_downlim = yz_plane_node_list->y;
						part0.y_uplim = yz_plane_node_list->y;
						part0.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
						part0.z_downlim = yz_plane_node_list->z + 1 >= Z ? 0 : yz_plane_node_list->z + 1;
						part0_srcy = part3.y_uplim;
						part0_srcx = yz_plane.x_downlim;
						part0_srcz = part3.z_downlim;
					}
					else if (part_idx == 1){
						part_valid[1] = 1;
						part1.x_downlim = yz_plane.x_downlim;
						part1.x_uplim = yz_plane.x_uplim;
						part1.y_downlim = yz_plane_node_list->y;
						part1.y_uplim = yz_plane_node_list->y;
						part1.z_uplim = yz_plane.z_wrap() ? (yz_plane_node_list->z + Z / 2 >= Z ? yz_plane_node_list->z + Z / 2 - Z : yz_plane_node_list->z + Z / 2) : yz_plane.z_uplim;
						part1.z_downlim = yz_plane_node_list->z + 1 >= Z ? 0 : yz_plane_node_list->z + 1;
						part1_srcy = part1.y_uplim;
						part1_srcx = yz_plane.x_downlim;
						part1_srcz = part1.z_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (yz_eval.region6_merge != 0 && yz_eval.region0_merge != 1){
			if (yz_eval.ypos_enable){
				if (yz_eval.region6_merge != 1){
					part_valid[3] = 1;
					part3.x_downlim = yz_plane.x_downlim;
					part3.x_uplim = yz_plane.x_uplim;
					part3.z_downlim = yz_plane_node_list->z;
					part3.z_uplim = yz_plane_node_list->z;
					part3.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
					part3.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
					part3_srcy = part3.y_downlim;
					part3_srcx = yz_plane.x_downlim;
					part3_srcz = part3.z_downlim;
				}
				else if (yz_eval.region0_merge != 0){
					part_valid[0] = 1;
					part0.x_downlim = yz_plane.x_downlim;
					part0.x_uplim = yz_plane.x_uplim;
					part0.z_downlim = yz_plane_node_list->z;
					part0.z_uplim = yz_plane_node_list->z;
					part0.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
					part0.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
					part0_srcy = part0.y_downlim;
					part0_srcx = yz_plane.x_downlim;
					part0_srcz = part0.z_downlim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 1){
						part_valid[1] = 1;
						part1.x_downlim = yz_plane.x_downlim;
						part1.x_uplim = yz_plane.x_uplim;
						part1.z_downlim = yz_plane_node_list->z;
						part1.z_uplim = yz_plane_node_list->z;
						part1.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
						part1.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
						part1_srcy = part1.y_downlim;
						part1_srcx = yz_plane.x_downlim;
						part1_srcz = part1.z_downlim;
					}
					else if (part_idx == 2){
						part_valid[2] = 1;
						part2.x_downlim = yz_plane.x_downlim;
						part2.x_uplim = yz_plane.x_uplim;
						part2.z_downlim = yz_plane_node_list->z;
						part2.z_uplim = yz_plane_node_list->z;
						part2.y_uplim = yz_plane.y_wrap() ? (yz_plane_node_list->y + Y / 2 >= Y ? yz_plane_node_list->y + Y / 2 - Y : yz_plane_node_list->y + Y / 2) : yz_plane.y_uplim;
						part2.y_downlim = yz_plane_node_list->y + 1 >= Y ? 0 : yz_plane_node_list->y + 1;
						part2_srcy = part2.y_downlim;
						part2_srcx = yz_plane.x_downlim;
						part2_srcz = part2.z_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}

		//now distribute the yz_plane_node_list into parts (up to 4)
		struct src_dst_list* yz_plane_node_ptr=yz_plane_node_list->next;
		struct src_dst_list* part0_list=NULL;
		struct src_dst_list* part1_list=NULL;
		struct src_dst_list* part2_list=NULL;
		struct src_dst_list* part3_list=NULL;

		if(part_valid[0]){
			if(!(part0_list=(struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout<<"no mem"<<endl;
				exit(-1);
			}
			part0_list->valid=true;
			part0_list->src_or_dst=true;
			part0_list->next=NULL;
			part0_list->x=part0_srcx;
			part0_list->y=part0_srcy;
			part0_list->z=part0_srcz;
		}
		if(part_valid[1]){
			if(!(part1_list=(struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout<<"no mem"<<endl;
				exit(-1);
			}
			part1_list->valid=true;
			part1_list->src_or_dst=true;
			part1_list->next=NULL;
			part1_list->x=part1_srcx;
			part1_list->y=part1_srcy;
			part1_list->z=part1_srcz;
		}
		if(part_valid[2]){
			if(!(part2_list=(struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout<<"no mem"<<endl;
				exit(-1);
			}
			part2_list->valid=true;
			part2_list->src_or_dst=true;
			part2_list->next=NULL;
			part2_list->x=part2_srcx;
			part2_list->y=part2_srcy;
			part2_list->z=part2_srcz;
		}
		if(part_valid[3]){
			if(!(part3_list=(struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout<<"no mem"<<endl;
				exit(-1);
			}
			part3_list->valid=true;
			part3_list->src_or_dst=true;
			part3_list->next=NULL;
			part3_list->x=part3_srcx;
			part3_list->y=part3_srcy;
			part3_list->z=part3_srcz;
		}

		struct src_dst_list* new_node;

		while (yz_plane_node_ptr){
			if (part_valid[0] && within_range(part0, yz_plane_node_ptr)){
				//insert a node into the part0 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = yz_plane_node_ptr->x;
				new_node->y = yz_plane_node_ptr->y;
				new_node->z = yz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part0_list->next;
				part0_list->next = new_node;	

			}
			else if (part_valid[1] && within_range(part1, yz_plane_node_ptr)){
				
				//insert a node into the part1 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = yz_plane_node_ptr->x;
				new_node->y = yz_plane_node_ptr->y;
				new_node->z = yz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part1_list->next;
				part1_list->next = new_node;
				

			}
			else if (part_valid[2] && within_range(part2, yz_plane_node_ptr)){
				
				//insert a node into the part2 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = yz_plane_node_ptr->x;
				new_node->y = yz_plane_node_ptr->y;
				new_node->z = yz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part2_list->next;
				part2_list->next = new_node;
				

			}
			else if (part_valid[3] && within_range(part3, yz_plane_node_ptr)){
				
					//insert a node into the part3 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = yz_plane_node_ptr->x;
				new_node->y = yz_plane_node_ptr->y;
				new_node->z = yz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part3_list->next;
				part3_list->next = new_node;
				

			}

			yz_plane_node_ptr = yz_plane_node_ptr->next;
		}
		
		int new_weight = (tree_src->weight == 1) ? 1 : tree_src->weight / 2;
		node* x_pos_src;
		node* x_neg_src;
		node* part0_src;
		node* part1_src;
		node* part2_src;
		node* part3_src;
		if (x_up_node_list){
			tree_src->children[tree_src->num_children] = new node(x_up_node_list->x, x_up_node_list->y, x_up_node_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			x_pos_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (x_down_node_list){
			tree_src->children[tree_src->num_children] = new node(x_down_node_list->x, x_down_node_list->y, x_down_node_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			x_neg_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[0]){
			tree_src->children[tree_src->num_children] = new node(part0_list->x,part0_list->y,part0_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part0_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[1]){
			tree_src->children[tree_src->num_children] = new node(part1_list->x, part1_list->y, part1_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part1_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[2]){
			tree_src->children[tree_src->num_children] = new node(part2_list->x, part2_list->y, part2_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part2_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[3]){
			tree_src->children[tree_src->num_children] = new node(part3_list->x, part3_list->y, part3_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part3_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		//print the current the src and dst nodes on the current node
		fout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
			accumulate_link(tree_src,tree_src->children[children_idx]);
		}
		fout << "}" << endl;

		cout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
		//	accumulate_link(tree_src, tree_src->children[children_idx]);
		}
		cout << "}" << endl;

		struct src_dst_list* free_ptr;

		struct src_dst_list* next_free_ptr;

		if (x_up_node_list){
			RPM_partition(x_up_node_list, xpos_chunk, x_pos_src);
		}
		if (x_down_node_list){
			RPM_partition(x_down_node_list, xneg_chunk, x_neg_src);
		}
		if (part_valid[0]){
			RPM_partition_2D(part0_list, part0, part0_src,0);
		}
		free_ptr = part0_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}

		if (part_valid[1]){
			RPM_partition_2D(part1_list, part1, part1_src,0);
		}
		free_ptr = part1_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}

		if (part_valid[2]){
			RPM_partition_2D(part2_list, part2, part2_src,0);
		}

		free_ptr = part2_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}

		if (part_valid[3]){
			RPM_partition_2D(part3_list, part3, part3_src,0);
		}


		//free the four part_list

		free_ptr = part3_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		

	}
	else if (partition_eval == 1){
		//partition_along y direction
		//partition along xz plane
		struct src_dst_list* y_up_node_list = NULL;
		struct src_dst_list* y_down_node_list = NULL;
		struct src_dst_list* xz_plane_node_list;
		//init the three link lists
		if (!(y_up_node_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
			cout << "no mem" << endl;
			exit(-1);
		}

		if (!(xz_plane_node_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
			cout << "no mem" << endl;
			exit(-1);
		}
		xz_plane_node_list->next = NULL;
		xz_plane_node_list->x = node_list->x;
		xz_plane_node_list->y = node_list->y;
		xz_plane_node_list->z = node_list->z;
		xz_plane_node_list->valid = true;
		xz_plane_node_list->src_or_dst = true;
		if (Chunk.y_wrap() || ((!Chunk.y_wrap()) && node_list->y != Chunk.y_downlim)){
			if (!(y_down_node_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			y_down_node_list->x = node_list->x;
			y_down_node_list->y = node_list->y != 0 ? (node_list->y - 1) : Y - 1;
			y_down_node_list->z = node_list->z;
			y_down_node_list->next = NULL;
			y_down_node_list->valid = true;
			y_down_node_list->src_or_dst = true;
		}
		if (Chunk.y_wrap() || ((!Chunk.y_wrap()) && node_list->y != Chunk.y_uplim)){
			if (!(y_up_node_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			y_up_node_list->x = node_list->x;
			y_up_node_list->y = node_list->y != Y - 1 ? (node_list->y + 1) : 0;
			y_up_node_list->z = node_list->z;
			y_up_node_list->next = NULL;
			y_up_node_list->valid = true;
			y_up_node_list->src_or_dst = true;
		}

		//now distribute the nodes in node_list into three parts
		struct src_dst_list* node_ptr;
		struct src_dst_list* next_node;
		node_ptr = node_list->next;
		while (node_ptr){
			next_node = node_ptr->next;
			if (node_ptr->y == xz_plane_node_list->y){
				//insert this node into xz_plane_node_list
				node_ptr->next = xz_plane_node_list->next;
				xz_plane_node_list->next = node_ptr;

			}
			else if (Chunk.y_wrap()){
				if (node_ptr->y > xz_plane_node_list->y){
					if (node_ptr->y - xz_plane_node_list->y <= Y / 2){
						//insert this node into the x_up_node_list
						if (y_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = y_up_node_list->next;
							y_up_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node int othe x_down_node_list
						if (y_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = y_down_node_list->next;
							y_down_node_list->next = node_ptr;
						}
					}

				}
				else{
					if (xz_plane_node_list->y - node_ptr->y <= Y / 2){
						//insert this node into the x_down_node_list
						if (y_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = y_down_node_list->next;
							y_down_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node into the x_up_node_list
						if (y_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = y_up_node_list->next;
							y_up_node_list->next = node_ptr;
						}
					}
				}

			}
			else{//y is not wrap up
				if (Chunk.y_downlim < Chunk.y_uplim){
					if (node_ptr->y>xz_plane_node_list->y){
						//insert this node into the y_up_node_list
						if (y_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = y_up_node_list->next;
							y_up_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node into the y_down_node_list
						if (y_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = y_down_node_list->next;
							y_down_node_list->next = node_ptr;
						}
					}
				}
				else if (Chunk.y_downlim > Chunk.y_uplim){
					int y_distance_between_node_ptr_downlim = (node_ptr->y >= Chunk.y_downlim) ? (node_ptr->y - Chunk.y_downlim) : (node_ptr->y - Chunk.y_downlim + Y);
					int y_distance_between_src_downlim = (xz_plane_node_list->y >= Chunk.y_downlim) ? (xz_plane_node_list->y - Chunk.y_downlim) : (xz_plane_node_list->y - Chunk.y_downlim + Y);
					if (y_distance_between_src_downlim < y_distance_between_node_ptr_downlim){
						//insert this node into the y_up_node_list
						if (y_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = y_up_node_list->next;
							y_up_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node into the x_down_node_list
						if (y_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = y_down_node_list->next;
							y_down_node_list->next = node_ptr;
						}
					}

				}

			}
			node_ptr = next_node;
		}
		//now the nodes are all in the three link lists
		//generate the ypos chunk and yneg chunk
		struct chunk ypos_chunk;
		struct chunk yneg_chunk;
		struct chunk xz_plane;
		if (y_up_node_list){
			ypos_chunk.y_downlim = y_up_node_list->y;
			if (Chunk.y_wrap()){
				ypos_chunk.y_uplim = xz_plane_node_list->y + Y / 2 >= Y ? xz_plane_node_list->y + Y / 2 - Y : xz_plane_node_list->y + Y / 2;
			}
			else
				ypos_chunk.y_uplim = Chunk.y_uplim;
			ypos_chunk.x_downlim = Chunk.x_downlim;
			ypos_chunk.x_uplim = Chunk.x_uplim;
			ypos_chunk.z_downlim = Chunk.z_downlim;
			ypos_chunk.z_uplim = Chunk.z_uplim;

		}
		if (y_down_node_list){
			yneg_chunk.y_uplim = y_down_node_list->y;
			if (Chunk.y_wrap()){
				yneg_chunk.y_downlim = xz_plane_node_list->y - Y / 2 + 1<0 ? xz_plane_node_list->y - Y / 2 + 1 + Y : xz_plane_node_list->y - Y / 2 + 1;
			}
			else
				yneg_chunk.y_downlim = Chunk.y_downlim;
			yneg_chunk.x_downlim = Chunk.x_downlim;
			yneg_chunk.x_uplim = Chunk.x_uplim;
			yneg_chunk.z_downlim = Chunk.z_downlim;
			yneg_chunk.z_uplim = Chunk.z_uplim;
		}
		xz_plane.y_downlim = xz_plane_node_list->y;
		xz_plane.y_uplim = xz_plane_node_list->y;
		xz_plane.x_downlim = Chunk.x_downlim;
		xz_plane.x_uplim = Chunk.x_uplim;
		xz_plane.z_downlim = Chunk.z_downlim;
		xz_plane.z_uplim = Chunk.z_uplim;
		//now partition the xz plane
		//first evalute this plane
		struct plane_evaluation xz_eval;
		xz_eval = evaluate_plane(xz_plane_node_list, xz_plane, 1);
		//go around the four possible merged regions
		//at most partition the plane into four parts
		struct chunk part0;
		struct chunk part1;
		struct chunk part2;
		struct chunk part3;
		int part0_srcx, part0_srcy, part0_srcz;
		int part1_srcx, part1_srcy, part1_srcz;
		int part2_srcx, part2_srcy, part2_srcz;
		int part3_srcx, part3_srcy, part3_srcz;

		int part_valid[4] = { 0, 0, 0, 0 };
		if (xz_eval.region0_merge == 0){
			//region 0 is merged with region1
			part_valid[0] = 1;

			part0.y_uplim = xz_plane_node_list->y;
			part0.y_downlim = xz_plane_node_list->y;
			part0.x_downlim = xz_plane_node_list->x;
			part0.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
			part0.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
			part0.z_uplim = xz_plane_node_list->z - 1<0 ? Z - 1 : xz_plane_node_list->z - 1;
			part0_srcx = part0.x_downlim;
			part0_srcy = part0.y_downlim;
			part0_srcz = part0.z_uplim;
		}

		else if (xz_eval.region0_merge == 1){
			//region0 is merged with regino7
			part_valid[0] = 1;
			part0.y_uplim = xz_plane_node_list->y;
			part0.y_downlim = xz_plane_node_list->y;
			part0.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
			part0.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
			part0.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
			part0.z_uplim = xz_plane_node_list->z;
			part0_srcx = part0.x_downlim;
			part0_srcy = part0.y_downlim;
			part0_srcz = part0.z_uplim;
		}
		else if (xz_eval.region0_merge == 2){ // the region 0 is not used
			part_valid[0] = 0;
		}

		if (xz_eval.region2_merge == 0){
			//region 2 is merged with region 3
			part_valid[1] = 1;

			part1.y_uplim = xz_plane_node_list->y;
			part1.y_downlim = xz_plane_node_list->y;
			part1.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
			part1.x_uplim = xz_plane_node_list->x - 1<0 ? X - 1 : xz_plane_node_list->x - 1;
			part1.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
			part1.z_uplim = xz_plane_node_list->z;
			part1_srcx = part1.x_uplim;
			part1_srcy = part1.y_downlim;
			part1_srcz = part1.z_uplim;

		}
		else if (xz_eval.region2_merge == 1){
			if (part_valid[0] == 1 && xz_eval.region0_merge == 0){
				//region0 and region2 should be merged together
				part_valid[1] = 0;
				part0.x_downlim = xz_plane.x_downlim;
				part0.x_uplim = xz_plane.x_uplim;
				part0.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
				part0.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
				part0_srcx = xz_plane_node_list->x;
				part0_srcy = part0.y_downlim;
				part0_srcz = part0.z_uplim;

			}
			//region2 is merged with region1
			else{
				part_valid[1] = 1;

				part1.y_uplim = xz_plane_node_list->y;
				part1.y_downlim = xz_plane_node_list->y;
				part1.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
				part1.x_uplim = xz_plane_node_list->x;
				part1.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)< 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
				part1.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
				part1_srcx = part1.x_uplim;
				part1_srcy = part1.y_downlim;
				part1_srcz = part1.z_uplim;
			}

		}
		else if (xz_eval.region2_merge == 2){ // the region 2 is not used
			part_valid[1] = 0;

		}

		if (xz_eval.region4_merge == 0){
			//region 4 is merged with region 5
			part_valid[2] = 1;
			part2.y_uplim = xz_plane_node_list->y;
			part2.y_downlim = xz_plane_node_list->y;
			part2.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
			part2.x_uplim = xz_plane_node_list->x;
			part2.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
			part2.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
			part2_srcx = part2.x_uplim;
			part2_srcy = part2.y_downlim;
			part2_srcz = part2.z_downlim;

		}
		else if (xz_eval.region4_merge == 1){
			if (part_valid[1] == 1 && xz_eval.region2_merge == 0){
				//region2 and region4 should be merged together
				part_valid[2] = 0;


				part1.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
				part1.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
				part1.z_downlim = xz_plane.z_downlim;
				part1.z_uplim = xz_plane.z_uplim;
				part1_srcx = part1.x_uplim;
				part1_srcy = part1.y_downlim;
				part1_srcz = xz_plane_node_list->z;

			}
			//region4 is merged with region3
			else{
				part_valid[2] = 1;

				part2.y_uplim = xz_plane_node_list->y;
				part2.y_downlim = xz_plane_node_list->y;
				part2.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
				part2.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
				part2.z_downlim = xz_plane_node_list->z;
				part2.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
				part2_srcx = part2.x_uplim;
				part2_srcy = part2.y_downlim;
				part2_srcz = part2.z_downlim;
			}

		}
		else if (xz_eval.region4_merge == 2){ // the region 4 is not used
			part_valid[2] = 0;

		}

		if (xz_eval.region6_merge == 0){
			if (part_valid[0] == 1 && xz_eval.region0_merge == 1){
				//region0 and region6 should be merged together
				part_valid[3] = 0;


				part0.y_uplim = xz_plane_node_list->y;
				part0.y_downlim = xz_plane_node_list->y;
				part0.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
				part0.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
				part0.z_downlim = xz_plane.z_downlim;
				part0.z_uplim = xz_plane.z_uplim;
				part0_srcx = part0.x_downlim;
				part0_srcy = part0.y_downlim;
				part0_srcz = xz_plane_node_list->z;

			}
			//region 6 is merged with region 7
			else{
				part_valid[3] = 1;

				part3.y_uplim = xz_plane_node_list->y;
				part3.y_downlim = xz_plane_node_list->y;
				part3.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
				part3.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
				part3.z_downlim = xz_plane_node_list->z;
				part3.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcy = part3.y_downlim;
				part3_srcz = part3.z_downlim;
			}

		}
		else if (xz_eval.region6_merge == 1){
			if (part_valid[2] == 1 && xz_eval.region4_merge == 0){
				//region4 and region6 should be merged together
				part_valid[3] = 0;

				part2.x_downlim = xz_plane.x_downlim;
				part2.x_uplim = xz_plane.x_uplim;
				part2.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
				part2.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
				part2_srcx = xz_plane_node_list->x;
				part2_srcy = part2.y_downlim;
				part2_srcz = part2.z_downlim;

			}
			//region6 is merged with region5
			else{
				part_valid[3] = 1;


				part3.y_uplim = xz_plane_node_list->y;
				part3.y_downlim = xz_plane_node_list->y;
				part3.x_downlim = xz_plane_node_list->x;
				part3.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
				part3.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
				part3.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcy = part3.y_downlim;
				part3_srcz = part3.z_downlim;
			}

		}
		else if (xz_eval.region6_merge == 2){ // the region 6 is not used
			part_valid[3] = 0;

		}
		if (xz_eval.region0_merge != 0 && xz_eval.region2_merge != 1){
			if (xz_eval.zneg_enable){
				if (xz_eval.region0_merge != 1){
					//this is region1, now use part0 to cover it(part1 is also ok, but we use part0 here
					part_valid[0] = 1;
					part0.y_downlim = xz_plane.y_downlim;
					part0.y_uplim = xz_plane.y_uplim;
					part0.x_downlim = xz_plane_node_list->x;
					part0.x_uplim = xz_plane_node_list->x;
					part0.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
					part0.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
					part0_srcx = xz_plane_node_list->x;
					part0_srcy = xz_plane.y_downlim;
					part0_srcz = part0.z_uplim;
				}
				else if (xz_eval.region2_merge != 0){
					part_valid[1] = 1;
					part1.y_downlim = xz_plane.y_downlim;
					part1.y_uplim = xz_plane.y_uplim;
					part1.x_downlim = xz_plane_node_list->x;
					part1.x_uplim = xz_plane_node_list->x;
					part1.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
					part1.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
					part1_srcx = xz_plane_node_list->x;
					part1_srcy = xz_plane.y_downlim;
					part1_srcz = part1.z_uplim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 2){
						part_valid[2] = 1;
						part2.y_downlim = xz_plane.y_downlim;
						part2.y_uplim = xz_plane.y_uplim;
						part2.x_downlim = xz_plane_node_list->x;
						part2.x_uplim = xz_plane_node_list->x;
						part2.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
						part2.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
						part2_srcx = xz_plane_node_list->x;
						part2_srcy = xz_plane.y_downlim;
						part2_srcz = part2.z_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.y_downlim = xz_plane.y_downlim;
						part3.y_uplim = xz_plane.y_uplim;
						part3.x_downlim = xz_plane_node_list->x;
						part3.x_uplim = xz_plane_node_list->x;
						part3.z_downlim = xz_plane.z_wrap() ? (xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) < 0 ? xz_plane_node_list->z - Z / 2 + (Z % 2 == 0) + Z : xz_plane_node_list->z - Z / 2 + (Z % 2 == 0)) : xz_plane.z_downlim;
						part3.z_uplim = xz_plane_node_list->z - 1 < 0 ? Z - 1 : xz_plane_node_list->z - 1;
						part3_srcx = xz_plane_node_list->x;
						part3_srcy = xz_plane.y_downlim;
						part3_srcz = part3.z_uplim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (xz_eval.region2_merge != 0 && xz_eval.region4_merge != 1){
			if (xz_eval.xneg_enable){
				if (xz_eval.region2_merge != 1){
					part_valid[1] = 1;
					part1.y_downlim = xz_plane.y_downlim;
					part1.y_uplim = xz_plane.y_uplim;
					part1.z_downlim = xz_plane_node_list->z;
					part1.z_uplim = xz_plane_node_list->z;
					part1.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
					part1.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
					part1_srcx = part1.x_uplim;
					part1_srcy = xz_plane.y_downlim;
					part1_srcz = part1.z_uplim;
				}
				else if (xz_eval.region4_merge != 0){
					part_valid[2] = 1;
					part2.y_downlim = xz_plane.y_downlim;
					part2.y_uplim = xz_plane.y_uplim;
					part2.z_downlim = xz_plane_node_list->z;
					part2.z_uplim = xz_plane_node_list->z;
					part2.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
					part2.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
					part2_srcx = part2.x_uplim;
					part2_srcy = xz_plane.y_downlim;
					part2_srcz = part2.z_uplim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						part_valid[0] = 1;
						part0.y_downlim = xz_plane.y_downlim;
						part0.y_uplim = xz_plane.y_uplim;
						part0.z_downlim = xz_plane_node_list->z;
						part0.z_uplim = xz_plane_node_list->z;
						part0.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
						part0.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
						part0_srcx = part0.x_uplim;
						part0_srcy = xz_plane.y_downlim;
						part0_srcz = part0.z_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.y_downlim = xz_plane.y_downlim;
						part3.y_uplim = xz_plane.y_uplim;
						part3.z_downlim = xz_plane_node_list->z;
						part3.z_uplim = xz_plane_node_list->z;
						part3.x_downlim = xz_plane.x_wrap() ? (xz_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xz_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xz_plane_node_list->x - X / 2 + (X % 2 == 0)) : xz_plane.x_downlim;
						part3.x_uplim = xz_plane_node_list->x - 1 < 0 ? X - 1 : xz_plane_node_list->x - 1;
						part3_srcx = part3.x_uplim;
						part3_srcy = xz_plane.y_downlim;
						part3_srcz = part3.z_uplim;
					}
					else
						cout << "bug" << endl;
				}

			}
		}
		if (xz_eval.region4_merge != 0 && xz_eval.region6_merge != 1){
			if (xz_eval.zpos_enable){
				if (xz_eval.region4_merge != 1){
					part_valid[2] = 1;
					part2.y_downlim = xz_plane.y_downlim;
					part2.y_uplim = xz_plane.y_uplim;
					part2.x_downlim = xz_plane_node_list->x;
					part2.x_uplim = xz_plane_node_list->x;
					part2.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
					part2.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
					part2_srcx = part2.x_uplim;
					part2_srcy = xz_plane.y_downlim;
					part2_srcz = part2.z_downlim;
				}
				else if (xz_eval.region6_merge != 0){
					part_valid[3] = 1;
					part3.y_downlim = xz_plane.y_downlim;
					part3.y_uplim = xz_plane.y_uplim;
					part3.x_downlim = xz_plane_node_list->x;
					part3.x_uplim = xz_plane_node_list->x;
					part3.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
					part3.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
					part3_srcx = part3.x_uplim;
					part3_srcy = xz_plane.y_downlim;
					part3_srcz = part3.z_downlim;

				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						part_valid[0] = 1;
						part0.y_downlim = xz_plane.y_downlim;
						part0.y_uplim = xz_plane.y_uplim;
						part0.x_downlim = xz_plane_node_list->x;
						part0.x_uplim = xz_plane_node_list->x;
						part0.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
						part0.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
						part0_srcx = part0.x_uplim;
						part0_srcy = xz_plane.y_downlim;
						part0_srcz = part0.z_downlim;
					}
					else if (part_idx == 1){
						part_valid[1] = 1;
						part1.y_downlim = xz_plane.y_downlim;
						part1.y_uplim = xz_plane.y_uplim;
						part1.x_downlim = xz_plane_node_list->x;
						part1.x_uplim = xz_plane_node_list->x;
						part1.z_uplim = xz_plane.z_wrap() ? (xz_plane_node_list->z + Z / 2 >= Z ? xz_plane_node_list->z + Z / 2 - Z : xz_plane_node_list->z + Z / 2) : xz_plane.z_uplim;
						part1.z_downlim = xz_plane_node_list->z + 1 >= Z ? 0 : xz_plane_node_list->z + 1;
						part1_srcx = part0.x_uplim;
						part1_srcy = xz_plane.y_downlim;
						part1_srcz = part0.z_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (xz_eval.region6_merge != 0 && xz_eval.region0_merge != 1){
			if (xz_eval.xpos_enable){
				if (xz_eval.region6_merge != 1){
					part_valid[3] = 1;
					part3.y_downlim = xz_plane.y_downlim;
					part3.y_uplim = xz_plane.y_uplim;
					part3.z_downlim = xz_plane_node_list->z;
					part3.z_uplim = xz_plane_node_list->z;
					part3.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
					part3.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
					part3_srcx = part3.x_downlim;
					part3_srcy = xz_plane.y_downlim;
					part3_srcz = part3.z_downlim;
				}
				else if (xz_eval.region0_merge != 0){
					part_valid[0] = 1;
					part0.y_downlim = xz_plane.y_downlim;
					part0.y_uplim = xz_plane.y_uplim;
					part0.z_downlim = xz_plane_node_list->z;
					part0.z_uplim = xz_plane_node_list->z;
					part0.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
					part0.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
					part0_srcx = part0.x_downlim;
					part0_srcy = xz_plane.y_downlim;
					part0_srcz = part0.z_downlim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 1){
						part_valid[1] = 1;
						part1.y_downlim = xz_plane.y_downlim;
						part1.y_uplim = xz_plane.y_uplim;
						part1.z_downlim = xz_plane_node_list->z;
						part1.z_uplim = xz_plane_node_list->z;
						part1.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
						part1.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
						part1_srcx = part1.x_downlim;
						part1_srcy = xz_plane.y_downlim;
						part1_srcz = part1.z_downlim;
					}
					else if (part_idx == 2){
						part_valid[2] = 1;
						part2.y_downlim = xz_plane.y_downlim;
						part2.y_uplim = xz_plane.y_uplim;
						part2.z_downlim = xz_plane_node_list->z;
						part2.z_uplim = xz_plane_node_list->z;
						part2.x_uplim = xz_plane.x_wrap() ? (xz_plane_node_list->x + X / 2 >= X ? xz_plane_node_list->x + X / 2 - X : xz_plane_node_list->x + X / 2) : xz_plane.x_uplim;
						part2.x_downlim = xz_plane_node_list->x + 1 >= X ? 0 : xz_plane_node_list->x + 1;
						part2_srcx = part2.x_downlim;
						part2_srcy = xz_plane.y_downlim;
						part2_srcz = part2.z_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}


		//now distribute the xz_plane_node_list into parts (up to 4)
		struct src_dst_list* xz_plane_node_ptr = xz_plane_node_list->next;
		struct src_dst_list* part0_list = NULL;
		struct src_dst_list* part1_list = NULL;
		struct src_dst_list* part2_list = NULL;
		struct src_dst_list* part3_list = NULL;

		if (part_valid[0]){
			if (!(part0_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part0_list->valid = true;
			part0_list->src_or_dst = true;
			part0_list->next = NULL;
			part0_list->x = part0_srcx;
			part0_list->y = part0_srcy;
			part0_list->z = part0_srcz;
		}
		if (part_valid[1]){
			if (!(part1_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part1_list->valid = true;
			part1_list->src_or_dst = true;
			part1_list->next = NULL;
			part1_list->x = part1_srcx;
			part1_list->y = part1_srcy;
			part1_list->z = part1_srcz;
		}
		if (part_valid[2]){
			if (!(part2_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part2_list->valid = true;
			part2_list->src_or_dst = true;
			part2_list->next = NULL;
			part2_list->x = part2_srcx;
			part2_list->y = part2_srcy;
			part2_list->z = part2_srcz;
		}
		if (part_valid[3]){
			if (!(part3_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part3_list->valid = true;
			part3_list->src_or_dst = true;
			part3_list->next = NULL;
			part3_list->x = part3_srcx;
			part3_list->y = part3_srcy;
			part3_list->z = part3_srcz;
		}

		struct src_dst_list* new_node;

		while (xz_plane_node_ptr){
			if (part_valid[0] && within_range(part0, xz_plane_node_ptr)){
				//insert a node into the part0 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xz_plane_node_ptr->x;
				new_node->y = xz_plane_node_ptr->y;
				new_node->z = xz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part0_list->next;
				part0_list->next = new_node;

			}
			else if (part_valid[1] && within_range(part1, xz_plane_node_ptr)){

				//insert a node into the part1 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xz_plane_node_ptr->x;
				new_node->y = xz_plane_node_ptr->y;
				new_node->z = xz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part1_list->next;
				part1_list->next = new_node;


			}
			else if (part_valid[2] && within_range(part2, xz_plane_node_ptr)){

				//insert a node into the part2 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xz_plane_node_ptr->x;
				new_node->y = xz_plane_node_ptr->y;
				new_node->z = xz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part2_list->next;
				part2_list->next = new_node;


			}
			else if (part_valid[3] && within_range(part3, xz_plane_node_ptr)){

				//insert a node into the part3 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xz_plane_node_ptr->x;
				new_node->y = xz_plane_node_ptr->y;
				new_node->z = xz_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part3_list->next;
				part3_list->next = new_node;


			}

			xz_plane_node_ptr = xz_plane_node_ptr->next;
		}

		int new_weight = (tree_src->weight == 1) ? 1 : tree_src->weight / 2;
		node* y_pos_src;
		node* y_neg_src;
		node* part0_src;
		node* part1_src;
		node* part2_src;
		node* part3_src;
		if (y_up_node_list){
			tree_src->children[tree_src->num_children] = new node(y_up_node_list->x, y_up_node_list->y, y_up_node_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			y_pos_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (y_down_node_list){
			tree_src->children[tree_src->num_children] = new node(y_down_node_list->x, y_down_node_list->y, y_down_node_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			y_neg_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[0]){
			tree_src->children[tree_src->num_children] = new node(part0_list->x, part0_list->y, part0_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part0_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[1]){
			tree_src->children[tree_src->num_children] = new node(part1_list->x, part1_list->y, part1_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part1_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[2]){
			tree_src->children[tree_src->num_children] = new node(part2_list->x, part2_list->y, part2_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part2_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[3]){
			tree_src->children[tree_src->num_children] = new node(part3_list->x, part3_list->y, part3_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part3_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		//print the current the src and dst nodes on the current node
		fout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
			accumulate_link(tree_src,tree_src->children[children_idx]);
		}
		fout << "}" << endl;

		cout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
		}
		cout << "}" << endl;

		struct src_dst_list* free_ptr;

		struct src_dst_list* next_free_ptr;

		if (y_up_node_list){
			RPM_partition(y_up_node_list, ypos_chunk, y_pos_src);
		}
		if (y_down_node_list){
			RPM_partition(y_down_node_list, yneg_chunk, y_neg_src);
		}
		if (part_valid[0]){
			RPM_partition_2D(part0_list, part0, part0_src,1);
		}

		free_ptr = part0_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}

		if (part_valid[1]){
			RPM_partition_2D(part1_list, part1, part1_src,1);
		}

		free_ptr = part1_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}

		if (part_valid[2]){
			RPM_partition_2D(part2_list, part2, part2_src,1);
		}

		free_ptr = part2_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}

		if (part_valid[3]){
			RPM_partition_2D(part3_list, part3, part3_src,1);
		}

		//free the four part_list
	
		
		
		
		free_ptr = part3_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}



	}
	else if (partition_eval == 2){
		//partition_along z direction
		//partition along xy plane
		struct src_dst_list* z_up_node_list = NULL;
		struct src_dst_list* z_down_node_list = NULL;
		struct src_dst_list* xy_plane_node_list;
		//init the three link lists
		if (!(z_up_node_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
			cout << "no mem" << endl;
			exit(-1);
		}

		if (!(xy_plane_node_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
			cout << "no mem" << endl;
			exit(-1);
		}
		xy_plane_node_list->next = NULL;
		xy_plane_node_list->x = node_list->x;
		xy_plane_node_list->y = node_list->y;
		xy_plane_node_list->z = node_list->z;
		xy_plane_node_list->valid = true;
		xy_plane_node_list->src_or_dst = true;
		if (Chunk.z_wrap() || ((!Chunk.z_wrap()) && node_list->z != Chunk.z_downlim)){
			if (!(z_down_node_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			z_down_node_list->x = node_list->x;
			z_down_node_list->y = node_list->y;
			z_down_node_list->z = node_list->z != 0 ? (node_list->z - 1) : Z - 1;
			z_down_node_list->next = NULL;
			z_down_node_list->valid = true;
			z_down_node_list->src_or_dst = true;
		}
		if (Chunk.z_wrap() || ((!Chunk.z_wrap()) && node_list->z != Chunk.z_uplim)){
			if (!(z_up_node_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			z_up_node_list->x = node_list->x;
			z_up_node_list->y = node_list->y;
			z_up_node_list->z = node_list->z != Z - 1 ? (node_list->z + 1) : 0;
			z_up_node_list->next = NULL;
			z_up_node_list->valid = true;
			z_up_node_list->src_or_dst = true;
		}

		//now distribute the nodes in node_list into three parts
		struct src_dst_list* node_ptr;
		struct src_dst_list* next_node;
		node_ptr = node_list->next;
		while (node_ptr){
			next_node = node_ptr->next;
			if (node_ptr->z == xy_plane_node_list->z){
				//insert this node into xy_plane_node_list
				node_ptr->next = xy_plane_node_list->next;
				xy_plane_node_list->next = node_ptr;

			}
			else if (Chunk.z_wrap()){
				if (node_ptr->z > xy_plane_node_list->z){
					if (node_ptr->z - xy_plane_node_list->z <= Z / 2){
						//insert this node into the z_up_node_list
						if (z_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = z_up_node_list->next;
							z_up_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node int othe z_down_node_list
						if (z_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = z_down_node_list->next;
							z_down_node_list->next = node_ptr;
						}
					}

				}
				else{
					if (xy_plane_node_list->z - node_ptr->z <= Z / 2){
						//insert this node into the z_down_node_list
						if (z_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = z_down_node_list->next;
							z_down_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node into the z_up_node_list
						if (z_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = z_up_node_list->next;
							z_up_node_list->next = node_ptr;
						}
					}
				}

			}
			else{//z is not wrap up
				if (Chunk.z_downlim < Chunk.z_uplim){
					if (node_ptr->z>xy_plane_node_list->z){
						//insert this node into the z_up_node_list
						if (z_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = z_up_node_list->next;
							z_up_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node into the z_down_node_list
						if (z_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = z_down_node_list->next;
							z_down_node_list->next = node_ptr;
						}
					}
				}
				else if (Chunk.z_downlim > Chunk.z_uplim){
					int z_distance_between_node_ptr_downlim = (node_ptr->z >= Chunk.z_downlim) ? (node_ptr->z - Chunk.z_downlim) : (node_ptr->z - Chunk.z_downlim + Z);
					int z_distance_between_src_downlim = (xy_plane_node_list->z >= Chunk.z_downlim) ? (xy_plane_node_list->z - Chunk.z_downlim) : (xy_plane_node_list->z - Chunk.z_downlim + Z);
					if (z_distance_between_src_downlim < z_distance_between_node_ptr_downlim){
						//insert this node into the x_up_node_list
						if (z_up_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = z_up_node_list->next;
							z_up_node_list->next = node_ptr;
						}
					}
					else{
						//insert this node into the x_down_node_list
						if (z_down_node_list == NULL){
							cout << "THe bug has happened at the node" << node_ptr->x << " " << node_ptr->y << " " << node_ptr->z << " " << endl;
						}
						else{
							node_ptr->next = z_down_node_list->next;
							z_down_node_list->next = node_ptr;
						}
					}

				}

			}
			node_ptr = next_node;
		}
		//now the nodes are all in the three link lists
		//generate the zpos chunk and zneg chunk
		struct chunk zpos_chunk;
		struct chunk zneg_chunk;
		struct chunk xy_plane;
		if (z_up_node_list){
			zpos_chunk.z_downlim = z_up_node_list->z;
			if (Chunk.z_wrap()){
				zpos_chunk.z_uplim = xy_plane_node_list->z + Z / 2 >= Z ? xy_plane_node_list->z + Z / 2 - Z : xy_plane_node_list->z + Z / 2;
			}
			else
				zpos_chunk.z_uplim = Chunk.z_uplim;
			zpos_chunk.x_downlim = Chunk.x_downlim;
			zpos_chunk.x_uplim = Chunk.x_uplim;
			zpos_chunk.y_downlim = Chunk.y_downlim;
			zpos_chunk.y_uplim = Chunk.y_uplim;

		}
		if (z_down_node_list){
			zneg_chunk.z_uplim = z_down_node_list->z;
			if (Chunk.z_wrap()){
				zneg_chunk.z_downlim = xy_plane_node_list->z - Z / 2 + 1<0 ? xy_plane_node_list->z - Z / 2 + 1 + Z : xy_plane_node_list->z - Z / 2 + 1;
			}
			else
				zneg_chunk.z_downlim = Chunk.z_downlim;
			zneg_chunk.x_downlim = Chunk.x_downlim;
			zneg_chunk.x_uplim = Chunk.x_uplim;
			zneg_chunk.y_downlim = Chunk.y_downlim;
			zneg_chunk.y_uplim = Chunk.y_uplim;
		}
		xy_plane.z_downlim = xy_plane_node_list->z;
		xy_plane.z_uplim = xy_plane_node_list->z;
		xy_plane.x_downlim = Chunk.x_downlim;
		xy_plane.x_uplim = Chunk.x_uplim;
		xy_plane.y_downlim = Chunk.y_downlim;
		xy_plane.y_uplim = Chunk.y_uplim;
		//now partition the xz plane
		//first evalute this plane
		struct plane_evaluation xy_eval;
		xy_eval = evaluate_plane(xy_plane_node_list, xy_plane, 2);
		//go around the four possible merged regions
		//at most partition the plane into four parts
		struct chunk part0;
		struct chunk part1;
		struct chunk part2;
		struct chunk part3;
		int part0_srcx, part0_srcy, part0_srcz;
		int part1_srcx, part1_srcy, part1_srcz;
		int part2_srcx, part2_srcy, part2_srcz;
		int part3_srcx, part3_srcy, part3_srcz;

		int part_valid[4] = { 0, 0, 0, 0 };
		if (xy_eval.region0_merge == 0){
			//region 0 is merged with region1
			part_valid[0] = 1;

			part0.z_uplim = xy_plane_node_list->z;
			part0.z_downlim = xy_plane_node_list->z;
			part0.x_downlim = xy_plane_node_list->x;
			part0.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
			part0.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
			part0.y_uplim = xy_plane_node_list->y - 1<0 ? Y - 1 : xy_plane_node_list->y - 1;
			part0_srcx = part0.x_downlim;
			part0_srcz = part0.z_downlim;
			part0_srcy = part0.y_uplim;
		}

		else if (xy_eval.region0_merge == 1){
			//region0 is merged with regino7
			part_valid[0] = 1;
			part0.z_uplim = xy_plane_node_list->z;
			part0.z_downlim = xy_plane_node_list->z;
			part0.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
			part0.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
			part0.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
			part0.y_uplim = xy_plane_node_list->y;
			part0_srcx = part0.x_downlim;
			part0_srcz = part0.z_downlim;
			part0_srcy = part0.y_uplim;
		}
		else if (xy_eval.region0_merge == 2){ // the region 0 is not used
			part_valid[0] = 0;
		}

		if (xy_eval.region2_merge == 0){
			//region 2 is merged with region 3
			part_valid[1] = 1;

			part1.z_uplim = xy_plane_node_list->z;
			part1.z_downlim = xy_plane_node_list->z;
			part1.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
			part1.x_uplim = xy_plane_node_list->x - 1<0 ? X - 1 : xy_plane_node_list->x - 1;
			part1.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
			part1.y_uplim = xy_plane_node_list->y;
			part1_srcx = part1.x_uplim;
			part1_srcz = part1.z_downlim;
			part1_srcy = part1.y_uplim;

		}
		else if (xy_eval.region2_merge == 1){

			if (part_valid[0] == 1 && xy_eval.region0_merge == 0){
				//region0 and region2 should be merged together
				part_valid[1] = 0;
				part0.x_downlim = xy_plane.x_downlim;
				part0.x_uplim = xy_plane.x_uplim;
				part0.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
				part0.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
				part0_srcx = xy_plane_node_list->x;
				part0_srcz = part0.z_downlim;
				part0_srcy = part0.y_uplim;

			}
						//region2 is merged with region1
			else{
				part_valid[1] = 1;

				part1.z_uplim = xy_plane_node_list->z;
				part1.z_downlim = xy_plane_node_list->z;
				part1.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
				part1.x_uplim = xy_plane_node_list->x;
				part1.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)< 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
				part1.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
				part1_srcx = part1.x_uplim;
				part1_srcz = part1.z_downlim;
				part1_srcy = part1.y_uplim;
			}
		}
		else if (xy_eval.region2_merge == 2){ // the region 2 is not used
			part_valid[1] = 0;

		}

		if (xy_eval.region4_merge == 0){
			//region 4 is merged with region 5
			part_valid[2] = 1;
			part2.z_uplim = xy_plane_node_list->z;
			part2.z_downlim = xy_plane_node_list->z;
			part2.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
			part2.x_uplim = xy_plane_node_list->x;
			part2.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
			part2.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= X ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
			part2_srcx = part2.x_uplim;
			part2_srcz = part2.z_downlim;
			part2_srcy = part2.y_downlim;

		}
		else if (xy_eval.region4_merge == 1){
			if (part_valid[1] == 1 && xy_eval.region2_merge == 0){
				//region2 and region4 should be merged together
				part_valid[2] = 0;


				part1.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
				part1.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
				part1.y_downlim = xy_plane.y_downlim;
				part1.y_uplim = xy_plane.y_uplim;
				part1_srcx = part1.x_uplim;
				part1_srcz = part1.z_downlim;
				part1_srcy = xy_plane_node_list->y;

			}
			//region4 is merged with region3
			else{
				part_valid[2] = 1;

				part2.z_uplim = xy_plane_node_list->z;
				part2.z_downlim = xy_plane_node_list->z;
				part2.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0)< 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
				part2.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
				part2.y_downlim = xy_plane_node_list->y;
				part2.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= X ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
				part2_srcx = part2.x_uplim;
				part2_srcz = part2.z_downlim;
				part2_srcy = part2.y_downlim;
			}

		}
		else if (xy_eval.region4_merge == 2){ // the region 4 is not used
			part_valid[2] = 0;

		}

		if (xy_eval.region6_merge == 0){
			if (part_valid[0] == 1 && xy_eval.region0_merge == 1){
				//region0 and region6 should be merged together
				part_valid[3] = 0;


				part0.z_uplim = xy_plane_node_list->z;
				part0.z_downlim = xy_plane_node_list->z;
				part0.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
				part0.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
				part0.y_downlim = xy_plane.y_downlim;
				part0.y_uplim = xy_plane.y_uplim;
				part0_srcx = part0.x_downlim;
				part0_srcz = part0.z_downlim;
				part0_srcy = xy_plane_node_list->y;

			}
			//region 6 is merged with region 7
			else{
				part_valid[3] = 1;

				part3.z_uplim = xy_plane_node_list->z;
				part3.z_downlim = xy_plane_node_list->z;
				part3.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
				part3.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
				part3.y_downlim = xy_plane_node_list->y;
				part3.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= X ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcz = part3.z_downlim;
				part3_srcy = part3.y_downlim;
			}

		}
		else if (xy_eval.region6_merge == 1){
			if (part_valid[2] == 1 && xy_eval.region4_merge == 0){
				//region4 and region6 should be merged together
				part_valid[3] = 0;

				part2.x_downlim = xy_plane.x_downlim;
				part2.x_uplim = xy_plane.x_uplim;
				part2.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
				part2.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= X ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
				part2_srcx = xy_plane_node_list->x;
				part2_srcz = part2.z_downlim;
				part2_srcy = part2.y_downlim;

			}
			//region6 is merged with region5
			else{
				part_valid[3] = 1;


				part3.z_uplim = xy_plane_node_list->z;
				part3.z_downlim = xy_plane_node_list->z;
				part3.x_downlim = xy_plane_node_list->x;
				part3.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
				part3.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
				part3.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= X ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
				part3_srcx = part3.x_downlim;
				part3_srcz = part3.z_downlim;
				part3_srcy = part3.y_downlim;
			}

		}
		else if (xy_eval.region6_merge == 2){ // the region 6 is not used
			part_valid[3] = 0;

		}

		if (xy_eval.region0_merge != 0 && xy_eval.region2_merge != 1){
			if (xy_eval.yneg_enable){
				if (xy_eval.region0_merge != 1){
					//this is region1, now use part0 to cover it(part1 is also ok, but we use part0 here
					part_valid[0] = 1;
					part0.z_downlim = xy_plane.z_downlim;
					part0.z_uplim = xy_plane.z_uplim;
					part0.x_downlim = xy_plane_node_list->x;
					part0.x_uplim = xy_plane_node_list->x;
					part0.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
					part0.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
					part0_srcx = xy_plane_node_list->x;
					part0_srcz = xy_plane.z_downlim;
					part0_srcy = part0.y_uplim;
				}
				else if (xy_eval.region2_merge != 0){
					//this is region1, now use part1 to cover it(part1 is also ok, but we use part0 here
					part_valid[1] = 1;
					part1.z_downlim = xy_plane.z_downlim;
					part1.z_uplim = xy_plane.z_uplim;
					part1.x_downlim = xy_plane_node_list->x;
					part1.x_uplim = xy_plane_node_list->x;
					part1.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
					part1.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
					part1_srcx = xy_plane_node_list->x;
					part1_srcz = xy_plane.z_downlim;
					part1_srcy = part1.y_uplim;

				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 2){
						//this is region1, now use part1 to cover it(part1 is also ok, but we use part0 here
						part_valid[2] = 1;
						part2.z_downlim = xy_plane.z_downlim;
						part2.z_uplim = xy_plane.z_uplim;
						part2.x_downlim = xy_plane_node_list->x;
						part2.x_uplim = xy_plane_node_list->x;
						part2.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
						part2.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
						part2_srcx = xy_plane_node_list->x;
						part2_srcz = xy_plane.z_downlim;
						part2_srcy = part2.y_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.z_downlim = xy_plane.z_downlim;
						part3.z_uplim = xy_plane.z_uplim;
						part3.x_downlim = xy_plane_node_list->x;
						part3.x_uplim = xy_plane_node_list->x;
						part3.y_downlim = xy_plane.y_wrap() ? (xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) < 0 ? xy_plane_node_list->y - Y / 2 + (Y % 2 == 0) + Y : xy_plane_node_list->y - Y / 2 + (Y % 2 == 0)) : xy_plane.y_downlim;
						part3.y_uplim = xy_plane_node_list->y - 1 < 0 ? Y - 1 : xy_plane_node_list->y - 1;
						part3_srcx = xy_plane_node_list->x;
						part3_srcz = xy_plane.z_downlim;
						part3_srcy = part3.y_uplim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (xy_eval.region2_merge != 0 && xy_eval.region4_merge != 1){
			if (xy_eval.xneg_enable){
				if (xy_eval.region2_merge != 1){
					part_valid[1] = 1;
					part1.z_downlim = xy_plane.z_downlim;
					part1.z_uplim = xy_plane.z_uplim;
					part1.y_downlim = xy_plane_node_list->y;
					part1.y_uplim = xy_plane_node_list->y;
					part1.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
					part1.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
					part1_srcx = part1.x_uplim;
					part1_srcz = xy_plane.z_downlim;
					part1_srcy = part1.y_uplim;
				}
				else if (xy_eval.region4_merge != 0){
					part_valid[2] = 1;
					part2.z_downlim = xy_plane.z_downlim;
					part2.z_uplim = xy_plane.z_uplim;
					part2.y_downlim = xy_plane_node_list->y;
					part2.y_uplim = xy_plane_node_list->y;
					part2.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
					part2.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
					part2_srcx = part2.x_uplim;
					part2_srcz = xy_plane.z_downlim;
					part2_srcy = part2.y_uplim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						//this is region1, now use part1 to cover it(part1 is also ok, but we use part0 here
						part_valid[0] = 1;
						part0.z_downlim = xy_plane.z_downlim;
						part0.z_uplim = xy_plane.z_uplim;
						part0.y_downlim = xy_plane_node_list->y;
						part0.y_uplim = xy_plane_node_list->y;
						part0.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
						part0.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
						part0_srcx = part0.x_uplim;
						part0_srcz = xy_plane.z_downlim;
						part0_srcy = part0.y_uplim;
					}
					else if (part_idx == 3){
						part_valid[3] = 1;
						part3.z_downlim = xy_plane.z_downlim;
						part3.z_uplim = xy_plane.z_uplim;
						part3.y_downlim = xy_plane_node_list->y;
						part3.y_uplim = xy_plane_node_list->y;
						part3.x_downlim = xy_plane.x_wrap() ? (xy_plane_node_list->x - X / 2 + (X % 2 == 0) < 0 ? xy_plane_node_list->x - X / 2 + (X % 2 == 0) + X : xy_plane_node_list->x - X / 2 + (X % 2 == 0)) : xy_plane.x_downlim;
						part3.x_uplim = xy_plane_node_list->x - 1 < 0 ? X - 1 : xy_plane_node_list->x - 1;
						part3_srcx = part0.x_uplim;
						part3_srcz = xy_plane.z_downlim;
						part3_srcy = part0.y_uplim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (xy_eval.region4_merge != 0 && xy_eval.region6_merge != 1){
			if (xy_eval.ypos_enable){
				if (xy_eval.region4_merge != 1){
					part_valid[2] = 1;
					part2.z_downlim = xy_plane.z_downlim;
					part2.z_uplim = xy_plane.z_uplim;
					part2.x_downlim = xy_plane_node_list->x;
					part2.x_uplim = xy_plane_node_list->x;
					part2.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
					part2.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
					part2_srcx = part2.x_uplim;
					part2_srcz = xy_plane.z_downlim;
					part2_srcy = part2.y_downlim;
				}
				else if (xy_eval.region6_merge != 0){
					part_valid[3] = 1;
					part3.z_downlim = xy_plane.z_downlim;
					part3.z_uplim = xy_plane.z_uplim;
					part3.x_downlim = xy_plane_node_list->x;
					part3.x_uplim = xy_plane_node_list->x;
					part3.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
					part3.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
					part3_srcx = part3.x_uplim;
					part3_srcz = xy_plane.z_downlim;
					part3_srcy = part3.y_downlim;
				}
				else{
					//find the available the part
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 0){
						//this is region1, now use part1 to cover it(part1 is also ok, but we use part0 here
						part_valid[0] = 1;
						part0.z_downlim = xy_plane.z_downlim;
						part0.z_uplim = xy_plane.z_uplim;
						part0.x_downlim = xy_plane_node_list->x;
						part0.x_uplim = xy_plane_node_list->x;
						part0.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
						part0.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
						part0_srcx = part0.x_uplim;
						part0_srcz = xy_plane.z_downlim;
						part0_srcy = part0.y_downlim;
					}
					else if (part_idx == 1){
						part_valid[1] = 1;
						part1.z_downlim = xy_plane.z_downlim;
						part1.z_uplim = xy_plane.z_uplim;
						part1.x_downlim = xy_plane_node_list->x;
						part1.x_uplim = xy_plane_node_list->x;
						part1.y_uplim = xy_plane.y_wrap() ? (xy_plane_node_list->y + Y / 2 >= Y ? xy_plane_node_list->y + Y / 2 - Y : xy_plane_node_list->y + Y / 2) : xy_plane.y_uplim;
						part1.y_downlim = xy_plane_node_list->y + 1 >= Y ? 0 : xy_plane_node_list->y + 1;
						part1_srcx = part1.x_uplim;
						part1_srcz = xy_plane.z_downlim;
						part1_srcy = part1.y_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}
		if (xy_eval.region6_merge != 0 && xy_eval.region0_merge != 1){
			if (xy_eval.xpos_enable){
				if (xy_eval.region6_merge != 1){
					part_valid[3] = 1;
					part3.z_downlim = xy_plane.z_downlim;
					part3.z_uplim = xy_plane.z_uplim;
					part3.y_downlim = xy_plane_node_list->y;
					part3.y_uplim = xy_plane_node_list->y;
					part3.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
					part3.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
					part3_srcx = part3.x_downlim;
					part3_srcz = xy_plane.z_downlim;
					part3_srcy = part3.y_downlim;
				}
				else if (xy_eval.region0_merge != 0){
					part_valid[0] = 1;
					part0.z_downlim = xy_plane.z_downlim;
					part0.z_uplim = xy_plane.z_uplim;
					part0.y_downlim = xy_plane_node_list->y;
					part0.y_uplim = xy_plane_node_list->y;
					part0.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
					part0.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
					part0_srcx = part0.x_downlim;
					part0_srcz = xy_plane.z_downlim;
					part0_srcy = part0.y_downlim;
				}
				else{
					int part_idx;
					for (part_idx = 0; part_idx < 4; part_idx++){
						if (part_valid[part_idx] == 0){
							break;
						}
					}
					if (part_idx == 1){
						//this is region1, now use part1 to cover it(part1 is also ok, but we use part0 here
						part_valid[1] = 1;
						part1.z_downlim = xy_plane.z_downlim;
						part1.z_uplim = xy_plane.z_uplim;
						part1.y_downlim = xy_plane_node_list->y;
						part1.y_uplim = xy_plane_node_list->y;
						part1.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
						part1.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
						part1_srcx = part1.x_downlim;
						part1_srcz = xy_plane.z_downlim;
						part1_srcy = part1.y_downlim;
					}
					else if (part_idx == 2){
						part_valid[2] = 1;
						part2.z_downlim = xy_plane.z_downlim;
						part2.z_uplim = xy_plane.z_uplim;
						part2.y_downlim = xy_plane_node_list->y;
						part2.y_uplim = xy_plane_node_list->y;
						part2.x_uplim = xy_plane.x_wrap() ? (xy_plane_node_list->x + X / 2 >= X ? xy_plane_node_list->x + X / 2 - X : xy_plane_node_list->x + X / 2) : xy_plane.x_uplim;
						part2.x_downlim = xy_plane_node_list->x + 1 >= X ? 0 : xy_plane_node_list->x + 1;
						part2_srcx = part2.x_downlim;
						part2_srcz = xy_plane.z_downlim;
						part2_srcy = part2.y_downlim;
					}
					else
						cout << "bug" << endl;
				}
			}
		}

		//now distribute the xy_plane_node_list into parts (up to 4)
		struct src_dst_list* xy_plane_node_ptr = xy_plane_node_list->next;
		struct src_dst_list* part0_list = NULL;
		struct src_dst_list* part1_list = NULL;
		struct src_dst_list* part2_list = NULL;
		struct src_dst_list* part3_list = NULL;

		if (part_valid[0]){
			if (!(part0_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part0_list->valid = true;
			part0_list->src_or_dst = true;
			part0_list->next = NULL;
			part0_list->x = part0_srcx;
			part0_list->y = part0_srcy;
			part0_list->z = part0_srcz;
		}
		if (part_valid[1]){
			if (!(part1_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part1_list->valid = true;
			part1_list->src_or_dst = true;
			part1_list->next = NULL;
			part1_list->x = part1_srcx;
			part1_list->y = part1_srcy;
			part1_list->z = part1_srcz;
		}
		if (part_valid[2]){
			if (!(part2_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part2_list->valid = true;
			part2_list->src_or_dst = true;
			part2_list->next = NULL;
			part2_list->x = part2_srcx;
			part2_list->y = part2_srcy;
			part2_list->z = part2_srcz;
		}
		if (part_valid[3]){
			if (!(part3_list = (struct src_dst_list*)malloc(sizeof(struct src_dst_list)))){
				cout << "no mem" << endl;
				exit(-1);
			}
			part3_list->valid = true;
			part3_list->src_or_dst = true;
			part3_list->next = NULL;
			part3_list->x = part3_srcx;
			part3_list->y = part3_srcy;
			part3_list->z = part3_srcz;
		}

		struct src_dst_list* new_node;

		while (xy_plane_node_ptr){
			if (part_valid[0] && within_range(part0, xy_plane_node_ptr)){
				//insert a node into the part0 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xy_plane_node_ptr->x;
				new_node->y = xy_plane_node_ptr->y;
				new_node->z = xy_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part0_list->next;
				part0_list->next = new_node;

			}
			else if (part_valid[1] && within_range(part1, xy_plane_node_ptr)){

				//insert a node into the part1 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xy_plane_node_ptr->x;
				new_node->y = xy_plane_node_ptr->y;
				new_node->z = xy_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part1_list->next;
				part1_list->next = new_node;


			}
			else if (part_valid[2] && within_range(part2, xy_plane_node_ptr)){

				//insert a node into the part2 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xy_plane_node_ptr->x;
				new_node->y = xy_plane_node_ptr->y;
				new_node->z = xy_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part2_list->next;
				part2_list->next = new_node;


			}
			else if (part_valid[3] && within_range(part3, xy_plane_node_ptr)){

				//insert a node into the part3 list
				if (!(new_node = (struct src_dst_list*)malloc(sizeof(src_dst_list)))){
					cout << "no mem" << endl;
					exit(-1);
				}
				new_node->x = xy_plane_node_ptr->x;
				new_node->y = xy_plane_node_ptr->y;
				new_node->z = xy_plane_node_ptr->z;
				new_node->src_or_dst = false;
				new_node->valid = true;
				new_node->next = part3_list->next;
				part3_list->next = new_node;


			}

			xy_plane_node_ptr = xy_plane_node_ptr->next;
		}

		int new_weight = (tree_src->weight == 1) ? 1 : tree_src->weight / 2;
		node* z_pos_src;
		node* z_neg_src;
		node* part0_src;
		node* part1_src;
		node* part2_src;
		node* part3_src;
		if (z_up_node_list){
			tree_src->children[tree_src->num_children] = new node(z_up_node_list->x, z_up_node_list->y, z_up_node_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			z_pos_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (z_down_node_list){
			tree_src->children[tree_src->num_children] = new node(z_down_node_list->x, z_down_node_list->y, z_down_node_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			z_neg_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[0]){
			tree_src->children[tree_src->num_children] = new node(part0_list->x, part0_list->y, part0_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part0_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[1]){
			tree_src->children[tree_src->num_children] = new node(part1_list->x, part1_list->y, part1_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part1_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[2]){
			tree_src->children[tree_src->num_children] = new node(part2_list->x, part2_list->y, part2_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part2_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		if (part_valid[3]){
			tree_src->children[tree_src->num_children] = new node(part3_list->x, part3_list->y, part3_list->z, new_weight);
			tree_src->children[tree_src->num_children]->parent = tree_src;
			part3_src = tree_src->children[tree_src->num_children];
			tree_src->num_children++;
		}
		//print the current the src and dst nodes on the current node
		fout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			fout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
			accumulate_link(tree_src,tree_src->children[children_idx]);
		}
		fout << "}" << endl;

		cout << "{src: (" << tree_src->x << "," << tree_src->y << "," << tree_src->z << ") weight: " << tree_src->weight << endl;
		for (int children_idx = 0; children_idx < tree_src->num_children; children_idx++){
			cout << "dst: (" << tree_src->children[children_idx]->x << "," << tree_src->children[children_idx]->y << "," << tree_src->children[children_idx]->z << ") weight: " << new_weight << endl;
		}
		cout << "}" << endl;

		struct src_dst_list* free_ptr;

		struct src_dst_list* next_free_ptr;

		if (z_up_node_list){
			RPM_partition(z_up_node_list, zpos_chunk, z_pos_src);
		}
		if (z_down_node_list){
			RPM_partition(z_down_node_list, zneg_chunk, z_neg_src);
		}
		if (part_valid[0]){
			RPM_partition_2D(part0_list, part0, part0_src,2);
		}
		free_ptr = part0_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		if (part_valid[1]){
			RPM_partition_2D(part1_list, part1, part1_src,2);
		}
		free_ptr = part1_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		if (part_valid[2]){
			RPM_partition_2D(part2_list, part2, part2_src,2);
		}
		free_ptr = part2_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		if (part_valid[3]){
			RPM_partition_2D(part3_list, part3, part3_src,2);
		}

		free_ptr = part3_list;
		while (free_ptr){
			next_free_ptr = free_ptr->next;
			free(free_ptr);
			free_ptr = next_free_ptr;
		}
		//free the four part_list
		
		
		
		
		
	}
	
	
}





int main(){
	string filename = "C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/destination.txt";
	string output="C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/reduction_tree.txt";
	fout.open(output);
	global_partition_rr_choice = 0;
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
	chunk entire_space;
	entire_space.x_downlim=0;
	entire_space.x_uplim=X-1;
	entire_space.y_downlim=0;
	entire_space.y_uplim=Y-1;
	entire_space.z_downlim=0;
	entire_space.z_uplim=Z-1;
	read_src_dst_file(filename);
	node* tree_src_array[X*Y*Z];


	fout<<"X"<<endl;
	fout<<X<<endl;
	fout<<"Y"<<endl;
	fout<<Y<<endl;
	fout<<"Z"<<endl;
	fout<<Z<<endl;
	fout<<"The r_to_c ratio is:"<<endl;
	fout<<"1"<<endl;
	fout<<"The number of particles of one box"<<endl;
	fout<<"172"<<endl;
	fout<<"***************************start calculation!******************************"<<endl;

	for(int i=0;i<X*Y*Z;i++){
		if(src_list[i]->valid){
			tree_src_array[i]=new node(src_list[i]->x,src_list[i]->y,src_list[i]->z,256);

			fout<<"Start generating BroadCast TREE pattern for this node: ("<<src_list[i]->x<<","<<src_list[i]->y<<","<<src_list[i]->z<<"):"<<endl;
			fout<<endl;
			RPM_partition(src_list[i],entire_space,tree_src_array[i]);
		}
		else{
			tree_src_array[i]=NULL;
		}
	}
	
	return 0;
}
