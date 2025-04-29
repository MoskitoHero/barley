# Benchmarks

These benchmarks compare Barley and Barley with cache to:
- Alba
- AMS
- Blueprinter
- FastSerializer
- JSerializer
- Panko
- Rails
- Representable
- SimpleAMS
- Turbostreamer

They run against:
- a collection of objects to serialize
- a single result

With these options:
- YJIT on/off
- OJ Rails optimization on/off

## Results

### Collection - Ruby 3.4.3, YJIT enabled

```shell
bundle exec ruby collection.rb
```

```shell
ruby 3.4.3 (2025-04-14 revision d0b7e5b6a0) +YJIT +PRISM [x86_64-linux]
Warming up --------------------------------------
                alba    42.000 i/100ms
alba_with_transformation
                        26.000 i/100ms
         alba_inline     2.000 i/100ms
                 ams     1.000 i/100ms
              barley    46.000 i/100ms
        barley_cache    41.000 i/100ms
         blueprinter    12.000 i/100ms
     fast_serializer    15.000 i/100ms
         jserializer    26.000 i/100ms
               panko    55.000 i/100ms
               rails    13.000 i/100ms
       representable     6.000 i/100ms
          simple_ams     4.000 i/100ms
       turbostreamer    37.000 i/100ms
Calculating -------------------------------------
                alba    401.119 (± 1.7%) i/s    (2.49 ms/i) -      2.016k in   5.027350s
alba_with_transformation
                        256.123 (± 1.2%) i/s    (3.90 ms/i) -      1.300k in   5.076497s
         alba_inline     22.749 (± 8.8%) i/s   (43.96 ms/i) -    114.000 in   5.049973s
                 ams     16.923 (± 5.9%) i/s   (59.09 ms/i) -     85.000 in   5.029061s
              barley    427.045 (± 2.6%) i/s    (2.34 ms/i) -      2.162k in   5.066130s
        barley_cache    378.285 (± 2.4%) i/s    (2.64 ms/i) -      1.927k in   5.097462s
         blueprinter    120.704 (± 1.7%) i/s    (8.28 ms/i) -    612.000 in   5.071371s
     fast_serializer    142.347 (± 1.4%) i/s    (7.03 ms/i) -    720.000 in   5.058924s
         jserializer    252.455 (± 1.6%) i/s    (3.96 ms/i) -      1.274k in   5.047584s
               panko    510.262 (± 4.7%) i/s    (1.96 ms/i) -      2.585k in   5.077381s
               rails    107.589 (± 7.4%) i/s    (9.29 ms/i) -    546.000 in   5.104715s
       representable     50.264 (± 6.0%) i/s   (19.89 ms/i) -    252.000 in   5.027987s
          simple_ams     36.584 (± 5.5%) i/s   (27.33 ms/i) -    184.000 in   5.054347s
       turbostreamer    351.551 (± 1.7%) i/s    (2.84 ms/i) -      1.776k in   5.053401s

Comparison:
               panko:      510.3 i/s
              barley:      427.0 i/s - 1.19x  slower
                alba:      401.1 i/s - 1.27x  slower
        barley_cache:      378.3 i/s - 1.35x  slower
       turbostreamer:      351.6 i/s - 1.45x  slower
alba_with_transformation:      256.1 i/s - 1.99x  slower
         jserializer:      252.5 i/s - 2.02x  slower
     fast_serializer:      142.3 i/s - 3.58x  slower
         blueprinter:      120.7 i/s - 4.23x  slower
               rails:      107.6 i/s - 4.74x  slower
       representable:       50.3 i/s - 10.15x  slower
          simple_ams:       36.6 i/s - 13.95x  slower
         alba_inline:       22.7 i/s - 22.43x  slower
                 ams:       16.9 i/s - 30.15x  slower

Calculating -------------------------------------
                alba   818.241k memsize (     0.000  retained)
                         9.807k objects (     0.000  retained)
                         6.000  strings (     0.000  retained)
alba_with_transformation
                       818.181k memsize (     0.000  retained)
                         9.808k objects (     0.000  retained)
                         6.000  strings (     0.000  retained)
         alba_inline     2.736M memsize (     0.000  retained)
                        21.504k objects (     0.000  retained)
                        36.000  strings (     0.000  retained)
                 ams     4.713M memsize (     0.000  retained)
                        53.241k objects (     0.000  retained)
                         8.000  strings (     0.000  retained)
              barley   633.521k memsize (     0.000  retained)
                         5.603k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
        barley_cache   849.521k memsize (     0.000  retained)
                         7.403k objects (     0.000  retained)
                        50.000  strings (     0.000  retained)
         blueprinter     2.298M memsize (     0.000  retained)
                        32.505k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
     fast_serializer     1.470M memsize (     0.000  retained)
                        13.807k objects (     0.000  retained)
                         3.000  strings (     0.000  retained)
         jserializer   822.281k memsize (    16.000k retained)
                        10.009k objects (   100.000  retained)
                         2.000  strings (     0.000  retained)
               panko   259.178k memsize (     0.000  retained)
                         3.033k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
               rails     2.758M memsize (     0.000  retained)
                        28.508k objects (     0.000  retained)
                         6.000  strings (     0.000  retained)
       representable     5.151M memsize (     0.000  retained)
                        36.822k objects (     0.000  retained)
                         8.000  strings (     0.000  retained)
          simple_ams     9.017M memsize (     0.000  retained)
                        68.006k objects (     0.000  retained)
                         5.000  strings (     0.000  retained)
       turbostreamer   641.760k memsize (     0.000  retained)
                         9.742k objects (     0.000  retained)
                        33.000  strings (     0.000  retained)

Comparison:
               panko:     259178 allocated
              barley:     633521 allocated - 2.44x more
       turbostreamer:     641760 allocated - 2.48x more
alba_with_transformation:     818181 allocated - 3.16x more
                alba:     818241 allocated - 3.16x more
         jserializer:     822281 allocated - 3.17x more
        barley_cache:     849521 allocated - 3.28x more
     fast_serializer:    1470121 allocated - 5.67x more
         blueprinter:    2297921 allocated - 8.87x more
         alba_inline:    2736041 allocated - 10.56x more
               rails:    2757857 allocated - 10.64x more
                 ams:    4713401 allocated - 18.19x more
       representable:    5151321 allocated - 19.88x more
          simple_ams:    9017033 allocated - 34.79x more
Gem versions:
active_model_serializers: 0.10.15
alba: 3.6.0
barley: 0.9.0
blueprinter: 1.1.2
jserializer: 0.2.1
panko_serializer: 0.8.3
representable: 3.2.0
simple_ams: 0.2.6
turbostreamer: 1.11.0
```

