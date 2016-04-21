//Purpose: generate the routing table, multicast table and reduction table
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 28th 2015
//Input: reduction_tree.txt this is the tree struction file
//Input: xyz.txt  this is the xyz coordinates of the particles

#include <fstream>
#include <iostream>
#include<string>
#include<stdlib.h>
#include<time.h>
#include<queue>
#include<Windows.h>
//#include<boost/multiprecision/cpp_int.hpp>

#define LINEMAX 100
#define MAX_NUM_CHILDREN 6
#define INIT_WEIGHT 512
#define ROUTING_TABLE_SIZE  4100
#define MULTICAST_TABLE_SIZE 256
#define REDUCTION_TABLE_SIZE 4096
#define MAX_TREE_DEPTH 8

#define LOCAL 0
#define YNEG 1
#define YPOS 2
#define XPOS 3
#define XNEG 4
#define ZPOS 5
#define ZNEG 6

#define SINGLECASTPCKT 8
#define MULTICASTPCKT 9
#define REDUCTIONPCKT 10

#define MODE 1


int mode = MODE; //1 is the multicast mode, 2 is the reduction mode, 3 is the forward singlecast mode, 4 is the reverse singlecast mode.
//5 

using namespace std;
//using namespace boost::multiprecision;

int X=4; // number of nodes on X dimension
int Y=4; // number of nodes on Y dimension
int Z=4; // number of nodes on Z dimension
double r2c=1;// the ratio between the cutoff radius and box size
int particle_per_box=512;
int particle_per_cell = 512;
float r = 12;
float xsize = 108;
float ysize = 108;
float zsize = 80;

struct payload{
	bool valid; // if valid, this valud will be 1
	float x;
	float y;
	float z;
	float type;
};

payload** xyz_list;

//routing table entry format
/*
* 32 bits in total
* |packetType|dst       |table index|priority|
* |4   bits  |4     bits|16 bits    |8 bits  |
* if the packet type is a singlecast packet, the dst field will be the exiting port on current node, the table index is the index on next node.
if the packet type is a multicast packet, the dst field is a dont-care field. The table index is the corresponding entry on the multicast table, the down stream packet will inherent the priority field of the parent packet
if the packet type is a reduction packet, the dst field is a dont-care field. The table index is the corresponding entry on the reduction table, the up stream packet will have the same prioity as the largest one among the largest packet
The first bit of the packet type field is valid bit
1000 is single cast packet
1001 is the mutlicast packet
1010 is the reduction packet

*/




struct routing_table_entry{
	int packet_type;
	int dst;
	int next_table_index;
	int priority;
//	char table_entry[9];//8 hex values for 32 bits
};

struct routing_table_entry_lite{
	char table_entry[9];//8 hex values for 32 bits
};

struct routing_table{
	struct routing_table_entry_lite table[7][ROUTING_TABLE_SIZE];
	int table_ptr[7];
};

struct routing_table* global_routing_table_array;

//multicast table entry format
/*
* at most 6 fan-out for 3D-torus network.
for each fanout, format is as below:
|dst   |table index|
|4 bits|16 bits    |
* |counter of valid packets|5th packet|4th packet| 3th packet| 2nd packet| 1st packet| 0th packet| 123 bits in total
* | 3 bits                 |20 bits   |20 bits   | 20 bits   | 20 bits   | 20 bits   | 20 bits   |
the counter are between 1 and 6
* */
struct multicast_table_entry{
	int downstream_num;
	int downstream_dst[6];
	int downstream_table_index[6];
//	char table_entry[27];
};

struct multicast_table_entry_lite{
	char table_entry[32];
};

struct multicast_table{
	struct multicast_table_entry_lite table[7][MULTICAST_TABLE_SIZE];
	int table_ptr[7];
};

struct multicast_table* global_multicast_table_array;

//reduction table entry format
/*
* at most five fan-in for 3D-torus network.
for each fanin, format is as below:
|3-bit expect counter|3-bit arrival bookkeeping counter|dst   |table index| weight accumulator| payload accumulator|
|3 bits              | 3 bits                          |4 bits|16 bits    | 8 bits            | 128 bits           | 162 bits in total
* */

struct reduction_table_entry{
	int downstream_expect_num;
	int upstream_dst;
	int upstream_table_index;
//	char table_entry[42];
};

struct reduction_table_entry_lite{
	char table_entry[44];
};

struct reduction_table{
	struct reduction_table_entry_lite table[7][REDUCTION_TABLE_SIZE];
	int table_ptr[7];
};

struct reduction_table* global_reduction_table_array;


struct data256{
	char hex_val[65];
};

struct data256** data_to_send;

int* data_to_send_ptr;

class node{
public:
	int x;
	int y;
	int z;
	int weight; // the children in the same level share the same weight
	int num_children; 
	int incoming_port_num; // the port num where the packet where come from, could be LOCAL, XPOS, XNEG, YPOS, YNEG, ZPOS, ZNEG
	int depth;//root is 0
	node* parent;
	node* children[MAX_NUM_CHILDREN];
	node(int X, int Y, int Z, int W){
		x = X;
		y = Y;
		z = Z;
		weight = W;
		parent = NULL;
		depth = 0;
		for (int i = 0; i < MAX_NUM_CHILDREN; ++i)
			children[i] = NULL;
		num_children = 0;
		incoming_port_num = LOCAL; // init as LOCAL first.

	}
};

struct link_list_node{
	node* NODE;
	link_list_node* next;
};

struct xyz{
	int x;
	int y;
	int z;
};

int extract_weight_from_line(char* line){
	int i = 0;
	int j;
	char data_substr[5];
	while (line[i++]){
		if (line[i] == 'w' && line[i + 1] == 'e'){
			//found keyword 'weight'
			break;
		}
	}
	j = i + 8;
	i = 0;
	while (line[j] <= '9'&&line[j]>='0'){
		data_substr[i] = line[j];
		i++;
		j++;
	}
	data_substr[i] = '\0';
	return atoi(data_substr);
}

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

node* BFS_find_node(node* root,xyz XYZ){
	if (!root)
		return NULL;
	else{
		queue<node*> Q;
		node* tmp = root;
		Q.push(tmp);
		while (!Q.empty()){
			tmp = Q.front();
			Q.pop();
			if (tmp->x==XYZ.x && tmp->y==XYZ.y && tmp->z==XYZ.z){
				return tmp;
			}
			for (int i = 0; i < MAX_NUM_CHILDREN; i++){
				if (tmp->children[i]){
					Q.push(tmp->children[i]);
				}
			}
		}
		return NULL;
	}


}

