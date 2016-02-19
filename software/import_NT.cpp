/***********************************************************************
* CAAD,BU
* Qingqing X, 12/15/2015
* Step1: set X, Y ,Z (number of boxes on each dimension)
* Step2: set one of the two parameters GenPattern, GenVolumn to be 1
* Step3: if GenPattern is set, set R_2_C;
else GenVolumn is set, set three parameters SRC_X to SRC_Z to
be the box node you want to watch
* **********************************************************************/

#include <iostream>
#include <stdlib.h>
#include <vector>
#include "assert.h"
#include <math.h>
#include <limits>
#include <string>
#include <algorithm>

//#include "stdafx.h"
#include <fstream>

using namespace std;

#define X 9
#define Y 9
#define Z 7

#define SRC_X 0
#define SRC_Y 0
#define SRC_Z 0


#define NT 1	//Enable generating pattern for the Netural Territory Method
#define GenVolumn 0


#define R_2_C 1.7

class coordinates{
public:
	int cell_x;
	int cell_y;
	int cell_z;
	coordinates(int a, int b, int c, int x, int y, int z) {

		cell_x = a;

		cell_y = b;

		cell_z = c;
	}

};


int get_nbr_particles_per_box(float r_2_c){

	return (int)(172 / (pow(r_2_c, 3)));
}

