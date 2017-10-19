# README

Attempting to debug a issue we are having with sidekiq workers blocking further workers from running.
It appears to be something around using sleep. We first noticed the issue using the Net:SSH gem and it's session.wait

Here we have two simple workers, each performs a loop 10 times where they put a statement to console then wait for a second.

Clone and bundle install.

Once installed
run `bundle exec sidekiq` in a terminal session.
In another session run `bundle exec rails console`

In the console window run `TestWorker.perform_async; AnotherTestWorker.perform_async`

It appears that the first worker blocks the second and the output looks like this:

```
2017-10-19T09:25:06.122Z 83703 TID-ox1otcjbc TestWorker JID-1bf49f8275fef3160501a0ae INFO: start
Test worker
2017-10-19T09:25:06.124Z 83703 TID-ox1otchdw AnotherTestWorker JID-472cfbd813cc8f001d149279 INFO: start
Test worker
Test worker
Test worker
Test worker
Test worker
Test worker
Test worker
Test worker
Test worker
2017-10-19T09:25:16.137Z 83703 TID-ox1otcjbc TestWorker JID-1bf49f8275fef3160501a0ae INFO: done: 10.015 sec
Another test worker
Another test worker
Another test worker
Another test worker
Another test worker
Another test worker
Another test worker
Another test worker
Another test worker
Another test worker
2017-10-19T09:25:26.145Z 83703 TID-ox1otchdw AnotherTestWorker JID-472cfbd813cc8f001d149279 INFO: done: 20.021 sec
```

If you then run exactly the same command `TestWorker.perform_async; AnotherTestWorker.perform_async`
the output looks like this:

```
2017-10-19T09:26:46.647Z 83703 TID-ox1otchdw TestWorker JID-f80f7cc8d8613bcabc2e005b INFO: start
Test worker
2017-10-19T09:26:46.647Z 83703 TID-ox1olpspo AnotherTestWorker JID-142c76e1c4115b73b2147570 INFO: start
Another test worker
Test worker
Another test worker
Test worker
Another test worker
Test worker
Another test worker
Test worker
Another test worker
Test worker
Another test worker
Test worker
Another test worker
Test worker
Another test worker
Test worker
Another test worker
Test worker
Another test worker
2017-10-19T09:26:56.648Z 83703 TID-ox1otchdw TestWorker JID-f80f7cc8d8613bcabc2e005b INFO: done: 10.001 sec
2017-10-19T09:26:56.648Z 83703 TID-ox1olpspo AnotherTestWorker JID-142c76e1c4115b73b2147570 INFO: done: 10.001 sec
```

The second output is what I would expect.
