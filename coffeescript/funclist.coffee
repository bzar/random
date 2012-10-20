pair      = (a, b) -> (first) -> if first then a else b
first     = (p) -> p(true)
second    = (p) -> p(false)
list      = (head, tail...) -> pair(head, if tail.length > 0 then list(tail...) else null)
element   = (p, i) -> if i == 0 then first p else element(second(p), i - 1)
forEach   = (p, func) -> if p? then func(first p); forEach(second(p), func)
append    = (l1, l2) -> if l1? then l2 else pair(first(l1), append(second(l1), l2))
map       = (p, func) -> if p? then pair(func(first(p)), map(second(p), func))
filter    = (p, func) -> if p? and func(first(p)) then pair(first(p), filter(second(p), func)) else if p? then filter(second(p), func)
fold      = (p, unit, func) -> if p? then fold(second(p), func(unit, first(p)), func) else unit
slice     = (p, a, b) -> if p? and a > 0 then slice(second(p), a - 1, b - 1) else if p? and b >= 0 then pair(first(p), slice(second(p), a - 1, b - 1)) else null
range     = (a, b, k = 1) -> if a <= b then pair(a, range(a + k, b, k)) else null
join      = (p, separator) -> fold(p, null, (a, b) -> if a? then "#{a}#{separator}#{b}" else "#{b}")
serialize = (p) -> "[#{join(p, ', ')}]"
any       = (p) -> fold(p, false, (a, b) -> if a or b then true else false)
all       = (p) -> fold(p, false, (a, b) -> if a and b then true else false)
zip       = (lists) -> if any(lists) then pair(map(filter(lists, (x) -> x?), first), zip(map(filter(lists, (x) -> x?), second))) else null
toArray   = (p) -> fold(p, null, (a, b) -> if a? then a.concat(b) else [b])
starmap   = (p, func) -> map(p, (args) -> func(toArray(args)...))
startWhen = (p, pred) -> if pred(first(p)) then p else startWhen(second(p), pred)
endWhen   = (p, pred) -> (f) -> if f then first(p) else if pred(first(second(p))) then null else endWhen(second(p), pred)

p = pair(1, 2)
pp = list(1, 2, 3, 4, 5)
console.log first(p)
console.log second(p)
console.log element(pp, 3)
console.log serialize pp

console.log "##"
console.log serialize map(pp, (i) -> i + 2)

console.log "##"
console.log serialize filter(pp, (i) -> i > 2)

console.log "##"
console.log fold(pp, 0, (acc, i) -> acc + i)

console.log "##"
console.log serialize slice(pp,1,3)

console.log "##"
console.log serialize range(1,20,3)

console.log "##"
console.log serialize map(zip(list(range(1,5), range(6, 13), range(9, 20, 2))), serialize)

console.log "##"
console.log serialize starmap(zip(list(range(1,5), range(6, 10), range(11, 15))), (a, b, c) -> a + b + c)

console.log "##"
fibgen = (a=0, b=1) -> (first) -> if first then b else fibgen(b, a + b)
console.log serialize slice(fibgen(), 0, 10)

console.log "##"
console.log serialize endWhen(startWhen(fibgen(), (x) -> x > 20), (x) -> x > 250)
console.log serialize startWhen(endWhen(fibgen(), (x) -> x > 250), (x) -> x > 20)