### Collection - Ruby 3.4.3, YJIT disabled

```shell
NO_YJIT=1 bundle exec ruby collection.rb
```

```shell
ruby 3.4.3 (2025-04-14 revision d0b7e5b6a0) +PRISM [x86_64-linux]
Warming up --------------------------------------
                alba    17.000 i/100ms
alba_with_transformation
                        15.000 i/100ms
         alba_inline     4.000 i/100ms
                 ams     1.000 i/100ms
              barley    24.000 i/100ms
        barley_cache    29.000 i/100ms
         blueprinter     6.000 i/100ms
     fast_serializer     7.000 i/100ms
         jserializer    15.000 i/100ms
               panko    35.000 i/100ms
               rails     7.000 i/100ms
       representable     3.000 i/100ms
          simple_ams     2.000 i/100ms
       turbostreamer    14.000 i/100ms
Calculating -------------------------------------
                alba    143.906 (± 6.3%) i/s    (6.95 ms/i) -    731.000 in   5.098654s
alba_with_transformation
                        132.084 (± 9.1%) i/s    (7.57 ms/i) -    660.000 in   5.040655s
         alba_inline     40.872 (± 4.9%) i/s   (24.47 ms/i) -    204.000 in   5.004669s
                 ams     10.383 (± 9.6%) i/s   (96.31 ms/i) -     52.000 in   5.026124s
              barley    214.528 (± 9.8%) i/s    (4.66 ms/i) -      1.080k in   5.086194s
        barley_cache    225.495 (± 2.2%) i/s    (4.43 ms/i) -      1.131k in   5.017775s
         blueprinter     54.560 (± 1.8%) i/s   (18.33 ms/i) -    276.000 in   5.059682s
     fast_serializer     60.323 (± 1.7%) i/s   (16.58 ms/i) -    308.000 in   5.107386s
         jserializer    118.297 (± 1.7%) i/s    (8.45 ms/i) -    600.000 in   5.073970s
               panko    278.549 (± 3.6%) i/s    (3.59 ms/i) -      1.400k in   5.032999s
               rails     62.625 (± 1.6%) i/s   (15.97 ms/i) -    315.000 in   5.031389s
       representable     32.185 (± 3.1%) i/s   (31.07 ms/i) -    162.000 in   5.036340s
          simple_ams     24.350 (±12.3%) i/s   (41.07 ms/i) -    120.000 in   5.000797s
       turbostreamer    155.409 (± 2.6%) i/s    (6.43 ms/i) -    784.000 in   5.048204s

Comparison:
               panko:      278.5 i/s
        barley_cache:      225.5 i/s - 1.24x  slower
              barley:      214.5 i/s - 1.30x  slower
       turbostreamer:      155.4 i/s - 1.79x  slower
                alba:      143.9 i/s - 1.94x  slower
alba_with_transformation:      132.1 i/s - 2.11x  slower
         jserializer:      118.3 i/s - 2.35x  slower
               rails:       62.6 i/s - 4.45x  slower
     fast_serializer:       60.3 i/s - 4.62x  slower
         blueprinter:       54.6 i/s - 5.11x  slower
         alba_inline:       40.9 i/s - 6.82x  slower
       representable:       32.2 i/s - 8.65x  slower
          simple_ams:       24.3 i/s - 11.44x  slower
                 ams:       10.4 i/s - 26.83x  slower

Calculating -------------------------------------
                alba   818.241k memsize (     0.000  retained)
                         9.807k objects (     0.000  retained)
                         6.000  strings (     0.000  retained)
alba_with_transformation
                       818.181k memsize (     0.000  retained)
                         9.808k objects (     0.000  retained)
                         6.000  strings (     0.000  retained)
         alba_inline     2.736M memsize (     0.000  retained)
                        21.504k objects (     0.000  retained)
                        36.000  strings (     0.000  retained)
                 ams     4.713M memsize (     0.000  retained)
                        53.241k objects (     0.000  retained)
                         8.000  strings (     0.000  retained)
              barley   633.521k memsize (     0.000  retained)
                         5.603k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
        barley_cache   853.161k memsize (     0.000  retained)
                         7.494k objects (     0.000  retained)
                        50.000  strings (     0.000  retained)
         blueprinter     2.298M memsize (     0.000  retained)
                        32.505k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
     fast_serializer     1.470M memsize (     0.000  retained)
                        13.807k objects (     0.000  retained)
                         3.000  strings (     0.000  retained)
         jserializer   822.281k memsize (    16.000k retained)
                        10.009k objects (   100.000  retained)
                         2.000  strings (     0.000  retained)
               panko   259.178k memsize (     0.000  retained)
                         3.033k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
               rails     2.758M memsize (     0.000  retained)
                        28.508k objects (     0.000  retained)
                         6.000  strings (     0.000  retained)
       representable     5.151M memsize (     0.000  retained)
                        36.822k objects (     0.000  retained)
                         8.000  strings (     0.000  retained)
          simple_ams     9.017M memsize (     0.000  retained)
                        68.006k objects (     0.000  retained)
                         5.000  strings (     0.000  retained)
       turbostreamer   641.760k memsize (     0.000  retained)
                         9.742k objects (     0.000  retained)
                        33.000  strings (     0.000  retained)

Comparison:
               panko:     259178 allocated
              barley:     633521 allocated - 2.44x more
       turbostreamer:     641760 allocated - 2.48x more
alba_with_transformation:     818181 allocated - 3.16x more
                alba:     818241 allocated - 3.16x more
         jserializer:     822281 allocated - 3.17x more
        barley_cache:     853161 allocated - 3.29x more
     fast_serializer:    1470121 allocated - 5.67x more
         blueprinter:    2297921 allocated - 8.87x more
         alba_inline:    2736041 allocated - 10.56x more
               rails:    2757857 allocated - 10.64x more
                 ams:    4713401 allocated - 18.19x more
       representable:    5151321 allocated - 19.88x more
          simple_ams:    9017033 allocated - 34.79x more
Gem versions:
active_model_serializers: 0.10.15
alba: 3.6.0
barley: 0.9.0
blueprinter: 1.1.2
jserializer: 0.2.1
panko_serializer: 0.8.3
representable: 3.2.0
simple_ams: 0.2.6
turbostreamer: 1.11.0
```

