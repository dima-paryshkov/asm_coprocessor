#include <stdio.h>
#include <conio.h>
#include <locale.h>
#include <iostream>
using namespace std;

extern "C" float __stdcall Newton(float precision, int* iterCtr);

void main()
{
	int iterCtr = 1;
	float precision;
	float res;

	cout << "The equation: arctg(x) = 0" << endl;
	cout << "Eps: ";
	cin >> precision;

	res = Newton(precision, &iterCtr);

	cout << "Equation solution: " <<  res << endl;
	cout << "Number of iterations: " <<  iterCtr << endl;

	_getch();
}