node **read_reduction_tree(char *filename){
	ifstream input_file;
	char line[LINEMAX];
	int i,j;//iterator in one line
	int line_counter = 0;

	node** root_array;
	node* root_tmp;
	node* current_node;
	int current_node_id;
	int cur_root_x;
	int cur_root_y;
	int cur_root_z;
	int child_idx;
	input_file.open(filename);
	if (input_file.fail())
		cout << "Open reduction tree file failed" << endl;
	else
		cout << "Open reduction tree file successfully" << endl;
	input_file.getline(line, LINEMAX); // first line should be X 
	line_counter++;
	input_file.getline(line, LINEMAX); // second line is value of X
	line_counter++;
	X = atoi(line);
	
	input_file.getline(line, LINEMAX); // first line should be Y 
	line_counter++;
	input_file.getline(line, LINEMAX); // second line is value of Y
	line_counter++;
	Y = atoi(line);
	
	input_file.getline(line, LINEMAX); // first line should be Z 
	line_counter++;
	input_file.getline(line, LINEMAX); // second line is value of Z
	line_counter++;
	Z = atoi(line);
	
	input_file.getline(line, LINEMAX); //verbose, skip(The r_to_c ratio is)
	line_counter++;
	input_file.getline(line, LINEMAX);
	line_counter++;
	r2c = atof(line);
	xsize = X*(r / r2c);
	ysize = Y*(r / r2c);
	zsize = Z*(r / r2c);
	input_file.getline(line, LINEMAX);////verbose, skip(One box contains number of particles)
	line_counter++;
	input_file.getline(line, LINEMAX);
	line_counter++;
	particle_per_box = atoi(line); //1.3 for margin

	input_file.getline(line, LINEMAX);//skip verbose
	line_counter++;

	if (!(root_array = (node**)malloc(X*Y*Z*sizeof(node*)))){
		cout << "No mem!!" << endl;
		exit(-1);
	}
	for (int i = 0; i < X*Y*Z; ++i)
		root_array[i] = NULL;

	while (!input_file.eof()){
		input_file.getline(line,LINEMAX);
		line_counter++;
		
		if (line[0] == 'S'){ // the souce node of a tree
			xyz cur_xyz = extract_node_from_line(line);
			//create a new node as root
			cur_root_x = cur_xyz.x;
			cur_root_y = cur_xyz.y;
			cur_root_z = cur_xyz.z;
			current_node_id = cur_root_x*Y*Z + cur_root_y*Z + cur_root_z;
			root_tmp = new node(cur_root_x, cur_root_y, cur_root_z, INIT_WEIGHT);// the initial root
			root_array[current_node_id] = root_tmp;
		}
		else if (line[0] == '{'){
			xyz cur_xyz = extract_node_from_line(line);//this will be a new father node 
			int weight = extract_weight_from_line(line);
			if (weight == 256){ //current father node is the root node
				child_idx = 0;
				current_node = root_tmp;
				continue;
			}
			else{//otherwise
				current_node = BFS_find_node(root_tmp, cur_xyz);
				child_idx = 0;
				if (!current_node){
					cout << "something is wrong with reduction.txt about (" << cur_xyz.x << "," << cur_xyz.y << "," << cur_xyz.z << ")" << endl;
					cout << "current link is " << line_counter << endl;
				}
					
				continue;
			}			
		}
		else if (line[0] == 'd'){
			xyz cur_xyz = extract_node_from_line(line);//this will be a new child node of current node
			int weight = extract_weight_from_line(line);
			node* new_node = new node(cur_xyz.x, cur_xyz.y, cur_xyz.z, weight);
			new_node->parent = current_node;
			new_node->depth = current_node->depth + 1;
			child_idx = current_node->num_children;
			current_node->children[child_idx] = new_node;
			current_node->num_children++;
			child_idx++;

		}
		else if (line[0] == '}'){
			continue;
		}	
	}
	input_file.close();


	return root_array;
	
}

int node_idx_convert(float coord, float c, int num_cell_per_dim, float dim_size){
	coord = coord + dim_size/2;
	if (coord <= 0)
		return 0;
	else if (coord >= dim_size)
		return num_cell_per_dim-1;
	else{
		if ((int)(coord / c))
		return (int)(coord / c);
	}
}

void read_xyz(char *filename){
	ifstream input_file;
	input_file.open(filename);
	int line_idx=0;
	char line[LINEMAX];
	float type;
	float x;
	float y;
	float z;
	int node_x;
	int node_y;
	int node_z; 
	int x_box;
	int y_box;
	int z_box;
	
	int* xyz_array_ptr; // array, each item corresponds to the empty position in each node xyz list
	if (!(xyz_array_ptr = (int*)malloc(X*Y*Z*sizeof(int)))){
		cout << "no mem for xyz_array_ptr" << endl;
		exit(-1);
	}
	for (int i = 0; i < X*Y*Z; i++){
		xyz_array_ptr[i] = 0;
	}
	if (!(xyz_list = (payload**)malloc(X*Y*Z*sizeof(payload*)))){
		cout << "no mem for xyz_list!!" << endl;
		exit(-1);
	}
	for (int i = 0; i < X*Y*Z; i++){
		if (!(xyz_list[i] = (payload*)malloc(particle_per_cell*sizeof(payload)))){
			cout << "no mem for xyz_list i!!" << endl;
			exit(-1);
		}
		for (int j = 0; j < particle_per_cell; j++){
			xyz_list[i][j].valid = false;
		}
	}
	if (input_file.fail()){
		float c = r / r2c;
		int halfintc = floor(c/2);
		float xoffset;//the x coordinates of center of whole space minus the x coordinates of the current cell
		float yoffset;//the y coordinates of the center of the whole space minus the y coordnates of the current cell
		float zoffset;//the z coordinates of the center of the whole space minus the z coordnates of the current cell
		char syn_filename[100] = "C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/syn_xyz.txt";
		ofstream fout;
		fout.open(syn_filename);
		srand(time(NULL));
		cout << "Open xyz file failed" << endl;
		cout << " generating synthetic benchmark " << endl;
		//X is the number of boxes in x dimension, Y is the number of boxes in y dimension, Z is the number of the boxed in z dimensions
		particle_per_box = (int)(particle_per_cell) / (r2c*r2c*r2c);
		for (int i = 0; i < X; i++){
			for (int j = 0; j < Y; j++){
				for (int k = 0; k < Z; k++){
					for (int count = 0; count < particle_per_box; count++){

						xoffset = (X*c / 2 - c / 2);
						yoffset = (Y*c / 2 - c / 2);
						zoffset = (Z*c / 2 - c / 2);
						x = (rand() % halfintc)*((rand() % 2 == 1) ? -1 : 1) + xoffset;
						y = (rand() % halfintc)*((rand() % 2 == 1) ? -1 : 1) + yoffset;
						z = (rand() % halfintc)*((rand() % 2 == 1) ? -1 : 1) + zoffset;
						type = 32;
						int id = i*Y*Z + j*Z + k;
						xyz_list[id][xyz_array_ptr[id]].type = 0;
						xyz_list[id][xyz_array_ptr[id]].x = x;
						xyz_list[id][xyz_array_ptr[id]].y = y;
						xyz_list[id][xyz_array_ptr[id]].z = z;
						xyz_list[id][xyz_array_ptr[id]].valid = true;
						xyz_array_ptr[id]++;
						fout << type << endl;
						fout << x << endl;
						fout << y << endl;
						fout << z << endl;
					}
				}
			}
		}
		return;
		
	}
	else
		cout << "Open xyz file successfully" << endl;
	
	
	while (!input_file.eof()){
		line_idx += 4;
		input_file.getline(line, LINEMAX);
		type = atof(line);
		input_file.getline(line, LINEMAX);
		x = atof(line);
		input_file.getline(line, LINEMAX);
		y = atof(line);
		input_file.getline(line, LINEMAX);
		z = atof(line);
		node_x = node_idx_convert(x, r / r2c, X, xsize);
		node_y = node_idx_convert(y, r / r2c, Y, ysize);
		node_z = node_idx_convert(z, r / r2c, Z, zsize);
		int id = node_x*Y*Z + node_y*Z + node_z;
		if (xyz_array_ptr[id] < particle_per_box){
			xyz_list[id][xyz_array_ptr[id]].type = 0;
			xyz_list[id][xyz_array_ptr[id]].x = x;
			xyz_list[id][xyz_array_ptr[id]].y = y;
			xyz_list[id][xyz_array_ptr[id]].z = z;
			xyz_list[id][xyz_array_ptr[id]].valid = true;
			xyz_array_ptr[node_x*Y*Z + node_y*Z + node_z]++;
		}
	}

	cout << line_idx / 4 << "particles has been read \n" << endl;
	input_file.close();



}

