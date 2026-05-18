from ast import List
from numbers import Number

print("hi mom - again ")
print("more lines ")

n = 1
n += 1
print(n)

if n > 2:
    print(2)
    x = 3
elif n < 5:

    print("less than 5")
else:
    print("sds")


print(5 / 2)
print(5 // 2)
print(-3 // 2)


print(10 % 3)
print(float("inf"))

arr = [1, 2, 3]
print(arr)

arr.append(4)
arr.append(5)
arr.pop()
print(arr)

arr.insert(1, 7)
print(arr)

arr = [1, 2, 3]
print(arr[-1])
print(arr[0:2])

nums = [1, 2, 3]
for i, n in enumerate(nums):
    print(i, n)


nums1 = [1, 3, 5]
nums2 = [2, 4, 6]

for n1, n2 in zip(nums1, nums2):
    print(n1, n2)


# sorts in place!
nums = [1, 2, 3]
rev = nums.reverse()
print(nums)


arr = [5, 4, 7, 3, 8]
arr.sort()
print(arr)

arr = ["bob", "alice", "jane", "doe"]
arr.sort()
print(arr)
arr.sort(key=lambda x: len(x))
print(arr)

arr = [i + i for i in range(5)]
print(arr)

# 2D arrays
arr = [[0] * 4 for i in range(4)]
print(arr)

s = "abc"
print(s[0:3])

# ascii values
print(ord("a"))

strings = ["ab", "cd", "ef"]
print("-".join(strings))


class MyClass:
    def __init__(self, nums: list[float]):
        self.nums: list[float] = nums


class Hello:
    def __init__(self) -> None:
        pass

    def wellthen(self):
        print("yo")
