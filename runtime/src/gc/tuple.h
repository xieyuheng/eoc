#pragma once

void tuple_init(tuple_t *self, size_t size);
tuple_t *tuple_new(size_t size, gc_t *gc);

size_t tuple_size(tuple_t *self);

bool tuple_is_atom_index(tuple_t *self, size_t index);
bool tuple_is_object_index(tuple_t *self, size_t index);

void tuple_set_object(tuple_t *self, size_t index, void *object);
void tuple_set_atom(tuple_t *self, size_t index, int64_t atom);
