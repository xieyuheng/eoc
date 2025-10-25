#include "index.h"

typedef uint64_t header_t;

tuple_t *
tuple_new(size_t size) {
    assert(size <= 50);
    tuple_t *self = allocate_pointers(size + 1);
    uint64_t forwarding_bits = 1;
    uint64_t length_bits = size << 1;
    header_t header = length_bits | forwarding_bits;
    self[0] = header;
    return self;
}
