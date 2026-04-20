# Group Anagrams

[Problem Link](https://leetcode.com/problems/group-anagrams/)

## Approach

Use a hash map where the key represents the character signature of a word, and the value is a list of all words that share that signature.

For each word, compute a key that uniquely identifies its set of characters regardless of order. Two approaches work well:

- Sort the characters of the word. Words that are anagrams of each other will produce the same sorted string.
- Use a fixed-size frequency tuple of 26 integers, one for each letter. This avoids the cost of sorting.

Add each word to the list in the map that corresponds to its key.

At the end, return all the lists in the map as the result.

Sorting each word takes **O(k log k)** where k is the length of the word. Using a frequency tuple reduces the per-word cost to **O(k)**, which is better when words are long.

**Time Complexity:** O(n * k log k) with sorting, O(n * k) with frequency tuple, where n is the number of words and k is the average word length  
**Space Complexity:** O(n * k)

## Code

```python
class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        groups = defaultdict(list)

        for word in strs:
            count = [0] * 26

            for char in word:
                count[ord(char) - ord('a')] += 1

            groups[tuple(count)].append(word)

        return list(groups.values())
```
