a, b = map(int, input().split())
s = set(i for i in range(10))
s.remove(a + b)
print(s.pop())
