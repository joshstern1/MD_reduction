//Purpose: parse the departing results and arriving results from the verilog design 
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Jan 13th 2016
//Input: dump.txt

#include <fstream>
#include <iostream>
#include<string>
#include<stdlib.h>
#include<time.h>
#include<queue>

using namespace std;

//departure packet is format [src.x] [src.y] [src.z] [id] [time] [packet type]
//arrival packet is format   [src.x] [src.y] [src.z] [dst.x] [dst.y] [dst.z] [id] [time] [packet type]



#define LINEMAX 100

#define PARTICLE_PER_BOX 172
#define MODE 2 // 1 is multicast mode, 2 is reduction mode, 3 is the singlecast multicastmode, 4 is the singlecast reduction mode
#define MAX_NUM_CHILDREN 5

#define LOCAL 0
#define YNEG 1
#define YPOS 2
#define XPOS 3
#define XNEG 4
#define ZPOS 5
#define ZNEG 6
#define X 4
#define Y 4
#define Z 4

int export_num;



double r2c = 1;// the ratio between the cutoff radius and box size
int particle_per_box = 172;
int particle_per_cell = 172;
float r = 12;
float xsize = 108;
float ysize = 108;
float zsize = 80;

int mode = MODE;

struct packet_timing{
	int depart_time;
	int arrival_time[X*Y*Z];
	int valid;
};

struct singlecast_packet_timing{
	int depart_counter;
	int arrival_counter;
	int valid;
};

struct packet_timing** multicast_timing;

struct singlecast_packet_timing** singlecast_timing;

void read_dump_singlecast(char* filename){
	ifstream input_file;
	int line_counter = 0; 
	input_file.open(filename);
	char *tokens;// the number is going to be read from the dump.txt
	int src_x;
	int src_y;
	int src_z;
	int dst_x;
	int dst_y;
	int dst_z;
	int id;
	int depart_time;
	int arrival_time;
	char line[LINEMAX];
	while (!input_file.eof()){
		input_file.getline(line, LINEMAX);
		line_counter++;
		if (line[0] == 'D'){
			input_file.getline(line, LINEMAX);
			line_counter++;
			tokens = strtok(line, " ");
			src_x = atoi(tokens);
			tokens = strtok(NULL, " ");
			src_y = atoi(tokens);
			tokens = strtok(NULL, " ");
			src_z = atoi(tokens);
			tokens = strtok(NULL, " ");
			id = atoi(tokens);
			tokens = strtok(NULL, " ");
			depart_time = atoi(tokens);
			singlecast_timing[src_x*Y*Z + src_y*Z + src_z][id].depart_counter++;

		}
		else if (line[0] == 'A'){
			input_file.getline(line, LINEMAX);
			line_counter++;
			tokens = strtok(line, " ");
			src_x = atoi(tokens);
			tokens = strtok(NULL, " ");
			src_y = atoi(tokens);
			tokens = strtok(NULL, " ");
			src_z = atoi(tokens);
			tokens = strtok(NULL, " ");
			dst_x = atoi(tokens);
			tokens = strtok(NULL, " ");
			dst_y = atoi(tokens);
			tokens = strtok(NULL, " ");
			dst_z = atoi(tokens);
			tokens = strtok(NULL, " ");
			id = atoi(tokens);

			tokens = strtok(NULL, " ");
			arrival_time = atoi(tokens);
			singlecast_timing[src_x*Y*Z + src_y*Z + src_z][id].arrival_counter++;
		}


	}
	input_file.close();
}




