//
// Created by Matteo on 09/09/2024.
//

#ifndef FUNCTION_H
#define FUNCTION_H
#include "type.h"
#include "constants.h"

ssize_t my_getline(char **, size_t *, FILE *);
void print_row(Row*);
uint32_t* leaf_node_num_cells(void*);
void* leaf_node_cell(void*, uint32_t);
uint32_t* leaf_node_key(void*, uint32_t);
void* leaf_node_value(void*, uint32_t);
void print_constants();
void print_leaf_node(void*);
void serialize_row(Row*, void*);
void deserialize_row(void*, Row*);
void initialize_leaf_node(void*);
void* get_page(Pager*, uint32_t);
Cursor* table_start(Table*);
Cursor* table_end(Table*);
void* cursor_value(Cursor*);
void cursor_advance(Cursor*);
Pager* pager_open(const char *);
Table* db_open(const char *);
InputBuffer* new_input_buffer();
void close_input_buffer(InputBuffer*);
void print_prompt();
void read_input(InputBuffer*);
void pager_flush(Pager*, uint32_t);
void db_close(Table*);
MetaCommandResult do_meta_command(InputBuffer*, Table*);
PrepareResult prepare_insert(InputBuffer*, Statement*);
PrepareResult prepare_statement(InputBuffer*, Statement*);
void leaf_node_insert(Cursor*, uint32_t, Row*);
ExecuteResult execute_insert(Statement*, Table*);
ExecuteResult execute_select(Statement*, Table*);
ExecuteResult execute_statement(Statement*, Table*);

#endif //FUNCTION_H
