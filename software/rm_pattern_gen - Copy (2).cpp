/***********************************************************************
* CAAD,BU
* All-to-all broadcast tree generator
* Qingqing X, 03/16/2016
* Step1: set X, Y ,Z (number of nodes on each dimension)
* **********************************************************************/

#include <iostream>
#include <stdlib.h>
#include <vector>
#include "assert.h"
#include <math.h>
#include <limits>
//#include <boost/bind.hpp>
#include <algorithm>
#include <string>
#include <fstream>
#include <queue>
#include <iterator>

using namespace std;

#define X 4
#define Y 4
#define Z 4

//define the root node to do broadcast to
int root_x;
int root_y;
int root_z;

//define all to all or bc to a set of nodes
#define A_TO_A 1



/*
#define SRC_X 0
#define SRC_Y 0
#define SRC_Z 0
*/
#define DEBUG 0


#define LINEMAX 200
/***********************************
* data structure for output file
***********************************/




struct src_dst_list{
	int x;
	int y;
	int z;
	bool valid;
	bool src_or_dst;//true is src, false is dst
	src_dst_list* next;
};


struct xyz{
	int x;
	int y;
	int z;
};
struct coord{

	int x;
	int y;
	int z;
	coord(int a, int b, int c) :
		x(a), y(b), z(c){}

};
struct pattern{
	coord source;
	coord dest;
	int   weight;
	pattern(coord source, coord dest, int weight) :
		source(source), dest(dest), weight(weight){}
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
coord trans(coord a);
int zone_8_9(coord root_old, coord d_old){
	//tune the relative coordinate
	int x, y, z;

	int half_dist_x = X / 2, half_dist_y = Y / 2, half_dist = Z / 2;

	if (X % 2 == 0){
		x = half_dist_x - 1;
	}
	else{
		x = half_dist_x;
	}
	if (Y % 2 == 0){
		y = half_dist_y - 1;
	}
	else{
		y = half_dist_y;
	}
	if (Z % 2 == 0){
		z = half_dist - 1;
	}
	else{
		z = half_dist;
	}

	coord root(x, y, z);
	int dif_x = x - root_old.x;
	int dif_y = y - root_old.y;
	int dif_z = z - root_old.z;

	coord d_o(d_old.x + dif_x, d_old.y + dif_y, d_old.z + dif_z);
	coord d = trans(d_o);

	//if ((root.x == d.x) && (root.y == d.y)){
	//int half_dist = Z / 2;
	if (root.z != d.z){
		if (((root.z >= half_dist) && (Z % 2 == 0)) || ((root.z > half_dist) && (Z % 2 == 1))){
			if ((((d.z - root.z) <= half_dist) && ((d.z - root.z) > 0))
				|| ((((root.z - d.z) > half_dist) && (Z % 2 == 1)) || (((root.z - d.z) >= half_dist) && (Z % 2 == 0)))){
				return 8;
			}
			else
				return 9;
		}
		else{
			if (((d.z - root.z) <= half_dist) && ((d.z - root.z) > 0)){

				return 8;
			}
			else if (((root.z - d.z) <= half_dist) && ((d.z - root.z) < 0)){
				return 9;
			}
		}
	}
	else{
		return -1;
	}
	return -1;
}
int zone_3_7(coord root_old, coord d_old){
	//tune the relative coordinate
	int x, y, z;

	int half_dist_x = X / 2, half_dist_y = Y / 2, half_dist_z = Z / 2;

	if (X % 2 == 0){
		x = half_dist_x - 1;
	}
	else{
		x = half_dist_x;
	}
	if (Y % 2 == 0){
		y = half_dist_y - 1;
	}
	else{
		y = half_dist_y;
	}
	if (Z % 2 == 0){
		z = half_dist_z - 1;
	}
	else{
		z = half_dist_z;
	}

	coord root(x, y, z);
	int dif_x = x - root_old.x;
	int dif_y = y - root_old.y;
	int dif_z = z - root_old.z;

	coord d_o(d_old.x + dif_x, d_old.y + dif_y, d_old.z + dif_z);
	coord d = trans(d_o);

	if ((root.y == d.y) && (root.z == d.z)){
		int half_dist = X / 2;
		//zone 7
		if (((root.x >= half_dist) && (X % 2 == 0)) || ((root.x > half_dist) && (X % 2 == 1))){
			if ((((d.x - root.x) <= half_dist) && ((d.x - root.x) > 0))
				|| ((((root.x - d.x) > half_dist) && (X % 2 == 1)) || (((root.x - d.x) >= half_dist) && (X % 2 == 0)))){
				return 7;
			}
			else
				return 3;
		}
		else {
			if (((d.x - root.x) <= half_dist) && ((d.x - root.x) > 0)) {

				return 7;
			}
			else{

				return 3;
			}
		}
	}
	else{
		return -1;
	}
}

int zone_1_5(coord root_old, coord d_old){
	//tune the relative coordinate
	int x, y, z;

	int half_dist_x = X / 2, half_dist_y = Y / 2, half_dist_z = Z / 2;

	if (X % 2 == 0){
		x = half_dist_x - 1;
	}
	else{
		x = half_dist_x;
	}
	if (Y % 2 == 0){
		y = half_dist_y - 1;
	}
	else{
		y = half_dist_y;
	}
	if (Z % 2 == 0){
		z = half_dist_z - 1;
	}
	else{
		z = half_dist_z;
	}

	coord root(x, y, z);
	int dif_x = x - root_old.x;
	int dif_y = y - root_old.y;
	int dif_z = z - root_old.z;

	coord d_o(d_old.x + dif_x, d_old.y + dif_y, d_old.z + dif_z);
	coord d = trans(d_o);
	if ((root.x == d.x) && (root.z == d.z)){
		int half_dist = Y / 2;
		if (((root.y >= half_dist) && (Y % 2 == 0)) || ((root.y > half_dist) && (Y % 2 == 1))){
			if ((((d.y - root.y) <= half_dist) && ((d.y - root.y) > 0))
				|| ((((root.y - d.y) > half_dist) && (Y % 2 == 1)) || (((root.y - d.y) >= half_dist) && (Y % 2 == 0)))){
				return 1;
			}
			else
				return 5;
		}
		else {
			if (((d.y - root.y) <= half_dist) && ((d.y - root.y) > 0)) {

				return 1;
			}
			else{

				return 5;
			}
		}
	}
	else{
		return -1;
	}
}

int zone_0_6(coord root_old, coord d_old){
	//tune the relative coordinate
	int x, y, z;

	int half_dist_x = X / 2, half_dist_y = Y / 2, half_dist_z = Z / 2;

	if (X % 2 == 0){
		x = half_dist_x - 1;
	}
	else{
		x = half_dist_x;
	}
	if (Y % 2 == 0){
		y = half_dist_y - 1;
	}
	else{
		y = half_dist_y;
	}
	if (Z % 2 == 0){
		z = half_dist_z - 1;
	}
	else{
		z = half_dist_z;
	}

	coord root(x, y, z);
	int dif_x = x - root_old.x;
	int dif_y = y - root_old.y;
	int dif_z = z - root_old.z;

	coord d_o(d_old.x + dif_x, d_old.y + dif_y, d_old.z + dif_z);
	coord d = trans(d_o);

	if ((root.z == d.z) && (root.y != d.y)){

		if (((root.x >= half_dist_x) && (X % 2 == 0)) || ((root.x > half_dist_x) && (X % 2 == 1))){
			if ((((d.x - root.x) <= half_dist_x) && ((d.x - root.x) > 0))
				|| ((((root.x - d.x) > half_dist_x) && (X % 2 == 1)) || (((root.x - d.x) >= half_dist_x) && (X % 2 == 0)))){

				if (((root.y >= half_dist_y) && (Y % 2 == 0)) || ((root.y > half_dist_y) && (Y % 2 == 1))){
					if ((((d.y - root.y) <= half_dist_y) && ((d.y - root.y) > 0))
						|| ((((root.y - d.y) > half_dist_y) && (Y % 2 == 1)) || (((root.y - d.y) >= half_dist_y) && (Y % 2 == 0)))){

						return 0;
					}
					else
						return 6;
				}
				else{
					if (((d.y - root.y) <= half_dist_y) && ((d.y - root.y) > 0)){
						return 0;
					}
					else
						return 6;
				}
			}
			else
				return -1;
		}
		else{

			if ((((d.x - root.x) <= half_dist_x) && ((d.x - root.x) > 0))){
				if (((root.y >= half_dist_y) && (Y % 2 == 0)) || ((root.y > half_dist_y) && (Y % 2 == 1))){
					if ((((d.y - root.y) <= half_dist_y) && ((d.y - root.y) > 0))
						|| ((((root.y - d.y) > half_dist_y) && (Y % 2 == 1)) || (((root.y - d.y) >= half_dist_y) && (Y % 2 == 0)))){
						return 0;
					}
					else
						return 6;
				}
				else{

					if (((d.y - root.y) <= half_dist_y) && ((d.y - root.y) > 0)){
						return 0;
					}
					else if (((root.y - d.y) <= half_dist_y) && ((root.y - d.y) > 0)){
						return 6;
					}
				}
			}
			else
				return -1;
		}
	}
	else{
		return -1;
	}
	return -1;
}

int zone_2_4(coord root_old, coord d_old){

	//tune the relative coordinate
	int x, y, z;

	int half_dist_x = X / 2, half_dist_y = Y / 2, half_dist_z = Z / 2;

	if (X % 2 == 0){
		x = half_dist_x - 1;
	}
	else{
		x = half_dist_x;
	}
	if (Y % 2 == 0){
		y = half_dist_y - 1;
	}
	else{
		y = half_dist_y;
	}
	if (Z % 2 == 0){
		z = half_dist_z - 1;
	}
	else{
		z = half_dist_z;
	}

	coord root(x, y, z);
	int dif_x = x - root_old.x;
	int dif_y = y - root_old.y;
	int dif_z = z - root_old.z;

	coord d_o(d_old.x + dif_x, d_old.y + dif_y, d_old.z + dif_z);
	coord d = trans(d_o);

	if ((root.z == d.z) && (root.y != d.y)){

		if ((zone_0_6(root, d) == -1) && (zone_1_5(root, d) == -1) && (zone_3_7(root, d) == -1)){
			if ((((d.y - root.y) <= half_dist_y) && ((d.y - root.y) > 0))
				|| ((((root.y - d.y) > half_dist_y) && (Y % 2 == 1)) || (((root.y - d.y) >= half_dist_y) && (Y % 2 == 0)))){
				return 2;
			}
			else
				return 4;
		}
		else{
			return -1;
		}
	}
	else{
		return -1;
	}
}

bool itself(coord root, coord d){
	return ((root.x == d.x) && (root.y == d.y) && (root.z == d.z));
}

int weight(coord source, coord dest){
	int diff = abs(dest.x - source.x) + abs(dest.y - source.y) + abs(dest.z - source.z);
	if (diff == 0) {
		return 256;
	}
	else {
		return 256/diff;
	}
}

coord trans(coord a){
	coord b(a.x, a.y, a.z);

	if ((a.x < 0) || (a.x >= X)){
		b.x = ((a.x + X) % X);
	}
	else {
		b.x = a.x;
	}
	if ((a.y < 0) || (a.y >= Y)){
		b.y = ((a.y + Y) % Y);
	}
	else {
		b.y = a.y;
	}
	if ((a.z < 0) || (a.z >= Z)){
		b.z = ((a.z + Z) % Z);
	}
	else {
		b.z = a.z;
	}

	return b;

}


vector<int> has_dst(coord rt, vector<coord> dest){

	vector<int> state;//ten zones, has dst-->1, no dsts-->0
	for (int i = 0; i< 10; i++){
		state.push_back(0);
	}
	if (dest.size() == 0){
		return state;
	}
	for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
		coord d = *itt;
		if (zone_0_6(rt, d) == 0){
			state[0] = 1;
		}
		else if (zone_0_6(rt, d) == 6){
			state[6] = 1;
		}
		else if (zone_1_5(rt, d) == 1){
			state[1] = 1;
		}
		else if (zone_1_5(rt, d) == 5){
			state[5] = 1;
		}
		else if (zone_2_4(rt, d) == 2){
			state[2] = 1;
		}
		else if (zone_2_4(rt, d) == 4){
			state[4] = 1;
		}
		else if (zone_3_7(rt, d) == 3){
			state[3] = 1;
		}
		else if (zone_3_7(rt, d) == 7){
			state[7] = 1;
		}
		else if (zone_8_9(rt, d) == 8){
			state[8] = 1;
		}
		else if (zone_8_9(rt, d) == 9){
			state[9] = 1;
		}
	}
	return state;

}

