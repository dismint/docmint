n = int(input())


def checkPal(s):
    for i in range(len(s) // 2):
        if s[i] != s[-(i + 1)]:
            return False
    return True

lastVal = 1
for i in range(1, 10**6):
    if not checkPal(str(i**3)):
        continue
    if i**3 > n:
        break
    lastVal = i**3

print(lastVal)
