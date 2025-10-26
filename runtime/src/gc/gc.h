#pragma once

gc_t *gc_new(size_t root_size, size_t heap_size);

tuple_t *gc_allocate_tuple(gc_t* self, size_t size);
void gc_expose_root_space(gc_t* self, void ***root_space_pointer, void ***root_pointer_pointer);