//the ID mapping on the ring is shown below
//     +x     +y     -y
//     ||     ||     ||
//     3------2------1
//     |              \
//     |               \
//     |                0==local
//     |               /
//     |              /
//     4------5------6
//     ||     ||     ||
//     -x     +z     -z

int cmp_nodes_relative_pos(node* src, node* dst){
	// if return -1, means src and dst are not valid
	//return which port of src is connected to the dst
	if (src->x == dst->x){
		if (src->y == dst->y){
			if (src->z == dst->z){
				return -1;
			}
			else if ((src->z >= Z) || (src->z < 0) || (dst->z >= Z) || (dst->z < 0)){
				return -1;
			}
			else if ((src->z == Z - 1 && dst->z == 0) || (src->z + 1 == dst->z)){//ZPOS
				return ZPOS;
			}
			else if ((src->z == 0 && dst->z == Z - 1) || (src->z == dst->z + 1)){//ZNEG
				return ZNEG;
			}
			else
				return -1;
		}
		else if (src->z != dst->z){
			return -1;
		}
		else if ((src->y >= Y) || (src->y < 0) || (dst->y >= Y) || (dst->y < 0)){
			return -1;
		}
		else if ((src->y == Y - 1 && dst->y == 0) || (src->y + 1 == dst->y)){//YPOS
			return YPOS;
		}
		else if ((src->y == 0 && dst->y == Y - 1) || (src->y == dst->y + 1)){//YNEG
			return YNEG;
		}
		else{
			return -1;
		}
	}
	else if (src->y != dst->y || src->z != dst->z){
		return -1;
	}
	else if ((src->x >= X) || (src->x < 0) || (dst->x >= X) || (dst->x < 0)){
		return -1;
	}
	else if ((src->x == X - 1 && dst->x == 0) || (src->x + 1 == dst->x)){//XPOS
		return XPOS;
	}
	else if ((src->x == 0 && dst->x == X - 1) || (src->x == dst->x + 1)){//XNEG
		return XNEG;
	}
	else{
		return -1;
	}

}

int reverse_port(int in){
	if (in == XPOS){
		return XNEG;
	}
	else if (in == XNEG)
		return XPOS;
	else if (in == YPOS){
		return YNEG;
	}
	else if (in == YNEG)
		return YPOS;
	else if (in == ZPOS)
		return ZNEG;
	else if (in == ZNEG)
		return ZPOS;
	else
		return -1;
}



