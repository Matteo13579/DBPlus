//
// Created by Matteo on 09/09/2024.
//

#ifndef FUNCTION_H
#define FUNCTION_H
#include "type.h"
#include "constants.h"

//  My Getline for user input
ssize_t my_getline(char **, size_t *, FILE *);

//  Prints db constants
void print_constants();

//  Prints db prompt
void print_prompt();

//  Command selection section
MetaCommandResult do_meta_command(InputBuffer*, Table*);

//  Node Typing section
NodeType get_node_type(void*);
void set_node_type(void*, NodeType);
uint32_t get_node_max_key(void*);

//  Root Node section
void create_new_root(Table*, uint32_t);
bool is_node_root(void*);
void set_node_root(void*, bool);

//  Paging management
Pager* pager_open(const char *);
void* get_page(Pager*, uint32_t);
uint32_t get_unused_page_num(Pager*);
void pager_flush(Pager*, uint32_t);


//  Internal Node section
uint32_t* internal_node_num_keys(void*);
uint32_t* internal_node_right_child(void*);
uint32_t* internal_node_cell(void*, uint32_t);
uint32_t* internal_node_child(void*, uint32_t);
uint32_t* internal_node_key(void*, uint32_t);
Cursor* internal_node_find(Table*, uint32_t, uint32_t);
void initialize_internal_node(void*);

//  Leaf Node section
uint32_t* leaf_node_num_cells(void*);
void* leaf_node_cell(void*, uint32_t);
uint32_t* leaf_node_key(void*, uint32_t);
void* leaf_node_value(void*, uint32_t);
Cursor* leaf_node_find(Table*, uint32_t, uint32_t);
void leaf_node_split_and_insert(Cursor*, uint32_t, Row*);
void leaf_node_insert(Cursor*, uint32_t, Row*);
void initialize_leaf_node(void*);
// void print_leaf_node(void*);
void indent(uint32_t);
void print_tree(Pager*, uint32_t, uint32_t);

//  Input buffer management
InputBuffer* new_input_buffer();
void read_input(InputBuffer*);
void close_input_buffer(InputBuffer*);

//  Table management
Cursor* table_start(Table*);
Cursor* table_find(Table*, uint32_t);
void* cursor_value(Cursor*);
void cursor_advance(Cursor*);
void serialize_row(Row*, void*);
void deserialize_row(void*, Row*);
void print_row(Row*);

//  DB connection management
Table* db_open(const char *);
void db_close(Table*);

//  Prepare statement section
PrepareResult prepare_insert(InputBuffer*, Statement*);
PrepareResult prepare_statement(InputBuffer*, Statement*);

//  Execute section
ExecuteResult execute_insert(Statement*, Table*);
ExecuteResult execute_select(Statement*, Table*);
ExecuteResult execute_statement(Statement*, Table*);

#endif //FUNCTION_H
