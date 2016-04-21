//Purpose: get the most proper buffer size of the current network
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Mar 19th 2015
//Input: buffer_size.txt this is the tree struction file


#include<iostream>
#include<fstream>
#include<string>
#define LINEMAX 1000
using namespace std;

int main(){
	string filename="C:/Users/Jiayi/Documents/GitHub/MD_reduction/software/buffer_size.txt";
	int max_size=0;
	int cur_size=0;
	int total_size;
	ifstream input_file;
	int line_counter = 0;
	char line[LINEMAX];
	char* tokens;
	input_file.open(filename);
	if (input_file.fail()){
		cout << "open file failed" << filename << endl;
		return -1;
	}
	while (!input_file.eof()){
		input_file.getline(line, LINEMAX);
		line_counter++;
		tokens = strtok(line, " ");
		if (tokens == NULL) break;
		cur_size = atoi(tokens);
		tokens = strtok(NULL, " ");
		total_size = atoi(tokens);
		if(cur_size>max_size){
			max_size=cur_size;
		}
	}

	cout<<"max buffer consumption is "<<max_size<<"out of "<<total_size<<endl;

	
	return 0;
}