### Collection - Ruby 3.4.3, YJIT enabled, OJ rails optimizations disabled

```shell
NO_OJ_OPTIMIZE_RAILS=1 bundle exec ruby collection.rb
```

```shell
ruby 3.4.3 (2025-04-14 revision d0b7e5b6a0) +YJIT +PRISM [x86_64-linux]
Warming up --------------------------------------
                alba    47.000 i/100ms
alba_with_transformation
                        29.000 i/100ms
         alba_inline     2.000 i/100ms
                 ams     1.000 i/100ms
              barley    31.000 i/100ms
        barley_cache    31.000 i/100ms
         blueprinter    11.000 i/100ms
     fast_serializer    15.000 i/100ms
         jserializer    25.000 i/100ms
               panko    53.000 i/100ms
               rails    12.000 i/100ms
       representable     6.000 i/100ms
          simple_ams     4.000 i/100ms
       turbostreamer    36.000 i/100ms
Calculating -------------------------------------
                alba    438.505 (± 0.9%) i/s    (2.28 ms/i) -      2.209k in   5.038043s
alba_with_transformation
                        289.236 (± 1.7%) i/s    (3.46 ms/i) -      1.450k in   5.015160s
         alba_inline     23.037 (± 4.3%) i/s   (43.41 ms/i) -    116.000 in   5.052127s
                 ams     17.363 (± 5.8%) i/s   (57.59 ms/i) -     87.000 in   5.015527s
              barley    316.346 (± 2.2%) i/s    (3.16 ms/i) -      1.612k in   5.098273s
        barley_cache    303.553 (± 1.3%) i/s    (3.29 ms/i) -      1.519k in   5.004760s
         blueprinter    121.280 (± 0.8%) i/s    (8.25 ms/i) -    616.000 in   5.079878s
     fast_serializer    141.963 (± 9.2%) i/s    (7.04 ms/i) -    705.000 in   5.016072s
         jserializer    216.639 (±10.2%) i/s    (4.62 ms/i) -      1.075k in   5.010811s
               panko    488.281 (± 8.8%) i/s    (2.05 ms/i) -      2.438k in   5.037696s
               rails     92.965 (± 9.7%) i/s   (10.76 ms/i) -    468.000 in   5.108527s
       representable     55.370 (± 1.8%) i/s   (18.06 ms/i) -    282.000 in   5.095844s
          simple_ams     31.325 (± 6.4%) i/s   (31.92 ms/i) -    156.000 in   5.002733s
       turbostreamer    289.988 (± 5.5%) i/s    (3.45 ms/i) -      1.476k in   5.105071s

Comparison:
               panko:      488.3 i/s
                alba:      438.5 i/s - 1.11x  slower
              barley:      316.3 i/s - 1.54x  slower
        barley_cache:      303.6 i/s - 1.61x  slower
       turbostreamer:      290.0 i/s - 1.68x  slower
alba_with_transformation:      289.2 i/s - 1.69x  slower
         jserializer:      216.6 i/s - 2.25x  slower
     fast_serializer:      142.0 i/s - 3.44x  slower
         blueprinter:      121.3 i/s - 4.03x  slower
               rails:       93.0 i/s - 5.25x  slower
       representable:       55.4 i/s - 8.82x  slower
          simple_ams:       31.3 i/s - 15.59x  slower
         alba_inline:       23.0 i/s - 21.20x  slower
                 ams:       17.4 i/s - 28.12x  slower

Calculating -------------------------------------
                alba   642.121k memsize (     0.000  retained)
                         5.406k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
alba_with_transformation
                       642.061k memsize (     0.000  retained)
                         5.407k objects (     0.000  retained)
                         3.000  strings (     0.000  retained)
         alba_inline     2.560M memsize (     0.000  retained)
                        17.103k objects (     0.000  retained)
                        32.000  strings (     0.000  retained)
                 ams     5.115M memsize (     0.000  retained)
                        55.544k objects (     0.000  retained)
                         8.000  strings (     0.000  retained)
              barley     1.035M memsize (     0.000  retained)
                         7.906k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
        barley_cache     1.251M memsize (     0.000  retained)
                         9.706k objects (     0.000  retained)
                        50.000  strings (     0.000  retained)
         blueprinter     2.298M memsize (     0.000  retained)
                        32.504k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
     fast_serializer     1.470M memsize (     0.000  retained)
                        13.806k objects (     0.000  retained)
                         3.000  strings (     0.000  retained)
         jserializer   822.161k memsize (    16.000k retained)
                        10.008k objects (   100.000  retained)
                         2.000  strings (     0.000  retained)
               panko   259.178k memsize (     0.000  retained)
                         3.033k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
               rails     3.151M memsize (     0.000  retained)
                        30.611k objects (     0.000  retained)
                         6.000  strings (     0.000  retained)
       representable     5.151M memsize (     0.000  retained)
                        36.822k objects (     0.000  retained)
                         8.000  strings (     0.000  retained)
          simple_ams     9.418M memsize (     0.000  retained)
                        70.309k objects (     0.000  retained)
                         5.000  strings (     0.000  retained)
       turbostreamer   641.760k memsize (     0.000  retained)
                         9.742k objects (     0.000  retained)
                        33.000  strings (     0.000  retained)

Comparison:
               panko:     259178 allocated
       turbostreamer:     641760 allocated - 2.48x more
alba_with_transformation:     642061 allocated - 2.48x more
                alba:     642121 allocated - 2.48x more
         jserializer:     822161 allocated - 3.17x more
              barley:    1034681 allocated - 3.99x more
        barley_cache:    1250681 allocated - 4.83x more
     fast_serializer:    1470001 allocated - 5.67x more
         blueprinter:    2297801 allocated - 8.87x more
         alba_inline:    2559921 allocated - 9.88x more
               rails:    3151017 allocated - 12.16x more
                 ams:    5114561 allocated - 19.73x more
       representable:    5151321 allocated - 19.88x more
          simple_ams:    9418193 allocated - 36.34x more
Gem versions:
active_model_serializers: 0.10.15
alba: 3.6.0
barley: 0.9.0
blueprinter: 1.1.2
jserializer: 0.2.1
panko_serializer: 0.8.3
representable: 3.2.0
simple_ams: 0.2.6
turbostreamer: 1.11.0
```

