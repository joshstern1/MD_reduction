/***********************************************************************
* CAAD,BU
* All-to-all broadcast tree generator
* Qingqing X, 02/29/2016
* Step1: set X, Y ,Z (number of boxes on each dimension)
* **********************************************************************/

#include <iostream>
#include <stdlib.h>
#include <vector>
#include "assert.h"
#include <math.h>
#include <limits>
#include <boost/bind.hpp>
#include <algorithm>
#include <string>
#include <fstream>
#include <queue>

using namespace std;

#define X 5
#define Y 5
#define Z 5
/*
#define SRC_X 0
#define SRC_Y 0
#define SRC_Z 0
*/
#define DEBUG 0

/***********************************
* data structure for output file
***********************************/
struct pattern{
	int src_x;
	int src_y;
	int src_z;
	int dst_x;
	int dst_y;
	int dst_z;
	int weight;
	pattern(int a, int b, int c, int d, int e, int f, int g) :
		src_x(a), src_y(b), src_z(c), dst_x(d), dst_y(e), dst_z(f), weight(g) {}
};

int weight_a(int x_dst, int y_dst, int z_dst, int x, int y, int z){
	int diff = abs(x_dst - x) + abs(y_dst - y) + abs(z_dst - z);
	if (diff == 0) {
		return 256;
	}
	else {
		return 256 - diff;
	}
}

/***********************************
* translate coords for corner cases
***********************************/
int trans(int src, int cell){
	if ((src < 0) || (src >= cell)){
		return ((src + cell) % cell);
	}
	else return src;
}