void BFS_write_table_multicast(node* root, payload xyz){//write the table based on the 
	if (root == NULL)
		return;//this should not happen
	else if (mode == 1){
		queue<node*> Q;
		node* tmp = root;
		int routing_table_entry_index;
		int multicast_table_entry_index;
		struct routing_table_entry RoutingTableEntry;
		struct routing_table_entry_lite RoutingTableEntryLite;
		int current_port;
		Q.push(tmp);
		while (!Q.empty()){
			tmp = Q.front();
			Q.pop();
			struct multicast_table_entry MulticastTableEntry;
			struct multicast_table_entry_lite MulticastTableEntryLite;
			if (tmp->num_children == 0){
				//this is singlecast packet to local
				current_port = cmp_nodes_relative_pos(tmp, tmp->parent);
				RoutingTableEntry.packet_type = SINGLECASTPCKT;
				RoutingTableEntry.dst = LOCAL;
				RoutingTableEntry.priority = (unsigned)(tmp->weight) >> 3;
				RoutingTableEntry.next_table_index = 0;//dont care value
				sprintf(RoutingTableEntryLite.table_entry, "%08x", (RoutingTableEntry.packet_type << 28) + (RoutingTableEntry.dst << 24) + (RoutingTableEntry.next_table_index << 8) + RoutingTableEntry.priority);
				routing_table_entry_index = global_routing_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table_ptr[current_port]++;
				global_routing_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table[current_port][routing_table_entry_index] = RoutingTableEntryLite;
			}
			/*			else if (tmp->num_children == 1){
							//we need two singlecast packets here
							//one goes to next level, one goes to local
							if (tmp == root){
							current_port = LOCAL;
							}
							else{
							current_port = cmp_nodes_relative_pos(tmp, tmp->parent);
							}
							//first packet
							RoutingTableEntry.packet_type = SINGLECASTPCKT;
							RoutingTableEntry.dst = LOCAL;
							RoutingTableEntry.priority = 1;// this is the least siginificant packet because it is almost there
							RoutingTableEntry.next_table_index = 0;//dont care value
							sprintf(RoutingTableEntry.table_entry, "%8x", (RoutingTableEntry.packet_type << 28) + (RoutingTableEntry.dst << 24) + (RoutingTableEntry.next_table_index << 8) + RoutingTableEntry.priority);
							routing_table_entry_index = global_routing_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table_ptr[current_port]++;
							global_routing_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table[current_port][routing_table_entry_index] = RoutingTableEntry;

							//second packet
							//only need to write the routing table
							RoutingTableEntry.packet_type = SINGLECASTPCKT;
							RoutingTableEntry.dst = cmp_nodes_relative_pos(tmp, tmp->children[0]);
							tmp->children[0]->incoming_port_num = reverse_port(RoutingTableEntry.dst);
							RoutingTableEntry.priority = tmp->weight >> 3;
							RoutingTableEntry.next_table_index = global_routing_table_array[tmp->children[0]->x*Y*Z + tmp->children[0]->y*Z + tmp->children[0]->z].table_ptr[tmp->children[0]->incoming_port_num];
							sprintf(RoutingTableEntry.table_entry, "%8x", (RoutingTableEntry.packet_type << 28) + (RoutingTableEntry.dst << 24) + (RoutingTableEntry.next_table_index << 8) + RoutingTableEntry.priority);
							routing_table_entry_index = global_routing_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table_ptr[current_port]++;
							global_routing_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table[current_port][routing_table_entry_index] = RoutingTableEntry;

							}*/
			else{
				//we need one singlecast packet one multicast packet here
				if (tmp == root){
					current_port = LOCAL;
				
					//record the data_to_send for current root
					/*
					*|255      |254          | 253--246    |245--238     |237--230     |229--222        |221--218   |217--210     |209--202     |201--194     |193--186            |185--152|151-----144|143-----128|127--96|95--64|63--32|31--0|
					*|valid bit|reduction bit|z of src node|y of src node|x of src onde|src id of packet|packet type|z of dst node|y of dst node|x of dst node|dst id of the packet|unused  |log  weight|table index|type   |z     |y     |x    |
					*/

					for (int i = 0; i < particle_per_box; i++){
						int root_id = root->x*Y*Z + root->y*Z + root->z;
						if (xyz_list[root_id][i].valid){
							sprintf(data_to_send[root_id][data_to_send_ptr[root_id]].hex_val, "%08x%08x%08x%08x%08x%08x%08x%08x",
								(1 << 31) + (tmp->z << 22) + (tmp->y << 14) + (tmp->x << 6) + ((i & 0xfc)>>2),
								((i & 0x3) << 30) + (9 << 26),//dst x y z are dont care values
								0,
								(1<<23) + (global_routing_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table_ptr[current_port] & 0xffff),//logweight is 128 at the root 1<<(7+16)
								xyz_list[root_id][i].type, xyz_list[root_id][i].z, xyz_list[root_id][i].y, xyz_list[root_id][i].x);
							
							data_to_send_ptr[root_id]++;
							
						}
					}
				}
				else{
					current_port = cmp_nodes_relative_pos(tmp, tmp->parent);
				}
				//write the routing table first, then multicast table
				RoutingTableEntry.packet_type = MULTICASTPCKT;
				RoutingTableEntry.dst = 0;//do not care value
				RoutingTableEntry.next_table_index = global_multicast_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table_ptr[current_port];
				RoutingTableEntry.priority =(unsigned)(tmp->weight) >> 3;
				sprintf(RoutingTableEntryLite.table_entry, "%08x", (RoutingTableEntry.packet_type << 28) + (RoutingTableEntry.dst << 24) + (RoutingTableEntry.next_table_index << 8) + RoutingTableEntry.priority);
				routing_table_entry_index = global_routing_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table_ptr[current_port]++;
				global_routing_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table[current_port][routing_table_entry_index] = RoutingTableEntryLite;
				//then the multicast table
				MulticastTableEntry.downstream_num = tmp->num_children;
				for (int i = 0; i < MAX_NUM_CHILDREN; i++){
					if (i < tmp->num_children){
						MulticastTableEntry.downstream_dst[i] = cmp_nodes_relative_pos(tmp, tmp->children[i]);
						tmp->children[i]->incoming_port_num = reverse_port(RoutingTableEntry.dst);
						MulticastTableEntry.downstream_table_index[i] = global_routing_table_array[tmp->children[i]->x*Y*Z + tmp->children[i]->y*Z + tmp->children[i]->z].table_ptr[cmp_nodes_relative_pos(tmp->children[i], tmp)];
					}
					else{
						MulticastTableEntry.downstream_dst[i] = 0;
						MulticastTableEntry.downstream_table_index[i] = 0;
					}
				}

				sprintf(MulticastTableEntryLite.table_entry, "%07x%08x%08x%08x",
					(int)(((MulticastTableEntry.downstream_num & 0x7) << 24) + ((MulticastTableEntry.downstream_dst[5] & 0xf)<<20)+ ((MulticastTableEntry.downstream_table_index[5] & 0xffff) << 4) + MulticastTableEntry.downstream_dst[4]),
					(int)(((MulticastTableEntry.downstream_table_index[4] & 0xffff) << 16) + ((MulticastTableEntry.downstream_dst[3] & 0xf) << 12) + ((MulticastTableEntry.downstream_table_index[3] & 0xfff0)>>4)),
					(int)(((MulticastTableEntry.downstream_table_index[3] & 0xf) << 28) + ((MulticastTableEntry.downstream_dst[2] & 0xf) << 24) + ((MulticastTableEntry.downstream_table_index[2] & 0xffff) << 8) + ((MulticastTableEntry.downstream_dst[1] & 0xf) << 4) + ((unsigned)(MulticastTableEntry.downstream_table_index[1]) >> 12)),
					(int)((MulticastTableEntry.downstream_table_index[1] & 0xfff) << 20) + ((MulticastTableEntry.downstream_dst[0] & 0xf) << 16) + MulticastTableEntry.downstream_table_index[0]);
				multicast_table_entry_index = global_multicast_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table_ptr[current_port]++;
				global_multicast_table_array[tmp->x*Y*Z + tmp->y*Z + tmp->z].table[current_port][multicast_table_entry_index] = MulticastTableEntryLite;
			}

			for (int i = 0; i < tmp->num_children; i++){
				Q.push(tmp->children[i]);
			}
		}
	}
}
void BFS_write_table_reduction(node* root, payload xyz,int dst_id){//dst id is the id of the reduction id on the root
	if (root == NULL)
		return;//this should not happen
	else if (mode == 2){ //reduction mode
		//build a link list array that can bottom-up traverse the tree, each link list is for each level
		link_list_node* depth[MAX_TREE_DEPTH];
		link_list_node* new_link_list_node;
		link_list_node* node_link_list_iterator;
		int routing_table_entry_index;
		int reduction_table_entry_index;
		struct routing_table_entry RoutingTableEntry;
		struct routing_table_entry_lite RoutingTableEntryLite;
		struct reduction_table_entry ReductionTableEntry;
		struct reduction_table_entry_lite ReductionTableEntryLite;
		int current_port;
		int current_depth;
		int last_depth = 0;
		for (int i = 0; i < MAX_TREE_DEPTH; i++){
			depth[i] = NULL;
		}
		//first BFS to trerse the tree and then store each level in corresponding depth[i]
		node* tmp = root;
		queue<node*> Q;
		Q.push(tmp);
		while (!Q.empty()){
			tmp = Q.front();
			Q.pop();
			if (!(new_link_list_node = (link_list_node*)malloc(sizeof(new_link_list_node)))){
				cout << "no mem for new_link_list_node!!" << endl;
				exit(-1);
			}
			new_link_list_node->NODE = tmp;
			new_link_list_node->next = NULL;
			current_depth = tmp->depth;
			if (current_depth > last_depth)
				last_depth = current_depth;
			if (depth[current_depth] == NULL){//if head is null, then it is new head
				depth[current_depth] = new_link_list_node;
			}
			else{//if header is not null, insert it as head
				new_link_list_node->next = depth[current_depth];
				depth[current_depth] = new_link_list_node;
			}
			for (int i = 0; i < tmp->num_children; i++){
				Q.push(tmp->children[i]);
			}
		}
		for (int i = last_depth; i >= 0; i--){
			for (node_link_list_iterator = depth[i]; node_link_list_iterator; node_link_list_iterator = node_link_list_iterator->next){
				if (node_link_list_iterator->NODE->num_children==0){
					//record the data to be sent for current node
					routing_table_entry_index = global_routing_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table_ptr[LOCAL];
					int leaf_id = node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z;
					sprintf(data_to_send[leaf_id][data_to_send_ptr[leaf_id]].hex_val, "%08x%08x%08x%08x%08x%08x%08x%08x",\
						(1 << 31) + (node_link_list_iterator->NODE->z << 22) + (node_link_list_iterator->NODE->y << 14) + (node_link_list_iterator->NODE->z << 6) + ((routing_table_entry_index & 0xfc) >> 2),\
						((routing_table_entry_index & 0x3) << 30) + (0xa << 26) + ((root->z) << 18) + ((root->y) << 10) + ((root->z) << 2) + ((unsigned)dst_id >> 6),\
						((dst_id & 0x3f) << 26),\
						(1 << 16) + (routing_table_entry_index & 0xffff),\
						xyz.type, xyz.z, xyz.y, xyz.x);
					data_to_send_ptr[leaf_id]++;
					//first create the routing table
					RoutingTableEntry.packet_type = SINGLECASTPCKT;
					RoutingTableEntry.dst = cmp_nodes_relative_pos(node_link_list_iterator->NODE, node_link_list_iterator->NODE->parent);
					RoutingTableEntry.priority =(unsigned)(node_link_list_iterator->NODE->weight) >> 3;
					RoutingTableEntry.next_table_index = global_routing_table_array[node_link_list_iterator->NODE->parent->x*Y*Z + node_link_list_iterator->NODE->parent->y*Z + node_link_list_iterator->NODE->parent->z].table_ptr[reverse_port(RoutingTableEntry.dst)];
					sprintf(RoutingTableEntryLite.table_entry, "%08x", (RoutingTableEntry.packet_type << 28) + (RoutingTableEntry.dst << 24) + (RoutingTableEntry.next_table_index << 8) + RoutingTableEntry.priority);
					//then write the entry to the table
					global_routing_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table_ptr[LOCAL]++;
					global_routing_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table[LOCAL][routing_table_entry_index] = RoutingTableEntryLite;
				}
				else{
					//two packet, first is the local reduction packet that will enter the tree if it is not root
					if (i != 0){
						//record the data to be sent for current node
						current_port = LOCAL;
						routing_table_entry_index = global_routing_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table_ptr[current_port];
						int id = node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z;
						sprintf(data_to_send[id][data_to_send_ptr[id]].hex_val, "%08x%08x%08x%08x%08x%08x%08x%08x", \
							(3 << 30) + (node_link_list_iterator->NODE->z << 22) + (node_link_list_iterator->NODE->y << 14) + (node_link_list_iterator->NODE->z << 6) + ((routing_table_entry_index & 0xfc) >> 2), \
							((routing_table_entry_index & 0x3) << 30) + (0xa << 26) + ((root->z) << 18) + ((root->y) << 10) + ((root->z) << 2) + ((unsigned)dst_id >> 6), \
							((dst_id & 0x3f) << 26), \
							(1 << 16) + (routing_table_entry_index & 0xffff), \
							xyz.type, xyz.z, xyz.y, xyz.x);
						data_to_send_ptr[id]++;
						//then create the routing table
						RoutingTableEntry.packet_type = REDUCTIONPCKT;
						RoutingTableEntry.dst = cmp_nodes_relative_pos(node_link_list_iterator->NODE, node_link_list_iterator->NODE->parent);
						RoutingTableEntry.priority = (unsigned)(node_link_list_iterator->NODE->weight) >> 3;
						RoutingTableEntry.next_table_index = global_reduction_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table_ptr[RoutingTableEntry.dst];
						sprintf(RoutingTableEntryLite.table_entry, "%08x", (RoutingTableEntry.packet_type << 28) + (RoutingTableEntry.dst << 24) + (RoutingTableEntry.next_table_index << 8) + RoutingTableEntry.priority);
						//write the enntry to the table
						global_routing_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table_ptr[current_port]++;
						global_routing_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table[current_port][routing_table_entry_index] = RoutingTableEntryLite;
					}
					//first write the routing table for up to five incoming downstream children
					for (int j = 0; j < node_link_list_iterator->NODE->num_children; j++){ // next table is reduction table on the exit port
						//create the routing table entry first
						RoutingTableEntry.packet_type = REDUCTIONPCKT;
						if (i != 0)
							RoutingTableEntry.dst = cmp_nodes_relative_pos(node_link_list_iterator->NODE, node_link_list_iterator->NODE->parent);
						else
							RoutingTableEntry.dst = LOCAL;
						RoutingTableEntry.priority = (unsigned)(node_link_list_iterator->NODE->weight) >> 3;
						RoutingTableEntry.next_table_index = global_reduction_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table_ptr[RoutingTableEntry.dst];
						sprintf(RoutingTableEntryLite.table_entry, "%08x", (RoutingTableEntry.packet_type << 28) + (RoutingTableEntry.dst << 24) + (RoutingTableEntry.next_table_index << 8) + RoutingTableEntry.priority);
						//then write the entry to the table
						current_port = cmp_nodes_relative_pos(node_link_list_iterator->NODE, node_link_list_iterator->NODE->children[j]);
						routing_table_entry_index = global_routing_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table_ptr[current_port]++;
						global_routing_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table[current_port][routing_table_entry_index] = RoutingTableEntryLite;
					}
					//then create the reduction table entry
					
					if (i != 0){
						ReductionTableEntry.downstream_expect_num = node_link_list_iterator->NODE->num_children + 1;//children plus itself
						ReductionTableEntry.upstream_dst = cmp_nodes_relative_pos(node_link_list_iterator->NODE->parent, node_link_list_iterator->NODE);
						ReductionTableEntry.upstream_table_index = global_routing_table_array[node_link_list_iterator->NODE->parent->x*Y*Z + node_link_list_iterator->NODE->parent->y*Z + node_link_list_iterator->NODE->parent->z].table_ptr[ReductionTableEntry.upstream_dst];
						sprintf(ReductionTableEntryLite.table_entry, "%03x%08x%08x%08x%08x%08x", ((unsigned)(ReductionTableEntry.downstream_expect_num & 0x6) >> 1), ((ReductionTableEntry.downstream_expect_num & 0x1) << 31) + (ReductionTableEntry.upstream_dst << 24) + (ReductionTableEntry.upstream_table_index << 8), 0, 0, 0, 0);
						//then write the entry to the reduction table
						current_port = cmp_nodes_relative_pos(node_link_list_iterator->NODE, node_link_list_iterator->NODE->parent);

					}
					else{
						ReductionTableEntry.downstream_expect_num = node_link_list_iterator->NODE->num_children;
						ReductionTableEntry.upstream_dst = LOCAL;
						ReductionTableEntry.upstream_table_index = 0;//dont care
						sprintf(ReductionTableEntryLite.table_entry, "%03x%08x%08x%08x%08x%08x", ((unsigned)(ReductionTableEntry.downstream_expect_num & 0x6) >> 1), ((ReductionTableEntry.downstream_expect_num & 0x1) << 31) + (ReductionTableEntry.upstream_dst << 24) + (ReductionTableEntry.upstream_table_index << 8), 0, 0, 0, 0);
						current_port = LOCAL;
					}
					reduction_table_entry_index = global_reduction_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table_ptr[current_port]++;
					global_reduction_table_array[node_link_list_iterator->NODE->x*Y*Z + node_link_list_iterator->NODE->y*Z + node_link_list_iterator->NODE->z].table[current_port][reduction_table_entry_index] = ReductionTableEntryLite;
				}
			}
		}
	}

}