### Collection - Ruby 3.4.3, YJIT disabled, OJ rails optimizations disabled

```shell
NO_YJIT=1 NO_OJ_OPTIMIZE_RAILS=1 bundle exec ruby collection.rb
```

```shell
ruby 3.4.3 (2025-04-14 revision d0b7e5b6a0) +PRISM [x86_64-linux]
Warming up --------------------------------------
                alba    19.000 i/100ms
alba_with_transformation
                        16.000 i/100ms
         alba_inline     4.000 i/100ms
                 ams     1.000 i/100ms
              barley    16.000 i/100ms
        barley_cache    19.000 i/100ms
         blueprinter     7.000 i/100ms
     fast_serializer     7.000 i/100ms
         jserializer    16.000 i/100ms
               panko    37.000 i/100ms
               rails     7.000 i/100ms
       representable     4.000 i/100ms
          simple_ams     2.000 i/100ms
       turbostreamer    17.000 i/100ms
Calculating -------------------------------------
                alba    181.822 (± 3.3%) i/s    (5.50 ms/i) -    912.000 in   5.021805s
alba_with_transformation
                        164.904 (± 2.4%) i/s    (6.06 ms/i) -    832.000 in   5.047786s
         alba_inline     44.507 (± 4.5%) i/s   (22.47 ms/i) -    224.000 in   5.039383s
                 ams     11.966 (± 0.0%) i/s   (83.57 ms/i) -     60.000 in   5.016535s
              barley    166.765 (± 1.8%) i/s    (6.00 ms/i) -    848.000 in   5.086770s
        barley_cache    191.426 (± 1.6%) i/s    (5.22 ms/i) -    969.000 in   5.062893s
         blueprinter     71.002 (± 1.4%) i/s   (14.08 ms/i) -    357.000 in   5.029051s
     fast_serializer     77.705 (± 1.3%) i/s   (12.87 ms/i) -    392.000 in   5.046530s
         jserializer    157.884 (± 5.1%) i/s    (6.33 ms/i) -    800.000 in   5.080956s
               panko    294.080 (± 7.5%) i/s    (3.40 ms/i) -      1.480k in   5.062328s
               rails     56.849 (± 3.5%) i/s   (17.59 ms/i) -    287.000 in   5.058187s
       representable     31.213 (± 6.4%) i/s   (32.04 ms/i) -    156.000 in   5.027658s
          simple_ams     21.240 (± 9.4%) i/s   (47.08 ms/i) -    106.000 in   5.028641s
       turbostreamer    149.467 (± 9.4%) i/s    (6.69 ms/i) -    748.000 in   5.046793s

Comparison:
               panko:      294.1 i/s
        barley_cache:      191.4 i/s - 1.54x  slower
                alba:      181.8 i/s - 1.62x  slower
              barley:      166.8 i/s - 1.76x  slower
alba_with_transformation:      164.9 i/s - 1.78x  slower
         jserializer:      157.9 i/s - 1.86x  slower
       turbostreamer:      149.5 i/s - 1.97x  slower
     fast_serializer:       77.7 i/s - 3.78x  slower
         blueprinter:       71.0 i/s - 4.14x  slower
               rails:       56.8 i/s - 5.17x  slower
         alba_inline:       44.5 i/s - 6.61x  slower
       representable:       31.2 i/s - 9.42x  slower
          simple_ams:       21.2 i/s - 13.85x  slower
                 ams:       12.0 i/s - 24.58x  slower

Calculating -------------------------------------
                alba   642.121k memsize (     0.000  retained)
                         5.406k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
alba_with_transformation
                       642.061k memsize (     0.000  retained)
                         5.407k objects (     0.000  retained)
                         3.000  strings (     0.000  retained)
         alba_inline     2.560M memsize (     0.000  retained)
                        17.103k objects (     0.000  retained)
                        32.000  strings (     0.000  retained)
                 ams     5.115M memsize (     0.000  retained)
                        55.544k objects (     0.000  retained)
                         8.000  strings (     0.000  retained)
              barley     1.035M memsize (     0.000  retained)
                         7.906k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
        barley_cache     1.254M memsize (     0.000  retained)
                         9.797k objects (     0.000  retained)
                        50.000  strings (     0.000  retained)
         blueprinter     2.298M memsize (     0.000  retained)
                        32.504k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
     fast_serializer     1.470M memsize (     0.000  retained)
                        13.806k objects (     0.000  retained)
                         3.000  strings (     0.000  retained)
         jserializer   822.161k memsize (    16.000k retained)
                        10.008k objects (   100.000  retained)
                         2.000  strings (     0.000  retained)
               panko   259.178k memsize (     0.000  retained)
                         3.033k objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
               rails     3.151M memsize (     0.000  retained)
                        30.611k objects (     0.000  retained)
                         6.000  strings (     0.000  retained)
       representable     5.151M memsize (     0.000  retained)
                        36.822k objects (     0.000  retained)
                         8.000  strings (     0.000  retained)
          simple_ams     9.418M memsize (     0.000  retained)
                        70.309k objects (     0.000  retained)
                         5.000  strings (     0.000  retained)
       turbostreamer   641.760k memsize (     0.000  retained)
                         9.742k objects (     0.000  retained)
                        33.000  strings (     0.000  retained)

Comparison:
               panko:     259178 allocated
       turbostreamer:     641760 allocated - 2.48x more
alba_with_transformation:     642061 allocated - 2.48x more
                alba:     642121 allocated - 2.48x more
         jserializer:     822161 allocated - 3.17x more
              barley:    1034681 allocated - 3.99x more
        barley_cache:    1254321 allocated - 4.84x more
     fast_serializer:    1470001 allocated - 5.67x more
         blueprinter:    2297801 allocated - 8.87x more
         alba_inline:    2559921 allocated - 9.88x more
               rails:    3151017 allocated - 12.16x more
                 ams:    5114561 allocated - 19.73x more
       representable:    5151321 allocated - 19.88x more
          simple_ams:    9418193 allocated - 36.34x more
Gem versions:
active_model_serializers: 0.10.15
alba: 3.6.0
barley: 0.9.0
blueprinter: 1.1.2
jserializer: 0.2.1
panko_serializer: 0.8.3
representable: 3.2.0
simple_ams: 0.2.6
turbostreamer: 1.11.0
```

