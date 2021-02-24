system "grep Discover *_LOADER.log > /tmp/disc.txt";
svc:();
.Q.fs[{ svc,: ("   S";" ") 0:x }] `:/tmp/disc.txt

system"rm -f /tmp/fifo && mkfifo /tmp/fifo";
svc:();
.Q.fps[{ svc,: ("   S";" ") 0:x }] `:/tmp/fifo;
system "grep Discover *_LOADER.log > /tmp/fifo &";

distinct `$first each ":" vs/: string first svc