void write_path_to_table_forward(link_list_node* path){
	link_list_node* node_ptr = path;
	int current_port;
	struct routing_table_entry RoutingTableEntry;
	struct routing_table_entry_lite RoutingTableEntryLite;
	int routing_table_entry_index;
	//write the data_to_send first
	link_list_node* src = path;
	link_list_node* dst = path;
	if (path == NULL || path->next == NULL)
		return;
	// write the routing table
	while (node_ptr){
		RoutingTableEntry.packet_type = SINGLECASTPCKT;
		if (node_ptr->next == NULL){
			RoutingTableEntry.dst = LOCAL;
			RoutingTableEntry.next_table_index = 0;//dont care value
			RoutingTableEntry.priority = 1;
		}
		else{
			RoutingTableEntry.dst = cmp_nodes_relative_pos(node_ptr->NODE, node_ptr->next->NODE);
			RoutingTableEntry.next_table_index = global_routing_table_array[node_ptr->next->NODE->x*Y*Z + node_ptr->next->NODE->y*Z + node_ptr->next->NODE->z].table_ptr[reverse_port(RoutingTableEntry.dst)];
			RoutingTableEntry.priority = (unsigned)(node_ptr->NODE->weight)>>3;
			node_ptr->next->NODE->incoming_port_num = cmp_nodes_relative_pos(node_ptr->next->NODE,node_ptr->NODE);
		}
		sprintf(RoutingTableEntryLite.table_entry, "%08x", (RoutingTableEntry.packet_type << 28) + (RoutingTableEntry.dst << 24) + (RoutingTableEntry.next_table_index << 8) + RoutingTableEntry.priority);
		if (node_ptr == path){//this is root
			current_port = LOCAL;
		}
		else{
			//current_port = cmp_nodes_relative_pos(node_ptr->NODE, node_ptr->NODE->parent);
			current_port = node_ptr->NODE->incoming_port_num;
		}
		routing_table_entry_index = global_routing_table_array[node_ptr->NODE->x*Y*Z + node_ptr->NODE->y*Z + node_ptr->NODE->z].table_ptr[current_port]++;
		
		global_routing_table_array[node_ptr->NODE->x*Y*Z + node_ptr->NODE->y*Z + node_ptr->NODE->z].table[current_port][routing_table_entry_index] = RoutingTableEntryLite;
		node_ptr = node_ptr->next;
	}
}
void write_path_to_table_reverse(link_list_node* path){
	//create a revese link_list of path
	link_list_node* node_ptr = path;
	link_list_node* reverse_path;
	link_list_node* new_reverse_node;
	link_list_node* to_be_deleted;

	while (node_ptr){

		if (node_ptr == path){
			if (!(reverse_path = (link_list_node*)malloc(sizeof(link_list_node)))){
				cout << "No mem for reverse path!!";
				exit(-1);
			}
			reverse_path->NODE = node_ptr->NODE;
			reverse_path->next = NULL;
		}
		else{
			if (!(new_reverse_node = (link_list_node*)malloc(sizeof(link_list_node)))){
				cout << "No mem for new_reverse_node!!";
				exit(-1);
			}
			new_reverse_node->NODE = node_ptr->NODE;
			new_reverse_node->next = reverse_path;
			reverse_path = new_reverse_node;
		}
		node_ptr = node_ptr->next;
	}
	write_path_to_table_forward(reverse_path);
	node_ptr = reverse_path;
	while (node_ptr){
		to_be_deleted = node_ptr;
		node_ptr = node_ptr->next;
		free(to_be_deleted);
	}
	
}