void read_dump_multicast(char* filename){
	ifstream input_file;
	int line_counter = 0;
	input_file.open(filename);
	char *tokens;// the number is going to be read from the dump.txt
	int src_x;
	int src_y;
	int src_z;
	int dst_x;
	int dst_y;
	int dst_z;
	int id;
	int depart_time;
	int arrival_time;

	char line[LINEMAX];
	while (!input_file.eof()){
		input_file.getline(line, LINEMAX);
		line_counter++;
		if (line[0] == 'D'){
			input_file.getline(line, LINEMAX);
			line_counter++;
			tokens = strtok(line," ");
			src_x = atoi(tokens);
			tokens = strtok(NULL, " ");
			src_y = atoi(tokens);
			tokens = strtok(NULL, " ");
			src_z = atoi(tokens);
			tokens = strtok(NULL, " ");
			id = atoi(tokens);
			tokens = strtok(NULL, " ");
			depart_time = atoi(tokens);
			multicast_timing[src_x*Y*Z+src_y*Z+src_z][id].depart_time=depart_time;
			for (int i = 0; i < X*Y*Z; i++){
				multicast_timing[src_x*Y*Z + src_y*Z + src_z][id].arrival_time[i] = -1;
			}

		}
		else if (line[0] == 'A'){
			input_file.getline(line, LINEMAX);
			line_counter++;
			tokens = strtok(line, " ");
			src_x = atoi(tokens);
			tokens = strtok(NULL, " ");
			src_y = atoi(tokens);
			tokens = strtok(NULL, " ");
			src_z = atoi(tokens);
			tokens = strtok(NULL, " ");
			dst_x = atoi(tokens);
			tokens = strtok(NULL, " ");
			dst_y = atoi(tokens);
			tokens = strtok(NULL, " ");
			dst_z = atoi(tokens);
			tokens = strtok(NULL, " ");
			id = atoi(tokens);

			tokens = strtok(NULL, " ");
			arrival_time = atoi(tokens);
			multicast_timing[src_x*Y*Z + src_y*Z + src_z][id].arrival_time[dst_x*Y*Z + dst_y*Z + dst_z] = arrival_time;



		}


	}
	input_file.close();
}

void verify_multicast(){
	int bitmap[X*Y*Z];
	int ref_counter = 0;
	int counter;
	for (int i = 0; i < X*Y*Z; i++){
		bitmap[i] = 0;
	}
	for (int i = 0; i < X*Y*Z; i++){
		if (multicast_timing[0][0].arrival_time[i] != -1){
			bitmap[i] = 1;
			ref_counter++;
		}
	}

	for (int i = 0; i < X*Y*Z; i++){
		for (int j = 0; j < PARTICLE_PER_BOX; j++){
			counter = 0;
			for (int k = 0; k < X*Y*Z; k++){
				if (multicast_timing[i][j].arrival_time[k] != -1){
					counter++;
				}
			}
			if (counter != ref_counter) {
				cout << "error at" << i << " " << j << endl;
				cout << "counter=" << counter << " ref_counter=" << ref_counter << endl;
			}
		}
	}
	cout << "all correct!" << endl;
}

void verify_singlecast(){
	for (int i = 0; i < X*Y*Z; i++){
		for (int j = 0; j < PARTICLE_PER_BOX; j++){
			if (singlecast_timing[i][j].arrival_counter < singlecast_timing[i][j].depart_counter){
				cout << "error at" << i << " " << j << endl;
				cout << "depart counter=" << singlecast_timing[i][j].depart_counter << " arrival counter=" << singlecast_timing[i][j].arrival_counter << endl;
			}
		}
	}
}

int main(){
	
	char filename[200] = "C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/dump.txt";
	if (mode == 1){
		if (!(multicast_timing = (packet_timing**)malloc(X*Y*Z*sizeof(packet_timing*)))){
			cout << "No mem for multicast_timing" << endl;
			exit(-1);
		}
		for (int i = 0; i < X*Y*Z; i++){
			if (!(multicast_timing[i] = (packet_timing*)malloc(PARTICLE_PER_BOX*sizeof(packet_timing)))){
				cout << "No mem for multicast_timing" << i << endl;
				exit(-1);
			}
		}
		//init multicast_timing
		for (int i = 0; i < X*Y*Z; i++){
			for (int j = 0; j < PARTICLE_PER_BOX; j++){
				//multicast_timing[i][j].arrival_time = 0;
				multicast_timing[i][j].depart_time = 0;
				multicast_timing[i][j].valid = false;
			}
		}
		read_dump_multicast(filename);
		verify_multicast();
		
	}
	else if (mode == 3 || mode == 4){
		if (!(singlecast_timing = (singlecast_packet_timing**)malloc(X*Y*Z*sizeof(singlecast_packet_timing*)))){
			cout << "No mem for singlecast_timing" << endl;
			exit(-1);
		}
		for (int i = 0; i < X*Y*Z; i++){
			if (!(singlecast_timing[i] = (singlecast_packet_timing*)malloc(PARTICLE_PER_BOX*sizeof(singlecast_packet_timing)))){
				cout << "No mem for singlecast_timing" << i << endl;
				exit(-1);
			}
		}
		//init multicast_timing
		for (int i = 0; i < X*Y*Z; i++){
			for (int j = 0; j < PARTICLE_PER_BOX; j++){
				singlecast_timing[i][j].depart_counter = 0;
				singlecast_timing[i][j].arrival_counter = 0;			
			}
		}
		read_dump_singlecast(filename);
		verify_singlecast();

	}

	return 0;
}