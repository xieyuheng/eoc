#pragma once

extern void **gc_root_stack_begin;
extern void **gc_root_stack_end;

extern void **gc_from_space_begin;
extern void **gc_from_space_end;

extern void **gc_free_pointer;

// size in word (64 bits (not byte))
void gc_initialize(size_t root_stack_size, size_t heap_size);
void gc_collect(void **root_stack_pointer, size_t size);
