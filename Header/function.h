//
// Created by Matteo on 09/09/2024.
//

#ifndef FUNCTION_H
#define FUNCTION_H
#include "type.h"

ssize_t my_getline(char **, size_t *, FILE *);
MetaCommandResult do_meta_command(InputBuffer*, Table*);
PrepareResult prepare_insert(InputBuffer*, Statement*);
PrepareResult prepare_statement(InputBuffer*, Statement*);
InputBuffer* new_input_buffer();
void print_prompt();
void print_row(Row*);
void read_input(InputBuffer*);
void close_input_buffer(InputBuffer*);
ExecuteResult execute_insert(Statement*, Table*);
ExecuteResult execute_select(Statement*, Table*);
ExecuteResult execute_statement(Statement*, Table*);
void* get_page(Pager*, uint32_t);
void pager_flush(Pager*, uint32_t, uint32_t);
void serialize_row(Row*, void*);
void deserialize_row(void*, Row*);
void* row_slot(Table*, uint32_t);
Pager* pager_open(const char *);
Table* db_open(const char *);
void db_close(Table*);



#endif //FUNCTION_H
