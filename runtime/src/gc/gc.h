#pragma once

gc_t *gc_new(size_t root_size, size_t heap_size);

tuple_t *gc_allocate_tuple(gc_t* self, size_t size);

void gc_expose_root_space(gc_t* self, void ***root_space_pointer);
void gc_set_root_pointer(gc_t* self, void **root_pointer);
size_t gc_root_length(gc_t* self);

// stack API only for testing
void gc_push_root(gc_t* self, tuple_t *tuple);
tuple_t *gc_pop_root(gc_t* self);