### Single resource - Ruby 3.4.3, YJIT enabled

```shell
NO_YJIT=1 bundle exec ruby single_resource.rb
```

```shell
ruby 3.4.3 (2025-04-14 revision d0b7e5b6a0) +YJIT +PRISM [x86_64-linux]
Warming up --------------------------------------
                alba     1.624k i/100ms
         alba_inline   147.000 i/100ms
                 ams     1.043k i/100ms
              barley     1.556k i/100ms
        barley_cache     6.186k i/100ms
         blueprinter     1.134k i/100ms
            jbuilder     1.449k i/100ms
         jserializer     1.546k i/100ms
               panko     1.534k i/100ms
               rails     8.945k i/100ms
       representable     1.142k i/100ms
          simple_ams   626.000 i/100ms
       turbostreamer     1.245k i/100ms
Calculating -------------------------------------
                alba     13.306k (±11.3%) i/s   (75.15 μs/i) -     66.584k in   5.065808s
         alba_inline      1.142k (±11.3%) i/s  (875.84 μs/i) -      5.733k in   5.080612s
                 ams      9.081k (± 9.1%) i/s  (110.11 μs/i) -     45.892k in   5.094621s
              barley     13.832k (± 5.0%) i/s   (72.30 μs/i) -     70.020k in   5.073633s
        barley_cache     53.811k (± 2.4%) i/s   (18.58 μs/i) -    272.184k in   5.061055s
         blueprinter     11.321k (± 4.8%) i/s   (88.33 μs/i) -     56.700k in   5.021209s
            jbuilder     11.855k (± 7.3%) i/s   (84.35 μs/i) -     59.409k in   5.044206s
         jserializer     12.982k (± 4.5%) i/s   (77.03 μs/i) -     64.932k in   5.012119s
               panko     12.885k (± 7.8%) i/s   (77.61 μs/i) -     64.428k in   5.027686s
               rails     98.330k (± 3.7%) i/s   (10.17 μs/i) -    491.975k in   5.010565s
       representable     11.770k (± 2.2%) i/s   (84.97 μs/i) -     59.384k in   5.048009s
          simple_ams      6.719k (± 2.6%) i/s  (148.83 μs/i) -     33.804k in   5.034372s
       turbostreamer     14.932k (± 2.9%) i/s   (66.97 μs/i) -     74.700k in   5.007180s

Comparison:
               rails:    98329.8 i/s
        barley_cache:    53811.0 i/s - 1.83x  slower
       turbostreamer:    14931.6 i/s - 6.59x  slower
              barley:    13832.0 i/s - 7.11x  slower
                alba:    13306.2 i/s - 7.39x  slower
         jserializer:    12982.4 i/s - 7.57x  slower
               panko:    12885.4 i/s - 7.63x  slower
            jbuilder:    11854.7 i/s - 8.29x  slower
       representable:    11769.5 i/s - 8.35x  slower
         blueprinter:    11321.2 i/s - 8.69x  slower
                 ams:     9081.5 i/s - 10.83x  slower
          simple_ams:     6719.1 i/s - 14.63x  slower
         alba_inline:     1141.8 i/s - 86.12x  slower

Calculating -------------------------------------
                alba    11.680k memsize (   480.000  retained)
                       164.000  objects (     6.000  retained)
                        11.000  strings (     0.000  retained)
         alba_inline    31.336k memsize (   480.000  retained)
                       280.000  objects (     6.000  retained)
                        41.000  strings (     0.000  retained)
                 ams    17.112k memsize (   480.000  retained)
                       221.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
              barley    10.560k memsize (   480.000  retained)
                       154.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
        barley_cache     3.600k memsize (    40.000  retained)
                        40.000  objects (     1.000  retained)
                        16.000  strings (     0.000  retained)
         blueprinter    13.200k memsize (   480.000  retained)
                       191.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
            jbuilder    12.640k memsize (   480.000  retained)
                       173.000  objects (     6.000  retained)
                        11.000  strings (     0.000  retained)
         jserializer    11.520k memsize (   640.000  retained)
                       166.000  objects (     7.000  retained)
                         7.000  strings (     0.000  retained)
               panko    10.880k memsize (   480.000  retained)
                       164.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
               rails     3.160k memsize (     0.000  retained)
                        32.000  objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
       representable    14.280k memsize (   480.000  retained)
                       185.000  objects (     6.000  retained)
                        14.000  strings (     0.000  retained)
          simple_ams    37.872k memsize (   480.000  retained)
                       405.000  objects (     6.000  retained)
                        10.000  strings (     0.000  retained)
       turbostreamer    11.448k memsize (   480.000  retained)
                       175.000  objects (     6.000  retained)
                        15.000  strings (     0.000  retained)

Comparison:
               rails:       3160 allocated
        barley_cache:       3600 allocated - 1.14x more
              barley:      10560 allocated - 3.34x more
               panko:      10880 allocated - 3.44x more
       turbostreamer:      11448 allocated - 3.62x more
         jserializer:      11520 allocated - 3.65x more
                alba:      11680 allocated - 3.70x more
            jbuilder:      12640 allocated - 4.00x more
         blueprinter:      13200 allocated - 4.18x more
       representable:      14280 allocated - 4.52x more
                 ams:      17112 allocated - 5.42x more
         alba_inline:      31336 allocated - 9.92x more
          simple_ams:      37872 allocated - 11.98x more
```

