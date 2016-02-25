/***********************************************************************
 * CAAD,BU
 * Qingqing X, 12/15/2015
 * Step1: set X, Y ,Z (number of boxes on each dimension)
 * Step2: set one of the two parameters GenPattern, GenVolumn to be 1
 * Step3: if GenPattern is set, set R_2_C;
 else GenVolumn is set, set three parameters SRC_X to SRC_Z to
 be the box node you want to watch
 * **********************************************************************/
/*
 * revised by Jiayi Sheng at 12/28/2015
 */

#include <iostream>
#include <stdlib.h>
#include <vector>
#include "assert.h"
#include <math.h>
#include <limits>
//#include <boost/bind.hpp>
#include <algorithm>

//#include "stdafx.h"
#include <fstream>

using namespace std;

#define X 4
#define Y 4
#define Z 4

#define SRC_X 0
#define SRC_Y 0
#define SRC_Z 0

#define DEBUG 0
#define GenPattern 1   //Set this to 1 to generate pattern for one source box
#define GenVolumn 0	   //Set this to 1 to generate boxes numbers to half ball volumn ratio

#if GenPattern

#define R_2_C 1

#endif

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

/********************************************
 * @r_to_cell  radius to cell size ratio
 * @x, y, z     system size in unit of cell
 * @cell_x, cell_y, cell_z  coordinates of one cell
 * ******************************************/

