# Invaders finder

## How to run

```
bundle install
./run.rb data/radar.txt
```

## Algorithm description

The approach I took is to scan a map with some level of allowed noise (uncertainity), this one can be modified by `NOISE_LEVEL_THRESHOLD` const in the `run.rb` file. The higher the value is, the more invader places can be treated as a confirmed match.

The `App` class is a thin class which uses other dependencies (finders, radar data, invaders data), plus some printing of the result. Printing output could be moved to another class but I did not do that in a sake of brevity.

By default the app searches a radar in 3 different ways:
* `full_scan` - it tries to find whole invaders within radar boundaries
* `partial_top_edge` - it tries to find partially visible invaders at the top edge of a radar
* `partial_bottom_edge` - it tries to find partially visible invaders at the bottom edge of a radar

Many invaders can be added and radar data can be initialized by other data.
Invaders detection mechanism can be easily extended by other algorithms just by injecting additional finder classes into the `App`.

## Default output of a running app

```
./run.rb data/radar.txt

Looking for:
--o-----o--
---o---o---
--ooooooo--
-oo-ooo-oo-
ooooooooooo
o-ooooooo-o
o-o-----o-o
---oo-oo---

Coordinates:
[full_scan] X:74, Y:1
[full_scan] X:85, Y:12
[full_scan] X:60, Y:13
[partial_top_edge] not found
[partial_bottom_edge] not found

Looking for:
---oo---
--oooo--
-oooooo-
oo-oo-oo
oooooooo
--o--o--
-o-oo-o-
o-o--o-o

Coordinates:
[full_scan] X:42, Y:0
[full_scan] X:35, Y:15
[full_scan] X:16, Y:28
[full_scan] X:82, Y:41
[partial_top_edge] X:18, Y:0
[partial_top_edge] X:17, Y:0
[partial_bottom_edge] X:17, Y:45
[partial_bottom_edge] X:18, Y:45
```
