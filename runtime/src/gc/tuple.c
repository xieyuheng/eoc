#include "index.h"

typedef void *header_t;

void
tuple_init(tuple_t *self, size_t size) {
    assert(size <= 50);
    uint64_t forwarding_bits = 1;
    uint64_t length_bits = size << 1;
    header_t header = (header_t) (length_bits | forwarding_bits);
    self[0] = header;
}

tuple_t *
tuple_new(size_t size) {
    tuple_t *self = allocate_pointers(size + 1);
    tuple_init(self, size);
    return self;
}

size_t
tuple_size(tuple_t *self) {
    header_t header = self[0];
    uint64_t low_byte = ((uint64_t) header) & ((uint64_t) 0xff);
    return low_byte >> 1;
}
