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

using namespace std;

#define X 4
#define Y 4
#define Z 4

//define the root node to do broadcast to
#define root_x	1
#define root_y	1
#define root_z  2

/*
#define SRC_X 0
#define SRC_Y 0
#define SRC_Z 0
*/
#define DEBUG 0

/***********************************
* data structure for output file
***********************************/

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

int zone_8_9(coord root, coord d){
	if ((root.x == d.x) && (root.y == d.y)){
		int half_dist = Y / 2;
		if (((d.z - root.z) <= half_dist) && ((d.z - root.z) > 0)){

			return 8;
		}
		else{
			return 9;
		}
	}
	else{
		return -1;
	}
}
int zone_3_7(coord root, coord d){

	if (root.y == d.y){
		int half_dist = X / 2;
		if (((d.x - root.x) <= half_dist) && ((d.x - root.x) > 0)){

			return 7;
		}
		else if (((root.x - d.x) <= half_dist) && ((root.x - d.x) > 0)){

			return 3;
		}
		return -1;
	}
	else{
		return -1;
	}
}

int zone_1_5(coord root, coord d){

	if (root.x == d.x){
		int half_dist = Y / 2;
		if (((d.y - root.y) <= half_dist) && ((d.y - root.y) > 0)){

			return 1;
		}
		else if (((root.y - d.y) <= half_dist) && ((root.y - d.y) > 0)){

			return 5;
		}
		return -1;
	}
	else{
		return -1;
	}
}

int zone_0_6(coord root, coord d){

	int half_dist_x = X / 2, half_dist_y = Y / 2;
	if (((d.x - root.x) <= half_dist_x) && ((d.x - root.x) > 0)){
		if (((d.y - root.y) <= half_dist_y) && ((d.y - root.y) > 0)){
			return 0;
		}
		else if (((root.y - d.y) <= half_dist_y) && ((root.y - d.y) > 0)){
			return 6;
		}
		return -1;
	}
	else{
		return -1;
	}
}

int zone_2_4(coord root, coord d){

	int half_dist_x = X / 2, half_dist_y = Y / 2;
	if (((root.x - d.x) <= half_dist_x) && ((root.x - d.x) > 0)){
		if (((d.y - root.y) <= half_dist_y) && ((d.y - root.y) > 0)){
			return 2;
		}
		else if (((root.y - d.y) <= half_dist_y) && ((root.y - d.y) > 0)){
			return 4;
		}
		return -1;
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
		return 257;
	}
	else {
		return 257 - diff;
	}
}

