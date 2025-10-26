#pragma once

gc_t *gc_new(size_t root_size, size_t heap_size);

tuple_t *gc_allocate_tuple(gc_t* self, size_t size);
