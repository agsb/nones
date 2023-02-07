/*
  https://chat.openai.com/chat
$ gcc -o parse-words parse-words.c
$ ./parse-words "the quick brown fox jumps over the lazy dog" fox
fox occurs at index 4 in the list.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
  // Check if we have the correct number of arguments
  if (argc != 3) {
    printf("Usage: %s <line> <word>\n", argv[0]);
    return 1;
  }

  // Get the line and word from the command line arguments
  char *line = argv[1];
  char *word = argv[2];

  // Create a list of words from the line
  char *list[1024] = { 0 };
  char *p = strtok(line, " ");
  int i = 0;
  while (p != NULL) {
    list[i++] = p;
    p = strtok(NULL, " ");
  }

  // Search the list for the word and print its index
  for (i = 0; i < 1024 && list[i] != NULL; i++) {
    if (strcmp(list[i], word) == 0) {
      printf("%s occurs at index %d in the list.\n", word, i);
      return 0;
    }
  }

  // If the word is not in the list, print an error message
  printf("%s does not occur in the list.\n", word);
  return 0;
}

