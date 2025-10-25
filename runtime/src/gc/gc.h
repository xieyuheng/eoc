#pragma once

extern object_t** gc_root_stack_begin;
extern object_t** gc_root_stack_end;

extern object_t* gc_free_pointer;

extern object_t* gc_from_space_begin;
extern object_t* gc_from_space_end;

void gc_initialize(size_t root_stack_size, size_t heap_size);
