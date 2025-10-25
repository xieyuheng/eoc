#include "index.h"

value_t* gc_free_ptr = NULL;
value_t* gc_from_space_begin = NULL;
value_t* gc_from_space_end = NULL;
value_t** gc_root_stack_begin = NULL;