### Single resource - Ruby 3.4.3, YJIT disabled

```shell
NO_YJIT=1 bundle exec ruby single_resource.rb
```

```shell
ruby 3.4.3 (2025-04-14 revision d0b7e5b6a0) +PRISM [x86_64-linux]
Warming up --------------------------------------
                alba   644.000 i/100ms
         alba_inline   260.000 i/100ms
                 ams   491.000 i/100ms
              barley   678.000 i/100ms
        barley_cache     4.216k i/100ms
         blueprinter   555.000 i/100ms
            jbuilder   588.000 i/100ms
         jserializer   648.000 i/100ms
               panko   666.000 i/100ms
               rails     6.294k i/100ms
       representable   496.000 i/100ms
          simple_ams   359.000 i/100ms
       turbostreamer   570.000 i/100ms
Calculating -------------------------------------
                alba      6.329k (± 1.3%) i/s  (157.99 μs/i) -     32.200k in   5.088254s
         alba_inline      2.600k (± 6.5%) i/s  (384.65 μs/i) -     13.000k in   5.023371s
                 ams      4.831k (± 1.2%) i/s  (207.01 μs/i) -     24.550k in   5.082876s
              barley      6.445k (± 3.1%) i/s  (155.16 μs/i) -     32.544k in   5.054777s
        barley_cache     38.567k (± 3.1%) i/s   (25.93 μs/i) -    193.936k in   5.033288s
         blueprinter      5.032k (± 3.3%) i/s  (198.74 μs/i) -     25.530k in   5.079946s
            jbuilder      5.514k (± 1.7%) i/s  (181.37 μs/i) -     27.636k in   5.013691s
         jserializer      5.898k (± 1.5%) i/s  (169.54 μs/i) -     29.808k in   5.054687s
               panko      6.060k (± 1.8%) i/s  (165.01 μs/i) -     30.636k in   5.056961s
               rails     59.995k (± 2.6%) i/s   (16.67 μs/i) -    302.112k in   5.039091s
       representable      4.986k (± 1.8%) i/s  (200.55 μs/i) -     25.296k in   5.074826s
          simple_ams      3.482k (± 2.6%) i/s  (287.18 μs/i) -     17.591k in   5.055698s
       turbostreamer      5.976k (± 2.7%) i/s  (167.35 μs/i) -     30.210k in   5.059793s

Comparison:
               rails:    59995.1 i/s
        barley_cache:    38566.6 i/s - 1.56x  slower
              barley:     6445.1 i/s - 9.31x  slower
                alba:     6329.5 i/s - 9.48x  slower
               panko:     6060.2 i/s - 9.90x  slower
       turbostreamer:     5975.5 i/s - 10.04x  slower
         jserializer:     5898.4 i/s - 10.17x  slower
            jbuilder:     5513.7 i/s - 10.88x  slower
         blueprinter:     5031.6 i/s - 11.92x  slower
       representable:     4986.2 i/s - 12.03x  slower
                 ams:     4830.7 i/s - 12.42x  slower
          simple_ams:     3482.2 i/s - 17.23x  slower
         alba_inline:     2599.7 i/s - 23.08x  slower

Calculating -------------------------------------
                alba    11.680k memsize (   480.000  retained)
                       164.000  objects (     6.000  retained)
                        11.000  strings (     0.000  retained)
         alba_inline    31.336k memsize (   480.000  retained)
                       280.000  objects (     6.000  retained)
                        41.000  strings (     0.000  retained)
                 ams    17.112k memsize (   480.000  retained)
                       221.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
              barley    10.560k memsize (   480.000  retained)
                       154.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
        barley_cache     3.600k memsize (     0.000  retained)
                        40.000  objects (     0.000  retained)
                        15.000  strings (     0.000  retained)
         blueprinter    13.200k memsize (   480.000  retained)
                       191.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
            jbuilder    12.640k memsize (   480.000  retained)
                       173.000  objects (     6.000  retained)
                        11.000  strings (     0.000  retained)
         jserializer    11.520k memsize (   640.000  retained)
                       166.000  objects (     7.000  retained)
                         7.000  strings (     0.000  retained)
               panko    10.880k memsize (   480.000  retained)
                       164.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
               rails     3.160k memsize (     0.000  retained)
                        32.000  objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
       representable    14.280k memsize (   480.000  retained)
                       185.000  objects (     6.000  retained)
                        14.000  strings (     0.000  retained)
          simple_ams    37.872k memsize (   480.000  retained)
                       405.000  objects (     6.000  retained)
                        10.000  strings (     0.000  retained)
       turbostreamer    11.448k memsize (   480.000  retained)
                       175.000  objects (     6.000  retained)
                        15.000  strings (     0.000  retained)

Comparison:
               rails:       3160 allocated
        barley_cache:       3600 allocated - 1.14x more
              barley:      10560 allocated - 3.34x more
               panko:      10880 allocated - 3.44x more
       turbostreamer:      11448 allocated - 3.62x more
         jserializer:      11520 allocated - 3.65x more
                alba:      11680 allocated - 3.70x more
            jbuilder:      12640 allocated - 4.00x more
         blueprinter:      13200 allocated - 4.18x more
       representable:      14280 allocated - 4.52x more
                 ams:      17112 allocated - 5.42x more
         alba_inline:      31336 allocated - 9.92x more
          simple_ams:      37872 allocated - 11.98x more
```