void gen_pattern(coord root, vector<coord> dest, vector<pattern> & result){

	coord RT(root_x, root_y, root_z);
	vector<coord> dest_new;
	
	if (dest.size() == 1){
		if (itself(root, *(dest.begin()))){
			return;
		}		
	}
	
	for (vector<coord>::iterator it = dest.begin(); it != dest.end(); ++it){

		if (itself(root, *it)){
			/*
			dest.erase(it);
			if (dest.size() == 0){
				break;
			}
			*/
			//continue
				;
		}
		//to up

		else if (zone_8_9(root, *it) == 8){
			result.push_back(pattern(coord(root.x, root.y, root.z), coord(root.x, root.y, root.z + 1), weight(RT, coord(root.x, root.y, root.z + 1))));
			for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
				if (zone_8_9(root, *itt) == 8){
					dest_new.push_back(*itt);
				}
			}
			gen_pattern(coord(root.x, root.y, root.z + 1), dest_new, result);
			//continue;
			
		}
		//to down
		else if (zone_8_9(root, *it) == 9){
			result.push_back(pattern(coord(root.x, root.y, root.z), coord(root.x, root.y, root.z - 1), weight(RT, coord(root.x, root.y, root.z - 1))));
			for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
				if (zone_8_9(root, *itt) == 9){
					dest_new.push_back(*itt);
				}
			}
			gen_pattern(coord(root.x, root.y, root.z - 1), dest_new, result);
			//continue;
		}
		//to east
		else if (((zone_3_7(root, *it) == 7) || (zone_0_6(root, *it) == 6)) && (zone_1_5(root, *it) != 5) && (zone_2_4(root, *it) != 4)){
			result.push_back(pattern(coord(root.x, root.y, root.z), coord(root.x + 1, root.y, root.z), weight(RT, coord(root.x + 1, root.y, root.z))));
			for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
				if (((zone_3_7(root, *itt) == 7) || (zone_0_6(root, *itt) == 6)) && (zone_1_5(root, *itt) != 5) && (zone_2_4(root, *itt) != 4)){
					dest_new.push_back(*itt);
				}
			}
			gen_pattern(coord(root.x + 1, root.y, root.z), dest_new, result);
			//continue;
		}
		//to north
		else if ((zone_1_5(root, *it) == 1) || ((zone_0_6(root, *it) == 0) && ((zone_3_7(root, *it) != 7) &&
			(zone_0_6(root, *it) != 6))) || ((zone_0_6(root, *it) == 0) && (zone_2_4(root, *it) == 2))) {
			result.push_back(pattern(coord(root.x, root.y, root.z), coord(root.x, root.y + 1, root.z), weight(RT, coord(root.x, root.y + 1, root.z))));
			for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
				if ((zone_1_5(root, *itt) == 1) || ((zone_0_6(root, *itt) == 0) && ((zone_3_7(root, *itt) != 7) &&
					(zone_0_6(root, *itt) != 6))) || ((zone_0_6(root, *itt) == 0) && (zone_2_4(root, *itt) == 2))){
					dest_new.push_back(*itt);
				}
			}
			gen_pattern(coord(root.x, root.y + 1, root.z), dest_new, result);
			//continue;
		}
		//to west
		else if (((zone_3_7(root, *it) == 3) || (zone_2_4(root, *it) == 2)) && (zone_1_5(root, *it) != 1) && (zone_0_6(root, *it) != 0)){
			result.push_back(pattern(coord(root.x, root.y, root.z), coord(root.x - 1, root.y, root.z), weight(RT, coord(root.x - 1, root.y, root.z))));
			for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
				if (((zone_3_7(root, *itt) == 3) || (zone_2_4(root, *itt) == 2)) && (zone_1_5(root, *itt) != 1) && (zone_0_6(root, *itt) != 0)){
					dest_new.push_back(*itt);
				}
			}
			gen_pattern(coord(root.x - 1, root.y, root.z), dest_new, result);
			//continue;
		}
		//south 
		else if ((zone_1_5(root, *it) == 5) || ((zone_2_4(root, *it) == 4) && ((zone_3_7(root, *it) != 3)  &&
			(zone_2_4(root, *it) != 4))) || ((zone_2_4(root, *it) == 4) && (zone_0_6(root, *it) == 6))) {
			result.push_back(pattern(coord(root.x, root.y, root.z), coord(root.x, root.y - 1, root.z), weight(RT, coord(root.x, root.y - 1, root.z))));
			for (vector<coord>::iterator itt = dest.begin(); itt != dest.end(); ++itt){
				if ((zone_1_5(root, *itt) == 5) || ((zone_2_4(root, *itt) == 4) && ((zone_3_7(root, *itt) != 3)  &&
					(zone_2_4(root, *itt) != 4))) || ((zone_2_4(root, *itt) == 4) && (zone_0_6(root, *itt) == 6))) {
					dest_new.push_back(*itt);
				}
			}
			gen_pattern(coord(root.x, root.y - 1, root.z), dest_new, result);
			//continue;
		}

		//neeeeeeeeeeed to delete all the nodes that can be covered by the selected ports 
		//JIAYI: pls delete all the nodes in dest_new from current dest vector
		if (dest_new.size() != 0){
			coord * current;
			coord * itt = it;
			for (current = dest_new.begin(); current != dest_new.end(); ++current){
				if (itself(*current, *itt)){
					while ((dest.size() != 0){


					}
				}
				

			}
			
			while((dest.size() != 0) &&()){
				coord *it_inner = dest.begin();
				if (itself(*current, *it_inner)){
					dest.erase(it_inner);
					dest_new.erase(current);
				}

			}
			current = next(current);
		}
			

	}
	return;
}


int main() {

	//violated definations 

	ifstream inputfile("destinations.txt");
	string line;
	vector<coord> dest;	//stores all the destinations
	vector<pattern> result;
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


	//start generating pattern
	coord root_0(root_x, root_y, root_z);
	gen_pattern(root_0, dest, result);
	
	for (vector<pattern>::iterator it = result.begin(); it != result.end(); ++it){

		coord src = it->source;
		coord dst = it->dest;
		int	  wt = it->weight;
		cout << src.x << ", " << src.y << ", " << src.z << "   DST:";
		cout << dst.x << ", " << dst.y << ", " << dst.z << "   WEIGHT:";
		cout << wt << endl;
	}

	

	return 1;
}
