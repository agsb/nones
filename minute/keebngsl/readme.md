
## t a o e h n d i b f s r y l w u c m p g k v j x q z

With the sequence of keys from frequency analysis, the ngsl list of words 2809 with ppm, and number of keys, 12 without thumbs and pinkies) defined by design, can do some tests for eval the layouts.

### layouts

the layouts ared defined by a weight and a sequence of keys

1. data as "word ppm" from 

        ngls    ngsl-1.2 
        ngrf    google books n-gram, full
        ngrp    google books n-gram, only > 1

2. results for char (key)
    
        2.1 absolute counter, summing all events of any single char
        2.2 relative counter, as 2.1 weight by events of words with it
        2.3 effort counter, as 2.2 weighted by effort of keyboard layout used

#### layout 1

Used as reference for values
 
    1 t a o e h n d i b f r s y l w u c m p g k v j x q z 

#### layout 2

no reserved keys for actions, 12 keys for layers

    = layer 1 
    1 t a o e h n d i b f r s
    = layer 2 
    2 y l w u c m p g k v j x
    = layer 3 
    3 q z

#### layout 3

reserves two keys in secondary layers,  12, 10, 4 keys

    = layer 1 
    1 t a o e h n d i b f r s
    = layer 2 
    2 y l w u c m p g k v
    = layer 3 
    3 j x q z 

#### layout 4

reserves two keys in each layer for actions, 10 keys for layer

    = layer 1 
    1 t a o e h n d i b f 
    = layer 2 
    2 r s y l w u c m p g 
    = layer 3 
    3 k v j x q z 

#### layout 5 

No reserved keys, each by row and layers, moves 12 keys for layer

    = layer 0 home row
    1 t a o e h n 
    = layer 0 upper row
    2 d i b f r s
    = layer 1 home row
    3 y l w u c m
    = layer 1 upper row
    4 p g k v j x 
    = layer 2 home row
    5 q z 

#### layout 6 

No reserved keys, each by row and layers, moves 10 keys for layer

    = layer 0 home row
    1 t a o e h  
    = layer 0 upper row
    2 n d i b f 
    = layer 1 home row
    3 r s y l w 
    = layer 1 upper row
    4 u c m p g  
    = layer 2 home row
    5 k v j x q 
    = layer 2 upper row
    6 z 

## results

#### For NGSL 

| layout | ppm clicks | over | notes | 
| --- | --- | -- | --- | 
| 1 | 3307643 | 1.0000 | one layer, all keys load 1, reference counter |
| 2 | 4048216 | 1.2238 | 3 layers, 12/12/2, loads 1, 2, 3 |
| 3 | 4058368 | 1.2270 | 3 layers, 12/10/4, loads 1, 2, 3 |
| 4 | 4441992 | 1.3429 | 3 layers, 10/10/6, loads 1, 2, 3 |
| 5 | 5770272 | 1.7445 | 3 layers, 12/12/2, loads by row/layer 1, 2, 3 |
| 6 | 6639137 | 2.0072 | 3 layers, 10/10/6, loads by row/layer 1, 2, 3 |
| 7 | 4043904 | 1.2226 | 3 layers, same loads for 2 and 3 |
| | | | 