### Single resource - Ruby 3.4.3, YJIT enabled, OJ rails optimizations disabled

```shell
NO_OJ_OPTIMIZE_RAILS=1 bundle exec ruby single_resource.rb
```

```shell
ruby 3.4.3 (2025-04-14 revision d0b7e5b6a0) +YJIT +PRISM [x86_64-linux]
Warming up --------------------------------------
                alba     1.669k i/100ms
         alba_inline   157.000 i/100ms
                 ams     1.110k i/100ms
              barley     1.636k i/100ms
        barley_cache     5.835k i/100ms
         blueprinter     1.306k i/100ms
            jbuilder     1.475k i/100ms
         jserializer     1.624k i/100ms
               panko     1.533k i/100ms
               rails     7.892k i/100ms
       representable     1.106k i/100ms
          simple_ams   672.000 i/100ms
       turbostreamer     1.525k i/100ms
Calculating -------------------------------------
                alba     15.410k (± 8.8%) i/s   (64.89 μs/i) -     76.774k in   5.029243s
         alba_inline      1.174k (±12.2%) i/s  (852.06 μs/i) -      5.809k in   5.018792s
                 ams      8.957k (± 9.0%) i/s  (111.64 μs/i) -     45.510k in   5.121131s
              barley     13.309k (± 8.5%) i/s   (75.14 μs/i) -     67.076k in   5.074950s
        barley_cache     47.781k (± 8.9%) i/s   (20.93 μs/i) -    239.235k in   5.044470s
         blueprinter     13.611k (± 2.7%) i/s   (73.47 μs/i) -     69.218k in   5.089696s
            jbuilder     14.443k (± 1.5%) i/s   (69.24 μs/i) -     72.275k in   5.005296s
         jserializer     15.969k (± 1.5%) i/s   (62.62 μs/i) -     81.200k in   5.086160s
               panko     15.323k (± 3.6%) i/s   (65.26 μs/i) -     76.650k in   5.009102s
               rails     81.266k (± 6.2%) i/s   (12.31 μs/i) -    410.384k in   5.072031s
       representable     10.777k (±10.7%) i/s   (92.79 μs/i) -     54.194k in   5.092428s
          simple_ams      7.017k (± 1.9%) i/s  (142.52 μs/i) -     35.616k in   5.077831s
       turbostreamer     15.224k (± 1.1%) i/s   (65.68 μs/i) -     76.250k in   5.009082s

Comparison:
               rails:    81266.4 i/s
        barley_cache:    47780.9 i/s - 1.70x  slower
         jserializer:    15968.8 i/s - 5.09x  slower
                alba:    15409.9 i/s - 5.27x  slower
               panko:    15323.5 i/s - 5.30x  slower
       turbostreamer:    15224.3 i/s - 5.34x  slower
            jbuilder:    14442.9 i/s - 5.63x  slower
         blueprinter:    13610.9 i/s - 5.97x  slower
              barley:    13308.6 i/s - 6.11x  slower
       representable:    10777.3 i/s - 7.54x  slower
                 ams:     8957.5 i/s - 9.07x  slower
          simple_ams:     7016.6 i/s - 11.58x  slower
         alba_inline:     1173.6 i/s - 69.24x  slower

Calculating -------------------------------------
                alba    11.240k memsize (   480.000  retained)
                       155.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
         alba_inline    30.896k memsize (   480.000  retained)
                       271.000  objects (     6.000  retained)
                        37.000  strings (     0.000  retained)
                 ams    17.992k memsize (   480.000  retained)
                       228.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
              barley    11.440k memsize (   480.000  retained)
                       161.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
        barley_cache     4.480k memsize (   160.000  retained)
                        47.000  objects (     1.000  retained)
                        16.000  strings (     1.000  retained)
         blueprinter    13.080k memsize (   480.000  retained)
                       190.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
            jbuilder    13.360k memsize (   480.000  retained)
                       176.000  objects (     6.000  retained)
                        11.000  strings (     0.000  retained)
         jserializer    11.400k memsize (   640.000  retained)
                       165.000  objects (     7.000  retained)
                         7.000  strings (     0.000  retained)
               panko    10.880k memsize (   480.000  retained)
                       164.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
               rails     3.960k memsize (     0.000  retained)
                        37.000  objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
       representable    15.240k memsize (   480.000  retained)
                       191.000  objects (     6.000  retained)
                        14.000  strings (     0.000  retained)
          simple_ams    38.752k memsize (   480.000  retained)
                       412.000  objects (     6.000  retained)
                        10.000  strings (     0.000  retained)
       turbostreamer    11.448k memsize (   480.000  retained)
                       175.000  objects (     6.000  retained)
                        15.000  strings (     0.000  retained)

Comparison:
               rails:       3960 allocated
        barley_cache:       4480 allocated - 1.13x more
               panko:      10880 allocated - 2.75x more
                alba:      11240 allocated - 2.84x more
         jserializer:      11400 allocated - 2.88x more
              barley:      11440 allocated - 2.89x more
       turbostreamer:      11448 allocated - 2.89x more
         blueprinter:      13080 allocated - 3.30x more
            jbuilder:      13360 allocated - 3.37x more
       representable:      15240 allocated - 3.85x more
                 ams:      17992 allocated - 4.54x more
         alba_inline:      30896 allocated - 7.80x more
          simple_ams:      38752 allocated - 9.79x more
```