vector<coordinates> get_import_sets_NT(float r_to_cell, int x, int y, int z,
	int cell_x, int cell_y, int cell_z){

	vector<coordinates> import_set;

	if ((r_to_cell < 0.0) || (r_to_cell > 4.0)){
		cout << "input ratio is out of range!";
		//return 0;

	}


	//when r_to_cell no larger than 1(return 13 cells)
	//when (z==z) plate 
	else if (r_to_cell <= 1.0){
		import_set.push_back(coordinates(cell_x - 1, cell_y - 1, cell_z, x, y, z));
		import_set.push_back(coordinates(cell_x - 1, cell_y, cell_z, x, y, z));
		import_set.push_back(coordinates(cell_x - 1, cell_y + 1, cell_z, x, y, z));
		import_set.push_back(coordinates(cell_x, cell_y + 1, cell_z, x, y, z));
		//when (z== z+1) outer tower
		import_set.push_back(coordinates(cell_x, cell_y, cell_z + 1, x, y, z));
		import_set.push_back(coordinates(cell_x, cell_y, cell_z - 1, x, y, z));
		//cout << "13!!!!!!!!!!!!!";

	}
	//when 1 < c_to_r <= 1/sqrt(2)
	//when (z==z) return plate
	else if ((1.0 <r_to_cell) && (r_to_cell <= sqrt(2))){
		for (int i = cell_y - 1; i<cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 2, i, cell_z, x, y, z));
		}
		for (int i = cell_y - 2; i<cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 1, i, cell_z, x, y, z));
		}
		for (int i = cell_y + 1; i<cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x, i, cell_z, x, y, z));
		}
		//tower
		for (int i = cell_z + 1; i<cell_z + 3; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 3; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}

		//cout << "40!!!!!!!!!!!!!!!!!!";
	}

	//when （1/sqrt(2), 1/sqrt(3)]

	else if ((sqrt(2.0) < r_to_cell) && (r_to_cell <= sqrt(3.0))){
		//when(z==z) return ()
		for (int i = cell_x - 2; i < cell_x; i++){
			for (int j = cell_y - 2; j < cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z, x, y, z));
			}
		}
		import_set.push_back(coordinates(cell_x, cell_y + 1, cell_z, x, y, z));
		import_set.push_back(coordinates(cell_x, cell_y + 2, cell_z, x, y, z));

		//tower
		for (int i = cell_z + 1; i<cell_z + 3; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 3; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		//cout<<"58!!!!!!";


	}



	else if ((sqrt(3.0) < r_to_cell) && (r_to_cell <= 2.01)){
		//when(z==z) return ()
		for (int i = cell_x - 2; i < cell_x; i++){
			for (int j = cell_y - 2; j < cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z, x, y, z));
			}
		}
		import_set.push_back(coordinates(cell_x, cell_y + 1, cell_z, x, y, z));
		import_set.push_back(coordinates(cell_x, cell_y + 2, cell_z, x, y, z));


		//tower
		for (int i = cell_z + 1; i<cell_z + 3; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 3; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		//cout<<"62!!!!!!";
	}

	else if ((r_to_cell > 2.0) && (r_to_cell <= sqrt(5.0))) {
		//when (z==z)
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 2, i, cell_z, x, y, z));
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 1, i, cell_z, x, y, z));
		}
		for (int i = cell_y + 1; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x, i, cell_z, x, y, z));
		}

		//tower
		for (int i = cell_z + 1; i<cell_z + 4; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 4; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		//cout << "89!!!!!!!!!!";
	}

	//when (sqrt(5), sqrt(6)]
	else if ((r_to_cell > sqrt(5.0)) && (r_to_cell < sqrt(6.0))){
		//z == z
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z, x, y, z));
		}
		for (int i = cell_x - 2; i<cell_x; i++){
			for (int j = cell_y - 3; j<cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z, x, y, z));
			}
		}
		for (int i = cell_y + 1; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x, i, cell_z, x, y, z));
		}
		//tower
		for (int i = cell_z + 1; i<cell_z + 4; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 4; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		//cout << "125!!!!!!!!!!!!!!!";

	}









	//when (sqrt(6), sqrt(8)]
	else if ((r_to_cell > sqrt(6.0)) && (r_to_cell < sqrt(8.0))){
		//z == z
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z, x, y, z));
		}
		for (int i = cell_x - 2; i<cell_x; i++){
			for (int j = cell_y - 3; j<cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z, x, y, z));
			}
		}
		for (int i = cell_y + 1; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x, i, cell_z, x, y, z));
		}
		//tower
		for (int i = cell_z + 1; i<cell_z + 4; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 4; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		//cout<<"137!!!!!!!!!!!!!";
	}





	else if ((r_to_cell>sqrt(8.0)) && (r_to_cell <= 3.01)){
		//when z==z
		for (int i = cell_x - 3; i < cell_x; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z, x, y, z));
			}
		}
		for (int i = cell_y + 1; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x, i, cell_z, x, y, z));
		}
		//tower
		for (int i = cell_z + 1; i<cell_z + 4; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 4; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		//cout << "155!!!!!!!";
	}

	else if ((r_to_cell>3.0) && (r_to_cell <= sqrt(10.0))){
		//when z==z
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z, x, y, z));
		}
		for (int i = cell_x - 3; i < cell_x - 1; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z, x, y, z));
			}
		}
		for (int i = cell_y - 4; i < cell_y + 5; i++){
			import_set.push_back(coordinates(cell_x - 1, i, cell_z, x, y, z));
		}
		for (int i = cell_y + 1; i < cell_y + 5; i++){
			import_set.push_back(coordinates(cell_x, i, cell_z, x, y, z));
		}
		//tower
		for (int i = cell_z + 1; i<cell_z + 5; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 5; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}

		//cout << "194!!!!!!!";
	}


	//when(sqrt(10), sqrt(11)]
	else if ((r_to_cell>sqrt(10.0)) && (r_to_cell <= sqrt(11.0))){
		//when z==z
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z, x, y, z));
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z, x, y, z));
		}
		for (int i = cell_x - 2; i < cell_x; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z, x, y, z));
			}
		}
		for (int i = cell_y + 1; i < cell_y + 5; i++){
			import_set.push_back(coordinates(cell_x, i, cell_z, x, y, z));
		}
		//tower
		for (int i = cell_z + 1; i<cell_z + 5; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 5; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}

		//cout << "230!!!!!!!";
	}





	//when (sqrt(11), sqrt(12)]
	else if ((r_to_cell>sqrt(11.0)) && (r_to_cell <= sqrt(12.0))){
		//when z==z
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z, x, y, z));
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z, x, y, z));
		}
		for (int i = cell_x - 2; i < cell_x; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z, x, y, z));
			}
		}
		for (int i = cell_y + 1; i < cell_y + 5; i++){
			import_set.push_back(coordinates(cell_x, i, cell_z, x, y, z));
		}
		//tower
		for (int i = cell_z + 1; i<cell_z + 5; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 5; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}


		//cout << "242!!!!!!!";
	}




	//when (sqrt(12), sqrt(13)]
	else if ((r_to_cell>sqrt(12.0)) && (r_to_cell <= sqrt(13.0))){
		//when z==z
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z, x, y, z));
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z, x, y, z));
		}
		for (int i = cell_x - 2; i < cell_x; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z, x, y, z));
			}
		}
		for (int i = cell_y + 1; i < cell_y + 5; i++){
			import_set.push_back(coordinates(cell_x, i, cell_z, x, y, z));
		}
		//tower
		for (int i = cell_z + 1; i<cell_z + 5; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 5; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}


		//cout << "246!!!!!!!";
	}



	//when (sqrt(13), sqrt(14)]
	else if ((r_to_cell>sqrt(13.0)) && (r_to_cell <= sqrt(14.0))){
		//when z==z
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z, x, y, z));
		}
		for (int i = cell_y - 4; i < cell_y + 5; i++){
			for (int j = cell_x - 3; j < cell_x; j++){
				import_set.push_back(coordinates(j, i, cell_z, x, y, z));
			}
		}
		for (int i = cell_y + 1; i < cell_y + 5; i++){
			import_set.push_back(coordinates(cell_x, i, cell_z, x, y, z));
		}

		//tower
		for (int i = cell_z + 1; i<cell_z + 5; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 5; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}


		//cout << "282!!!!!!!";
	}


	//when (sqrt(14), sqrt(16)]
	else if ((r_to_cell>sqrt(14.0)) && (r_to_cell <= 4.01)){
		//when z==z
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z, x, y, z));
		}
		for (int i = cell_y - 4; i < cell_y + 5; i++){
			for (int j = cell_x - 3; j < cell_x; j++){
				import_set.push_back(coordinates(j, i, cell_z, x, y, z));
			}
		}
		for (int i = cell_y + 1; i < cell_y + 5; i++){
			import_set.push_back(coordinates(cell_x, i, cell_z, x, y, z));
		}

		//tower
		for (int i = cell_z + 1; i<cell_z + 5; i++){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}
		for (int i = cell_z - 1; i>cell_z - 5; i--){
			import_set.push_back(coordinates(cell_x, cell_y, i, x, y, z));
		}


		//cout << "306!!!!!!!";
	}


	return import_set;





}






