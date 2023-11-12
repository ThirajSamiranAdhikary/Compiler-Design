#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 100 // size of hash table and it is constant value of 100

// hash table structure with key and value, defined another struct to chaining
typedef struct Entry
{
    char *type; // variable type
    char *key;
    int value;
    struct Entry *next;
} Entry;

// Define the hash table of size 100, at this momenet hash table is empty
Entry *table[SIZE] = {NULL};

// Hash function to calculate hash value for the key
unsigned int hash(const char *key)
{
    unsigned int hash = 0;
    while (*key) // iterate through all the characters of the key
    {
        hash = (hash * 31) + *key; // multify by 31 to increase the randomness
        key++;
    }
    return hash % SIZE;
}

// Insert a key-value pair into the hash table
void insert(const char *type, const char *key, int value)
{
    unsigned int index = hash(key); // calculating hash value

    Entry *newEntry = (Entry *)malloc(sizeof(Entry)); // creating new entry and dynamically allocate memory for new entry
    newEntry->type = strdup(type);
    newEntry->key = strdup(key); // creating copy of key. So can change the value without effecting original key value.
    newEntry->value = value;
    newEntry->next = NULL;

    newEntry->next = table[index]; // linking newEntry with next structure
    table[index] = newEntry;       // newEntry is the head of the linked list
}

// Retrieve the value associated with a key
int get(const char *key)
{
    unsigned int index = hash(key);
    Entry *entry = table[index];

    while (entry != NULL) // traverse through the linked list
    {
        if (strcmp(entry->key, key) == 0) // string comparison
        {
            return entry->value;
        }
        entry = entry->next;
    }

    return -1; // Key not found
}

int main()
{

    return 0;
}
