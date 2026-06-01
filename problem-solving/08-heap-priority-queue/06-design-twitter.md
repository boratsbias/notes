# Design Twitter

[Problem Link](https://leetcode.com/problems/design-twitter/)

## Approach

Store:

- `follows[user]`: set of followed user ids
- `tweets[user]`: list of `(timestamp, tweet_id)` newest last

On `getNewsFeed`, collect the ten most recent tweets from the user and everyone they follow using a max heap keyed by timestamp.

Merge k sorted tweet lists with a heap in **O(m log k)** where m is feed size and k is follow count.

Scanning all tweets for every feed call is too slow. The heap merges only recent candidates.

**Time Complexity:** O(m log k) getNewsFeed, O(1) post and follow  
**Space Complexity:** O(users + tweets)

## Code

```python
class Twitter:

    def __init__(self):
        self.time = 0
        self.tweets = defaultdict(list)
        self.follows = defaultdict(set)

    def postTweet(self, userId: int, tweetId: int) -> None:
        self.time += 1
        self.tweets[userId].append((self.time, tweetId))

    def getNewsFeed(self, userId: int) -> List[int]:
        users = self.follows[userId] | {userId}
        heap = []

        for uid in users:
            if self.tweets[uid]:
                idx = len(self.tweets[uid]) - 1
                time, tweet_id = self.tweets[uid][idx]
                heapq.heappush(heap, (-time, uid, idx, tweet_id))

        feed = []
        while heap and len(feed) < 10:
            _, uid, idx, tweet_id = heapq.heappop(heap)
            feed.append(tweet_id)
            if idx > 0:
                time, prev_id = self.tweets[uid][idx - 1]
                heapq.heappush(heap, (-time, uid, idx - 1, prev_id))

        return feed

    def follow(self, followerId: int, followeeId: int) -> None:
        self.follows[followerId].add(followeeId)

    def unfollow(self, followerId: int, followeeId: int) -> None:
        self.follows[followerId].discard(followeeId)
```
