


Empty Planet Simulation

The program simulates population growth hypotheses, using 3 age groups, children, adults and elderly, calculating the variations of these groups each generation, using the number of children per couple, percentage of unmarried adults and infant mortality.

The evaluation ends when there are no children or when the number of children exceeds the original population.

Information on the number of the original population, percentages of children, adults and the elderly, number of children per couple, percentage of unmarried adults and percentage of infant mortality are required.

The representation in years for each generation, usually 20 to 25 years or group ages( < 15, 15 a 65, 65 < ), is not specific to the algorithm, only the capacity or not of reproduction.

Basically, with each generation: The number of children is calculated by multiplying half of adults by the number of children and by the proportion of couples; The number of adults is calculated by the multiplication of the children adjusted to the index of infant mortality; The number of elderly and children is accumulated in each generation.

The program is not meant to be accurate or comprehensive, just the simplified demonstration of results.

EXAMPLE: for a population of 7000, 0.43 of childrens, 0.43 of adults and 0.14 of elders, with two childrens by couple, 0.30 of unmarried adults and 0.001 of infant mortality

echo "7000 0.43 0.43 0.14 2 0.30 0.001" | emppty > data.csv

spoiller: with .30 unmarried must be a 2.86 childrens per couple rate to survive 3008 generations.

for real factors https://data.worldbank.org/indicator/SP.DYN.TFRT.IN https://ourworldindata.org/fertility-rate https://www.cia.gov/library/publications/the-world-factbook/rankorder/2127rank.html https://www.bbc.com/news/world-39211144