### Single resource - Ruby 3.4.3, YJIT disabled, OJ rails optimizations disabled

```shell
NO_YJIT=1 NO_OJ_OPTIMIZE_RAILS=1 bundle exec ruby single_resource.rb
```

```shell
ruby 3.4.3 (2025-04-14 revision d0b7e5b6a0) +PRISM [x86_64-linux]
Warming up --------------------------------------
                alba   604.000 i/100ms
         alba_inline   223.000 i/100ms
                 ams   448.000 i/100ms
              barley   623.000 i/100ms
        barley_cache     3.209k i/100ms
         blueprinter   515.000 i/100ms
            jbuilder   543.000 i/100ms
         jserializer   607.000 i/100ms
               panko   595.000 i/100ms
               rails     4.240k i/100ms
       representable   472.000 i/100ms
          simple_ams   271.000 i/100ms
       turbostreamer   466.000 i/100ms
Calculating -------------------------------------
                alba      5.026k (± 7.1%) i/s  (198.95 μs/i) -     25.368k in   5.073210s
         alba_inline      1.945k (±13.1%) i/s  (514.04 μs/i) -      9.589k in   5.026950s
                 ams      3.760k (± 4.1%) i/s  (265.98 μs/i) -     18.816k in   5.013765s
              barley      5.090k (± 5.6%) i/s  (196.45 μs/i) -     25.543k in   5.034648s
        barley_cache     24.742k (± 4.2%) i/s   (40.42 μs/i) -    125.151k in   5.067475s
         blueprinter      4.999k (± 6.8%) i/s  (200.04 μs/i) -     25.235k in   5.073809s
            jbuilder      5.356k (± 2.5%) i/s  (186.70 μs/i) -     27.150k in   5.072029s
         jserializer      6.057k (± 2.8%) i/s  (165.09 μs/i) -     30.350k in   5.014538s
               panko      6.468k (± 1.5%) i/s  (154.60 μs/i) -     32.725k in   5.060228s
               rails     45.508k (± 1.5%) i/s   (21.97 μs/i) -    228.960k in   5.032386s
       representable      4.888k (± 1.7%) i/s  (204.56 μs/i) -     24.544k in   5.022277s
          simple_ams      3.424k (± 1.5%) i/s  (292.02 μs/i) -     17.344k in   5.065796s
       turbostreamer      6.042k (± 1.7%) i/s  (165.51 μs/i) -     30.290k in   5.014674s

Comparison:
               rails:    45508.4 i/s
        barley_cache:    24742.4 i/s - 1.84x  slower
               panko:     6468.5 i/s - 7.04x  slower
         jserializer:     6057.3 i/s - 7.51x  slower
       turbostreamer:     6042.0 i/s - 7.53x  slower
            jbuilder:     5356.2 i/s - 8.50x  slower
              barley:     5090.3 i/s - 8.94x  slower
                alba:     5026.4 i/s - 9.05x  slower
         blueprinter:     4999.0 i/s - 9.10x  slower
       representable:     4888.5 i/s - 9.31x  slower
                 ams:     3759.7 i/s - 12.10x  slower
          simple_ams:     3424.5 i/s - 13.29x  slower
         alba_inline:     1945.4 i/s - 23.39x  slower

Calculating -------------------------------------
                alba    11.240k memsize (   480.000  retained)
                       155.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
         alba_inline    30.896k memsize (   480.000  retained)
                       271.000  objects (     6.000  retained)
                        37.000  strings (     0.000  retained)
                 ams    17.992k memsize (   480.000  retained)
                       228.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
              barley    11.440k memsize (   480.000  retained)
                       161.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
        barley_cache     4.480k memsize (     0.000  retained)
                        47.000  objects (     0.000  retained)
                        15.000  strings (     0.000  retained)
         blueprinter    13.080k memsize (   480.000  retained)
                       190.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
            jbuilder    13.360k memsize (   480.000  retained)
                       176.000  objects (     6.000  retained)
                        11.000  strings (     0.000  retained)
         jserializer    11.400k memsize (   640.000  retained)
                       165.000  objects (     7.000  retained)
                         7.000  strings (     0.000  retained)
               panko    10.880k memsize (   480.000  retained)
                       164.000  objects (     6.000  retained)
                         7.000  strings (     0.000  retained)
               rails     3.960k memsize (     0.000  retained)
                        37.000  objects (     0.000  retained)
                         2.000  strings (     0.000  retained)
       representable    15.240k memsize (   480.000  retained)
                       191.000  objects (     6.000  retained)
                        14.000  strings (     0.000  retained)
          simple_ams    38.752k memsize (   480.000  retained)
                       412.000  objects (     6.000  retained)
                        10.000  strings (     0.000  retained)
       turbostreamer    11.448k memsize (   480.000  retained)
                       175.000  objects (     6.000  retained)
                        15.000  strings (     0.000  retained)

Comparison:
               rails:       3960 allocated
        barley_cache:       4480 allocated - 1.13x more
               panko:      10880 allocated - 2.75x more
                alba:      11240 allocated - 2.84x more
         jserializer:      11400 allocated - 2.88x more
              barley:      11440 allocated - 2.89x more
       turbostreamer:      11448 allocated - 2.89x more
         blueprinter:      13080 allocated - 3.30x more
            jbuilder:      13360 allocated - 3.37x more
       representable:      15240 allocated - 3.85x more
                 ams:      17992 allocated - 4.54x more
         alba_inline:      30896 allocated - 7.80x more
          simple_ams:      38752 allocated - 9.79x more
```