vector<coordinates> get_import_sets(float r_to_cell, int x, int y, int z,
                                    int cell_x, int cell_y, int cell_z){
    
	vector<coordinates> import_set;
    
	//assertions
	if ((r_to_cell < 0.0) || (r_to_cell > 4.0)){
		cout << "input ratio is out of range!";
		//return 0;
        
	}
	//when r_to_cell no larger than 1(return 13 cells)
	//when (z==z) return (x-1,y-1), (x-1,y), (x-1,y+1), (x+1, y+1)
	else if (r_to_cell <= 1.0){
		import_set.push_back(coordinates(cell_x - 1, cell_y - 1, cell_z, x, y, z));
		import_set.push_back(coordinates(cell_x - 1, cell_y, cell_z, x, y, z));
		import_set.push_back(coordinates(cell_x - 1, cell_y + 1, cell_z, x, y, z));
		import_set.push_back(coordinates(cell_x, cell_y + 1, cell_z, x, y, z));
		//when (z== z+1) return (x-2<x<x+2, y-2<y<y+2)
		for (int i = cell_x - 1; i<cell_x + 2; i++){
			for (int j = cell_y - 1; j<cell_y + 2; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		//cout << "13!!!!!!!!!!!!!";
        
	}
	//when 1 < c_to_r <= 1/sqrt(2)
	//when (z==z) return (x-2, y-2<y<y+2)  and  (x-1,y-3<y<y+3) and (x, y<y<y+3)
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
		//when (z== z+1) return (x-2,y-2<y<y+2) and (x-2<x<x+2, y-3<y<y+3) and (x+2,y-2<y<y+2)
		for (int i = cell_y - 1; i<cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 2, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_x - 1; i<cell_x + 2; i++){
			for (int j = cell_y - 2; j<cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_y - 1; i<cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x + 2, i, cell_z + 1, x, y, z));
		}
        
		//when (z== z+2) return (x-2<x<x+2, y-2<y<y+2)
		for (int i = cell_x - 1; i<cell_x + 2; i++){
			for (int j = cell_y - 1; j<cell_y + 2; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
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
        
		//when(z == z+1) 5x5
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 2; j < cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
        
		//when(z == z + 2) same as layer z=z+1 of (1,1.414]
		for (int i = cell_y - 1; i<cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 2, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_x - 1; i<cell_x + 2; i++){
			for (int j = cell_y - 2; j<cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		for (int i = cell_y - 1; i<cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x + 2, i, cell_z + 2, x, y, z));
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
        
		//when(z == z+1) 5x5
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 2; j < cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
        
		//when(z == z + 2)
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 2; j < cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
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
        
		//when(z==z+1)
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 2, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_x - 1; i < cell_x + 2; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 2, i, cell_z + 1, x, y, z));
		}
        
		//when (z==z+2)   //should be the shape of r==2 5x5
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 2; j < cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		//when(z==z+3)
		for (int i = cell_x - 1; i<cell_x + 2; i++){
			for (int j = cell_y - 1; j<cell_y + 2; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
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
		//z == z+1
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_x - 2; i<cell_x + 3; i++){
			for (int j = cell_y - 3; j<cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 1, x, y, z));
		}
		//z == z+2 (2,sqrt(5))
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 2, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_x - 1; i < cell_x + 2; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 2, i, cell_z + 2, x, y, z));
		}
		//z == z+3 (1,sqrt(2)]
		for (int i = cell_y - 1; i<cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 2, i, cell_z + 3, x, y, z));
		}
		for (int i = cell_x - 1; i<cell_x + 2; i++){
			for (int j = cell_y - 2; j<cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
		}
		for (int i = cell_y - 1; i<cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x + 2, i, cell_z + 3, x, y, z));
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
		//z == z+1
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_x - 2; i<cell_x + 3; i++){
			for (int j = cell_y - 3; j<cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 1, x, y, z));
		}
		//z == z+2 (sqrt(5),sqrt(6))
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_x - 2; i<cell_x + 3; i++){
			for (int j = cell_y - 3; j<cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 2, x, y, z));
		}
		//z == z+3 (sqrt(2),sqrt(3)]
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 2; j < cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
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
		//when z==z+1 7x7
		for (int i = cell_x - 3; i < cell_x + 4; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		//when z==z+2 (sqrt(7),sqrt(8)]
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_x - 2; i<cell_x + 3; i++){
			for (int j = cell_y - 3; j<cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 2, x, y, z));
		}
		//when z==z+3 (2,sqrt(5)]
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 3, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 2, i, cell_z + 3, x, y, z));
		}
		for (int i = cell_x - 1; i < cell_x + 2; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
		}
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 3, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 2, i, cell_z + 3, x, y, z));
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
		//when z==z+1
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_x - 3; i < cell_x - 1; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_x - 1; i < cell_x + 2; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_x + 2; i < cell_x + 4; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 1, x, y, z));
		}
		//when z==z+2 (sqrt(8),sqrt(9)]
		for (int i = cell_x - 3; i < cell_x + 4; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		//when z==z+3 (sqrt(5),sqrt(6)]
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 3, x, y, z));
		}
		for (int i = cell_x - 2; i<cell_x + 3; i++){
			for (int j = cell_y - 3; j<cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 3, x, y, z));
		}
		//when z==z+4 (0,1]
		for (int i = cell_x - 1; i<cell_x + 2; i++){
			for (int j = cell_y - 1; j<cell_y + 2; j++){
				import_set.push_back(coordinates(i, j, cell_z + 4, x, y, z));
			}
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
		//when z==z+1
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 1, x, y, z));
		}
        
		//when z==z+2 (sqrt(9),sqrt(10)]
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_x - 3; i < cell_x - 1; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		for (int i = cell_x - 1; i < cell_x + 2; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		for (int i = cell_x + 2; i < cell_x + 4; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 2, x, y, z));
		}
		//when z==z+3 (sqrt(6),sqrt(7)]
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 3, x, y, z));
		}
		for (int i = cell_x - 2; i<cell_x + 3; i++){
			for (int j = cell_y - 3; j<cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 3, x, y, z));
		}
		//when z==z+4 (1,sqrt(2)]
		for (int i = cell_y - 1; i<cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 2, i, cell_z + 4, x, y, z));
		}
		for (int i = cell_x - 1; i<cell_x + 2; i++){
			for (int j = cell_y - 2; j<cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z + 4, x, y, z));
			}
		}
		for (int i = cell_y - 1; i<cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x + 2, i, cell_z + 4, x, y, z));
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
		//when z==z+1
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 1, x, y, z));
		}
        
		//when z==z+2 (sqrt(10),sqrt(11)]
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 2, x, y, z));
		}
		//when z==z+3 (sqrt(7),sqrt(8)]
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 3, x, y, z));
		}
		for (int i = cell_x - 2; i<cell_x + 3; i++){
			for (int j = cell_y - 3; j<cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 3, x, y, z));
		}
		//when z==z+4 (sqrt(2),sqrt(3)]
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 2; j < cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z + 4, x, y, z));
			}
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
		//when z==z+1
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 1, x, y, z));
		}
        
		//when z==z+2 (sqrt(11),sqrt(12)]
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 2, x, y, z));
		}
		//when z==z+3 (sqrt(8),sqrt(9)]
		for (int i = cell_x - 3; i < cell_x + 4; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
		}
		//when z==z+4 (sqrt(3),sqrt(4)]
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 2; j < cell_y + 3; j++){
				import_set.push_back(coordinates(i, j, cell_z + 4, x, y, z));
			}
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
        
		//when z==z+1 the same as the lower layer(two times)
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_y - 4; i < cell_y + 5; i++){
			for (int j = cell_x - 3; j < cell_x + 4; j++){
				import_set.push_back(coordinates(j, i, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 1, x, y, z));
		}
        
		//when z==z+2 (sqrt(12),sqrt(13)]
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z + 2, x, y, z));
			}
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 2, x, y, z));
		}
        
		//when z==z+3 (3,sqrt(10)]
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 3, x, y, z));
		}
		for (int i = cell_x - 3; i < cell_x - 1; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
		}
		for (int i = cell_x - 1; i < cell_x + 2; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
		}
		for (int i = cell_x + 2; i < cell_x + 4; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
		}
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 3, x, y, z));
		}
        
		//when z==z+4 (2,sqrt(5)]
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 4, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 2, i, cell_z + 4, x, y, z));
		}
		for (int i = cell_x - 1; i < cell_x + 2; i++){
			for (int j = cell_y - 3; j < cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 4, x, y, z));
			}
		}
		for (int i = cell_y - 1; i < cell_y + 2; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 4, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 2, i, cell_z + 4, x, y, z));
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
        
		//when z==z+1 the same as the lower layer(two times)
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 1, x, y, z));
		}
		for (int i = cell_y - 4; i < cell_y + 5; i++){
			for (int j = cell_x - 3; j < cell_x + 4; j++){
				import_set.push_back(coordinates(j, i, cell_z + 1, x, y, z));
			}
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 1, x, y, z));
		}
        
		//when z==z+2 (sqrt(13),sqrt(14)]
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 2, x, y, z));
		}
		for (int i = cell_y - 4; i < cell_y + 5; i++){
			for (int j = cell_x - 3; j < cell_x + 4; j++){
				import_set.push_back(coordinates(j, i, cell_z + 2, x, y, z));
			}
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 2, x, y, z));
		}
        
		//when z==z+3 (sqrt(10),sqrt(11)]
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 4, i, cell_z + 3, x, y, z));
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 3, x, y, z));
		}
		for (int i = cell_x - 2; i < cell_x + 3; i++){
			for (int j = cell_y - 4; j < cell_y + 5; j++){
				import_set.push_back(coordinates(i, j, cell_z + 3, x, y, z));
			}
		}
		for (int i = cell_y - 3; i < cell_y + 4; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 3, x, y, z));
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 4, i, cell_z + 3, x, y, z));
		}
        
		//when z==z+4 (sqrt(5),sqrt(6)]
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x - 3, i, cell_z + 4, x, y, z));
		}
		for (int i = cell_x - 2; i<cell_x + 3; i++){
			for (int j = cell_y - 3; j<cell_y + 4; j++){
				import_set.push_back(coordinates(i, j, cell_z + 4, x, y, z));
			}
		}
		for (int i = cell_y - 2; i < cell_y + 3; i++){
			import_set.push_back(coordinates(cell_x + 3, i, cell_z + 4, x, y, z));
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
		x_src = x_dst;
		y_src = y_dst;
		z_src = z_dst - 1;
	}