vector<pattern> gen_dst_for_src(int src_x, int src_y, int src_z, int x, int y, int z){
	//calc the x, y ,z bondary of the torus
	//odd, equal 
	//even, neg side has one less
	int x_neg_bound = (x / 2)*(-1), x_pos_bound = x / 2;
	int y_neg_bound = (y / 2)*(-1), y_pos_bound = y / 2;
	int z_neg_bound = (z / 2)*(-1), z_pos_bound = z / 2;

	if (x % 2 == 0) {
		x_neg_bound = (x / 2 - 1)*(-1);
	}
	if (y % 2 == 0) {
		y_neg_bound = (y / 2 - 1)*(-1);
	}
	if (z % 2 == 0) {
		z_neg_bound = (z / 2 - 1)*(-1);
	}
		
	vector<pattern> pat;

	for (int c = z_neg_bound; c <= z_pos_bound; c++){
		for (int b = y_neg_bound; b <= y_pos_bound; b++){
			for (int a = x_neg_bound; a <= x_pos_bound; a++){

				//check if the nodes are the corner nodes of the cube
				if(((c == z_neg_bound)||(c == z_pos_bound))&&((b == y_neg_bound)||(b == y_pos_bound))&&((a == x_neg_bound)||(a == x_pos_bound))){
					continue;
				}
				//the center node, to five directions except the north
				else if (c == 0 && b == 0 && a == 0){
					pat.push_back(pattern(src_x, src_y, src_z, trans(src_x + 1, x), src_y, src_z, 255));//F
					pat.push_back(pattern(src_x, src_y, src_z, src_x, trans(src_y + 1, y), src_z, 255));//E
					pat.push_back(pattern(src_x, src_y, src_z, trans(src_x - 1, x), src_y, src_z, 255));//B
					pat.push_back(pattern(src_x, src_y, src_z, src_x, trans(src_y - 1, y), src_z, 255));//W
					pat.push_back(pattern(src_x, src_y, src_z, src_y, src_z, trans(src_z - 1, z), 255));//S
				}
				//the west of the z=z+1 level
				else if (c == 1 && (b == -1) && a == 0){
					pat.push_back(pattern(src_x, trans(src_y - 1, Y), trans(src_z + 1, Z), src_x, trans(src_y - 1, Y), trans(src_z + 2, Z), 253));//N
					pat.push_back(pattern(src_x, trans(src_y - 1, Y), trans(src_z + 1, Z), src_x, trans(src_y - 2, Y), trans(src_z + 2, Z), 253));//W
					pat.push_back(pattern(src_x, trans(src_y - 1, Y), trans(src_z + 1, Z), trans(src_x + 1, X), trans(src_y - 1, Y), trans(src_z + 2, Z), 253));//F
					pat.push_back(pattern(src_x, trans(src_y - 1, Y), trans(src_z + 1, Z), src_x, src_y, trans(src_z + 1, Z), 253));//E!!!!!!!
				}
				//Layer z==z, W
				else if (c >= 0 && b == -1 && a == 0){
					pat.push_back(pattern(src_x, trans(src_y - 1, Y), trans(src_z + c, Z), trans(src_x + 1, X), trans(src_y - 1, Y), trans(src_z + c, Z), 254));//F
					pat.push_back(pattern(src_x, trans(src_y - 1, Y), trans(src_z + c, Z), src_x, trans(src_y - 2, Y), trans(src_z + c, Z), 254));//W
					pat.push_back(pattern(src_x, trans(src_y - 1, Y), trans(src_z + c, Z), src_x, trans(src_y - 1, Y), trans(src_z + c + 1, Z), 254));//N
				}
				//layer z==z, B
				else if (c >= 0 && b == 0 && a == -1){
					pat.push_back(pattern(trans(src_x - 1, X), src_y, trans(src_z + c, Z), trans(src_x - 2, X), src_y, trans(src_z + c, Z), 254));//B
					pat.push_back(pattern(trans(src_x - 1, X), src_y, trans(src_z + c, Z), trans(src_x - 1, X), trans(src_y - 1, Y), trans(src_z + c, Z), 254));//W
					pat.push_back(pattern(trans(src_x - 1, X), src_y, trans(src_z + c, Z), trans(src_x - 1, X), src_y, trans(src_z + c - 1, Z), 254));//S
				}
				//layer z==z, E
				else if (c <= 0 && b == 1 && a == 0){
					pat.push_back(pattern(src_x, trans(src_y + 1, Y), trans(src_z + c, Z), src_x, trans(src_y + 1, Y), trans(src_z + c, Z), 254));//B
					pat.push_back(pattern(src_x, trans(src_y + 1, Y), trans(src_z + c, Z), src_x, trans(src_y + 2, Y), trans(src_z + c, Z), 254));//E
					pat.push_back(pattern(src_x, trans(src_y + 1, Y), trans(src_z + c, Z), src_x, trans(src_y + 1, Y), trans(src_z + c - 1, Z), 254));//S
				}
				//layer z==z, F
				else if (c <= 0 && b == 0 && a == -1){
					pat.push_back(pattern(trans(src_x + 1, X), src_y, trans(src_z + c, Z), trans(src_x + 2, X), src_y, trans(src_z + c, Z), 254));//F
					pat.push_back(pattern(trans(src_x + 1, X), src_y, trans(src_z + c, Z), trans(src_x + 1, X), trans(src_y + 1, Y), trans(src_z + c, Z), 254));//E
					pat.push_back(pattern(trans(src_x + 1, X), src_y, trans(src_z + c, Z), trans(src_x + 1, X), src_y, trans(src_z + c - 1, Z), 254));//S
				}
				//nodes in the B plane
				else if (b == 0 && a < 0){
					pat.push_back(pattern(trans(src_x + a, X), src_y, trans(src_z + c, Z), trans(src_x + a - 1, X), src_y, trans(src_z + c, Z), weight_a(src_x + a - 1, src_y, trans(src_z + c, Z), src_x, src_y, src_z)));//B
					pat.push_back(pattern(trans(src_x + a, X), src_y, trans(src_z + c, Z), trans(src_x + a, X), trans(src_y - 1, Y), trans(src_z + c, Z), weight_a(src_x + a, src_y - 1, trans(src_z + c, Z), src_x, src_y, src_z)));//W
				}
				//nodes in the F plane
				else if (b == 0 && a > 0){
					pat.push_back(pattern(trans(src_x + a, X), src_y, trans(src_z + c, Z), trans(src_x + a + 1, X), src_y, trans(src_z + c, Z), weight_a(src_x + a + 1, src_y, trans(src_z + c, Z), src_x, src_y, src_z)));//F
					pat.push_back(pattern(trans(src_x + a, X), src_y, trans(src_z + c, Z), trans(src_x + a, X), trans(src_y + 1, Y), trans(src_z + c, Z), weight_a(src_x + a, src_y + 1, trans(src_z + c, Z), src_x, src_y, src_z)));//E
				}
				//nodes in the W plane
				else if (b < 0 && a == 0){
					pat.push_back(pattern(src_x, trans(src_y + b, Y), trans(src_z + c, Z), trans(src_x + 1, X), trans(src_y + b, Y), trans(src_z + c, Z), weight_a(src_x + 1, src_y + b, trans(src_z + c, Z), src_x, src_y, src_z)));//F
					pat.push_back(pattern(src_x, trans(src_y + b, Y), trans(src_z + c, Z), src_x, trans(src_y + b - 1, Y), trans(src_z + c, Z), weight_a(src_x, src_y + b - 1, trans(src_z + c, Z), src_x, src_y, src_z)));//W
				}
				//nodes in the E plane
				else if (b > 0 && a == 0){
					pat.push_back(pattern(src_x, trans(src_y + b, Y), trans(src_z + c, Z), trans(src_x - 1, X), trans(src_y + b, Y), trans(src_z + c, Z), weight_a(src_x - 1, src_y + b, trans(src_z + c, Z), src_x, src_y, src_z)));//B
					pat.push_back(pattern(src_x, trans(src_y + b, Y), trans(src_z + c, Z), src_x, trans(src_y + b + 1, Y), trans(src_z + c, Z), weight_a(src_x, src_y + b + 1, trans(src_z + c, Z), src_x, src_y, src_z)));//E
				}
				//nodes in the  northwestern quarter of the ball
				else if (b <= 0 && a <= 0){
					pat.push_back(pattern(trans(src_x + a, X), trans(src_y + b, Y), trans(src_z + c, Z), trans(src_x + a, X), trans(src_y + b - 1, Y), trans(src_z + c, Z), weight_a(src_x + a, src_y + b - 1, trans(src_z + c, Z), src_x, src_y, src_z)));//W
				}
				//nodes in the  southwestern quarter of the ball
				else if (b <= 0 && a > 0){
					pat.push_back(pattern(trans(src_x + a, X), trans(src_y + b, Y), trans(src_z + c, Z), trans(src_x + a + 1, X), trans(src_y + b, Y), trans(src_z + c, Z), weight_a(src_x + a + 1, src_y + b, trans(src_z + c, Z), src_x, src_y, src_z)));//F
				}
				//nodes in the  southeastern quarter of the ball
				else if (b > 0 && a > 0){
					pat.push_back(pattern(trans(src_x + a, X), trans(src_y + b, Y), trans(src_z + c, Z), trans(src_x + a, X), trans(src_y + b + 1, Y), trans(src_z + c, Z), weight_a(src_x + a, src_y + b + 1, trans(src_z + c, Z), src_x, src_y, src_z)));//W
				}
				//nodes in the  northeastern quarter of the ball
				else if (b > 0 && a < 0){
					pat.push_back(pattern(trans(src_x + a, X), trans(src_y + b, Y), trans(src_z + c, Z), trans(src_x + a - 1, X), trans(src_y + b, Y), trans(src_z + c, Z), weight_a(src_x + a - 1, src_y + b, trans(src_z + c, Z), src_x, src_y, src_z)));//F
				}
				else{
					cout << "the node is not in the torus\n";
					exit(EXIT_FAILURE);
				}
			}
		}
	}

	return pat;

}