void gen_pattern_2(coord root, vector<coord> dest, vector<pattern> & result, int & count){

	coord RT(root_x, root_y, root_z);


	count--;
	if (dest.size() == 0){

		return;
	}

	if (dest.size() == 1){
		if (itself(root, *(dest.begin()))){

			return;
		}
	}
	/************************************************************new_version**************************************************************/
	vector<int> state = has_dst(root, dest);
	/*******03/28/2016**********/
	int six_belongs_to_e = 0;

	int direct[6] = { 0, 0, 0, 0, 0, 0 };

	if ((state[8]) && (root.x == root_x) && (root.y == root_y)){
		result.push_back(pattern(coord(root.x, root.y, root.z), trans(coord(root.x, root.y, root.z + 1)), count));
		direct[0] = 1;

	}
	//to down
	if ((state[9]) && (root.x == root_x) && (root.y == root_y)){
		result.push_back(pattern(coord(root.x, root.y, root.z), trans(coord(root.x, root.y, root.z - 1)), count));
		direct[1] = 1;

	}
	//to east
	if ((state[7]) || ((state[6]) && (state[5] == 0) && (state[4] == 0))){
		result.push_back(pattern(coord(root.x, root.y, root.z), trans(coord(root.x + 1, root.y, root.z)), count));
		direct[2] = 1;

	}

	//to north
	if ((state[1]) || ((state[0]) && ((state[7] == 0) || (state[4] == 0) &&
		(state[6]))) || ((state[0]) && (state[2])))  {
		result.push_back(pattern(coord(root.x, root.y, root.z), trans(coord(root.x, root.y + 1, root.z)), count));
		direct[3] = 1;

	}

	//to west
	if ((state[3]) || ((state[2]) && (state[1] == 0) && (state[0] == 0))){
		result.push_back(pattern(coord(root.x, root.y, root.z), trans(coord(root.x - 1, root.y, root.z)), count));
		direct[4] = 1;

	}


	//south
	if ((state[5]) || ((state[4]) && ((state[3] == 0) || (state[0] == 0) &&
		(state[4]))) || ((state[4]) && (state[6]))) {
		result.push_back(pattern(coord(root.x, root.y, root.z), trans(coord(root.x, root.y - 1, root.z)), count));
		direct[5] = 1;

	}


	/*candidate is chosen then add new set into dest*/
	//U
	if (direct[0]){
		vector<coord> dest_new;
		for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
			if ((zone_8_9(root, *itt) == 8) && (!itself(*itt, trans(coord(root.x, root.y, root.z + 1))))){
				dest_new.push_back(*itt);
			}
		}
		gen_pattern_2(trans(coord(root.x, root.y, root.z + 1)), dest_new, result, count);
		count++;
	}
	//D
	if (direct[1]){
		vector<coord> dest_new;
		for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
			if ((zone_8_9(root, *itt) == 9) && (!itself(*itt, trans(coord(root.x, root.y, root.z - 1))))){
				dest_new.push_back(*itt);
			}
		}
		gen_pattern_2(trans(coord(root.x, root.y, root.z - 1)), dest_new, result, count);
		count++;
	}
	//E
	if (direct[2]){
		vector<coord> dest_new;
		for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
			if (((zone_3_7(root, *itt) == 7) || (zone_0_6(root, *itt) == 6)) && (!itself(*itt, trans(coord(root.x + 1, root.y, root.z))))){
				dest_new.push_back(*itt);
			}
		}

		if (direct[3] == 0){
			for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
				if (((zone_0_6(root, *itt) == 0)) && (!itself(*itt, trans(coord(root.x + 1, root.y, root.z))))){
					dest_new.push_back(*itt);
				}
			}
		}
		gen_pattern_2(trans(coord(root.x + 1, root.y, root.z)), dest_new, result, count);
		count++;

	}
	//N
	if (direct[3]){
		vector<coord> dest_new;
		for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
			if (((zone_1_5(root, *itt) == 1) || (zone_0_6(root, *itt) == 0)) && (!itself(*itt, trans(coord(root.x, root.y + 1, root.z))))){
				dest_new.push_back(*itt);
			}
		}

		if (direct[4] == 0){
			for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
				if (((zone_2_4(root, *itt) == 2)) && (!itself(*itt, trans(coord(root.x, root.y + 1, root.z))))){
					dest_new.push_back(*itt);
				}
			}
		}
		gen_pattern_2(trans(coord(root.x, root.y + 1, root.z)), dest_new, result, count);
		count++;
	}
	//W
	if (direct[4]){
		vector<coord> dest_new;
		for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
			if (((zone_2_4(root, *itt) == 2) || (zone_3_7(root, *itt) == 3)) && (!itself(*itt, trans(coord(root.x - 1, root.y, root.z))))){
				dest_new.push_back(*itt);
			}
		}

		if (direct[5] == 0){
			for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
				if (((zone_2_4(root, *itt) == 4)) && (!itself(*itt, trans(coord(root.x, root.y + 1, root.z))))){
					dest_new.push_back(*itt);
				}
			}
		}
		gen_pattern_2(trans(coord(root.x - 1, root.y, root.z)), dest_new, result, count);
		count++;
	}
	//S
	if (direct[5]){
		vector<coord> dest_new;
		for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
			if (((zone_2_4(root, *itt) == 4) || (zone_1_5(root, *itt) == 5)) && (!itself(*itt, trans(coord(root.x, root.y - 1, root.z))))) {
				dest_new.push_back(*itt);
			}
		}

		if (direct[2] == 0){
			for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
				if (((zone_0_6(root, *itt) == 6)) && (!itself(*itt, trans(coord(root.x, root.y + 1, root.z))))){
					dest_new.push_back(*itt);
				}
			}
		}
		gen_pattern_2(trans(coord(root.x, root.y - 1, root.z)), dest_new, result, count);
		count++;
	}

	return;

}
struct greater_than_weight{
	inline bool operator()(const pattern& pattern1, const pattern& pattern2){
		return (pattern1.weight > pattern2.weight);
	}

};
int main() {

	//violated definations 
	string input_filename="C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/destination.txt";
	ofstream outputFile;
	outputFile.open("C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/reduction_tree.txt");


	outputFile<<"X"<<endl;
	outputFile<<X<<endl;
	outputFile<<"Y"<<endl;
	outputFile<<Y<<endl;
	outputFile<<"Z"<<endl;
	outputFile<<Z<<endl;
	outputFile<<"The r_to_c ratio is:"<<endl;
	outputFile<<"1"<<endl;
	outputFile<<"The number of particles of one box"<<endl;
	outputFile<<"172"<<endl;
	outputFile<<"***************************start calculation!******************************"<<endl;
	read_src_dst_file(input_filename);
	int count = 257;
	vector<pattern> result;	
	vector<coord> dest;	//stores all the destinations
/*#if A_TO_A
	for (int i = 0; i < Z; ++i){
		for (int j = 0; j < Y; ++j){
			for (int k = 0; k < X; ++k){
				if ((i == root_z) && (j == root_y) && (k == root_x)){
					continue;
				}
				else{
					dest.push_back(coord(k,j,i));
				}
			}
		}
	}


#else

	
	ifstream inputfile("destinations.txt");
	string line;

	
	if (inputfile.is_open()){


		while (getline(inputfile, line)){

			cout << line << endl;
			int a[3];
			int i = 0;
			for (string::iterator it = line.begin(); it != line.end(); ++it){

				if ((*it == '(') || (*it == ',') || (*it == ')')){
					continue;
				}
				else{
					a[i] = (int)(*it) - 48;
					i++;
				}
			}
			dest.push_back(coord(a[0], a[1], a[2]));

		}
	}
	else {

		cout << "no file~~~~~~";
	}



	inputfile.close();

#endif*/
	//start generating pattern
	int cur_root_x;
	int cur_root_y;
	int cur_root_z;
	struct src_dst_list* ptr;
	for(int i=0;i<X*Y*Z;i++){
		if(src_list[i]->valid){
			//init the dest
			result.clear();
			dest.clear();
			count=257;
			ptr=src_list[i]->next;
			while(ptr){
				if(ptr->x!=src_list[i]->x || ptr->y!=src_list[i]->y || ptr->z!=src_list[i]->z){
					dest.push_back(coord(ptr->x,ptr->y,ptr->z));
				}
				ptr=ptr->next;
			}
			root_x=src_list[i]->x;
			root_y=src_list[i]->y;
			root_z=src_list[i]->z;
			coord root_0(src_list[i]->x, src_list[i]->y, src_list[i]->z);
			gen_pattern_2(root_0, dest, result, count);

	//ofstream outfile;
	//sort(result.begin(), result.end(), greater_than_weight()); cannot use this since sort is O(nlongn) sorting algorithm
			int wt = 256;
	
			vector<pattern> result_new;
	
			while (wt > 1){
				for (vector<pattern>::iterator it = result.begin(); it != result.end(); ++it){
					if (it->weight == wt){
						result_new.push_back(*it);

					}
				}
				wt--;
			}





			int level = 256;
			pattern front = *result_new.begin();
			coord current = front.source;




			outputFile << "Start generating RM BroadCast TREE pattern for this node: (" << src_list[i]->x << "," << src_list[i]->y << "," << src_list[i]->z << "):\n\n";
	
			int fanout = 0;
			outputFile << "{";
			outputFile << "src: (" << current.x << "," << current.y << "," << current.z << ")\n";
			for (vector<pattern>::iterator it = result_new.begin(); it != result_new.end(); ++it){
				coord tmp_src = it->source;
				coord tmp_dst = it->dest;
				if (it->weight == level){
			
					if (itself(tmp_src, current)){

						outputFile << "dst: (" << tmp_dst.x << "," << tmp_dst.y << "," << tmp_dst.z << ")  ";
						outputFile << "weight: " << it->weight << "\n";
						fanout++;
					}
					else {
						if (fanout == 1) {
							outputFile << "}";
						}
						else {
							outputFile << "}";
						}
						fanout = 1;
						outputFile << "\n{";
						outputFile << "src: (" << tmp_src.x << "," << tmp_src.y << "," << tmp_src.z << ")\n";
						outputFile << "dst: (" << tmp_dst.x << "," << tmp_dst.y << "," << tmp_dst.z << ")  ";
						outputFile << "weight: " << it->weight << "\n";
						current = tmp_src;
					}

				}
				else {
					if (fanout == 1) {
						outputFile << "}";
					}
					else {
						outputFile << "}";
					}
					fanout = 1;
					outputFile << "\n{";
					outputFile << "src: (" << tmp_src.x << "," << tmp_src.y << "," << tmp_src.z << ")\n";
					outputFile << "dst: (" << tmp_dst.x << "," << tmp_dst.y << "," << tmp_dst.z << ")  ";
					outputFile << "weight: " << it->weight << "\n";
					level = it->weight;
					current = it->source;
				}

			}
			outputFile << "}\n\n";

		}
	}


	return 1;
}
