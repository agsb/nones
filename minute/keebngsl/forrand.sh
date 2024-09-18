
> list0.rnd
> list1.rnd
> z0
> z1

for i in  ` seq 3000000 4000000 `; do
    echo $i
    echo "$i" > eseed ; awk -f keysrand.awk layout0.v eseed < ngsl.v >> z0
    echo "$i" > eseed ; awk -f keysrand.awk layout1.v eseed < ngsl.v >> z1
    done

    grep "# " z0 | sort -n >  list0.rnd
    grep "# " z1 | sort -n >  list1.rnd
