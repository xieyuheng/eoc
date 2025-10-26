#pragma once

void tuple_init(tuple_t *self, size_t size);
tuple_t *tuple_new(size_t size, gc_t *gc);

size_t tuple_size(tuple_t *self);
