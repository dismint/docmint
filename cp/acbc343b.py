n = int(input())
for _ in range(n):
    inp = list(map(int, input().split()))
    ans = ""
    for i, e in enumerate(inp):
        if not e:
            continue
        ans += f"{i + 1} "
    print(ans)