#if DEBUG
	cout << "x_dst: " << x_dst;
	cout << "   y_dst: " << y_dst;
	cout << "   z_dst: " << z_dst << "\n";
#endif
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
	ofstream outfile;
	outfile.open("C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/reduction_tree.txt");
    
#if GenVolumn
	int nbr_cells = X * Y * Z;
	outfile << "The number of cells in total is: " << nbr_cells << "\n";
	outfile << "\n***************************start calculation!******************************\n";
    
	for (float i = 1.0; i < 4.1; i = i + 0.1){
		outfile << "The r_to_c ratio is: " << i << "\n";
		vector<coordinates> import_set = get_import_sets(i, X, Y, Z, SRC_X, SRC_Y, SRC_Z);
        
		int nbr = import_set.size();
        
		float tmp_0 = pow(i, 3);
		float volumn_half_ball = (M_PI)*tmp_0 * 2 / 3 + 2 * i;
		outfile << "the half ball size is: " << volumn_half_ball << "\n";
		float volumn_calc = (float)(nbr);
        
		float r_r_p = volumn_half_ball / volumn_calc;
        
		outfile << "the oringinal import set size is: " << nbr << "\n";
		outfile << "if we do filtering reduction, we can send only: " << r_r_p;
		outfile << " of oringinal sending size.\n\n";
	}
#endif
    
