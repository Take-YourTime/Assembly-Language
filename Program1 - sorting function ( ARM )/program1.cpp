#include <iostream>
#include <cstdlib>
#include <cstring>
using namespace std;

int main(int argc, char *argv[])
{
	/*
	cout << "argc: " << argc << '\n';
	cout << "argv[]: ";
	for(int i = 0; i < argc; i++)
	{
		for(int j = 0; j < strlen(argv[i]); j++)
			cout << argv[i][j];
		cout << " ";
	}
	cout << '\n';
	*/
	
	const int size = argc;	//	max size = 8
	int list[argc - 1] = {0};
	
	//	index從1開始，因為要避免計算到檔案名稱
	for(int i = 1; i < argc; i++)
	{
		for(int j = 0; j < strlen(argv[i]); j++)
		{
			list[i-1] *= 10;
			list[i-1] += argv[i][j] - '0';
		}
	}
	
	cout << "Before sort: ";
	for(int i = 0; i < argc-1; i++)
		cout << list[i] << " ";
	cout << '\n';
	
	
	for(int i = 0; i < argc-1; i++)
	{
		for(int j = 0; j < argc-1 - i - 1; j++)
		{
			if(list[j] > list[j+1])
			{
				int temp = list[j];
				list[j] = list[j+1];
				list[j+1] = temp;
			}
		}
	}
	
	cout << "After sort: ";
	for(int i = 0; i < argc-1; i++)
		cout << list[i] << " ";
	cout << '\n';
	return 0;
}