void DFS_write_table(node* Node, node* root, link_list_node* path, int mode){
	link_list_node* new_path_node;
	link_list_node* node_ptr;
	if (!(new_path_node = (link_list_node*)malloc(sizeof(link_list_node)))){
		cout << "no mem for new_path_node!!!" << endl;
		exit(-1);
	}
	new_path_node->next = NULL;
	new_path_node->NODE = Node;
	//add the node to tail of the path
	new_path_node->NODE = Node;
	node_ptr = path;
	if (path == NULL){
		path = new_path_node;
		node_ptr = new_path_node;
	}
	else{
		while (node_ptr->next){
			node_ptr = node_ptr->next; // find the last node in the path
		}

		node_ptr->next = new_path_node;
	}
	if (path->next != NULL){
		//if root, then do not need 
		if (mode == 3)
			write_path_to_table_forward(path);
		else if (mode == 4)
			write_path_to_table_reverse(path);
	}
	if (Node->num_children == 0){
		//this node is leave		
		//remove the last node;
		node_ptr->next = NULL;
		free(new_path_node);
	}
	else{
		for (int i = 0; i < Node->num_children; i++){
			DFS_write_table(Node->children[i], root, path, mode);
		}
		node_ptr->next = NULL;
		free(new_path_node);
	}
	
}