int main(){
	//ABORT when the torus is too small
	ofstream output;
	output.open("A_2_A_tree.txt");

	if (X < 3 || Y < 3 || Z < 3){

		cout << "The torus size is too small for this all-to-all algorithm";
		exit(EXIT_FAILURE);
	}
	vector<pattern> x;
	


	//iterate through all the nodes in the space
	//generate the broadcast tree for that node
	// the pattern is the same for every source node
	//generate one according to the X,Y,X
	for (int src_z = 0; src_z < Z; src_z++){
		for (int src_y = 0; src_y < Y; src_y++){
			for (int src_x = 0; src_x < X; src_x++){

				output << "Tree for source: " << src_x << ", " << src_y << ", " << src_z << endl;
				vector<pattern> one_tree = gen_dst_for_src(src_x, src_y, src_z, X, Y, Z);
				vector<pattern> result;
				//reorder
				
				int level = 255;
				while(level > 220){
					for (vector<pattern>::iterator it = one_tree.begin(); it != one_tree.end(); ++it){
						if(it->weight == level){
							result.push_back(*it);
						}
						
					}
					level--;
				}


				for (vector<pattern>::iterator it = result.begin(); it != result.end(); ++it){
					output << "src: (" << it->src_x << "," << it->src_y << "," << it->src_z << ")\n";
					output << "          dst: (" << it->dst_x << "," << it->dst_y << "," << it->dst_z << ")  ";
					output << "weight: " << it->weight << "\n";
				}
			}
		}
	}
	output.close();
	return 1;


}