#if GenPattern
	float r_2_c = R_2_C;
	outfile << "X " << endl << X << endl;
	outfile << "Y " <<endl << Y << endl;
    
	outfile << "Z " <<endl << Z << endl;
    
	outfile << "The r_to_c ratio is: " << endl;
	outfile << r_2_c << "\n";
	int nbr_particles_box = get_nbr_particles_per_box(r_2_c);
	outfile << "The number of particles of one box" << endl;
	outfile << nbr_particles_box << endl;
	outfile << "***************************start calculation!******************************\n";
    
	for (int src_z = 0; src_z < Z; src_z++){
		for (int src_y = 0; src_y < Y; src_y++){
			for (int src_x = 0; src_x < X; src_x++){
                
                
				vector<pattern> x;
                
				outfile << "Start generating BroadCast TREE pattern for this node: (" << src_x << "," << src_y << "," << src_z << "):\n\n";
				vector<coordinates> import_set = get_import_sets(r_2_c, X, Y, Z, src_x, src_y, src_z);
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
				for (vector<pattern>::iterator it = x.begin(); ; ){

					if ((it== x.end())||(it->weight != level))  {
						sort(front, it, less_than_z());
                        //each level of tree, if z equals, sort by y coord
                        vector<pattern>::iterator front_1 = front;
                        int z_coord = front_1->src_z;
                        for (vector<pattern>::iterator itt = front; ; ){
                            

                            if ((itt== x.end())||(itt->src_z != z_coord)){
                                sort(front_1, itt, less_than_y());
                                
                                //each level of tree, if z equals, y equals, sort by x coord
                                vector<pattern>::iterator front_2 = front_1;
                                int y_coord = front_2->src_y;
                                for (vector<pattern>::iterator ittt = front_1; ; ){

                                    if ((ittt== x.end())||(ittt->src_y != y_coord)) {
                                        sort(front_2, ittt, less_than_x());
                                        front_2 = ittt;
                                        if(ittt==x.end()){
                                            y_coord = 100;
                                        }
                                        else{
                                            y_coord = ittt->src_y;
                                        }
                                    }
									if (ittt == x.end()||ittt==itt){
										break;
									}
									else{
										ittt++;
									}
                                }
                                
                                
                                front_1 = itt;
                                if(itt== x.end()){
						            z_coord = 100;
						        }
						        else{
						            z_coord = itt->src_z;
						        }
                                
                            }

							if (itt == x.end()||itt==it){
								break;
							}
							else{
								itt++;
							}
                        }
                        
                        
						front = it;
						if(it== x.end()){
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
				outfile << "{";
				outfile << "src: (" << front->src_x << "," << front->src_y << "," << front->src_z << ") weight: 256"<<endl;
				for (vector<pattern>::iterator it = x.begin(); it != x.end(); ++it){
                    
					if (it->weight == level){
						if ((it->src_x == groupx) && (it->src_y == groupy) && (it->src_z == groupz)){
							
                  			outfile << "dst: (" << it->dst_x << "," << it->dst_y << "," << it->dst_z << ") ";
							outfile << "weight: " << it->weight << "\n";
							fanout++;
						}
						else {
							if (fanout == 1) {
								outfile << " Single Fan Out!}";
							}
							else {
								outfile << "}";
							}
							fanout = 1;
							outfile << "\n{";
							outfile << "src: (" << it->src_x << "," << it->src_y << "," << it->src_z << ") weight: " << it->weight << "\n";
                            outfile << "dst: (" << it->dst_x << "," << it->dst_y << "," << it->dst_z << ") ";
							outfile << "weight: " << it->weight << "\n";
							groupx = it->src_x;
							groupy = it->src_y;
							groupz = it->src_z;
						}
                        
					}
					else {
						if (fanout == 1) {
							outfile << " Single Fan Out!}";
                        }
						else {
							outfile << "}";
						}
						fanout = 1;
						outfile << "\n{";
						outfile << "src: (" << it->src_x << "," << it->src_y << "," << it->src_z << ")\ weight: " << it->weight << "\n";
                        outfile << "dst: (" << it->dst_x << "," << it->dst_y << "," << it->dst_z << ") ";
						outfile << "weight: " << it->weight << "\n";
						level = it->weight;
						groupx = it->src_x;
						groupy = it->src_y;
						groupz = it->src_z;
					}
                    
				}
				outfile << " }\n\n";
                
                
			}
		}
	}
#endif
	cout<< "Done!\n";
	outfile.close();
    
	return 1;
    
}