void table_gen(node** tree_array){
	node* cur_tree;
	payload* cur_xyzlist;
	if (mode == 1){
		for (int i = 0; i < X*Y*Z; i++){
			cur_tree = tree_array[i];
			cur_xyzlist = xyz_list[i];
			BFS_write_table_multicast(cur_tree, cur_xyzlist[0]);
		}
	}
	else if (mode == 2){
		for (int j = 0; j < particle_per_box; j++){
			for (int i = 0; i < X*Y*Z; i++){
				cur_tree = tree_array[i];
				cur_xyzlist = xyz_list[i];
	
				BFS_write_table_reduction(cur_tree, cur_xyzlist[j], j);
			}
		}
	}
	else if (mode == 3){
		for (int i = 0; i < X*Y*Z; i++){
			cur_tree = tree_array[i];
			cur_xyzlist = xyz_list[i];
			DFS_write_table(cur_tree, cur_tree, NULL, mode);
			for (int j = 0; j < particle_per_box; j++){
				int root_id = cur_tree->x*Y*Z + cur_tree->y*Z + cur_tree->z;
				if (xyz_list[root_id][j].valid){
					sprintf(data_to_send[root_id][data_to_send_ptr[root_id]].hex_val, "%08x%08x%08x%08x%08x%08x%08x%08x",
						(1 << 31) + (cur_tree->z << 22) + (cur_tree->y << 14) + (cur_tree->x << 6) + ((j & 0xfc) >> 2),
						((j & 0x3) << 30) + (8 << 26),//dst x y z are dont care values
						0,
						(1 << 23) + (global_routing_table_array[cur_tree->x*Y*Z + cur_tree->y*Z + cur_tree->z].table_ptr[LOCAL] & 0xffff),//logweight is 128 at the root 1<<(7+8)  the table ptr is dont care value here
						xyz_list[root_id][j].type, xyz_list[root_id][j].z, xyz_list[root_id][j].y, xyz_list[root_id][j].x);
					data_to_send_ptr[root_id]++;

				}
			}
		}
	}
	else if (mode == 4){
		for (int i = 0; i < X*Y*Z; i++){
			cur_tree = tree_array[i];
			cur_xyzlist = xyz_list[i];
			DFS_write_table(cur_tree, cur_tree, NULL, mode);
			for (int j = 0; j < particle_per_box; j++){
				int root_id = cur_tree->x*Y*Z + cur_tree->y*Z + cur_tree->z;
				if (xyz_list[root_id][j].valid){
					sprintf(data_to_send[root_id][data_to_send_ptr[root_id]].hex_val, "%08x%08x%08x%08x%08x%08x%08x%08x",
						(1 << 31) + (cur_tree->z << 22) + (cur_tree->y << 14) + (cur_tree->x << 6) + ((j & 0xfc) >> 2),
						((j & 0x3) << 30) + (8 << 26),//dst x y z are dont care values
						0,
						(1 << 23) + (global_routing_table_array[cur_tree->x*Y*Z + cur_tree->y*Z + cur_tree->z].table_ptr[LOCAL] & 0xffff),//logweight is 128 at the root 1<<(7+8)  the table ptr is dont care value here
						xyz_list[root_id][j].type, xyz_list[root_id][j].z, xyz_list[root_id][j].y, xyz_list[root_id][j].x);
					data_to_send_ptr[root_id]++;

				}
			}
		}
	}


	/*
	for (int i = 0; i < X*Y*Z; i++){
		cur_tree = tree_array[i];
		cur_xyzlist = xyz_list[i];
		if (mode == 1){
			BFS_write_table_multicast(cur_tree, cur_xyzlist[0]);
		}
		else if (mode == 2){
			for (int j = 0; j < particle_per_box; j++){
				BFS_write_table_reduction(cur_tree, cur_xyzlist[j],j);
			}
		}
		else if (mode == 3){
			DFS_write_table(cur_tree, cur_tree, NULL, mode);
			for (int j = 0; j < particle_per_box; j++){
				int root_id = cur_tree->x*Y*Z + cur_tree->y*Z + cur_tree->z;
				if (xyz_list[root_id][j].valid){
					sprintf(data_to_send[root_id][data_to_send_ptr[root_id]].hex_val, "%08x%08x%08x%08x%08x%08x%08x%08x",
						(1 << 31) + (cur_tree->z << 22) + (cur_tree->y << 14) + (cur_tree->x << 6) + ((j & 0xfc) >> 2),
						((j & 0x3) << 30) + (8 << 26),//dst x y z are dont care values
						0,
						(1 << 23) + (global_routing_table_array[cur_tree->x*Y*Z + cur_tree->y*Z + cur_tree->z].table_ptr[LOCAL] & 0xffff),//logweight is 128 at the root 1<<(7+8)  the table ptr is dont care value here
						xyz_list[root_id][j].type, xyz_list[root_id][j].z, xyz_list[root_id][j].y, xyz_list[root_id][j].x);
					data_to_send_ptr[root_id]++;

				}
			}
		}

		else if (mode == 4){
			DFS_write_table(cur_tree, cur_tree, NULL, mode);
			for (int j = 0; j < particle_per_box; j++){
				int root_id = cur_tree->x*Y*Z + cur_tree->y*Z + cur_tree->z;
				if (xyz_list[root_id][j].valid){
					sprintf(data_to_send[root_id][data_to_send_ptr[root_id]].hex_val, "%08x%08x%08x%08x%08x%08x%08x%08x",
						(1 << 31) + (cur_tree->z << 22) + (cur_tree->y << 14) + (cur_tree->x << 6) + ((j & 0xfc) >> 2),
						((j & 0x3) << 30) + (8 << 26),//dst x y z are dont care values
						0,
						(1 << 23) + (global_routing_table_array[cur_tree->x*Y*Z + cur_tree->y*Z + cur_tree->z].table_ptr[LOCAL] & 0xffff),//logweight is 128 at the root 1<<(7+8)  the table ptr is dont care value here
						xyz_list[root_id][j].type, xyz_list[root_id][j].z, xyz_list[root_id][j].y, xyz_list[root_id][j].x);
					data_to_send_ptr[root_id]++;

				}
			}
		}

	}*/
}

void print_xyz(){
	string path = "C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/input_data/";
	string data_to_send_common = "data_to_send_";
	string suffix = ".txt";
	string filename;
	ofstream fout;
	int imax;
	for (int x = 0; x < X; x++){
		for (int y = 0; y < Y; y++){
			for (int z = 0; z < Z; z++){
				filename = path + data_to_send_common + to_string(x) + "_" + to_string(y) + "_" + to_string(z) + suffix;
				fout.open(filename);
				if (mode == 2){
					imax = ROUTING_TABLE_SIZE;
				}
				else{
					imax = particle_per_box;
				}
				for (int i = 0; i< imax ; i++){
					if (i < data_to_send_ptr[x*Y*Z + y*Z + z])
						fout << data_to_send[x*Y*Z + y*Z + z][i].hex_val << endl;
					else
						fout << "0000000000000000000000000000000000000000000000000000000000000000" << endl;
				}
				fout.close();
			}
		}
	}
	
}

