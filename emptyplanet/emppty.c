#include <stdio.h>
#include <stdlib.h>

/*
Empty Planet hypotheses

by Alvaro Barcellos, february, 2019

The program simulates population growth hypotheses, using 3 age groups,
children, adults and elderly, calculating the variations of these 
groups each generation, using the number of children per couple, 
percentage of unmarried adults and infant mortality. 

The evaluation ends when there are no children or when the number of
children exceeds the original population.

Information on the number of the original population, percentages of 
children, adults and the elderly, number of children per couple, 
percentage of unmarried adults and percentage of infant mortality 
are required.

The representation in years for each generation, usually 20 to 25 years,
is not specific to the algorithm, only the capacity or not of reproduction.

Basically, with each generation: The number of children is calculated by 
multiplying half of adults by the number of children and by the proportion
of couples; The number of adults is calculated by the multiplication of 
the children adjusted to the index of infant mortality; The number of 
elderly and children is accumulated in each generation.

The program is not meant to be accurate or comprehensive, 
just the simplified demonstration of results.

EXAMPLE:
for a population of 7000, 0.43 of childrens, 0.43 of adults and 0.14 of elders,
with two childrens by couple, 0.30 of unmarried adults and 0.001 of infant mortality

echo "7000 0.43 0.43 0.14 2 0.30 0.001" | emppty > data.csv

for gnuplot:
cat << ENDED
set term png
set output 'd.png'
set datafile commentschars "#"
plot 	'data.csv' using 1:2 with lines, 
	'data.csv' using 1:3 with lines,
	'data.csv' using 1:4 with lines,:
	'data.csv' using 1:5 with lines
ENDED

eg:

cat data.gp | gnuplot

COPYRIGHT

    Copyright © 2019, Alvaro Barcellos.

    this program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

    this program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
    of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program.  
    If not, see http://www.gnu.org/licenses/.


*/

int main (int c, char * a[]) {
	
	int n;
	long int p0, p1, p2, p3, p4, p5, p6;
	float infants, singles, childs;
	
	n = 0;
	p5 = p6 = p4 = 0;

// just for 
	{
	float pa, pb, pc;

	scanf (" %ld %f %f %f %f %f %f",
		&p0, &pa, &pb, &pc, &childs, &singles, &infants);

// record status
	printf ("# population=%8ld, childrens=%4.3f, adults=%4.3f, elders=%4.3f, childs=%4.3f, singles=%4.3f, infants=%4.3f,\n",
		p0, pa, pb, pc, infants, singles, childs);

// initial populations
	p1 = p0 * pa;
	p2 = p0 * pb;
	p3 = p0 * pc;
	}

// record headers
	printf ("# generation, childrens, adults, elders, population, sum_born, sum_dies\n");

// repeat generations
	do {

// this generation
		n++;

// born in this generation
		p4 = p2 / 2 * ( 1.0 - singles) * childs;

// all born
		p6 = p6 + p4; 
		
// all dead
		p5 = p5 + p3; 
		
// all elders
		p3 = p2;	

// all adults
		p2 = p1 * (1.0 - infants); 

// all childrens
		p1 = p4;	

// all status in csv

		printf ("%4d, %8ld, %8ld, %8ld, %8ld, %8ld, %8ld\n", 
				n, p1, p2, p3, p1+p2+p3, p5, p6);
// ends when
		} while (p1 > 0 && p1 < p0);

// ends all
	return (0);
	}

