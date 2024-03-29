n, t = map(int, input().split())
m = {i+1: 0 for i in range(n)}
d = {0: n}

for _ in range(t):
    a, b = map(int, input().split())
    d[m[a]] -= 1
    if not d[m[a]]:
        del d[m[a]]
    m[a] += b
    if m[a] not in d:
        d[m[a]] = 0
    d[m[a]] += 1
    print(len(d))