void print_tables(){
	string path = "C:/Users/Jiayi/Documents/GitHub/MD_reduction_data/tables/";
	string routing_table_file_common = "routing_table_";
	string multicast_table_file_common = "multicast_table_";
	string reduction_table_file_common = "reduction_table_";
	string port_name[7] = { "LOCAL", "YNEG", "YPOS", "XPOS", "XNEG", "ZPOS", "ZNEG" };
	string suffix = ".txt";
	ofstream fout;
	string filename;
	int largest_single_routing_table_size=0;
	int largest_single_multicast_table_size = 0;
	int largest_single_reduction_table_size = 0;

	int largest_total_routing_table_size = 0;
	int largest_total_multicast_table_size = 0;
	int largest_total_reduction_table_size = 0;

	int cur_total_routing_table_size = 0;
	int cur_total_multicast_table_size = 0;
	int cur_total_reduction_table_size = 0;



	//write the routing table
	for (int x = 0; x < X; x++){
		for (int y = 0; y < Y; y++){
			for (int z = 0; z < Z; z++){
				cur_total_routing_table_size = 0;
				cur_total_multicast_table_size = 0;
				cur_total_reduction_table_size = 0;
				for (int i = 0; i < 7; i++){
					cur_total_routing_table_size += global_routing_table_array[x*Y*Z + y*Z + z].table_ptr[i];
					cur_total_multicast_table_size += global_multicast_table_array[x*Y*Z + y*Z + z].table_ptr[i];
					cur_total_reduction_table_size += global_reduction_table_array[x*Y*Z + y*Z + z].table_ptr[i];
					filename = path + routing_table_file_common + to_string(x) + "_" + to_string(y) + "_" + to_string(z) + "_" + port_name[i] + suffix;			
					fout.open(filename);
					for (int j = 0; j < ROUTING_TABLE_SIZE; j++){
						if (j < global_routing_table_array[x*Y*Z + y*Z + z].table_ptr[i])
							fout << global_routing_table_array[x*Y*Z + y*Z + z].table[i][j].table_entry << endl;
						else
							fout << "00000000" << endl;
					}
					if (largest_single_routing_table_size < global_routing_table_array[x*Y*Z + y*Z + z].table_ptr[i])
						largest_single_routing_table_size = global_routing_table_array[x*Y*Z + y*Z + z].table_ptr[i];
					fout.close();
					filename = path  + multicast_table_file_common + to_string(x) + "_" + to_string(y) + "_" + to_string(z) + "_" + port_name[i] + suffix;
					fout.open(filename);
					for (int j = 0; j <MULTICAST_TABLE_SIZE; j++){
						if (j < global_multicast_table_array[x*Y*Z + y*Z + z].table_ptr[i])
							fout << global_multicast_table_array[x*Y*Z + y*Z + z].table[i][j].table_entry << endl;
						else
							fout << "00000000000000000000000000" << endl;
					}
					if (largest_single_multicast_table_size < global_multicast_table_array[x*Y*Z + y*Z + z].table_ptr[i])
						largest_single_multicast_table_size = global_multicast_table_array[x*Y*Z + y*Z + z].table_ptr[i];
					fout.close();
					filename = path + reduction_table_file_common + to_string(x) + "_" + to_string(y) + "_" + to_string(z) + "_" + port_name[i] + suffix;
					fout.open(filename);
					for (int j = 0; j < REDUCTION_TABLE_SIZE; j++){
						if (j < global_reduction_table_array[x*Y*Z + y*Z + z].table_ptr[i])
							fout << global_reduction_table_array[x*Y*Z + y*Z + z].table[i][j].table_entry << endl;
						else
							fout << "0" << endl;
					}
					if (largest_single_reduction_table_size < global_reduction_table_array[x*Y*Z + y*Z + z].table_ptr[i])
						largest_single_reduction_table_size = global_reduction_table_array[x*Y*Z + y*Z + z].table_ptr[i];
					fout.close();
				}

				if (cur_total_multicast_table_size>largest_total_multicast_table_size)
					largest_total_multicast_table_size = cur_total_multicast_table_size;
				if (cur_total_reduction_table_size > largest_total_reduction_table_size)
					largest_total_reduction_table_size = cur_total_reduction_table_size;
				if (cur_total_routing_table_size > largest_total_routing_table_size)
					largest_total_routing_table_size = cur_total_routing_table_size;

			}
		}
		
	}
	cout << "Largest routing table size is " << largest_single_routing_table_size <<endl;
	cout << "Largest multicast table size is " << largest_single_multicast_table_size <<endl;
	cout << "Largest reduction table size is" << largest_single_reduction_table_size<<endl;
	cout << "Largest total routing table size is " << largest_total_routing_table_size<<endl;
	cout << "Largest total multicast table size is " << largest_total_multicast_table_size<<endl;
	cout << "Largest total reduction table size is" << largest_total_reduction_table_size<<endl;

	
}

int main(int argc, char* argv[]){
	char filename[] = "C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/reduction_tree.txt";
	long size =10000000000;
	if (!(global_routing_table_array = (struct routing_table*)malloc(X*Y*Z*sizeof(routing_table)))){
		cout << "no mem for global_routing_table_array!!" << size << "bytes" << endl;
		cout << "error code is" << GetLastError() << endl; 
		exit(-1);
	}
	if (!(global_multicast_table_array = (struct multicast_table*)VirtualAlloc(NULL, X*Y*Z*sizeof(multicast_table), MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE))){
		cout << "no mem for global_multicast_table_array!!" << endl;
		exit(-1);
	}
	if (!(global_reduction_table_array = (struct reduction_table*)VirtualAlloc(NULL, X*Y*Z*sizeof(reduction_table), MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE))){
		cout << "no mem for global_reduction_table_array!!" << endl;
		exit(-1);
	}
	node** tree_array = read_reduction_tree(filename);

	if (!(data_to_send = (data256**)malloc(X*Y*Z*sizeof(data256*)))){
		cout << "no mem of the data_send**" << endl;
		exit(-1);
	}
	if (mode == 1 || mode == 3 || mode == 4){
		for (int i = 0; i < X*Y*Z; i++){
			if (!(data_to_send[i] = (data256*)malloc(particle_per_box*sizeof(data256)))){
				cout << "no mem for data_send* " << i << endl;
				exit(-1);
			}
		}
	}
	else if (mode == 2){
		for (int i = 0; i < X*Y*Z; i++){
			if (!(data_to_send[i] = (data256*)malloc(ROUTING_TABLE_SIZE*sizeof(data256)))){
				cout << "no mem for data_send* " << i << endl;
				exit(-1);
			}
		}
	}
	if (!(data_to_send_ptr = (int*)malloc(X*Y*Z*sizeof(int)))){
		cout << "no mem for data_to_send_ptr" << endl;
		exit(-1);
	}
	for (int i = 0; i < X*Y*Z; i++){
		data_to_send_ptr[i] = 0;
	}


	//initital tables


	for (int i = 0; i < X*Y*Z; i++){
		for (int j = 0; j < 7; j++){
			global_routing_table_array[i].table_ptr[j] = 0;
			global_multicast_table_array[i].table_ptr[j] = 0;
			global_reduction_table_array[i].table_ptr[j] = 0;
		}
	}
	char xyz_file[] = "C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/xyz.txt";
	read_xyz(xyz_file);
	table_gen(tree_array);
	print_tables();
	print_xyz();
	
	
	






	return 0;
}