int weight_a(int x_dst, int y_dst, int z_dst, int x, int y, int z){
	int diff = abs(x_dst - x) + abs(y_dst - y) + abs(z_dst - z);
	if (diff == 0) {
		return 0;
	}
	else {
		return 256 >> (diff - 1);
	}
}


/***********************************
* calc the src of every point to
* point tranferring.
* for same z level,
* transfer follow the wind fan shape
***********************************/
vector<int> get_src_of_dst(int x_dst, int y_dst, int z_dst, int x, int y, int z){
	int m = x_dst - x;
	int n = y_dst - y;
	int l = z_dst - z;
	int weight;
	int x_src, y_src, z_src;
	vector<int> result;

	//left_bottom 
	if ((m <= 0) && (n<0)){
		x_src = x_dst;
		y_src = y_dst + 1;
		z_src = z_dst;
	}

	//left_top	
	else if ((m < 0) && (n >= 0)){
		x_src = x_dst + 1;
		y_src = y_dst;
		z_src = z_dst;
	}

	//right_up
	else if ((m >= 0) && (n>0)){
		x_src = x_dst;
		y_src = y_dst - 1;
		z_src = z_dst;
	}

	//right_bottom
	else if ((m > 0) && (n <= 0)){
		x_src = x_dst - 1;
		y_src = y_dst;
		z_src = z_dst;
	}
	if ((m == 0) && (n == 0)){
		if (l <= 0){

			x_src = x_dst;
			y_src = y_dst;
			z_src = z_dst + 1;
		}
		else{
			x_src = x_dst;
			y_src = y_dst;
			z_src = z_dst - 1;
		}
	}

	weight = weight_a(x_dst, y_dst, z_dst, x, y, z);
	result.push_back(x_src);
	result.push_back(y_src);
	result.push_back(z_src);
	result.push_back(weight);
	return result;
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

struct greater_than_weight{
	inline bool operator()(const pattern& pattern1, const pattern& pattern2){
		return (pattern1.weight > pattern2.weight);
	}

};

struct less_than_z{
	inline bool operator()(const pattern& pattern1, const pattern& pattern2){
		return (pattern1.src_z < pattern2.src_z);
	}

};

struct less_than_y{
	inline bool operator()(const pattern& pattern1, const pattern& pattern2){
		return (pattern1.src_y < pattern2.src_y);
	}

};

struct less_than_x{
	inline bool operator()(const pattern& pattern1, const pattern& pattern2){
		return (pattern1.src_x < pattern2.src_x);
	}

};




int main()
//int argc , char ** argv)
{


#if GenVolumn
	ofstream outputV;
	outputV.open("import_volumn_NT.txt");

	int nbr_cells = X * Y * Z;
	outputV << "The number of cells in total is: " << nbr_cells << "\n";
	outputV << "\n***************************start calculation!******************************\n";

	for (float i = 1.0; i < 4.1; i = i + 0.1){
		outputV << "The r_to_c ratio is: " << i << "\n";
		vector<coordinates> import_set_v = get_import_sets_NT(i, X, Y, Z, SRC_X, SRC_Y, SRC_Z);

		int nbr = import_set_v.size();

		float tmp_0 = pow(i, 2);
		float volumn_half_ball = (M_PI)*tmp_0 / 2 + 4 * i;
		outputV << "the half ball size is: " << volumn_half_ball << "\n";
		float volumn_calc = (float)(nbr);

		float r_r_p = volumn_half_ball / volumn_calc;

		outputV << "the oringinal import set size is: " << nbr << "\n";
		outputV << "if we do filtering reduction, we can send only: " << r_r_p;
		outputV << " of oringinal sending size.\n\n";
	}

	outputV << "Done_NT!\n";
	outputV.close();
#endif 
#if NT
	ofstream outputFile;
	float r_2_c = R_2_C;
	string r2c = to_string(r_2_c);
	string fileheader = "programdata_NT";
	string filename = fileheader + r2c + ".txt";
	outputFile.open(filename);


	outputFile << "The r_to_c ratio is: " << r_2_c << "\n";
	int nbr_particles_box = get_nbr_particles_per_box(r_2_c);
	outputFile << "one box contains " << nbr_particles_box << "  of particles\n";
	outputFile << "\n***************************start calculation!******************************\n";

	for (int src_z = 0; src_z < Z; src_z++){
		for (int src_y = 0; src_y < Y; src_y++){
			for (int src_x = 0; src_x < X; src_x++){


				vector<pattern> x;

				outputFile << "Start generating BroadCast TREE pattern for this node: (" << src_x << "," << src_y << "," << src_z << "):\n\n";
				vector<coordinates> import_set = get_import_sets_NT(r_2_c, X, Y, Z, src_x, src_y, src_z);
				for (vector<coordinates>::iterator it = import_set.begin(); it != import_set.end(); ++it){
					int dst_x = (*it).cell_x;
					int dst_y = (*it).cell_y;
					int dst_z = (*it).cell_z;
					int x_src, y_src, z_src;
					int weight;

					vector<int> result = get_src_of_dst(dst_x, dst_y, dst_z, src_x, src_y, src_z);
					vector<int>::iterator itt = result.begin();
					x_src = *itt;
					itt++;
					y_src = *itt;
					itt++;
					z_src = *itt;
					itt++;
					weight = *itt;
					int send_to_dst_x = trans(dst_x, X);
					int send_to_dst_y = trans(dst_y, Y);
					int send_to_dst_z = trans(dst_z, Z);
					int send_from_src_x = trans(x_src, X);
					int send_from_src_y = trans(y_src, Y);
					int send_from_src_z = trans(z_src, Z);



					x.push_back(pattern(send_from_src_x, send_from_src_y, send_from_src_z, send_to_dst_x, send_to_dst_y, send_to_dst_z, weight));


				}

				//first sort by weight, from root to leaf of the tree
				sort(x.begin(), x.end(), greater_than_weight());
				int level = 256;
				vector<pattern>::iterator front = x.begin();

				//in each level of tree, sort by source coord
				for (vector<pattern>::iterator it = x.begin();;){

					if ((it == x.end()) || (it->weight != level))  {
						sort(front, it, less_than_z());
						//each level of tree, if z equals, sort by y coord
						vector<pattern>::iterator front_1 = front;
						int z_coord = front_1->src_z;
						for (vector<pattern>::iterator itt = front;;){


							if ((itt == x.end()) || (itt->src_z != z_coord)){
								sort(front_1, itt, less_than_y());

								//each level of tree, if z equals, y equals, sort by x coord
								vector<pattern>::iterator front_2 = front_1;
								int y_coord = front_2->src_y;
								for (vector<pattern>::iterator ittt = front_1;;){

									if ((ittt == x.end()) || (ittt->src_y != y_coord)) {
										sort(front_2, ittt, less_than_x());
										front_2 = ittt;
										if (ittt == x.end()){
											y_coord = 100;
										}
										else{
											y_coord = ittt->src_y;
										}
									}
									if (ittt == x.end() || ittt == itt){
										break;
									}
									else{
										ittt++;
									}
								}


								front_1 = itt;
								if (itt == x.end()){
									z_coord = 100;
								}
								else{
									z_coord = itt->src_z;
								}

							}

							if (itt == x.end() || itt == it){
								break;
							}
							else{
								itt++;
							}
						}


						front = it;
						if (it == x.end()){
							level = 0;
						}
						else{
							level = it->weight;
						}
					}


					if (it == x.end()){
						break;
					}
					else{
						it++;
					}
				}




				// group up
				level = 256;
				front = x.begin();
				int groupx = front->src_x;
				int groupy = front->src_y;
				int groupz = front->src_z;
				int fanout = 0;
				outputFile << "{";
				outputFile << "src: (" << front->src_x << "," << front->src_y << "," << front->src_z << ")\n";
				for (vector<pattern>::iterator it = x.begin(); it != x.end(); ++it){

					if (it->weight == level){
						if ((it->src_x == groupx) && (it->src_y == groupy) && (it->src_z == groupz)){

							outputFile << "          dst: (" << it->dst_x << "," << it->dst_y << "," << it->dst_z << ")  ";
							outputFile << "weight: " << it->weight << "\n";
							fanout++;
						}
						else {
							if (fanout == 1) {
								outputFile << "                     Single Fan Out!}";
							}
							else {
								outputFile << "                                    }";
							}
							fanout = 1;
							outputFile << "\n{";
							outputFile << "src: (" << it->src_x << "," << it->src_y << "," << it->src_z << ")\n";
							outputFile << "          dst: (" << it->dst_x << "," << it->dst_y << "," << it->dst_z << ")  ";
							outputFile << "weight: " << it->weight << "\n";
							groupx = it->src_x;
							groupy = it->src_y;
							groupz = it->src_z;
						}

					}
					else {
						if (fanout == 1) {
							outputFile << "                     Single Fan Out!}";
						}
						else {
							outputFile << "                                    }";
						}
						fanout = 1;
						outputFile << "\n{";
						outputFile << "src: (" << it->src_x << "," << it->src_y << "," << it->src_z << ")\n";
						outputFile << "          dst: (" << it->dst_x << "," << it->dst_y << "," << it->dst_z << ")  ";
						outputFile << "weight: " << it->weight << "\n";
						level = it->weight;
						groupx = it->src_x;
						groupy = it->src_y;
						groupz = it->src_z;
					}

				}
				outputFile << "                                    }\n\n";


			}
		}
	}

	outputFile << "Done_NT!\n";
	outputFile.close();
#endif
	return 1;

}





