
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 5d 38 10 80       	mov    $0x8010385d,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 50 87 10 80       	push   $0x80108750
80100042:	68 60 c6 10 80       	push   $0x8010c660
80100047:	e8 b3 50 00 00       	call   801050ff <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 ac 0d 11 80 5c 	movl   $0x80110d5c,0x80110dac
80100056:	0d 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b0 0d 11 80 5c 	movl   $0x80110d5c,0x80110db0
80100060:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
8010006a:	eb 47                	jmp    801000b3 <binit+0x7f>
    b->next = bcache.head.next;
8010006c:	8b 15 b0 0d 11 80    	mov    0x80110db0,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 50 5c 0d 11 80 	movl   $0x80110d5c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	83 c0 0c             	add    $0xc,%eax
80100088:	83 ec 08             	sub    $0x8,%esp
8010008b:	68 57 87 10 80       	push   $0x80108757
80100090:	50                   	push   %eax
80100091:	e8 e6 4e 00 00       	call   80104f7c <initsleeplock>
80100096:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
80100099:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
8010009e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a1:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	a3 b0 0d 11 80       	mov    %eax,0x80110db0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ac:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b3:	b8 5c 0d 11 80       	mov    $0x80110d5c,%eax
801000b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000bb:	72 af                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	90                   	nop
801000be:	c9                   	leave  
801000bf:	c3                   	ret    

801000c0 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000c0:	55                   	push   %ebp
801000c1:	89 e5                	mov    %esp,%ebp
801000c3:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c6:	83 ec 0c             	sub    $0xc,%esp
801000c9:	68 60 c6 10 80       	push   $0x8010c660
801000ce:	e8 4e 50 00 00       	call   80105121 <acquire>
801000d3:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000d6:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
801000db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000de:	eb 58                	jmp    80100138 <bget+0x78>
    if(b->dev == dev && b->blockno == blockno){
801000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e3:	8b 40 04             	mov    0x4(%eax),%eax
801000e6:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e9:	75 44                	jne    8010012f <bget+0x6f>
801000eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ee:	8b 40 08             	mov    0x8(%eax),%eax
801000f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000f4:	75 39                	jne    8010012f <bget+0x6f>
      b->refcnt++;
801000f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f9:	8b 40 4c             	mov    0x4c(%eax),%eax
801000fc:	8d 50 01             	lea    0x1(%eax),%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100105:	83 ec 0c             	sub    $0xc,%esp
80100108:	68 60 c6 10 80       	push   $0x8010c660
8010010d:	e8 7d 50 00 00       	call   8010518f <release>
80100112:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100118:	83 c0 0c             	add    $0xc,%eax
8010011b:	83 ec 0c             	sub    $0xc,%esp
8010011e:	50                   	push   %eax
8010011f:	e8 94 4e 00 00       	call   80104fb8 <acquiresleep>
80100124:	83 c4 10             	add    $0x10,%esp
      return b;
80100127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012a:	e9 9d 00 00 00       	jmp    801001cc <bget+0x10c>
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 54             	mov    0x54(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 5c 0d 11 80 	cmpl   $0x80110d5c,-0xc(%ebp)
8010013f:	75 9f                	jne    801000e0 <bget+0x20>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 ac 0d 11 80       	mov    0x80110dac,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 6b                	jmp    801001b6 <bget+0xf6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100151:	85 c0                	test   %eax,%eax
80100153:	75 58                	jne    801001ad <bget+0xed>
80100155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100158:	8b 00                	mov    (%eax),%eax
8010015a:	83 e0 04             	and    $0x4,%eax
8010015d:	85 c0                	test   %eax,%eax
8010015f:	75 4c                	jne    801001ad <bget+0xed>
      b->dev = dev;
80100161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100164:	8b 55 08             	mov    0x8(%ebp),%edx
80100167:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100170:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100186:	83 ec 0c             	sub    $0xc,%esp
80100189:	68 60 c6 10 80       	push   $0x8010c660
8010018e:	e8 fc 4f 00 00       	call   8010518f <release>
80100193:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100199:	83 c0 0c             	add    $0xc,%eax
8010019c:	83 ec 0c             	sub    $0xc,%esp
8010019f:	50                   	push   %eax
801001a0:	e8 13 4e 00 00       	call   80104fb8 <acquiresleep>
801001a5:	83 c4 10             	add    $0x10,%esp
      return b;
801001a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ab:	eb 1f                	jmp    801001cc <bget+0x10c>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b0:	8b 40 50             	mov    0x50(%eax),%eax
801001b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001b6:	81 7d f4 5c 0d 11 80 	cmpl   $0x80110d5c,-0xc(%ebp)
801001bd:	75 8c                	jne    8010014b <bget+0x8b>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001bf:	83 ec 0c             	sub    $0xc,%esp
801001c2:	68 5e 87 10 80       	push   $0x8010875e
801001c7:	e8 d4 03 00 00       	call   801005a0 <panic>
}
801001cc:	c9                   	leave  
801001cd:	c3                   	ret    

801001ce <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001ce:	55                   	push   %ebp
801001cf:	89 e5                	mov    %esp,%ebp
801001d1:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001d4:	83 ec 08             	sub    $0x8,%esp
801001d7:	ff 75 0c             	pushl  0xc(%ebp)
801001da:	ff 75 08             	pushl  0x8(%ebp)
801001dd:	e8 de fe ff ff       	call   801000c0 <bget>
801001e2:	83 c4 10             	add    $0x10,%esp
801001e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001eb:	8b 00                	mov    (%eax),%eax
801001ed:	83 e0 02             	and    $0x2,%eax
801001f0:	85 c0                	test   %eax,%eax
801001f2:	75 0e                	jne    80100202 <bread+0x34>
    iderw(b);
801001f4:	83 ec 0c             	sub    $0xc,%esp
801001f7:	ff 75 f4             	pushl  -0xc(%ebp)
801001fa:	e8 5d 27 00 00       	call   8010295c <iderw>
801001ff:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100202:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100205:	c9                   	leave  
80100206:	c3                   	ret    

80100207 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100207:	55                   	push   %ebp
80100208:	89 e5                	mov    %esp,%ebp
8010020a:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010020d:	8b 45 08             	mov    0x8(%ebp),%eax
80100210:	83 c0 0c             	add    $0xc,%eax
80100213:	83 ec 0c             	sub    $0xc,%esp
80100216:	50                   	push   %eax
80100217:	e8 4e 4e 00 00       	call   8010506a <holdingsleep>
8010021c:	83 c4 10             	add    $0x10,%esp
8010021f:	85 c0                	test   %eax,%eax
80100221:	75 0d                	jne    80100230 <bwrite+0x29>
    panic("bwrite");
80100223:	83 ec 0c             	sub    $0xc,%esp
80100226:	68 6f 87 10 80       	push   $0x8010876f
8010022b:	e8 70 03 00 00       	call   801005a0 <panic>
  b->flags |= B_DIRTY;
80100230:	8b 45 08             	mov    0x8(%ebp),%eax
80100233:	8b 00                	mov    (%eax),%eax
80100235:	83 c8 04             	or     $0x4,%eax
80100238:	89 c2                	mov    %eax,%edx
8010023a:	8b 45 08             	mov    0x8(%ebp),%eax
8010023d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010023f:	83 ec 0c             	sub    $0xc,%esp
80100242:	ff 75 08             	pushl  0x8(%ebp)
80100245:	e8 12 27 00 00       	call   8010295c <iderw>
8010024a:	83 c4 10             	add    $0x10,%esp
}
8010024d:	90                   	nop
8010024e:	c9                   	leave  
8010024f:	c3                   	ret    

80100250 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100250:	55                   	push   %ebp
80100251:	89 e5                	mov    %esp,%ebp
80100253:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100256:	8b 45 08             	mov    0x8(%ebp),%eax
80100259:	83 c0 0c             	add    $0xc,%eax
8010025c:	83 ec 0c             	sub    $0xc,%esp
8010025f:	50                   	push   %eax
80100260:	e8 05 4e 00 00       	call   8010506a <holdingsleep>
80100265:	83 c4 10             	add    $0x10,%esp
80100268:	85 c0                	test   %eax,%eax
8010026a:	75 0d                	jne    80100279 <brelse+0x29>
    panic("brelse");
8010026c:	83 ec 0c             	sub    $0xc,%esp
8010026f:	68 76 87 10 80       	push   $0x80108776
80100274:	e8 27 03 00 00       	call   801005a0 <panic>

  releasesleep(&b->lock);
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	83 c0 0c             	add    $0xc,%eax
8010027f:	83 ec 0c             	sub    $0xc,%esp
80100282:	50                   	push   %eax
80100283:	e8 94 4d 00 00       	call   8010501c <releasesleep>
80100288:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
8010028b:	83 ec 0c             	sub    $0xc,%esp
8010028e:	68 60 c6 10 80       	push   $0x8010c660
80100293:	e8 89 4e 00 00       	call   80105121 <acquire>
80100298:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010029b:	8b 45 08             	mov    0x8(%ebp),%eax
8010029e:	8b 40 4c             	mov    0x4c(%eax),%eax
801002a1:	8d 50 ff             	lea    -0x1(%eax),%edx
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002aa:	8b 45 08             	mov    0x8(%ebp),%eax
801002ad:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 47                	jne    801002fb <brelse+0xab>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002b4:	8b 45 08             	mov    0x8(%ebp),%eax
801002b7:	8b 40 54             	mov    0x54(%eax),%eax
801002ba:	8b 55 08             	mov    0x8(%ebp),%edx
801002bd:	8b 52 50             	mov    0x50(%edx),%edx
801002c0:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002c3:	8b 45 08             	mov    0x8(%ebp),%eax
801002c6:	8b 40 50             	mov    0x50(%eax),%eax
801002c9:	8b 55 08             	mov    0x8(%ebp),%edx
801002cc:	8b 52 54             	mov    0x54(%edx),%edx
801002cf:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002d2:	8b 15 b0 0d 11 80    	mov    0x80110db0,%edx
801002d8:	8b 45 08             	mov    0x8(%ebp),%eax
801002db:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	c7 40 50 5c 0d 11 80 	movl   $0x80110d5c,0x50(%eax)
    bcache.head.next->prev = b;
801002e8:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
801002ed:	8b 55 08             	mov    0x8(%ebp),%edx
801002f0:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002f3:	8b 45 08             	mov    0x8(%ebp),%eax
801002f6:	a3 b0 0d 11 80       	mov    %eax,0x80110db0
  }
  
  release(&bcache.lock);
801002fb:	83 ec 0c             	sub    $0xc,%esp
801002fe:	68 60 c6 10 80       	push   $0x8010c660
80100303:	e8 87 4e 00 00       	call   8010518f <release>
80100308:	83 c4 10             	add    $0x10,%esp
}
8010030b:	90                   	nop
8010030c:	c9                   	leave  
8010030d:	c3                   	ret    

8010030e <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010030e:	55                   	push   %ebp
8010030f:	89 e5                	mov    %esp,%ebp
80100311:	83 ec 14             	sub    $0x14,%esp
80100314:	8b 45 08             	mov    0x8(%ebp),%eax
80100317:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010031b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010031f:	89 c2                	mov    %eax,%edx
80100321:	ec                   	in     (%dx),%al
80100322:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80100325:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80100329:	c9                   	leave  
8010032a:	c3                   	ret    

8010032b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010032b:	55                   	push   %ebp
8010032c:	89 e5                	mov    %esp,%ebp
8010032e:	83 ec 08             	sub    $0x8,%esp
80100331:	8b 55 08             	mov    0x8(%ebp),%edx
80100334:	8b 45 0c             	mov    0xc(%ebp),%eax
80100337:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010033b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010033e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100342:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100346:	ee                   	out    %al,(%dx)
}
80100347:	90                   	nop
80100348:	c9                   	leave  
80100349:	c3                   	ret    

8010034a <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010034a:	55                   	push   %ebp
8010034b:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010034d:	fa                   	cli    
}
8010034e:	90                   	nop
8010034f:	5d                   	pop    %ebp
80100350:	c3                   	ret    

80100351 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100351:	55                   	push   %ebp
80100352:	89 e5                	mov    %esp,%ebp
80100354:	53                   	push   %ebx
80100355:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100358:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010035c:	74 1c                	je     8010037a <printint+0x29>
8010035e:	8b 45 08             	mov    0x8(%ebp),%eax
80100361:	c1 e8 1f             	shr    $0x1f,%eax
80100364:	0f b6 c0             	movzbl %al,%eax
80100367:	89 45 10             	mov    %eax,0x10(%ebp)
8010036a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036e:	74 0a                	je     8010037a <printint+0x29>
    x = -xx;
80100370:	8b 45 08             	mov    0x8(%ebp),%eax
80100373:	f7 d8                	neg    %eax
80100375:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100378:	eb 06                	jmp    80100380 <printint+0x2f>
  else
    x = xx;
8010037a:	8b 45 08             	mov    0x8(%ebp),%eax
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100380:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100387:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010038a:	8d 41 01             	lea    0x1(%ecx),%eax
8010038d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100390:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100393:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100396:	ba 00 00 00 00       	mov    $0x0,%edx
8010039b:	f7 f3                	div    %ebx
8010039d:	89 d0                	mov    %edx,%eax
8010039f:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
801003a6:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
801003aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801003ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003b0:	ba 00 00 00 00       	mov    $0x0,%edx
801003b5:	f7 f3                	div    %ebx
801003b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003be:	75 c7                	jne    80100387 <printint+0x36>

  if(sign)
801003c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003c4:	74 2a                	je     801003f0 <printint+0x9f>
    buf[i++] = '-';
801003c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003c9:	8d 50 01             	lea    0x1(%eax),%edx
801003cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003cf:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003d4:	eb 1a                	jmp    801003f0 <printint+0x9f>
    consputc(buf[i]);
801003d6:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003dc:	01 d0                	add    %edx,%eax
801003de:	0f b6 00             	movzbl (%eax),%eax
801003e1:	0f be c0             	movsbl %al,%eax
801003e4:	83 ec 0c             	sub    $0xc,%esp
801003e7:	50                   	push   %eax
801003e8:	e8 d8 03 00 00       	call   801007c5 <consputc>
801003ed:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003f8:	79 dc                	jns    801003d6 <printint+0x85>
    consputc(buf[i]);
}
801003fa:	90                   	nop
801003fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003fe:	c9                   	leave  
801003ff:	c3                   	ret    

80100400 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100406:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
8010040b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
8010040e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100412:	74 10                	je     80100424 <cprintf+0x24>
    acquire(&cons.lock);
80100414:	83 ec 0c             	sub    $0xc,%esp
80100417:	68 c0 b5 10 80       	push   $0x8010b5c0
8010041c:	e8 00 4d 00 00       	call   80105121 <acquire>
80100421:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100424:	8b 45 08             	mov    0x8(%ebp),%eax
80100427:	85 c0                	test   %eax,%eax
80100429:	75 0d                	jne    80100438 <cprintf+0x38>
    panic("null fmt");
8010042b:	83 ec 0c             	sub    $0xc,%esp
8010042e:	68 7d 87 10 80       	push   $0x8010877d
80100433:	e8 68 01 00 00       	call   801005a0 <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100438:	8d 45 0c             	lea    0xc(%ebp),%eax
8010043b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010043e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100445:	e9 1a 01 00 00       	jmp    80100564 <cprintf+0x164>
    if(c != '%'){
8010044a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010044e:	74 13                	je     80100463 <cprintf+0x63>
      consputc(c);
80100450:	83 ec 0c             	sub    $0xc,%esp
80100453:	ff 75 e4             	pushl  -0x1c(%ebp)
80100456:	e8 6a 03 00 00       	call   801007c5 <consputc>
8010045b:	83 c4 10             	add    $0x10,%esp
      continue;
8010045e:	e9 fd 00 00 00       	jmp    80100560 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100463:	8b 55 08             	mov    0x8(%ebp),%edx
80100466:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010046a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010046d:	01 d0                	add    %edx,%eax
8010046f:	0f b6 00             	movzbl (%eax),%eax
80100472:	0f be c0             	movsbl %al,%eax
80100475:	25 ff 00 00 00       	and    $0xff,%eax
8010047a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010047d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100481:	0f 84 ff 00 00 00    	je     80100586 <cprintf+0x186>
      break;
    switch(c){
80100487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010048a:	83 f8 70             	cmp    $0x70,%eax
8010048d:	74 47                	je     801004d6 <cprintf+0xd6>
8010048f:	83 f8 70             	cmp    $0x70,%eax
80100492:	7f 13                	jg     801004a7 <cprintf+0xa7>
80100494:	83 f8 25             	cmp    $0x25,%eax
80100497:	0f 84 98 00 00 00    	je     80100535 <cprintf+0x135>
8010049d:	83 f8 64             	cmp    $0x64,%eax
801004a0:	74 14                	je     801004b6 <cprintf+0xb6>
801004a2:	e9 9d 00 00 00       	jmp    80100544 <cprintf+0x144>
801004a7:	83 f8 73             	cmp    $0x73,%eax
801004aa:	74 47                	je     801004f3 <cprintf+0xf3>
801004ac:	83 f8 78             	cmp    $0x78,%eax
801004af:	74 25                	je     801004d6 <cprintf+0xd6>
801004b1:	e9 8e 00 00 00       	jmp    80100544 <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
801004b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b9:	8d 50 04             	lea    0x4(%eax),%edx
801004bc:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004bf:	8b 00                	mov    (%eax),%eax
801004c1:	83 ec 04             	sub    $0x4,%esp
801004c4:	6a 01                	push   $0x1
801004c6:	6a 0a                	push   $0xa
801004c8:	50                   	push   %eax
801004c9:	e8 83 fe ff ff       	call   80100351 <printint>
801004ce:	83 c4 10             	add    $0x10,%esp
      break;
801004d1:	e9 8a 00 00 00       	jmp    80100560 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004d9:	8d 50 04             	lea    0x4(%eax),%edx
801004dc:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004df:	8b 00                	mov    (%eax),%eax
801004e1:	83 ec 04             	sub    $0x4,%esp
801004e4:	6a 00                	push   $0x0
801004e6:	6a 10                	push   $0x10
801004e8:	50                   	push   %eax
801004e9:	e8 63 fe ff ff       	call   80100351 <printint>
801004ee:	83 c4 10             	add    $0x10,%esp
      break;
801004f1:	eb 6d                	jmp    80100560 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004f6:	8d 50 04             	lea    0x4(%eax),%edx
801004f9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004fc:	8b 00                	mov    (%eax),%eax
801004fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100501:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100505:	75 22                	jne    80100529 <cprintf+0x129>
        s = "(null)";
80100507:	c7 45 ec 86 87 10 80 	movl   $0x80108786,-0x14(%ebp)
      for(; *s; s++)
8010050e:	eb 19                	jmp    80100529 <cprintf+0x129>
        consputc(*s);
80100510:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100513:	0f b6 00             	movzbl (%eax),%eax
80100516:	0f be c0             	movsbl %al,%eax
80100519:	83 ec 0c             	sub    $0xc,%esp
8010051c:	50                   	push   %eax
8010051d:	e8 a3 02 00 00       	call   801007c5 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100525:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100529:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010052c:	0f b6 00             	movzbl (%eax),%eax
8010052f:	84 c0                	test   %al,%al
80100531:	75 dd                	jne    80100510 <cprintf+0x110>
        consputc(*s);
      break;
80100533:	eb 2b                	jmp    80100560 <cprintf+0x160>
    case '%':
      consputc('%');
80100535:	83 ec 0c             	sub    $0xc,%esp
80100538:	6a 25                	push   $0x25
8010053a:	e8 86 02 00 00       	call   801007c5 <consputc>
8010053f:	83 c4 10             	add    $0x10,%esp
      break;
80100542:	eb 1c                	jmp    80100560 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100544:	83 ec 0c             	sub    $0xc,%esp
80100547:	6a 25                	push   $0x25
80100549:	e8 77 02 00 00       	call   801007c5 <consputc>
8010054e:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100551:	83 ec 0c             	sub    $0xc,%esp
80100554:	ff 75 e4             	pushl  -0x1c(%ebp)
80100557:	e8 69 02 00 00       	call   801007c5 <consputc>
8010055c:	83 c4 10             	add    $0x10,%esp
      break;
8010055f:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100560:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100564:	8b 55 08             	mov    0x8(%ebp),%edx
80100567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010056a:	01 d0                	add    %edx,%eax
8010056c:	0f b6 00             	movzbl (%eax),%eax
8010056f:	0f be c0             	movsbl %al,%eax
80100572:	25 ff 00 00 00       	and    $0xff,%eax
80100577:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010057a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010057e:	0f 85 c6 fe ff ff    	jne    8010044a <cprintf+0x4a>
80100584:	eb 01                	jmp    80100587 <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100586:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100587:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010058b:	74 10                	je     8010059d <cprintf+0x19d>
    release(&cons.lock);
8010058d:	83 ec 0c             	sub    $0xc,%esp
80100590:	68 c0 b5 10 80       	push   $0x8010b5c0
80100595:	e8 f5 4b 00 00       	call   8010518f <release>
8010059a:	83 c4 10             	add    $0x10,%esp
}
8010059d:	90                   	nop
8010059e:	c9                   	leave  
8010059f:	c3                   	ret    

801005a0 <panic>:

void
panic(char *s)
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005a6:	e8 9f fd ff ff       	call   8010034a <cli>
  cons.locking = 0;
801005ab:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
801005b2:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005b5:	e8 31 2a 00 00       	call   80102feb <lapicid>
801005ba:	83 ec 08             	sub    $0x8,%esp
801005bd:	50                   	push   %eax
801005be:	68 8d 87 10 80       	push   $0x8010878d
801005c3:	e8 38 fe ff ff       	call   80100400 <cprintf>
801005c8:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005cb:	8b 45 08             	mov    0x8(%ebp),%eax
801005ce:	83 ec 0c             	sub    $0xc,%esp
801005d1:	50                   	push   %eax
801005d2:	e8 29 fe ff ff       	call   80100400 <cprintf>
801005d7:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005da:	83 ec 0c             	sub    $0xc,%esp
801005dd:	68 a1 87 10 80       	push   $0x801087a1
801005e2:	e8 19 fe ff ff       	call   80100400 <cprintf>
801005e7:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005ea:	83 ec 08             	sub    $0x8,%esp
801005ed:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f0:	50                   	push   %eax
801005f1:	8d 45 08             	lea    0x8(%ebp),%eax
801005f4:	50                   	push   %eax
801005f5:	e8 e7 4b 00 00       	call   801051e1 <getcallerpcs>
801005fa:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100604:	eb 1c                	jmp    80100622 <panic+0x82>
    cprintf(" %p", pcs[i]);
80100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100609:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010060d:	83 ec 08             	sub    $0x8,%esp
80100610:	50                   	push   %eax
80100611:	68 a3 87 10 80       	push   $0x801087a3
80100616:	e8 e5 fd ff ff       	call   80100400 <cprintf>
8010061b:	83 c4 10             	add    $0x10,%esp
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
8010061e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100622:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100626:	7e de                	jle    80100606 <panic+0x66>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
80100628:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
8010062f:	00 00 00 
  for(;;)
    ;
80100632:	eb fe                	jmp    80100632 <panic+0x92>

80100634 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100634:	55                   	push   %ebp
80100635:	89 e5                	mov    %esp,%ebp
80100637:	83 ec 18             	sub    $0x18,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
8010063a:	6a 0e                	push   $0xe
8010063c:	68 d4 03 00 00       	push   $0x3d4
80100641:	e8 e5 fc ff ff       	call   8010032b <outb>
80100646:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100649:	68 d5 03 00 00       	push   $0x3d5
8010064e:	e8 bb fc ff ff       	call   8010030e <inb>
80100653:	83 c4 04             	add    $0x4,%esp
80100656:	0f b6 c0             	movzbl %al,%eax
80100659:	c1 e0 08             	shl    $0x8,%eax
8010065c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010065f:	6a 0f                	push   $0xf
80100661:	68 d4 03 00 00       	push   $0x3d4
80100666:	e8 c0 fc ff ff       	call   8010032b <outb>
8010066b:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010066e:	68 d5 03 00 00       	push   $0x3d5
80100673:	e8 96 fc ff ff       	call   8010030e <inb>
80100678:	83 c4 04             	add    $0x4,%esp
8010067b:	0f b6 c0             	movzbl %al,%eax
8010067e:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100681:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100685:	75 30                	jne    801006b7 <cgaputc+0x83>
    pos += 80 - pos%80;
80100687:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010068a:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010068f:	89 c8                	mov    %ecx,%eax
80100691:	f7 ea                	imul   %edx
80100693:	c1 fa 05             	sar    $0x5,%edx
80100696:	89 c8                	mov    %ecx,%eax
80100698:	c1 f8 1f             	sar    $0x1f,%eax
8010069b:	29 c2                	sub    %eax,%edx
8010069d:	89 d0                	mov    %edx,%eax
8010069f:	c1 e0 02             	shl    $0x2,%eax
801006a2:	01 d0                	add    %edx,%eax
801006a4:	c1 e0 04             	shl    $0x4,%eax
801006a7:	29 c1                	sub    %eax,%ecx
801006a9:	89 ca                	mov    %ecx,%edx
801006ab:	b8 50 00 00 00       	mov    $0x50,%eax
801006b0:	29 d0                	sub    %edx,%eax
801006b2:	01 45 f4             	add    %eax,-0xc(%ebp)
801006b5:	eb 34                	jmp    801006eb <cgaputc+0xb7>
  else if(c == BACKSPACE){
801006b7:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006be:	75 0c                	jne    801006cc <cgaputc+0x98>
    if(pos > 0) --pos;
801006c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006c4:	7e 25                	jle    801006eb <cgaputc+0xb7>
801006c6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006ca:	eb 1f                	jmp    801006eb <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006cc:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
801006d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006d5:	8d 50 01             	lea    0x1(%eax),%edx
801006d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006db:	01 c0                	add    %eax,%eax
801006dd:	01 c8                	add    %ecx,%eax
801006df:	8b 55 08             	mov    0x8(%ebp),%edx
801006e2:	0f b6 d2             	movzbl %dl,%edx
801006e5:	80 ce 07             	or     $0x7,%dh
801006e8:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006ef:	78 09                	js     801006fa <cgaputc+0xc6>
801006f1:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006f8:	7e 0d                	jle    80100707 <cgaputc+0xd3>
    panic("pos under/overflow");
801006fa:	83 ec 0c             	sub    $0xc,%esp
801006fd:	68 a7 87 10 80       	push   $0x801087a7
80100702:	e8 99 fe ff ff       	call   801005a0 <panic>

  if((pos/80) >= 24){  // Scroll up.
80100707:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010070e:	7e 4c                	jle    8010075c <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100710:	a1 00 90 10 80       	mov    0x80109000,%eax
80100715:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010071b:	a1 00 90 10 80       	mov    0x80109000,%eax
80100720:	83 ec 04             	sub    $0x4,%esp
80100723:	68 60 0e 00 00       	push   $0xe60
80100728:	52                   	push   %edx
80100729:	50                   	push   %eax
8010072a:	e8 38 4d 00 00       	call   80105467 <memmove>
8010072f:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100732:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100736:	b8 80 07 00 00       	mov    $0x780,%eax
8010073b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010073e:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100741:	a1 00 90 10 80       	mov    0x80109000,%eax
80100746:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100749:	01 c9                	add    %ecx,%ecx
8010074b:	01 c8                	add    %ecx,%eax
8010074d:	83 ec 04             	sub    $0x4,%esp
80100750:	52                   	push   %edx
80100751:	6a 00                	push   $0x0
80100753:	50                   	push   %eax
80100754:	e8 4f 4c 00 00       	call   801053a8 <memset>
80100759:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
8010075c:	83 ec 08             	sub    $0x8,%esp
8010075f:	6a 0e                	push   $0xe
80100761:	68 d4 03 00 00       	push   $0x3d4
80100766:	e8 c0 fb ff ff       	call   8010032b <outb>
8010076b:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010076e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100771:	c1 f8 08             	sar    $0x8,%eax
80100774:	0f b6 c0             	movzbl %al,%eax
80100777:	83 ec 08             	sub    $0x8,%esp
8010077a:	50                   	push   %eax
8010077b:	68 d5 03 00 00       	push   $0x3d5
80100780:	e8 a6 fb ff ff       	call   8010032b <outb>
80100785:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100788:	83 ec 08             	sub    $0x8,%esp
8010078b:	6a 0f                	push   $0xf
8010078d:	68 d4 03 00 00       	push   $0x3d4
80100792:	e8 94 fb ff ff       	call   8010032b <outb>
80100797:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010079a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010079d:	0f b6 c0             	movzbl %al,%eax
801007a0:	83 ec 08             	sub    $0x8,%esp
801007a3:	50                   	push   %eax
801007a4:	68 d5 03 00 00       	push   $0x3d5
801007a9:	e8 7d fb ff ff       	call   8010032b <outb>
801007ae:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007b1:	a1 00 90 10 80       	mov    0x80109000,%eax
801007b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801007b9:	01 d2                	add    %edx,%edx
801007bb:	01 d0                	add    %edx,%eax
801007bd:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801007c2:	90                   	nop
801007c3:	c9                   	leave  
801007c4:	c3                   	ret    

801007c5 <consputc>:

void
consputc(int c)
{
801007c5:	55                   	push   %ebp
801007c6:	89 e5                	mov    %esp,%ebp
801007c8:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007cb:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
801007d0:	85 c0                	test   %eax,%eax
801007d2:	74 07                	je     801007db <consputc+0x16>
    cli();
801007d4:	e8 71 fb ff ff       	call   8010034a <cli>
    for(;;)
      ;
801007d9:	eb fe                	jmp    801007d9 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007db:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007e2:	75 29                	jne    8010080d <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007e4:	83 ec 0c             	sub    $0xc,%esp
801007e7:	6a 08                	push   $0x8
801007e9:	e8 38 65 00 00       	call   80106d26 <uartputc>
801007ee:	83 c4 10             	add    $0x10,%esp
801007f1:	83 ec 0c             	sub    $0xc,%esp
801007f4:	6a 20                	push   $0x20
801007f6:	e8 2b 65 00 00       	call   80106d26 <uartputc>
801007fb:	83 c4 10             	add    $0x10,%esp
801007fe:	83 ec 0c             	sub    $0xc,%esp
80100801:	6a 08                	push   $0x8
80100803:	e8 1e 65 00 00       	call   80106d26 <uartputc>
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	eb 0e                	jmp    8010081b <consputc+0x56>
  } else
    uartputc(c);
8010080d:	83 ec 0c             	sub    $0xc,%esp
80100810:	ff 75 08             	pushl  0x8(%ebp)
80100813:	e8 0e 65 00 00       	call   80106d26 <uartputc>
80100818:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010081b:	83 ec 0c             	sub    $0xc,%esp
8010081e:	ff 75 08             	pushl  0x8(%ebp)
80100821:	e8 0e fe ff ff       	call   80100634 <cgaputc>
80100826:	83 c4 10             	add    $0x10,%esp
}
80100829:	90                   	nop
8010082a:	c9                   	leave  
8010082b:	c3                   	ret    

8010082c <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
8010082c:	55                   	push   %ebp
8010082d:	89 e5                	mov    %esp,%ebp
8010082f:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
80100832:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100839:	83 ec 0c             	sub    $0xc,%esp
8010083c:	68 c0 b5 10 80       	push   $0x8010b5c0
80100841:	e8 db 48 00 00       	call   80105121 <acquire>
80100846:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100849:	e9 44 01 00 00       	jmp    80100992 <consoleintr+0x166>
    switch(c){
8010084e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100851:	83 f8 10             	cmp    $0x10,%eax
80100854:	74 1e                	je     80100874 <consoleintr+0x48>
80100856:	83 f8 10             	cmp    $0x10,%eax
80100859:	7f 0a                	jg     80100865 <consoleintr+0x39>
8010085b:	83 f8 08             	cmp    $0x8,%eax
8010085e:	74 6b                	je     801008cb <consoleintr+0x9f>
80100860:	e9 9b 00 00 00       	jmp    80100900 <consoleintr+0xd4>
80100865:	83 f8 15             	cmp    $0x15,%eax
80100868:	74 33                	je     8010089d <consoleintr+0x71>
8010086a:	83 f8 7f             	cmp    $0x7f,%eax
8010086d:	74 5c                	je     801008cb <consoleintr+0x9f>
8010086f:	e9 8c 00 00 00       	jmp    80100900 <consoleintr+0xd4>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100874:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010087b:	e9 12 01 00 00       	jmp    80100992 <consoleintr+0x166>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100880:	a1 48 10 11 80       	mov    0x80111048,%eax
80100885:	83 e8 01             	sub    $0x1,%eax
80100888:	a3 48 10 11 80       	mov    %eax,0x80111048
        consputc(BACKSPACE);
8010088d:	83 ec 0c             	sub    $0xc,%esp
80100890:	68 00 01 00 00       	push   $0x100
80100895:	e8 2b ff ff ff       	call   801007c5 <consputc>
8010089a:	83 c4 10             	add    $0x10,%esp
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010089d:	8b 15 48 10 11 80    	mov    0x80111048,%edx
801008a3:	a1 44 10 11 80       	mov    0x80111044,%eax
801008a8:	39 c2                	cmp    %eax,%edx
801008aa:	0f 84 e2 00 00 00    	je     80100992 <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008b0:	a1 48 10 11 80       	mov    0x80111048,%eax
801008b5:	83 e8 01             	sub    $0x1,%eax
801008b8:	83 e0 7f             	and    $0x7f,%eax
801008bb:	0f b6 80 c0 0f 11 80 	movzbl -0x7feef040(%eax),%eax
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c2:	3c 0a                	cmp    $0xa,%al
801008c4:	75 ba                	jne    80100880 <consoleintr+0x54>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008c6:	e9 c7 00 00 00       	jmp    80100992 <consoleintr+0x166>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008cb:	8b 15 48 10 11 80    	mov    0x80111048,%edx
801008d1:	a1 44 10 11 80       	mov    0x80111044,%eax
801008d6:	39 c2                	cmp    %eax,%edx
801008d8:	0f 84 b4 00 00 00    	je     80100992 <consoleintr+0x166>
        input.e--;
801008de:	a1 48 10 11 80       	mov    0x80111048,%eax
801008e3:	83 e8 01             	sub    $0x1,%eax
801008e6:	a3 48 10 11 80       	mov    %eax,0x80111048
        consputc(BACKSPACE);
801008eb:	83 ec 0c             	sub    $0xc,%esp
801008ee:	68 00 01 00 00       	push   $0x100
801008f3:	e8 cd fe ff ff       	call   801007c5 <consputc>
801008f8:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008fb:	e9 92 00 00 00       	jmp    80100992 <consoleintr+0x166>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100900:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100904:	0f 84 87 00 00 00    	je     80100991 <consoleintr+0x165>
8010090a:	8b 15 48 10 11 80    	mov    0x80111048,%edx
80100910:	a1 40 10 11 80       	mov    0x80111040,%eax
80100915:	29 c2                	sub    %eax,%edx
80100917:	89 d0                	mov    %edx,%eax
80100919:	83 f8 7f             	cmp    $0x7f,%eax
8010091c:	77 73                	ja     80100991 <consoleintr+0x165>
        c = (c == '\r') ? '\n' : c;
8010091e:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100922:	74 05                	je     80100929 <consoleintr+0xfd>
80100924:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100927:	eb 05                	jmp    8010092e <consoleintr+0x102>
80100929:	b8 0a 00 00 00       	mov    $0xa,%eax
8010092e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100931:	a1 48 10 11 80       	mov    0x80111048,%eax
80100936:	8d 50 01             	lea    0x1(%eax),%edx
80100939:	89 15 48 10 11 80    	mov    %edx,0x80111048
8010093f:	83 e0 7f             	and    $0x7f,%eax
80100942:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100945:	88 90 c0 0f 11 80    	mov    %dl,-0x7feef040(%eax)
        consputc(c);
8010094b:	83 ec 0c             	sub    $0xc,%esp
8010094e:	ff 75 f0             	pushl  -0x10(%ebp)
80100951:	e8 6f fe ff ff       	call   801007c5 <consputc>
80100956:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100959:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010095d:	74 18                	je     80100977 <consoleintr+0x14b>
8010095f:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100963:	74 12                	je     80100977 <consoleintr+0x14b>
80100965:	a1 48 10 11 80       	mov    0x80111048,%eax
8010096a:	8b 15 40 10 11 80    	mov    0x80111040,%edx
80100970:	83 ea 80             	sub    $0xffffff80,%edx
80100973:	39 d0                	cmp    %edx,%eax
80100975:	75 1a                	jne    80100991 <consoleintr+0x165>
          input.w = input.e;
80100977:	a1 48 10 11 80       	mov    0x80111048,%eax
8010097c:	a3 44 10 11 80       	mov    %eax,0x80111044
          wakeup(&input.r);
80100981:	83 ec 0c             	sub    $0xc,%esp
80100984:	68 40 10 11 80       	push   $0x80111040
80100989:	e8 34 44 00 00       	call   80104dc2 <wakeup>
8010098e:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100991:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100992:	8b 45 08             	mov    0x8(%ebp),%eax
80100995:	ff d0                	call   *%eax
80100997:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010099a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010099e:	0f 89 aa fe ff ff    	jns    8010084e <consoleintr+0x22>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009a4:	83 ec 0c             	sub    $0xc,%esp
801009a7:	68 c0 b5 10 80       	push   $0x8010b5c0
801009ac:	e8 de 47 00 00       	call   8010518f <release>
801009b1:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009b8:	74 05                	je     801009bf <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
801009ba:	e8 c1 44 00 00       	call   80104e80 <procdump>
  }
}
801009bf:	90                   	nop
801009c0:	c9                   	leave  
801009c1:	c3                   	ret    

801009c2 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009c2:	55                   	push   %ebp
801009c3:	89 e5                	mov    %esp,%ebp
801009c5:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	ff 75 08             	pushl  0x8(%ebp)
801009ce:	e8 50 11 00 00       	call   80101b23 <iunlock>
801009d3:	83 c4 10             	add    $0x10,%esp
  target = n;
801009d6:	8b 45 10             	mov    0x10(%ebp),%eax
801009d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009dc:	83 ec 0c             	sub    $0xc,%esp
801009df:	68 c0 b5 10 80       	push   $0x8010b5c0
801009e4:	e8 38 47 00 00       	call   80105121 <acquire>
801009e9:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009ec:	e9 ab 00 00 00       	jmp    80100a9c <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009f1:	e8 42 39 00 00       	call   80104338 <myproc>
801009f6:	8b 40 24             	mov    0x24(%eax),%eax
801009f9:	85 c0                	test   %eax,%eax
801009fb:	74 28                	je     80100a25 <consoleread+0x63>
        release(&cons.lock);
801009fd:	83 ec 0c             	sub    $0xc,%esp
80100a00:	68 c0 b5 10 80       	push   $0x8010b5c0
80100a05:	e8 85 47 00 00       	call   8010518f <release>
80100a0a:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a0d:	83 ec 0c             	sub    $0xc,%esp
80100a10:	ff 75 08             	pushl  0x8(%ebp)
80100a13:	e8 f8 0f 00 00       	call   80101a10 <ilock>
80100a18:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a20:	e9 ab 00 00 00       	jmp    80100ad0 <consoleread+0x10e>
      }
      sleep(&input.r, &cons.lock);
80100a25:	83 ec 08             	sub    $0x8,%esp
80100a28:	68 c0 b5 10 80       	push   $0x8010b5c0
80100a2d:	68 40 10 11 80       	push   $0x80111040
80100a32:	e8 a2 42 00 00       	call   80104cd9 <sleep>
80100a37:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100a3a:	8b 15 40 10 11 80    	mov    0x80111040,%edx
80100a40:	a1 44 10 11 80       	mov    0x80111044,%eax
80100a45:	39 c2                	cmp    %eax,%edx
80100a47:	74 a8                	je     801009f1 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a49:	a1 40 10 11 80       	mov    0x80111040,%eax
80100a4e:	8d 50 01             	lea    0x1(%eax),%edx
80100a51:	89 15 40 10 11 80    	mov    %edx,0x80111040
80100a57:	83 e0 7f             	and    $0x7f,%eax
80100a5a:	0f b6 80 c0 0f 11 80 	movzbl -0x7feef040(%eax),%eax
80100a61:	0f be c0             	movsbl %al,%eax
80100a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a67:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a6b:	75 17                	jne    80100a84 <consoleread+0xc2>
      if(n < target){
80100a6d:	8b 45 10             	mov    0x10(%ebp),%eax
80100a70:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a73:	73 2f                	jae    80100aa4 <consoleread+0xe2>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a75:	a1 40 10 11 80       	mov    0x80111040,%eax
80100a7a:	83 e8 01             	sub    $0x1,%eax
80100a7d:	a3 40 10 11 80       	mov    %eax,0x80111040
      }
      break;
80100a82:	eb 20                	jmp    80100aa4 <consoleread+0xe2>
    }
    *dst++ = c;
80100a84:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a87:	8d 50 01             	lea    0x1(%eax),%edx
80100a8a:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a90:	88 10                	mov    %dl,(%eax)
    --n;
80100a92:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a96:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a9a:	74 0b                	je     80100aa7 <consoleread+0xe5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100aa0:	7f 98                	jg     80100a3a <consoleread+0x78>
80100aa2:	eb 04                	jmp    80100aa8 <consoleread+0xe6>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100aa4:	90                   	nop
80100aa5:	eb 01                	jmp    80100aa8 <consoleread+0xe6>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100aa7:	90                   	nop
  }
  release(&cons.lock);
80100aa8:	83 ec 0c             	sub    $0xc,%esp
80100aab:	68 c0 b5 10 80       	push   $0x8010b5c0
80100ab0:	e8 da 46 00 00       	call   8010518f <release>
80100ab5:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ab8:	83 ec 0c             	sub    $0xc,%esp
80100abb:	ff 75 08             	pushl  0x8(%ebp)
80100abe:	e8 4d 0f 00 00       	call   80101a10 <ilock>
80100ac3:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100ac6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100acc:	29 c2                	sub    %eax,%edx
80100ace:	89 d0                	mov    %edx,%eax
}
80100ad0:	c9                   	leave  
80100ad1:	c3                   	ret    

80100ad2 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100ad2:	55                   	push   %ebp
80100ad3:	89 e5                	mov    %esp,%ebp
80100ad5:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100ad8:	83 ec 0c             	sub    $0xc,%esp
80100adb:	ff 75 08             	pushl  0x8(%ebp)
80100ade:	e8 40 10 00 00       	call   80101b23 <iunlock>
80100ae3:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100ae6:	83 ec 0c             	sub    $0xc,%esp
80100ae9:	68 c0 b5 10 80       	push   $0x8010b5c0
80100aee:	e8 2e 46 00 00       	call   80105121 <acquire>
80100af3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100af6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100afd:	eb 21                	jmp    80100b20 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b02:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b05:	01 d0                	add    %edx,%eax
80100b07:	0f b6 00             	movzbl (%eax),%eax
80100b0a:	0f be c0             	movsbl %al,%eax
80100b0d:	0f b6 c0             	movzbl %al,%eax
80100b10:	83 ec 0c             	sub    $0xc,%esp
80100b13:	50                   	push   %eax
80100b14:	e8 ac fc ff ff       	call   801007c5 <consputc>
80100b19:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b1c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b23:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b26:	7c d7                	jl     80100aff <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b28:	83 ec 0c             	sub    $0xc,%esp
80100b2b:	68 c0 b5 10 80       	push   $0x8010b5c0
80100b30:	e8 5a 46 00 00       	call   8010518f <release>
80100b35:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b38:	83 ec 0c             	sub    $0xc,%esp
80100b3b:	ff 75 08             	pushl  0x8(%ebp)
80100b3e:	e8 cd 0e 00 00       	call   80101a10 <ilock>
80100b43:	83 c4 10             	add    $0x10,%esp

  return n;
80100b46:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b49:	c9                   	leave  
80100b4a:	c3                   	ret    

80100b4b <consoleinit>:

void
consoleinit(void)
{
80100b4b:	55                   	push   %ebp
80100b4c:	89 e5                	mov    %esp,%ebp
80100b4e:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b51:	83 ec 08             	sub    $0x8,%esp
80100b54:	68 ba 87 10 80       	push   $0x801087ba
80100b59:	68 c0 b5 10 80       	push   $0x8010b5c0
80100b5e:	e8 9c 45 00 00       	call   801050ff <initlock>
80100b63:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b66:	c7 05 0c 1a 11 80 d2 	movl   $0x80100ad2,0x80111a0c
80100b6d:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b70:	c7 05 08 1a 11 80 c2 	movl   $0x801009c2,0x80111a08
80100b77:	09 10 80 
  cons.locking = 1;
80100b7a:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100b81:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b84:	83 ec 08             	sub    $0x8,%esp
80100b87:	6a 00                	push   $0x0
80100b89:	6a 01                	push   $0x1
80100b8b:	e8 94 1f 00 00       	call   80102b24 <ioapicenable>
80100b90:	83 c4 10             	add    $0x10,%esp
}
80100b93:	90                   	nop
80100b94:	c9                   	leave  
80100b95:	c3                   	ret    

80100b96 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b96:	55                   	push   %ebp
80100b97:	89 e5                	mov    %esp,%ebp
80100b99:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b9f:	e8 94 37 00 00       	call   80104338 <myproc>
80100ba4:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100ba7:	e8 89 29 00 00       	call   80103535 <begin_op>

  if((ip = namei(path)) == 0){
80100bac:	83 ec 0c             	sub    $0xc,%esp
80100baf:	ff 75 08             	pushl  0x8(%ebp)
80100bb2:	e8 99 19 00 00       	call   80102550 <namei>
80100bb7:	83 c4 10             	add    $0x10,%esp
80100bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bbd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bc1:	75 1f                	jne    80100be2 <exec+0x4c>
    end_op();
80100bc3:	e8 f9 29 00 00       	call   801035c1 <end_op>
    cprintf("exec: fail\n");
80100bc8:	83 ec 0c             	sub    $0xc,%esp
80100bcb:	68 c2 87 10 80       	push   $0x801087c2
80100bd0:	e8 2b f8 ff ff       	call   80100400 <cprintf>
80100bd5:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bdd:	e9 f1 03 00 00       	jmp    80100fd3 <exec+0x43d>
  }
  ilock(ip);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff 75 d8             	pushl  -0x28(%ebp)
80100be8:	e8 23 0e 00 00       	call   80101a10 <ilock>
80100bed:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bf0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bf7:	6a 34                	push   $0x34
80100bf9:	6a 00                	push   $0x0
80100bfb:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c01:	50                   	push   %eax
80100c02:	ff 75 d8             	pushl  -0x28(%ebp)
80100c05:	e8 f7 12 00 00       	call   80101f01 <readi>
80100c0a:	83 c4 10             	add    $0x10,%esp
80100c0d:	83 f8 34             	cmp    $0x34,%eax
80100c10:	0f 85 66 03 00 00    	jne    80100f7c <exec+0x3e6>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c16:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c1c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c21:	0f 85 58 03 00 00    	jne    80100f7f <exec+0x3e9>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c27:	e8 f6 70 00 00       	call   80107d22 <setupkvm>
80100c2c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c2f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c33:	0f 84 49 03 00 00    	je     80100f82 <exec+0x3ec>
    goto bad;

  // Load program into memory.
  // pj2 make page 0 unaccessible
  sz = PGSIZE;
80100c39:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
//  if((sz = allocuvm(pgdir,sz,sz + PGSIZE)) == 0)
//    goto bad;
//  clearpteu(pgdir,(char*)(sz - PGSIZE));

  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c40:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c47:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c50:	e9 de 00 00 00       	jmp    80100d33 <exec+0x19d>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c55:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c58:	6a 20                	push   $0x20
80100c5a:	50                   	push   %eax
80100c5b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c61:	50                   	push   %eax
80100c62:	ff 75 d8             	pushl  -0x28(%ebp)
80100c65:	e8 97 12 00 00       	call   80101f01 <readi>
80100c6a:	83 c4 10             	add    $0x10,%esp
80100c6d:	83 f8 20             	cmp    $0x20,%eax
80100c70:	0f 85 0f 03 00 00    	jne    80100f85 <exec+0x3ef>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c76:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c7c:	83 f8 01             	cmp    $0x1,%eax
80100c7f:	0f 85 a0 00 00 00    	jne    80100d25 <exec+0x18f>
      continue;
    if(ph.memsz < ph.filesz)
80100c85:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c8b:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c91:	39 c2                	cmp    %eax,%edx
80100c93:	0f 82 ef 02 00 00    	jb     80100f88 <exec+0x3f2>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c99:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c9f:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100ca5:	01 c2                	add    %eax,%edx
80100ca7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cad:	39 c2                	cmp    %eax,%edx
80100caf:	0f 82 d6 02 00 00    	jb     80100f8b <exec+0x3f5>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cb5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100cbb:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cc1:	01 d0                	add    %edx,%eax
80100cc3:	83 ec 04             	sub    $0x4,%esp
80100cc6:	50                   	push   %eax
80100cc7:	ff 75 e0             	pushl  -0x20(%ebp)
80100cca:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ccd:	e8 f5 73 00 00       	call   801080c7 <allocuvm>
80100cd2:	83 c4 10             	add    $0x10,%esp
80100cd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cd8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cdc:	0f 84 ac 02 00 00    	je     80100f8e <exec+0x3f8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ce2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ce8:	25 ff 0f 00 00       	and    $0xfff,%eax
80100ced:	85 c0                	test   %eax,%eax
80100cef:	0f 85 9c 02 00 00    	jne    80100f91 <exec+0x3fb>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cf5:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100cfb:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d01:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d07:	83 ec 0c             	sub    $0xc,%esp
80100d0a:	52                   	push   %edx
80100d0b:	50                   	push   %eax
80100d0c:	ff 75 d8             	pushl  -0x28(%ebp)
80100d0f:	51                   	push   %ecx
80100d10:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d13:	e8 e2 72 00 00       	call   80107ffa <loaduvm>
80100d18:	83 c4 20             	add    $0x20,%esp
80100d1b:	85 c0                	test   %eax,%eax
80100d1d:	0f 88 71 02 00 00    	js     80100f94 <exec+0x3fe>
80100d23:	eb 01                	jmp    80100d26 <exec+0x190>

  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d25:	90                   	nop
  sz = PGSIZE;
//  if((sz = allocuvm(pgdir,sz,sz + PGSIZE)) == 0)
//    goto bad;
//  clearpteu(pgdir,(char*)(sz - PGSIZE));

  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d26:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d2d:	83 c0 20             	add    $0x20,%eax
80100d30:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d33:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d3a:	0f b7 c0             	movzwl %ax,%eax
80100d3d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d40:	0f 8f 0f ff ff ff    	jg     80100c55 <exec+0xbf>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d46:	83 ec 0c             	sub    $0xc,%esp
80100d49:	ff 75 d8             	pushl  -0x28(%ebp)
80100d4c:	e8 f0 0e 00 00       	call   80101c41 <iunlockput>
80100d51:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d54:	e8 68 28 00 00       	call   801035c1 <end_op>
  ip = 0;
80100d59:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d63:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d70:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d73:	05 00 20 00 00       	add    $0x2000,%eax
80100d78:	83 ec 04             	sub    $0x4,%esp
80100d7b:	50                   	push   %eax
80100d7c:	ff 75 e0             	pushl  -0x20(%ebp)
80100d7f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d82:	e8 40 73 00 00       	call   801080c7 <allocuvm>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d91:	0f 84 00 02 00 00    	je     80100f97 <exec+0x401>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d97:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d9a:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d9f:	83 ec 08             	sub    $0x8,%esp
80100da2:	50                   	push   %eax
80100da3:	ff 75 d4             	pushl  -0x2c(%ebp)
80100da6:	e8 80 75 00 00       	call   8010832b <clearpteu>
80100dab:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100dae:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100db1:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100db4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100dbb:	e9 96 00 00 00       	jmp    80100e56 <exec+0x2c0>
    if(argc >= MAXARG)
80100dc0:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dc4:	0f 87 d0 01 00 00    	ja     80100f9a <exec+0x404>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dd7:	01 d0                	add    %edx,%eax
80100dd9:	8b 00                	mov    (%eax),%eax
80100ddb:	83 ec 0c             	sub    $0xc,%esp
80100dde:	50                   	push   %eax
80100ddf:	e8 11 48 00 00       	call   801055f5 <strlen>
80100de4:	83 c4 10             	add    $0x10,%esp
80100de7:	89 c2                	mov    %eax,%edx
80100de9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dec:	29 d0                	sub    %edx,%eax
80100dee:	83 e8 01             	sub    $0x1,%eax
80100df1:	83 e0 fc             	and    $0xfffffffc,%eax
80100df4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e01:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e04:	01 d0                	add    %edx,%eax
80100e06:	8b 00                	mov    (%eax),%eax
80100e08:	83 ec 0c             	sub    $0xc,%esp
80100e0b:	50                   	push   %eax
80100e0c:	e8 e4 47 00 00       	call   801055f5 <strlen>
80100e11:	83 c4 10             	add    $0x10,%esp
80100e14:	83 c0 01             	add    $0x1,%eax
80100e17:	89 c1                	mov    %eax,%ecx
80100e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e23:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e26:	01 d0                	add    %edx,%eax
80100e28:	8b 00                	mov    (%eax),%eax
80100e2a:	51                   	push   %ecx
80100e2b:	50                   	push   %eax
80100e2c:	ff 75 dc             	pushl  -0x24(%ebp)
80100e2f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e32:	e8 a0 76 00 00       	call   801084d7 <copyout>
80100e37:	83 c4 10             	add    $0x10,%esp
80100e3a:	85 c0                	test   %eax,%eax
80100e3c:	0f 88 5b 01 00 00    	js     80100f9d <exec+0x407>
      goto bad;
    ustack[3+argc] = sp;
80100e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e45:	8d 50 03             	lea    0x3(%eax),%edx
80100e48:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e4b:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e52:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e60:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e63:	01 d0                	add    %edx,%eax
80100e65:	8b 00                	mov    (%eax),%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	0f 85 51 ff ff ff    	jne    80100dc0 <exec+0x22a>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e72:	83 c0 03             	add    $0x3,%eax
80100e75:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e7c:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e80:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e87:	ff ff ff 
  ustack[1] = argc;
80100e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8d:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e96:	83 c0 01             	add    $0x1,%eax
80100e99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ea0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ea3:	29 d0                	sub    %edx,%eax
80100ea5:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eae:	83 c0 04             	add    $0x4,%eax
80100eb1:	c1 e0 02             	shl    $0x2,%eax
80100eb4:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eba:	83 c0 04             	add    $0x4,%eax
80100ebd:	c1 e0 02             	shl    $0x2,%eax
80100ec0:	50                   	push   %eax
80100ec1:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100ec7:	50                   	push   %eax
80100ec8:	ff 75 dc             	pushl  -0x24(%ebp)
80100ecb:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ece:	e8 04 76 00 00       	call   801084d7 <copyout>
80100ed3:	83 c4 10             	add    $0x10,%esp
80100ed6:	85 c0                	test   %eax,%eax
80100ed8:	0f 88 c2 00 00 00    	js     80100fa0 <exec+0x40a>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ede:	8b 45 08             	mov    0x8(%ebp),%eax
80100ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100eea:	eb 17                	jmp    80100f03 <exec+0x36d>
    if(*s == '/')
80100eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eef:	0f b6 00             	movzbl (%eax),%eax
80100ef2:	3c 2f                	cmp    $0x2f,%al
80100ef4:	75 09                	jne    80100eff <exec+0x369>
      last = s+1;
80100ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ef9:	83 c0 01             	add    $0x1,%eax
80100efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100eff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f06:	0f b6 00             	movzbl (%eax),%eax
80100f09:	84 c0                	test   %al,%al
80100f0b:	75 df                	jne    80100eec <exec+0x356>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f10:	83 c0 6c             	add    $0x6c,%eax
80100f13:	83 ec 04             	sub    $0x4,%esp
80100f16:	6a 10                	push   $0x10
80100f18:	ff 75 f0             	pushl  -0x10(%ebp)
80100f1b:	50                   	push   %eax
80100f1c:	e8 8a 46 00 00       	call   801055ab <safestrcpy>
80100f21:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f24:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f27:	8b 40 04             	mov    0x4(%eax),%eax
80100f2a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f30:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f33:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f36:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f39:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f3c:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f41:	8b 40 18             	mov    0x18(%eax),%eax
80100f44:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f4a:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f50:	8b 40 18             	mov    0x18(%eax),%eax
80100f53:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f56:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f59:	83 ec 0c             	sub    $0xc,%esp
80100f5c:	ff 75 d0             	pushl  -0x30(%ebp)
80100f5f:	e8 88 6e 00 00       	call   80107dec <switchuvm>
80100f64:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f67:	83 ec 0c             	sub    $0xc,%esp
80100f6a:	ff 75 cc             	pushl  -0x34(%ebp)
80100f6d:	e8 20 73 00 00       	call   80108292 <freevm>
80100f72:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f75:	b8 00 00 00 00       	mov    $0x0,%eax
80100f7a:	eb 57                	jmp    80100fd3 <exec+0x43d>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
80100f7c:	90                   	nop
80100f7d:	eb 22                	jmp    80100fa1 <exec+0x40b>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f7f:	90                   	nop
80100f80:	eb 1f                	jmp    80100fa1 <exec+0x40b>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f82:	90                   	nop
80100f83:	eb 1c                	jmp    80100fa1 <exec+0x40b>
//    goto bad;
//  clearpteu(pgdir,(char*)(sz - PGSIZE));

  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f85:	90                   	nop
80100f86:	eb 19                	jmp    80100fa1 <exec+0x40b>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f88:	90                   	nop
80100f89:	eb 16                	jmp    80100fa1 <exec+0x40b>
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
80100f8b:	90                   	nop
80100f8c:	eb 13                	jmp    80100fa1 <exec+0x40b>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f8e:	90                   	nop
80100f8f:	eb 10                	jmp    80100fa1 <exec+0x40b>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
80100f91:	90                   	nop
80100f92:	eb 0d                	jmp    80100fa1 <exec+0x40b>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100f94:	90                   	nop
80100f95:	eb 0a                	jmp    80100fa1 <exec+0x40b>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100f97:	90                   	nop
80100f98:	eb 07                	jmp    80100fa1 <exec+0x40b>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f9a:	90                   	nop
80100f9b:	eb 04                	jmp    80100fa1 <exec+0x40b>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f9d:	90                   	nop
80100f9e:	eb 01                	jmp    80100fa1 <exec+0x40b>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100fa0:	90                   	nop
  switchuvm(curproc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100fa1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fa5:	74 0e                	je     80100fb5 <exec+0x41f>
    freevm(pgdir);
80100fa7:	83 ec 0c             	sub    $0xc,%esp
80100faa:	ff 75 d4             	pushl  -0x2c(%ebp)
80100fad:	e8 e0 72 00 00       	call   80108292 <freevm>
80100fb2:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fb5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fb9:	74 13                	je     80100fce <exec+0x438>
    iunlockput(ip);
80100fbb:	83 ec 0c             	sub    $0xc,%esp
80100fbe:	ff 75 d8             	pushl  -0x28(%ebp)
80100fc1:	e8 7b 0c 00 00       	call   80101c41 <iunlockput>
80100fc6:	83 c4 10             	add    $0x10,%esp
    end_op();
80100fc9:	e8 f3 25 00 00       	call   801035c1 <end_op>
  }
  return -1;
80100fce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fd3:	c9                   	leave  
80100fd4:	c3                   	ret    

80100fd5 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fd5:	55                   	push   %ebp
80100fd6:	89 e5                	mov    %esp,%ebp
80100fd8:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100fdb:	83 ec 08             	sub    $0x8,%esp
80100fde:	68 ce 87 10 80       	push   $0x801087ce
80100fe3:	68 60 10 11 80       	push   $0x80111060
80100fe8:	e8 12 41 00 00       	call   801050ff <initlock>
80100fed:	83 c4 10             	add    $0x10,%esp
}
80100ff0:	90                   	nop
80100ff1:	c9                   	leave  
80100ff2:	c3                   	ret    

80100ff3 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ff3:	55                   	push   %ebp
80100ff4:	89 e5                	mov    %esp,%ebp
80100ff6:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100ff9:	83 ec 0c             	sub    $0xc,%esp
80100ffc:	68 60 10 11 80       	push   $0x80111060
80101001:	e8 1b 41 00 00       	call   80105121 <acquire>
80101006:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101009:	c7 45 f4 94 10 11 80 	movl   $0x80111094,-0xc(%ebp)
80101010:	eb 2d                	jmp    8010103f <filealloc+0x4c>
    if(f->ref == 0){
80101012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101015:	8b 40 04             	mov    0x4(%eax),%eax
80101018:	85 c0                	test   %eax,%eax
8010101a:	75 1f                	jne    8010103b <filealloc+0x48>
      f->ref = 1;
8010101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010101f:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	68 60 10 11 80       	push   $0x80111060
8010102e:	e8 5c 41 00 00       	call   8010518f <release>
80101033:	83 c4 10             	add    $0x10,%esp
      return f;
80101036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101039:	eb 23                	jmp    8010105e <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010103b:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010103f:	b8 f4 19 11 80       	mov    $0x801119f4,%eax
80101044:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101047:	72 c9                	jb     80101012 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101049:	83 ec 0c             	sub    $0xc,%esp
8010104c:	68 60 10 11 80       	push   $0x80111060
80101051:	e8 39 41 00 00       	call   8010518f <release>
80101056:	83 c4 10             	add    $0x10,%esp
  return 0;
80101059:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010105e:	c9                   	leave  
8010105f:	c3                   	ret    

80101060 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101066:	83 ec 0c             	sub    $0xc,%esp
80101069:	68 60 10 11 80       	push   $0x80111060
8010106e:	e8 ae 40 00 00       	call   80105121 <acquire>
80101073:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101076:	8b 45 08             	mov    0x8(%ebp),%eax
80101079:	8b 40 04             	mov    0x4(%eax),%eax
8010107c:	85 c0                	test   %eax,%eax
8010107e:	7f 0d                	jg     8010108d <filedup+0x2d>
    panic("filedup");
80101080:	83 ec 0c             	sub    $0xc,%esp
80101083:	68 d5 87 10 80       	push   $0x801087d5
80101088:	e8 13 f5 ff ff       	call   801005a0 <panic>
  f->ref++;
8010108d:	8b 45 08             	mov    0x8(%ebp),%eax
80101090:	8b 40 04             	mov    0x4(%eax),%eax
80101093:	8d 50 01             	lea    0x1(%eax),%edx
80101096:	8b 45 08             	mov    0x8(%ebp),%eax
80101099:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010109c:	83 ec 0c             	sub    $0xc,%esp
8010109f:	68 60 10 11 80       	push   $0x80111060
801010a4:	e8 e6 40 00 00       	call   8010518f <release>
801010a9:	83 c4 10             	add    $0x10,%esp
  return f;
801010ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010af:	c9                   	leave  
801010b0:	c3                   	ret    

801010b1 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010b1:	55                   	push   %ebp
801010b2:	89 e5                	mov    %esp,%ebp
801010b4:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010b7:	83 ec 0c             	sub    $0xc,%esp
801010ba:	68 60 10 11 80       	push   $0x80111060
801010bf:	e8 5d 40 00 00       	call   80105121 <acquire>
801010c4:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010c7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ca:	8b 40 04             	mov    0x4(%eax),%eax
801010cd:	85 c0                	test   %eax,%eax
801010cf:	7f 0d                	jg     801010de <fileclose+0x2d>
    panic("fileclose");
801010d1:	83 ec 0c             	sub    $0xc,%esp
801010d4:	68 dd 87 10 80       	push   $0x801087dd
801010d9:	e8 c2 f4 ff ff       	call   801005a0 <panic>
  if(--f->ref > 0){
801010de:	8b 45 08             	mov    0x8(%ebp),%eax
801010e1:	8b 40 04             	mov    0x4(%eax),%eax
801010e4:	8d 50 ff             	lea    -0x1(%eax),%edx
801010e7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ea:	89 50 04             	mov    %edx,0x4(%eax)
801010ed:	8b 45 08             	mov    0x8(%ebp),%eax
801010f0:	8b 40 04             	mov    0x4(%eax),%eax
801010f3:	85 c0                	test   %eax,%eax
801010f5:	7e 15                	jle    8010110c <fileclose+0x5b>
    release(&ftable.lock);
801010f7:	83 ec 0c             	sub    $0xc,%esp
801010fa:	68 60 10 11 80       	push   $0x80111060
801010ff:	e8 8b 40 00 00       	call   8010518f <release>
80101104:	83 c4 10             	add    $0x10,%esp
80101107:	e9 8b 00 00 00       	jmp    80101197 <fileclose+0xe6>
    return;
  }
  ff = *f;
8010110c:	8b 45 08             	mov    0x8(%ebp),%eax
8010110f:	8b 10                	mov    (%eax),%edx
80101111:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101114:	8b 50 04             	mov    0x4(%eax),%edx
80101117:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010111a:	8b 50 08             	mov    0x8(%eax),%edx
8010111d:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101120:	8b 50 0c             	mov    0xc(%eax),%edx
80101123:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101126:	8b 50 10             	mov    0x10(%eax),%edx
80101129:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010112c:	8b 40 14             	mov    0x14(%eax),%eax
8010112f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101132:	8b 45 08             	mov    0x8(%ebp),%eax
80101135:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010113c:	8b 45 08             	mov    0x8(%ebp),%eax
8010113f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101145:	83 ec 0c             	sub    $0xc,%esp
80101148:	68 60 10 11 80       	push   $0x80111060
8010114d:	e8 3d 40 00 00       	call   8010518f <release>
80101152:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101155:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101158:	83 f8 01             	cmp    $0x1,%eax
8010115b:	75 19                	jne    80101176 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010115d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101161:	0f be d0             	movsbl %al,%edx
80101164:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101167:	83 ec 08             	sub    $0x8,%esp
8010116a:	52                   	push   %edx
8010116b:	50                   	push   %eax
8010116c:	e8 a6 2d 00 00       	call   80103f17 <pipeclose>
80101171:	83 c4 10             	add    $0x10,%esp
80101174:	eb 21                	jmp    80101197 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101176:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101179:	83 f8 02             	cmp    $0x2,%eax
8010117c:	75 19                	jne    80101197 <fileclose+0xe6>
    begin_op();
8010117e:	e8 b2 23 00 00       	call   80103535 <begin_op>
    iput(ff.ip);
80101183:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101186:	83 ec 0c             	sub    $0xc,%esp
80101189:	50                   	push   %eax
8010118a:	e8 e2 09 00 00       	call   80101b71 <iput>
8010118f:	83 c4 10             	add    $0x10,%esp
    end_op();
80101192:	e8 2a 24 00 00       	call   801035c1 <end_op>
  }
}
80101197:	c9                   	leave  
80101198:	c3                   	ret    

80101199 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101199:	55                   	push   %ebp
8010119a:	89 e5                	mov    %esp,%ebp
8010119c:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010119f:	8b 45 08             	mov    0x8(%ebp),%eax
801011a2:	8b 00                	mov    (%eax),%eax
801011a4:	83 f8 02             	cmp    $0x2,%eax
801011a7:	75 40                	jne    801011e9 <filestat+0x50>
    ilock(f->ip);
801011a9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ac:	8b 40 10             	mov    0x10(%eax),%eax
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	50                   	push   %eax
801011b3:	e8 58 08 00 00       	call   80101a10 <ilock>
801011b8:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011bb:	8b 45 08             	mov    0x8(%ebp),%eax
801011be:	8b 40 10             	mov    0x10(%eax),%eax
801011c1:	83 ec 08             	sub    $0x8,%esp
801011c4:	ff 75 0c             	pushl  0xc(%ebp)
801011c7:	50                   	push   %eax
801011c8:	e8 ee 0c 00 00       	call   80101ebb <stati>
801011cd:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011d0:	8b 45 08             	mov    0x8(%ebp),%eax
801011d3:	8b 40 10             	mov    0x10(%eax),%eax
801011d6:	83 ec 0c             	sub    $0xc,%esp
801011d9:	50                   	push   %eax
801011da:	e8 44 09 00 00       	call   80101b23 <iunlock>
801011df:	83 c4 10             	add    $0x10,%esp
    return 0;
801011e2:	b8 00 00 00 00       	mov    $0x0,%eax
801011e7:	eb 05                	jmp    801011ee <filestat+0x55>
  }
  return -1;
801011e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011ee:	c9                   	leave  
801011ef:	c3                   	ret    

801011f0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011f6:	8b 45 08             	mov    0x8(%ebp),%eax
801011f9:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011fd:	84 c0                	test   %al,%al
801011ff:	75 0a                	jne    8010120b <fileread+0x1b>
    return -1;
80101201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101206:	e9 9b 00 00 00       	jmp    801012a6 <fileread+0xb6>
  if(f->type == FD_PIPE)
8010120b:	8b 45 08             	mov    0x8(%ebp),%eax
8010120e:	8b 00                	mov    (%eax),%eax
80101210:	83 f8 01             	cmp    $0x1,%eax
80101213:	75 1a                	jne    8010122f <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101215:	8b 45 08             	mov    0x8(%ebp),%eax
80101218:	8b 40 0c             	mov    0xc(%eax),%eax
8010121b:	83 ec 04             	sub    $0x4,%esp
8010121e:	ff 75 10             	pushl  0x10(%ebp)
80101221:	ff 75 0c             	pushl  0xc(%ebp)
80101224:	50                   	push   %eax
80101225:	e8 94 2e 00 00       	call   801040be <piperead>
8010122a:	83 c4 10             	add    $0x10,%esp
8010122d:	eb 77                	jmp    801012a6 <fileread+0xb6>
  if(f->type == FD_INODE){
8010122f:	8b 45 08             	mov    0x8(%ebp),%eax
80101232:	8b 00                	mov    (%eax),%eax
80101234:	83 f8 02             	cmp    $0x2,%eax
80101237:	75 60                	jne    80101299 <fileread+0xa9>
    ilock(f->ip);
80101239:	8b 45 08             	mov    0x8(%ebp),%eax
8010123c:	8b 40 10             	mov    0x10(%eax),%eax
8010123f:	83 ec 0c             	sub    $0xc,%esp
80101242:	50                   	push   %eax
80101243:	e8 c8 07 00 00       	call   80101a10 <ilock>
80101248:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010124b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010124e:	8b 45 08             	mov    0x8(%ebp),%eax
80101251:	8b 50 14             	mov    0x14(%eax),%edx
80101254:	8b 45 08             	mov    0x8(%ebp),%eax
80101257:	8b 40 10             	mov    0x10(%eax),%eax
8010125a:	51                   	push   %ecx
8010125b:	52                   	push   %edx
8010125c:	ff 75 0c             	pushl  0xc(%ebp)
8010125f:	50                   	push   %eax
80101260:	e8 9c 0c 00 00       	call   80101f01 <readi>
80101265:	83 c4 10             	add    $0x10,%esp
80101268:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010126b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010126f:	7e 11                	jle    80101282 <fileread+0x92>
      f->off += r;
80101271:	8b 45 08             	mov    0x8(%ebp),%eax
80101274:	8b 50 14             	mov    0x14(%eax),%edx
80101277:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010127a:	01 c2                	add    %eax,%edx
8010127c:	8b 45 08             	mov    0x8(%ebp),%eax
8010127f:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101282:	8b 45 08             	mov    0x8(%ebp),%eax
80101285:	8b 40 10             	mov    0x10(%eax),%eax
80101288:	83 ec 0c             	sub    $0xc,%esp
8010128b:	50                   	push   %eax
8010128c:	e8 92 08 00 00       	call   80101b23 <iunlock>
80101291:	83 c4 10             	add    $0x10,%esp
    return r;
80101294:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101297:	eb 0d                	jmp    801012a6 <fileread+0xb6>
  }
  panic("fileread");
80101299:	83 ec 0c             	sub    $0xc,%esp
8010129c:	68 e7 87 10 80       	push   $0x801087e7
801012a1:	e8 fa f2 ff ff       	call   801005a0 <panic>
}
801012a6:	c9                   	leave  
801012a7:	c3                   	ret    

801012a8 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012a8:	55                   	push   %ebp
801012a9:	89 e5                	mov    %esp,%ebp
801012ab:	53                   	push   %ebx
801012ac:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012af:	8b 45 08             	mov    0x8(%ebp),%eax
801012b2:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012b6:	84 c0                	test   %al,%al
801012b8:	75 0a                	jne    801012c4 <filewrite+0x1c>
    return -1;
801012ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012bf:	e9 1b 01 00 00       	jmp    801013df <filewrite+0x137>
  if(f->type == FD_PIPE)
801012c4:	8b 45 08             	mov    0x8(%ebp),%eax
801012c7:	8b 00                	mov    (%eax),%eax
801012c9:	83 f8 01             	cmp    $0x1,%eax
801012cc:	75 1d                	jne    801012eb <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012ce:	8b 45 08             	mov    0x8(%ebp),%eax
801012d1:	8b 40 0c             	mov    0xc(%eax),%eax
801012d4:	83 ec 04             	sub    $0x4,%esp
801012d7:	ff 75 10             	pushl  0x10(%ebp)
801012da:	ff 75 0c             	pushl  0xc(%ebp)
801012dd:	50                   	push   %eax
801012de:	e8 de 2c 00 00       	call   80103fc1 <pipewrite>
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	e9 f4 00 00 00       	jmp    801013df <filewrite+0x137>
  if(f->type == FD_INODE){
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	8b 00                	mov    (%eax),%eax
801012f0:	83 f8 02             	cmp    $0x2,%eax
801012f3:	0f 85 d9 00 00 00    	jne    801013d2 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
801012f9:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101307:	e9 a3 00 00 00       	jmp    801013af <filewrite+0x107>
      int n1 = n - i;
8010130c:	8b 45 10             	mov    0x10(%ebp),%eax
8010130f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101312:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101315:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101318:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010131b:	7e 06                	jle    80101323 <filewrite+0x7b>
        n1 = max;
8010131d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101320:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101323:	e8 0d 22 00 00       	call   80103535 <begin_op>
      ilock(f->ip);
80101328:	8b 45 08             	mov    0x8(%ebp),%eax
8010132b:	8b 40 10             	mov    0x10(%eax),%eax
8010132e:	83 ec 0c             	sub    $0xc,%esp
80101331:	50                   	push   %eax
80101332:	e8 d9 06 00 00       	call   80101a10 <ilock>
80101337:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010133a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010133d:	8b 45 08             	mov    0x8(%ebp),%eax
80101340:	8b 50 14             	mov    0x14(%eax),%edx
80101343:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101346:	8b 45 0c             	mov    0xc(%ebp),%eax
80101349:	01 c3                	add    %eax,%ebx
8010134b:	8b 45 08             	mov    0x8(%ebp),%eax
8010134e:	8b 40 10             	mov    0x10(%eax),%eax
80101351:	51                   	push   %ecx
80101352:	52                   	push   %edx
80101353:	53                   	push   %ebx
80101354:	50                   	push   %eax
80101355:	e8 fe 0c 00 00       	call   80102058 <writei>
8010135a:	83 c4 10             	add    $0x10,%esp
8010135d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101360:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101364:	7e 11                	jle    80101377 <filewrite+0xcf>
        f->off += r;
80101366:	8b 45 08             	mov    0x8(%ebp),%eax
80101369:	8b 50 14             	mov    0x14(%eax),%edx
8010136c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010136f:	01 c2                	add    %eax,%edx
80101371:	8b 45 08             	mov    0x8(%ebp),%eax
80101374:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101377:	8b 45 08             	mov    0x8(%ebp),%eax
8010137a:	8b 40 10             	mov    0x10(%eax),%eax
8010137d:	83 ec 0c             	sub    $0xc,%esp
80101380:	50                   	push   %eax
80101381:	e8 9d 07 00 00       	call   80101b23 <iunlock>
80101386:	83 c4 10             	add    $0x10,%esp
      end_op();
80101389:	e8 33 22 00 00       	call   801035c1 <end_op>

      if(r < 0)
8010138e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101392:	78 29                	js     801013bd <filewrite+0x115>
        break;
      if(r != n1)
80101394:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101397:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010139a:	74 0d                	je     801013a9 <filewrite+0x101>
        panic("short filewrite");
8010139c:	83 ec 0c             	sub    $0xc,%esp
8010139f:	68 f0 87 10 80       	push   $0x801087f0
801013a4:	e8 f7 f1 ff ff       	call   801005a0 <panic>
      i += r;
801013a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013ac:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b2:	3b 45 10             	cmp    0x10(%ebp),%eax
801013b5:	0f 8c 51 ff ff ff    	jl     8010130c <filewrite+0x64>
801013bb:	eb 01                	jmp    801013be <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801013bd:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801013be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c1:	3b 45 10             	cmp    0x10(%ebp),%eax
801013c4:	75 05                	jne    801013cb <filewrite+0x123>
801013c6:	8b 45 10             	mov    0x10(%ebp),%eax
801013c9:	eb 14                	jmp    801013df <filewrite+0x137>
801013cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013d0:	eb 0d                	jmp    801013df <filewrite+0x137>
  }
  panic("filewrite");
801013d2:	83 ec 0c             	sub    $0xc,%esp
801013d5:	68 00 88 10 80       	push   $0x80108800
801013da:	e8 c1 f1 ff ff       	call   801005a0 <panic>
}
801013df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013e2:	c9                   	leave  
801013e3:	c3                   	ret    

801013e4 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013e4:	55                   	push   %ebp
801013e5:	89 e5                	mov    %esp,%ebp
801013e7:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013ea:	8b 45 08             	mov    0x8(%ebp),%eax
801013ed:	83 ec 08             	sub    $0x8,%esp
801013f0:	6a 01                	push   $0x1
801013f2:	50                   	push   %eax
801013f3:	e8 d6 ed ff ff       	call   801001ce <bread>
801013f8:	83 c4 10             	add    $0x10,%esp
801013fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101401:	83 c0 5c             	add    $0x5c,%eax
80101404:	83 ec 04             	sub    $0x4,%esp
80101407:	6a 1c                	push   $0x1c
80101409:	50                   	push   %eax
8010140a:	ff 75 0c             	pushl  0xc(%ebp)
8010140d:	e8 55 40 00 00       	call   80105467 <memmove>
80101412:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101415:	83 ec 0c             	sub    $0xc,%esp
80101418:	ff 75 f4             	pushl  -0xc(%ebp)
8010141b:	e8 30 ee ff ff       	call   80100250 <brelse>
80101420:	83 c4 10             	add    $0x10,%esp
}
80101423:	90                   	nop
80101424:	c9                   	leave  
80101425:	c3                   	ret    

80101426 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101426:	55                   	push   %ebp
80101427:	89 e5                	mov    %esp,%ebp
80101429:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
8010142c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010142f:	8b 45 08             	mov    0x8(%ebp),%eax
80101432:	83 ec 08             	sub    $0x8,%esp
80101435:	52                   	push   %edx
80101436:	50                   	push   %eax
80101437:	e8 92 ed ff ff       	call   801001ce <bread>
8010143c:	83 c4 10             	add    $0x10,%esp
8010143f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101442:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101445:	83 c0 5c             	add    $0x5c,%eax
80101448:	83 ec 04             	sub    $0x4,%esp
8010144b:	68 00 02 00 00       	push   $0x200
80101450:	6a 00                	push   $0x0
80101452:	50                   	push   %eax
80101453:	e8 50 3f 00 00       	call   801053a8 <memset>
80101458:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010145b:	83 ec 0c             	sub    $0xc,%esp
8010145e:	ff 75 f4             	pushl  -0xc(%ebp)
80101461:	e8 07 23 00 00       	call   8010376d <log_write>
80101466:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101469:	83 ec 0c             	sub    $0xc,%esp
8010146c:	ff 75 f4             	pushl  -0xc(%ebp)
8010146f:	e8 dc ed ff ff       	call   80100250 <brelse>
80101474:	83 c4 10             	add    $0x10,%esp
}
80101477:	90                   	nop
80101478:	c9                   	leave  
80101479:	c3                   	ret    

8010147a <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010147a:	55                   	push   %ebp
8010147b:	89 e5                	mov    %esp,%ebp
8010147d:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101480:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101487:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010148e:	e9 13 01 00 00       	jmp    801015a6 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101496:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010149c:	85 c0                	test   %eax,%eax
8010149e:	0f 48 c2             	cmovs  %edx,%eax
801014a1:	c1 f8 0c             	sar    $0xc,%eax
801014a4:	89 c2                	mov    %eax,%edx
801014a6:	a1 78 1a 11 80       	mov    0x80111a78,%eax
801014ab:	01 d0                	add    %edx,%eax
801014ad:	83 ec 08             	sub    $0x8,%esp
801014b0:	50                   	push   %eax
801014b1:	ff 75 08             	pushl  0x8(%ebp)
801014b4:	e8 15 ed ff ff       	call   801001ce <bread>
801014b9:	83 c4 10             	add    $0x10,%esp
801014bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014c6:	e9 a6 00 00 00       	jmp    80101571 <balloc+0xf7>
      m = 1 << (bi % 8);
801014cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ce:	99                   	cltd   
801014cf:	c1 ea 1d             	shr    $0x1d,%edx
801014d2:	01 d0                	add    %edx,%eax
801014d4:	83 e0 07             	and    $0x7,%eax
801014d7:	29 d0                	sub    %edx,%eax
801014d9:	ba 01 00 00 00       	mov    $0x1,%edx
801014de:	89 c1                	mov    %eax,%ecx
801014e0:	d3 e2                	shl    %cl,%edx
801014e2:	89 d0                	mov    %edx,%eax
801014e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ea:	8d 50 07             	lea    0x7(%eax),%edx
801014ed:	85 c0                	test   %eax,%eax
801014ef:	0f 48 c2             	cmovs  %edx,%eax
801014f2:	c1 f8 03             	sar    $0x3,%eax
801014f5:	89 c2                	mov    %eax,%edx
801014f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014fa:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801014ff:	0f b6 c0             	movzbl %al,%eax
80101502:	23 45 e8             	and    -0x18(%ebp),%eax
80101505:	85 c0                	test   %eax,%eax
80101507:	75 64                	jne    8010156d <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
80101509:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010150c:	8d 50 07             	lea    0x7(%eax),%edx
8010150f:	85 c0                	test   %eax,%eax
80101511:	0f 48 c2             	cmovs  %edx,%eax
80101514:	c1 f8 03             	sar    $0x3,%eax
80101517:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010151a:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010151f:	89 d1                	mov    %edx,%ecx
80101521:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101524:	09 ca                	or     %ecx,%edx
80101526:	89 d1                	mov    %edx,%ecx
80101528:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010152b:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
8010152f:	83 ec 0c             	sub    $0xc,%esp
80101532:	ff 75 ec             	pushl  -0x14(%ebp)
80101535:	e8 33 22 00 00       	call   8010376d <log_write>
8010153a:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010153d:	83 ec 0c             	sub    $0xc,%esp
80101540:	ff 75 ec             	pushl  -0x14(%ebp)
80101543:	e8 08 ed ff ff       	call   80100250 <brelse>
80101548:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010154b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101551:	01 c2                	add    %eax,%edx
80101553:	8b 45 08             	mov    0x8(%ebp),%eax
80101556:	83 ec 08             	sub    $0x8,%esp
80101559:	52                   	push   %edx
8010155a:	50                   	push   %eax
8010155b:	e8 c6 fe ff ff       	call   80101426 <bzero>
80101560:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101563:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101566:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101569:	01 d0                	add    %edx,%eax
8010156b:	eb 57                	jmp    801015c4 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010156d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101571:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101578:	7f 17                	jg     80101591 <balloc+0x117>
8010157a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010157d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101580:	01 d0                	add    %edx,%eax
80101582:	89 c2                	mov    %eax,%edx
80101584:	a1 60 1a 11 80       	mov    0x80111a60,%eax
80101589:	39 c2                	cmp    %eax,%edx
8010158b:	0f 82 3a ff ff ff    	jb     801014cb <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101591:	83 ec 0c             	sub    $0xc,%esp
80101594:	ff 75 ec             	pushl  -0x14(%ebp)
80101597:	e8 b4 ec ff ff       	call   80100250 <brelse>
8010159c:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010159f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015a6:	8b 15 60 1a 11 80    	mov    0x80111a60,%edx
801015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015af:	39 c2                	cmp    %eax,%edx
801015b1:	0f 87 dc fe ff ff    	ja     80101493 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015b7:	83 ec 0c             	sub    $0xc,%esp
801015ba:	68 0c 88 10 80       	push   $0x8010880c
801015bf:	e8 dc ef ff ff       	call   801005a0 <panic>
}
801015c4:	c9                   	leave  
801015c5:	c3                   	ret    

801015c6 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015c6:	55                   	push   %ebp
801015c7:	89 e5                	mov    %esp,%ebp
801015c9:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015cc:	83 ec 08             	sub    $0x8,%esp
801015cf:	68 60 1a 11 80       	push   $0x80111a60
801015d4:	ff 75 08             	pushl  0x8(%ebp)
801015d7:	e8 08 fe ff ff       	call   801013e4 <readsb>
801015dc:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015df:	8b 45 0c             	mov    0xc(%ebp),%eax
801015e2:	c1 e8 0c             	shr    $0xc,%eax
801015e5:	89 c2                	mov    %eax,%edx
801015e7:	a1 78 1a 11 80       	mov    0x80111a78,%eax
801015ec:	01 c2                	add    %eax,%edx
801015ee:	8b 45 08             	mov    0x8(%ebp),%eax
801015f1:	83 ec 08             	sub    $0x8,%esp
801015f4:	52                   	push   %edx
801015f5:	50                   	push   %eax
801015f6:	e8 d3 eb ff ff       	call   801001ce <bread>
801015fb:	83 c4 10             	add    $0x10,%esp
801015fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101601:	8b 45 0c             	mov    0xc(%ebp),%eax
80101604:	25 ff 0f 00 00       	and    $0xfff,%eax
80101609:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010160c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010160f:	99                   	cltd   
80101610:	c1 ea 1d             	shr    $0x1d,%edx
80101613:	01 d0                	add    %edx,%eax
80101615:	83 e0 07             	and    $0x7,%eax
80101618:	29 d0                	sub    %edx,%eax
8010161a:	ba 01 00 00 00       	mov    $0x1,%edx
8010161f:	89 c1                	mov    %eax,%ecx
80101621:	d3 e2                	shl    %cl,%edx
80101623:	89 d0                	mov    %edx,%eax
80101625:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101628:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010162b:	8d 50 07             	lea    0x7(%eax),%edx
8010162e:	85 c0                	test   %eax,%eax
80101630:	0f 48 c2             	cmovs  %edx,%eax
80101633:	c1 f8 03             	sar    $0x3,%eax
80101636:	89 c2                	mov    %eax,%edx
80101638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010163b:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101640:	0f b6 c0             	movzbl %al,%eax
80101643:	23 45 ec             	and    -0x14(%ebp),%eax
80101646:	85 c0                	test   %eax,%eax
80101648:	75 0d                	jne    80101657 <bfree+0x91>
    panic("freeing free block");
8010164a:	83 ec 0c             	sub    $0xc,%esp
8010164d:	68 22 88 10 80       	push   $0x80108822
80101652:	e8 49 ef ff ff       	call   801005a0 <panic>
  bp->data[bi/8] &= ~m;
80101657:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165a:	8d 50 07             	lea    0x7(%eax),%edx
8010165d:	85 c0                	test   %eax,%eax
8010165f:	0f 48 c2             	cmovs  %edx,%eax
80101662:	c1 f8 03             	sar    $0x3,%eax
80101665:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101668:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010166d:	89 d1                	mov    %edx,%ecx
8010166f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101672:	f7 d2                	not    %edx
80101674:	21 ca                	and    %ecx,%edx
80101676:	89 d1                	mov    %edx,%ecx
80101678:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010167b:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
8010167f:	83 ec 0c             	sub    $0xc,%esp
80101682:	ff 75 f4             	pushl  -0xc(%ebp)
80101685:	e8 e3 20 00 00       	call   8010376d <log_write>
8010168a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010168d:	83 ec 0c             	sub    $0xc,%esp
80101690:	ff 75 f4             	pushl  -0xc(%ebp)
80101693:	e8 b8 eb ff ff       	call   80100250 <brelse>
80101698:	83 c4 10             	add    $0x10,%esp
}
8010169b:	90                   	nop
8010169c:	c9                   	leave  
8010169d:	c3                   	ret    

8010169e <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010169e:	55                   	push   %ebp
8010169f:	89 e5                	mov    %esp,%ebp
801016a1:	57                   	push   %edi
801016a2:	56                   	push   %esi
801016a3:	53                   	push   %ebx
801016a4:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
801016a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801016ae:	83 ec 08             	sub    $0x8,%esp
801016b1:	68 35 88 10 80       	push   $0x80108835
801016b6:	68 80 1a 11 80       	push   $0x80111a80
801016bb:	e8 3f 3a 00 00       	call   801050ff <initlock>
801016c0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016c3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016ca:	eb 2d                	jmp    801016f9 <iinit+0x5b>
    initsleeplock(&icache.inode[i].lock, "inode");
801016cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016cf:	89 d0                	mov    %edx,%eax
801016d1:	c1 e0 03             	shl    $0x3,%eax
801016d4:	01 d0                	add    %edx,%eax
801016d6:	c1 e0 04             	shl    $0x4,%eax
801016d9:	83 c0 30             	add    $0x30,%eax
801016dc:	05 80 1a 11 80       	add    $0x80111a80,%eax
801016e1:	83 c0 10             	add    $0x10,%eax
801016e4:	83 ec 08             	sub    $0x8,%esp
801016e7:	68 3c 88 10 80       	push   $0x8010883c
801016ec:	50                   	push   %eax
801016ed:	e8 8a 38 00 00       	call   80104f7c <initsleeplock>
801016f2:	83 c4 10             	add    $0x10,%esp
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801016f5:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801016f9:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801016fd:	7e cd                	jle    801016cc <iinit+0x2e>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801016ff:	83 ec 08             	sub    $0x8,%esp
80101702:	68 60 1a 11 80       	push   $0x80111a60
80101707:	ff 75 08             	pushl  0x8(%ebp)
8010170a:	e8 d5 fc ff ff       	call   801013e4 <readsb>
8010170f:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101712:	a1 78 1a 11 80       	mov    0x80111a78,%eax
80101717:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010171a:	8b 3d 74 1a 11 80    	mov    0x80111a74,%edi
80101720:	8b 35 70 1a 11 80    	mov    0x80111a70,%esi
80101726:	8b 1d 6c 1a 11 80    	mov    0x80111a6c,%ebx
8010172c:	8b 0d 68 1a 11 80    	mov    0x80111a68,%ecx
80101732:	8b 15 64 1a 11 80    	mov    0x80111a64,%edx
80101738:	a1 60 1a 11 80       	mov    0x80111a60,%eax
8010173d:	ff 75 d4             	pushl  -0x2c(%ebp)
80101740:	57                   	push   %edi
80101741:	56                   	push   %esi
80101742:	53                   	push   %ebx
80101743:	51                   	push   %ecx
80101744:	52                   	push   %edx
80101745:	50                   	push   %eax
80101746:	68 44 88 10 80       	push   $0x80108844
8010174b:	e8 b0 ec ff ff       	call   80100400 <cprintf>
80101750:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101753:	90                   	nop
80101754:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101757:	5b                   	pop    %ebx
80101758:	5e                   	pop    %esi
80101759:	5f                   	pop    %edi
8010175a:	5d                   	pop    %ebp
8010175b:	c3                   	ret    

8010175c <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
8010175c:	55                   	push   %ebp
8010175d:	89 e5                	mov    %esp,%ebp
8010175f:	83 ec 28             	sub    $0x28,%esp
80101762:	8b 45 0c             	mov    0xc(%ebp),%eax
80101765:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101769:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101770:	e9 9e 00 00 00       	jmp    80101813 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101778:	c1 e8 03             	shr    $0x3,%eax
8010177b:	89 c2                	mov    %eax,%edx
8010177d:	a1 74 1a 11 80       	mov    0x80111a74,%eax
80101782:	01 d0                	add    %edx,%eax
80101784:	83 ec 08             	sub    $0x8,%esp
80101787:	50                   	push   %eax
80101788:	ff 75 08             	pushl  0x8(%ebp)
8010178b:	e8 3e ea ff ff       	call   801001ce <bread>
80101790:	83 c4 10             	add    $0x10,%esp
80101793:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101796:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101799:	8d 50 5c             	lea    0x5c(%eax),%edx
8010179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179f:	83 e0 07             	and    $0x7,%eax
801017a2:	c1 e0 06             	shl    $0x6,%eax
801017a5:	01 d0                	add    %edx,%eax
801017a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017ad:	0f b7 00             	movzwl (%eax),%eax
801017b0:	66 85 c0             	test   %ax,%ax
801017b3:	75 4c                	jne    80101801 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017b5:	83 ec 04             	sub    $0x4,%esp
801017b8:	6a 40                	push   $0x40
801017ba:	6a 00                	push   $0x0
801017bc:	ff 75 ec             	pushl  -0x14(%ebp)
801017bf:	e8 e4 3b 00 00       	call   801053a8 <memset>
801017c4:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017ca:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017ce:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017d1:	83 ec 0c             	sub    $0xc,%esp
801017d4:	ff 75 f0             	pushl  -0x10(%ebp)
801017d7:	e8 91 1f 00 00       	call   8010376d <log_write>
801017dc:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017df:	83 ec 0c             	sub    $0xc,%esp
801017e2:	ff 75 f0             	pushl  -0x10(%ebp)
801017e5:	e8 66 ea ff ff       	call   80100250 <brelse>
801017ea:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f0:	83 ec 08             	sub    $0x8,%esp
801017f3:	50                   	push   %eax
801017f4:	ff 75 08             	pushl  0x8(%ebp)
801017f7:	e8 f8 00 00 00       	call   801018f4 <iget>
801017fc:	83 c4 10             	add    $0x10,%esp
801017ff:	eb 30                	jmp    80101831 <ialloc+0xd5>
    }
    brelse(bp);
80101801:	83 ec 0c             	sub    $0xc,%esp
80101804:	ff 75 f0             	pushl  -0x10(%ebp)
80101807:	e8 44 ea ff ff       	call   80100250 <brelse>
8010180c:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010180f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101813:	8b 15 68 1a 11 80    	mov    0x80111a68,%edx
80101819:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181c:	39 c2                	cmp    %eax,%edx
8010181e:	0f 87 51 ff ff ff    	ja     80101775 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101824:	83 ec 0c             	sub    $0xc,%esp
80101827:	68 97 88 10 80       	push   $0x80108897
8010182c:	e8 6f ed ff ff       	call   801005a0 <panic>
}
80101831:	c9                   	leave  
80101832:	c3                   	ret    

80101833 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101833:	55                   	push   %ebp
80101834:	89 e5                	mov    %esp,%ebp
80101836:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101839:	8b 45 08             	mov    0x8(%ebp),%eax
8010183c:	8b 40 04             	mov    0x4(%eax),%eax
8010183f:	c1 e8 03             	shr    $0x3,%eax
80101842:	89 c2                	mov    %eax,%edx
80101844:	a1 74 1a 11 80       	mov    0x80111a74,%eax
80101849:	01 c2                	add    %eax,%edx
8010184b:	8b 45 08             	mov    0x8(%ebp),%eax
8010184e:	8b 00                	mov    (%eax),%eax
80101850:	83 ec 08             	sub    $0x8,%esp
80101853:	52                   	push   %edx
80101854:	50                   	push   %eax
80101855:	e8 74 e9 ff ff       	call   801001ce <bread>
8010185a:	83 c4 10             	add    $0x10,%esp
8010185d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101863:	8d 50 5c             	lea    0x5c(%eax),%edx
80101866:	8b 45 08             	mov    0x8(%ebp),%eax
80101869:	8b 40 04             	mov    0x4(%eax),%eax
8010186c:	83 e0 07             	and    $0x7,%eax
8010186f:	c1 e0 06             	shl    $0x6,%eax
80101872:	01 d0                	add    %edx,%eax
80101874:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101877:	8b 45 08             	mov    0x8(%ebp),%eax
8010187a:	0f b7 50 50          	movzwl 0x50(%eax),%edx
8010187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101881:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101884:	8b 45 08             	mov    0x8(%ebp),%eax
80101887:	0f b7 50 52          	movzwl 0x52(%eax),%edx
8010188b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010188e:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101892:	8b 45 08             	mov    0x8(%ebp),%eax
80101895:	0f b7 50 54          	movzwl 0x54(%eax),%edx
80101899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189c:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018a0:	8b 45 08             	mov    0x8(%ebp),%eax
801018a3:	0f b7 50 56          	movzwl 0x56(%eax),%edx
801018a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018aa:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018ae:	8b 45 08             	mov    0x8(%ebp),%eax
801018b1:	8b 50 58             	mov    0x58(%eax),%edx
801018b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b7:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018ba:	8b 45 08             	mov    0x8(%ebp),%eax
801018bd:	8d 50 5c             	lea    0x5c(%eax),%edx
801018c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c3:	83 c0 0c             	add    $0xc,%eax
801018c6:	83 ec 04             	sub    $0x4,%esp
801018c9:	6a 34                	push   $0x34
801018cb:	52                   	push   %edx
801018cc:	50                   	push   %eax
801018cd:	e8 95 3b 00 00       	call   80105467 <memmove>
801018d2:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018d5:	83 ec 0c             	sub    $0xc,%esp
801018d8:	ff 75 f4             	pushl  -0xc(%ebp)
801018db:	e8 8d 1e 00 00       	call   8010376d <log_write>
801018e0:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018e3:	83 ec 0c             	sub    $0xc,%esp
801018e6:	ff 75 f4             	pushl  -0xc(%ebp)
801018e9:	e8 62 e9 ff ff       	call   80100250 <brelse>
801018ee:	83 c4 10             	add    $0x10,%esp
}
801018f1:	90                   	nop
801018f2:	c9                   	leave  
801018f3:	c3                   	ret    

801018f4 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018f4:	55                   	push   %ebp
801018f5:	89 e5                	mov    %esp,%ebp
801018f7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018fa:	83 ec 0c             	sub    $0xc,%esp
801018fd:	68 80 1a 11 80       	push   $0x80111a80
80101902:	e8 1a 38 00 00       	call   80105121 <acquire>
80101907:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010190a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101911:	c7 45 f4 b4 1a 11 80 	movl   $0x80111ab4,-0xc(%ebp)
80101918:	eb 60                	jmp    8010197a <iget+0x86>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010191a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191d:	8b 40 08             	mov    0x8(%eax),%eax
80101920:	85 c0                	test   %eax,%eax
80101922:	7e 39                	jle    8010195d <iget+0x69>
80101924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101927:	8b 00                	mov    (%eax),%eax
80101929:	3b 45 08             	cmp    0x8(%ebp),%eax
8010192c:	75 2f                	jne    8010195d <iget+0x69>
8010192e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101931:	8b 40 04             	mov    0x4(%eax),%eax
80101934:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101937:	75 24                	jne    8010195d <iget+0x69>
      ip->ref++;
80101939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193c:	8b 40 08             	mov    0x8(%eax),%eax
8010193f:	8d 50 01             	lea    0x1(%eax),%edx
80101942:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101945:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101948:	83 ec 0c             	sub    $0xc,%esp
8010194b:	68 80 1a 11 80       	push   $0x80111a80
80101950:	e8 3a 38 00 00       	call   8010518f <release>
80101955:	83 c4 10             	add    $0x10,%esp
      return ip;
80101958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195b:	eb 77                	jmp    801019d4 <iget+0xe0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010195d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101961:	75 10                	jne    80101973 <iget+0x7f>
80101963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101966:	8b 40 08             	mov    0x8(%eax),%eax
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 06                	jne    80101973 <iget+0x7f>
      empty = ip;
8010196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101970:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101973:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
8010197a:	81 7d f4 d4 36 11 80 	cmpl   $0x801136d4,-0xc(%ebp)
80101981:	72 97                	jb     8010191a <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101983:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101987:	75 0d                	jne    80101996 <iget+0xa2>
    panic("iget: no inodes");
80101989:	83 ec 0c             	sub    $0xc,%esp
8010198c:	68 a9 88 10 80       	push   $0x801088a9
80101991:	e8 0a ec ff ff       	call   801005a0 <panic>

  ip = empty;
80101996:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101999:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010199f:	8b 55 08             	mov    0x8(%ebp),%edx
801019a2:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801019aa:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
801019b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ba:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
801019c1:	83 ec 0c             	sub    $0xc,%esp
801019c4:	68 80 1a 11 80       	push   $0x80111a80
801019c9:	e8 c1 37 00 00       	call   8010518f <release>
801019ce:	83 c4 10             	add    $0x10,%esp

  return ip;
801019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019d4:	c9                   	leave  
801019d5:	c3                   	ret    

801019d6 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019d6:	55                   	push   %ebp
801019d7:	89 e5                	mov    %esp,%ebp
801019d9:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019dc:	83 ec 0c             	sub    $0xc,%esp
801019df:	68 80 1a 11 80       	push   $0x80111a80
801019e4:	e8 38 37 00 00       	call   80105121 <acquire>
801019e9:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019ec:	8b 45 08             	mov    0x8(%ebp),%eax
801019ef:	8b 40 08             	mov    0x8(%eax),%eax
801019f2:	8d 50 01             	lea    0x1(%eax),%edx
801019f5:	8b 45 08             	mov    0x8(%ebp),%eax
801019f8:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019fb:	83 ec 0c             	sub    $0xc,%esp
801019fe:	68 80 1a 11 80       	push   $0x80111a80
80101a03:	e8 87 37 00 00       	call   8010518f <release>
80101a08:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a0e:	c9                   	leave  
80101a0f:	c3                   	ret    

80101a10 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a1a:	74 0a                	je     80101a26 <ilock+0x16>
80101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1f:	8b 40 08             	mov    0x8(%eax),%eax
80101a22:	85 c0                	test   %eax,%eax
80101a24:	7f 0d                	jg     80101a33 <ilock+0x23>
    panic("ilock");
80101a26:	83 ec 0c             	sub    $0xc,%esp
80101a29:	68 b9 88 10 80       	push   $0x801088b9
80101a2e:	e8 6d eb ff ff       	call   801005a0 <panic>

  acquiresleep(&ip->lock);
80101a33:	8b 45 08             	mov    0x8(%ebp),%eax
80101a36:	83 c0 0c             	add    $0xc,%eax
80101a39:	83 ec 0c             	sub    $0xc,%esp
80101a3c:	50                   	push   %eax
80101a3d:	e8 76 35 00 00       	call   80104fb8 <acquiresleep>
80101a42:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101a45:	8b 45 08             	mov    0x8(%ebp),%eax
80101a48:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	0f 85 cd 00 00 00    	jne    80101b20 <ilock+0x110>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a53:	8b 45 08             	mov    0x8(%ebp),%eax
80101a56:	8b 40 04             	mov    0x4(%eax),%eax
80101a59:	c1 e8 03             	shr    $0x3,%eax
80101a5c:	89 c2                	mov    %eax,%edx
80101a5e:	a1 74 1a 11 80       	mov    0x80111a74,%eax
80101a63:	01 c2                	add    %eax,%edx
80101a65:	8b 45 08             	mov    0x8(%ebp),%eax
80101a68:	8b 00                	mov    (%eax),%eax
80101a6a:	83 ec 08             	sub    $0x8,%esp
80101a6d:	52                   	push   %edx
80101a6e:	50                   	push   %eax
80101a6f:	e8 5a e7 ff ff       	call   801001ce <bread>
80101a74:	83 c4 10             	add    $0x10,%esp
80101a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a7d:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	8b 40 04             	mov    0x4(%eax),%eax
80101a86:	83 e0 07             	and    $0x7,%eax
80101a89:	c1 e0 06             	shl    $0x6,%eax
80101a8c:	01 d0                	add    %edx,%eax
80101a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a94:	0f b7 10             	movzwl (%eax),%edx
80101a97:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9a:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa1:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa8:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aaf:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab6:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101abd:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac4:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101acb:	8b 50 08             	mov    0x8(%eax),%edx
80101ace:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad1:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad7:	8d 50 0c             	lea    0xc(%eax),%edx
80101ada:	8b 45 08             	mov    0x8(%ebp),%eax
80101add:	83 c0 5c             	add    $0x5c,%eax
80101ae0:	83 ec 04             	sub    $0x4,%esp
80101ae3:	6a 34                	push   $0x34
80101ae5:	52                   	push   %edx
80101ae6:	50                   	push   %eax
80101ae7:	e8 7b 39 00 00       	call   80105467 <memmove>
80101aec:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101aef:	83 ec 0c             	sub    $0xc,%esp
80101af2:	ff 75 f4             	pushl  -0xc(%ebp)
80101af5:	e8 56 e7 ff ff       	call   80100250 <brelse>
80101afa:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101afd:	8b 45 08             	mov    0x8(%ebp),%eax
80101b00:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101b07:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101b0e:	66 85 c0             	test   %ax,%ax
80101b11:	75 0d                	jne    80101b20 <ilock+0x110>
      panic("ilock: no type");
80101b13:	83 ec 0c             	sub    $0xc,%esp
80101b16:	68 bf 88 10 80       	push   $0x801088bf
80101b1b:	e8 80 ea ff ff       	call   801005a0 <panic>
  }
}
80101b20:	90                   	nop
80101b21:	c9                   	leave  
80101b22:	c3                   	ret    

80101b23 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b23:	55                   	push   %ebp
80101b24:	89 e5                	mov    %esp,%ebp
80101b26:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b2d:	74 20                	je     80101b4f <iunlock+0x2c>
80101b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b32:	83 c0 0c             	add    $0xc,%eax
80101b35:	83 ec 0c             	sub    $0xc,%esp
80101b38:	50                   	push   %eax
80101b39:	e8 2c 35 00 00       	call   8010506a <holdingsleep>
80101b3e:	83 c4 10             	add    $0x10,%esp
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0a                	je     80101b4f <iunlock+0x2c>
80101b45:	8b 45 08             	mov    0x8(%ebp),%eax
80101b48:	8b 40 08             	mov    0x8(%eax),%eax
80101b4b:	85 c0                	test   %eax,%eax
80101b4d:	7f 0d                	jg     80101b5c <iunlock+0x39>
    panic("iunlock");
80101b4f:	83 ec 0c             	sub    $0xc,%esp
80101b52:	68 ce 88 10 80       	push   $0x801088ce
80101b57:	e8 44 ea ff ff       	call   801005a0 <panic>

  releasesleep(&ip->lock);
80101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5f:	83 c0 0c             	add    $0xc,%eax
80101b62:	83 ec 0c             	sub    $0xc,%esp
80101b65:	50                   	push   %eax
80101b66:	e8 b1 34 00 00       	call   8010501c <releasesleep>
80101b6b:	83 c4 10             	add    $0x10,%esp
}
80101b6e:	90                   	nop
80101b6f:	c9                   	leave  
80101b70:	c3                   	ret    

80101b71 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b71:	55                   	push   %ebp
80101b72:	89 e5                	mov    %esp,%ebp
80101b74:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101b77:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7a:	83 c0 0c             	add    $0xc,%eax
80101b7d:	83 ec 0c             	sub    $0xc,%esp
80101b80:	50                   	push   %eax
80101b81:	e8 32 34 00 00       	call   80104fb8 <acquiresleep>
80101b86:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b8f:	85 c0                	test   %eax,%eax
80101b91:	74 6a                	je     80101bfd <iput+0x8c>
80101b93:	8b 45 08             	mov    0x8(%ebp),%eax
80101b96:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101b9a:	66 85 c0             	test   %ax,%ax
80101b9d:	75 5e                	jne    80101bfd <iput+0x8c>
    acquire(&icache.lock);
80101b9f:	83 ec 0c             	sub    $0xc,%esp
80101ba2:	68 80 1a 11 80       	push   $0x80111a80
80101ba7:	e8 75 35 00 00       	call   80105121 <acquire>
80101bac:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101baf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb2:	8b 40 08             	mov    0x8(%eax),%eax
80101bb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101bb8:	83 ec 0c             	sub    $0xc,%esp
80101bbb:	68 80 1a 11 80       	push   $0x80111a80
80101bc0:	e8 ca 35 00 00       	call   8010518f <release>
80101bc5:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101bc8:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101bcc:	75 2f                	jne    80101bfd <iput+0x8c>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101bce:	83 ec 0c             	sub    $0xc,%esp
80101bd1:	ff 75 08             	pushl  0x8(%ebp)
80101bd4:	e8 b2 01 00 00       	call   80101d8b <itrunc>
80101bd9:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101bdc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdf:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101be5:	83 ec 0c             	sub    $0xc,%esp
80101be8:	ff 75 08             	pushl  0x8(%ebp)
80101beb:	e8 43 fc ff ff       	call   80101833 <iupdate>
80101bf0:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf6:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101c00:	83 c0 0c             	add    $0xc,%eax
80101c03:	83 ec 0c             	sub    $0xc,%esp
80101c06:	50                   	push   %eax
80101c07:	e8 10 34 00 00       	call   8010501c <releasesleep>
80101c0c:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101c0f:	83 ec 0c             	sub    $0xc,%esp
80101c12:	68 80 1a 11 80       	push   $0x80111a80
80101c17:	e8 05 35 00 00       	call   80105121 <acquire>
80101c1c:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101c1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c22:	8b 40 08             	mov    0x8(%eax),%eax
80101c25:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c28:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2b:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c2e:	83 ec 0c             	sub    $0xc,%esp
80101c31:	68 80 1a 11 80       	push   $0x80111a80
80101c36:	e8 54 35 00 00       	call   8010518f <release>
80101c3b:	83 c4 10             	add    $0x10,%esp
}
80101c3e:	90                   	nop
80101c3f:	c9                   	leave  
80101c40:	c3                   	ret    

80101c41 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c41:	55                   	push   %ebp
80101c42:	89 e5                	mov    %esp,%ebp
80101c44:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c47:	83 ec 0c             	sub    $0xc,%esp
80101c4a:	ff 75 08             	pushl  0x8(%ebp)
80101c4d:	e8 d1 fe ff ff       	call   80101b23 <iunlock>
80101c52:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c55:	83 ec 0c             	sub    $0xc,%esp
80101c58:	ff 75 08             	pushl  0x8(%ebp)
80101c5b:	e8 11 ff ff ff       	call   80101b71 <iput>
80101c60:	83 c4 10             	add    $0x10,%esp
}
80101c63:	90                   	nop
80101c64:	c9                   	leave  
80101c65:	c3                   	ret    

80101c66 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c66:	55                   	push   %ebp
80101c67:	89 e5                	mov    %esp,%ebp
80101c69:	53                   	push   %ebx
80101c6a:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c6d:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c71:	77 42                	ja     80101cb5 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101c73:	8b 45 08             	mov    0x8(%ebp),%eax
80101c76:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c79:	83 c2 14             	add    $0x14,%edx
80101c7c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c87:	75 24                	jne    80101cad <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c89:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8c:	8b 00                	mov    (%eax),%eax
80101c8e:	83 ec 0c             	sub    $0xc,%esp
80101c91:	50                   	push   %eax
80101c92:	e8 e3 f7 ff ff       	call   8010147a <balloc>
80101c97:	83 c4 10             	add    $0x10,%esp
80101c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca0:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ca3:	8d 4a 14             	lea    0x14(%edx),%ecx
80101ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ca9:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cb0:	e9 d1 00 00 00       	jmp    80101d86 <bmap+0x120>
  }
  bn -= NDIRECT;
80101cb5:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101cb9:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101cbd:	0f 87 b6 00 00 00    	ja     80101d79 <bmap+0x113>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc6:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cd3:	75 20                	jne    80101cf5 <bmap+0x8f>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd8:	8b 00                	mov    (%eax),%eax
80101cda:	83 ec 0c             	sub    $0xc,%esp
80101cdd:	50                   	push   %eax
80101cde:	e8 97 f7 ff ff       	call   8010147a <balloc>
80101ce3:	83 c4 10             	add    $0x10,%esp
80101ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cec:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cef:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf8:	8b 00                	mov    (%eax),%eax
80101cfa:	83 ec 08             	sub    $0x8,%esp
80101cfd:	ff 75 f4             	pushl  -0xc(%ebp)
80101d00:	50                   	push   %eax
80101d01:	e8 c8 e4 ff ff       	call   801001ce <bread>
80101d06:	83 c4 10             	add    $0x10,%esp
80101d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d0f:	83 c0 5c             	add    $0x5c,%eax
80101d12:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d15:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d22:	01 d0                	add    %edx,%eax
80101d24:	8b 00                	mov    (%eax),%eax
80101d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d2d:	75 37                	jne    80101d66 <bmap+0x100>
      a[bn] = addr = balloc(ip->dev);
80101d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d3c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d42:	8b 00                	mov    (%eax),%eax
80101d44:	83 ec 0c             	sub    $0xc,%esp
80101d47:	50                   	push   %eax
80101d48:	e8 2d f7 ff ff       	call   8010147a <balloc>
80101d4d:	83 c4 10             	add    $0x10,%esp
80101d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d56:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d58:	83 ec 0c             	sub    $0xc,%esp
80101d5b:	ff 75 f0             	pushl  -0x10(%ebp)
80101d5e:	e8 0a 1a 00 00       	call   8010376d <log_write>
80101d63:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d66:	83 ec 0c             	sub    $0xc,%esp
80101d69:	ff 75 f0             	pushl  -0x10(%ebp)
80101d6c:	e8 df e4 ff ff       	call   80100250 <brelse>
80101d71:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d77:	eb 0d                	jmp    80101d86 <bmap+0x120>
  }

  panic("bmap: out of range");
80101d79:	83 ec 0c             	sub    $0xc,%esp
80101d7c:	68 d6 88 10 80       	push   $0x801088d6
80101d81:	e8 1a e8 ff ff       	call   801005a0 <panic>
}
80101d86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d89:	c9                   	leave  
80101d8a:	c3                   	ret    

80101d8b <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d8b:	55                   	push   %ebp
80101d8c:	89 e5                	mov    %esp,%ebp
80101d8e:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d98:	eb 45                	jmp    80101ddf <itrunc+0x54>
    if(ip->addrs[i]){
80101d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101da0:	83 c2 14             	add    $0x14,%edx
80101da3:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101da7:	85 c0                	test   %eax,%eax
80101da9:	74 30                	je     80101ddb <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101dab:	8b 45 08             	mov    0x8(%ebp),%eax
80101dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101db1:	83 c2 14             	add    $0x14,%edx
80101db4:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101db8:	8b 55 08             	mov    0x8(%ebp),%edx
80101dbb:	8b 12                	mov    (%edx),%edx
80101dbd:	83 ec 08             	sub    $0x8,%esp
80101dc0:	50                   	push   %eax
80101dc1:	52                   	push   %edx
80101dc2:	e8 ff f7 ff ff       	call   801015c6 <bfree>
80101dc7:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101dca:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dd0:	83 c2 14             	add    $0x14,%edx
80101dd3:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101dda:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ddb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101ddf:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101de3:	7e b5                	jle    80101d9a <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101de5:	8b 45 08             	mov    0x8(%ebp),%eax
80101de8:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101dee:	85 c0                	test   %eax,%eax
80101df0:	0f 84 aa 00 00 00    	je     80101ea0 <itrunc+0x115>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101df6:	8b 45 08             	mov    0x8(%ebp),%eax
80101df9:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101dff:	8b 45 08             	mov    0x8(%ebp),%eax
80101e02:	8b 00                	mov    (%eax),%eax
80101e04:	83 ec 08             	sub    $0x8,%esp
80101e07:	52                   	push   %edx
80101e08:	50                   	push   %eax
80101e09:	e8 c0 e3 ff ff       	call   801001ce <bread>
80101e0e:	83 c4 10             	add    $0x10,%esp
80101e11:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e17:	83 c0 5c             	add    $0x5c,%eax
80101e1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e1d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e24:	eb 3c                	jmp    80101e62 <itrunc+0xd7>
      if(a[j])
80101e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e33:	01 d0                	add    %edx,%eax
80101e35:	8b 00                	mov    (%eax),%eax
80101e37:	85 c0                	test   %eax,%eax
80101e39:	74 23                	je     80101e5e <itrunc+0xd3>
        bfree(ip->dev, a[j]);
80101e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e3e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e45:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e48:	01 d0                	add    %edx,%eax
80101e4a:	8b 00                	mov    (%eax),%eax
80101e4c:	8b 55 08             	mov    0x8(%ebp),%edx
80101e4f:	8b 12                	mov    (%edx),%edx
80101e51:	83 ec 08             	sub    $0x8,%esp
80101e54:	50                   	push   %eax
80101e55:	52                   	push   %edx
80101e56:	e8 6b f7 ff ff       	call   801015c6 <bfree>
80101e5b:	83 c4 10             	add    $0x10,%esp
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e5e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e65:	83 f8 7f             	cmp    $0x7f,%eax
80101e68:	76 bc                	jbe    80101e26 <itrunc+0x9b>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e6a:	83 ec 0c             	sub    $0xc,%esp
80101e6d:	ff 75 ec             	pushl  -0x14(%ebp)
80101e70:	e8 db e3 ff ff       	call   80100250 <brelse>
80101e75:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e78:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7b:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e81:	8b 55 08             	mov    0x8(%ebp),%edx
80101e84:	8b 12                	mov    (%edx),%edx
80101e86:	83 ec 08             	sub    $0x8,%esp
80101e89:	50                   	push   %eax
80101e8a:	52                   	push   %edx
80101e8b:	e8 36 f7 ff ff       	call   801015c6 <bfree>
80101e90:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e93:	8b 45 08             	mov    0x8(%ebp),%eax
80101e96:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e9d:	00 00 00 
  }

  ip->size = 0;
80101ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea3:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	ff 75 08             	pushl  0x8(%ebp)
80101eb0:	e8 7e f9 ff ff       	call   80101833 <iupdate>
80101eb5:	83 c4 10             	add    $0x10,%esp
}
80101eb8:	90                   	nop
80101eb9:	c9                   	leave  
80101eba:	c3                   	ret    

80101ebb <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ebb:	55                   	push   %ebp
80101ebc:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ebe:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec1:	8b 00                	mov    (%eax),%eax
80101ec3:	89 c2                	mov    %eax,%edx
80101ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec8:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ece:	8b 50 04             	mov    0x4(%eax),%edx
80101ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed4:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eda:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101ede:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ee1:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee7:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eee:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef5:	8b 50 58             	mov    0x58(%eax),%edx
80101ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101efb:	89 50 10             	mov    %edx,0x10(%eax)
}
80101efe:	90                   	nop
80101eff:	5d                   	pop    %ebp
80101f00:	c3                   	ret    

80101f01 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f01:	55                   	push   %ebp
80101f02:	89 e5                	mov    %esp,%ebp
80101f04:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f07:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101f0e:	66 83 f8 03          	cmp    $0x3,%ax
80101f12:	75 5c                	jne    80101f70 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f14:	8b 45 08             	mov    0x8(%ebp),%eax
80101f17:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f1b:	66 85 c0             	test   %ax,%ax
80101f1e:	78 20                	js     80101f40 <readi+0x3f>
80101f20:	8b 45 08             	mov    0x8(%ebp),%eax
80101f23:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f27:	66 83 f8 09          	cmp    $0x9,%ax
80101f2b:	7f 13                	jg     80101f40 <readi+0x3f>
80101f2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f30:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f34:	98                   	cwtl   
80101f35:	8b 04 c5 00 1a 11 80 	mov    -0x7feee600(,%eax,8),%eax
80101f3c:	85 c0                	test   %eax,%eax
80101f3e:	75 0a                	jne    80101f4a <readi+0x49>
      return -1;
80101f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f45:	e9 0c 01 00 00       	jmp    80102056 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101f4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f51:	98                   	cwtl   
80101f52:	8b 04 c5 00 1a 11 80 	mov    -0x7feee600(,%eax,8),%eax
80101f59:	8b 55 14             	mov    0x14(%ebp),%edx
80101f5c:	83 ec 04             	sub    $0x4,%esp
80101f5f:	52                   	push   %edx
80101f60:	ff 75 0c             	pushl  0xc(%ebp)
80101f63:	ff 75 08             	pushl  0x8(%ebp)
80101f66:	ff d0                	call   *%eax
80101f68:	83 c4 10             	add    $0x10,%esp
80101f6b:	e9 e6 00 00 00       	jmp    80102056 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101f70:	8b 45 08             	mov    0x8(%ebp),%eax
80101f73:	8b 40 58             	mov    0x58(%eax),%eax
80101f76:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f79:	72 0d                	jb     80101f88 <readi+0x87>
80101f7b:	8b 55 10             	mov    0x10(%ebp),%edx
80101f7e:	8b 45 14             	mov    0x14(%ebp),%eax
80101f81:	01 d0                	add    %edx,%eax
80101f83:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f86:	73 0a                	jae    80101f92 <readi+0x91>
    return -1;
80101f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f8d:	e9 c4 00 00 00       	jmp    80102056 <readi+0x155>
  if(off + n > ip->size)
80101f92:	8b 55 10             	mov    0x10(%ebp),%edx
80101f95:	8b 45 14             	mov    0x14(%ebp),%eax
80101f98:	01 c2                	add    %eax,%edx
80101f9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9d:	8b 40 58             	mov    0x58(%eax),%eax
80101fa0:	39 c2                	cmp    %eax,%edx
80101fa2:	76 0c                	jbe    80101fb0 <readi+0xaf>
    n = ip->size - off;
80101fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa7:	8b 40 58             	mov    0x58(%eax),%eax
80101faa:	2b 45 10             	sub    0x10(%ebp),%eax
80101fad:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fb7:	e9 8b 00 00 00       	jmp    80102047 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fbc:	8b 45 10             	mov    0x10(%ebp),%eax
80101fbf:	c1 e8 09             	shr    $0x9,%eax
80101fc2:	83 ec 08             	sub    $0x8,%esp
80101fc5:	50                   	push   %eax
80101fc6:	ff 75 08             	pushl  0x8(%ebp)
80101fc9:	e8 98 fc ff ff       	call   80101c66 <bmap>
80101fce:	83 c4 10             	add    $0x10,%esp
80101fd1:	89 c2                	mov    %eax,%edx
80101fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd6:	8b 00                	mov    (%eax),%eax
80101fd8:	83 ec 08             	sub    $0x8,%esp
80101fdb:	52                   	push   %edx
80101fdc:	50                   	push   %eax
80101fdd:	e8 ec e1 ff ff       	call   801001ce <bread>
80101fe2:	83 c4 10             	add    $0x10,%esp
80101fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fe8:	8b 45 10             	mov    0x10(%ebp),%eax
80101feb:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ff0:	ba 00 02 00 00       	mov    $0x200,%edx
80101ff5:	29 c2                	sub    %eax,%edx
80101ff7:	8b 45 14             	mov    0x14(%ebp),%eax
80101ffa:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101ffd:	39 c2                	cmp    %eax,%edx
80101fff:	0f 46 c2             	cmovbe %edx,%eax
80102002:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102005:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102008:	8d 50 5c             	lea    0x5c(%eax),%edx
8010200b:	8b 45 10             	mov    0x10(%ebp),%eax
8010200e:	25 ff 01 00 00       	and    $0x1ff,%eax
80102013:	01 d0                	add    %edx,%eax
80102015:	83 ec 04             	sub    $0x4,%esp
80102018:	ff 75 ec             	pushl  -0x14(%ebp)
8010201b:	50                   	push   %eax
8010201c:	ff 75 0c             	pushl  0xc(%ebp)
8010201f:	e8 43 34 00 00       	call   80105467 <memmove>
80102024:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102027:	83 ec 0c             	sub    $0xc,%esp
8010202a:	ff 75 f0             	pushl  -0x10(%ebp)
8010202d:	e8 1e e2 ff ff       	call   80100250 <brelse>
80102032:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102035:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102038:	01 45 f4             	add    %eax,-0xc(%ebp)
8010203b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010203e:	01 45 10             	add    %eax,0x10(%ebp)
80102041:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102044:	01 45 0c             	add    %eax,0xc(%ebp)
80102047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010204a:	3b 45 14             	cmp    0x14(%ebp),%eax
8010204d:	0f 82 69 ff ff ff    	jb     80101fbc <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102053:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102056:	c9                   	leave  
80102057:	c3                   	ret    

80102058 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102058:	55                   	push   %ebp
80102059:	89 e5                	mov    %esp,%ebp
8010205b:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010205e:	8b 45 08             	mov    0x8(%ebp),%eax
80102061:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102065:	66 83 f8 03          	cmp    $0x3,%ax
80102069:	75 5c                	jne    801020c7 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010206b:	8b 45 08             	mov    0x8(%ebp),%eax
8010206e:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102072:	66 85 c0             	test   %ax,%ax
80102075:	78 20                	js     80102097 <writei+0x3f>
80102077:	8b 45 08             	mov    0x8(%ebp),%eax
8010207a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010207e:	66 83 f8 09          	cmp    $0x9,%ax
80102082:	7f 13                	jg     80102097 <writei+0x3f>
80102084:	8b 45 08             	mov    0x8(%ebp),%eax
80102087:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010208b:	98                   	cwtl   
8010208c:	8b 04 c5 04 1a 11 80 	mov    -0x7feee5fc(,%eax,8),%eax
80102093:	85 c0                	test   %eax,%eax
80102095:	75 0a                	jne    801020a1 <writei+0x49>
      return -1;
80102097:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010209c:	e9 3d 01 00 00       	jmp    801021de <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
801020a1:	8b 45 08             	mov    0x8(%ebp),%eax
801020a4:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801020a8:	98                   	cwtl   
801020a9:	8b 04 c5 04 1a 11 80 	mov    -0x7feee5fc(,%eax,8),%eax
801020b0:	8b 55 14             	mov    0x14(%ebp),%edx
801020b3:	83 ec 04             	sub    $0x4,%esp
801020b6:	52                   	push   %edx
801020b7:	ff 75 0c             	pushl  0xc(%ebp)
801020ba:	ff 75 08             	pushl  0x8(%ebp)
801020bd:	ff d0                	call   *%eax
801020bf:	83 c4 10             	add    $0x10,%esp
801020c2:	e9 17 01 00 00       	jmp    801021de <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801020c7:	8b 45 08             	mov    0x8(%ebp),%eax
801020ca:	8b 40 58             	mov    0x58(%eax),%eax
801020cd:	3b 45 10             	cmp    0x10(%ebp),%eax
801020d0:	72 0d                	jb     801020df <writei+0x87>
801020d2:	8b 55 10             	mov    0x10(%ebp),%edx
801020d5:	8b 45 14             	mov    0x14(%ebp),%eax
801020d8:	01 d0                	add    %edx,%eax
801020da:	3b 45 10             	cmp    0x10(%ebp),%eax
801020dd:	73 0a                	jae    801020e9 <writei+0x91>
    return -1;
801020df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e4:	e9 f5 00 00 00       	jmp    801021de <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801020e9:	8b 55 10             	mov    0x10(%ebp),%edx
801020ec:	8b 45 14             	mov    0x14(%ebp),%eax
801020ef:	01 d0                	add    %edx,%eax
801020f1:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020f6:	76 0a                	jbe    80102102 <writei+0xaa>
    return -1;
801020f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020fd:	e9 dc 00 00 00       	jmp    801021de <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102102:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102109:	e9 99 00 00 00       	jmp    801021a7 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010210e:	8b 45 10             	mov    0x10(%ebp),%eax
80102111:	c1 e8 09             	shr    $0x9,%eax
80102114:	83 ec 08             	sub    $0x8,%esp
80102117:	50                   	push   %eax
80102118:	ff 75 08             	pushl  0x8(%ebp)
8010211b:	e8 46 fb ff ff       	call   80101c66 <bmap>
80102120:	83 c4 10             	add    $0x10,%esp
80102123:	89 c2                	mov    %eax,%edx
80102125:	8b 45 08             	mov    0x8(%ebp),%eax
80102128:	8b 00                	mov    (%eax),%eax
8010212a:	83 ec 08             	sub    $0x8,%esp
8010212d:	52                   	push   %edx
8010212e:	50                   	push   %eax
8010212f:	e8 9a e0 ff ff       	call   801001ce <bread>
80102134:	83 c4 10             	add    $0x10,%esp
80102137:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010213a:	8b 45 10             	mov    0x10(%ebp),%eax
8010213d:	25 ff 01 00 00       	and    $0x1ff,%eax
80102142:	ba 00 02 00 00       	mov    $0x200,%edx
80102147:	29 c2                	sub    %eax,%edx
80102149:	8b 45 14             	mov    0x14(%ebp),%eax
8010214c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010214f:	39 c2                	cmp    %eax,%edx
80102151:	0f 46 c2             	cmovbe %edx,%eax
80102154:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102157:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010215a:	8d 50 5c             	lea    0x5c(%eax),%edx
8010215d:	8b 45 10             	mov    0x10(%ebp),%eax
80102160:	25 ff 01 00 00       	and    $0x1ff,%eax
80102165:	01 d0                	add    %edx,%eax
80102167:	83 ec 04             	sub    $0x4,%esp
8010216a:	ff 75 ec             	pushl  -0x14(%ebp)
8010216d:	ff 75 0c             	pushl  0xc(%ebp)
80102170:	50                   	push   %eax
80102171:	e8 f1 32 00 00       	call   80105467 <memmove>
80102176:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102179:	83 ec 0c             	sub    $0xc,%esp
8010217c:	ff 75 f0             	pushl  -0x10(%ebp)
8010217f:	e8 e9 15 00 00       	call   8010376d <log_write>
80102184:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102187:	83 ec 0c             	sub    $0xc,%esp
8010218a:	ff 75 f0             	pushl  -0x10(%ebp)
8010218d:	e8 be e0 ff ff       	call   80100250 <brelse>
80102192:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102195:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102198:	01 45 f4             	add    %eax,-0xc(%ebp)
8010219b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010219e:	01 45 10             	add    %eax,0x10(%ebp)
801021a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021a4:	01 45 0c             	add    %eax,0xc(%ebp)
801021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021aa:	3b 45 14             	cmp    0x14(%ebp),%eax
801021ad:	0f 82 5b ff ff ff    	jb     8010210e <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801021b3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021b7:	74 22                	je     801021db <writei+0x183>
801021b9:	8b 45 08             	mov    0x8(%ebp),%eax
801021bc:	8b 40 58             	mov    0x58(%eax),%eax
801021bf:	3b 45 10             	cmp    0x10(%ebp),%eax
801021c2:	73 17                	jae    801021db <writei+0x183>
    ip->size = off;
801021c4:	8b 45 08             	mov    0x8(%ebp),%eax
801021c7:	8b 55 10             	mov    0x10(%ebp),%edx
801021ca:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801021cd:	83 ec 0c             	sub    $0xc,%esp
801021d0:	ff 75 08             	pushl  0x8(%ebp)
801021d3:	e8 5b f6 ff ff       	call   80101833 <iupdate>
801021d8:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021db:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021de:	c9                   	leave  
801021df:	c3                   	ret    

801021e0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021e6:	83 ec 04             	sub    $0x4,%esp
801021e9:	6a 0e                	push   $0xe
801021eb:	ff 75 0c             	pushl  0xc(%ebp)
801021ee:	ff 75 08             	pushl  0x8(%ebp)
801021f1:	e8 07 33 00 00       	call   801054fd <strncmp>
801021f6:	83 c4 10             	add    $0x10,%esp
}
801021f9:	c9                   	leave  
801021fa:	c3                   	ret    

801021fb <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021fb:	55                   	push   %ebp
801021fc:	89 e5                	mov    %esp,%ebp
801021fe:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102201:	8b 45 08             	mov    0x8(%ebp),%eax
80102204:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102208:	66 83 f8 01          	cmp    $0x1,%ax
8010220c:	74 0d                	je     8010221b <dirlookup+0x20>
    panic("dirlookup not DIR");
8010220e:	83 ec 0c             	sub    $0xc,%esp
80102211:	68 e9 88 10 80       	push   $0x801088e9
80102216:	e8 85 e3 ff ff       	call   801005a0 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010221b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102222:	eb 7b                	jmp    8010229f <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102224:	6a 10                	push   $0x10
80102226:	ff 75 f4             	pushl  -0xc(%ebp)
80102229:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010222c:	50                   	push   %eax
8010222d:	ff 75 08             	pushl  0x8(%ebp)
80102230:	e8 cc fc ff ff       	call   80101f01 <readi>
80102235:	83 c4 10             	add    $0x10,%esp
80102238:	83 f8 10             	cmp    $0x10,%eax
8010223b:	74 0d                	je     8010224a <dirlookup+0x4f>
      panic("dirlookup read");
8010223d:	83 ec 0c             	sub    $0xc,%esp
80102240:	68 fb 88 10 80       	push   $0x801088fb
80102245:	e8 56 e3 ff ff       	call   801005a0 <panic>
    if(de.inum == 0)
8010224a:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010224e:	66 85 c0             	test   %ax,%ax
80102251:	74 47                	je     8010229a <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102253:	83 ec 08             	sub    $0x8,%esp
80102256:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102259:	83 c0 02             	add    $0x2,%eax
8010225c:	50                   	push   %eax
8010225d:	ff 75 0c             	pushl  0xc(%ebp)
80102260:	e8 7b ff ff ff       	call   801021e0 <namecmp>
80102265:	83 c4 10             	add    $0x10,%esp
80102268:	85 c0                	test   %eax,%eax
8010226a:	75 2f                	jne    8010229b <dirlookup+0xa0>
      // entry matches path element
      if(poff)
8010226c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102270:	74 08                	je     8010227a <dirlookup+0x7f>
        *poff = off;
80102272:	8b 45 10             	mov    0x10(%ebp),%eax
80102275:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102278:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010227a:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010227e:	0f b7 c0             	movzwl %ax,%eax
80102281:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102284:	8b 45 08             	mov    0x8(%ebp),%eax
80102287:	8b 00                	mov    (%eax),%eax
80102289:	83 ec 08             	sub    $0x8,%esp
8010228c:	ff 75 f0             	pushl  -0x10(%ebp)
8010228f:	50                   	push   %eax
80102290:	e8 5f f6 ff ff       	call   801018f4 <iget>
80102295:	83 c4 10             	add    $0x10,%esp
80102298:	eb 19                	jmp    801022b3 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
8010229a:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010229b:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010229f:	8b 45 08             	mov    0x8(%ebp),%eax
801022a2:	8b 40 58             	mov    0x58(%eax),%eax
801022a5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801022a8:	0f 87 76 ff ff ff    	ja     80102224 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801022ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022b3:	c9                   	leave  
801022b4:	c3                   	ret    

801022b5 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801022b5:	55                   	push   %ebp
801022b6:	89 e5                	mov    %esp,%ebp
801022b8:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022bb:	83 ec 04             	sub    $0x4,%esp
801022be:	6a 00                	push   $0x0
801022c0:	ff 75 0c             	pushl  0xc(%ebp)
801022c3:	ff 75 08             	pushl  0x8(%ebp)
801022c6:	e8 30 ff ff ff       	call   801021fb <dirlookup>
801022cb:	83 c4 10             	add    $0x10,%esp
801022ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022d5:	74 18                	je     801022ef <dirlink+0x3a>
    iput(ip);
801022d7:	83 ec 0c             	sub    $0xc,%esp
801022da:	ff 75 f0             	pushl  -0x10(%ebp)
801022dd:	e8 8f f8 ff ff       	call   80101b71 <iput>
801022e2:	83 c4 10             	add    $0x10,%esp
    return -1;
801022e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022ea:	e9 9c 00 00 00       	jmp    8010238b <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022f6:	eb 39                	jmp    80102331 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fb:	6a 10                	push   $0x10
801022fd:	50                   	push   %eax
801022fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102301:	50                   	push   %eax
80102302:	ff 75 08             	pushl  0x8(%ebp)
80102305:	e8 f7 fb ff ff       	call   80101f01 <readi>
8010230a:	83 c4 10             	add    $0x10,%esp
8010230d:	83 f8 10             	cmp    $0x10,%eax
80102310:	74 0d                	je     8010231f <dirlink+0x6a>
      panic("dirlink read");
80102312:	83 ec 0c             	sub    $0xc,%esp
80102315:	68 0a 89 10 80       	push   $0x8010890a
8010231a:	e8 81 e2 ff ff       	call   801005a0 <panic>
    if(de.inum == 0)
8010231f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102323:	66 85 c0             	test   %ax,%ax
80102326:	74 18                	je     80102340 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010232b:	83 c0 10             	add    $0x10,%eax
8010232e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102331:	8b 45 08             	mov    0x8(%ebp),%eax
80102334:	8b 50 58             	mov    0x58(%eax),%edx
80102337:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010233a:	39 c2                	cmp    %eax,%edx
8010233c:	77 ba                	ja     801022f8 <dirlink+0x43>
8010233e:	eb 01                	jmp    80102341 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102340:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102341:	83 ec 04             	sub    $0x4,%esp
80102344:	6a 0e                	push   $0xe
80102346:	ff 75 0c             	pushl  0xc(%ebp)
80102349:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010234c:	83 c0 02             	add    $0x2,%eax
8010234f:	50                   	push   %eax
80102350:	e8 fe 31 00 00       	call   80105553 <strncpy>
80102355:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102358:	8b 45 10             	mov    0x10(%ebp),%eax
8010235b:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102362:	6a 10                	push   $0x10
80102364:	50                   	push   %eax
80102365:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102368:	50                   	push   %eax
80102369:	ff 75 08             	pushl  0x8(%ebp)
8010236c:	e8 e7 fc ff ff       	call   80102058 <writei>
80102371:	83 c4 10             	add    $0x10,%esp
80102374:	83 f8 10             	cmp    $0x10,%eax
80102377:	74 0d                	je     80102386 <dirlink+0xd1>
    panic("dirlink");
80102379:	83 ec 0c             	sub    $0xc,%esp
8010237c:	68 17 89 10 80       	push   $0x80108917
80102381:	e8 1a e2 ff ff       	call   801005a0 <panic>

  return 0;
80102386:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010238b:	c9                   	leave  
8010238c:	c3                   	ret    

8010238d <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010238d:	55                   	push   %ebp
8010238e:	89 e5                	mov    %esp,%ebp
80102390:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102393:	eb 04                	jmp    80102399 <skipelem+0xc>
    path++;
80102395:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102399:	8b 45 08             	mov    0x8(%ebp),%eax
8010239c:	0f b6 00             	movzbl (%eax),%eax
8010239f:	3c 2f                	cmp    $0x2f,%al
801023a1:	74 f2                	je     80102395 <skipelem+0x8>
    path++;
  if(*path == 0)
801023a3:	8b 45 08             	mov    0x8(%ebp),%eax
801023a6:	0f b6 00             	movzbl (%eax),%eax
801023a9:	84 c0                	test   %al,%al
801023ab:	75 07                	jne    801023b4 <skipelem+0x27>
    return 0;
801023ad:	b8 00 00 00 00       	mov    $0x0,%eax
801023b2:	eb 7b                	jmp    8010242f <skipelem+0xa2>
  s = path;
801023b4:	8b 45 08             	mov    0x8(%ebp),%eax
801023b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023ba:	eb 04                	jmp    801023c0 <skipelem+0x33>
    path++;
801023bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801023c0:	8b 45 08             	mov    0x8(%ebp),%eax
801023c3:	0f b6 00             	movzbl (%eax),%eax
801023c6:	3c 2f                	cmp    $0x2f,%al
801023c8:	74 0a                	je     801023d4 <skipelem+0x47>
801023ca:	8b 45 08             	mov    0x8(%ebp),%eax
801023cd:	0f b6 00             	movzbl (%eax),%eax
801023d0:	84 c0                	test   %al,%al
801023d2:	75 e8                	jne    801023bc <skipelem+0x2f>
    path++;
  len = path - s;
801023d4:	8b 55 08             	mov    0x8(%ebp),%edx
801023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023da:	29 c2                	sub    %eax,%edx
801023dc:	89 d0                	mov    %edx,%eax
801023de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023e1:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023e5:	7e 15                	jle    801023fc <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801023e7:	83 ec 04             	sub    $0x4,%esp
801023ea:	6a 0e                	push   $0xe
801023ec:	ff 75 f4             	pushl  -0xc(%ebp)
801023ef:	ff 75 0c             	pushl  0xc(%ebp)
801023f2:	e8 70 30 00 00       	call   80105467 <memmove>
801023f7:	83 c4 10             	add    $0x10,%esp
801023fa:	eb 26                	jmp    80102422 <skipelem+0x95>
  else {
    memmove(name, s, len);
801023fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023ff:	83 ec 04             	sub    $0x4,%esp
80102402:	50                   	push   %eax
80102403:	ff 75 f4             	pushl  -0xc(%ebp)
80102406:	ff 75 0c             	pushl  0xc(%ebp)
80102409:	e8 59 30 00 00       	call   80105467 <memmove>
8010240e:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102411:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102414:	8b 45 0c             	mov    0xc(%ebp),%eax
80102417:	01 d0                	add    %edx,%eax
80102419:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010241c:	eb 04                	jmp    80102422 <skipelem+0x95>
    path++;
8010241e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102422:	8b 45 08             	mov    0x8(%ebp),%eax
80102425:	0f b6 00             	movzbl (%eax),%eax
80102428:	3c 2f                	cmp    $0x2f,%al
8010242a:	74 f2                	je     8010241e <skipelem+0x91>
    path++;
  return path;
8010242c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010242f:	c9                   	leave  
80102430:	c3                   	ret    

80102431 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102431:	55                   	push   %ebp
80102432:	89 e5                	mov    %esp,%ebp
80102434:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102437:	8b 45 08             	mov    0x8(%ebp),%eax
8010243a:	0f b6 00             	movzbl (%eax),%eax
8010243d:	3c 2f                	cmp    $0x2f,%al
8010243f:	75 17                	jne    80102458 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102441:	83 ec 08             	sub    $0x8,%esp
80102444:	6a 01                	push   $0x1
80102446:	6a 01                	push   $0x1
80102448:	e8 a7 f4 ff ff       	call   801018f4 <iget>
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102453:	e9 ba 00 00 00       	jmp    80102512 <namex+0xe1>
  else
    ip = idup(myproc()->cwd);
80102458:	e8 db 1e 00 00       	call   80104338 <myproc>
8010245d:	8b 40 68             	mov    0x68(%eax),%eax
80102460:	83 ec 0c             	sub    $0xc,%esp
80102463:	50                   	push   %eax
80102464:	e8 6d f5 ff ff       	call   801019d6 <idup>
80102469:	83 c4 10             	add    $0x10,%esp
8010246c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010246f:	e9 9e 00 00 00       	jmp    80102512 <namex+0xe1>
    ilock(ip);
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	ff 75 f4             	pushl  -0xc(%ebp)
8010247a:	e8 91 f5 ff ff       	call   80101a10 <ilock>
8010247f:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102482:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102485:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102489:	66 83 f8 01          	cmp    $0x1,%ax
8010248d:	74 18                	je     801024a7 <namex+0x76>
      iunlockput(ip);
8010248f:	83 ec 0c             	sub    $0xc,%esp
80102492:	ff 75 f4             	pushl  -0xc(%ebp)
80102495:	e8 a7 f7 ff ff       	call   80101c41 <iunlockput>
8010249a:	83 c4 10             	add    $0x10,%esp
      return 0;
8010249d:	b8 00 00 00 00       	mov    $0x0,%eax
801024a2:	e9 a7 00 00 00       	jmp    8010254e <namex+0x11d>
    }
    if(nameiparent && *path == '\0'){
801024a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024ab:	74 20                	je     801024cd <namex+0x9c>
801024ad:	8b 45 08             	mov    0x8(%ebp),%eax
801024b0:	0f b6 00             	movzbl (%eax),%eax
801024b3:	84 c0                	test   %al,%al
801024b5:	75 16                	jne    801024cd <namex+0x9c>
      // Stop one level early.
      iunlock(ip);
801024b7:	83 ec 0c             	sub    $0xc,%esp
801024ba:	ff 75 f4             	pushl  -0xc(%ebp)
801024bd:	e8 61 f6 ff ff       	call   80101b23 <iunlock>
801024c2:	83 c4 10             	add    $0x10,%esp
      return ip;
801024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024c8:	e9 81 00 00 00       	jmp    8010254e <namex+0x11d>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024cd:	83 ec 04             	sub    $0x4,%esp
801024d0:	6a 00                	push   $0x0
801024d2:	ff 75 10             	pushl  0x10(%ebp)
801024d5:	ff 75 f4             	pushl  -0xc(%ebp)
801024d8:	e8 1e fd ff ff       	call   801021fb <dirlookup>
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024e7:	75 15                	jne    801024fe <namex+0xcd>
      iunlockput(ip);
801024e9:	83 ec 0c             	sub    $0xc,%esp
801024ec:	ff 75 f4             	pushl  -0xc(%ebp)
801024ef:	e8 4d f7 ff ff       	call   80101c41 <iunlockput>
801024f4:	83 c4 10             	add    $0x10,%esp
      return 0;
801024f7:	b8 00 00 00 00       	mov    $0x0,%eax
801024fc:	eb 50                	jmp    8010254e <namex+0x11d>
    }
    iunlockput(ip);
801024fe:	83 ec 0c             	sub    $0xc,%esp
80102501:	ff 75 f4             	pushl  -0xc(%ebp)
80102504:	e8 38 f7 ff ff       	call   80101c41 <iunlockput>
80102509:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010250c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010250f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
80102512:	83 ec 08             	sub    $0x8,%esp
80102515:	ff 75 10             	pushl  0x10(%ebp)
80102518:	ff 75 08             	pushl  0x8(%ebp)
8010251b:	e8 6d fe ff ff       	call   8010238d <skipelem>
80102520:	83 c4 10             	add    $0x10,%esp
80102523:	89 45 08             	mov    %eax,0x8(%ebp)
80102526:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010252a:	0f 85 44 ff ff ff    	jne    80102474 <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102530:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102534:	74 15                	je     8010254b <namex+0x11a>
    iput(ip);
80102536:	83 ec 0c             	sub    $0xc,%esp
80102539:	ff 75 f4             	pushl  -0xc(%ebp)
8010253c:	e8 30 f6 ff ff       	call   80101b71 <iput>
80102541:	83 c4 10             	add    $0x10,%esp
    return 0;
80102544:	b8 00 00 00 00       	mov    $0x0,%eax
80102549:	eb 03                	jmp    8010254e <namex+0x11d>
  }
  return ip;
8010254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010254e:	c9                   	leave  
8010254f:	c3                   	ret    

80102550 <namei>:

struct inode*
namei(char *path)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102556:	83 ec 04             	sub    $0x4,%esp
80102559:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010255c:	50                   	push   %eax
8010255d:	6a 00                	push   $0x0
8010255f:	ff 75 08             	pushl  0x8(%ebp)
80102562:	e8 ca fe ff ff       	call   80102431 <namex>
80102567:	83 c4 10             	add    $0x10,%esp
}
8010256a:	c9                   	leave  
8010256b:	c3                   	ret    

8010256c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010256c:	55                   	push   %ebp
8010256d:	89 e5                	mov    %esp,%ebp
8010256f:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102572:	83 ec 04             	sub    $0x4,%esp
80102575:	ff 75 0c             	pushl  0xc(%ebp)
80102578:	6a 01                	push   $0x1
8010257a:	ff 75 08             	pushl  0x8(%ebp)
8010257d:	e8 af fe ff ff       	call   80102431 <namex>
80102582:	83 c4 10             	add    $0x10,%esp
}
80102585:	c9                   	leave  
80102586:	c3                   	ret    

80102587 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102587:	55                   	push   %ebp
80102588:	89 e5                	mov    %esp,%ebp
8010258a:	83 ec 14             	sub    $0x14,%esp
8010258d:	8b 45 08             	mov    0x8(%ebp),%eax
80102590:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102594:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102598:	89 c2                	mov    %eax,%edx
8010259a:	ec                   	in     (%dx),%al
8010259b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010259e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801025a2:	c9                   	leave  
801025a3:	c3                   	ret    

801025a4 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801025a4:	55                   	push   %ebp
801025a5:	89 e5                	mov    %esp,%ebp
801025a7:	57                   	push   %edi
801025a8:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025a9:	8b 55 08             	mov    0x8(%ebp),%edx
801025ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025af:	8b 45 10             	mov    0x10(%ebp),%eax
801025b2:	89 cb                	mov    %ecx,%ebx
801025b4:	89 df                	mov    %ebx,%edi
801025b6:	89 c1                	mov    %eax,%ecx
801025b8:	fc                   	cld    
801025b9:	f3 6d                	rep insl (%dx),%es:(%edi)
801025bb:	89 c8                	mov    %ecx,%eax
801025bd:	89 fb                	mov    %edi,%ebx
801025bf:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025c2:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801025c5:	90                   	nop
801025c6:	5b                   	pop    %ebx
801025c7:	5f                   	pop    %edi
801025c8:	5d                   	pop    %ebp
801025c9:	c3                   	ret    

801025ca <outb>:

static inline void
outb(ushort port, uchar data)
{
801025ca:	55                   	push   %ebp
801025cb:	89 e5                	mov    %esp,%ebp
801025cd:	83 ec 08             	sub    $0x8,%esp
801025d0:	8b 55 08             	mov    0x8(%ebp),%edx
801025d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801025d6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801025da:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025dd:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025e1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025e5:	ee                   	out    %al,(%dx)
}
801025e6:	90                   	nop
801025e7:	c9                   	leave  
801025e8:	c3                   	ret    

801025e9 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801025e9:	55                   	push   %ebp
801025ea:	89 e5                	mov    %esp,%ebp
801025ec:	56                   	push   %esi
801025ed:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025ee:	8b 55 08             	mov    0x8(%ebp),%edx
801025f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025f4:	8b 45 10             	mov    0x10(%ebp),%eax
801025f7:	89 cb                	mov    %ecx,%ebx
801025f9:	89 de                	mov    %ebx,%esi
801025fb:	89 c1                	mov    %eax,%ecx
801025fd:	fc                   	cld    
801025fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102600:	89 c8                	mov    %ecx,%eax
80102602:	89 f3                	mov    %esi,%ebx
80102604:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102607:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010260a:	90                   	nop
8010260b:	5b                   	pop    %ebx
8010260c:	5e                   	pop    %esi
8010260d:	5d                   	pop    %ebp
8010260e:	c3                   	ret    

8010260f <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010260f:	55                   	push   %ebp
80102610:	89 e5                	mov    %esp,%ebp
80102612:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102615:	90                   	nop
80102616:	68 f7 01 00 00       	push   $0x1f7
8010261b:	e8 67 ff ff ff       	call   80102587 <inb>
80102620:	83 c4 04             	add    $0x4,%esp
80102623:	0f b6 c0             	movzbl %al,%eax
80102626:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102629:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010262c:	25 c0 00 00 00       	and    $0xc0,%eax
80102631:	83 f8 40             	cmp    $0x40,%eax
80102634:	75 e0                	jne    80102616 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102636:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010263a:	74 11                	je     8010264d <idewait+0x3e>
8010263c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010263f:	83 e0 21             	and    $0x21,%eax
80102642:	85 c0                	test   %eax,%eax
80102644:	74 07                	je     8010264d <idewait+0x3e>
    return -1;
80102646:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010264b:	eb 05                	jmp    80102652 <idewait+0x43>
  return 0;
8010264d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102652:	c9                   	leave  
80102653:	c3                   	ret    

80102654 <ideinit>:

void
ideinit(void)
{
80102654:	55                   	push   %ebp
80102655:	89 e5                	mov    %esp,%ebp
80102657:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
8010265a:	83 ec 08             	sub    $0x8,%esp
8010265d:	68 1f 89 10 80       	push   $0x8010891f
80102662:	68 00 b6 10 80       	push   $0x8010b600
80102667:	e8 93 2a 00 00       	call   801050ff <initlock>
8010266c:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010266f:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
80102674:	83 e8 01             	sub    $0x1,%eax
80102677:	83 ec 08             	sub    $0x8,%esp
8010267a:	50                   	push   %eax
8010267b:	6a 0e                	push   $0xe
8010267d:	e8 a2 04 00 00       	call   80102b24 <ioapicenable>
80102682:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102685:	83 ec 0c             	sub    $0xc,%esp
80102688:	6a 00                	push   $0x0
8010268a:	e8 80 ff ff ff       	call   8010260f <idewait>
8010268f:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102692:	83 ec 08             	sub    $0x8,%esp
80102695:	68 f0 00 00 00       	push   $0xf0
8010269a:	68 f6 01 00 00       	push   $0x1f6
8010269f:	e8 26 ff ff ff       	call   801025ca <outb>
801026a4:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801026a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026ae:	eb 24                	jmp    801026d4 <ideinit+0x80>
    if(inb(0x1f7) != 0){
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	68 f7 01 00 00       	push   $0x1f7
801026b8:	e8 ca fe ff ff       	call   80102587 <inb>
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	84 c0                	test   %al,%al
801026c2:	74 0c                	je     801026d0 <ideinit+0x7c>
      havedisk1 = 1;
801026c4:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
801026cb:	00 00 00 
      break;
801026ce:	eb 0d                	jmp    801026dd <ideinit+0x89>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801026d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801026d4:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026db:	7e d3                	jle    801026b0 <ideinit+0x5c>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026dd:	83 ec 08             	sub    $0x8,%esp
801026e0:	68 e0 00 00 00       	push   $0xe0
801026e5:	68 f6 01 00 00       	push   $0x1f6
801026ea:	e8 db fe ff ff       	call   801025ca <outb>
801026ef:	83 c4 10             	add    $0x10,%esp
}
801026f2:	90                   	nop
801026f3:	c9                   	leave  
801026f4:	c3                   	ret    

801026f5 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026f5:	55                   	push   %ebp
801026f6:	89 e5                	mov    %esp,%ebp
801026f8:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026ff:	75 0d                	jne    8010270e <idestart+0x19>
    panic("idestart");
80102701:	83 ec 0c             	sub    $0xc,%esp
80102704:	68 23 89 10 80       	push   $0x80108923
80102709:	e8 92 de ff ff       	call   801005a0 <panic>
  if(b->blockno >= FSSIZE)
8010270e:	8b 45 08             	mov    0x8(%ebp),%eax
80102711:	8b 40 08             	mov    0x8(%eax),%eax
80102714:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102719:	76 0d                	jbe    80102728 <idestart+0x33>
    panic("incorrect blockno");
8010271b:	83 ec 0c             	sub    $0xc,%esp
8010271e:	68 2c 89 10 80       	push   $0x8010892c
80102723:	e8 78 de ff ff       	call   801005a0 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102728:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010272f:	8b 45 08             	mov    0x8(%ebp),%eax
80102732:	8b 50 08             	mov    0x8(%eax),%edx
80102735:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102738:	0f af c2             	imul   %edx,%eax
8010273b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010273e:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102742:	75 07                	jne    8010274b <idestart+0x56>
80102744:	b8 20 00 00 00       	mov    $0x20,%eax
80102749:	eb 05                	jmp    80102750 <idestart+0x5b>
8010274b:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102750:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102753:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102757:	75 07                	jne    80102760 <idestart+0x6b>
80102759:	b8 30 00 00 00       	mov    $0x30,%eax
8010275e:	eb 05                	jmp    80102765 <idestart+0x70>
80102760:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102765:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102768:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010276c:	7e 0d                	jle    8010277b <idestart+0x86>
8010276e:	83 ec 0c             	sub    $0xc,%esp
80102771:	68 23 89 10 80       	push   $0x80108923
80102776:	e8 25 de ff ff       	call   801005a0 <panic>

  idewait(0);
8010277b:	83 ec 0c             	sub    $0xc,%esp
8010277e:	6a 00                	push   $0x0
80102780:	e8 8a fe ff ff       	call   8010260f <idewait>
80102785:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102788:	83 ec 08             	sub    $0x8,%esp
8010278b:	6a 00                	push   $0x0
8010278d:	68 f6 03 00 00       	push   $0x3f6
80102792:	e8 33 fe ff ff       	call   801025ca <outb>
80102797:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
8010279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010279d:	0f b6 c0             	movzbl %al,%eax
801027a0:	83 ec 08             	sub    $0x8,%esp
801027a3:	50                   	push   %eax
801027a4:	68 f2 01 00 00       	push   $0x1f2
801027a9:	e8 1c fe ff ff       	call   801025ca <outb>
801027ae:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027b4:	0f b6 c0             	movzbl %al,%eax
801027b7:	83 ec 08             	sub    $0x8,%esp
801027ba:	50                   	push   %eax
801027bb:	68 f3 01 00 00       	push   $0x1f3
801027c0:	e8 05 fe ff ff       	call   801025ca <outb>
801027c5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801027c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027cb:	c1 f8 08             	sar    $0x8,%eax
801027ce:	0f b6 c0             	movzbl %al,%eax
801027d1:	83 ec 08             	sub    $0x8,%esp
801027d4:	50                   	push   %eax
801027d5:	68 f4 01 00 00       	push   $0x1f4
801027da:	e8 eb fd ff ff       	call   801025ca <outb>
801027df:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027e5:	c1 f8 10             	sar    $0x10,%eax
801027e8:	0f b6 c0             	movzbl %al,%eax
801027eb:	83 ec 08             	sub    $0x8,%esp
801027ee:	50                   	push   %eax
801027ef:	68 f5 01 00 00       	push   $0x1f5
801027f4:	e8 d1 fd ff ff       	call   801025ca <outb>
801027f9:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027fc:	8b 45 08             	mov    0x8(%ebp),%eax
801027ff:	8b 40 04             	mov    0x4(%eax),%eax
80102802:	83 e0 01             	and    $0x1,%eax
80102805:	c1 e0 04             	shl    $0x4,%eax
80102808:	89 c2                	mov    %eax,%edx
8010280a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010280d:	c1 f8 18             	sar    $0x18,%eax
80102810:	83 e0 0f             	and    $0xf,%eax
80102813:	09 d0                	or     %edx,%eax
80102815:	83 c8 e0             	or     $0xffffffe0,%eax
80102818:	0f b6 c0             	movzbl %al,%eax
8010281b:	83 ec 08             	sub    $0x8,%esp
8010281e:	50                   	push   %eax
8010281f:	68 f6 01 00 00       	push   $0x1f6
80102824:	e8 a1 fd ff ff       	call   801025ca <outb>
80102829:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010282c:	8b 45 08             	mov    0x8(%ebp),%eax
8010282f:	8b 00                	mov    (%eax),%eax
80102831:	83 e0 04             	and    $0x4,%eax
80102834:	85 c0                	test   %eax,%eax
80102836:	74 35                	je     8010286d <idestart+0x178>
    outb(0x1f7, write_cmd);
80102838:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010283b:	0f b6 c0             	movzbl %al,%eax
8010283e:	83 ec 08             	sub    $0x8,%esp
80102841:	50                   	push   %eax
80102842:	68 f7 01 00 00       	push   $0x1f7
80102847:	e8 7e fd ff ff       	call   801025ca <outb>
8010284c:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010284f:	8b 45 08             	mov    0x8(%ebp),%eax
80102852:	83 c0 5c             	add    $0x5c,%eax
80102855:	83 ec 04             	sub    $0x4,%esp
80102858:	68 80 00 00 00       	push   $0x80
8010285d:	50                   	push   %eax
8010285e:	68 f0 01 00 00       	push   $0x1f0
80102863:	e8 81 fd ff ff       	call   801025e9 <outsl>
80102868:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010286b:	eb 17                	jmp    80102884 <idestart+0x18f>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
8010286d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102870:	0f b6 c0             	movzbl %al,%eax
80102873:	83 ec 08             	sub    $0x8,%esp
80102876:	50                   	push   %eax
80102877:	68 f7 01 00 00       	push   $0x1f7
8010287c:	e8 49 fd ff ff       	call   801025ca <outb>
80102881:	83 c4 10             	add    $0x10,%esp
  }
}
80102884:	90                   	nop
80102885:	c9                   	leave  
80102886:	c3                   	ret    

80102887 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102887:	55                   	push   %ebp
80102888:	89 e5                	mov    %esp,%ebp
8010288a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010288d:	83 ec 0c             	sub    $0xc,%esp
80102890:	68 00 b6 10 80       	push   $0x8010b600
80102895:	e8 87 28 00 00       	call   80105121 <acquire>
8010289a:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
8010289d:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801028a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028a9:	75 15                	jne    801028c0 <ideintr+0x39>
    release(&idelock);
801028ab:	83 ec 0c             	sub    $0xc,%esp
801028ae:	68 00 b6 10 80       	push   $0x8010b600
801028b3:	e8 d7 28 00 00       	call   8010518f <release>
801028b8:	83 c4 10             	add    $0x10,%esp
    return;
801028bb:	e9 9a 00 00 00       	jmp    8010295a <ideintr+0xd3>
  }
  idequeue = b->qnext;
801028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c3:	8b 40 58             	mov    0x58(%eax),%eax
801028c6:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ce:	8b 00                	mov    (%eax),%eax
801028d0:	83 e0 04             	and    $0x4,%eax
801028d3:	85 c0                	test   %eax,%eax
801028d5:	75 2d                	jne    80102904 <ideintr+0x7d>
801028d7:	83 ec 0c             	sub    $0xc,%esp
801028da:	6a 01                	push   $0x1
801028dc:	e8 2e fd ff ff       	call   8010260f <idewait>
801028e1:	83 c4 10             	add    $0x10,%esp
801028e4:	85 c0                	test   %eax,%eax
801028e6:	78 1c                	js     80102904 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028eb:	83 c0 5c             	add    $0x5c,%eax
801028ee:	83 ec 04             	sub    $0x4,%esp
801028f1:	68 80 00 00 00       	push   $0x80
801028f6:	50                   	push   %eax
801028f7:	68 f0 01 00 00       	push   $0x1f0
801028fc:	e8 a3 fc ff ff       	call   801025a4 <insl>
80102901:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102904:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102907:	8b 00                	mov    (%eax),%eax
80102909:	83 c8 02             	or     $0x2,%eax
8010290c:	89 c2                	mov    %eax,%edx
8010290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102911:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102913:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102916:	8b 00                	mov    (%eax),%eax
80102918:	83 e0 fb             	and    $0xfffffffb,%eax
8010291b:	89 c2                	mov    %eax,%edx
8010291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102920:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102922:	83 ec 0c             	sub    $0xc,%esp
80102925:	ff 75 f4             	pushl  -0xc(%ebp)
80102928:	e8 95 24 00 00       	call   80104dc2 <wakeup>
8010292d:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102930:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102935:	85 c0                	test   %eax,%eax
80102937:	74 11                	je     8010294a <ideintr+0xc3>
    idestart(idequeue);
80102939:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010293e:	83 ec 0c             	sub    $0xc,%esp
80102941:	50                   	push   %eax
80102942:	e8 ae fd ff ff       	call   801026f5 <idestart>
80102947:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010294a:	83 ec 0c             	sub    $0xc,%esp
8010294d:	68 00 b6 10 80       	push   $0x8010b600
80102952:	e8 38 28 00 00       	call   8010518f <release>
80102957:	83 c4 10             	add    $0x10,%esp
}
8010295a:	c9                   	leave  
8010295b:	c3                   	ret    

8010295c <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010295c:	55                   	push   %ebp
8010295d:	89 e5                	mov    %esp,%ebp
8010295f:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102962:	8b 45 08             	mov    0x8(%ebp),%eax
80102965:	83 c0 0c             	add    $0xc,%eax
80102968:	83 ec 0c             	sub    $0xc,%esp
8010296b:	50                   	push   %eax
8010296c:	e8 f9 26 00 00       	call   8010506a <holdingsleep>
80102971:	83 c4 10             	add    $0x10,%esp
80102974:	85 c0                	test   %eax,%eax
80102976:	75 0d                	jne    80102985 <iderw+0x29>
    panic("iderw: buf not locked");
80102978:	83 ec 0c             	sub    $0xc,%esp
8010297b:	68 3e 89 10 80       	push   $0x8010893e
80102980:	e8 1b dc ff ff       	call   801005a0 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102985:	8b 45 08             	mov    0x8(%ebp),%eax
80102988:	8b 00                	mov    (%eax),%eax
8010298a:	83 e0 06             	and    $0x6,%eax
8010298d:	83 f8 02             	cmp    $0x2,%eax
80102990:	75 0d                	jne    8010299f <iderw+0x43>
    panic("iderw: nothing to do");
80102992:	83 ec 0c             	sub    $0xc,%esp
80102995:	68 54 89 10 80       	push   $0x80108954
8010299a:	e8 01 dc ff ff       	call   801005a0 <panic>
  if(b->dev != 0 && !havedisk1)
8010299f:	8b 45 08             	mov    0x8(%ebp),%eax
801029a2:	8b 40 04             	mov    0x4(%eax),%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	74 16                	je     801029bf <iderw+0x63>
801029a9:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801029ae:	85 c0                	test   %eax,%eax
801029b0:	75 0d                	jne    801029bf <iderw+0x63>
    panic("iderw: ide disk 1 not present");
801029b2:	83 ec 0c             	sub    $0xc,%esp
801029b5:	68 69 89 10 80       	push   $0x80108969
801029ba:	e8 e1 db ff ff       	call   801005a0 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029bf:	83 ec 0c             	sub    $0xc,%esp
801029c2:	68 00 b6 10 80       	push   $0x8010b600
801029c7:	e8 55 27 00 00       	call   80105121 <acquire>
801029cc:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801029cf:	8b 45 08             	mov    0x8(%ebp),%eax
801029d2:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029d9:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
801029e0:	eb 0b                	jmp    801029ed <iderw+0x91>
801029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e5:	8b 00                	mov    (%eax),%eax
801029e7:	83 c0 58             	add    $0x58,%eax
801029ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f0:	8b 00                	mov    (%eax),%eax
801029f2:	85 c0                	test   %eax,%eax
801029f4:	75 ec                	jne    801029e2 <iderw+0x86>
    ;
  *pp = b;
801029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f9:	8b 55 08             	mov    0x8(%ebp),%edx
801029fc:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801029fe:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102a03:	3b 45 08             	cmp    0x8(%ebp),%eax
80102a06:	75 23                	jne    80102a2b <iderw+0xcf>
    idestart(b);
80102a08:	83 ec 0c             	sub    $0xc,%esp
80102a0b:	ff 75 08             	pushl  0x8(%ebp)
80102a0e:	e8 e2 fc ff ff       	call   801026f5 <idestart>
80102a13:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a16:	eb 13                	jmp    80102a2b <iderw+0xcf>
    sleep(b, &idelock);
80102a18:	83 ec 08             	sub    $0x8,%esp
80102a1b:	68 00 b6 10 80       	push   $0x8010b600
80102a20:	ff 75 08             	pushl  0x8(%ebp)
80102a23:	e8 b1 22 00 00       	call   80104cd9 <sleep>
80102a28:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2e:	8b 00                	mov    (%eax),%eax
80102a30:	83 e0 06             	and    $0x6,%eax
80102a33:	83 f8 02             	cmp    $0x2,%eax
80102a36:	75 e0                	jne    80102a18 <iderw+0xbc>
    sleep(b, &idelock);
  }


  release(&idelock);
80102a38:	83 ec 0c             	sub    $0xc,%esp
80102a3b:	68 00 b6 10 80       	push   $0x8010b600
80102a40:	e8 4a 27 00 00       	call   8010518f <release>
80102a45:	83 c4 10             	add    $0x10,%esp
}
80102a48:	90                   	nop
80102a49:	c9                   	leave  
80102a4a:	c3                   	ret    

80102a4b <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a4b:	55                   	push   %ebp
80102a4c:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a4e:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102a53:	8b 55 08             	mov    0x8(%ebp),%edx
80102a56:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a58:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102a5d:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a60:	5d                   	pop    %ebp
80102a61:	c3                   	ret    

80102a62 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a62:	55                   	push   %ebp
80102a63:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a65:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102a6a:	8b 55 08             	mov    0x8(%ebp),%edx
80102a6d:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a6f:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102a74:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a77:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a7a:	90                   	nop
80102a7b:	5d                   	pop    %ebp
80102a7c:	c3                   	ret    

80102a7d <ioapicinit>:

void
ioapicinit(void)
{
80102a7d:	55                   	push   %ebp
80102a7e:	89 e5                	mov    %esp,%ebp
80102a80:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a83:	c7 05 d4 36 11 80 00 	movl   $0xfec00000,0x801136d4
80102a8a:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a8d:	6a 01                	push   $0x1
80102a8f:	e8 b7 ff ff ff       	call   80102a4b <ioapicread>
80102a94:	83 c4 04             	add    $0x4,%esp
80102a97:	c1 e8 10             	shr    $0x10,%eax
80102a9a:	25 ff 00 00 00       	and    $0xff,%eax
80102a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102aa2:	6a 00                	push   $0x0
80102aa4:	e8 a2 ff ff ff       	call   80102a4b <ioapicread>
80102aa9:	83 c4 04             	add    $0x4,%esp
80102aac:	c1 e8 18             	shr    $0x18,%eax
80102aaf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102ab2:	0f b6 05 00 38 11 80 	movzbl 0x80113800,%eax
80102ab9:	0f b6 c0             	movzbl %al,%eax
80102abc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102abf:	74 10                	je     80102ad1 <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102ac1:	83 ec 0c             	sub    $0xc,%esp
80102ac4:	68 88 89 10 80       	push   $0x80108988
80102ac9:	e8 32 d9 ff ff       	call   80100400 <cprintf>
80102ace:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ad1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ad8:	eb 3f                	jmp    80102b19 <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102add:	83 c0 20             	add    $0x20,%eax
80102ae0:	0d 00 00 01 00       	or     $0x10000,%eax
80102ae5:	89 c2                	mov    %eax,%edx
80102ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aea:	83 c0 08             	add    $0x8,%eax
80102aed:	01 c0                	add    %eax,%eax
80102aef:	83 ec 08             	sub    $0x8,%esp
80102af2:	52                   	push   %edx
80102af3:	50                   	push   %eax
80102af4:	e8 69 ff ff ff       	call   80102a62 <ioapicwrite>
80102af9:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aff:	83 c0 08             	add    $0x8,%eax
80102b02:	01 c0                	add    %eax,%eax
80102b04:	83 c0 01             	add    $0x1,%eax
80102b07:	83 ec 08             	sub    $0x8,%esp
80102b0a:	6a 00                	push   $0x0
80102b0c:	50                   	push   %eax
80102b0d:	e8 50 ff ff ff       	call   80102a62 <ioapicwrite>
80102b12:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b1f:	7e b9                	jle    80102ada <ioapicinit+0x5d>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b21:	90                   	nop
80102b22:	c9                   	leave  
80102b23:	c3                   	ret    

80102b24 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b24:	55                   	push   %ebp
80102b25:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b27:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2a:	83 c0 20             	add    $0x20,%eax
80102b2d:	89 c2                	mov    %eax,%edx
80102b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b32:	83 c0 08             	add    $0x8,%eax
80102b35:	01 c0                	add    %eax,%eax
80102b37:	52                   	push   %edx
80102b38:	50                   	push   %eax
80102b39:	e8 24 ff ff ff       	call   80102a62 <ioapicwrite>
80102b3e:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b41:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b44:	c1 e0 18             	shl    $0x18,%eax
80102b47:	89 c2                	mov    %eax,%edx
80102b49:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4c:	83 c0 08             	add    $0x8,%eax
80102b4f:	01 c0                	add    %eax,%eax
80102b51:	83 c0 01             	add    $0x1,%eax
80102b54:	52                   	push   %edx
80102b55:	50                   	push   %eax
80102b56:	e8 07 ff ff ff       	call   80102a62 <ioapicwrite>
80102b5b:	83 c4 08             	add    $0x8,%esp
}
80102b5e:	90                   	nop
80102b5f:	c9                   	leave  
80102b60:	c3                   	ret    

80102b61 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b61:	55                   	push   %ebp
80102b62:	89 e5                	mov    %esp,%ebp
80102b64:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b67:	83 ec 08             	sub    $0x8,%esp
80102b6a:	68 ba 89 10 80       	push   $0x801089ba
80102b6f:	68 e0 36 11 80       	push   $0x801136e0
80102b74:	e8 86 25 00 00       	call   801050ff <initlock>
80102b79:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b7c:	c7 05 14 37 11 80 00 	movl   $0x0,0x80113714
80102b83:	00 00 00 
  freerange(vstart, vend);
80102b86:	83 ec 08             	sub    $0x8,%esp
80102b89:	ff 75 0c             	pushl  0xc(%ebp)
80102b8c:	ff 75 08             	pushl  0x8(%ebp)
80102b8f:	e8 2a 00 00 00       	call   80102bbe <freerange>
80102b94:	83 c4 10             	add    $0x10,%esp
}
80102b97:	90                   	nop
80102b98:	c9                   	leave  
80102b99:	c3                   	ret    

80102b9a <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b9a:	55                   	push   %ebp
80102b9b:	89 e5                	mov    %esp,%ebp
80102b9d:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102ba0:	83 ec 08             	sub    $0x8,%esp
80102ba3:	ff 75 0c             	pushl  0xc(%ebp)
80102ba6:	ff 75 08             	pushl  0x8(%ebp)
80102ba9:	e8 10 00 00 00       	call   80102bbe <freerange>
80102bae:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102bb1:	c7 05 14 37 11 80 01 	movl   $0x1,0x80113714
80102bb8:	00 00 00 
}
80102bbb:	90                   	nop
80102bbc:	c9                   	leave  
80102bbd:	c3                   	ret    

80102bbe <freerange>:

void
freerange(void *vstart, void *vend)
{
80102bbe:	55                   	push   %ebp
80102bbf:	89 e5                	mov    %esp,%ebp
80102bc1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80102bc7:	05 ff 0f 00 00       	add    $0xfff,%eax
80102bcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bd4:	eb 15                	jmp    80102beb <freerange+0x2d>
    kfree(p);
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	ff 75 f4             	pushl  -0xc(%ebp)
80102bdc:	e8 1a 00 00 00       	call   80102bfb <kfree>
80102be1:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102be4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bee:	05 00 10 00 00       	add    $0x1000,%eax
80102bf3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102bf6:	76 de                	jbe    80102bd6 <freerange+0x18>
    kfree(p);
}
80102bf8:	90                   	nop
80102bf9:	c9                   	leave  
80102bfa:	c3                   	ret    

80102bfb <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bfb:	55                   	push   %ebp
80102bfc:	89 e5                	mov    %esp,%ebp
80102bfe:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102c01:	8b 45 08             	mov    0x8(%ebp),%eax
80102c04:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c09:	85 c0                	test   %eax,%eax
80102c0b:	75 18                	jne    80102c25 <kfree+0x2a>
80102c0d:	81 7d 08 a0 69 11 80 	cmpl   $0x801169a0,0x8(%ebp)
80102c14:	72 0f                	jb     80102c25 <kfree+0x2a>
80102c16:	8b 45 08             	mov    0x8(%ebp),%eax
80102c19:	05 00 00 00 80       	add    $0x80000000,%eax
80102c1e:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c23:	76 0d                	jbe    80102c32 <kfree+0x37>
    panic("kfree");
80102c25:	83 ec 0c             	sub    $0xc,%esp
80102c28:	68 bf 89 10 80       	push   $0x801089bf
80102c2d:	e8 6e d9 ff ff       	call   801005a0 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c32:	83 ec 04             	sub    $0x4,%esp
80102c35:	68 00 10 00 00       	push   $0x1000
80102c3a:	6a 01                	push   $0x1
80102c3c:	ff 75 08             	pushl  0x8(%ebp)
80102c3f:	e8 64 27 00 00       	call   801053a8 <memset>
80102c44:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c47:	a1 14 37 11 80       	mov    0x80113714,%eax
80102c4c:	85 c0                	test   %eax,%eax
80102c4e:	74 10                	je     80102c60 <kfree+0x65>
    acquire(&kmem.lock);
80102c50:	83 ec 0c             	sub    $0xc,%esp
80102c53:	68 e0 36 11 80       	push   $0x801136e0
80102c58:	e8 c4 24 00 00       	call   80105121 <acquire>
80102c5d:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c60:	8b 45 08             	mov    0x8(%ebp),%eax
80102c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c66:	8b 15 18 37 11 80    	mov    0x80113718,%edx
80102c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6f:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c74:	a3 18 37 11 80       	mov    %eax,0x80113718
  if(kmem.use_lock)
80102c79:	a1 14 37 11 80       	mov    0x80113714,%eax
80102c7e:	85 c0                	test   %eax,%eax
80102c80:	74 10                	je     80102c92 <kfree+0x97>
    release(&kmem.lock);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	68 e0 36 11 80       	push   $0x801136e0
80102c8a:	e8 00 25 00 00       	call   8010518f <release>
80102c8f:	83 c4 10             	add    $0x10,%esp
}
80102c92:	90                   	nop
80102c93:	c9                   	leave  
80102c94:	c3                   	ret    

80102c95 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c95:	55                   	push   %ebp
80102c96:	89 e5                	mov    %esp,%ebp
80102c98:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c9b:	a1 14 37 11 80       	mov    0x80113714,%eax
80102ca0:	85 c0                	test   %eax,%eax
80102ca2:	74 10                	je     80102cb4 <kalloc+0x1f>
    acquire(&kmem.lock);
80102ca4:	83 ec 0c             	sub    $0xc,%esp
80102ca7:	68 e0 36 11 80       	push   $0x801136e0
80102cac:	e8 70 24 00 00       	call   80105121 <acquire>
80102cb1:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102cb4:	a1 18 37 11 80       	mov    0x80113718,%eax
80102cb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102cbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102cc0:	74 0a                	je     80102ccc <kalloc+0x37>
    kmem.freelist = r->next;
80102cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc5:	8b 00                	mov    (%eax),%eax
80102cc7:	a3 18 37 11 80       	mov    %eax,0x80113718
  if(kmem.use_lock)
80102ccc:	a1 14 37 11 80       	mov    0x80113714,%eax
80102cd1:	85 c0                	test   %eax,%eax
80102cd3:	74 10                	je     80102ce5 <kalloc+0x50>
    release(&kmem.lock);
80102cd5:	83 ec 0c             	sub    $0xc,%esp
80102cd8:	68 e0 36 11 80       	push   $0x801136e0
80102cdd:	e8 ad 24 00 00       	call   8010518f <release>
80102ce2:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102ce8:	c9                   	leave  
80102ce9:	c3                   	ret    

80102cea <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102cea:	55                   	push   %ebp
80102ceb:	89 e5                	mov    %esp,%ebp
80102ced:	83 ec 14             	sub    $0x14,%esp
80102cf0:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102cfb:	89 c2                	mov    %eax,%edx
80102cfd:	ec                   	in     (%dx),%al
80102cfe:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d01:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d05:	c9                   	leave  
80102d06:	c3                   	ret    

80102d07 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d07:	55                   	push   %ebp
80102d08:	89 e5                	mov    %esp,%ebp
80102d0a:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d0d:	6a 64                	push   $0x64
80102d0f:	e8 d6 ff ff ff       	call   80102cea <inb>
80102d14:	83 c4 04             	add    $0x4,%esp
80102d17:	0f b6 c0             	movzbl %al,%eax
80102d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d20:	83 e0 01             	and    $0x1,%eax
80102d23:	85 c0                	test   %eax,%eax
80102d25:	75 0a                	jne    80102d31 <kbdgetc+0x2a>
    return -1;
80102d27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d2c:	e9 23 01 00 00       	jmp    80102e54 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d31:	6a 60                	push   $0x60
80102d33:	e8 b2 ff ff ff       	call   80102cea <inb>
80102d38:	83 c4 04             	add    $0x4,%esp
80102d3b:	0f b6 c0             	movzbl %al,%eax
80102d3e:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d41:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d48:	75 17                	jne    80102d61 <kbdgetc+0x5a>
    shift |= E0ESC;
80102d4a:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d4f:	83 c8 40             	or     $0x40,%eax
80102d52:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102d57:	b8 00 00 00 00       	mov    $0x0,%eax
80102d5c:	e9 f3 00 00 00       	jmp    80102e54 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d64:	25 80 00 00 00       	and    $0x80,%eax
80102d69:	85 c0                	test   %eax,%eax
80102d6b:	74 45                	je     80102db2 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d6d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d72:	83 e0 40             	and    $0x40,%eax
80102d75:	85 c0                	test   %eax,%eax
80102d77:	75 08                	jne    80102d81 <kbdgetc+0x7a>
80102d79:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d7c:	83 e0 7f             	and    $0x7f,%eax
80102d7f:	eb 03                	jmp    80102d84 <kbdgetc+0x7d>
80102d81:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d84:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d87:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d8a:	05 20 90 10 80       	add    $0x80109020,%eax
80102d8f:	0f b6 00             	movzbl (%eax),%eax
80102d92:	83 c8 40             	or     $0x40,%eax
80102d95:	0f b6 c0             	movzbl %al,%eax
80102d98:	f7 d0                	not    %eax
80102d9a:	89 c2                	mov    %eax,%edx
80102d9c:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102da1:	21 d0                	and    %edx,%eax
80102da3:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102da8:	b8 00 00 00 00       	mov    $0x0,%eax
80102dad:	e9 a2 00 00 00       	jmp    80102e54 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102db2:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102db7:	83 e0 40             	and    $0x40,%eax
80102dba:	85 c0                	test   %eax,%eax
80102dbc:	74 14                	je     80102dd2 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102dbe:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102dc5:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102dca:	83 e0 bf             	and    $0xffffffbf,%eax
80102dcd:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd5:	05 20 90 10 80       	add    $0x80109020,%eax
80102dda:	0f b6 00             	movzbl (%eax),%eax
80102ddd:	0f b6 d0             	movzbl %al,%edx
80102de0:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102de5:	09 d0                	or     %edx,%eax
80102de7:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102def:	05 20 91 10 80       	add    $0x80109120,%eax
80102df4:	0f b6 00             	movzbl (%eax),%eax
80102df7:	0f b6 d0             	movzbl %al,%edx
80102dfa:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102dff:	31 d0                	xor    %edx,%eax
80102e01:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e06:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102e0b:	83 e0 03             	and    $0x3,%eax
80102e0e:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102e15:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e18:	01 d0                	add    %edx,%eax
80102e1a:	0f b6 00             	movzbl (%eax),%eax
80102e1d:	0f b6 c0             	movzbl %al,%eax
80102e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e23:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102e28:	83 e0 08             	and    $0x8,%eax
80102e2b:	85 c0                	test   %eax,%eax
80102e2d:	74 22                	je     80102e51 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e2f:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e33:	76 0c                	jbe    80102e41 <kbdgetc+0x13a>
80102e35:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e39:	77 06                	ja     80102e41 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e3b:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e3f:	eb 10                	jmp    80102e51 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e41:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e45:	76 0a                	jbe    80102e51 <kbdgetc+0x14a>
80102e47:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e4b:	77 04                	ja     80102e51 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e4d:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e54:	c9                   	leave  
80102e55:	c3                   	ret    

80102e56 <kbdintr>:

void
kbdintr(void)
{
80102e56:	55                   	push   %ebp
80102e57:	89 e5                	mov    %esp,%ebp
80102e59:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e5c:	83 ec 0c             	sub    $0xc,%esp
80102e5f:	68 07 2d 10 80       	push   $0x80102d07
80102e64:	e8 c3 d9 ff ff       	call   8010082c <consoleintr>
80102e69:	83 c4 10             	add    $0x10,%esp
}
80102e6c:	90                   	nop
80102e6d:	c9                   	leave  
80102e6e:	c3                   	ret    

80102e6f <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e6f:	55                   	push   %ebp
80102e70:	89 e5                	mov    %esp,%ebp
80102e72:	83 ec 14             	sub    $0x14,%esp
80102e75:	8b 45 08             	mov    0x8(%ebp),%eax
80102e78:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e7c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e80:	89 c2                	mov    %eax,%edx
80102e82:	ec                   	in     (%dx),%al
80102e83:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e86:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e8a:	c9                   	leave  
80102e8b:	c3                   	ret    

80102e8c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102e8c:	55                   	push   %ebp
80102e8d:	89 e5                	mov    %esp,%ebp
80102e8f:	83 ec 08             	sub    $0x8,%esp
80102e92:	8b 55 08             	mov    0x8(%ebp),%edx
80102e95:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e98:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102e9c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e9f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102ea3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102ea7:	ee                   	out    %al,(%dx)
}
80102ea8:	90                   	nop
80102ea9:	c9                   	leave  
80102eaa:	c3                   	ret    

80102eab <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102eab:	55                   	push   %ebp
80102eac:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102eae:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102eb3:	8b 55 08             	mov    0x8(%ebp),%edx
80102eb6:	c1 e2 02             	shl    $0x2,%edx
80102eb9:	01 c2                	add    %eax,%edx
80102ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ebe:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ec0:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102ec5:	83 c0 20             	add    $0x20,%eax
80102ec8:	8b 00                	mov    (%eax),%eax
}
80102eca:	90                   	nop
80102ecb:	5d                   	pop    %ebp
80102ecc:	c3                   	ret    

80102ecd <lapicinit>:

void
lapicinit(void)
{
80102ecd:	55                   	push   %ebp
80102ece:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102ed0:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102ed5:	85 c0                	test   %eax,%eax
80102ed7:	0f 84 0b 01 00 00    	je     80102fe8 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102edd:	68 3f 01 00 00       	push   $0x13f
80102ee2:	6a 3c                	push   $0x3c
80102ee4:	e8 c2 ff ff ff       	call   80102eab <lapicw>
80102ee9:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102eec:	6a 0b                	push   $0xb
80102eee:	68 f8 00 00 00       	push   $0xf8
80102ef3:	e8 b3 ff ff ff       	call   80102eab <lapicw>
80102ef8:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102efb:	68 20 00 02 00       	push   $0x20020
80102f00:	68 c8 00 00 00       	push   $0xc8
80102f05:	e8 a1 ff ff ff       	call   80102eab <lapicw>
80102f0a:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102f0d:	68 80 96 98 00       	push   $0x989680
80102f12:	68 e0 00 00 00       	push   $0xe0
80102f17:	e8 8f ff ff ff       	call   80102eab <lapicw>
80102f1c:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f1f:	68 00 00 01 00       	push   $0x10000
80102f24:	68 d4 00 00 00       	push   $0xd4
80102f29:	e8 7d ff ff ff       	call   80102eab <lapicw>
80102f2e:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f31:	68 00 00 01 00       	push   $0x10000
80102f36:	68 d8 00 00 00       	push   $0xd8
80102f3b:	e8 6b ff ff ff       	call   80102eab <lapicw>
80102f40:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f43:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102f48:	83 c0 30             	add    $0x30,%eax
80102f4b:	8b 00                	mov    (%eax),%eax
80102f4d:	c1 e8 10             	shr    $0x10,%eax
80102f50:	0f b6 c0             	movzbl %al,%eax
80102f53:	83 f8 03             	cmp    $0x3,%eax
80102f56:	76 12                	jbe    80102f6a <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102f58:	68 00 00 01 00       	push   $0x10000
80102f5d:	68 d0 00 00 00       	push   $0xd0
80102f62:	e8 44 ff ff ff       	call   80102eab <lapicw>
80102f67:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f6a:	6a 33                	push   $0x33
80102f6c:	68 dc 00 00 00       	push   $0xdc
80102f71:	e8 35 ff ff ff       	call   80102eab <lapicw>
80102f76:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f79:	6a 00                	push   $0x0
80102f7b:	68 a0 00 00 00       	push   $0xa0
80102f80:	e8 26 ff ff ff       	call   80102eab <lapicw>
80102f85:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f88:	6a 00                	push   $0x0
80102f8a:	68 a0 00 00 00       	push   $0xa0
80102f8f:	e8 17 ff ff ff       	call   80102eab <lapicw>
80102f94:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f97:	6a 00                	push   $0x0
80102f99:	6a 2c                	push   $0x2c
80102f9b:	e8 0b ff ff ff       	call   80102eab <lapicw>
80102fa0:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102fa3:	6a 00                	push   $0x0
80102fa5:	68 c4 00 00 00       	push   $0xc4
80102faa:	e8 fc fe ff ff       	call   80102eab <lapicw>
80102faf:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102fb2:	68 00 85 08 00       	push   $0x88500
80102fb7:	68 c0 00 00 00       	push   $0xc0
80102fbc:	e8 ea fe ff ff       	call   80102eab <lapicw>
80102fc1:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102fc4:	90                   	nop
80102fc5:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102fca:	05 00 03 00 00       	add    $0x300,%eax
80102fcf:	8b 00                	mov    (%eax),%eax
80102fd1:	25 00 10 00 00       	and    $0x1000,%eax
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	75 eb                	jne    80102fc5 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102fda:	6a 00                	push   $0x0
80102fdc:	6a 20                	push   $0x20
80102fde:	e8 c8 fe ff ff       	call   80102eab <lapicw>
80102fe3:	83 c4 08             	add    $0x8,%esp
80102fe6:	eb 01                	jmp    80102fe9 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic)
    return;
80102fe8:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102fe9:	c9                   	leave  
80102fea:	c3                   	ret    

80102feb <lapicid>:

int
lapicid(void)
{
80102feb:	55                   	push   %ebp
80102fec:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102fee:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102ff3:	85 c0                	test   %eax,%eax
80102ff5:	75 07                	jne    80102ffe <lapicid+0x13>
    return 0;
80102ff7:	b8 00 00 00 00       	mov    $0x0,%eax
80102ffc:	eb 0d                	jmp    8010300b <lapicid+0x20>
  return lapic[ID] >> 24;
80102ffe:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80103003:	83 c0 20             	add    $0x20,%eax
80103006:	8b 00                	mov    (%eax),%eax
80103008:	c1 e8 18             	shr    $0x18,%eax
}
8010300b:	5d                   	pop    %ebp
8010300c:	c3                   	ret    

8010300d <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010300d:	55                   	push   %ebp
8010300e:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103010:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80103015:	85 c0                	test   %eax,%eax
80103017:	74 0c                	je     80103025 <lapiceoi+0x18>
    lapicw(EOI, 0);
80103019:	6a 00                	push   $0x0
8010301b:	6a 2c                	push   $0x2c
8010301d:	e8 89 fe ff ff       	call   80102eab <lapicw>
80103022:	83 c4 08             	add    $0x8,%esp
}
80103025:	90                   	nop
80103026:	c9                   	leave  
80103027:	c3                   	ret    

80103028 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103028:	55                   	push   %ebp
80103029:	89 e5                	mov    %esp,%ebp
}
8010302b:	90                   	nop
8010302c:	5d                   	pop    %ebp
8010302d:	c3                   	ret    

8010302e <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010302e:	55                   	push   %ebp
8010302f:	89 e5                	mov    %esp,%ebp
80103031:	83 ec 14             	sub    $0x14,%esp
80103034:	8b 45 08             	mov    0x8(%ebp),%eax
80103037:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8010303a:	6a 0f                	push   $0xf
8010303c:	6a 70                	push   $0x70
8010303e:	e8 49 fe ff ff       	call   80102e8c <outb>
80103043:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103046:	6a 0a                	push   $0xa
80103048:	6a 71                	push   $0x71
8010304a:	e8 3d fe ff ff       	call   80102e8c <outb>
8010304f:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103052:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103059:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010305c:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103061:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103064:	83 c0 02             	add    $0x2,%eax
80103067:	8b 55 0c             	mov    0xc(%ebp),%edx
8010306a:	c1 ea 04             	shr    $0x4,%edx
8010306d:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103070:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103074:	c1 e0 18             	shl    $0x18,%eax
80103077:	50                   	push   %eax
80103078:	68 c4 00 00 00       	push   $0xc4
8010307d:	e8 29 fe ff ff       	call   80102eab <lapicw>
80103082:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103085:	68 00 c5 00 00       	push   $0xc500
8010308a:	68 c0 00 00 00       	push   $0xc0
8010308f:	e8 17 fe ff ff       	call   80102eab <lapicw>
80103094:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103097:	68 c8 00 00 00       	push   $0xc8
8010309c:	e8 87 ff ff ff       	call   80103028 <microdelay>
801030a1:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801030a4:	68 00 85 00 00       	push   $0x8500
801030a9:	68 c0 00 00 00       	push   $0xc0
801030ae:	e8 f8 fd ff ff       	call   80102eab <lapicw>
801030b3:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030b6:	6a 64                	push   $0x64
801030b8:	e8 6b ff ff ff       	call   80103028 <microdelay>
801030bd:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030c7:	eb 3d                	jmp    80103106 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
801030c9:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030cd:	c1 e0 18             	shl    $0x18,%eax
801030d0:	50                   	push   %eax
801030d1:	68 c4 00 00 00       	push   $0xc4
801030d6:	e8 d0 fd ff ff       	call   80102eab <lapicw>
801030db:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801030de:	8b 45 0c             	mov    0xc(%ebp),%eax
801030e1:	c1 e8 0c             	shr    $0xc,%eax
801030e4:	80 cc 06             	or     $0x6,%ah
801030e7:	50                   	push   %eax
801030e8:	68 c0 00 00 00       	push   $0xc0
801030ed:	e8 b9 fd ff ff       	call   80102eab <lapicw>
801030f2:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801030f5:	68 c8 00 00 00       	push   $0xc8
801030fa:	e8 29 ff ff ff       	call   80103028 <microdelay>
801030ff:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103102:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103106:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010310a:	7e bd                	jle    801030c9 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010310c:	90                   	nop
8010310d:	c9                   	leave  
8010310e:	c3                   	ret    

8010310f <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
8010310f:	55                   	push   %ebp
80103110:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103112:	8b 45 08             	mov    0x8(%ebp),%eax
80103115:	0f b6 c0             	movzbl %al,%eax
80103118:	50                   	push   %eax
80103119:	6a 70                	push   $0x70
8010311b:	e8 6c fd ff ff       	call   80102e8c <outb>
80103120:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103123:	68 c8 00 00 00       	push   $0xc8
80103128:	e8 fb fe ff ff       	call   80103028 <microdelay>
8010312d:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103130:	6a 71                	push   $0x71
80103132:	e8 38 fd ff ff       	call   80102e6f <inb>
80103137:	83 c4 04             	add    $0x4,%esp
8010313a:	0f b6 c0             	movzbl %al,%eax
}
8010313d:	c9                   	leave  
8010313e:	c3                   	ret    

8010313f <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
8010313f:	55                   	push   %ebp
80103140:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103142:	6a 00                	push   $0x0
80103144:	e8 c6 ff ff ff       	call   8010310f <cmos_read>
80103149:	83 c4 04             	add    $0x4,%esp
8010314c:	89 c2                	mov    %eax,%edx
8010314e:	8b 45 08             	mov    0x8(%ebp),%eax
80103151:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103153:	6a 02                	push   $0x2
80103155:	e8 b5 ff ff ff       	call   8010310f <cmos_read>
8010315a:	83 c4 04             	add    $0x4,%esp
8010315d:	89 c2                	mov    %eax,%edx
8010315f:	8b 45 08             	mov    0x8(%ebp),%eax
80103162:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103165:	6a 04                	push   $0x4
80103167:	e8 a3 ff ff ff       	call   8010310f <cmos_read>
8010316c:	83 c4 04             	add    $0x4,%esp
8010316f:	89 c2                	mov    %eax,%edx
80103171:	8b 45 08             	mov    0x8(%ebp),%eax
80103174:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103177:	6a 07                	push   $0x7
80103179:	e8 91 ff ff ff       	call   8010310f <cmos_read>
8010317e:	83 c4 04             	add    $0x4,%esp
80103181:	89 c2                	mov    %eax,%edx
80103183:	8b 45 08             	mov    0x8(%ebp),%eax
80103186:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103189:	6a 08                	push   $0x8
8010318b:	e8 7f ff ff ff       	call   8010310f <cmos_read>
80103190:	83 c4 04             	add    $0x4,%esp
80103193:	89 c2                	mov    %eax,%edx
80103195:	8b 45 08             	mov    0x8(%ebp),%eax
80103198:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010319b:	6a 09                	push   $0x9
8010319d:	e8 6d ff ff ff       	call   8010310f <cmos_read>
801031a2:	83 c4 04             	add    $0x4,%esp
801031a5:	89 c2                	mov    %eax,%edx
801031a7:	8b 45 08             	mov    0x8(%ebp),%eax
801031aa:	89 50 14             	mov    %edx,0x14(%eax)
}
801031ad:	90                   	nop
801031ae:	c9                   	leave  
801031af:	c3                   	ret    

801031b0 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031b6:	6a 0b                	push   $0xb
801031b8:	e8 52 ff ff ff       	call   8010310f <cmos_read>
801031bd:	83 c4 04             	add    $0x4,%esp
801031c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031c6:	83 e0 04             	and    $0x4,%eax
801031c9:	85 c0                	test   %eax,%eax
801031cb:	0f 94 c0             	sete   %al
801031ce:	0f b6 c0             	movzbl %al,%eax
801031d1:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801031d4:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031d7:	50                   	push   %eax
801031d8:	e8 62 ff ff ff       	call   8010313f <fill_rtcdate>
801031dd:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801031e0:	6a 0a                	push   $0xa
801031e2:	e8 28 ff ff ff       	call   8010310f <cmos_read>
801031e7:	83 c4 04             	add    $0x4,%esp
801031ea:	25 80 00 00 00       	and    $0x80,%eax
801031ef:	85 c0                	test   %eax,%eax
801031f1:	75 27                	jne    8010321a <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801031f3:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031f6:	50                   	push   %eax
801031f7:	e8 43 ff ff ff       	call   8010313f <fill_rtcdate>
801031fc:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801031ff:	83 ec 04             	sub    $0x4,%esp
80103202:	6a 18                	push   $0x18
80103204:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103207:	50                   	push   %eax
80103208:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010320b:	50                   	push   %eax
8010320c:	e8 fe 21 00 00       	call   8010540f <memcmp>
80103211:	83 c4 10             	add    $0x10,%esp
80103214:	85 c0                	test   %eax,%eax
80103216:	74 05                	je     8010321d <cmostime+0x6d>
80103218:	eb ba                	jmp    801031d4 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
8010321a:	90                   	nop
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010321b:	eb b7                	jmp    801031d4 <cmostime+0x24>
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
8010321d:	90                   	nop
  }

  // convert
  if(bcd) {
8010321e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103222:	0f 84 b4 00 00 00    	je     801032dc <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103228:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010322b:	c1 e8 04             	shr    $0x4,%eax
8010322e:	89 c2                	mov    %eax,%edx
80103230:	89 d0                	mov    %edx,%eax
80103232:	c1 e0 02             	shl    $0x2,%eax
80103235:	01 d0                	add    %edx,%eax
80103237:	01 c0                	add    %eax,%eax
80103239:	89 c2                	mov    %eax,%edx
8010323b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010323e:	83 e0 0f             	and    $0xf,%eax
80103241:	01 d0                	add    %edx,%eax
80103243:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103246:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103249:	c1 e8 04             	shr    $0x4,%eax
8010324c:	89 c2                	mov    %eax,%edx
8010324e:	89 d0                	mov    %edx,%eax
80103250:	c1 e0 02             	shl    $0x2,%eax
80103253:	01 d0                	add    %edx,%eax
80103255:	01 c0                	add    %eax,%eax
80103257:	89 c2                	mov    %eax,%edx
80103259:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010325c:	83 e0 0f             	and    $0xf,%eax
8010325f:	01 d0                	add    %edx,%eax
80103261:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103264:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103267:	c1 e8 04             	shr    $0x4,%eax
8010326a:	89 c2                	mov    %eax,%edx
8010326c:	89 d0                	mov    %edx,%eax
8010326e:	c1 e0 02             	shl    $0x2,%eax
80103271:	01 d0                	add    %edx,%eax
80103273:	01 c0                	add    %eax,%eax
80103275:	89 c2                	mov    %eax,%edx
80103277:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010327a:	83 e0 0f             	and    $0xf,%eax
8010327d:	01 d0                	add    %edx,%eax
8010327f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103285:	c1 e8 04             	shr    $0x4,%eax
80103288:	89 c2                	mov    %eax,%edx
8010328a:	89 d0                	mov    %edx,%eax
8010328c:	c1 e0 02             	shl    $0x2,%eax
8010328f:	01 d0                	add    %edx,%eax
80103291:	01 c0                	add    %eax,%eax
80103293:	89 c2                	mov    %eax,%edx
80103295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103298:	83 e0 0f             	and    $0xf,%eax
8010329b:	01 d0                	add    %edx,%eax
8010329d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801032a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032a3:	c1 e8 04             	shr    $0x4,%eax
801032a6:	89 c2                	mov    %eax,%edx
801032a8:	89 d0                	mov    %edx,%eax
801032aa:	c1 e0 02             	shl    $0x2,%eax
801032ad:	01 d0                	add    %edx,%eax
801032af:	01 c0                	add    %eax,%eax
801032b1:	89 c2                	mov    %eax,%edx
801032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032b6:	83 e0 0f             	and    $0xf,%eax
801032b9:	01 d0                	add    %edx,%eax
801032bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801032be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032c1:	c1 e8 04             	shr    $0x4,%eax
801032c4:	89 c2                	mov    %eax,%edx
801032c6:	89 d0                	mov    %edx,%eax
801032c8:	c1 e0 02             	shl    $0x2,%eax
801032cb:	01 d0                	add    %edx,%eax
801032cd:	01 c0                	add    %eax,%eax
801032cf:	89 c2                	mov    %eax,%edx
801032d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032d4:	83 e0 0f             	and    $0xf,%eax
801032d7:	01 d0                	add    %edx,%eax
801032d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801032dc:	8b 45 08             	mov    0x8(%ebp),%eax
801032df:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032e2:	89 10                	mov    %edx,(%eax)
801032e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032e7:	89 50 04             	mov    %edx,0x4(%eax)
801032ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032ed:	89 50 08             	mov    %edx,0x8(%eax)
801032f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032f3:	89 50 0c             	mov    %edx,0xc(%eax)
801032f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032f9:	89 50 10             	mov    %edx,0x10(%eax)
801032fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032ff:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103302:	8b 45 08             	mov    0x8(%ebp),%eax
80103305:	8b 40 14             	mov    0x14(%eax),%eax
80103308:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010330e:	8b 45 08             	mov    0x8(%ebp),%eax
80103311:	89 50 14             	mov    %edx,0x14(%eax)
}
80103314:	90                   	nop
80103315:	c9                   	leave  
80103316:	c3                   	ret    

80103317 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103317:	55                   	push   %ebp
80103318:	89 e5                	mov    %esp,%ebp
8010331a:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010331d:	83 ec 08             	sub    $0x8,%esp
80103320:	68 c5 89 10 80       	push   $0x801089c5
80103325:	68 20 37 11 80       	push   $0x80113720
8010332a:	e8 d0 1d 00 00       	call   801050ff <initlock>
8010332f:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103332:	83 ec 08             	sub    $0x8,%esp
80103335:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103338:	50                   	push   %eax
80103339:	ff 75 08             	pushl  0x8(%ebp)
8010333c:	e8 a3 e0 ff ff       	call   801013e4 <readsb>
80103341:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103344:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103347:	a3 54 37 11 80       	mov    %eax,0x80113754
  log.size = sb.nlog;
8010334c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010334f:	a3 58 37 11 80       	mov    %eax,0x80113758
  log.dev = dev;
80103354:	8b 45 08             	mov    0x8(%ebp),%eax
80103357:	a3 64 37 11 80       	mov    %eax,0x80113764
  recover_from_log();
8010335c:	e8 b2 01 00 00       	call   80103513 <recover_from_log>
}
80103361:	90                   	nop
80103362:	c9                   	leave  
80103363:	c3                   	ret    

80103364 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80103364:	55                   	push   %ebp
80103365:	89 e5                	mov    %esp,%ebp
80103367:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010336a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103371:	e9 95 00 00 00       	jmp    8010340b <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103376:	8b 15 54 37 11 80    	mov    0x80113754,%edx
8010337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010337f:	01 d0                	add    %edx,%eax
80103381:	83 c0 01             	add    $0x1,%eax
80103384:	89 c2                	mov    %eax,%edx
80103386:	a1 64 37 11 80       	mov    0x80113764,%eax
8010338b:	83 ec 08             	sub    $0x8,%esp
8010338e:	52                   	push   %edx
8010338f:	50                   	push   %eax
80103390:	e8 39 ce ff ff       	call   801001ce <bread>
80103395:	83 c4 10             	add    $0x10,%esp
80103398:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010339b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010339e:	83 c0 10             	add    $0x10,%eax
801033a1:	8b 04 85 2c 37 11 80 	mov    -0x7feec8d4(,%eax,4),%eax
801033a8:	89 c2                	mov    %eax,%edx
801033aa:	a1 64 37 11 80       	mov    0x80113764,%eax
801033af:	83 ec 08             	sub    $0x8,%esp
801033b2:	52                   	push   %edx
801033b3:	50                   	push   %eax
801033b4:	e8 15 ce ff ff       	call   801001ce <bread>
801033b9:	83 c4 10             	add    $0x10,%esp
801033bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033c2:	8d 50 5c             	lea    0x5c(%eax),%edx
801033c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033c8:	83 c0 5c             	add    $0x5c,%eax
801033cb:	83 ec 04             	sub    $0x4,%esp
801033ce:	68 00 02 00 00       	push   $0x200
801033d3:	52                   	push   %edx
801033d4:	50                   	push   %eax
801033d5:	e8 8d 20 00 00       	call   80105467 <memmove>
801033da:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801033dd:	83 ec 0c             	sub    $0xc,%esp
801033e0:	ff 75 ec             	pushl  -0x14(%ebp)
801033e3:	e8 1f ce ff ff       	call   80100207 <bwrite>
801033e8:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
801033eb:	83 ec 0c             	sub    $0xc,%esp
801033ee:	ff 75 f0             	pushl  -0x10(%ebp)
801033f1:	e8 5a ce ff ff       	call   80100250 <brelse>
801033f6:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801033f9:	83 ec 0c             	sub    $0xc,%esp
801033fc:	ff 75 ec             	pushl  -0x14(%ebp)
801033ff:	e8 4c ce ff ff       	call   80100250 <brelse>
80103404:	83 c4 10             	add    $0x10,%esp
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103407:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010340b:	a1 68 37 11 80       	mov    0x80113768,%eax
80103410:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103413:	0f 8f 5d ff ff ff    	jg     80103376 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80103419:	90                   	nop
8010341a:	c9                   	leave  
8010341b:	c3                   	ret    

8010341c <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010341c:	55                   	push   %ebp
8010341d:	89 e5                	mov    %esp,%ebp
8010341f:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103422:	a1 54 37 11 80       	mov    0x80113754,%eax
80103427:	89 c2                	mov    %eax,%edx
80103429:	a1 64 37 11 80       	mov    0x80113764,%eax
8010342e:	83 ec 08             	sub    $0x8,%esp
80103431:	52                   	push   %edx
80103432:	50                   	push   %eax
80103433:	e8 96 cd ff ff       	call   801001ce <bread>
80103438:	83 c4 10             	add    $0x10,%esp
8010343b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010343e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103441:	83 c0 5c             	add    $0x5c,%eax
80103444:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103447:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010344a:	8b 00                	mov    (%eax),%eax
8010344c:	a3 68 37 11 80       	mov    %eax,0x80113768
  for (i = 0; i < log.lh.n; i++) {
80103451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103458:	eb 1b                	jmp    80103475 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
8010345a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010345d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103460:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103464:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103467:	83 c2 10             	add    $0x10,%edx
8010346a:	89 04 95 2c 37 11 80 	mov    %eax,-0x7feec8d4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103471:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103475:	a1 68 37 11 80       	mov    0x80113768,%eax
8010347a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010347d:	7f db                	jg     8010345a <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010347f:	83 ec 0c             	sub    $0xc,%esp
80103482:	ff 75 f0             	pushl  -0x10(%ebp)
80103485:	e8 c6 cd ff ff       	call   80100250 <brelse>
8010348a:	83 c4 10             	add    $0x10,%esp
}
8010348d:	90                   	nop
8010348e:	c9                   	leave  
8010348f:	c3                   	ret    

80103490 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103496:	a1 54 37 11 80       	mov    0x80113754,%eax
8010349b:	89 c2                	mov    %eax,%edx
8010349d:	a1 64 37 11 80       	mov    0x80113764,%eax
801034a2:	83 ec 08             	sub    $0x8,%esp
801034a5:	52                   	push   %edx
801034a6:	50                   	push   %eax
801034a7:	e8 22 cd ff ff       	call   801001ce <bread>
801034ac:	83 c4 10             	add    $0x10,%esp
801034af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034b5:	83 c0 5c             	add    $0x5c,%eax
801034b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034bb:	8b 15 68 37 11 80    	mov    0x80113768,%edx
801034c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034c4:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034cd:	eb 1b                	jmp    801034ea <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801034cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034d2:	83 c0 10             	add    $0x10,%eax
801034d5:	8b 0c 85 2c 37 11 80 	mov    -0x7feec8d4(,%eax,4),%ecx
801034dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034e2:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034ea:	a1 68 37 11 80       	mov    0x80113768,%eax
801034ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034f2:	7f db                	jg     801034cf <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801034f4:	83 ec 0c             	sub    $0xc,%esp
801034f7:	ff 75 f0             	pushl  -0x10(%ebp)
801034fa:	e8 08 cd ff ff       	call   80100207 <bwrite>
801034ff:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103502:	83 ec 0c             	sub    $0xc,%esp
80103505:	ff 75 f0             	pushl  -0x10(%ebp)
80103508:	e8 43 cd ff ff       	call   80100250 <brelse>
8010350d:	83 c4 10             	add    $0x10,%esp
}
80103510:	90                   	nop
80103511:	c9                   	leave  
80103512:	c3                   	ret    

80103513 <recover_from_log>:

static void
recover_from_log(void)
{
80103513:	55                   	push   %ebp
80103514:	89 e5                	mov    %esp,%ebp
80103516:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103519:	e8 fe fe ff ff       	call   8010341c <read_head>
  install_trans(); // if committed, copy from log to disk
8010351e:	e8 41 fe ff ff       	call   80103364 <install_trans>
  log.lh.n = 0;
80103523:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
8010352a:	00 00 00 
  write_head(); // clear the log
8010352d:	e8 5e ff ff ff       	call   80103490 <write_head>
}
80103532:	90                   	nop
80103533:	c9                   	leave  
80103534:	c3                   	ret    

80103535 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103535:	55                   	push   %ebp
80103536:	89 e5                	mov    %esp,%ebp
80103538:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	68 20 37 11 80       	push   $0x80113720
80103543:	e8 d9 1b 00 00       	call   80105121 <acquire>
80103548:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010354b:	a1 60 37 11 80       	mov    0x80113760,%eax
80103550:	85 c0                	test   %eax,%eax
80103552:	74 17                	je     8010356b <begin_op+0x36>
      sleep(&log, &log.lock);
80103554:	83 ec 08             	sub    $0x8,%esp
80103557:	68 20 37 11 80       	push   $0x80113720
8010355c:	68 20 37 11 80       	push   $0x80113720
80103561:	e8 73 17 00 00       	call   80104cd9 <sleep>
80103566:	83 c4 10             	add    $0x10,%esp
80103569:	eb e0                	jmp    8010354b <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010356b:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
80103571:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80103576:	8d 50 01             	lea    0x1(%eax),%edx
80103579:	89 d0                	mov    %edx,%eax
8010357b:	c1 e0 02             	shl    $0x2,%eax
8010357e:	01 d0                	add    %edx,%eax
80103580:	01 c0                	add    %eax,%eax
80103582:	01 c8                	add    %ecx,%eax
80103584:	83 f8 1e             	cmp    $0x1e,%eax
80103587:	7e 17                	jle    801035a0 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103589:	83 ec 08             	sub    $0x8,%esp
8010358c:	68 20 37 11 80       	push   $0x80113720
80103591:	68 20 37 11 80       	push   $0x80113720
80103596:	e8 3e 17 00 00       	call   80104cd9 <sleep>
8010359b:	83 c4 10             	add    $0x10,%esp
8010359e:	eb ab                	jmp    8010354b <begin_op+0x16>
    } else {
      log.outstanding += 1;
801035a0:	a1 5c 37 11 80       	mov    0x8011375c,%eax
801035a5:	83 c0 01             	add    $0x1,%eax
801035a8:	a3 5c 37 11 80       	mov    %eax,0x8011375c
      release(&log.lock);
801035ad:	83 ec 0c             	sub    $0xc,%esp
801035b0:	68 20 37 11 80       	push   $0x80113720
801035b5:	e8 d5 1b 00 00       	call   8010518f <release>
801035ba:	83 c4 10             	add    $0x10,%esp
      break;
801035bd:	90                   	nop
    }
  }
}
801035be:	90                   	nop
801035bf:	c9                   	leave  
801035c0:	c3                   	ret    

801035c1 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035c1:	55                   	push   %ebp
801035c2:	89 e5                	mov    %esp,%ebp
801035c4:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801035c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801035ce:	83 ec 0c             	sub    $0xc,%esp
801035d1:	68 20 37 11 80       	push   $0x80113720
801035d6:	e8 46 1b 00 00       	call   80105121 <acquire>
801035db:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035de:	a1 5c 37 11 80       	mov    0x8011375c,%eax
801035e3:	83 e8 01             	sub    $0x1,%eax
801035e6:	a3 5c 37 11 80       	mov    %eax,0x8011375c
  if(log.committing)
801035eb:	a1 60 37 11 80       	mov    0x80113760,%eax
801035f0:	85 c0                	test   %eax,%eax
801035f2:	74 0d                	je     80103601 <end_op+0x40>
    panic("log.committing");
801035f4:	83 ec 0c             	sub    $0xc,%esp
801035f7:	68 c9 89 10 80       	push   $0x801089c9
801035fc:	e8 9f cf ff ff       	call   801005a0 <panic>
  if(log.outstanding == 0){
80103601:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80103606:	85 c0                	test   %eax,%eax
80103608:	75 13                	jne    8010361d <end_op+0x5c>
    do_commit = 1;
8010360a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103611:	c7 05 60 37 11 80 01 	movl   $0x1,0x80113760
80103618:	00 00 00 
8010361b:	eb 10                	jmp    8010362d <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
8010361d:	83 ec 0c             	sub    $0xc,%esp
80103620:	68 20 37 11 80       	push   $0x80113720
80103625:	e8 98 17 00 00       	call   80104dc2 <wakeup>
8010362a:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010362d:	83 ec 0c             	sub    $0xc,%esp
80103630:	68 20 37 11 80       	push   $0x80113720
80103635:	e8 55 1b 00 00       	call   8010518f <release>
8010363a:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010363d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103641:	74 3f                	je     80103682 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103643:	e8 f5 00 00 00       	call   8010373d <commit>
    acquire(&log.lock);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	68 20 37 11 80       	push   $0x80113720
80103650:	e8 cc 1a 00 00       	call   80105121 <acquire>
80103655:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103658:	c7 05 60 37 11 80 00 	movl   $0x0,0x80113760
8010365f:	00 00 00 
    wakeup(&log);
80103662:	83 ec 0c             	sub    $0xc,%esp
80103665:	68 20 37 11 80       	push   $0x80113720
8010366a:	e8 53 17 00 00       	call   80104dc2 <wakeup>
8010366f:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103672:	83 ec 0c             	sub    $0xc,%esp
80103675:	68 20 37 11 80       	push   $0x80113720
8010367a:	e8 10 1b 00 00       	call   8010518f <release>
8010367f:	83 c4 10             	add    $0x10,%esp
  }
}
80103682:	90                   	nop
80103683:	c9                   	leave  
80103684:	c3                   	ret    

80103685 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103685:	55                   	push   %ebp
80103686:	89 e5                	mov    %esp,%ebp
80103688:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010368b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103692:	e9 95 00 00 00       	jmp    8010372c <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103697:	8b 15 54 37 11 80    	mov    0x80113754,%edx
8010369d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036a0:	01 d0                	add    %edx,%eax
801036a2:	83 c0 01             	add    $0x1,%eax
801036a5:	89 c2                	mov    %eax,%edx
801036a7:	a1 64 37 11 80       	mov    0x80113764,%eax
801036ac:	83 ec 08             	sub    $0x8,%esp
801036af:	52                   	push   %edx
801036b0:	50                   	push   %eax
801036b1:	e8 18 cb ff ff       	call   801001ce <bread>
801036b6:	83 c4 10             	add    $0x10,%esp
801036b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036bf:	83 c0 10             	add    $0x10,%eax
801036c2:	8b 04 85 2c 37 11 80 	mov    -0x7feec8d4(,%eax,4),%eax
801036c9:	89 c2                	mov    %eax,%edx
801036cb:	a1 64 37 11 80       	mov    0x80113764,%eax
801036d0:	83 ec 08             	sub    $0x8,%esp
801036d3:	52                   	push   %edx
801036d4:	50                   	push   %eax
801036d5:	e8 f4 ca ff ff       	call   801001ce <bread>
801036da:	83 c4 10             	add    $0x10,%esp
801036dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801036e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036e3:	8d 50 5c             	lea    0x5c(%eax),%edx
801036e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036e9:	83 c0 5c             	add    $0x5c,%eax
801036ec:	83 ec 04             	sub    $0x4,%esp
801036ef:	68 00 02 00 00       	push   $0x200
801036f4:	52                   	push   %edx
801036f5:	50                   	push   %eax
801036f6:	e8 6c 1d 00 00       	call   80105467 <memmove>
801036fb:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801036fe:	83 ec 0c             	sub    $0xc,%esp
80103701:	ff 75 f0             	pushl  -0x10(%ebp)
80103704:	e8 fe ca ff ff       	call   80100207 <bwrite>
80103709:	83 c4 10             	add    $0x10,%esp
    brelse(from);
8010370c:	83 ec 0c             	sub    $0xc,%esp
8010370f:	ff 75 ec             	pushl  -0x14(%ebp)
80103712:	e8 39 cb ff ff       	call   80100250 <brelse>
80103717:	83 c4 10             	add    $0x10,%esp
    brelse(to);
8010371a:	83 ec 0c             	sub    $0xc,%esp
8010371d:	ff 75 f0             	pushl  -0x10(%ebp)
80103720:	e8 2b cb ff ff       	call   80100250 <brelse>
80103725:	83 c4 10             	add    $0x10,%esp
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103728:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010372c:	a1 68 37 11 80       	mov    0x80113768,%eax
80103731:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103734:	0f 8f 5d ff ff ff    	jg     80103697 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
8010373a:	90                   	nop
8010373b:	c9                   	leave  
8010373c:	c3                   	ret    

8010373d <commit>:

static void
commit()
{
8010373d:	55                   	push   %ebp
8010373e:	89 e5                	mov    %esp,%ebp
80103740:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103743:	a1 68 37 11 80       	mov    0x80113768,%eax
80103748:	85 c0                	test   %eax,%eax
8010374a:	7e 1e                	jle    8010376a <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010374c:	e8 34 ff ff ff       	call   80103685 <write_log>
    write_head();    // Write header to disk -- the real commit
80103751:	e8 3a fd ff ff       	call   80103490 <write_head>
    install_trans(); // Now install writes to home locations
80103756:	e8 09 fc ff ff       	call   80103364 <install_trans>
    log.lh.n = 0;
8010375b:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
80103762:	00 00 00 
    write_head();    // Erase the transaction from the log
80103765:	e8 26 fd ff ff       	call   80103490 <write_head>
  }
}
8010376a:	90                   	nop
8010376b:	c9                   	leave  
8010376c:	c3                   	ret    

8010376d <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010376d:	55                   	push   %ebp
8010376e:	89 e5                	mov    %esp,%ebp
80103770:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103773:	a1 68 37 11 80       	mov    0x80113768,%eax
80103778:	83 f8 1d             	cmp    $0x1d,%eax
8010377b:	7f 12                	jg     8010378f <log_write+0x22>
8010377d:	a1 68 37 11 80       	mov    0x80113768,%eax
80103782:	8b 15 58 37 11 80    	mov    0x80113758,%edx
80103788:	83 ea 01             	sub    $0x1,%edx
8010378b:	39 d0                	cmp    %edx,%eax
8010378d:	7c 0d                	jl     8010379c <log_write+0x2f>
    panic("too big a transaction");
8010378f:	83 ec 0c             	sub    $0xc,%esp
80103792:	68 d8 89 10 80       	push   $0x801089d8
80103797:	e8 04 ce ff ff       	call   801005a0 <panic>
  if (log.outstanding < 1)
8010379c:	a1 5c 37 11 80       	mov    0x8011375c,%eax
801037a1:	85 c0                	test   %eax,%eax
801037a3:	7f 0d                	jg     801037b2 <log_write+0x45>
    panic("log_write outside of trans");
801037a5:	83 ec 0c             	sub    $0xc,%esp
801037a8:	68 ee 89 10 80       	push   $0x801089ee
801037ad:	e8 ee cd ff ff       	call   801005a0 <panic>

  acquire(&log.lock);
801037b2:	83 ec 0c             	sub    $0xc,%esp
801037b5:	68 20 37 11 80       	push   $0x80113720
801037ba:	e8 62 19 00 00       	call   80105121 <acquire>
801037bf:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801037c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037c9:	eb 1d                	jmp    801037e8 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ce:	83 c0 10             	add    $0x10,%eax
801037d1:	8b 04 85 2c 37 11 80 	mov    -0x7feec8d4(,%eax,4),%eax
801037d8:	89 c2                	mov    %eax,%edx
801037da:	8b 45 08             	mov    0x8(%ebp),%eax
801037dd:	8b 40 08             	mov    0x8(%eax),%eax
801037e0:	39 c2                	cmp    %eax,%edx
801037e2:	74 10                	je     801037f4 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801037e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037e8:	a1 68 37 11 80       	mov    0x80113768,%eax
801037ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037f0:	7f d9                	jg     801037cb <log_write+0x5e>
801037f2:	eb 01                	jmp    801037f5 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
801037f4:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801037f5:	8b 45 08             	mov    0x8(%ebp),%eax
801037f8:	8b 40 08             	mov    0x8(%eax),%eax
801037fb:	89 c2                	mov    %eax,%edx
801037fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103800:	83 c0 10             	add    $0x10,%eax
80103803:	89 14 85 2c 37 11 80 	mov    %edx,-0x7feec8d4(,%eax,4)
  if (i == log.lh.n)
8010380a:	a1 68 37 11 80       	mov    0x80113768,%eax
8010380f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103812:	75 0d                	jne    80103821 <log_write+0xb4>
    log.lh.n++;
80103814:	a1 68 37 11 80       	mov    0x80113768,%eax
80103819:	83 c0 01             	add    $0x1,%eax
8010381c:	a3 68 37 11 80       	mov    %eax,0x80113768
  b->flags |= B_DIRTY; // prevent eviction
80103821:	8b 45 08             	mov    0x8(%ebp),%eax
80103824:	8b 00                	mov    (%eax),%eax
80103826:	83 c8 04             	or     $0x4,%eax
80103829:	89 c2                	mov    %eax,%edx
8010382b:	8b 45 08             	mov    0x8(%ebp),%eax
8010382e:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103830:	83 ec 0c             	sub    $0xc,%esp
80103833:	68 20 37 11 80       	push   $0x80113720
80103838:	e8 52 19 00 00       	call   8010518f <release>
8010383d:	83 c4 10             	add    $0x10,%esp
}
80103840:	90                   	nop
80103841:	c9                   	leave  
80103842:	c3                   	ret    

80103843 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103843:	55                   	push   %ebp
80103844:	89 e5                	mov    %esp,%ebp
80103846:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103849:	8b 55 08             	mov    0x8(%ebp),%edx
8010384c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010384f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103852:	f0 87 02             	lock xchg %eax,(%edx)
80103855:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103858:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010385b:	c9                   	leave  
8010385c:	c3                   	ret    

8010385d <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010385d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103861:	83 e4 f0             	and    $0xfffffff0,%esp
80103864:	ff 71 fc             	pushl  -0x4(%ecx)
80103867:	55                   	push   %ebp
80103868:	89 e5                	mov    %esp,%ebp
8010386a:	51                   	push   %ecx
8010386b:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010386e:	83 ec 08             	sub    $0x8,%esp
80103871:	68 00 00 40 80       	push   $0x80400000
80103876:	68 a0 69 11 80       	push   $0x801169a0
8010387b:	e8 e1 f2 ff ff       	call   80102b61 <kinit1>
80103880:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103883:	e8 33 45 00 00       	call   80107dbb <kvmalloc>
  mpinit();        // detect other processors
80103888:	e8 bf 03 00 00       	call   80103c4c <mpinit>
  lapicinit();     // interrupt controller
8010388d:	e8 3b f6 ff ff       	call   80102ecd <lapicinit>
  seginit();       // segment descriptors
80103892:	e8 0f 40 00 00       	call   801078a6 <seginit>
  picinit();       // disable pic
80103897:	e8 01 05 00 00       	call   80103d9d <picinit>
  ioapicinit();    // another interrupt controller
8010389c:	e8 dc f1 ff ff       	call   80102a7d <ioapicinit>
  consoleinit();   // console hardware
801038a1:	e8 a5 d2 ff ff       	call   80100b4b <consoleinit>
  uartinit();      // serial port
801038a6:	e8 94 33 00 00       	call   80106c3f <uartinit>
  pinit();         // process table
801038ab:	e8 26 09 00 00       	call   801041d6 <pinit>
  tvinit();        // trap vectors
801038b0:	e8 6c 2f 00 00       	call   80106821 <tvinit>
  binit();         // buffer cache
801038b5:	e8 7a c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801038ba:	e8 16 d7 ff ff       	call   80100fd5 <fileinit>
  ideinit();       // disk
801038bf:	e8 90 ed ff ff       	call   80102654 <ideinit>
  shmeminit();  // share memory
801038c4:	e8 ac 4c 00 00       	call   80108575 <shmeminit>
  startothers();   // start other processors
801038c9:	e8 80 00 00 00       	call   8010394e <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801038ce:	83 ec 08             	sub    $0x8,%esp
801038d1:	68 00 00 00 8e       	push   $0x8e000000
801038d6:	68 00 00 40 80       	push   $0x80400000
801038db:	e8 ba f2 ff ff       	call   80102b9a <kinit2>
801038e0:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801038e3:	e8 82 0b 00 00       	call   8010446a <userinit>
  mpmain();        // finish this processor's setup
801038e8:	e8 1a 00 00 00       	call   80103907 <mpmain>

801038ed <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801038ed:	55                   	push   %ebp
801038ee:	89 e5                	mov    %esp,%ebp
801038f0:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801038f3:	e8 db 44 00 00       	call   80107dd3 <switchkvm>
  seginit();
801038f8:	e8 a9 3f 00 00       	call   801078a6 <seginit>
  lapicinit();
801038fd:	e8 cb f5 ff ff       	call   80102ecd <lapicinit>
  mpmain();
80103902:	e8 00 00 00 00       	call   80103907 <mpmain>

80103907 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103907:	55                   	push   %ebp
80103908:	89 e5                	mov    %esp,%ebp
8010390a:	53                   	push   %ebx
8010390b:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
8010390e:	e8 8c 09 00 00       	call   8010429f <cpuid>
80103913:	89 c3                	mov    %eax,%ebx
80103915:	e8 85 09 00 00       	call   8010429f <cpuid>
8010391a:	83 ec 04             	sub    $0x4,%esp
8010391d:	53                   	push   %ebx
8010391e:	50                   	push   %eax
8010391f:	68 09 8a 10 80       	push   $0x80108a09
80103924:	e8 d7 ca ff ff       	call   80100400 <cprintf>
80103929:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
8010392c:	e8 66 30 00 00       	call   80106997 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103931:	e8 8a 09 00 00       	call   801042c0 <mycpu>
80103936:	05 a0 00 00 00       	add    $0xa0,%eax
8010393b:	83 ec 08             	sub    $0x8,%esp
8010393e:	6a 01                	push   $0x1
80103940:	50                   	push   %eax
80103941:	e8 fd fe ff ff       	call   80103843 <xchg>
80103946:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103949:	e8 95 11 00 00       	call   80104ae3 <scheduler>

8010394e <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010394e:	55                   	push   %ebp
8010394f:	89 e5                	mov    %esp,%ebp
80103951:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103954:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010395b:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103960:	83 ec 04             	sub    $0x4,%esp
80103963:	50                   	push   %eax
80103964:	68 0c b5 10 80       	push   $0x8010b50c
80103969:	ff 75 f0             	pushl  -0x10(%ebp)
8010396c:	e8 f6 1a 00 00       	call   80105467 <memmove>
80103971:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103974:	c7 45 f4 20 38 11 80 	movl   $0x80113820,-0xc(%ebp)
8010397b:	eb 79                	jmp    801039f6 <startothers+0xa8>
    if(c == mycpu())  // We've started already.
8010397d:	e8 3e 09 00 00       	call   801042c0 <mycpu>
80103982:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103985:	74 67                	je     801039ee <startothers+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103987:	e8 09 f3 ff ff       	call   80102c95 <kalloc>
8010398c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010398f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103992:	83 e8 04             	sub    $0x4,%eax
80103995:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103998:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010399e:	89 10                	mov    %edx,(%eax)
    *(void(**)(void))(code-8) = mpenter;
801039a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a3:	83 e8 08             	sub    $0x8,%eax
801039a6:	c7 00 ed 38 10 80    	movl   $0x801038ed,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801039ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039af:	83 e8 0c             	sub    $0xc,%eax
801039b2:	ba 00 a0 10 80       	mov    $0x8010a000,%edx
801039b7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801039bd:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
801039bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039c2:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801039c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039cb:	0f b6 00             	movzbl (%eax),%eax
801039ce:	0f b6 c0             	movzbl %al,%eax
801039d1:	83 ec 08             	sub    $0x8,%esp
801039d4:	52                   	push   %edx
801039d5:	50                   	push   %eax
801039d6:	e8 53 f6 ff ff       	call   8010302e <lapicstartap>
801039db:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039de:	90                   	nop
801039df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e2:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801039e8:	85 c0                	test   %eax,%eax
801039ea:	74 f3                	je     801039df <startothers+0x91>
801039ec:	eb 01                	jmp    801039ef <startothers+0xa1>
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == mycpu())  // We've started already.
      continue;
801039ee:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801039ef:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
801039f6:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
801039fb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103a01:	05 20 38 11 80       	add    $0x80113820,%eax
80103a06:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a09:	0f 87 6e ff ff ff    	ja     8010397d <startothers+0x2f>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103a0f:	90                   	nop
80103a10:	c9                   	leave  
80103a11:	c3                   	ret    

80103a12 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103a12:	55                   	push   %ebp
80103a13:	89 e5                	mov    %esp,%ebp
80103a15:	83 ec 14             	sub    $0x14,%esp
80103a18:	8b 45 08             	mov    0x8(%ebp),%eax
80103a1b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a1f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a23:	89 c2                	mov    %eax,%edx
80103a25:	ec                   	in     (%dx),%al
80103a26:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a29:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a2d:	c9                   	leave  
80103a2e:	c3                   	ret    

80103a2f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a2f:	55                   	push   %ebp
80103a30:	89 e5                	mov    %esp,%ebp
80103a32:	83 ec 08             	sub    $0x8,%esp
80103a35:	8b 55 08             	mov    0x8(%ebp),%edx
80103a38:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a3b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a3f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a42:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a46:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a4a:	ee                   	out    %al,(%dx)
}
80103a4b:	90                   	nop
80103a4c:	c9                   	leave  
80103a4d:	c3                   	ret    

80103a4e <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103a4e:	55                   	push   %ebp
80103a4f:	89 e5                	mov    %esp,%ebp
80103a51:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103a54:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a62:	eb 15                	jmp    80103a79 <sum+0x2b>
    sum += addr[i];
80103a64:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a67:	8b 45 08             	mov    0x8(%ebp),%eax
80103a6a:	01 d0                	add    %edx,%eax
80103a6c:	0f b6 00             	movzbl (%eax),%eax
80103a6f:	0f b6 c0             	movzbl %al,%eax
80103a72:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103a75:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a79:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a7c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a7f:	7c e3                	jl     80103a64 <sum+0x16>
    sum += addr[i];
  return sum;
80103a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a84:	c9                   	leave  
80103a85:	c3                   	ret    

80103a86 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a86:	55                   	push   %ebp
80103a87:	89 e5                	mov    %esp,%ebp
80103a89:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80103a8f:	05 00 00 00 80       	add    $0x80000000,%eax
80103a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a97:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a9d:	01 d0                	add    %edx,%eax
80103a9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aa8:	eb 36                	jmp    80103ae0 <mpsearch1+0x5a>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103aaa:	83 ec 04             	sub    $0x4,%esp
80103aad:	6a 04                	push   $0x4
80103aaf:	68 20 8a 10 80       	push   $0x80108a20
80103ab4:	ff 75 f4             	pushl  -0xc(%ebp)
80103ab7:	e8 53 19 00 00       	call   8010540f <memcmp>
80103abc:	83 c4 10             	add    $0x10,%esp
80103abf:	85 c0                	test   %eax,%eax
80103ac1:	75 19                	jne    80103adc <mpsearch1+0x56>
80103ac3:	83 ec 08             	sub    $0x8,%esp
80103ac6:	6a 10                	push   $0x10
80103ac8:	ff 75 f4             	pushl  -0xc(%ebp)
80103acb:	e8 7e ff ff ff       	call   80103a4e <sum>
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	84 c0                	test   %al,%al
80103ad5:	75 05                	jne    80103adc <mpsearch1+0x56>
      return (struct mp*)p;
80103ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ada:	eb 11                	jmp    80103aed <mpsearch1+0x67>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103adc:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ae6:	72 c2                	jb     80103aaa <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103ae8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103aed:	c9                   	leave  
80103aee:	c3                   	ret    

80103aef <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103aef:	55                   	push   %ebp
80103af0:	89 e5                	mov    %esp,%ebp
80103af2:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103af5:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aff:	83 c0 0f             	add    $0xf,%eax
80103b02:	0f b6 00             	movzbl (%eax),%eax
80103b05:	0f b6 c0             	movzbl %al,%eax
80103b08:	c1 e0 08             	shl    $0x8,%eax
80103b0b:	89 c2                	mov    %eax,%edx
80103b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b10:	83 c0 0e             	add    $0xe,%eax
80103b13:	0f b6 00             	movzbl (%eax),%eax
80103b16:	0f b6 c0             	movzbl %al,%eax
80103b19:	09 d0                	or     %edx,%eax
80103b1b:	c1 e0 04             	shl    $0x4,%eax
80103b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b25:	74 21                	je     80103b48 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b27:	83 ec 08             	sub    $0x8,%esp
80103b2a:	68 00 04 00 00       	push   $0x400
80103b2f:	ff 75 f0             	pushl  -0x10(%ebp)
80103b32:	e8 4f ff ff ff       	call   80103a86 <mpsearch1>
80103b37:	83 c4 10             	add    $0x10,%esp
80103b3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b41:	74 51                	je     80103b94 <mpsearch+0xa5>
      return mp;
80103b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b46:	eb 61                	jmp    80103ba9 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b4b:	83 c0 14             	add    $0x14,%eax
80103b4e:	0f b6 00             	movzbl (%eax),%eax
80103b51:	0f b6 c0             	movzbl %al,%eax
80103b54:	c1 e0 08             	shl    $0x8,%eax
80103b57:	89 c2                	mov    %eax,%edx
80103b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b5c:	83 c0 13             	add    $0x13,%eax
80103b5f:	0f b6 00             	movzbl (%eax),%eax
80103b62:	0f b6 c0             	movzbl %al,%eax
80103b65:	09 d0                	or     %edx,%eax
80103b67:	c1 e0 0a             	shl    $0xa,%eax
80103b6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b70:	2d 00 04 00 00       	sub    $0x400,%eax
80103b75:	83 ec 08             	sub    $0x8,%esp
80103b78:	68 00 04 00 00       	push   $0x400
80103b7d:	50                   	push   %eax
80103b7e:	e8 03 ff ff ff       	call   80103a86 <mpsearch1>
80103b83:	83 c4 10             	add    $0x10,%esp
80103b86:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b89:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b8d:	74 05                	je     80103b94 <mpsearch+0xa5>
      return mp;
80103b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b92:	eb 15                	jmp    80103ba9 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b94:	83 ec 08             	sub    $0x8,%esp
80103b97:	68 00 00 01 00       	push   $0x10000
80103b9c:	68 00 00 0f 00       	push   $0xf0000
80103ba1:	e8 e0 fe ff ff       	call   80103a86 <mpsearch1>
80103ba6:	83 c4 10             	add    $0x10,%esp
}
80103ba9:	c9                   	leave  
80103baa:	c3                   	ret    

80103bab <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103bab:	55                   	push   %ebp
80103bac:	89 e5                	mov    %esp,%ebp
80103bae:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bb1:	e8 39 ff ff ff       	call   80103aef <mpsearch>
80103bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bbd:	74 0a                	je     80103bc9 <mpconfig+0x1e>
80103bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bc2:	8b 40 04             	mov    0x4(%eax),%eax
80103bc5:	85 c0                	test   %eax,%eax
80103bc7:	75 07                	jne    80103bd0 <mpconfig+0x25>
    return 0;
80103bc9:	b8 00 00 00 00       	mov    $0x0,%eax
80103bce:	eb 7a                	jmp    80103c4a <mpconfig+0x9f>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd3:	8b 40 04             	mov    0x4(%eax),%eax
80103bd6:	05 00 00 00 80       	add    $0x80000000,%eax
80103bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103bde:	83 ec 04             	sub    $0x4,%esp
80103be1:	6a 04                	push   $0x4
80103be3:	68 25 8a 10 80       	push   $0x80108a25
80103be8:	ff 75 f0             	pushl  -0x10(%ebp)
80103beb:	e8 1f 18 00 00       	call   8010540f <memcmp>
80103bf0:	83 c4 10             	add    $0x10,%esp
80103bf3:	85 c0                	test   %eax,%eax
80103bf5:	74 07                	je     80103bfe <mpconfig+0x53>
    return 0;
80103bf7:	b8 00 00 00 00       	mov    $0x0,%eax
80103bfc:	eb 4c                	jmp    80103c4a <mpconfig+0x9f>
  if(conf->version != 1 && conf->version != 4)
80103bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c01:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c05:	3c 01                	cmp    $0x1,%al
80103c07:	74 12                	je     80103c1b <mpconfig+0x70>
80103c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c0c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c10:	3c 04                	cmp    $0x4,%al
80103c12:	74 07                	je     80103c1b <mpconfig+0x70>
    return 0;
80103c14:	b8 00 00 00 00       	mov    $0x0,%eax
80103c19:	eb 2f                	jmp    80103c4a <mpconfig+0x9f>
  if(sum((uchar*)conf, conf->length) != 0)
80103c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c1e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c22:	0f b7 c0             	movzwl %ax,%eax
80103c25:	83 ec 08             	sub    $0x8,%esp
80103c28:	50                   	push   %eax
80103c29:	ff 75 f0             	pushl  -0x10(%ebp)
80103c2c:	e8 1d fe ff ff       	call   80103a4e <sum>
80103c31:	83 c4 10             	add    $0x10,%esp
80103c34:	84 c0                	test   %al,%al
80103c36:	74 07                	je     80103c3f <mpconfig+0x94>
    return 0;
80103c38:	b8 00 00 00 00       	mov    $0x0,%eax
80103c3d:	eb 0b                	jmp    80103c4a <mpconfig+0x9f>
  *pmp = mp;
80103c3f:	8b 45 08             	mov    0x8(%ebp),%eax
80103c42:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c45:	89 10                	mov    %edx,(%eax)
  return conf;
80103c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c4a:	c9                   	leave  
80103c4b:	c3                   	ret    

80103c4c <mpinit>:

void
mpinit(void)
{
80103c4c:	55                   	push   %ebp
80103c4d:	89 e5                	mov    %esp,%ebp
80103c4f:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103c52:	83 ec 0c             	sub    $0xc,%esp
80103c55:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103c58:	50                   	push   %eax
80103c59:	e8 4d ff ff ff       	call   80103bab <mpconfig>
80103c5e:	83 c4 10             	add    $0x10,%esp
80103c61:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c68:	75 0d                	jne    80103c77 <mpinit+0x2b>
    panic("Expect to run on an SMP");
80103c6a:	83 ec 0c             	sub    $0xc,%esp
80103c6d:	68 2a 8a 10 80       	push   $0x80108a2a
80103c72:	e8 29 c9 ff ff       	call   801005a0 <panic>
  ismp = 1;
80103c77:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c81:	8b 40 24             	mov    0x24(%eax),%eax
80103c84:	a3 1c 37 11 80       	mov    %eax,0x8011371c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c8c:	83 c0 2c             	add    $0x2c,%eax
80103c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c95:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c99:	0f b7 d0             	movzwl %ax,%edx
80103c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c9f:	01 d0                	add    %edx,%eax
80103ca1:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103ca4:	eb 7b                	jmp    80103d21 <mpinit+0xd5>
    switch(*p){
80103ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca9:	0f b6 00             	movzbl (%eax),%eax
80103cac:	0f b6 c0             	movzbl %al,%eax
80103caf:	83 f8 04             	cmp    $0x4,%eax
80103cb2:	77 65                	ja     80103d19 <mpinit+0xcd>
80103cb4:	8b 04 85 64 8a 10 80 	mov    -0x7fef759c(,%eax,4),%eax
80103cbb:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103cc3:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
80103cc8:	83 f8 07             	cmp    $0x7,%eax
80103ccb:	7f 28                	jg     80103cf5 <mpinit+0xa9>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103ccd:	8b 15 a0 3d 11 80    	mov    0x80113da0,%edx
80103cd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cd6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cda:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103ce0:	81 c2 20 38 11 80    	add    $0x80113820,%edx
80103ce6:	88 02                	mov    %al,(%edx)
        ncpu++;
80103ce8:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
80103ced:	83 c0 01             	add    $0x1,%eax
80103cf0:	a3 a0 3d 11 80       	mov    %eax,0x80113da0
      }
      p += sizeof(struct mpproc);
80103cf5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103cf9:	eb 26                	jmp    80103d21 <mpinit+0xd5>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103d01:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d04:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d08:	a2 00 38 11 80       	mov    %al,0x80113800
      p += sizeof(struct mpioapic);
80103d0d:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d11:	eb 0e                	jmp    80103d21 <mpinit+0xd5>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d13:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d17:	eb 08                	jmp    80103d21 <mpinit+0xd5>
    default:
      ismp = 0;
80103d19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103d20:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d24:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103d27:	0f 82 79 ff ff ff    	jb     80103ca6 <mpinit+0x5a>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103d2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d31:	75 0d                	jne    80103d40 <mpinit+0xf4>
    panic("Didn't find a suitable machine");
80103d33:	83 ec 0c             	sub    $0xc,%esp
80103d36:	68 44 8a 10 80       	push   $0x80108a44
80103d3b:	e8 60 c8 ff ff       	call   801005a0 <panic>

  if(mp->imcrp){
80103d40:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d43:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d47:	84 c0                	test   %al,%al
80103d49:	74 30                	je     80103d7b <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d4b:	83 ec 08             	sub    $0x8,%esp
80103d4e:	6a 70                	push   $0x70
80103d50:	6a 22                	push   $0x22
80103d52:	e8 d8 fc ff ff       	call   80103a2f <outb>
80103d57:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	6a 23                	push   $0x23
80103d5f:	e8 ae fc ff ff       	call   80103a12 <inb>
80103d64:	83 c4 10             	add    $0x10,%esp
80103d67:	83 c8 01             	or     $0x1,%eax
80103d6a:	0f b6 c0             	movzbl %al,%eax
80103d6d:	83 ec 08             	sub    $0x8,%esp
80103d70:	50                   	push   %eax
80103d71:	6a 23                	push   $0x23
80103d73:	e8 b7 fc ff ff       	call   80103a2f <outb>
80103d78:	83 c4 10             	add    $0x10,%esp
  }
}
80103d7b:	90                   	nop
80103d7c:	c9                   	leave  
80103d7d:	c3                   	ret    

80103d7e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d7e:	55                   	push   %ebp
80103d7f:	89 e5                	mov    %esp,%ebp
80103d81:	83 ec 08             	sub    $0x8,%esp
80103d84:	8b 55 08             	mov    0x8(%ebp),%edx
80103d87:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d8a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103d8e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d91:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103d95:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103d99:	ee                   	out    %al,(%dx)
}
80103d9a:	90                   	nop
80103d9b:	c9                   	leave  
80103d9c:	c3                   	ret    

80103d9d <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103d9d:	55                   	push   %ebp
80103d9e:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103da0:	68 ff 00 00 00       	push   $0xff
80103da5:	6a 21                	push   $0x21
80103da7:	e8 d2 ff ff ff       	call   80103d7e <outb>
80103dac:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103daf:	68 ff 00 00 00       	push   $0xff
80103db4:	68 a1 00 00 00       	push   $0xa1
80103db9:	e8 c0 ff ff ff       	call   80103d7e <outb>
80103dbe:	83 c4 08             	add    $0x8,%esp
}
80103dc1:	90                   	nop
80103dc2:	c9                   	leave  
80103dc3:	c3                   	ret    

80103dc4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103dc4:	55                   	push   %ebp
80103dc5:	89 e5                	mov    %esp,%ebp
80103dc7:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103dca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103dda:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ddd:	8b 10                	mov    (%eax),%edx
80103ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80103de2:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103de4:	e8 0a d2 ff ff       	call   80100ff3 <filealloc>
80103de9:	89 c2                	mov    %eax,%edx
80103deb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dee:	89 10                	mov    %edx,(%eax)
80103df0:	8b 45 08             	mov    0x8(%ebp),%eax
80103df3:	8b 00                	mov    (%eax),%eax
80103df5:	85 c0                	test   %eax,%eax
80103df7:	0f 84 cb 00 00 00    	je     80103ec8 <pipealloc+0x104>
80103dfd:	e8 f1 d1 ff ff       	call   80100ff3 <filealloc>
80103e02:	89 c2                	mov    %eax,%edx
80103e04:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e07:	89 10                	mov    %edx,(%eax)
80103e09:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e0c:	8b 00                	mov    (%eax),%eax
80103e0e:	85 c0                	test   %eax,%eax
80103e10:	0f 84 b2 00 00 00    	je     80103ec8 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103e16:	e8 7a ee ff ff       	call   80102c95 <kalloc>
80103e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e22:	0f 84 9f 00 00 00    	je     80103ec7 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80103e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e2b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103e32:	00 00 00 
  p->writeopen = 1;
80103e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e38:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103e3f:	00 00 00 
  p->nwrite = 0;
80103e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e45:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103e4c:	00 00 00 
  p->nread = 0;
80103e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e52:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103e59:	00 00 00 
  initlock(&p->lock, "pipe");
80103e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e5f:	83 ec 08             	sub    $0x8,%esp
80103e62:	68 78 8a 10 80       	push   $0x80108a78
80103e67:	50                   	push   %eax
80103e68:	e8 92 12 00 00       	call   801050ff <initlock>
80103e6d:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103e70:	8b 45 08             	mov    0x8(%ebp),%eax
80103e73:	8b 00                	mov    (%eax),%eax
80103e75:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7e:	8b 00                	mov    (%eax),%eax
80103e80:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103e84:	8b 45 08             	mov    0x8(%ebp),%eax
80103e87:	8b 00                	mov    (%eax),%eax
80103e89:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103e8d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e90:	8b 00                	mov    (%eax),%eax
80103e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e95:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103e98:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e9b:	8b 00                	mov    (%eax),%eax
80103e9d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ea6:	8b 00                	mov    (%eax),%eax
80103ea8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103eac:	8b 45 0c             	mov    0xc(%ebp),%eax
80103eaf:	8b 00                	mov    (%eax),%eax
80103eb1:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103eb8:	8b 00                	mov    (%eax),%eax
80103eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ebd:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103ec0:	b8 00 00 00 00       	mov    $0x0,%eax
80103ec5:	eb 4e                	jmp    80103f15 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103ec7:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103ec8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ecc:	74 0e                	je     80103edc <pipealloc+0x118>
    kfree((char*)p);
80103ece:	83 ec 0c             	sub    $0xc,%esp
80103ed1:	ff 75 f4             	pushl  -0xc(%ebp)
80103ed4:	e8 22 ed ff ff       	call   80102bfb <kfree>
80103ed9:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103edc:	8b 45 08             	mov    0x8(%ebp),%eax
80103edf:	8b 00                	mov    (%eax),%eax
80103ee1:	85 c0                	test   %eax,%eax
80103ee3:	74 11                	je     80103ef6 <pipealloc+0x132>
    fileclose(*f0);
80103ee5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee8:	8b 00                	mov    (%eax),%eax
80103eea:	83 ec 0c             	sub    $0xc,%esp
80103eed:	50                   	push   %eax
80103eee:	e8 be d1 ff ff       	call   801010b1 <fileclose>
80103ef3:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ef9:	8b 00                	mov    (%eax),%eax
80103efb:	85 c0                	test   %eax,%eax
80103efd:	74 11                	je     80103f10 <pipealloc+0x14c>
    fileclose(*f1);
80103eff:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f02:	8b 00                	mov    (%eax),%eax
80103f04:	83 ec 0c             	sub    $0xc,%esp
80103f07:	50                   	push   %eax
80103f08:	e8 a4 d1 ff ff       	call   801010b1 <fileclose>
80103f0d:	83 c4 10             	add    $0x10,%esp
  return -1;
80103f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f15:	c9                   	leave  
80103f16:	c3                   	ret    

80103f17 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103f17:	55                   	push   %ebp
80103f18:	89 e5                	mov    %esp,%ebp
80103f1a:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80103f1d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f20:	83 ec 0c             	sub    $0xc,%esp
80103f23:	50                   	push   %eax
80103f24:	e8 f8 11 00 00       	call   80105121 <acquire>
80103f29:	83 c4 10             	add    $0x10,%esp
  if(writable){
80103f2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103f30:	74 23                	je     80103f55 <pipeclose+0x3e>
    p->writeopen = 0;
80103f32:	8b 45 08             	mov    0x8(%ebp),%eax
80103f35:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103f3c:	00 00 00 
    wakeup(&p->nread);
80103f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f42:	05 34 02 00 00       	add    $0x234,%eax
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	50                   	push   %eax
80103f4b:	e8 72 0e 00 00       	call   80104dc2 <wakeup>
80103f50:	83 c4 10             	add    $0x10,%esp
80103f53:	eb 21                	jmp    80103f76 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80103f55:	8b 45 08             	mov    0x8(%ebp),%eax
80103f58:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103f5f:	00 00 00 
    wakeup(&p->nwrite);
80103f62:	8b 45 08             	mov    0x8(%ebp),%eax
80103f65:	05 38 02 00 00       	add    $0x238,%eax
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	50                   	push   %eax
80103f6e:	e8 4f 0e 00 00       	call   80104dc2 <wakeup>
80103f73:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103f76:	8b 45 08             	mov    0x8(%ebp),%eax
80103f79:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103f7f:	85 c0                	test   %eax,%eax
80103f81:	75 2c                	jne    80103faf <pipeclose+0x98>
80103f83:	8b 45 08             	mov    0x8(%ebp),%eax
80103f86:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f8c:	85 c0                	test   %eax,%eax
80103f8e:	75 1f                	jne    80103faf <pipeclose+0x98>
    release(&p->lock);
80103f90:	8b 45 08             	mov    0x8(%ebp),%eax
80103f93:	83 ec 0c             	sub    $0xc,%esp
80103f96:	50                   	push   %eax
80103f97:	e8 f3 11 00 00       	call   8010518f <release>
80103f9c:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103f9f:	83 ec 0c             	sub    $0xc,%esp
80103fa2:	ff 75 08             	pushl  0x8(%ebp)
80103fa5:	e8 51 ec ff ff       	call   80102bfb <kfree>
80103faa:	83 c4 10             	add    $0x10,%esp
80103fad:	eb 0f                	jmp    80103fbe <pipeclose+0xa7>
  } else
    release(&p->lock);
80103faf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb2:	83 ec 0c             	sub    $0xc,%esp
80103fb5:	50                   	push   %eax
80103fb6:	e8 d4 11 00 00       	call   8010518f <release>
80103fbb:	83 c4 10             	add    $0x10,%esp
}
80103fbe:	90                   	nop
80103fbf:	c9                   	leave  
80103fc0:	c3                   	ret    

80103fc1 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103fc1:	55                   	push   %ebp
80103fc2:	89 e5                	mov    %esp,%ebp
80103fc4:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80103fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	50                   	push   %eax
80103fce:	e8 4e 11 00 00       	call   80105121 <acquire>
80103fd3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103fd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103fdd:	e9 ac 00 00 00       	jmp    8010408e <pipewrite+0xcd>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
80103fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe5:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103feb:	85 c0                	test   %eax,%eax
80103fed:	74 0c                	je     80103ffb <pipewrite+0x3a>
80103fef:	e8 44 03 00 00       	call   80104338 <myproc>
80103ff4:	8b 40 24             	mov    0x24(%eax),%eax
80103ff7:	85 c0                	test   %eax,%eax
80103ff9:	74 19                	je     80104014 <pipewrite+0x53>
        release(&p->lock);
80103ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffe:	83 ec 0c             	sub    $0xc,%esp
80104001:	50                   	push   %eax
80104002:	e8 88 11 00 00       	call   8010518f <release>
80104007:	83 c4 10             	add    $0x10,%esp
        return -1;
8010400a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010400f:	e9 a8 00 00 00       	jmp    801040bc <pipewrite+0xfb>
      }
      wakeup(&p->nread);
80104014:	8b 45 08             	mov    0x8(%ebp),%eax
80104017:	05 34 02 00 00       	add    $0x234,%eax
8010401c:	83 ec 0c             	sub    $0xc,%esp
8010401f:	50                   	push   %eax
80104020:	e8 9d 0d 00 00       	call   80104dc2 <wakeup>
80104025:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104028:	8b 45 08             	mov    0x8(%ebp),%eax
8010402b:	8b 55 08             	mov    0x8(%ebp),%edx
8010402e:	81 c2 38 02 00 00    	add    $0x238,%edx
80104034:	83 ec 08             	sub    $0x8,%esp
80104037:	50                   	push   %eax
80104038:	52                   	push   %edx
80104039:	e8 9b 0c 00 00       	call   80104cd9 <sleep>
8010403e:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104041:	8b 45 08             	mov    0x8(%ebp),%eax
80104044:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010404a:	8b 45 08             	mov    0x8(%ebp),%eax
8010404d:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104053:	05 00 02 00 00       	add    $0x200,%eax
80104058:	39 c2                	cmp    %eax,%edx
8010405a:	74 86                	je     80103fe2 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010405c:	8b 45 08             	mov    0x8(%ebp),%eax
8010405f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104065:	8d 48 01             	lea    0x1(%eax),%ecx
80104068:	8b 55 08             	mov    0x8(%ebp),%edx
8010406b:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104071:	25 ff 01 00 00       	and    $0x1ff,%eax
80104076:	89 c1                	mov    %eax,%ecx
80104078:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010407b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010407e:	01 d0                	add    %edx,%eax
80104080:	0f b6 10             	movzbl (%eax),%edx
80104083:	8b 45 08             	mov    0x8(%ebp),%eax
80104086:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010408a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010408e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104091:	3b 45 10             	cmp    0x10(%ebp),%eax
80104094:	7c ab                	jl     80104041 <pipewrite+0x80>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104096:	8b 45 08             	mov    0x8(%ebp),%eax
80104099:	05 34 02 00 00       	add    $0x234,%eax
8010409e:	83 ec 0c             	sub    $0xc,%esp
801040a1:	50                   	push   %eax
801040a2:	e8 1b 0d 00 00       	call   80104dc2 <wakeup>
801040a7:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801040aa:	8b 45 08             	mov    0x8(%ebp),%eax
801040ad:	83 ec 0c             	sub    $0xc,%esp
801040b0:	50                   	push   %eax
801040b1:	e8 d9 10 00 00       	call   8010518f <release>
801040b6:	83 c4 10             	add    $0x10,%esp
  return n;
801040b9:	8b 45 10             	mov    0x10(%ebp),%eax
}
801040bc:	c9                   	leave  
801040bd:	c3                   	ret    

801040be <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801040be:	55                   	push   %ebp
801040bf:	89 e5                	mov    %esp,%ebp
801040c1:	53                   	push   %ebx
801040c2:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801040c5:	8b 45 08             	mov    0x8(%ebp),%eax
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	50                   	push   %eax
801040cc:	e8 50 10 00 00       	call   80105121 <acquire>
801040d1:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801040d4:	eb 3e                	jmp    80104114 <piperead+0x56>
    if(myproc()->killed){
801040d6:	e8 5d 02 00 00       	call   80104338 <myproc>
801040db:	8b 40 24             	mov    0x24(%eax),%eax
801040de:	85 c0                	test   %eax,%eax
801040e0:	74 19                	je     801040fb <piperead+0x3d>
      release(&p->lock);
801040e2:	8b 45 08             	mov    0x8(%ebp),%eax
801040e5:	83 ec 0c             	sub    $0xc,%esp
801040e8:	50                   	push   %eax
801040e9:	e8 a1 10 00 00       	call   8010518f <release>
801040ee:	83 c4 10             	add    $0x10,%esp
      return -1;
801040f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040f6:	e9 bf 00 00 00       	jmp    801041ba <piperead+0xfc>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801040fb:	8b 45 08             	mov    0x8(%ebp),%eax
801040fe:	8b 55 08             	mov    0x8(%ebp),%edx
80104101:	81 c2 34 02 00 00    	add    $0x234,%edx
80104107:	83 ec 08             	sub    $0x8,%esp
8010410a:	50                   	push   %eax
8010410b:	52                   	push   %edx
8010410c:	e8 c8 0b 00 00       	call   80104cd9 <sleep>
80104111:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104114:	8b 45 08             	mov    0x8(%ebp),%eax
80104117:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010411d:	8b 45 08             	mov    0x8(%ebp),%eax
80104120:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104126:	39 c2                	cmp    %eax,%edx
80104128:	75 0d                	jne    80104137 <piperead+0x79>
8010412a:	8b 45 08             	mov    0x8(%ebp),%eax
8010412d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104133:	85 c0                	test   %eax,%eax
80104135:	75 9f                	jne    801040d6 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010413e:	eb 49                	jmp    80104189 <piperead+0xcb>
    if(p->nread == p->nwrite)
80104140:	8b 45 08             	mov    0x8(%ebp),%eax
80104143:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104149:	8b 45 08             	mov    0x8(%ebp),%eax
8010414c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104152:	39 c2                	cmp    %eax,%edx
80104154:	74 3d                	je     80104193 <piperead+0xd5>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104156:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104159:	8b 45 0c             	mov    0xc(%ebp),%eax
8010415c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010415f:	8b 45 08             	mov    0x8(%ebp),%eax
80104162:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104168:	8d 48 01             	lea    0x1(%eax),%ecx
8010416b:	8b 55 08             	mov    0x8(%ebp),%edx
8010416e:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104174:	25 ff 01 00 00       	and    $0x1ff,%eax
80104179:	89 c2                	mov    %eax,%edx
8010417b:	8b 45 08             	mov    0x8(%ebp),%eax
8010417e:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104183:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104185:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104189:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010418f:	7c af                	jl     80104140 <piperead+0x82>
80104191:	eb 01                	jmp    80104194 <piperead+0xd6>
    if(p->nread == p->nwrite)
      break;
80104193:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104194:	8b 45 08             	mov    0x8(%ebp),%eax
80104197:	05 38 02 00 00       	add    $0x238,%eax
8010419c:	83 ec 0c             	sub    $0xc,%esp
8010419f:	50                   	push   %eax
801041a0:	e8 1d 0c 00 00       	call   80104dc2 <wakeup>
801041a5:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801041a8:	8b 45 08             	mov    0x8(%ebp),%eax
801041ab:	83 ec 0c             	sub    $0xc,%esp
801041ae:	50                   	push   %eax
801041af:	e8 db 0f 00 00       	call   8010518f <release>
801041b4:	83 c4 10             	add    $0x10,%esp
  return i;
801041b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801041ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041bd:	c9                   	leave  
801041be:	c3                   	ret    

801041bf <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801041bf:	55                   	push   %ebp
801041c0:	89 e5                	mov    %esp,%ebp
801041c2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041c5:	9c                   	pushf  
801041c6:	58                   	pop    %eax
801041c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801041ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801041cd:	c9                   	leave  
801041ce:	c3                   	ret    

801041cf <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801041cf:	55                   	push   %ebp
801041d0:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801041d2:	fb                   	sti    
}
801041d3:	90                   	nop
801041d4:	5d                   	pop    %ebp
801041d5:	c3                   	ret    

801041d6 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801041d6:	55                   	push   %ebp
801041d7:	89 e5                	mov    %esp,%ebp
801041d9:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801041dc:	83 ec 08             	sub    $0x8,%esp
801041df:	68 80 8a 10 80       	push   $0x80108a80
801041e4:	68 c0 3d 11 80       	push   $0x80113dc0
801041e9:	e8 11 0f 00 00       	call   801050ff <initlock>
801041ee:	83 c4 10             	add    $0x10,%esp
}
801041f1:	90                   	nop
801041f2:	c9                   	leave  
801041f3:	c3                   	ret    

801041f4 <getprocsinfo>:

// New function: getprocsinfo
int
getprocsinfo(struct procinfo* info){
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	83 ec 18             	sub    $0x18,%esp
    struct procinfo *in;
    struct proc *p;
    int proc_count = 0;
801041fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    in = info;
80104201:	8b 45 08             	mov    0x8(%ebp),%eax
80104204:	89 45 f4             	mov    %eax,-0xc(%ebp)
    acquire(&ptable.lock);
80104207:	83 ec 0c             	sub    $0xc,%esp
8010420a:	68 c0 3d 11 80       	push   $0x80113dc0
8010420f:	e8 0d 0f 00 00       	call   80105121 <acquire>
80104214:	83 c4 10             	add    $0x10,%esp
    for( p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104217:	c7 45 f0 f4 3d 11 80 	movl   $0x80113df4,-0x10(%ebp)
8010421e:	eb 61                	jmp    80104281 <getprocsinfo+0x8d>
    {
        if(p->state == EMBRYO || p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING)
80104220:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104223:	8b 40 0c             	mov    0xc(%eax),%eax
80104226:	83 f8 01             	cmp    $0x1,%eax
80104229:	74 21                	je     8010424c <getprocsinfo+0x58>
8010422b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010422e:	8b 40 0c             	mov    0xc(%eax),%eax
80104231:	83 f8 03             	cmp    $0x3,%eax
80104234:	74 16                	je     8010424c <getprocsinfo+0x58>
80104236:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104239:	8b 40 0c             	mov    0xc(%eax),%eax
8010423c:	83 f8 04             	cmp    $0x4,%eax
8010423f:	74 0b                	je     8010424c <getprocsinfo+0x58>
80104241:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104244:	8b 40 0c             	mov    0xc(%eax),%eax
80104247:	83 f8 02             	cmp    $0x2,%eax
8010424a:	75 2e                	jne    8010427a <getprocsinfo+0x86>
        {
            in->pid = p->pid;
8010424c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010424f:	8b 50 10             	mov    0x10(%eax),%edx
80104252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104255:	89 10                	mov    %edx,(%eax)
            safestrcpy(in->pname,p->name,16);
80104257:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010425a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010425d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104260:	83 c0 04             	add    $0x4,%eax
80104263:	83 ec 04             	sub    $0x4,%esp
80104266:	6a 10                	push   $0x10
80104268:	52                   	push   %edx
80104269:	50                   	push   %eax
8010426a:	e8 3c 13 00 00       	call   801055ab <safestrcpy>
8010426f:	83 c4 10             	add    $0x10,%esp
            in++;
80104272:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
            proc_count++;
80104276:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    struct procinfo *in;
    struct proc *p;
    int proc_count = 0;
    in = info;
    acquire(&ptable.lock);
    for( p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010427a:	81 45 f0 8c 00 00 00 	addl   $0x8c,-0x10(%ebp)
80104281:	81 7d f0 f4 60 11 80 	cmpl   $0x801160f4,-0x10(%ebp)
80104288:	72 96                	jb     80104220 <getprocsinfo+0x2c>
            safestrcpy(in->pname,p->name,16);
            in++;
            proc_count++;
        }
    }
    release(&ptable.lock);
8010428a:	83 ec 0c             	sub    $0xc,%esp
8010428d:	68 c0 3d 11 80       	push   $0x80113dc0
80104292:	e8 f8 0e 00 00       	call   8010518f <release>
80104297:	83 c4 10             	add    $0x10,%esp
    return proc_count;
8010429a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010429d:	c9                   	leave  
8010429e:	c3                   	ret    

8010429f <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
8010429f:	55                   	push   %ebp
801042a0:	89 e5                	mov    %esp,%ebp
801042a2:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801042a5:	e8 16 00 00 00       	call   801042c0 <mycpu>
801042aa:	89 c2                	mov    %eax,%edx
801042ac:	b8 20 38 11 80       	mov    $0x80113820,%eax
801042b1:	29 c2                	sub    %eax,%edx
801042b3:	89 d0                	mov    %edx,%eax
801042b5:	c1 f8 04             	sar    $0x4,%eax
801042b8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801042be:	c9                   	leave  
801042bf:	c3                   	ret    

801042c0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
801042c6:	e8 f4 fe ff ff       	call   801041bf <readeflags>
801042cb:	25 00 02 00 00       	and    $0x200,%eax
801042d0:	85 c0                	test   %eax,%eax
801042d2:	74 0d                	je     801042e1 <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	68 88 8a 10 80       	push   $0x80108a88
801042dc:	e8 bf c2 ff ff       	call   801005a0 <panic>
  
  apicid = lapicid();
801042e1:	e8 05 ed ff ff       	call   80102feb <lapicid>
801042e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801042e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042f0:	eb 2d                	jmp    8010431f <mycpu+0x5f>
    if (cpus[i].apicid == apicid)
801042f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f5:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801042fb:	05 20 38 11 80       	add    $0x80113820,%eax
80104300:	0f b6 00             	movzbl (%eax),%eax
80104303:	0f b6 c0             	movzbl %al,%eax
80104306:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104309:	75 10                	jne    8010431b <mycpu+0x5b>
      return &cpus[i];
8010430b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010430e:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104314:	05 20 38 11 80       	add    $0x80113820,%eax
80104319:	eb 1b                	jmp    80104336 <mycpu+0x76>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010431b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010431f:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
80104324:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104327:	7c c9                	jl     801042f2 <mycpu+0x32>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80104329:	83 ec 0c             	sub    $0xc,%esp
8010432c:	68 ae 8a 10 80       	push   $0x80108aae
80104331:	e8 6a c2 ff ff       	call   801005a0 <panic>
}
80104336:	c9                   	leave  
80104337:	c3                   	ret    

80104338 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80104338:	55                   	push   %ebp
80104339:	89 e5                	mov    %esp,%ebp
8010433b:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
8010433e:	e8 59 0f 00 00       	call   8010529c <pushcli>
  c = mycpu();
80104343:	e8 78 ff ff ff       	call   801042c0 <mycpu>
80104348:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
8010434b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104354:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80104357:	e8 8e 0f 00 00       	call   801052ea <popcli>
  return p;
8010435c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010435f:	c9                   	leave  
80104360:	c3                   	ret    

80104361 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104361:	55                   	push   %ebp
80104362:	89 e5                	mov    %esp,%ebp
80104364:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104367:	83 ec 0c             	sub    $0xc,%esp
8010436a:	68 c0 3d 11 80       	push   $0x80113dc0
8010436f:	e8 ad 0d 00 00       	call   80105121 <acquire>
80104374:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104377:	c7 45 f4 f4 3d 11 80 	movl   $0x80113df4,-0xc(%ebp)
8010437e:	eb 11                	jmp    80104391 <allocproc+0x30>
    if(p->state == UNUSED)
80104380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104383:	8b 40 0c             	mov    0xc(%eax),%eax
80104386:	85 c0                	test   %eax,%eax
80104388:	74 2a                	je     801043b4 <allocproc+0x53>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010438a:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104391:	81 7d f4 f4 60 11 80 	cmpl   $0x801160f4,-0xc(%ebp)
80104398:	72 e6                	jb     80104380 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
8010439a:	83 ec 0c             	sub    $0xc,%esp
8010439d:	68 c0 3d 11 80       	push   $0x80113dc0
801043a2:	e8 e8 0d 00 00       	call   8010518f <release>
801043a7:	83 c4 10             	add    $0x10,%esp
  return 0;
801043aa:	b8 00 00 00 00       	mov    $0x0,%eax
801043af:	e9 b4 00 00 00       	jmp    80104468 <allocproc+0x107>

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
801043b4:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801043b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b8:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801043bf:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801043c4:	8d 50 01             	lea    0x1(%eax),%edx
801043c7:	89 15 00 b0 10 80    	mov    %edx,0x8010b000
801043cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043d0:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	68 c0 3d 11 80       	push   $0x80113dc0
801043db:	e8 af 0d 00 00       	call   8010518f <release>
801043e0:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801043e3:	e8 ad e8 ff ff       	call   80102c95 <kalloc>
801043e8:	89 c2                	mov    %eax,%edx
801043ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ed:	89 50 08             	mov    %edx,0x8(%eax)
801043f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f3:	8b 40 08             	mov    0x8(%eax),%eax
801043f6:	85 c0                	test   %eax,%eax
801043f8:	75 11                	jne    8010440b <allocproc+0xaa>
    p->state = UNUSED;
801043fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104404:	b8 00 00 00 00       	mov    $0x0,%eax
80104409:	eb 5d                	jmp    80104468 <allocproc+0x107>
  }
  sp = p->kstack + KSTACKSIZE;
8010440b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440e:	8b 40 08             	mov    0x8(%eax),%eax
80104411:	05 00 10 00 00       	add    $0x1000,%eax
80104416:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104419:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010441d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104420:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104423:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104426:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010442a:	ba db 67 10 80       	mov    $0x801067db,%edx
8010442f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104432:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104434:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010443b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010443e:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104441:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104444:	8b 40 1c             	mov    0x1c(%eax),%eax
80104447:	83 ec 04             	sub    $0x4,%esp
8010444a:	6a 14                	push   $0x14
8010444c:	6a 00                	push   $0x0
8010444e:	50                   	push   %eax
8010444f:	e8 54 0f 00 00       	call   801053a8 <memset>
80104454:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010445a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010445d:	ba 93 4c 10 80       	mov    $0x80104c93,%edx
80104462:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104465:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104468:	c9                   	leave  
80104469:	c3                   	ret    

8010446a <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010446a:	55                   	push   %ebp
8010446b:	89 e5                	mov    %esp,%ebp
8010446d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104470:	e8 ec fe ff ff       	call   80104361 <allocproc>
80104475:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80104478:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447b:	a3 40 b6 10 80       	mov    %eax,0x8010b640
  if((p->pgdir = setupkvm()) == 0)
80104480:	e8 9d 38 00 00       	call   80107d22 <setupkvm>
80104485:	89 c2                	mov    %eax,%edx
80104487:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010448a:	89 50 04             	mov    %edx,0x4(%eax)
8010448d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104490:	8b 40 04             	mov    0x4(%eax),%eax
80104493:	85 c0                	test   %eax,%eax
80104495:	75 0d                	jne    801044a4 <userinit+0x3a>
    panic("userinit: out of memory?");
80104497:	83 ec 0c             	sub    $0xc,%esp
8010449a:	68 be 8a 10 80       	push   $0x80108abe
8010449f:	e8 fc c0 ff ff       	call   801005a0 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801044a4:	ba 2c 00 00 00       	mov    $0x2c,%edx
801044a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ac:	8b 40 04             	mov    0x4(%eax),%eax
801044af:	83 ec 04             	sub    $0x4,%esp
801044b2:	52                   	push   %edx
801044b3:	68 e0 b4 10 80       	push   $0x8010b4e0
801044b8:	50                   	push   %eax
801044b9:	e8 cc 3a 00 00       	call   80107f8a <inituvm>
801044be:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801044c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c4:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801044ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044cd:	8b 40 18             	mov    0x18(%eax),%eax
801044d0:	83 ec 04             	sub    $0x4,%esp
801044d3:	6a 4c                	push   $0x4c
801044d5:	6a 00                	push   $0x0
801044d7:	50                   	push   %eax
801044d8:	e8 cb 0e 00 00       	call   801053a8 <memset>
801044dd:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801044e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e3:	8b 40 18             	mov    0x18(%eax),%eax
801044e6:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801044ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ef:	8b 40 18             	mov    0x18(%eax),%eax
801044f2:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801044f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044fb:	8b 40 18             	mov    0x18(%eax),%eax
801044fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104501:	8b 52 18             	mov    0x18(%edx),%edx
80104504:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104508:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010450c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010450f:	8b 40 18             	mov    0x18(%eax),%eax
80104512:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104515:	8b 52 18             	mov    0x18(%edx),%edx
80104518:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010451c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104523:	8b 40 18             	mov    0x18(%eax),%eax
80104526:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010452d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104530:	8b 40 18             	mov    0x18(%eax),%eax
80104533:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010453a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010453d:	8b 40 18             	mov    0x18(%eax),%eax
80104540:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104547:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454a:	83 c0 6c             	add    $0x6c,%eax
8010454d:	83 ec 04             	sub    $0x4,%esp
80104550:	6a 10                	push   $0x10
80104552:	68 d7 8a 10 80       	push   $0x80108ad7
80104557:	50                   	push   %eax
80104558:	e8 4e 10 00 00       	call   801055ab <safestrcpy>
8010455d:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104560:	83 ec 0c             	sub    $0xc,%esp
80104563:	68 e0 8a 10 80       	push   $0x80108ae0
80104568:	e8 e3 df ff ff       	call   80102550 <namei>
8010456d:	83 c4 10             	add    $0x10,%esp
80104570:	89 c2                	mov    %eax,%edx
80104572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104575:	89 50 68             	mov    %edx,0x68(%eax)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80104578:	83 ec 0c             	sub    $0xc,%esp
8010457b:	68 c0 3d 11 80       	push   $0x80113dc0
80104580:	e8 9c 0b 00 00       	call   80105121 <acquire>
80104585:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80104588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104592:	83 ec 0c             	sub    $0xc,%esp
80104595:	68 c0 3d 11 80       	push   $0x80113dc0
8010459a:	e8 f0 0b 00 00       	call   8010518f <release>
8010459f:	83 c4 10             	add    $0x10,%esp
}
801045a2:	90                   	nop
801045a3:	c9                   	leave  
801045a4:	c3                   	ret    

801045a5 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801045a5:	55                   	push   %ebp
801045a6:	89 e5                	mov    %esp,%ebp
801045a8:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
801045ab:	e8 88 fd ff ff       	call   80104338 <myproc>
801045b0:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
801045b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045b6:	8b 00                	mov    (%eax),%eax
801045b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801045bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045bf:	7e 2e                	jle    801045ef <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801045c1:	8b 55 08             	mov    0x8(%ebp),%edx
801045c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c7:	01 c2                	add    %eax,%edx
801045c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045cc:	8b 40 04             	mov    0x4(%eax),%eax
801045cf:	83 ec 04             	sub    $0x4,%esp
801045d2:	52                   	push   %edx
801045d3:	ff 75 f4             	pushl  -0xc(%ebp)
801045d6:	50                   	push   %eax
801045d7:	e8 eb 3a 00 00       	call   801080c7 <allocuvm>
801045dc:	83 c4 10             	add    $0x10,%esp
801045df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045e6:	75 3b                	jne    80104623 <growproc+0x7e>
      return -1;
801045e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045ed:	eb 4f                	jmp    8010463e <growproc+0x99>
  } else if(n < 0){
801045ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045f3:	79 2e                	jns    80104623 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801045f5:	8b 55 08             	mov    0x8(%ebp),%edx
801045f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fb:	01 c2                	add    %eax,%edx
801045fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104600:	8b 40 04             	mov    0x4(%eax),%eax
80104603:	83 ec 04             	sub    $0x4,%esp
80104606:	52                   	push   %edx
80104607:	ff 75 f4             	pushl  -0xc(%ebp)
8010460a:	50                   	push   %eax
8010460b:	e8 be 3b 00 00       	call   801081ce <deallocuvm>
80104610:	83 c4 10             	add    $0x10,%esp
80104613:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010461a:	75 07                	jne    80104623 <growproc+0x7e>
      return -1;
8010461c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104621:	eb 1b                	jmp    8010463e <growproc+0x99>
  }
  curproc->sz = sz;
80104623:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104626:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104629:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
8010462b:	83 ec 0c             	sub    $0xc,%esp
8010462e:	ff 75 f0             	pushl  -0x10(%ebp)
80104631:	e8 b6 37 00 00       	call   80107dec <switchuvm>
80104636:	83 c4 10             	add    $0x10,%esp
  return 0;
80104639:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010463e:	c9                   	leave  
8010463f:	c3                   	ret    

80104640 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	57                   	push   %edi
80104644:	56                   	push   %esi
80104645:	53                   	push   %ebx
80104646:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104649:	e8 ea fc ff ff       	call   80104338 <myproc>
8010464e:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80104651:	e8 0b fd ff ff       	call   80104361 <allocproc>
80104656:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104659:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
8010465d:	75 0d                	jne    8010466c <fork+0x2c>
    panic("allocate process");
8010465f:	83 ec 0c             	sub    $0xc,%esp
80104662:	68 e2 8a 10 80       	push   $0x80108ae2
80104667:	e8 34 bf ff ff       	call   801005a0 <panic>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010466c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010466f:	8b 10                	mov    (%eax),%edx
80104671:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104674:	8b 40 04             	mov    0x4(%eax),%eax
80104677:	83 ec 08             	sub    $0x8,%esp
8010467a:	52                   	push   %edx
8010467b:	50                   	push   %eax
8010467c:	e8 eb 3c 00 00       	call   8010836c <copyuvm>
80104681:	83 c4 10             	add    $0x10,%esp
80104684:	89 c2                	mov    %eax,%edx
80104686:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104689:	89 50 04             	mov    %edx,0x4(%eax)
8010468c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010468f:	8b 40 04             	mov    0x4(%eax),%eax
80104692:	85 c0                	test   %eax,%eax
80104694:	75 33                	jne    801046c9 <fork+0x89>
    kfree(np->kstack);
80104696:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104699:	8b 40 08             	mov    0x8(%eax),%eax
8010469c:	83 ec 0c             	sub    $0xc,%esp
8010469f:	50                   	push   %eax
801046a0:	e8 56 e5 ff ff       	call   80102bfb <kfree>
801046a5:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801046a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801046ab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801046b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801046b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    panic("copy process");
801046bc:	83 ec 0c             	sub    $0xc,%esp
801046bf:	68 f3 8a 10 80       	push   $0x80108af3
801046c4:	e8 d7 be ff ff       	call   801005a0 <panic>
    return -1;
  }
  np->sz = curproc->sz;
801046c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046cc:	8b 10                	mov    (%eax),%edx
801046ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
801046d1:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
801046d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801046d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
801046d9:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
801046dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
801046df:	8b 50 18             	mov    0x18(%eax),%edx
801046e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046e5:	8b 40 18             	mov    0x18(%eax),%eax
801046e8:	89 c3                	mov    %eax,%ebx
801046ea:	b8 13 00 00 00       	mov    $0x13,%eax
801046ef:	89 d7                	mov    %edx,%edi
801046f1:	89 de                	mov    %ebx,%esi
801046f3:	89 c1                	mov    %eax,%ecx
801046f5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801046f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801046fa:	8b 40 18             	mov    0x18(%eax),%eax
801046fd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104704:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010470b:	eb 3d                	jmp    8010474a <fork+0x10a>
    if(curproc->ofile[i])
8010470d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104710:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104713:	83 c2 08             	add    $0x8,%edx
80104716:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010471a:	85 c0                	test   %eax,%eax
8010471c:	74 28                	je     80104746 <fork+0x106>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010471e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104721:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104724:	83 c2 08             	add    $0x8,%edx
80104727:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010472b:	83 ec 0c             	sub    $0xc,%esp
8010472e:	50                   	push   %eax
8010472f:	e8 2c c9 ff ff       	call   80101060 <filedup>
80104734:	83 c4 10             	add    $0x10,%esp
80104737:	89 c1                	mov    %eax,%ecx
80104739:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010473c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010473f:	83 c2 08             	add    $0x8,%edx
80104742:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104746:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010474a:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010474e:	7e bd                	jle    8010470d <fork+0xcd>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80104750:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104753:	8b 40 68             	mov    0x68(%eax),%eax
80104756:	83 ec 0c             	sub    $0xc,%esp
80104759:	50                   	push   %eax
8010475a:	e8 77 d2 ff ff       	call   801019d6 <idup>
8010475f:	83 c4 10             	add    $0x10,%esp
80104762:	89 c2                	mov    %eax,%edx
80104764:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104767:	89 50 68             	mov    %edx,0x68(%eax)
  // copy share memory.
  for(int i = 0; i < NSHAREDPG; i++){
8010476a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80104771:	e9 85 00 00 00       	jmp    801047fb <fork+0x1bb>
    if(curproc->share[i]){
80104776:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104779:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010477c:	83 c2 1c             	add    $0x1c,%edx
8010477f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80104783:	85 c0                	test   %eax,%eax
80104785:	74 70                	je     801047f7 <fork+0x1b7>
        np->share[i] = curproc->share[i];
80104787:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010478a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010478d:	83 c2 1c             	add    $0x1c,%edx
80104790:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80104794:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104797:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010479a:	83 c1 1c             	add    $0x1c,%ecx
8010479d:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
        mappages(np->pgdir, (char*)(KERNBASE - PGSIZE*(i+1)), PGSIZE, V2P(sharepages[i].vaddr), PTE_W|PTE_U);
801047a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047a4:	8b 04 c5 80 69 11 80 	mov    -0x7fee9680(,%eax,8),%eax
801047ab:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801047b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047b4:	83 c0 01             	add    $0x1,%eax
801047b7:	c1 e0 0c             	shl    $0xc,%eax
801047ba:	b9 00 00 00 80       	mov    $0x80000000,%ecx
801047bf:	29 c1                	sub    %eax,%ecx
801047c1:	89 c8                	mov    %ecx,%eax
801047c3:	89 c1                	mov    %eax,%ecx
801047c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801047c8:	8b 40 04             	mov    0x4(%eax),%eax
801047cb:	83 ec 0c             	sub    $0xc,%esp
801047ce:	6a 06                	push   $0x6
801047d0:	52                   	push   %edx
801047d1:	68 00 10 00 00       	push   $0x1000
801047d6:	51                   	push   %ecx
801047d7:	50                   	push   %eax
801047d8:	e8 b5 34 00 00       	call   80107c92 <mappages>
801047dd:	83 c4 20             	add    $0x20,%esp
        sharepages[i].count++;
801047e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047e3:	8b 04 c5 84 69 11 80 	mov    -0x7fee967c(,%eax,8),%eax
801047ea:	8d 50 01             	lea    0x1(%eax),%edx
801047ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047f0:	89 14 c5 84 69 11 80 	mov    %edx,-0x7fee967c(,%eax,8)
  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
  // copy share memory.
  for(int i = 0; i < NSHAREDPG; i++){
801047f7:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
801047fb:	83 7d e0 03          	cmpl   $0x3,-0x20(%ebp)
801047ff:	0f 8e 71 ff ff ff    	jle    80104776 <fork+0x136>
        mappages(np->pgdir, (char*)(KERNBASE - PGSIZE*(i+1)), PGSIZE, V2P(sharepages[i].vaddr), PTE_W|PTE_U);
        sharepages[i].count++;
    }
  }

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104805:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104808:	8d 50 6c             	lea    0x6c(%eax),%edx
8010480b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010480e:	83 c0 6c             	add    $0x6c,%eax
80104811:	83 ec 04             	sub    $0x4,%esp
80104814:	6a 10                	push   $0x10
80104816:	52                   	push   %edx
80104817:	50                   	push   %eax
80104818:	e8 8e 0d 00 00       	call   801055ab <safestrcpy>
8010481d:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104820:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104823:	8b 40 10             	mov    0x10(%eax),%eax
80104826:	89 45 d4             	mov    %eax,-0x2c(%ebp)

  acquire(&ptable.lock);
80104829:	83 ec 0c             	sub    $0xc,%esp
8010482c:	68 c0 3d 11 80       	push   $0x80113dc0
80104831:	e8 eb 08 00 00       	call   80105121 <acquire>
80104836:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80104839:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010483c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104843:	83 ec 0c             	sub    $0xc,%esp
80104846:	68 c0 3d 11 80       	push   $0x80113dc0
8010484b:	e8 3f 09 00 00       	call   8010518f <release>
80104850:	83 c4 10             	add    $0x10,%esp

  return pid;
80104853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
80104856:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104859:	5b                   	pop    %ebx
8010485a:	5e                   	pop    %esi
8010485b:	5f                   	pop    %edi
8010485c:	5d                   	pop    %ebp
8010485d:	c3                   	ret    

8010485e <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010485e:	55                   	push   %ebp
8010485f:	89 e5                	mov    %esp,%ebp
80104861:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104864:	e8 cf fa ff ff       	call   80104338 <myproc>
80104869:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010486c:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80104871:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104874:	75 0d                	jne    80104883 <exit+0x25>
    panic("init exiting");
80104876:	83 ec 0c             	sub    $0xc,%esp
80104879:	68 00 8b 10 80       	push   $0x80108b00
8010487e:	e8 1d bd ff ff       	call   801005a0 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104883:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010488a:	eb 3f                	jmp    801048cb <exit+0x6d>
    if(curproc->ofile[fd]){
8010488c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010488f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104892:	83 c2 08             	add    $0x8,%edx
80104895:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104899:	85 c0                	test   %eax,%eax
8010489b:	74 2a                	je     801048c7 <exit+0x69>
      fileclose(curproc->ofile[fd]);
8010489d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048a3:	83 c2 08             	add    $0x8,%edx
801048a6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048aa:	83 ec 0c             	sub    $0xc,%esp
801048ad:	50                   	push   %eax
801048ae:	e8 fe c7 ff ff       	call   801010b1 <fileclose>
801048b3:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
801048b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048bc:	83 c2 08             	add    $0x8,%edx
801048bf:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048c6:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048c7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801048cb:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801048cf:	7e bb                	jle    8010488c <exit+0x2e>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
801048d1:	e8 5f ec ff ff       	call   80103535 <begin_op>
  iput(curproc->cwd);
801048d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048d9:	8b 40 68             	mov    0x68(%eax),%eax
801048dc:	83 ec 0c             	sub    $0xc,%esp
801048df:	50                   	push   %eax
801048e0:	e8 8c d2 ff ff       	call   80101b71 <iput>
801048e5:	83 c4 10             	add    $0x10,%esp
  end_op();
801048e8:	e8 d4 ec ff ff       	call   801035c1 <end_op>
  curproc->cwd = 0;
801048ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048f0:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801048f7:	83 ec 0c             	sub    $0xc,%esp
801048fa:	68 c0 3d 11 80       	push   $0x80113dc0
801048ff:	e8 1d 08 00 00       	call   80105121 <acquire>
80104904:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104907:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010490a:	8b 40 14             	mov    0x14(%eax),%eax
8010490d:	83 ec 0c             	sub    $0xc,%esp
80104910:	50                   	push   %eax
80104911:	e8 6a 04 00 00       	call   80104d80 <wakeup1>
80104916:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104919:	c7 45 f4 f4 3d 11 80 	movl   $0x80113df4,-0xc(%ebp)
80104920:	eb 3a                	jmp    8010495c <exit+0xfe>
    if(p->parent == curproc){
80104922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104925:	8b 40 14             	mov    0x14(%eax),%eax
80104928:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010492b:	75 28                	jne    80104955 <exit+0xf7>
      p->parent = initproc;
8010492d:	8b 15 40 b6 10 80    	mov    0x8010b640,%edx
80104933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104936:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010493c:	8b 40 0c             	mov    0xc(%eax),%eax
8010493f:	83 f8 05             	cmp    $0x5,%eax
80104942:	75 11                	jne    80104955 <exit+0xf7>
        wakeup1(initproc);
80104944:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80104949:	83 ec 0c             	sub    $0xc,%esp
8010494c:	50                   	push   %eax
8010494d:	e8 2e 04 00 00       	call   80104d80 <wakeup1>
80104952:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104955:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
8010495c:	81 7d f4 f4 60 11 80 	cmpl   $0x801160f4,-0xc(%ebp)
80104963:	72 bd                	jb     80104922 <exit+0xc4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104965:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104968:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010496f:	e8 2a 02 00 00       	call   80104b9e <sched>
  panic("zombie exit");
80104974:	83 ec 0c             	sub    $0xc,%esp
80104977:	68 0d 8b 10 80       	push   $0x80108b0d
8010497c:	e8 1f bc ff ff       	call   801005a0 <panic>

80104981 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104981:	55                   	push   %ebp
80104982:	89 e5                	mov    %esp,%ebp
80104984:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104987:	e8 ac f9 ff ff       	call   80104338 <myproc>
8010498c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  
  acquire(&ptable.lock);
8010498f:	83 ec 0c             	sub    $0xc,%esp
80104992:	68 c0 3d 11 80       	push   $0x80113dc0
80104997:	e8 85 07 00 00       	call   80105121 <acquire>
8010499c:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010499f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049a6:	c7 45 f4 f4 3d 11 80 	movl   $0x80113df4,-0xc(%ebp)
801049ad:	e9 e3 00 00 00       	jmp    80104a95 <wait+0x114>
      if(p->parent != curproc)
801049b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b5:	8b 40 14             	mov    0x14(%eax),%eax
801049b8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
801049bb:	0f 85 cc 00 00 00    	jne    80104a8d <wait+0x10c>
        continue;
      havekids = 1;
801049c1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801049c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049cb:	8b 40 0c             	mov    0xc(%eax),%eax
801049ce:	83 f8 05             	cmp    $0x5,%eax
801049d1:	0f 85 b7 00 00 00    	jne    80104a8e <wait+0x10d>
          for(int i = 0; i < NSHAREDPG; i++){
801049d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801049de:	eb 2c                	jmp    80104a0c <wait+0x8b>
              if(p->share[i]){
801049e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801049e6:	83 c2 1c             	add    $0x1c,%edx
801049e9:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801049ed:	85 c0                	test   %eax,%eax
801049ef:	74 17                	je     80104a08 <wait+0x87>
                  sharepages[i].count--;
801049f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049f4:	8b 04 c5 84 69 11 80 	mov    -0x7fee967c(,%eax,8),%eax
801049fb:	8d 50 ff             	lea    -0x1(%eax),%edx
801049fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a01:	89 14 c5 84 69 11 80 	mov    %edx,-0x7fee967c(,%eax,8)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
          for(int i = 0; i < NSHAREDPG; i++){
80104a08:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104a0c:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
80104a10:	7e ce                	jle    801049e0 <wait+0x5f>
              if(p->share[i]){
                  sharepages[i].count--;
              }
          }
        // Found one.
        pid = p->pid;
80104a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a15:	8b 40 10             	mov    0x10(%eax),%eax
80104a18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        kfree(p->kstack);
80104a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1e:	8b 40 08             	mov    0x8(%eax),%eax
80104a21:	83 ec 0c             	sub    $0xc,%esp
80104a24:	50                   	push   %eax
80104a25:	e8 d1 e1 ff ff       	call   80102bfb <kfree>
80104a2a:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a30:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a3a:	8b 40 04             	mov    0x4(%eax),%eax
80104a3d:	83 ec 0c             	sub    $0xc,%esp
80104a40:	50                   	push   %eax
80104a41:	e8 4c 38 00 00       	call   80108292 <freevm>
80104a46:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a56:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a60:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a67:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a71:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104a78:	83 ec 0c             	sub    $0xc,%esp
80104a7b:	68 c0 3d 11 80       	push   $0x80113dc0
80104a80:	e8 0a 07 00 00       	call   8010518f <release>
80104a85:	83 c4 10             	add    $0x10,%esp
        return pid;
80104a88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a8b:	eb 54                	jmp    80104ae1 <wait+0x160>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
80104a8d:	90                   	nop
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a8e:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104a95:	81 7d f4 f4 60 11 80 	cmpl   $0x801160f4,-0xc(%ebp)
80104a9c:	0f 82 10 ff ff ff    	jb     801049b2 <wait+0x31>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104aa2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104aa6:	74 0a                	je     80104ab2 <wait+0x131>
80104aa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104aab:	8b 40 24             	mov    0x24(%eax),%eax
80104aae:	85 c0                	test   %eax,%eax
80104ab0:	74 17                	je     80104ac9 <wait+0x148>
      release(&ptable.lock);
80104ab2:	83 ec 0c             	sub    $0xc,%esp
80104ab5:	68 c0 3d 11 80       	push   $0x80113dc0
80104aba:	e8 d0 06 00 00       	call   8010518f <release>
80104abf:	83 c4 10             	add    $0x10,%esp
      return -1;
80104ac2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac7:	eb 18                	jmp    80104ae1 <wait+0x160>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104ac9:	83 ec 08             	sub    $0x8,%esp
80104acc:	68 c0 3d 11 80       	push   $0x80113dc0
80104ad1:	ff 75 e8             	pushl  -0x18(%ebp)
80104ad4:	e8 00 02 00 00       	call   80104cd9 <sleep>
80104ad9:	83 c4 10             	add    $0x10,%esp
  }
80104adc:	e9 be fe ff ff       	jmp    8010499f <wait+0x1e>
}
80104ae1:	c9                   	leave  
80104ae2:	c3                   	ret    

80104ae3 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104ae3:	55                   	push   %ebp
80104ae4:	89 e5                	mov    %esp,%ebp
80104ae6:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104ae9:	e8 d2 f7 ff ff       	call   801042c0 <mycpu>
80104aee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104af4:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104afb:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104afe:	e8 cc f6 ff ff       	call   801041cf <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104b03:	83 ec 0c             	sub    $0xc,%esp
80104b06:	68 c0 3d 11 80       	push   $0x80113dc0
80104b0b:	e8 11 06 00 00       	call   80105121 <acquire>
80104b10:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b13:	c7 45 f4 f4 3d 11 80 	movl   $0x80113df4,-0xc(%ebp)
80104b1a:	eb 64                	jmp    80104b80 <scheduler+0x9d>
      if(p->state != RUNNABLE)
80104b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1f:	8b 40 0c             	mov    0xc(%eax),%eax
80104b22:	83 f8 03             	cmp    $0x3,%eax
80104b25:	75 51                	jne    80104b78 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b2d:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104b33:	83 ec 0c             	sub    $0xc,%esp
80104b36:	ff 75 f4             	pushl  -0xc(%ebp)
80104b39:	e8 ae 32 00 00       	call   80107dec <switchuvm>
80104b3e:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b44:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b4e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b51:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b54:	83 c2 04             	add    $0x4,%edx
80104b57:	83 ec 08             	sub    $0x8,%esp
80104b5a:	50                   	push   %eax
80104b5b:	52                   	push   %edx
80104b5c:	e8 bb 0a 00 00       	call   8010561c <swtch>
80104b61:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104b64:	e8 6a 32 00 00       	call   80107dd3 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b6c:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104b73:	00 00 00 
80104b76:	eb 01                	jmp    80104b79 <scheduler+0x96>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104b78:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b79:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104b80:	81 7d f4 f4 60 11 80 	cmpl   $0x801160f4,-0xc(%ebp)
80104b87:	72 93                	jb     80104b1c <scheduler+0x39>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80104b89:	83 ec 0c             	sub    $0xc,%esp
80104b8c:	68 c0 3d 11 80       	push   $0x80113dc0
80104b91:	e8 f9 05 00 00       	call   8010518f <release>
80104b96:	83 c4 10             	add    $0x10,%esp

  }
80104b99:	e9 60 ff ff ff       	jmp    80104afe <scheduler+0x1b>

80104b9e <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104b9e:	55                   	push   %ebp
80104b9f:	89 e5                	mov    %esp,%ebp
80104ba1:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104ba4:	e8 8f f7 ff ff       	call   80104338 <myproc>
80104ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104bac:	83 ec 0c             	sub    $0xc,%esp
80104baf:	68 c0 3d 11 80       	push   $0x80113dc0
80104bb4:	e8 a2 06 00 00       	call   8010525b <holding>
80104bb9:	83 c4 10             	add    $0x10,%esp
80104bbc:	85 c0                	test   %eax,%eax
80104bbe:	75 0d                	jne    80104bcd <sched+0x2f>
    panic("sched ptable.lock");
80104bc0:	83 ec 0c             	sub    $0xc,%esp
80104bc3:	68 19 8b 10 80       	push   $0x80108b19
80104bc8:	e8 d3 b9 ff ff       	call   801005a0 <panic>
  if(mycpu()->ncli != 1)
80104bcd:	e8 ee f6 ff ff       	call   801042c0 <mycpu>
80104bd2:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104bd8:	83 f8 01             	cmp    $0x1,%eax
80104bdb:	74 0d                	je     80104bea <sched+0x4c>
    panic("sched locks");
80104bdd:	83 ec 0c             	sub    $0xc,%esp
80104be0:	68 2b 8b 10 80       	push   $0x80108b2b
80104be5:	e8 b6 b9 ff ff       	call   801005a0 <panic>
  if(p->state == RUNNING)
80104bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bed:	8b 40 0c             	mov    0xc(%eax),%eax
80104bf0:	83 f8 04             	cmp    $0x4,%eax
80104bf3:	75 0d                	jne    80104c02 <sched+0x64>
    panic("sched running");
80104bf5:	83 ec 0c             	sub    $0xc,%esp
80104bf8:	68 37 8b 10 80       	push   $0x80108b37
80104bfd:	e8 9e b9 ff ff       	call   801005a0 <panic>
  if(readeflags()&FL_IF)
80104c02:	e8 b8 f5 ff ff       	call   801041bf <readeflags>
80104c07:	25 00 02 00 00       	and    $0x200,%eax
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	74 0d                	je     80104c1d <sched+0x7f>
    panic("sched interruptible");
80104c10:	83 ec 0c             	sub    $0xc,%esp
80104c13:	68 45 8b 10 80       	push   $0x80108b45
80104c18:	e8 83 b9 ff ff       	call   801005a0 <panic>
  intena = mycpu()->intena;
80104c1d:	e8 9e f6 ff ff       	call   801042c0 <mycpu>
80104c22:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104c2b:	e8 90 f6 ff ff       	call   801042c0 <mycpu>
80104c30:	8b 40 04             	mov    0x4(%eax),%eax
80104c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c36:	83 c2 1c             	add    $0x1c,%edx
80104c39:	83 ec 08             	sub    $0x8,%esp
80104c3c:	50                   	push   %eax
80104c3d:	52                   	push   %edx
80104c3e:	e8 d9 09 00 00       	call   8010561c <swtch>
80104c43:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104c46:	e8 75 f6 ff ff       	call   801042c0 <mycpu>
80104c4b:	89 c2                	mov    %eax,%edx
80104c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c50:	89 82 a8 00 00 00    	mov    %eax,0xa8(%edx)
}
80104c56:	90                   	nop
80104c57:	c9                   	leave  
80104c58:	c3                   	ret    

80104c59 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104c59:	55                   	push   %ebp
80104c5a:	89 e5                	mov    %esp,%ebp
80104c5c:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104c5f:	83 ec 0c             	sub    $0xc,%esp
80104c62:	68 c0 3d 11 80       	push   $0x80113dc0
80104c67:	e8 b5 04 00 00       	call   80105121 <acquire>
80104c6c:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104c6f:	e8 c4 f6 ff ff       	call   80104338 <myproc>
80104c74:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104c7b:	e8 1e ff ff ff       	call   80104b9e <sched>
  release(&ptable.lock);
80104c80:	83 ec 0c             	sub    $0xc,%esp
80104c83:	68 c0 3d 11 80       	push   $0x80113dc0
80104c88:	e8 02 05 00 00       	call   8010518f <release>
80104c8d:	83 c4 10             	add    $0x10,%esp
}
80104c90:	90                   	nop
80104c91:	c9                   	leave  
80104c92:	c3                   	ret    

80104c93 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c93:	55                   	push   %ebp
80104c94:	89 e5                	mov    %esp,%ebp
80104c96:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c99:	83 ec 0c             	sub    $0xc,%esp
80104c9c:	68 c0 3d 11 80       	push   $0x80113dc0
80104ca1:	e8 e9 04 00 00       	call   8010518f <release>
80104ca6:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104ca9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104cae:	85 c0                	test   %eax,%eax
80104cb0:	74 24                	je     80104cd6 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104cb2:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
80104cb9:	00 00 00 
    iinit(ROOTDEV);
80104cbc:	83 ec 0c             	sub    $0xc,%esp
80104cbf:	6a 01                	push   $0x1
80104cc1:	e8 d8 c9 ff ff       	call   8010169e <iinit>
80104cc6:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104cc9:	83 ec 0c             	sub    $0xc,%esp
80104ccc:	6a 01                	push   $0x1
80104cce:	e8 44 e6 ff ff       	call   80103317 <initlog>
80104cd3:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104cd6:	90                   	nop
80104cd7:	c9                   	leave  
80104cd8:	c3                   	ret    

80104cd9 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104cd9:	55                   	push   %ebp
80104cda:	89 e5                	mov    %esp,%ebp
80104cdc:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104cdf:	e8 54 f6 ff ff       	call   80104338 <myproc>
80104ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104ce7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104ceb:	75 0d                	jne    80104cfa <sleep+0x21>
    panic("sleep");
80104ced:	83 ec 0c             	sub    $0xc,%esp
80104cf0:	68 59 8b 10 80       	push   $0x80108b59
80104cf5:	e8 a6 b8 ff ff       	call   801005a0 <panic>

  if(lk == 0)
80104cfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104cfe:	75 0d                	jne    80104d0d <sleep+0x34>
    panic("sleep without lk");
80104d00:	83 ec 0c             	sub    $0xc,%esp
80104d03:	68 5f 8b 10 80       	push   $0x80108b5f
80104d08:	e8 93 b8 ff ff       	call   801005a0 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104d0d:	81 7d 0c c0 3d 11 80 	cmpl   $0x80113dc0,0xc(%ebp)
80104d14:	74 1e                	je     80104d34 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104d16:	83 ec 0c             	sub    $0xc,%esp
80104d19:	68 c0 3d 11 80       	push   $0x80113dc0
80104d1e:	e8 fe 03 00 00       	call   80105121 <acquire>
80104d23:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104d26:	83 ec 0c             	sub    $0xc,%esp
80104d29:	ff 75 0c             	pushl  0xc(%ebp)
80104d2c:	e8 5e 04 00 00       	call   8010518f <release>
80104d31:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d37:	8b 55 08             	mov    0x8(%ebp),%edx
80104d3a:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d40:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104d47:	e8 52 fe ff ff       	call   80104b9e <sched>

  // Tidy up.
  p->chan = 0;
80104d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d4f:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104d56:	81 7d 0c c0 3d 11 80 	cmpl   $0x80113dc0,0xc(%ebp)
80104d5d:	74 1e                	je     80104d7d <sleep+0xa4>
    release(&ptable.lock);
80104d5f:	83 ec 0c             	sub    $0xc,%esp
80104d62:	68 c0 3d 11 80       	push   $0x80113dc0
80104d67:	e8 23 04 00 00       	call   8010518f <release>
80104d6c:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104d6f:	83 ec 0c             	sub    $0xc,%esp
80104d72:	ff 75 0c             	pushl  0xc(%ebp)
80104d75:	e8 a7 03 00 00       	call   80105121 <acquire>
80104d7a:	83 c4 10             	add    $0x10,%esp
  }
}
80104d7d:	90                   	nop
80104d7e:	c9                   	leave  
80104d7f:	c3                   	ret    

80104d80 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d86:	c7 45 fc f4 3d 11 80 	movl   $0x80113df4,-0x4(%ebp)
80104d8d:	eb 27                	jmp    80104db6 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104d8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d92:	8b 40 0c             	mov    0xc(%eax),%eax
80104d95:	83 f8 02             	cmp    $0x2,%eax
80104d98:	75 15                	jne    80104daf <wakeup1+0x2f>
80104d9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d9d:	8b 40 20             	mov    0x20(%eax),%eax
80104da0:	3b 45 08             	cmp    0x8(%ebp),%eax
80104da3:	75 0a                	jne    80104daf <wakeup1+0x2f>
      p->state = RUNNABLE;
80104da5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104da8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104daf:	81 45 fc 8c 00 00 00 	addl   $0x8c,-0x4(%ebp)
80104db6:	81 7d fc f4 60 11 80 	cmpl   $0x801160f4,-0x4(%ebp)
80104dbd:	72 d0                	jb     80104d8f <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104dbf:	90                   	nop
80104dc0:	c9                   	leave  
80104dc1:	c3                   	ret    

80104dc2 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104dc2:	55                   	push   %ebp
80104dc3:	89 e5                	mov    %esp,%ebp
80104dc5:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104dc8:	83 ec 0c             	sub    $0xc,%esp
80104dcb:	68 c0 3d 11 80       	push   $0x80113dc0
80104dd0:	e8 4c 03 00 00       	call   80105121 <acquire>
80104dd5:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104dd8:	83 ec 0c             	sub    $0xc,%esp
80104ddb:	ff 75 08             	pushl  0x8(%ebp)
80104dde:	e8 9d ff ff ff       	call   80104d80 <wakeup1>
80104de3:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104de6:	83 ec 0c             	sub    $0xc,%esp
80104de9:	68 c0 3d 11 80       	push   $0x80113dc0
80104dee:	e8 9c 03 00 00       	call   8010518f <release>
80104df3:	83 c4 10             	add    $0x10,%esp
}
80104df6:	90                   	nop
80104df7:	c9                   	leave  
80104df8:	c3                   	ret    

80104df9 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104df9:	55                   	push   %ebp
80104dfa:	89 e5                	mov    %esp,%ebp
80104dfc:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104dff:	83 ec 0c             	sub    $0xc,%esp
80104e02:	68 c0 3d 11 80       	push   $0x80113dc0
80104e07:	e8 15 03 00 00       	call   80105121 <acquire>
80104e0c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e0f:	c7 45 f4 f4 3d 11 80 	movl   $0x80113df4,-0xc(%ebp)
80104e16:	eb 48                	jmp    80104e60 <kill+0x67>
    if(p->pid == pid){
80104e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e1b:	8b 40 10             	mov    0x10(%eax),%eax
80104e1e:	3b 45 08             	cmp    0x8(%ebp),%eax
80104e21:	75 36                	jne    80104e59 <kill+0x60>
      p->killed = 1;
80104e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e26:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e30:	8b 40 0c             	mov    0xc(%eax),%eax
80104e33:	83 f8 02             	cmp    $0x2,%eax
80104e36:	75 0a                	jne    80104e42 <kill+0x49>
        p->state = RUNNABLE;
80104e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e3b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104e42:	83 ec 0c             	sub    $0xc,%esp
80104e45:	68 c0 3d 11 80       	push   $0x80113dc0
80104e4a:	e8 40 03 00 00       	call   8010518f <release>
80104e4f:	83 c4 10             	add    $0x10,%esp
      return 0;
80104e52:	b8 00 00 00 00       	mov    $0x0,%eax
80104e57:	eb 25                	jmp    80104e7e <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e59:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104e60:	81 7d f4 f4 60 11 80 	cmpl   $0x801160f4,-0xc(%ebp)
80104e67:	72 af                	jb     80104e18 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104e69:	83 ec 0c             	sub    $0xc,%esp
80104e6c:	68 c0 3d 11 80       	push   $0x80113dc0
80104e71:	e8 19 03 00 00       	call   8010518f <release>
80104e76:	83 c4 10             	add    $0x10,%esp
  return -1;
80104e79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e7e:	c9                   	leave  
80104e7f:	c3                   	ret    

80104e80 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e86:	c7 45 f0 f4 3d 11 80 	movl   $0x80113df4,-0x10(%ebp)
80104e8d:	e9 da 00 00 00       	jmp    80104f6c <procdump+0xec>
    if(p->state == UNUSED)
80104e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e95:	8b 40 0c             	mov    0xc(%eax),%eax
80104e98:	85 c0                	test   %eax,%eax
80104e9a:	0f 84 c4 00 00 00    	je     80104f64 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ea3:	8b 40 0c             	mov    0xc(%eax),%eax
80104ea6:	83 f8 05             	cmp    $0x5,%eax
80104ea9:	77 23                	ja     80104ece <procdump+0x4e>
80104eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eae:	8b 40 0c             	mov    0xc(%eax),%eax
80104eb1:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104eb8:	85 c0                	test   %eax,%eax
80104eba:	74 12                	je     80104ece <procdump+0x4e>
      state = states[p->state];
80104ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ebf:	8b 40 0c             	mov    0xc(%eax),%eax
80104ec2:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104ec9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104ecc:	eb 07                	jmp    80104ed5 <procdump+0x55>
    else
      state = "???";
80104ece:	c7 45 ec 70 8b 10 80 	movl   $0x80108b70,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ed8:	8d 50 6c             	lea    0x6c(%eax),%edx
80104edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ede:	8b 40 10             	mov    0x10(%eax),%eax
80104ee1:	52                   	push   %edx
80104ee2:	ff 75 ec             	pushl  -0x14(%ebp)
80104ee5:	50                   	push   %eax
80104ee6:	68 74 8b 10 80       	push   $0x80108b74
80104eeb:	e8 10 b5 ff ff       	call   80100400 <cprintf>
80104ef0:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ef6:	8b 40 0c             	mov    0xc(%eax),%eax
80104ef9:	83 f8 02             	cmp    $0x2,%eax
80104efc:	75 54                	jne    80104f52 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f01:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f04:	8b 40 0c             	mov    0xc(%eax),%eax
80104f07:	83 c0 08             	add    $0x8,%eax
80104f0a:	89 c2                	mov    %eax,%edx
80104f0c:	83 ec 08             	sub    $0x8,%esp
80104f0f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f12:	50                   	push   %eax
80104f13:	52                   	push   %edx
80104f14:	e8 c8 02 00 00       	call   801051e1 <getcallerpcs>
80104f19:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104f1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104f23:	eb 1c                	jmp    80104f41 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f28:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104f2c:	83 ec 08             	sub    $0x8,%esp
80104f2f:	50                   	push   %eax
80104f30:	68 7d 8b 10 80       	push   $0x80108b7d
80104f35:	e8 c6 b4 ff ff       	call   80100400 <cprintf>
80104f3a:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104f3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104f41:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104f45:	7f 0b                	jg     80104f52 <procdump+0xd2>
80104f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104f4e:	85 c0                	test   %eax,%eax
80104f50:	75 d3                	jne    80104f25 <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104f52:	83 ec 0c             	sub    $0xc,%esp
80104f55:	68 81 8b 10 80       	push   $0x80108b81
80104f5a:	e8 a1 b4 ff ff       	call   80100400 <cprintf>
80104f5f:	83 c4 10             	add    $0x10,%esp
80104f62:	eb 01                	jmp    80104f65 <procdump+0xe5>
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104f64:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f65:	81 45 f0 8c 00 00 00 	addl   $0x8c,-0x10(%ebp)
80104f6c:	81 7d f0 f4 60 11 80 	cmpl   $0x801160f4,-0x10(%ebp)
80104f73:	0f 82 19 ff ff ff    	jb     80104e92 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104f79:	90                   	nop
80104f7a:	c9                   	leave  
80104f7b:	c3                   	ret    

80104f7c <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104f7c:	55                   	push   %ebp
80104f7d:	89 e5                	mov    %esp,%ebp
80104f7f:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80104f82:	8b 45 08             	mov    0x8(%ebp),%eax
80104f85:	83 c0 04             	add    $0x4,%eax
80104f88:	83 ec 08             	sub    $0x8,%esp
80104f8b:	68 ad 8b 10 80       	push   $0x80108bad
80104f90:	50                   	push   %eax
80104f91:	e8 69 01 00 00       	call   801050ff <initlock>
80104f96:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80104f99:	8b 45 08             	mov    0x8(%ebp),%eax
80104f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f9f:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104fa2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104fab:	8b 45 08             	mov    0x8(%ebp),%eax
80104fae:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104fb5:	90                   	nop
80104fb6:	c9                   	leave  
80104fb7:	c3                   	ret    

80104fb8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104fb8:	55                   	push   %ebp
80104fb9:	89 e5                	mov    %esp,%ebp
80104fbb:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104fbe:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc1:	83 c0 04             	add    $0x4,%eax
80104fc4:	83 ec 0c             	sub    $0xc,%esp
80104fc7:	50                   	push   %eax
80104fc8:	e8 54 01 00 00       	call   80105121 <acquire>
80104fcd:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104fd0:	eb 15                	jmp    80104fe7 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104fd2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd5:	83 c0 04             	add    $0x4,%eax
80104fd8:	83 ec 08             	sub    $0x8,%esp
80104fdb:	50                   	push   %eax
80104fdc:	ff 75 08             	pushl  0x8(%ebp)
80104fdf:	e8 f5 fc ff ff       	call   80104cd9 <sleep>
80104fe4:	83 c4 10             	add    $0x10,%esp

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104fe7:	8b 45 08             	mov    0x8(%ebp),%eax
80104fea:	8b 00                	mov    (%eax),%eax
80104fec:	85 c0                	test   %eax,%eax
80104fee:	75 e2                	jne    80104fd2 <acquiresleep+0x1a>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104ff9:	e8 3a f3 ff ff       	call   80104338 <myproc>
80104ffe:	8b 50 10             	mov    0x10(%eax),%edx
80105001:	8b 45 08             	mov    0x8(%ebp),%eax
80105004:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80105007:	8b 45 08             	mov    0x8(%ebp),%eax
8010500a:	83 c0 04             	add    $0x4,%eax
8010500d:	83 ec 0c             	sub    $0xc,%esp
80105010:	50                   	push   %eax
80105011:	e8 79 01 00 00       	call   8010518f <release>
80105016:	83 c4 10             	add    $0x10,%esp
}
80105019:	90                   	nop
8010501a:	c9                   	leave  
8010501b:	c3                   	ret    

8010501c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
8010501c:	55                   	push   %ebp
8010501d:	89 e5                	mov    %esp,%ebp
8010501f:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80105022:	8b 45 08             	mov    0x8(%ebp),%eax
80105025:	83 c0 04             	add    $0x4,%eax
80105028:	83 ec 0c             	sub    $0xc,%esp
8010502b:	50                   	push   %eax
8010502c:	e8 f0 00 00 00       	call   80105121 <acquire>
80105031:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
80105034:	8b 45 08             	mov    0x8(%ebp),%eax
80105037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010503d:	8b 45 08             	mov    0x8(%ebp),%eax
80105040:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80105047:	83 ec 0c             	sub    $0xc,%esp
8010504a:	ff 75 08             	pushl  0x8(%ebp)
8010504d:	e8 70 fd ff ff       	call   80104dc2 <wakeup>
80105052:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80105055:	8b 45 08             	mov    0x8(%ebp),%eax
80105058:	83 c0 04             	add    $0x4,%eax
8010505b:	83 ec 0c             	sub    $0xc,%esp
8010505e:	50                   	push   %eax
8010505f:	e8 2b 01 00 00       	call   8010518f <release>
80105064:	83 c4 10             	add    $0x10,%esp
}
80105067:	90                   	nop
80105068:	c9                   	leave  
80105069:	c3                   	ret    

8010506a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
8010506a:	55                   	push   %ebp
8010506b:	89 e5                	mov    %esp,%ebp
8010506d:	53                   	push   %ebx
8010506e:	83 ec 14             	sub    $0x14,%esp
  int r;
  
  acquire(&lk->lk);
80105071:	8b 45 08             	mov    0x8(%ebp),%eax
80105074:	83 c0 04             	add    $0x4,%eax
80105077:	83 ec 0c             	sub    $0xc,%esp
8010507a:	50                   	push   %eax
8010507b:	e8 a1 00 00 00       	call   80105121 <acquire>
80105080:	83 c4 10             	add    $0x10,%esp
  r = lk->locked && (lk->pid == myproc()->pid);
80105083:	8b 45 08             	mov    0x8(%ebp),%eax
80105086:	8b 00                	mov    (%eax),%eax
80105088:	85 c0                	test   %eax,%eax
8010508a:	74 19                	je     801050a5 <holdingsleep+0x3b>
8010508c:	8b 45 08             	mov    0x8(%ebp),%eax
8010508f:	8b 58 3c             	mov    0x3c(%eax),%ebx
80105092:	e8 a1 f2 ff ff       	call   80104338 <myproc>
80105097:	8b 40 10             	mov    0x10(%eax),%eax
8010509a:	39 c3                	cmp    %eax,%ebx
8010509c:	75 07                	jne    801050a5 <holdingsleep+0x3b>
8010509e:	b8 01 00 00 00       	mov    $0x1,%eax
801050a3:	eb 05                	jmp    801050aa <holdingsleep+0x40>
801050a5:	b8 00 00 00 00       	mov    $0x0,%eax
801050aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
801050ad:	8b 45 08             	mov    0x8(%ebp),%eax
801050b0:	83 c0 04             	add    $0x4,%eax
801050b3:	83 ec 0c             	sub    $0xc,%esp
801050b6:	50                   	push   %eax
801050b7:	e8 d3 00 00 00       	call   8010518f <release>
801050bc:	83 c4 10             	add    $0x10,%esp
  return r;
801050bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801050c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050c5:	c9                   	leave  
801050c6:	c3                   	ret    

801050c7 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801050c7:	55                   	push   %ebp
801050c8:	89 e5                	mov    %esp,%ebp
801050ca:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801050cd:	9c                   	pushf  
801050ce:	58                   	pop    %eax
801050cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801050d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050d5:	c9                   	leave  
801050d6:	c3                   	ret    

801050d7 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801050d7:	55                   	push   %ebp
801050d8:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801050da:	fa                   	cli    
}
801050db:	90                   	nop
801050dc:	5d                   	pop    %ebp
801050dd:	c3                   	ret    

801050de <sti>:

static inline void
sti(void)
{
801050de:	55                   	push   %ebp
801050df:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801050e1:	fb                   	sti    
}
801050e2:	90                   	nop
801050e3:	5d                   	pop    %ebp
801050e4:	c3                   	ret    

801050e5 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801050e5:	55                   	push   %ebp
801050e6:	89 e5                	mov    %esp,%ebp
801050e8:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801050eb:	8b 55 08             	mov    0x8(%ebp),%edx
801050ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801050f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050f4:	f0 87 02             	lock xchg %eax,(%edx)
801050f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801050fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050fd:	c9                   	leave  
801050fe:	c3                   	ret    

801050ff <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801050ff:	55                   	push   %ebp
80105100:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105102:	8b 45 08             	mov    0x8(%ebp),%eax
80105105:	8b 55 0c             	mov    0xc(%ebp),%edx
80105108:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010510b:	8b 45 08             	mov    0x8(%ebp),%eax
8010510e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105114:	8b 45 08             	mov    0x8(%ebp),%eax
80105117:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010511e:	90                   	nop
8010511f:	5d                   	pop    %ebp
80105120:	c3                   	ret    

80105121 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105121:	55                   	push   %ebp
80105122:	89 e5                	mov    %esp,%ebp
80105124:	53                   	push   %ebx
80105125:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105128:	e8 6f 01 00 00       	call   8010529c <pushcli>
  if(holding(lk))
8010512d:	8b 45 08             	mov    0x8(%ebp),%eax
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	50                   	push   %eax
80105134:	e8 22 01 00 00       	call   8010525b <holding>
80105139:	83 c4 10             	add    $0x10,%esp
8010513c:	85 c0                	test   %eax,%eax
8010513e:	74 0d                	je     8010514d <acquire+0x2c>
    panic("acquire");
80105140:	83 ec 0c             	sub    $0xc,%esp
80105143:	68 b8 8b 10 80       	push   $0x80108bb8
80105148:	e8 53 b4 ff ff       	call   801005a0 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
8010514d:	90                   	nop
8010514e:	8b 45 08             	mov    0x8(%ebp),%eax
80105151:	83 ec 08             	sub    $0x8,%esp
80105154:	6a 01                	push   $0x1
80105156:	50                   	push   %eax
80105157:	e8 89 ff ff ff       	call   801050e5 <xchg>
8010515c:	83 c4 10             	add    $0x10,%esp
8010515f:	85 c0                	test   %eax,%eax
80105161:	75 eb                	jne    8010514e <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80105163:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80105168:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010516b:	e8 50 f1 ff ff       	call   801042c0 <mycpu>
80105170:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80105173:	8b 45 08             	mov    0x8(%ebp),%eax
80105176:	83 c0 0c             	add    $0xc,%eax
80105179:	83 ec 08             	sub    $0x8,%esp
8010517c:	50                   	push   %eax
8010517d:	8d 45 08             	lea    0x8(%ebp),%eax
80105180:	50                   	push   %eax
80105181:	e8 5b 00 00 00       	call   801051e1 <getcallerpcs>
80105186:	83 c4 10             	add    $0x10,%esp
}
80105189:	90                   	nop
8010518a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010518d:	c9                   	leave  
8010518e:	c3                   	ret    

8010518f <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010518f:	55                   	push   %ebp
80105190:	89 e5                	mov    %esp,%ebp
80105192:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105195:	83 ec 0c             	sub    $0xc,%esp
80105198:	ff 75 08             	pushl  0x8(%ebp)
8010519b:	e8 bb 00 00 00       	call   8010525b <holding>
801051a0:	83 c4 10             	add    $0x10,%esp
801051a3:	85 c0                	test   %eax,%eax
801051a5:	75 0d                	jne    801051b4 <release+0x25>
    panic("release");
801051a7:	83 ec 0c             	sub    $0xc,%esp
801051aa:	68 c0 8b 10 80       	push   $0x80108bc0
801051af:	e8 ec b3 ff ff       	call   801005a0 <panic>

  lk->pcs[0] = 0;
801051b4:	8b 45 08             	mov    0x8(%ebp),%eax
801051b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801051be:	8b 45 08             	mov    0x8(%ebp),%eax
801051c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801051c8:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801051cd:	8b 45 08             	mov    0x8(%ebp),%eax
801051d0:	8b 55 08             	mov    0x8(%ebp),%edx
801051d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
801051d9:	e8 0c 01 00 00       	call   801052ea <popcli>
}
801051de:	90                   	nop
801051df:	c9                   	leave  
801051e0:	c3                   	ret    

801051e1 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801051e1:	55                   	push   %ebp
801051e2:	89 e5                	mov    %esp,%ebp
801051e4:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801051e7:	8b 45 08             	mov    0x8(%ebp),%eax
801051ea:	83 e8 08             	sub    $0x8,%eax
801051ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801051f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801051f7:	eb 38                	jmp    80105231 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801051f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801051fd:	74 53                	je     80105252 <getcallerpcs+0x71>
801051ff:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105206:	76 4a                	jbe    80105252 <getcallerpcs+0x71>
80105208:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010520c:	74 44                	je     80105252 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010520e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105211:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105218:	8b 45 0c             	mov    0xc(%ebp),%eax
8010521b:	01 c2                	add    %eax,%edx
8010521d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105220:	8b 40 04             	mov    0x4(%eax),%eax
80105223:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105225:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105228:	8b 00                	mov    (%eax),%eax
8010522a:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010522d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105231:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105235:	7e c2                	jle    801051f9 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105237:	eb 19                	jmp    80105252 <getcallerpcs+0x71>
    pcs[i] = 0;
80105239:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010523c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105243:	8b 45 0c             	mov    0xc(%ebp),%eax
80105246:	01 d0                	add    %edx,%eax
80105248:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010524e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105252:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105256:	7e e1                	jle    80105239 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105258:	90                   	nop
80105259:	c9                   	leave  
8010525a:	c3                   	ret    

8010525b <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010525b:	55                   	push   %ebp
8010525c:	89 e5                	mov    %esp,%ebp
8010525e:	53                   	push   %ebx
8010525f:	83 ec 14             	sub    $0x14,%esp
  int r;
  pushcli();
80105262:	e8 35 00 00 00       	call   8010529c <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105267:	8b 45 08             	mov    0x8(%ebp),%eax
8010526a:	8b 00                	mov    (%eax),%eax
8010526c:	85 c0                	test   %eax,%eax
8010526e:	74 16                	je     80105286 <holding+0x2b>
80105270:	8b 45 08             	mov    0x8(%ebp),%eax
80105273:	8b 58 08             	mov    0x8(%eax),%ebx
80105276:	e8 45 f0 ff ff       	call   801042c0 <mycpu>
8010527b:	39 c3                	cmp    %eax,%ebx
8010527d:	75 07                	jne    80105286 <holding+0x2b>
8010527f:	b8 01 00 00 00       	mov    $0x1,%eax
80105284:	eb 05                	jmp    8010528b <holding+0x30>
80105286:	b8 00 00 00 00       	mov    $0x0,%eax
8010528b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
8010528e:	e8 57 00 00 00       	call   801052ea <popcli>
  return r;
80105293:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105296:	83 c4 14             	add    $0x14,%esp
80105299:	5b                   	pop    %ebx
8010529a:	5d                   	pop    %ebp
8010529b:	c3                   	ret    

8010529c <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010529c:	55                   	push   %ebp
8010529d:	89 e5                	mov    %esp,%ebp
8010529f:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
801052a2:	e8 20 fe ff ff       	call   801050c7 <readeflags>
801052a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
801052aa:	e8 28 fe ff ff       	call   801050d7 <cli>
  if(mycpu()->ncli == 0)
801052af:	e8 0c f0 ff ff       	call   801042c0 <mycpu>
801052b4:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801052ba:	85 c0                	test   %eax,%eax
801052bc:	75 15                	jne    801052d3 <pushcli+0x37>
    mycpu()->intena = eflags & FL_IF;
801052be:	e8 fd ef ff ff       	call   801042c0 <mycpu>
801052c3:	89 c2                	mov    %eax,%edx
801052c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c8:	25 00 02 00 00       	and    $0x200,%eax
801052cd:	89 82 a8 00 00 00    	mov    %eax,0xa8(%edx)
  mycpu()->ncli += 1;
801052d3:	e8 e8 ef ff ff       	call   801042c0 <mycpu>
801052d8:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801052de:	83 c2 01             	add    $0x1,%edx
801052e1:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
801052e7:	90                   	nop
801052e8:	c9                   	leave  
801052e9:	c3                   	ret    

801052ea <popcli>:

void
popcli(void)
{
801052ea:	55                   	push   %ebp
801052eb:	89 e5                	mov    %esp,%ebp
801052ed:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801052f0:	e8 d2 fd ff ff       	call   801050c7 <readeflags>
801052f5:	25 00 02 00 00       	and    $0x200,%eax
801052fa:	85 c0                	test   %eax,%eax
801052fc:	74 0d                	je     8010530b <popcli+0x21>
    panic("popcli - interruptible");
801052fe:	83 ec 0c             	sub    $0xc,%esp
80105301:	68 c8 8b 10 80       	push   $0x80108bc8
80105306:	e8 95 b2 ff ff       	call   801005a0 <panic>
  if(--mycpu()->ncli < 0)
8010530b:	e8 b0 ef ff ff       	call   801042c0 <mycpu>
80105310:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105316:	83 ea 01             	sub    $0x1,%edx
80105319:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
8010531f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105325:	85 c0                	test   %eax,%eax
80105327:	79 0d                	jns    80105336 <popcli+0x4c>
    panic("popcli");
80105329:	83 ec 0c             	sub    $0xc,%esp
8010532c:	68 df 8b 10 80       	push   $0x80108bdf
80105331:	e8 6a b2 ff ff       	call   801005a0 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105336:	e8 85 ef ff ff       	call   801042c0 <mycpu>
8010533b:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105341:	85 c0                	test   %eax,%eax
80105343:	75 14                	jne    80105359 <popcli+0x6f>
80105345:	e8 76 ef ff ff       	call   801042c0 <mycpu>
8010534a:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105350:	85 c0                	test   %eax,%eax
80105352:	74 05                	je     80105359 <popcli+0x6f>
    sti();
80105354:	e8 85 fd ff ff       	call   801050de <sti>
}
80105359:	90                   	nop
8010535a:	c9                   	leave  
8010535b:	c3                   	ret    

8010535c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010535c:	55                   	push   %ebp
8010535d:	89 e5                	mov    %esp,%ebp
8010535f:	57                   	push   %edi
80105360:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105361:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105364:	8b 55 10             	mov    0x10(%ebp),%edx
80105367:	8b 45 0c             	mov    0xc(%ebp),%eax
8010536a:	89 cb                	mov    %ecx,%ebx
8010536c:	89 df                	mov    %ebx,%edi
8010536e:	89 d1                	mov    %edx,%ecx
80105370:	fc                   	cld    
80105371:	f3 aa                	rep stos %al,%es:(%edi)
80105373:	89 ca                	mov    %ecx,%edx
80105375:	89 fb                	mov    %edi,%ebx
80105377:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010537a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010537d:	90                   	nop
8010537e:	5b                   	pop    %ebx
8010537f:	5f                   	pop    %edi
80105380:	5d                   	pop    %ebp
80105381:	c3                   	ret    

80105382 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105382:	55                   	push   %ebp
80105383:	89 e5                	mov    %esp,%ebp
80105385:	57                   	push   %edi
80105386:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105387:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010538a:	8b 55 10             	mov    0x10(%ebp),%edx
8010538d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105390:	89 cb                	mov    %ecx,%ebx
80105392:	89 df                	mov    %ebx,%edi
80105394:	89 d1                	mov    %edx,%ecx
80105396:	fc                   	cld    
80105397:	f3 ab                	rep stos %eax,%es:(%edi)
80105399:	89 ca                	mov    %ecx,%edx
8010539b:	89 fb                	mov    %edi,%ebx
8010539d:	89 5d 08             	mov    %ebx,0x8(%ebp)
801053a0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801053a3:	90                   	nop
801053a4:	5b                   	pop    %ebx
801053a5:	5f                   	pop    %edi
801053a6:	5d                   	pop    %ebp
801053a7:	c3                   	ret    

801053a8 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801053a8:	55                   	push   %ebp
801053a9:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801053ab:	8b 45 08             	mov    0x8(%ebp),%eax
801053ae:	83 e0 03             	and    $0x3,%eax
801053b1:	85 c0                	test   %eax,%eax
801053b3:	75 43                	jne    801053f8 <memset+0x50>
801053b5:	8b 45 10             	mov    0x10(%ebp),%eax
801053b8:	83 e0 03             	and    $0x3,%eax
801053bb:	85 c0                	test   %eax,%eax
801053bd:	75 39                	jne    801053f8 <memset+0x50>
    c &= 0xFF;
801053bf:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801053c6:	8b 45 10             	mov    0x10(%ebp),%eax
801053c9:	c1 e8 02             	shr    $0x2,%eax
801053cc:	89 c1                	mov    %eax,%ecx
801053ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801053d1:	c1 e0 18             	shl    $0x18,%eax
801053d4:	89 c2                	mov    %eax,%edx
801053d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801053d9:	c1 e0 10             	shl    $0x10,%eax
801053dc:	09 c2                	or     %eax,%edx
801053de:	8b 45 0c             	mov    0xc(%ebp),%eax
801053e1:	c1 e0 08             	shl    $0x8,%eax
801053e4:	09 d0                	or     %edx,%eax
801053e6:	0b 45 0c             	or     0xc(%ebp),%eax
801053e9:	51                   	push   %ecx
801053ea:	50                   	push   %eax
801053eb:	ff 75 08             	pushl  0x8(%ebp)
801053ee:	e8 8f ff ff ff       	call   80105382 <stosl>
801053f3:	83 c4 0c             	add    $0xc,%esp
801053f6:	eb 12                	jmp    8010540a <memset+0x62>
  } else
    stosb(dst, c, n);
801053f8:	8b 45 10             	mov    0x10(%ebp),%eax
801053fb:	50                   	push   %eax
801053fc:	ff 75 0c             	pushl  0xc(%ebp)
801053ff:	ff 75 08             	pushl  0x8(%ebp)
80105402:	e8 55 ff ff ff       	call   8010535c <stosb>
80105407:	83 c4 0c             	add    $0xc,%esp
  return dst;
8010540a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010540d:	c9                   	leave  
8010540e:	c3                   	ret    

8010540f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010540f:	55                   	push   %ebp
80105410:	89 e5                	mov    %esp,%ebp
80105412:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80105415:	8b 45 08             	mov    0x8(%ebp),%eax
80105418:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010541b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010541e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105421:	eb 30                	jmp    80105453 <memcmp+0x44>
    if(*s1 != *s2)
80105423:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105426:	0f b6 10             	movzbl (%eax),%edx
80105429:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010542c:	0f b6 00             	movzbl (%eax),%eax
8010542f:	38 c2                	cmp    %al,%dl
80105431:	74 18                	je     8010544b <memcmp+0x3c>
      return *s1 - *s2;
80105433:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105436:	0f b6 00             	movzbl (%eax),%eax
80105439:	0f b6 d0             	movzbl %al,%edx
8010543c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010543f:	0f b6 00             	movzbl (%eax),%eax
80105442:	0f b6 c0             	movzbl %al,%eax
80105445:	29 c2                	sub    %eax,%edx
80105447:	89 d0                	mov    %edx,%eax
80105449:	eb 1a                	jmp    80105465 <memcmp+0x56>
    s1++, s2++;
8010544b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010544f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105453:	8b 45 10             	mov    0x10(%ebp),%eax
80105456:	8d 50 ff             	lea    -0x1(%eax),%edx
80105459:	89 55 10             	mov    %edx,0x10(%ebp)
8010545c:	85 c0                	test   %eax,%eax
8010545e:	75 c3                	jne    80105423 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105460:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105465:	c9                   	leave  
80105466:	c3                   	ret    

80105467 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105467:	55                   	push   %ebp
80105468:	89 e5                	mov    %esp,%ebp
8010546a:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010546d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105470:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105473:	8b 45 08             	mov    0x8(%ebp),%eax
80105476:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105479:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010547c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010547f:	73 54                	jae    801054d5 <memmove+0x6e>
80105481:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105484:	8b 45 10             	mov    0x10(%ebp),%eax
80105487:	01 d0                	add    %edx,%eax
80105489:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010548c:	76 47                	jbe    801054d5 <memmove+0x6e>
    s += n;
8010548e:	8b 45 10             	mov    0x10(%ebp),%eax
80105491:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105494:	8b 45 10             	mov    0x10(%ebp),%eax
80105497:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010549a:	eb 13                	jmp    801054af <memmove+0x48>
      *--d = *--s;
8010549c:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801054a0:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801054a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054a7:	0f b6 10             	movzbl (%eax),%edx
801054aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054ad:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801054af:	8b 45 10             	mov    0x10(%ebp),%eax
801054b2:	8d 50 ff             	lea    -0x1(%eax),%edx
801054b5:	89 55 10             	mov    %edx,0x10(%ebp)
801054b8:	85 c0                	test   %eax,%eax
801054ba:	75 e0                	jne    8010549c <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801054bc:	eb 24                	jmp    801054e2 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801054be:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054c1:	8d 50 01             	lea    0x1(%eax),%edx
801054c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
801054c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054ca:	8d 4a 01             	lea    0x1(%edx),%ecx
801054cd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801054d0:	0f b6 12             	movzbl (%edx),%edx
801054d3:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801054d5:	8b 45 10             	mov    0x10(%ebp),%eax
801054d8:	8d 50 ff             	lea    -0x1(%eax),%edx
801054db:	89 55 10             	mov    %edx,0x10(%ebp)
801054de:	85 c0                	test   %eax,%eax
801054e0:	75 dc                	jne    801054be <memmove+0x57>
      *d++ = *s++;

  return dst;
801054e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
801054e5:	c9                   	leave  
801054e6:	c3                   	ret    

801054e7 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801054e7:	55                   	push   %ebp
801054e8:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801054ea:	ff 75 10             	pushl  0x10(%ebp)
801054ed:	ff 75 0c             	pushl  0xc(%ebp)
801054f0:	ff 75 08             	pushl  0x8(%ebp)
801054f3:	e8 6f ff ff ff       	call   80105467 <memmove>
801054f8:	83 c4 0c             	add    $0xc,%esp
}
801054fb:	c9                   	leave  
801054fc:	c3                   	ret    

801054fd <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801054fd:	55                   	push   %ebp
801054fe:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105500:	eb 0c                	jmp    8010550e <strncmp+0x11>
    n--, p++, q++;
80105502:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105506:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010550a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010550e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105512:	74 1a                	je     8010552e <strncmp+0x31>
80105514:	8b 45 08             	mov    0x8(%ebp),%eax
80105517:	0f b6 00             	movzbl (%eax),%eax
8010551a:	84 c0                	test   %al,%al
8010551c:	74 10                	je     8010552e <strncmp+0x31>
8010551e:	8b 45 08             	mov    0x8(%ebp),%eax
80105521:	0f b6 10             	movzbl (%eax),%edx
80105524:	8b 45 0c             	mov    0xc(%ebp),%eax
80105527:	0f b6 00             	movzbl (%eax),%eax
8010552a:	38 c2                	cmp    %al,%dl
8010552c:	74 d4                	je     80105502 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010552e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105532:	75 07                	jne    8010553b <strncmp+0x3e>
    return 0;
80105534:	b8 00 00 00 00       	mov    $0x0,%eax
80105539:	eb 16                	jmp    80105551 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010553b:	8b 45 08             	mov    0x8(%ebp),%eax
8010553e:	0f b6 00             	movzbl (%eax),%eax
80105541:	0f b6 d0             	movzbl %al,%edx
80105544:	8b 45 0c             	mov    0xc(%ebp),%eax
80105547:	0f b6 00             	movzbl (%eax),%eax
8010554a:	0f b6 c0             	movzbl %al,%eax
8010554d:	29 c2                	sub    %eax,%edx
8010554f:	89 d0                	mov    %edx,%eax
}
80105551:	5d                   	pop    %ebp
80105552:	c3                   	ret    

80105553 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105553:	55                   	push   %ebp
80105554:	89 e5                	mov    %esp,%ebp
80105556:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105559:	8b 45 08             	mov    0x8(%ebp),%eax
8010555c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010555f:	90                   	nop
80105560:	8b 45 10             	mov    0x10(%ebp),%eax
80105563:	8d 50 ff             	lea    -0x1(%eax),%edx
80105566:	89 55 10             	mov    %edx,0x10(%ebp)
80105569:	85 c0                	test   %eax,%eax
8010556b:	7e 2c                	jle    80105599 <strncpy+0x46>
8010556d:	8b 45 08             	mov    0x8(%ebp),%eax
80105570:	8d 50 01             	lea    0x1(%eax),%edx
80105573:	89 55 08             	mov    %edx,0x8(%ebp)
80105576:	8b 55 0c             	mov    0xc(%ebp),%edx
80105579:	8d 4a 01             	lea    0x1(%edx),%ecx
8010557c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010557f:	0f b6 12             	movzbl (%edx),%edx
80105582:	88 10                	mov    %dl,(%eax)
80105584:	0f b6 00             	movzbl (%eax),%eax
80105587:	84 c0                	test   %al,%al
80105589:	75 d5                	jne    80105560 <strncpy+0xd>
    ;
  while(n-- > 0)
8010558b:	eb 0c                	jmp    80105599 <strncpy+0x46>
    *s++ = 0;
8010558d:	8b 45 08             	mov    0x8(%ebp),%eax
80105590:	8d 50 01             	lea    0x1(%eax),%edx
80105593:	89 55 08             	mov    %edx,0x8(%ebp)
80105596:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105599:	8b 45 10             	mov    0x10(%ebp),%eax
8010559c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010559f:	89 55 10             	mov    %edx,0x10(%ebp)
801055a2:	85 c0                	test   %eax,%eax
801055a4:	7f e7                	jg     8010558d <strncpy+0x3a>
    *s++ = 0;
  return os;
801055a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055a9:	c9                   	leave  
801055aa:	c3                   	ret    

801055ab <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801055ab:	55                   	push   %ebp
801055ac:	89 e5                	mov    %esp,%ebp
801055ae:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801055b1:	8b 45 08             	mov    0x8(%ebp),%eax
801055b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801055b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055bb:	7f 05                	jg     801055c2 <safestrcpy+0x17>
    return os;
801055bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055c0:	eb 31                	jmp    801055f3 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801055c2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801055c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055ca:	7e 1e                	jle    801055ea <safestrcpy+0x3f>
801055cc:	8b 45 08             	mov    0x8(%ebp),%eax
801055cf:	8d 50 01             	lea    0x1(%eax),%edx
801055d2:	89 55 08             	mov    %edx,0x8(%ebp)
801055d5:	8b 55 0c             	mov    0xc(%ebp),%edx
801055d8:	8d 4a 01             	lea    0x1(%edx),%ecx
801055db:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801055de:	0f b6 12             	movzbl (%edx),%edx
801055e1:	88 10                	mov    %dl,(%eax)
801055e3:	0f b6 00             	movzbl (%eax),%eax
801055e6:	84 c0                	test   %al,%al
801055e8:	75 d8                	jne    801055c2 <safestrcpy+0x17>
    ;
  *s = 0;
801055ea:	8b 45 08             	mov    0x8(%ebp),%eax
801055ed:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801055f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055f3:	c9                   	leave  
801055f4:	c3                   	ret    

801055f5 <strlen>:

int
strlen(const char *s)
{
801055f5:	55                   	push   %ebp
801055f6:	89 e5                	mov    %esp,%ebp
801055f8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801055fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105602:	eb 04                	jmp    80105608 <strlen+0x13>
80105604:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105608:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010560b:	8b 45 08             	mov    0x8(%ebp),%eax
8010560e:	01 d0                	add    %edx,%eax
80105610:	0f b6 00             	movzbl (%eax),%eax
80105613:	84 c0                	test   %al,%al
80105615:	75 ed                	jne    80105604 <strlen+0xf>
    ;
  return n;
80105617:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010561a:	c9                   	leave  
8010561b:	c3                   	ret    

8010561c <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010561c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105620:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105624:	55                   	push   %ebp
  pushl %ebx
80105625:	53                   	push   %ebx
  pushl %esi
80105626:	56                   	push   %esi
  pushl %edi
80105627:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105628:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010562a:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010562c:	5f                   	pop    %edi
  popl %esi
8010562d:	5e                   	pop    %esi
  popl %ebx
8010562e:	5b                   	pop    %ebx
  popl %ebp
8010562f:	5d                   	pop    %ebp
  ret
80105630:	c3                   	ret    

80105631 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105631:	55                   	push   %ebp
80105632:	89 e5                	mov    %esp,%ebp
80105634:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105637:	e8 fc ec ff ff       	call   80104338 <myproc>
8010563c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010563f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105642:	8b 00                	mov    (%eax),%eax
80105644:	3b 45 08             	cmp    0x8(%ebp),%eax
80105647:	76 0f                	jbe    80105658 <fetchint+0x27>
80105649:	8b 45 08             	mov    0x8(%ebp),%eax
8010564c:	8d 50 04             	lea    0x4(%eax),%edx
8010564f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105652:	8b 00                	mov    (%eax),%eax
80105654:	39 c2                	cmp    %eax,%edx
80105656:	76 07                	jbe    8010565f <fetchint+0x2e>
    return -1;
80105658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565d:	eb 0f                	jmp    8010566e <fetchint+0x3d>
  *ip = *(int*)(addr);
8010565f:	8b 45 08             	mov    0x8(%ebp),%eax
80105662:	8b 10                	mov    (%eax),%edx
80105664:	8b 45 0c             	mov    0xc(%ebp),%eax
80105667:	89 10                	mov    %edx,(%eax)
  return 0;
80105669:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010566e:	c9                   	leave  
8010566f:	c3                   	ret    

80105670 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105676:	e8 bd ec ff ff       	call   80104338 <myproc>
8010567b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
8010567e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105681:	8b 00                	mov    (%eax),%eax
80105683:	3b 45 08             	cmp    0x8(%ebp),%eax
80105686:	77 07                	ja     8010568f <fetchstr+0x1f>
    return -1;
80105688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568d:	eb 43                	jmp    801056d2 <fetchstr+0x62>
  *pp = (char*)addr;
8010568f:	8b 55 08             	mov    0x8(%ebp),%edx
80105692:	8b 45 0c             	mov    0xc(%ebp),%eax
80105695:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105697:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010569a:	8b 00                	mov    (%eax),%eax
8010569c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
8010569f:	8b 45 0c             	mov    0xc(%ebp),%eax
801056a2:	8b 00                	mov    (%eax),%eax
801056a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056a7:	eb 1c                	jmp    801056c5 <fetchstr+0x55>
    if(*s == 0)
801056a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ac:	0f b6 00             	movzbl (%eax),%eax
801056af:	84 c0                	test   %al,%al
801056b1:	75 0e                	jne    801056c1 <fetchstr+0x51>
      return s - *pp;
801056b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801056b9:	8b 00                	mov    (%eax),%eax
801056bb:	29 c2                	sub    %eax,%edx
801056bd:	89 d0                	mov    %edx,%eax
801056bf:	eb 11                	jmp    801056d2 <fetchstr+0x62>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801056c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801056c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801056cb:	72 dc                	jb     801056a9 <fetchstr+0x39>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
801056cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056d2:	c9                   	leave  
801056d3:	c3                   	ret    

801056d4 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801056da:	e8 59 ec ff ff       	call   80104338 <myproc>
801056df:	8b 40 18             	mov    0x18(%eax),%eax
801056e2:	8b 40 44             	mov    0x44(%eax),%eax
801056e5:	8b 55 08             	mov    0x8(%ebp),%edx
801056e8:	c1 e2 02             	shl    $0x2,%edx
801056eb:	01 d0                	add    %edx,%eax
801056ed:	83 c0 04             	add    $0x4,%eax
801056f0:	83 ec 08             	sub    $0x8,%esp
801056f3:	ff 75 0c             	pushl  0xc(%ebp)
801056f6:	50                   	push   %eax
801056f7:	e8 35 ff ff ff       	call   80105631 <fetchint>
801056fc:	83 c4 10             	add    $0x10,%esp
}
801056ff:	c9                   	leave  
80105700:	c3                   	ret    

80105701 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105701:	55                   	push   %ebp
80105702:	89 e5                	mov    %esp,%ebp
80105704:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80105707:	e8 2c ec ff ff       	call   80104338 <myproc>
8010570c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
8010570f:	83 ec 08             	sub    $0x8,%esp
80105712:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105715:	50                   	push   %eax
80105716:	ff 75 08             	pushl  0x8(%ebp)
80105719:	e8 b6 ff ff ff       	call   801056d4 <argint>
8010571e:	83 c4 10             	add    $0x10,%esp
80105721:	85 c0                	test   %eax,%eax
80105723:	79 07                	jns    8010572c <argptr+0x2b>
    return -1;
80105725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572a:	eb 42                	jmp    8010576e <argptr+0x6d>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz || (uint)i == 0)
8010572c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105730:	78 26                	js     80105758 <argptr+0x57>
80105732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105735:	8b 00                	mov    (%eax),%eax
80105737:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010573a:	39 d0                	cmp    %edx,%eax
8010573c:	76 1a                	jbe    80105758 <argptr+0x57>
8010573e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105741:	89 c2                	mov    %eax,%edx
80105743:	8b 45 10             	mov    0x10(%ebp),%eax
80105746:	01 c2                	add    %eax,%edx
80105748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574b:	8b 00                	mov    (%eax),%eax
8010574d:	39 c2                	cmp    %eax,%edx
8010574f:	77 07                	ja     80105758 <argptr+0x57>
80105751:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105754:	85 c0                	test   %eax,%eax
80105756:	75 07                	jne    8010575f <argptr+0x5e>
    return -1;
80105758:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575d:	eb 0f                	jmp    8010576e <argptr+0x6d>
  *pp = (char*)i;
8010575f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105762:	89 c2                	mov    %eax,%edx
80105764:	8b 45 0c             	mov    0xc(%ebp),%eax
80105767:	89 10                	mov    %edx,(%eax)
  return 0;
80105769:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010576e:	c9                   	leave  
8010576f:	c3                   	ret    

80105770 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105776:	83 ec 08             	sub    $0x8,%esp
80105779:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010577c:	50                   	push   %eax
8010577d:	ff 75 08             	pushl  0x8(%ebp)
80105780:	e8 4f ff ff ff       	call   801056d4 <argint>
80105785:	83 c4 10             	add    $0x10,%esp
80105788:	85 c0                	test   %eax,%eax
8010578a:	79 07                	jns    80105793 <argstr+0x23>
    return -1;
8010578c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105791:	eb 12                	jmp    801057a5 <argstr+0x35>
  return fetchstr(addr, pp);
80105793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105796:	83 ec 08             	sub    $0x8,%esp
80105799:	ff 75 0c             	pushl  0xc(%ebp)
8010579c:	50                   	push   %eax
8010579d:	e8 ce fe ff ff       	call   80105670 <fetchstr>
801057a2:	83 c4 10             	add    $0x10,%esp
}
801057a5:	c9                   	leave  
801057a6:	c3                   	ret    

801057a7 <syscall>:
[SYS_shmem_count] sys_shmem_count
};

void
syscall(void)
{
801057a7:	55                   	push   %ebp
801057a8:	89 e5                	mov    %esp,%ebp
801057aa:	53                   	push   %ebx
801057ab:	83 ec 14             	sub    $0x14,%esp
  int num;
  struct proc *curproc = myproc();
801057ae:	e8 85 eb ff ff       	call   80104338 <myproc>
801057b3:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
801057b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b9:	8b 40 18             	mov    0x18(%eax),%eax
801057bc:	8b 40 1c             	mov    0x1c(%eax),%eax
801057bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801057c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801057c6:	7e 2d                	jle    801057f5 <syscall+0x4e>
801057c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057cb:	83 f8 18             	cmp    $0x18,%eax
801057ce:	77 25                	ja     801057f5 <syscall+0x4e>
801057d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d3:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
801057da:	85 c0                	test   %eax,%eax
801057dc:	74 17                	je     801057f5 <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
801057de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e1:	8b 58 18             	mov    0x18(%eax),%ebx
801057e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057e7:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
801057ee:	ff d0                	call   *%eax
801057f0:	89 43 1c             	mov    %eax,0x1c(%ebx)
801057f3:	eb 2b                	jmp    80105820 <syscall+0x79>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801057f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f8:	8d 50 6c             	lea    0x6c(%eax),%edx

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801057fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057fe:	8b 40 10             	mov    0x10(%eax),%eax
80105801:	ff 75 f0             	pushl  -0x10(%ebp)
80105804:	52                   	push   %edx
80105805:	50                   	push   %eax
80105806:	68 e6 8b 10 80       	push   $0x80108be6
8010580b:	e8 f0 ab ff ff       	call   80100400 <cprintf>
80105810:	83 c4 10             	add    $0x10,%esp
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80105813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105816:	8b 40 18             	mov    0x18(%eax),%eax
80105819:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105820:	90                   	nop
80105821:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105824:	c9                   	leave  
80105825:	c3                   	ret    

80105826 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105826:	55                   	push   %ebp
80105827:	89 e5                	mov    %esp,%ebp
80105829:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010582c:	83 ec 08             	sub    $0x8,%esp
8010582f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105832:	50                   	push   %eax
80105833:	ff 75 08             	pushl  0x8(%ebp)
80105836:	e8 99 fe ff ff       	call   801056d4 <argint>
8010583b:	83 c4 10             	add    $0x10,%esp
8010583e:	85 c0                	test   %eax,%eax
80105840:	79 07                	jns    80105849 <argfd+0x23>
    return -1;
80105842:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105847:	eb 51                	jmp    8010589a <argfd+0x74>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105849:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010584c:	85 c0                	test   %eax,%eax
8010584e:	78 22                	js     80105872 <argfd+0x4c>
80105850:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105853:	83 f8 0f             	cmp    $0xf,%eax
80105856:	7f 1a                	jg     80105872 <argfd+0x4c>
80105858:	e8 db ea ff ff       	call   80104338 <myproc>
8010585d:	89 c2                	mov    %eax,%edx
8010585f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105862:	83 c0 08             	add    $0x8,%eax
80105865:	8b 44 82 08          	mov    0x8(%edx,%eax,4),%eax
80105869:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010586c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105870:	75 07                	jne    80105879 <argfd+0x53>
    return -1;
80105872:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105877:	eb 21                	jmp    8010589a <argfd+0x74>
  if(pfd)
80105879:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010587d:	74 08                	je     80105887 <argfd+0x61>
    *pfd = fd;
8010587f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105882:	8b 45 0c             	mov    0xc(%ebp),%eax
80105885:	89 10                	mov    %edx,(%eax)
  if(pf)
80105887:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010588b:	74 08                	je     80105895 <argfd+0x6f>
    *pf = f;
8010588d:	8b 45 10             	mov    0x10(%ebp),%eax
80105890:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105893:	89 10                	mov    %edx,(%eax)
  return 0;
80105895:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010589a:	c9                   	leave  
8010589b:	c3                   	ret    

8010589c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010589c:	55                   	push   %ebp
8010589d:	89 e5                	mov    %esp,%ebp
8010589f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801058a2:	e8 91 ea ff ff       	call   80104338 <myproc>
801058a7:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801058aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801058b1:	eb 2a                	jmp    801058dd <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
801058b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058b9:	83 c2 08             	add    $0x8,%edx
801058bc:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801058c0:	85 c0                	test   %eax,%eax
801058c2:	75 15                	jne    801058d9 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
801058c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058ca:	8d 4a 08             	lea    0x8(%edx),%ecx
801058cd:	8b 55 08             	mov    0x8(%ebp),%edx
801058d0:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801058d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058d7:	eb 0f                	jmp    801058e8 <fdalloc+0x4c>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801058d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801058dd:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801058e1:	7e d0                	jle    801058b3 <fdalloc+0x17>
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801058e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058e8:	c9                   	leave  
801058e9:	c3                   	ret    

801058ea <sys_dup>:

int
sys_dup(void)
{
801058ea:	55                   	push   %ebp
801058eb:	89 e5                	mov    %esp,%ebp
801058ed:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801058f0:	83 ec 04             	sub    $0x4,%esp
801058f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058f6:	50                   	push   %eax
801058f7:	6a 00                	push   $0x0
801058f9:	6a 00                	push   $0x0
801058fb:	e8 26 ff ff ff       	call   80105826 <argfd>
80105900:	83 c4 10             	add    $0x10,%esp
80105903:	85 c0                	test   %eax,%eax
80105905:	79 07                	jns    8010590e <sys_dup+0x24>
    return -1;
80105907:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590c:	eb 31                	jmp    8010593f <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010590e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105911:	83 ec 0c             	sub    $0xc,%esp
80105914:	50                   	push   %eax
80105915:	e8 82 ff ff ff       	call   8010589c <fdalloc>
8010591a:	83 c4 10             	add    $0x10,%esp
8010591d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105920:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105924:	79 07                	jns    8010592d <sys_dup+0x43>
    return -1;
80105926:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592b:	eb 12                	jmp    8010593f <sys_dup+0x55>
  filedup(f);
8010592d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	50                   	push   %eax
80105934:	e8 27 b7 ff ff       	call   80101060 <filedup>
80105939:	83 c4 10             	add    $0x10,%esp
  return fd;
8010593c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010593f:	c9                   	leave  
80105940:	c3                   	ret    

80105941 <sys_read>:

int
sys_read(void)
{
80105941:	55                   	push   %ebp
80105942:	89 e5                	mov    %esp,%ebp
80105944:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105947:	83 ec 04             	sub    $0x4,%esp
8010594a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010594d:	50                   	push   %eax
8010594e:	6a 00                	push   $0x0
80105950:	6a 00                	push   $0x0
80105952:	e8 cf fe ff ff       	call   80105826 <argfd>
80105957:	83 c4 10             	add    $0x10,%esp
8010595a:	85 c0                	test   %eax,%eax
8010595c:	78 2e                	js     8010598c <sys_read+0x4b>
8010595e:	83 ec 08             	sub    $0x8,%esp
80105961:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105964:	50                   	push   %eax
80105965:	6a 02                	push   $0x2
80105967:	e8 68 fd ff ff       	call   801056d4 <argint>
8010596c:	83 c4 10             	add    $0x10,%esp
8010596f:	85 c0                	test   %eax,%eax
80105971:	78 19                	js     8010598c <sys_read+0x4b>
80105973:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105976:	83 ec 04             	sub    $0x4,%esp
80105979:	50                   	push   %eax
8010597a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010597d:	50                   	push   %eax
8010597e:	6a 01                	push   $0x1
80105980:	e8 7c fd ff ff       	call   80105701 <argptr>
80105985:	83 c4 10             	add    $0x10,%esp
80105988:	85 c0                	test   %eax,%eax
8010598a:	79 07                	jns    80105993 <sys_read+0x52>
    return -1;
8010598c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105991:	eb 17                	jmp    801059aa <sys_read+0x69>
  return fileread(f, p, n);
80105993:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105996:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105999:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010599c:	83 ec 04             	sub    $0x4,%esp
8010599f:	51                   	push   %ecx
801059a0:	52                   	push   %edx
801059a1:	50                   	push   %eax
801059a2:	e8 49 b8 ff ff       	call   801011f0 <fileread>
801059a7:	83 c4 10             	add    $0x10,%esp
}
801059aa:	c9                   	leave  
801059ab:	c3                   	ret    

801059ac <sys_write>:

int
sys_write(void)
{
801059ac:	55                   	push   %ebp
801059ad:	89 e5                	mov    %esp,%ebp
801059af:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059b2:	83 ec 04             	sub    $0x4,%esp
801059b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059b8:	50                   	push   %eax
801059b9:	6a 00                	push   $0x0
801059bb:	6a 00                	push   $0x0
801059bd:	e8 64 fe ff ff       	call   80105826 <argfd>
801059c2:	83 c4 10             	add    $0x10,%esp
801059c5:	85 c0                	test   %eax,%eax
801059c7:	78 2e                	js     801059f7 <sys_write+0x4b>
801059c9:	83 ec 08             	sub    $0x8,%esp
801059cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059cf:	50                   	push   %eax
801059d0:	6a 02                	push   $0x2
801059d2:	e8 fd fc ff ff       	call   801056d4 <argint>
801059d7:	83 c4 10             	add    $0x10,%esp
801059da:	85 c0                	test   %eax,%eax
801059dc:	78 19                	js     801059f7 <sys_write+0x4b>
801059de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e1:	83 ec 04             	sub    $0x4,%esp
801059e4:	50                   	push   %eax
801059e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059e8:	50                   	push   %eax
801059e9:	6a 01                	push   $0x1
801059eb:	e8 11 fd ff ff       	call   80105701 <argptr>
801059f0:	83 c4 10             	add    $0x10,%esp
801059f3:	85 c0                	test   %eax,%eax
801059f5:	79 07                	jns    801059fe <sys_write+0x52>
    return -1;
801059f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fc:	eb 17                	jmp    80105a15 <sys_write+0x69>
  return filewrite(f, p, n);
801059fe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105a01:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a07:	83 ec 04             	sub    $0x4,%esp
80105a0a:	51                   	push   %ecx
80105a0b:	52                   	push   %edx
80105a0c:	50                   	push   %eax
80105a0d:	e8 96 b8 ff ff       	call   801012a8 <filewrite>
80105a12:	83 c4 10             	add    $0x10,%esp
}
80105a15:	c9                   	leave  
80105a16:	c3                   	ret    

80105a17 <sys_close>:

int
sys_close(void)
{
80105a17:	55                   	push   %ebp
80105a18:	89 e5                	mov    %esp,%ebp
80105a1a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105a1d:	83 ec 04             	sub    $0x4,%esp
80105a20:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a23:	50                   	push   %eax
80105a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a27:	50                   	push   %eax
80105a28:	6a 00                	push   $0x0
80105a2a:	e8 f7 fd ff ff       	call   80105826 <argfd>
80105a2f:	83 c4 10             	add    $0x10,%esp
80105a32:	85 c0                	test   %eax,%eax
80105a34:	79 07                	jns    80105a3d <sys_close+0x26>
    return -1;
80105a36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3b:	eb 29                	jmp    80105a66 <sys_close+0x4f>
  myproc()->ofile[fd] = 0;
80105a3d:	e8 f6 e8 ff ff       	call   80104338 <myproc>
80105a42:	89 c2                	mov    %eax,%edx
80105a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a47:	83 c0 08             	add    $0x8,%eax
80105a4a:	c7 44 82 08 00 00 00 	movl   $0x0,0x8(%edx,%eax,4)
80105a51:	00 
  fileclose(f);
80105a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a55:	83 ec 0c             	sub    $0xc,%esp
80105a58:	50                   	push   %eax
80105a59:	e8 53 b6 ff ff       	call   801010b1 <fileclose>
80105a5e:	83 c4 10             	add    $0x10,%esp
  return 0;
80105a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a66:	c9                   	leave  
80105a67:	c3                   	ret    

80105a68 <sys_fstat>:

int
sys_fstat(void)
{
80105a68:	55                   	push   %ebp
80105a69:	89 e5                	mov    %esp,%ebp
80105a6b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a6e:	83 ec 04             	sub    $0x4,%esp
80105a71:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a74:	50                   	push   %eax
80105a75:	6a 00                	push   $0x0
80105a77:	6a 00                	push   $0x0
80105a79:	e8 a8 fd ff ff       	call   80105826 <argfd>
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
80105a83:	78 17                	js     80105a9c <sys_fstat+0x34>
80105a85:	83 ec 04             	sub    $0x4,%esp
80105a88:	6a 14                	push   $0x14
80105a8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a8d:	50                   	push   %eax
80105a8e:	6a 01                	push   $0x1
80105a90:	e8 6c fc ff ff       	call   80105701 <argptr>
80105a95:	83 c4 10             	add    $0x10,%esp
80105a98:	85 c0                	test   %eax,%eax
80105a9a:	79 07                	jns    80105aa3 <sys_fstat+0x3b>
    return -1;
80105a9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa1:	eb 13                	jmp    80105ab6 <sys_fstat+0x4e>
  return filestat(f, st);
80105aa3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa9:	83 ec 08             	sub    $0x8,%esp
80105aac:	52                   	push   %edx
80105aad:	50                   	push   %eax
80105aae:	e8 e6 b6 ff ff       	call   80101199 <filestat>
80105ab3:	83 c4 10             	add    $0x10,%esp
}
80105ab6:	c9                   	leave  
80105ab7:	c3                   	ret    

80105ab8 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105ab8:	55                   	push   %ebp
80105ab9:	89 e5                	mov    %esp,%ebp
80105abb:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105abe:	83 ec 08             	sub    $0x8,%esp
80105ac1:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ac4:	50                   	push   %eax
80105ac5:	6a 00                	push   $0x0
80105ac7:	e8 a4 fc ff ff       	call   80105770 <argstr>
80105acc:	83 c4 10             	add    $0x10,%esp
80105acf:	85 c0                	test   %eax,%eax
80105ad1:	78 15                	js     80105ae8 <sys_link+0x30>
80105ad3:	83 ec 08             	sub    $0x8,%esp
80105ad6:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105ad9:	50                   	push   %eax
80105ada:	6a 01                	push   $0x1
80105adc:	e8 8f fc ff ff       	call   80105770 <argstr>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	79 0a                	jns    80105af2 <sys_link+0x3a>
    return -1;
80105ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aed:	e9 68 01 00 00       	jmp    80105c5a <sys_link+0x1a2>

  begin_op();
80105af2:	e8 3e da ff ff       	call   80103535 <begin_op>
  if((ip = namei(old)) == 0){
80105af7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105afa:	83 ec 0c             	sub    $0xc,%esp
80105afd:	50                   	push   %eax
80105afe:	e8 4d ca ff ff       	call   80102550 <namei>
80105b03:	83 c4 10             	add    $0x10,%esp
80105b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b0d:	75 0f                	jne    80105b1e <sys_link+0x66>
    end_op();
80105b0f:	e8 ad da ff ff       	call   801035c1 <end_op>
    return -1;
80105b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b19:	e9 3c 01 00 00       	jmp    80105c5a <sys_link+0x1a2>
  }

  ilock(ip);
80105b1e:	83 ec 0c             	sub    $0xc,%esp
80105b21:	ff 75 f4             	pushl  -0xc(%ebp)
80105b24:	e8 e7 be ff ff       	call   80101a10 <ilock>
80105b29:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2f:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105b33:	66 83 f8 01          	cmp    $0x1,%ax
80105b37:	75 1d                	jne    80105b56 <sys_link+0x9e>
    iunlockput(ip);
80105b39:	83 ec 0c             	sub    $0xc,%esp
80105b3c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b3f:	e8 fd c0 ff ff       	call   80101c41 <iunlockput>
80105b44:	83 c4 10             	add    $0x10,%esp
    end_op();
80105b47:	e8 75 da ff ff       	call   801035c1 <end_op>
    return -1;
80105b4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b51:	e9 04 01 00 00       	jmp    80105c5a <sys_link+0x1a2>
  }

  ip->nlink++;
80105b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b59:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105b5d:	83 c0 01             	add    $0x1,%eax
80105b60:	89 c2                	mov    %eax,%edx
80105b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b65:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105b69:	83 ec 0c             	sub    $0xc,%esp
80105b6c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b6f:	e8 bf bc ff ff       	call   80101833 <iupdate>
80105b74:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105b77:	83 ec 0c             	sub    $0xc,%esp
80105b7a:	ff 75 f4             	pushl  -0xc(%ebp)
80105b7d:	e8 a1 bf ff ff       	call   80101b23 <iunlock>
80105b82:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105b85:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b88:	83 ec 08             	sub    $0x8,%esp
80105b8b:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105b8e:	52                   	push   %edx
80105b8f:	50                   	push   %eax
80105b90:	e8 d7 c9 ff ff       	call   8010256c <nameiparent>
80105b95:	83 c4 10             	add    $0x10,%esp
80105b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b9f:	74 71                	je     80105c12 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105ba1:	83 ec 0c             	sub    $0xc,%esp
80105ba4:	ff 75 f0             	pushl  -0x10(%ebp)
80105ba7:	e8 64 be ff ff       	call   80101a10 <ilock>
80105bac:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb2:	8b 10                	mov    (%eax),%edx
80105bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb7:	8b 00                	mov    (%eax),%eax
80105bb9:	39 c2                	cmp    %eax,%edx
80105bbb:	75 1d                	jne    80105bda <sys_link+0x122>
80105bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc0:	8b 40 04             	mov    0x4(%eax),%eax
80105bc3:	83 ec 04             	sub    $0x4,%esp
80105bc6:	50                   	push   %eax
80105bc7:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105bca:	50                   	push   %eax
80105bcb:	ff 75 f0             	pushl  -0x10(%ebp)
80105bce:	e8 e2 c6 ff ff       	call   801022b5 <dirlink>
80105bd3:	83 c4 10             	add    $0x10,%esp
80105bd6:	85 c0                	test   %eax,%eax
80105bd8:	79 10                	jns    80105bea <sys_link+0x132>
    iunlockput(dp);
80105bda:	83 ec 0c             	sub    $0xc,%esp
80105bdd:	ff 75 f0             	pushl  -0x10(%ebp)
80105be0:	e8 5c c0 ff ff       	call   80101c41 <iunlockput>
80105be5:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105be8:	eb 29                	jmp    80105c13 <sys_link+0x15b>
  }
  iunlockput(dp);
80105bea:	83 ec 0c             	sub    $0xc,%esp
80105bed:	ff 75 f0             	pushl  -0x10(%ebp)
80105bf0:	e8 4c c0 ff ff       	call   80101c41 <iunlockput>
80105bf5:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105bf8:	83 ec 0c             	sub    $0xc,%esp
80105bfb:	ff 75 f4             	pushl  -0xc(%ebp)
80105bfe:	e8 6e bf ff ff       	call   80101b71 <iput>
80105c03:	83 c4 10             	add    $0x10,%esp

  end_op();
80105c06:	e8 b6 d9 ff ff       	call   801035c1 <end_op>

  return 0;
80105c0b:	b8 00 00 00 00       	mov    $0x0,%eax
80105c10:	eb 48                	jmp    80105c5a <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105c12:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105c13:	83 ec 0c             	sub    $0xc,%esp
80105c16:	ff 75 f4             	pushl  -0xc(%ebp)
80105c19:	e8 f2 bd ff ff       	call   80101a10 <ilock>
80105c1e:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c24:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105c28:	83 e8 01             	sub    $0x1,%eax
80105c2b:	89 c2                	mov    %eax,%edx
80105c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c30:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105c34:	83 ec 0c             	sub    $0xc,%esp
80105c37:	ff 75 f4             	pushl  -0xc(%ebp)
80105c3a:	e8 f4 bb ff ff       	call   80101833 <iupdate>
80105c3f:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105c42:	83 ec 0c             	sub    $0xc,%esp
80105c45:	ff 75 f4             	pushl  -0xc(%ebp)
80105c48:	e8 f4 bf ff ff       	call   80101c41 <iunlockput>
80105c4d:	83 c4 10             	add    $0x10,%esp
  end_op();
80105c50:	e8 6c d9 ff ff       	call   801035c1 <end_op>
  return -1;
80105c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5a:	c9                   	leave  
80105c5b:	c3                   	ret    

80105c5c <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105c5c:	55                   	push   %ebp
80105c5d:	89 e5                	mov    %esp,%ebp
80105c5f:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c62:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105c69:	eb 40                	jmp    80105cab <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6e:	6a 10                	push   $0x10
80105c70:	50                   	push   %eax
80105c71:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c74:	50                   	push   %eax
80105c75:	ff 75 08             	pushl  0x8(%ebp)
80105c78:	e8 84 c2 ff ff       	call   80101f01 <readi>
80105c7d:	83 c4 10             	add    $0x10,%esp
80105c80:	83 f8 10             	cmp    $0x10,%eax
80105c83:	74 0d                	je     80105c92 <isdirempty+0x36>
      panic("isdirempty: readi");
80105c85:	83 ec 0c             	sub    $0xc,%esp
80105c88:	68 02 8c 10 80       	push   $0x80108c02
80105c8d:	e8 0e a9 ff ff       	call   801005a0 <panic>
    if(de.inum != 0)
80105c92:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105c96:	66 85 c0             	test   %ax,%ax
80105c99:	74 07                	je     80105ca2 <isdirempty+0x46>
      return 0;
80105c9b:	b8 00 00 00 00       	mov    $0x0,%eax
80105ca0:	eb 1b                	jmp    80105cbd <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca5:	83 c0 10             	add    $0x10,%eax
80105ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cab:	8b 45 08             	mov    0x8(%ebp),%eax
80105cae:	8b 50 58             	mov    0x58(%eax),%edx
80105cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb4:	39 c2                	cmp    %eax,%edx
80105cb6:	77 b3                	ja     80105c6b <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105cb8:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105cbd:	c9                   	leave  
80105cbe:	c3                   	ret    

80105cbf <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105cbf:	55                   	push   %ebp
80105cc0:	89 e5                	mov    %esp,%ebp
80105cc2:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105cc5:	83 ec 08             	sub    $0x8,%esp
80105cc8:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105ccb:	50                   	push   %eax
80105ccc:	6a 00                	push   $0x0
80105cce:	e8 9d fa ff ff       	call   80105770 <argstr>
80105cd3:	83 c4 10             	add    $0x10,%esp
80105cd6:	85 c0                	test   %eax,%eax
80105cd8:	79 0a                	jns    80105ce4 <sys_unlink+0x25>
    return -1;
80105cda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cdf:	e9 bc 01 00 00       	jmp    80105ea0 <sys_unlink+0x1e1>

  begin_op();
80105ce4:	e8 4c d8 ff ff       	call   80103535 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105ce9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105cec:	83 ec 08             	sub    $0x8,%esp
80105cef:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105cf2:	52                   	push   %edx
80105cf3:	50                   	push   %eax
80105cf4:	e8 73 c8 ff ff       	call   8010256c <nameiparent>
80105cf9:	83 c4 10             	add    $0x10,%esp
80105cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d03:	75 0f                	jne    80105d14 <sys_unlink+0x55>
    end_op();
80105d05:	e8 b7 d8 ff ff       	call   801035c1 <end_op>
    return -1;
80105d0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0f:	e9 8c 01 00 00       	jmp    80105ea0 <sys_unlink+0x1e1>
  }

  ilock(dp);
80105d14:	83 ec 0c             	sub    $0xc,%esp
80105d17:	ff 75 f4             	pushl  -0xc(%ebp)
80105d1a:	e8 f1 bc ff ff       	call   80101a10 <ilock>
80105d1f:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105d22:	83 ec 08             	sub    $0x8,%esp
80105d25:	68 14 8c 10 80       	push   $0x80108c14
80105d2a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d2d:	50                   	push   %eax
80105d2e:	e8 ad c4 ff ff       	call   801021e0 <namecmp>
80105d33:	83 c4 10             	add    $0x10,%esp
80105d36:	85 c0                	test   %eax,%eax
80105d38:	0f 84 4a 01 00 00    	je     80105e88 <sys_unlink+0x1c9>
80105d3e:	83 ec 08             	sub    $0x8,%esp
80105d41:	68 16 8c 10 80       	push   $0x80108c16
80105d46:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d49:	50                   	push   %eax
80105d4a:	e8 91 c4 ff ff       	call   801021e0 <namecmp>
80105d4f:	83 c4 10             	add    $0x10,%esp
80105d52:	85 c0                	test   %eax,%eax
80105d54:	0f 84 2e 01 00 00    	je     80105e88 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105d5a:	83 ec 04             	sub    $0x4,%esp
80105d5d:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105d60:	50                   	push   %eax
80105d61:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d64:	50                   	push   %eax
80105d65:	ff 75 f4             	pushl  -0xc(%ebp)
80105d68:	e8 8e c4 ff ff       	call   801021fb <dirlookup>
80105d6d:	83 c4 10             	add    $0x10,%esp
80105d70:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d77:	0f 84 0a 01 00 00    	je     80105e87 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105d7d:	83 ec 0c             	sub    $0xc,%esp
80105d80:	ff 75 f0             	pushl  -0x10(%ebp)
80105d83:	e8 88 bc ff ff       	call   80101a10 <ilock>
80105d88:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d8e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105d92:	66 85 c0             	test   %ax,%ax
80105d95:	7f 0d                	jg     80105da4 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105d97:	83 ec 0c             	sub    $0xc,%esp
80105d9a:	68 19 8c 10 80       	push   $0x80108c19
80105d9f:	e8 fc a7 ff ff       	call   801005a0 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da7:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105dab:	66 83 f8 01          	cmp    $0x1,%ax
80105daf:	75 25                	jne    80105dd6 <sys_unlink+0x117>
80105db1:	83 ec 0c             	sub    $0xc,%esp
80105db4:	ff 75 f0             	pushl  -0x10(%ebp)
80105db7:	e8 a0 fe ff ff       	call   80105c5c <isdirempty>
80105dbc:	83 c4 10             	add    $0x10,%esp
80105dbf:	85 c0                	test   %eax,%eax
80105dc1:	75 13                	jne    80105dd6 <sys_unlink+0x117>
    iunlockput(ip);
80105dc3:	83 ec 0c             	sub    $0xc,%esp
80105dc6:	ff 75 f0             	pushl  -0x10(%ebp)
80105dc9:	e8 73 be ff ff       	call   80101c41 <iunlockput>
80105dce:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105dd1:	e9 b2 00 00 00       	jmp    80105e88 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105dd6:	83 ec 04             	sub    $0x4,%esp
80105dd9:	6a 10                	push   $0x10
80105ddb:	6a 00                	push   $0x0
80105ddd:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105de0:	50                   	push   %eax
80105de1:	e8 c2 f5 ff ff       	call   801053a8 <memset>
80105de6:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105de9:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105dec:	6a 10                	push   $0x10
80105dee:	50                   	push   %eax
80105def:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105df2:	50                   	push   %eax
80105df3:	ff 75 f4             	pushl  -0xc(%ebp)
80105df6:	e8 5d c2 ff ff       	call   80102058 <writei>
80105dfb:	83 c4 10             	add    $0x10,%esp
80105dfe:	83 f8 10             	cmp    $0x10,%eax
80105e01:	74 0d                	je     80105e10 <sys_unlink+0x151>
    panic("unlink: writei");
80105e03:	83 ec 0c             	sub    $0xc,%esp
80105e06:	68 2b 8c 10 80       	push   $0x80108c2b
80105e0b:	e8 90 a7 ff ff       	call   801005a0 <panic>
  if(ip->type == T_DIR){
80105e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e13:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105e17:	66 83 f8 01          	cmp    $0x1,%ax
80105e1b:	75 21                	jne    80105e3e <sys_unlink+0x17f>
    dp->nlink--;
80105e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e20:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105e24:	83 e8 01             	sub    $0x1,%eax
80105e27:	89 c2                	mov    %eax,%edx
80105e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e2c:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105e30:	83 ec 0c             	sub    $0xc,%esp
80105e33:	ff 75 f4             	pushl  -0xc(%ebp)
80105e36:	e8 f8 b9 ff ff       	call   80101833 <iupdate>
80105e3b:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105e3e:	83 ec 0c             	sub    $0xc,%esp
80105e41:	ff 75 f4             	pushl  -0xc(%ebp)
80105e44:	e8 f8 bd ff ff       	call   80101c41 <iunlockput>
80105e49:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e4f:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105e53:	83 e8 01             	sub    $0x1,%eax
80105e56:	89 c2                	mov    %eax,%edx
80105e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5b:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105e5f:	83 ec 0c             	sub    $0xc,%esp
80105e62:	ff 75 f0             	pushl  -0x10(%ebp)
80105e65:	e8 c9 b9 ff ff       	call   80101833 <iupdate>
80105e6a:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105e6d:	83 ec 0c             	sub    $0xc,%esp
80105e70:	ff 75 f0             	pushl  -0x10(%ebp)
80105e73:	e8 c9 bd ff ff       	call   80101c41 <iunlockput>
80105e78:	83 c4 10             	add    $0x10,%esp

  end_op();
80105e7b:	e8 41 d7 ff ff       	call   801035c1 <end_op>

  return 0;
80105e80:	b8 00 00 00 00       	mov    $0x0,%eax
80105e85:	eb 19                	jmp    80105ea0 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105e87:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105e88:	83 ec 0c             	sub    $0xc,%esp
80105e8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105e8e:	e8 ae bd ff ff       	call   80101c41 <iunlockput>
80105e93:	83 c4 10             	add    $0x10,%esp
  end_op();
80105e96:	e8 26 d7 ff ff       	call   801035c1 <end_op>
  return -1;
80105e9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ea0:	c9                   	leave  
80105ea1:	c3                   	ret    

80105ea2 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105ea2:	55                   	push   %ebp
80105ea3:	89 e5                	mov    %esp,%ebp
80105ea5:	83 ec 38             	sub    $0x38,%esp
80105ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105eab:	8b 55 10             	mov    0x10(%ebp),%edx
80105eae:	8b 45 14             	mov    0x14(%ebp),%eax
80105eb1:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105eb5:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105eb9:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105ebd:	83 ec 08             	sub    $0x8,%esp
80105ec0:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ec3:	50                   	push   %eax
80105ec4:	ff 75 08             	pushl  0x8(%ebp)
80105ec7:	e8 a0 c6 ff ff       	call   8010256c <nameiparent>
80105ecc:	83 c4 10             	add    $0x10,%esp
80105ecf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ed2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ed6:	75 0a                	jne    80105ee2 <create+0x40>
    return 0;
80105ed8:	b8 00 00 00 00       	mov    $0x0,%eax
80105edd:	e9 90 01 00 00       	jmp    80106072 <create+0x1d0>
  ilock(dp);
80105ee2:	83 ec 0c             	sub    $0xc,%esp
80105ee5:	ff 75 f4             	pushl  -0xc(%ebp)
80105ee8:	e8 23 bb ff ff       	call   80101a10 <ilock>
80105eed:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105ef0:	83 ec 04             	sub    $0x4,%esp
80105ef3:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ef6:	50                   	push   %eax
80105ef7:	8d 45 de             	lea    -0x22(%ebp),%eax
80105efa:	50                   	push   %eax
80105efb:	ff 75 f4             	pushl  -0xc(%ebp)
80105efe:	e8 f8 c2 ff ff       	call   801021fb <dirlookup>
80105f03:	83 c4 10             	add    $0x10,%esp
80105f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f0d:	74 50                	je     80105f5f <create+0xbd>
    iunlockput(dp);
80105f0f:	83 ec 0c             	sub    $0xc,%esp
80105f12:	ff 75 f4             	pushl  -0xc(%ebp)
80105f15:	e8 27 bd ff ff       	call   80101c41 <iunlockput>
80105f1a:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105f1d:	83 ec 0c             	sub    $0xc,%esp
80105f20:	ff 75 f0             	pushl  -0x10(%ebp)
80105f23:	e8 e8 ba ff ff       	call   80101a10 <ilock>
80105f28:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105f2b:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105f30:	75 15                	jne    80105f47 <create+0xa5>
80105f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f35:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105f39:	66 83 f8 02          	cmp    $0x2,%ax
80105f3d:	75 08                	jne    80105f47 <create+0xa5>
      return ip;
80105f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f42:	e9 2b 01 00 00       	jmp    80106072 <create+0x1d0>
    iunlockput(ip);
80105f47:	83 ec 0c             	sub    $0xc,%esp
80105f4a:	ff 75 f0             	pushl  -0x10(%ebp)
80105f4d:	e8 ef bc ff ff       	call   80101c41 <iunlockput>
80105f52:	83 c4 10             	add    $0x10,%esp
    return 0;
80105f55:	b8 00 00 00 00       	mov    $0x0,%eax
80105f5a:	e9 13 01 00 00       	jmp    80106072 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105f5f:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f66:	8b 00                	mov    (%eax),%eax
80105f68:	83 ec 08             	sub    $0x8,%esp
80105f6b:	52                   	push   %edx
80105f6c:	50                   	push   %eax
80105f6d:	e8 ea b7 ff ff       	call   8010175c <ialloc>
80105f72:	83 c4 10             	add    $0x10,%esp
80105f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f7c:	75 0d                	jne    80105f8b <create+0xe9>
    panic("create: ialloc");
80105f7e:	83 ec 0c             	sub    $0xc,%esp
80105f81:	68 3a 8c 10 80       	push   $0x80108c3a
80105f86:	e8 15 a6 ff ff       	call   801005a0 <panic>

  ilock(ip);
80105f8b:	83 ec 0c             	sub    $0xc,%esp
80105f8e:	ff 75 f0             	pushl  -0x10(%ebp)
80105f91:	e8 7a ba ff ff       	call   80101a10 <ilock>
80105f96:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f9c:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105fa0:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa7:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105fab:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fb2:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105fb8:	83 ec 0c             	sub    $0xc,%esp
80105fbb:	ff 75 f0             	pushl  -0x10(%ebp)
80105fbe:	e8 70 b8 ff ff       	call   80101833 <iupdate>
80105fc3:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105fc6:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105fcb:	75 6a                	jne    80106037 <create+0x195>
    dp->nlink++;  // for ".."
80105fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fd0:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105fd4:	83 c0 01             	add    $0x1,%eax
80105fd7:	89 c2                	mov    %eax,%edx
80105fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fdc:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	ff 75 f4             	pushl  -0xc(%ebp)
80105fe6:	e8 48 b8 ff ff       	call   80101833 <iupdate>
80105feb:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff1:	8b 40 04             	mov    0x4(%eax),%eax
80105ff4:	83 ec 04             	sub    $0x4,%esp
80105ff7:	50                   	push   %eax
80105ff8:	68 14 8c 10 80       	push   $0x80108c14
80105ffd:	ff 75 f0             	pushl  -0x10(%ebp)
80106000:	e8 b0 c2 ff ff       	call   801022b5 <dirlink>
80106005:	83 c4 10             	add    $0x10,%esp
80106008:	85 c0                	test   %eax,%eax
8010600a:	78 1e                	js     8010602a <create+0x188>
8010600c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010600f:	8b 40 04             	mov    0x4(%eax),%eax
80106012:	83 ec 04             	sub    $0x4,%esp
80106015:	50                   	push   %eax
80106016:	68 16 8c 10 80       	push   $0x80108c16
8010601b:	ff 75 f0             	pushl  -0x10(%ebp)
8010601e:	e8 92 c2 ff ff       	call   801022b5 <dirlink>
80106023:	83 c4 10             	add    $0x10,%esp
80106026:	85 c0                	test   %eax,%eax
80106028:	79 0d                	jns    80106037 <create+0x195>
      panic("create dots");
8010602a:	83 ec 0c             	sub    $0xc,%esp
8010602d:	68 49 8c 10 80       	push   $0x80108c49
80106032:	e8 69 a5 ff ff       	call   801005a0 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106037:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603a:	8b 40 04             	mov    0x4(%eax),%eax
8010603d:	83 ec 04             	sub    $0x4,%esp
80106040:	50                   	push   %eax
80106041:	8d 45 de             	lea    -0x22(%ebp),%eax
80106044:	50                   	push   %eax
80106045:	ff 75 f4             	pushl  -0xc(%ebp)
80106048:	e8 68 c2 ff ff       	call   801022b5 <dirlink>
8010604d:	83 c4 10             	add    $0x10,%esp
80106050:	85 c0                	test   %eax,%eax
80106052:	79 0d                	jns    80106061 <create+0x1bf>
    panic("create: dirlink");
80106054:	83 ec 0c             	sub    $0xc,%esp
80106057:	68 55 8c 10 80       	push   $0x80108c55
8010605c:	e8 3f a5 ff ff       	call   801005a0 <panic>

  iunlockput(dp);
80106061:	83 ec 0c             	sub    $0xc,%esp
80106064:	ff 75 f4             	pushl  -0xc(%ebp)
80106067:	e8 d5 bb ff ff       	call   80101c41 <iunlockput>
8010606c:	83 c4 10             	add    $0x10,%esp

  return ip;
8010606f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106072:	c9                   	leave  
80106073:	c3                   	ret    

80106074 <sys_open>:

int
sys_open(void)
{
80106074:	55                   	push   %ebp
80106075:	89 e5                	mov    %esp,%ebp
80106077:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010607a:	83 ec 08             	sub    $0x8,%esp
8010607d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106080:	50                   	push   %eax
80106081:	6a 00                	push   $0x0
80106083:	e8 e8 f6 ff ff       	call   80105770 <argstr>
80106088:	83 c4 10             	add    $0x10,%esp
8010608b:	85 c0                	test   %eax,%eax
8010608d:	78 15                	js     801060a4 <sys_open+0x30>
8010608f:	83 ec 08             	sub    $0x8,%esp
80106092:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106095:	50                   	push   %eax
80106096:	6a 01                	push   $0x1
80106098:	e8 37 f6 ff ff       	call   801056d4 <argint>
8010609d:	83 c4 10             	add    $0x10,%esp
801060a0:	85 c0                	test   %eax,%eax
801060a2:	79 0a                	jns    801060ae <sys_open+0x3a>
    return -1;
801060a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060a9:	e9 61 01 00 00       	jmp    8010620f <sys_open+0x19b>

  begin_op();
801060ae:	e8 82 d4 ff ff       	call   80103535 <begin_op>

  if(omode & O_CREATE){
801060b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060b6:	25 00 02 00 00       	and    $0x200,%eax
801060bb:	85 c0                	test   %eax,%eax
801060bd:	74 2a                	je     801060e9 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801060bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060c2:	6a 00                	push   $0x0
801060c4:	6a 00                	push   $0x0
801060c6:	6a 02                	push   $0x2
801060c8:	50                   	push   %eax
801060c9:	e8 d4 fd ff ff       	call   80105ea2 <create>
801060ce:	83 c4 10             	add    $0x10,%esp
801060d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801060d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060d8:	75 75                	jne    8010614f <sys_open+0xdb>
      end_op();
801060da:	e8 e2 d4 ff ff       	call   801035c1 <end_op>
      return -1;
801060df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e4:	e9 26 01 00 00       	jmp    8010620f <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801060e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060ec:	83 ec 0c             	sub    $0xc,%esp
801060ef:	50                   	push   %eax
801060f0:	e8 5b c4 ff ff       	call   80102550 <namei>
801060f5:	83 c4 10             	add    $0x10,%esp
801060f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060ff:	75 0f                	jne    80106110 <sys_open+0x9c>
      end_op();
80106101:	e8 bb d4 ff ff       	call   801035c1 <end_op>
      return -1;
80106106:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010610b:	e9 ff 00 00 00       	jmp    8010620f <sys_open+0x19b>
    }
    ilock(ip);
80106110:	83 ec 0c             	sub    $0xc,%esp
80106113:	ff 75 f4             	pushl  -0xc(%ebp)
80106116:	e8 f5 b8 ff ff       	call   80101a10 <ilock>
8010611b:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010611e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106121:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106125:	66 83 f8 01          	cmp    $0x1,%ax
80106129:	75 24                	jne    8010614f <sys_open+0xdb>
8010612b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010612e:	85 c0                	test   %eax,%eax
80106130:	74 1d                	je     8010614f <sys_open+0xdb>
      iunlockput(ip);
80106132:	83 ec 0c             	sub    $0xc,%esp
80106135:	ff 75 f4             	pushl  -0xc(%ebp)
80106138:	e8 04 bb ff ff       	call   80101c41 <iunlockput>
8010613d:	83 c4 10             	add    $0x10,%esp
      end_op();
80106140:	e8 7c d4 ff ff       	call   801035c1 <end_op>
      return -1;
80106145:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010614a:	e9 c0 00 00 00       	jmp    8010620f <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010614f:	e8 9f ae ff ff       	call   80100ff3 <filealloc>
80106154:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106157:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010615b:	74 17                	je     80106174 <sys_open+0x100>
8010615d:	83 ec 0c             	sub    $0xc,%esp
80106160:	ff 75 f0             	pushl  -0x10(%ebp)
80106163:	e8 34 f7 ff ff       	call   8010589c <fdalloc>
80106168:	83 c4 10             	add    $0x10,%esp
8010616b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010616e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106172:	79 2e                	jns    801061a2 <sys_open+0x12e>
    if(f)
80106174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106178:	74 0e                	je     80106188 <sys_open+0x114>
      fileclose(f);
8010617a:	83 ec 0c             	sub    $0xc,%esp
8010617d:	ff 75 f0             	pushl  -0x10(%ebp)
80106180:	e8 2c af ff ff       	call   801010b1 <fileclose>
80106185:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106188:	83 ec 0c             	sub    $0xc,%esp
8010618b:	ff 75 f4             	pushl  -0xc(%ebp)
8010618e:	e8 ae ba ff ff       	call   80101c41 <iunlockput>
80106193:	83 c4 10             	add    $0x10,%esp
    end_op();
80106196:	e8 26 d4 ff ff       	call   801035c1 <end_op>
    return -1;
8010619b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061a0:	eb 6d                	jmp    8010620f <sys_open+0x19b>
  }
  iunlock(ip);
801061a2:	83 ec 0c             	sub    $0xc,%esp
801061a5:	ff 75 f4             	pushl  -0xc(%ebp)
801061a8:	e8 76 b9 ff ff       	call   80101b23 <iunlock>
801061ad:	83 c4 10             	add    $0x10,%esp
  end_op();
801061b0:	e8 0c d4 ff ff       	call   801035c1 <end_op>

  f->type = FD_INODE;
801061b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061b8:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801061be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061c4:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801061c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ca:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801061d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061d4:	83 e0 01             	and    $0x1,%eax
801061d7:	85 c0                	test   %eax,%eax
801061d9:	0f 94 c0             	sete   %al
801061dc:	89 c2                	mov    %eax,%edx
801061de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061e1:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061e7:	83 e0 01             	and    $0x1,%eax
801061ea:	85 c0                	test   %eax,%eax
801061ec:	75 0a                	jne    801061f8 <sys_open+0x184>
801061ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061f1:	83 e0 02             	and    $0x2,%eax
801061f4:	85 c0                	test   %eax,%eax
801061f6:	74 07                	je     801061ff <sys_open+0x18b>
801061f8:	b8 01 00 00 00       	mov    $0x1,%eax
801061fd:	eb 05                	jmp    80106204 <sys_open+0x190>
801061ff:	b8 00 00 00 00       	mov    $0x0,%eax
80106204:	89 c2                	mov    %eax,%edx
80106206:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106209:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010620c:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010620f:	c9                   	leave  
80106210:	c3                   	ret    

80106211 <sys_mkdir>:

int
sys_mkdir(void)
{
80106211:	55                   	push   %ebp
80106212:	89 e5                	mov    %esp,%ebp
80106214:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106217:	e8 19 d3 ff ff       	call   80103535 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010621c:	83 ec 08             	sub    $0x8,%esp
8010621f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106222:	50                   	push   %eax
80106223:	6a 00                	push   $0x0
80106225:	e8 46 f5 ff ff       	call   80105770 <argstr>
8010622a:	83 c4 10             	add    $0x10,%esp
8010622d:	85 c0                	test   %eax,%eax
8010622f:	78 1b                	js     8010624c <sys_mkdir+0x3b>
80106231:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106234:	6a 00                	push   $0x0
80106236:	6a 00                	push   $0x0
80106238:	6a 01                	push   $0x1
8010623a:	50                   	push   %eax
8010623b:	e8 62 fc ff ff       	call   80105ea2 <create>
80106240:	83 c4 10             	add    $0x10,%esp
80106243:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106246:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010624a:	75 0c                	jne    80106258 <sys_mkdir+0x47>
    end_op();
8010624c:	e8 70 d3 ff ff       	call   801035c1 <end_op>
    return -1;
80106251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106256:	eb 18                	jmp    80106270 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106258:	83 ec 0c             	sub    $0xc,%esp
8010625b:	ff 75 f4             	pushl  -0xc(%ebp)
8010625e:	e8 de b9 ff ff       	call   80101c41 <iunlockput>
80106263:	83 c4 10             	add    $0x10,%esp
  end_op();
80106266:	e8 56 d3 ff ff       	call   801035c1 <end_op>
  return 0;
8010626b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106270:	c9                   	leave  
80106271:	c3                   	ret    

80106272 <sys_mknod>:

int
sys_mknod(void)
{
80106272:	55                   	push   %ebp
80106273:	89 e5                	mov    %esp,%ebp
80106275:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106278:	e8 b8 d2 ff ff       	call   80103535 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010627d:	83 ec 08             	sub    $0x8,%esp
80106280:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106283:	50                   	push   %eax
80106284:	6a 00                	push   $0x0
80106286:	e8 e5 f4 ff ff       	call   80105770 <argstr>
8010628b:	83 c4 10             	add    $0x10,%esp
8010628e:	85 c0                	test   %eax,%eax
80106290:	78 4f                	js     801062e1 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80106292:	83 ec 08             	sub    $0x8,%esp
80106295:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106298:	50                   	push   %eax
80106299:	6a 01                	push   $0x1
8010629b:	e8 34 f4 ff ff       	call   801056d4 <argint>
801062a0:	83 c4 10             	add    $0x10,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801062a3:	85 c0                	test   %eax,%eax
801062a5:	78 3a                	js     801062e1 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801062a7:	83 ec 08             	sub    $0x8,%esp
801062aa:	8d 45 e8             	lea    -0x18(%ebp),%eax
801062ad:	50                   	push   %eax
801062ae:	6a 02                	push   $0x2
801062b0:	e8 1f f4 ff ff       	call   801056d4 <argint>
801062b5:	83 c4 10             	add    $0x10,%esp
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801062b8:	85 c0                	test   %eax,%eax
801062ba:	78 25                	js     801062e1 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801062bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062bf:	0f bf c8             	movswl %ax,%ecx
801062c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062c5:	0f bf d0             	movswl %ax,%edx
801062c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801062cb:	51                   	push   %ecx
801062cc:	52                   	push   %edx
801062cd:	6a 03                	push   $0x3
801062cf:	50                   	push   %eax
801062d0:	e8 cd fb ff ff       	call   80105ea2 <create>
801062d5:	83 c4 10             	add    $0x10,%esp
801062d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062df:	75 0c                	jne    801062ed <sys_mknod+0x7b>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801062e1:	e8 db d2 ff ff       	call   801035c1 <end_op>
    return -1;
801062e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062eb:	eb 18                	jmp    80106305 <sys_mknod+0x93>
  }
  iunlockput(ip);
801062ed:	83 ec 0c             	sub    $0xc,%esp
801062f0:	ff 75 f4             	pushl  -0xc(%ebp)
801062f3:	e8 49 b9 ff ff       	call   80101c41 <iunlockput>
801062f8:	83 c4 10             	add    $0x10,%esp
  end_op();
801062fb:	e8 c1 d2 ff ff       	call   801035c1 <end_op>
  return 0;
80106300:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106305:	c9                   	leave  
80106306:	c3                   	ret    

80106307 <sys_chdir>:

int
sys_chdir(void)
{
80106307:	55                   	push   %ebp
80106308:	89 e5                	mov    %esp,%ebp
8010630a:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010630d:	e8 26 e0 ff ff       	call   80104338 <myproc>
80106312:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106315:	e8 1b d2 ff ff       	call   80103535 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010631a:	83 ec 08             	sub    $0x8,%esp
8010631d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106320:	50                   	push   %eax
80106321:	6a 00                	push   $0x0
80106323:	e8 48 f4 ff ff       	call   80105770 <argstr>
80106328:	83 c4 10             	add    $0x10,%esp
8010632b:	85 c0                	test   %eax,%eax
8010632d:	78 18                	js     80106347 <sys_chdir+0x40>
8010632f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106332:	83 ec 0c             	sub    $0xc,%esp
80106335:	50                   	push   %eax
80106336:	e8 15 c2 ff ff       	call   80102550 <namei>
8010633b:	83 c4 10             	add    $0x10,%esp
8010633e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106341:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106345:	75 0c                	jne    80106353 <sys_chdir+0x4c>
    end_op();
80106347:	e8 75 d2 ff ff       	call   801035c1 <end_op>
    return -1;
8010634c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106351:	eb 68                	jmp    801063bb <sys_chdir+0xb4>
  }
  ilock(ip);
80106353:	83 ec 0c             	sub    $0xc,%esp
80106356:	ff 75 f0             	pushl  -0x10(%ebp)
80106359:	e8 b2 b6 ff ff       	call   80101a10 <ilock>
8010635e:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106361:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106364:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106368:	66 83 f8 01          	cmp    $0x1,%ax
8010636c:	74 1a                	je     80106388 <sys_chdir+0x81>
    iunlockput(ip);
8010636e:	83 ec 0c             	sub    $0xc,%esp
80106371:	ff 75 f0             	pushl  -0x10(%ebp)
80106374:	e8 c8 b8 ff ff       	call   80101c41 <iunlockput>
80106379:	83 c4 10             	add    $0x10,%esp
    end_op();
8010637c:	e8 40 d2 ff ff       	call   801035c1 <end_op>
    return -1;
80106381:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106386:	eb 33                	jmp    801063bb <sys_chdir+0xb4>
  }
  iunlock(ip);
80106388:	83 ec 0c             	sub    $0xc,%esp
8010638b:	ff 75 f0             	pushl  -0x10(%ebp)
8010638e:	e8 90 b7 ff ff       	call   80101b23 <iunlock>
80106393:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80106396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106399:	8b 40 68             	mov    0x68(%eax),%eax
8010639c:	83 ec 0c             	sub    $0xc,%esp
8010639f:	50                   	push   %eax
801063a0:	e8 cc b7 ff ff       	call   80101b71 <iput>
801063a5:	83 c4 10             	add    $0x10,%esp
  end_op();
801063a8:	e8 14 d2 ff ff       	call   801035c1 <end_op>
  curproc->cwd = ip;
801063ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801063b3:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801063b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063bb:	c9                   	leave  
801063bc:	c3                   	ret    

801063bd <sys_exec>:

int
sys_exec(void)
{
801063bd:	55                   	push   %ebp
801063be:	89 e5                	mov    %esp,%ebp
801063c0:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801063c6:	83 ec 08             	sub    $0x8,%esp
801063c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063cc:	50                   	push   %eax
801063cd:	6a 00                	push   $0x0
801063cf:	e8 9c f3 ff ff       	call   80105770 <argstr>
801063d4:	83 c4 10             	add    $0x10,%esp
801063d7:	85 c0                	test   %eax,%eax
801063d9:	78 18                	js     801063f3 <sys_exec+0x36>
801063db:	83 ec 08             	sub    $0x8,%esp
801063de:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801063e4:	50                   	push   %eax
801063e5:	6a 01                	push   $0x1
801063e7:	e8 e8 f2 ff ff       	call   801056d4 <argint>
801063ec:	83 c4 10             	add    $0x10,%esp
801063ef:	85 c0                	test   %eax,%eax
801063f1:	79 0a                	jns    801063fd <sys_exec+0x40>
    return -1;
801063f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063f8:	e9 c6 00 00 00       	jmp    801064c3 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801063fd:	83 ec 04             	sub    $0x4,%esp
80106400:	68 80 00 00 00       	push   $0x80
80106405:	6a 00                	push   $0x0
80106407:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010640d:	50                   	push   %eax
8010640e:	e8 95 ef ff ff       	call   801053a8 <memset>
80106413:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106416:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010641d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106420:	83 f8 1f             	cmp    $0x1f,%eax
80106423:	76 0a                	jbe    8010642f <sys_exec+0x72>
      return -1;
80106425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642a:	e9 94 00 00 00       	jmp    801064c3 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010642f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106432:	c1 e0 02             	shl    $0x2,%eax
80106435:	89 c2                	mov    %eax,%edx
80106437:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010643d:	01 c2                	add    %eax,%edx
8010643f:	83 ec 08             	sub    $0x8,%esp
80106442:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106448:	50                   	push   %eax
80106449:	52                   	push   %edx
8010644a:	e8 e2 f1 ff ff       	call   80105631 <fetchint>
8010644f:	83 c4 10             	add    $0x10,%esp
80106452:	85 c0                	test   %eax,%eax
80106454:	79 07                	jns    8010645d <sys_exec+0xa0>
      return -1;
80106456:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010645b:	eb 66                	jmp    801064c3 <sys_exec+0x106>
    if(uarg == 0){
8010645d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106463:	85 c0                	test   %eax,%eax
80106465:	75 27                	jne    8010648e <sys_exec+0xd1>
      argv[i] = 0;
80106467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010646a:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106471:	00 00 00 00 
      break;
80106475:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106476:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106479:	83 ec 08             	sub    $0x8,%esp
8010647c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106482:	52                   	push   %edx
80106483:	50                   	push   %eax
80106484:	e8 0d a7 ff ff       	call   80100b96 <exec>
80106489:	83 c4 10             	add    $0x10,%esp
8010648c:	eb 35                	jmp    801064c3 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010648e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106494:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106497:	c1 e2 02             	shl    $0x2,%edx
8010649a:	01 c2                	add    %eax,%edx
8010649c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801064a2:	83 ec 08             	sub    $0x8,%esp
801064a5:	52                   	push   %edx
801064a6:	50                   	push   %eax
801064a7:	e8 c4 f1 ff ff       	call   80105670 <fetchstr>
801064ac:	83 c4 10             	add    $0x10,%esp
801064af:	85 c0                	test   %eax,%eax
801064b1:	79 07                	jns    801064ba <sys_exec+0xfd>
      return -1;
801064b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064b8:	eb 09                	jmp    801064c3 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801064ba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801064be:	e9 5a ff ff ff       	jmp    8010641d <sys_exec+0x60>
  return exec(path, argv);
}
801064c3:	c9                   	leave  
801064c4:	c3                   	ret    

801064c5 <sys_pipe>:

int
sys_pipe(void)
{
801064c5:	55                   	push   %ebp
801064c6:	89 e5                	mov    %esp,%ebp
801064c8:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801064cb:	83 ec 04             	sub    $0x4,%esp
801064ce:	6a 08                	push   $0x8
801064d0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064d3:	50                   	push   %eax
801064d4:	6a 00                	push   $0x0
801064d6:	e8 26 f2 ff ff       	call   80105701 <argptr>
801064db:	83 c4 10             	add    $0x10,%esp
801064de:	85 c0                	test   %eax,%eax
801064e0:	79 0a                	jns    801064ec <sys_pipe+0x27>
    return -1;
801064e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e7:	e9 b0 00 00 00       	jmp    8010659c <sys_pipe+0xd7>
  if(pipealloc(&rf, &wf) < 0)
801064ec:	83 ec 08             	sub    $0x8,%esp
801064ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064f2:	50                   	push   %eax
801064f3:	8d 45 e8             	lea    -0x18(%ebp),%eax
801064f6:	50                   	push   %eax
801064f7:	e8 c8 d8 ff ff       	call   80103dc4 <pipealloc>
801064fc:	83 c4 10             	add    $0x10,%esp
801064ff:	85 c0                	test   %eax,%eax
80106501:	79 0a                	jns    8010650d <sys_pipe+0x48>
    return -1;
80106503:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106508:	e9 8f 00 00 00       	jmp    8010659c <sys_pipe+0xd7>
  fd0 = -1;
8010650d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106514:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106517:	83 ec 0c             	sub    $0xc,%esp
8010651a:	50                   	push   %eax
8010651b:	e8 7c f3 ff ff       	call   8010589c <fdalloc>
80106520:	83 c4 10             	add    $0x10,%esp
80106523:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010652a:	78 18                	js     80106544 <sys_pipe+0x7f>
8010652c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010652f:	83 ec 0c             	sub    $0xc,%esp
80106532:	50                   	push   %eax
80106533:	e8 64 f3 ff ff       	call   8010589c <fdalloc>
80106538:	83 c4 10             	add    $0x10,%esp
8010653b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010653e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106542:	79 40                	jns    80106584 <sys_pipe+0xbf>
    if(fd0 >= 0)
80106544:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106548:	78 15                	js     8010655f <sys_pipe+0x9a>
      myproc()->ofile[fd0] = 0;
8010654a:	e8 e9 dd ff ff       	call   80104338 <myproc>
8010654f:	89 c2                	mov    %eax,%edx
80106551:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106554:	83 c0 08             	add    $0x8,%eax
80106557:	c7 44 82 08 00 00 00 	movl   $0x0,0x8(%edx,%eax,4)
8010655e:	00 
    fileclose(rf);
8010655f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106562:	83 ec 0c             	sub    $0xc,%esp
80106565:	50                   	push   %eax
80106566:	e8 46 ab ff ff       	call   801010b1 <fileclose>
8010656b:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010656e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106571:	83 ec 0c             	sub    $0xc,%esp
80106574:	50                   	push   %eax
80106575:	e8 37 ab ff ff       	call   801010b1 <fileclose>
8010657a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010657d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106582:	eb 18                	jmp    8010659c <sys_pipe+0xd7>
  }
  fd[0] = fd0;
80106584:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106587:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010658a:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010658c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010658f:	8d 50 04             	lea    0x4(%eax),%edx
80106592:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106595:	89 02                	mov    %eax,(%edx)
  return 0;
80106597:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010659c:	c9                   	leave  
8010659d:	c3                   	ret    

8010659e <sys_getprocsinfo>:
#include "procinfo.h"

//project1 add sys procsinfo
int
sys_getprocsinfo(void)
{
8010659e:	55                   	push   %ebp
8010659f:	89 e5                	mov    %esp,%ebp
801065a1:	83 ec 18             	sub    $0x18,%esp
    struct procinfo *info;
    if(argptr(0, (void*)&info, NPROC*sizeof(*info)) < 0)
801065a4:	83 ec 04             	sub    $0x4,%esp
801065a7:	68 00 05 00 00       	push   $0x500
801065ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065af:	50                   	push   %eax
801065b0:	6a 00                	push   $0x0
801065b2:	e8 4a f1 ff ff       	call   80105701 <argptr>
801065b7:	83 c4 10             	add    $0x10,%esp
801065ba:	85 c0                	test   %eax,%eax
801065bc:	79 07                	jns    801065c5 <sys_getprocsinfo+0x27>
    {
        return -1;
801065be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065c3:	eb 0f                	jmp    801065d4 <sys_getprocsinfo+0x36>
    }
    return getprocsinfo(info);
801065c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c8:	83 ec 0c             	sub    $0xc,%esp
801065cb:	50                   	push   %eax
801065cc:	e8 23 dc ff ff       	call   801041f4 <getprocsinfo>
801065d1:	83 c4 10             	add    $0x10,%esp
}
801065d4:	c9                   	leave  
801065d5:	c3                   	ret    

801065d6 <sys_shmem_access>:
// pj2 share memory
int
sys_shmem_access(void)
{
801065d6:	55                   	push   %ebp
801065d7:	89 e5                	mov    %esp,%ebp
801065d9:	83 ec 18             	sub    $0x18,%esp
  int pgindex;
  if(argint(0, &pgindex) < 0)
801065dc:	83 ec 08             	sub    $0x8,%esp
801065df:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065e2:	50                   	push   %eax
801065e3:	6a 00                	push   $0x0
801065e5:	e8 ea f0 ff ff       	call   801056d4 <argint>
801065ea:	83 c4 10             	add    $0x10,%esp
801065ed:	85 c0                	test   %eax,%eax
801065ef:	79 07                	jns    801065f8 <sys_shmem_access+0x22>
    return 0;
801065f1:	b8 00 00 00 00       	mov    $0x0,%eax
801065f6:	eb 0f                	jmp    80106607 <sys_shmem_access+0x31>
  return shmem_access(pgindex);
801065f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065fb:	83 ec 0c             	sub    $0xc,%esp
801065fe:	50                   	push   %eax
801065ff:	e8 f5 1f 00 00       	call   801085f9 <shmem_access>
80106604:	83 c4 10             	add    $0x10,%esp
}
80106607:	c9                   	leave  
80106608:	c3                   	ret    

80106609 <sys_shmem_count>:

int
sys_shmem_count(void)
{
80106609:	55                   	push   %ebp
8010660a:	89 e5                	mov    %esp,%ebp
8010660c:	83 ec 18             	sub    $0x18,%esp
  int pgindex;
  if(argint(0,&pgindex) < 0)
8010660f:	83 ec 08             	sub    $0x8,%esp
80106612:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106615:	50                   	push   %eax
80106616:	6a 00                	push   $0x0
80106618:	e8 b7 f0 ff ff       	call   801056d4 <argint>
8010661d:	83 c4 10             	add    $0x10,%esp
80106620:	85 c0                	test   %eax,%eax
80106622:	79 07                	jns    8010662b <sys_shmem_count+0x22>
    return -1;
80106624:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106629:	eb 0f                	jmp    8010663a <sys_shmem_count+0x31>
  return shmem_count(pgindex);
8010662b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010662e:	83 ec 0c             	sub    $0xc,%esp
80106631:	50                   	push   %eax
80106632:	e8 f0 20 00 00       	call   80108727 <shmem_count>
80106637:	83 c4 10             	add    $0x10,%esp
}
8010663a:	c9                   	leave  
8010663b:	c3                   	ret    

8010663c <sys_fork>:


int
sys_fork(void)
{
8010663c:	55                   	push   %ebp
8010663d:	89 e5                	mov    %esp,%ebp
8010663f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106642:	e8 f9 df ff ff       	call   80104640 <fork>
}
80106647:	c9                   	leave  
80106648:	c3                   	ret    

80106649 <sys_exit>:

int
sys_exit(void)
{
80106649:	55                   	push   %ebp
8010664a:	89 e5                	mov    %esp,%ebp
8010664c:	83 ec 08             	sub    $0x8,%esp
  exit();
8010664f:	e8 0a e2 ff ff       	call   8010485e <exit>
  return 0;  // not reached
80106654:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106659:	c9                   	leave  
8010665a:	c3                   	ret    

8010665b <sys_wait>:

int
sys_wait(void)
{
8010665b:	55                   	push   %ebp
8010665c:	89 e5                	mov    %esp,%ebp
8010665e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106661:	e8 1b e3 ff ff       	call   80104981 <wait>
}
80106666:	c9                   	leave  
80106667:	c3                   	ret    

80106668 <sys_kill>:

int
sys_kill(void)
{
80106668:	55                   	push   %ebp
80106669:	89 e5                	mov    %esp,%ebp
8010666b:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010666e:	83 ec 08             	sub    $0x8,%esp
80106671:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106674:	50                   	push   %eax
80106675:	6a 00                	push   $0x0
80106677:	e8 58 f0 ff ff       	call   801056d4 <argint>
8010667c:	83 c4 10             	add    $0x10,%esp
8010667f:	85 c0                	test   %eax,%eax
80106681:	79 07                	jns    8010668a <sys_kill+0x22>
    return -1;
80106683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106688:	eb 0f                	jmp    80106699 <sys_kill+0x31>
  return kill(pid);
8010668a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010668d:	83 ec 0c             	sub    $0xc,%esp
80106690:	50                   	push   %eax
80106691:	e8 63 e7 ff ff       	call   80104df9 <kill>
80106696:	83 c4 10             	add    $0x10,%esp
}
80106699:	c9                   	leave  
8010669a:	c3                   	ret    

8010669b <sys_getpid>:

int
sys_getpid(void)
{
8010669b:	55                   	push   %ebp
8010669c:	89 e5                	mov    %esp,%ebp
8010669e:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801066a1:	e8 92 dc ff ff       	call   80104338 <myproc>
801066a6:	8b 40 10             	mov    0x10(%eax),%eax
}
801066a9:	c9                   	leave  
801066aa:	c3                   	ret    

801066ab <sys_sbrk>:

int
sys_sbrk(void)
{
801066ab:	55                   	push   %ebp
801066ac:	89 e5                	mov    %esp,%ebp
801066ae:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801066b1:	83 ec 08             	sub    $0x8,%esp
801066b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066b7:	50                   	push   %eax
801066b8:	6a 00                	push   $0x0
801066ba:	e8 15 f0 ff ff       	call   801056d4 <argint>
801066bf:	83 c4 10             	add    $0x10,%esp
801066c2:	85 c0                	test   %eax,%eax
801066c4:	79 07                	jns    801066cd <sys_sbrk+0x22>
    return -1;
801066c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066cb:	eb 27                	jmp    801066f4 <sys_sbrk+0x49>
  addr = myproc()->sz;
801066cd:	e8 66 dc ff ff       	call   80104338 <myproc>
801066d2:	8b 00                	mov    (%eax),%eax
801066d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801066d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066da:	83 ec 0c             	sub    $0xc,%esp
801066dd:	50                   	push   %eax
801066de:	e8 c2 de ff ff       	call   801045a5 <growproc>
801066e3:	83 c4 10             	add    $0x10,%esp
801066e6:	85 c0                	test   %eax,%eax
801066e8:	79 07                	jns    801066f1 <sys_sbrk+0x46>
    return -1;
801066ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ef:	eb 03                	jmp    801066f4 <sys_sbrk+0x49>
  return addr;
801066f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801066f4:	c9                   	leave  
801066f5:	c3                   	ret    

801066f6 <sys_sleep>:

int
sys_sleep(void)
{
801066f6:	55                   	push   %ebp
801066f7:	89 e5                	mov    %esp,%ebp
801066f9:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801066fc:	83 ec 08             	sub    $0x8,%esp
801066ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106702:	50                   	push   %eax
80106703:	6a 00                	push   $0x0
80106705:	e8 ca ef ff ff       	call   801056d4 <argint>
8010670a:	83 c4 10             	add    $0x10,%esp
8010670d:	85 c0                	test   %eax,%eax
8010670f:	79 07                	jns    80106718 <sys_sleep+0x22>
    return -1;
80106711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106716:	eb 76                	jmp    8010678e <sys_sleep+0x98>
  acquire(&tickslock);
80106718:	83 ec 0c             	sub    $0xc,%esp
8010671b:	68 00 61 11 80       	push   $0x80116100
80106720:	e8 fc e9 ff ff       	call   80105121 <acquire>
80106725:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106728:	a1 40 69 11 80       	mov    0x80116940,%eax
8010672d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106730:	eb 38                	jmp    8010676a <sys_sleep+0x74>
    if(myproc()->killed){
80106732:	e8 01 dc ff ff       	call   80104338 <myproc>
80106737:	8b 40 24             	mov    0x24(%eax),%eax
8010673a:	85 c0                	test   %eax,%eax
8010673c:	74 17                	je     80106755 <sys_sleep+0x5f>
      release(&tickslock);
8010673e:	83 ec 0c             	sub    $0xc,%esp
80106741:	68 00 61 11 80       	push   $0x80116100
80106746:	e8 44 ea ff ff       	call   8010518f <release>
8010674b:	83 c4 10             	add    $0x10,%esp
      return -1;
8010674e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106753:	eb 39                	jmp    8010678e <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80106755:	83 ec 08             	sub    $0x8,%esp
80106758:	68 00 61 11 80       	push   $0x80116100
8010675d:	68 40 69 11 80       	push   $0x80116940
80106762:	e8 72 e5 ff ff       	call   80104cd9 <sleep>
80106767:	83 c4 10             	add    $0x10,%esp

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010676a:	a1 40 69 11 80       	mov    0x80116940,%eax
8010676f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106772:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106775:	39 d0                	cmp    %edx,%eax
80106777:	72 b9                	jb     80106732 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106779:	83 ec 0c             	sub    $0xc,%esp
8010677c:	68 00 61 11 80       	push   $0x80116100
80106781:	e8 09 ea ff ff       	call   8010518f <release>
80106786:	83 c4 10             	add    $0x10,%esp
  return 0;
80106789:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010678e:	c9                   	leave  
8010678f:	c3                   	ret    

80106790 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106796:	83 ec 0c             	sub    $0xc,%esp
80106799:	68 00 61 11 80       	push   $0x80116100
8010679e:	e8 7e e9 ff ff       	call   80105121 <acquire>
801067a3:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801067a6:	a1 40 69 11 80       	mov    0x80116940,%eax
801067ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801067ae:	83 ec 0c             	sub    $0xc,%esp
801067b1:	68 00 61 11 80       	push   $0x80116100
801067b6:	e8 d4 e9 ff ff       	call   8010518f <release>
801067bb:	83 c4 10             	add    $0x10,%esp
  return xticks;
801067be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801067c1:	c9                   	leave  
801067c2:	c3                   	ret    

801067c3 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801067c3:	1e                   	push   %ds
  pushl %es
801067c4:	06                   	push   %es
  pushl %fs
801067c5:	0f a0                	push   %fs
  pushl %gs
801067c7:	0f a8                	push   %gs
  pushal
801067c9:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801067ca:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801067ce:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801067d0:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801067d2:	54                   	push   %esp
  call trap
801067d3:	e8 d7 01 00 00       	call   801069af <trap>
  addl $4, %esp
801067d8:	83 c4 04             	add    $0x4,%esp

801067db <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801067db:	61                   	popa   
  popl %gs
801067dc:	0f a9                	pop    %gs
  popl %fs
801067de:	0f a1                	pop    %fs
  popl %es
801067e0:	07                   	pop    %es
  popl %ds
801067e1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801067e2:	83 c4 08             	add    $0x8,%esp
  iret
801067e5:	cf                   	iret   

801067e6 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801067e6:	55                   	push   %ebp
801067e7:	89 e5                	mov    %esp,%ebp
801067e9:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801067ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801067ef:	83 e8 01             	sub    $0x1,%eax
801067f2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801067f6:	8b 45 08             	mov    0x8(%ebp),%eax
801067f9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801067fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106800:	c1 e8 10             	shr    $0x10,%eax
80106803:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106807:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010680a:	0f 01 18             	lidtl  (%eax)
}
8010680d:	90                   	nop
8010680e:	c9                   	leave  
8010680f:	c3                   	ret    

80106810 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106816:	0f 20 d0             	mov    %cr2,%eax
80106819:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010681c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010681f:	c9                   	leave  
80106820:	c3                   	ret    

80106821 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106821:	55                   	push   %ebp
80106822:	89 e5                	mov    %esp,%ebp
80106824:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106827:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010682e:	e9 c3 00 00 00       	jmp    801068f6 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106836:	8b 04 85 84 b0 10 80 	mov    -0x7fef4f7c(,%eax,4),%eax
8010683d:	89 c2                	mov    %eax,%edx
8010683f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106842:	66 89 14 c5 40 61 11 	mov    %dx,-0x7fee9ec0(,%eax,8)
80106849:	80 
8010684a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010684d:	66 c7 04 c5 42 61 11 	movw   $0x8,-0x7fee9ebe(,%eax,8)
80106854:	80 08 00 
80106857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010685a:	0f b6 14 c5 44 61 11 	movzbl -0x7fee9ebc(,%eax,8),%edx
80106861:	80 
80106862:	83 e2 e0             	and    $0xffffffe0,%edx
80106865:	88 14 c5 44 61 11 80 	mov    %dl,-0x7fee9ebc(,%eax,8)
8010686c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010686f:	0f b6 14 c5 44 61 11 	movzbl -0x7fee9ebc(,%eax,8),%edx
80106876:	80 
80106877:	83 e2 1f             	and    $0x1f,%edx
8010687a:	88 14 c5 44 61 11 80 	mov    %dl,-0x7fee9ebc(,%eax,8)
80106881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106884:	0f b6 14 c5 45 61 11 	movzbl -0x7fee9ebb(,%eax,8),%edx
8010688b:	80 
8010688c:	83 e2 f0             	and    $0xfffffff0,%edx
8010688f:	83 ca 0e             	or     $0xe,%edx
80106892:	88 14 c5 45 61 11 80 	mov    %dl,-0x7fee9ebb(,%eax,8)
80106899:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010689c:	0f b6 14 c5 45 61 11 	movzbl -0x7fee9ebb(,%eax,8),%edx
801068a3:	80 
801068a4:	83 e2 ef             	and    $0xffffffef,%edx
801068a7:	88 14 c5 45 61 11 80 	mov    %dl,-0x7fee9ebb(,%eax,8)
801068ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b1:	0f b6 14 c5 45 61 11 	movzbl -0x7fee9ebb(,%eax,8),%edx
801068b8:	80 
801068b9:	83 e2 9f             	and    $0xffffff9f,%edx
801068bc:	88 14 c5 45 61 11 80 	mov    %dl,-0x7fee9ebb(,%eax,8)
801068c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c6:	0f b6 14 c5 45 61 11 	movzbl -0x7fee9ebb(,%eax,8),%edx
801068cd:	80 
801068ce:	83 ca 80             	or     $0xffffff80,%edx
801068d1:	88 14 c5 45 61 11 80 	mov    %dl,-0x7fee9ebb(,%eax,8)
801068d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068db:	8b 04 85 84 b0 10 80 	mov    -0x7fef4f7c(,%eax,4),%eax
801068e2:	c1 e8 10             	shr    $0x10,%eax
801068e5:	89 c2                	mov    %eax,%edx
801068e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ea:	66 89 14 c5 46 61 11 	mov    %dx,-0x7fee9eba(,%eax,8)
801068f1:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801068f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801068f6:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801068fd:	0f 8e 30 ff ff ff    	jle    80106833 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106903:	a1 84 b1 10 80       	mov    0x8010b184,%eax
80106908:	66 a3 40 63 11 80    	mov    %ax,0x80116340
8010690e:	66 c7 05 42 63 11 80 	movw   $0x8,0x80116342
80106915:	08 00 
80106917:	0f b6 05 44 63 11 80 	movzbl 0x80116344,%eax
8010691e:	83 e0 e0             	and    $0xffffffe0,%eax
80106921:	a2 44 63 11 80       	mov    %al,0x80116344
80106926:	0f b6 05 44 63 11 80 	movzbl 0x80116344,%eax
8010692d:	83 e0 1f             	and    $0x1f,%eax
80106930:	a2 44 63 11 80       	mov    %al,0x80116344
80106935:	0f b6 05 45 63 11 80 	movzbl 0x80116345,%eax
8010693c:	83 c8 0f             	or     $0xf,%eax
8010693f:	a2 45 63 11 80       	mov    %al,0x80116345
80106944:	0f b6 05 45 63 11 80 	movzbl 0x80116345,%eax
8010694b:	83 e0 ef             	and    $0xffffffef,%eax
8010694e:	a2 45 63 11 80       	mov    %al,0x80116345
80106953:	0f b6 05 45 63 11 80 	movzbl 0x80116345,%eax
8010695a:	83 c8 60             	or     $0x60,%eax
8010695d:	a2 45 63 11 80       	mov    %al,0x80116345
80106962:	0f b6 05 45 63 11 80 	movzbl 0x80116345,%eax
80106969:	83 c8 80             	or     $0xffffff80,%eax
8010696c:	a2 45 63 11 80       	mov    %al,0x80116345
80106971:	a1 84 b1 10 80       	mov    0x8010b184,%eax
80106976:	c1 e8 10             	shr    $0x10,%eax
80106979:	66 a3 46 63 11 80    	mov    %ax,0x80116346

  initlock(&tickslock, "time");
8010697f:	83 ec 08             	sub    $0x8,%esp
80106982:	68 68 8c 10 80       	push   $0x80108c68
80106987:	68 00 61 11 80       	push   $0x80116100
8010698c:	e8 6e e7 ff ff       	call   801050ff <initlock>
80106991:	83 c4 10             	add    $0x10,%esp
}
80106994:	90                   	nop
80106995:	c9                   	leave  
80106996:	c3                   	ret    

80106997 <idtinit>:

void
idtinit(void)
{
80106997:	55                   	push   %ebp
80106998:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010699a:	68 00 08 00 00       	push   $0x800
8010699f:	68 40 61 11 80       	push   $0x80116140
801069a4:	e8 3d fe ff ff       	call   801067e6 <lidt>
801069a9:	83 c4 08             	add    $0x8,%esp
}
801069ac:	90                   	nop
801069ad:	c9                   	leave  
801069ae:	c3                   	ret    

801069af <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801069af:	55                   	push   %ebp
801069b0:	89 e5                	mov    %esp,%ebp
801069b2:	57                   	push   %edi
801069b3:	56                   	push   %esi
801069b4:	53                   	push   %ebx
801069b5:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801069b8:	8b 45 08             	mov    0x8(%ebp),%eax
801069bb:	8b 40 30             	mov    0x30(%eax),%eax
801069be:	83 f8 40             	cmp    $0x40,%eax
801069c1:	75 3d                	jne    80106a00 <trap+0x51>
    if(myproc()->killed)
801069c3:	e8 70 d9 ff ff       	call   80104338 <myproc>
801069c8:	8b 40 24             	mov    0x24(%eax),%eax
801069cb:	85 c0                	test   %eax,%eax
801069cd:	74 05                	je     801069d4 <trap+0x25>
      exit();
801069cf:	e8 8a de ff ff       	call   8010485e <exit>
    myproc()->tf = tf;
801069d4:	e8 5f d9 ff ff       	call   80104338 <myproc>
801069d9:	89 c2                	mov    %eax,%edx
801069db:	8b 45 08             	mov    0x8(%ebp),%eax
801069de:	89 42 18             	mov    %eax,0x18(%edx)
    syscall();
801069e1:	e8 c1 ed ff ff       	call   801057a7 <syscall>
    if(myproc()->killed)
801069e6:	e8 4d d9 ff ff       	call   80104338 <myproc>
801069eb:	8b 40 24             	mov    0x24(%eax),%eax
801069ee:	85 c0                	test   %eax,%eax
801069f0:	0f 84 04 02 00 00    	je     80106bfa <trap+0x24b>
      exit();
801069f6:	e8 63 de ff ff       	call   8010485e <exit>
    return;
801069fb:	e9 fa 01 00 00       	jmp    80106bfa <trap+0x24b>
  }

  switch(tf->trapno){
80106a00:	8b 45 08             	mov    0x8(%ebp),%eax
80106a03:	8b 40 30             	mov    0x30(%eax),%eax
80106a06:	83 e8 20             	sub    $0x20,%eax
80106a09:	83 f8 1f             	cmp    $0x1f,%eax
80106a0c:	0f 87 b5 00 00 00    	ja     80106ac7 <trap+0x118>
80106a12:	8b 04 85 10 8d 10 80 	mov    -0x7fef72f0(,%eax,4),%eax
80106a19:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106a1b:	e8 7f d8 ff ff       	call   8010429f <cpuid>
80106a20:	85 c0                	test   %eax,%eax
80106a22:	75 3d                	jne    80106a61 <trap+0xb2>
      acquire(&tickslock);
80106a24:	83 ec 0c             	sub    $0xc,%esp
80106a27:	68 00 61 11 80       	push   $0x80116100
80106a2c:	e8 f0 e6 ff ff       	call   80105121 <acquire>
80106a31:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106a34:	a1 40 69 11 80       	mov    0x80116940,%eax
80106a39:	83 c0 01             	add    $0x1,%eax
80106a3c:	a3 40 69 11 80       	mov    %eax,0x80116940
      wakeup(&ticks);
80106a41:	83 ec 0c             	sub    $0xc,%esp
80106a44:	68 40 69 11 80       	push   $0x80116940
80106a49:	e8 74 e3 ff ff       	call   80104dc2 <wakeup>
80106a4e:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106a51:	83 ec 0c             	sub    $0xc,%esp
80106a54:	68 00 61 11 80       	push   $0x80116100
80106a59:	e8 31 e7 ff ff       	call   8010518f <release>
80106a5e:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106a61:	e8 a7 c5 ff ff       	call   8010300d <lapiceoi>
    break;
80106a66:	e9 0f 01 00 00       	jmp    80106b7a <trap+0x1cb>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106a6b:	e8 17 be ff ff       	call   80102887 <ideintr>
    lapiceoi();
80106a70:	e8 98 c5 ff ff       	call   8010300d <lapiceoi>
    break;
80106a75:	e9 00 01 00 00       	jmp    80106b7a <trap+0x1cb>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106a7a:	e8 d7 c3 ff ff       	call   80102e56 <kbdintr>
    lapiceoi();
80106a7f:	e8 89 c5 ff ff       	call   8010300d <lapiceoi>
    break;
80106a84:	e9 f1 00 00 00       	jmp    80106b7a <trap+0x1cb>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106a89:	e8 40 03 00 00       	call   80106dce <uartintr>
    lapiceoi();
80106a8e:	e8 7a c5 ff ff       	call   8010300d <lapiceoi>
    break;
80106a93:	e9 e2 00 00 00       	jmp    80106b7a <trap+0x1cb>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a98:	8b 45 08             	mov    0x8(%ebp),%eax
80106a9b:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106aa5:	0f b7 d8             	movzwl %ax,%ebx
80106aa8:	e8 f2 d7 ff ff       	call   8010429f <cpuid>
80106aad:	56                   	push   %esi
80106aae:	53                   	push   %ebx
80106aaf:	50                   	push   %eax
80106ab0:	68 70 8c 10 80       	push   $0x80108c70
80106ab5:	e8 46 99 ff ff       	call   80100400 <cprintf>
80106aba:	83 c4 10             	add    $0x10,%esp
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106abd:	e8 4b c5 ff ff       	call   8010300d <lapiceoi>
    break;
80106ac2:	e9 b3 00 00 00       	jmp    80106b7a <trap+0x1cb>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106ac7:	e8 6c d8 ff ff       	call   80104338 <myproc>
80106acc:	85 c0                	test   %eax,%eax
80106ace:	74 11                	je     80106ae1 <trap+0x132>
80106ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ad7:	0f b7 c0             	movzwl %ax,%eax
80106ada:	83 e0 03             	and    $0x3,%eax
80106add:	85 c0                	test   %eax,%eax
80106adf:	75 3b                	jne    80106b1c <trap+0x16d>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ae1:	e8 2a fd ff ff       	call   80106810 <rcr2>
80106ae6:	89 c6                	mov    %eax,%esi
80106ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80106aeb:	8b 58 38             	mov    0x38(%eax),%ebx
80106aee:	e8 ac d7 ff ff       	call   8010429f <cpuid>
80106af3:	89 c2                	mov    %eax,%edx
80106af5:	8b 45 08             	mov    0x8(%ebp),%eax
80106af8:	8b 40 30             	mov    0x30(%eax),%eax
80106afb:	83 ec 0c             	sub    $0xc,%esp
80106afe:	56                   	push   %esi
80106aff:	53                   	push   %ebx
80106b00:	52                   	push   %edx
80106b01:	50                   	push   %eax
80106b02:	68 94 8c 10 80       	push   $0x80108c94
80106b07:	e8 f4 98 ff ff       	call   80100400 <cprintf>
80106b0c:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106b0f:	83 ec 0c             	sub    $0xc,%esp
80106b12:	68 c6 8c 10 80       	push   $0x80108cc6
80106b17:	e8 84 9a ff ff       	call   801005a0 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b1c:	e8 ef fc ff ff       	call   80106810 <rcr2>
80106b21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b24:	8b 45 08             	mov    0x8(%ebp),%eax
80106b27:	8b 78 38             	mov    0x38(%eax),%edi
80106b2a:	e8 70 d7 ff ff       	call   8010429f <cpuid>
80106b2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b32:	8b 45 08             	mov    0x8(%ebp),%eax
80106b35:	8b 70 34             	mov    0x34(%eax),%esi
80106b38:	8b 45 08             	mov    0x8(%ebp),%eax
80106b3b:	8b 58 30             	mov    0x30(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106b3e:	e8 f5 d7 ff ff       	call   80104338 <myproc>
80106b43:	8d 48 6c             	lea    0x6c(%eax),%ecx
80106b46:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80106b49:	e8 ea d7 ff ff       	call   80104338 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b4e:	8b 40 10             	mov    0x10(%eax),%eax
80106b51:	ff 75 e4             	pushl  -0x1c(%ebp)
80106b54:	57                   	push   %edi
80106b55:	ff 75 e0             	pushl  -0x20(%ebp)
80106b58:	56                   	push   %esi
80106b59:	53                   	push   %ebx
80106b5a:	ff 75 dc             	pushl  -0x24(%ebp)
80106b5d:	50                   	push   %eax
80106b5e:	68 cc 8c 10 80       	push   $0x80108ccc
80106b63:	e8 98 98 ff ff       	call   80100400 <cprintf>
80106b68:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106b6b:	e8 c8 d7 ff ff       	call   80104338 <myproc>
80106b70:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106b77:	eb 01                	jmp    80106b7a <trap+0x1cb>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106b79:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b7a:	e8 b9 d7 ff ff       	call   80104338 <myproc>
80106b7f:	85 c0                	test   %eax,%eax
80106b81:	74 23                	je     80106ba6 <trap+0x1f7>
80106b83:	e8 b0 d7 ff ff       	call   80104338 <myproc>
80106b88:	8b 40 24             	mov    0x24(%eax),%eax
80106b8b:	85 c0                	test   %eax,%eax
80106b8d:	74 17                	je     80106ba6 <trap+0x1f7>
80106b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b92:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106b96:	0f b7 c0             	movzwl %ax,%eax
80106b99:	83 e0 03             	and    $0x3,%eax
80106b9c:	83 f8 03             	cmp    $0x3,%eax
80106b9f:	75 05                	jne    80106ba6 <trap+0x1f7>
    exit();
80106ba1:	e8 b8 dc ff ff       	call   8010485e <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106ba6:	e8 8d d7 ff ff       	call   80104338 <myproc>
80106bab:	85 c0                	test   %eax,%eax
80106bad:	74 1d                	je     80106bcc <trap+0x21d>
80106baf:	e8 84 d7 ff ff       	call   80104338 <myproc>
80106bb4:	8b 40 0c             	mov    0xc(%eax),%eax
80106bb7:	83 f8 04             	cmp    $0x4,%eax
80106bba:	75 10                	jne    80106bcc <trap+0x21d>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106bbc:	8b 45 08             	mov    0x8(%ebp),%eax
80106bbf:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106bc2:	83 f8 20             	cmp    $0x20,%eax
80106bc5:	75 05                	jne    80106bcc <trap+0x21d>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80106bc7:	e8 8d e0 ff ff       	call   80104c59 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106bcc:	e8 67 d7 ff ff       	call   80104338 <myproc>
80106bd1:	85 c0                	test   %eax,%eax
80106bd3:	74 26                	je     80106bfb <trap+0x24c>
80106bd5:	e8 5e d7 ff ff       	call   80104338 <myproc>
80106bda:	8b 40 24             	mov    0x24(%eax),%eax
80106bdd:	85 c0                	test   %eax,%eax
80106bdf:	74 1a                	je     80106bfb <trap+0x24c>
80106be1:	8b 45 08             	mov    0x8(%ebp),%eax
80106be4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106be8:	0f b7 c0             	movzwl %ax,%eax
80106beb:	83 e0 03             	and    $0x3,%eax
80106bee:	83 f8 03             	cmp    $0x3,%eax
80106bf1:	75 08                	jne    80106bfb <trap+0x24c>
    exit();
80106bf3:	e8 66 dc ff ff       	call   8010485e <exit>
80106bf8:	eb 01                	jmp    80106bfb <trap+0x24c>
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
80106bfa:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bfe:	5b                   	pop    %ebx
80106bff:	5e                   	pop    %esi
80106c00:	5f                   	pop    %edi
80106c01:	5d                   	pop    %ebp
80106c02:	c3                   	ret    

80106c03 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106c03:	55                   	push   %ebp
80106c04:	89 e5                	mov    %esp,%ebp
80106c06:	83 ec 14             	sub    $0x14,%esp
80106c09:	8b 45 08             	mov    0x8(%ebp),%eax
80106c0c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106c10:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106c14:	89 c2                	mov    %eax,%edx
80106c16:	ec                   	in     (%dx),%al
80106c17:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106c1a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106c1e:	c9                   	leave  
80106c1f:	c3                   	ret    

80106c20 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	83 ec 08             	sub    $0x8,%esp
80106c26:	8b 55 08             	mov    0x8(%ebp),%edx
80106c29:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c2c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106c30:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c33:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106c37:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106c3b:	ee                   	out    %al,(%dx)
}
80106c3c:	90                   	nop
80106c3d:	c9                   	leave  
80106c3e:	c3                   	ret    

80106c3f <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106c3f:	55                   	push   %ebp
80106c40:	89 e5                	mov    %esp,%ebp
80106c42:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106c45:	6a 00                	push   $0x0
80106c47:	68 fa 03 00 00       	push   $0x3fa
80106c4c:	e8 cf ff ff ff       	call   80106c20 <outb>
80106c51:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106c54:	68 80 00 00 00       	push   $0x80
80106c59:	68 fb 03 00 00       	push   $0x3fb
80106c5e:	e8 bd ff ff ff       	call   80106c20 <outb>
80106c63:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106c66:	6a 0c                	push   $0xc
80106c68:	68 f8 03 00 00       	push   $0x3f8
80106c6d:	e8 ae ff ff ff       	call   80106c20 <outb>
80106c72:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106c75:	6a 00                	push   $0x0
80106c77:	68 f9 03 00 00       	push   $0x3f9
80106c7c:	e8 9f ff ff ff       	call   80106c20 <outb>
80106c81:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106c84:	6a 03                	push   $0x3
80106c86:	68 fb 03 00 00       	push   $0x3fb
80106c8b:	e8 90 ff ff ff       	call   80106c20 <outb>
80106c90:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106c93:	6a 00                	push   $0x0
80106c95:	68 fc 03 00 00       	push   $0x3fc
80106c9a:	e8 81 ff ff ff       	call   80106c20 <outb>
80106c9f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106ca2:	6a 01                	push   $0x1
80106ca4:	68 f9 03 00 00       	push   $0x3f9
80106ca9:	e8 72 ff ff ff       	call   80106c20 <outb>
80106cae:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106cb1:	68 fd 03 00 00       	push   $0x3fd
80106cb6:	e8 48 ff ff ff       	call   80106c03 <inb>
80106cbb:	83 c4 04             	add    $0x4,%esp
80106cbe:	3c ff                	cmp    $0xff,%al
80106cc0:	74 61                	je     80106d23 <uartinit+0xe4>
    return;
  uart = 1;
80106cc2:	c7 05 44 b6 10 80 01 	movl   $0x1,0x8010b644
80106cc9:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106ccc:	68 fa 03 00 00       	push   $0x3fa
80106cd1:	e8 2d ff ff ff       	call   80106c03 <inb>
80106cd6:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106cd9:	68 f8 03 00 00       	push   $0x3f8
80106cde:	e8 20 ff ff ff       	call   80106c03 <inb>
80106ce3:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106ce6:	83 ec 08             	sub    $0x8,%esp
80106ce9:	6a 00                	push   $0x0
80106ceb:	6a 04                	push   $0x4
80106ced:	e8 32 be ff ff       	call   80102b24 <ioapicenable>
80106cf2:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106cf5:	c7 45 f4 90 8d 10 80 	movl   $0x80108d90,-0xc(%ebp)
80106cfc:	eb 19                	jmp    80106d17 <uartinit+0xd8>
    uartputc(*p);
80106cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d01:	0f b6 00             	movzbl (%eax),%eax
80106d04:	0f be c0             	movsbl %al,%eax
80106d07:	83 ec 0c             	sub    $0xc,%esp
80106d0a:	50                   	push   %eax
80106d0b:	e8 16 00 00 00       	call   80106d26 <uartputc>
80106d10:	83 c4 10             	add    $0x10,%esp
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106d13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d1a:	0f b6 00             	movzbl (%eax),%eax
80106d1d:	84 c0                	test   %al,%al
80106d1f:	75 dd                	jne    80106cfe <uartinit+0xbf>
80106d21:	eb 01                	jmp    80106d24 <uartinit+0xe5>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106d23:	90                   	nop
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106d24:	c9                   	leave  
80106d25:	c3                   	ret    

80106d26 <uartputc>:

void
uartputc(int c)
{
80106d26:	55                   	push   %ebp
80106d27:	89 e5                	mov    %esp,%ebp
80106d29:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106d2c:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80106d31:	85 c0                	test   %eax,%eax
80106d33:	74 53                	je     80106d88 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d3c:	eb 11                	jmp    80106d4f <uartputc+0x29>
    microdelay(10);
80106d3e:	83 ec 0c             	sub    $0xc,%esp
80106d41:	6a 0a                	push   $0xa
80106d43:	e8 e0 c2 ff ff       	call   80103028 <microdelay>
80106d48:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d4b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106d4f:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106d53:	7f 1a                	jg     80106d6f <uartputc+0x49>
80106d55:	83 ec 0c             	sub    $0xc,%esp
80106d58:	68 fd 03 00 00       	push   $0x3fd
80106d5d:	e8 a1 fe ff ff       	call   80106c03 <inb>
80106d62:	83 c4 10             	add    $0x10,%esp
80106d65:	0f b6 c0             	movzbl %al,%eax
80106d68:	83 e0 20             	and    $0x20,%eax
80106d6b:	85 c0                	test   %eax,%eax
80106d6d:	74 cf                	je     80106d3e <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d72:	0f b6 c0             	movzbl %al,%eax
80106d75:	83 ec 08             	sub    $0x8,%esp
80106d78:	50                   	push   %eax
80106d79:	68 f8 03 00 00       	push   $0x3f8
80106d7e:	e8 9d fe ff ff       	call   80106c20 <outb>
80106d83:	83 c4 10             	add    $0x10,%esp
80106d86:	eb 01                	jmp    80106d89 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106d88:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106d89:	c9                   	leave  
80106d8a:	c3                   	ret    

80106d8b <uartgetc>:

static int
uartgetc(void)
{
80106d8b:	55                   	push   %ebp
80106d8c:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106d8e:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80106d93:	85 c0                	test   %eax,%eax
80106d95:	75 07                	jne    80106d9e <uartgetc+0x13>
    return -1;
80106d97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d9c:	eb 2e                	jmp    80106dcc <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106d9e:	68 fd 03 00 00       	push   $0x3fd
80106da3:	e8 5b fe ff ff       	call   80106c03 <inb>
80106da8:	83 c4 04             	add    $0x4,%esp
80106dab:	0f b6 c0             	movzbl %al,%eax
80106dae:	83 e0 01             	and    $0x1,%eax
80106db1:	85 c0                	test   %eax,%eax
80106db3:	75 07                	jne    80106dbc <uartgetc+0x31>
    return -1;
80106db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dba:	eb 10                	jmp    80106dcc <uartgetc+0x41>
  return inb(COM1+0);
80106dbc:	68 f8 03 00 00       	push   $0x3f8
80106dc1:	e8 3d fe ff ff       	call   80106c03 <inb>
80106dc6:	83 c4 04             	add    $0x4,%esp
80106dc9:	0f b6 c0             	movzbl %al,%eax
}
80106dcc:	c9                   	leave  
80106dcd:	c3                   	ret    

80106dce <uartintr>:

void
uartintr(void)
{
80106dce:	55                   	push   %ebp
80106dcf:	89 e5                	mov    %esp,%ebp
80106dd1:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106dd4:	83 ec 0c             	sub    $0xc,%esp
80106dd7:	68 8b 6d 10 80       	push   $0x80106d8b
80106ddc:	e8 4b 9a ff ff       	call   8010082c <consoleintr>
80106de1:	83 c4 10             	add    $0x10,%esp
}
80106de4:	90                   	nop
80106de5:	c9                   	leave  
80106de6:	c3                   	ret    

80106de7 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $0
80106de9:	6a 00                	push   $0x0
  jmp alltraps
80106deb:	e9 d3 f9 ff ff       	jmp    801067c3 <alltraps>

80106df0 <vector1>:
.globl vector1
vector1:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $1
80106df2:	6a 01                	push   $0x1
  jmp alltraps
80106df4:	e9 ca f9 ff ff       	jmp    801067c3 <alltraps>

80106df9 <vector2>:
.globl vector2
vector2:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $2
80106dfb:	6a 02                	push   $0x2
  jmp alltraps
80106dfd:	e9 c1 f9 ff ff       	jmp    801067c3 <alltraps>

80106e02 <vector3>:
.globl vector3
vector3:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $3
80106e04:	6a 03                	push   $0x3
  jmp alltraps
80106e06:	e9 b8 f9 ff ff       	jmp    801067c3 <alltraps>

80106e0b <vector4>:
.globl vector4
vector4:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $4
80106e0d:	6a 04                	push   $0x4
  jmp alltraps
80106e0f:	e9 af f9 ff ff       	jmp    801067c3 <alltraps>

80106e14 <vector5>:
.globl vector5
vector5:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $5
80106e16:	6a 05                	push   $0x5
  jmp alltraps
80106e18:	e9 a6 f9 ff ff       	jmp    801067c3 <alltraps>

80106e1d <vector6>:
.globl vector6
vector6:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $6
80106e1f:	6a 06                	push   $0x6
  jmp alltraps
80106e21:	e9 9d f9 ff ff       	jmp    801067c3 <alltraps>

80106e26 <vector7>:
.globl vector7
vector7:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $7
80106e28:	6a 07                	push   $0x7
  jmp alltraps
80106e2a:	e9 94 f9 ff ff       	jmp    801067c3 <alltraps>

80106e2f <vector8>:
.globl vector8
vector8:
  pushl $8
80106e2f:	6a 08                	push   $0x8
  jmp alltraps
80106e31:	e9 8d f9 ff ff       	jmp    801067c3 <alltraps>

80106e36 <vector9>:
.globl vector9
vector9:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $9
80106e38:	6a 09                	push   $0x9
  jmp alltraps
80106e3a:	e9 84 f9 ff ff       	jmp    801067c3 <alltraps>

80106e3f <vector10>:
.globl vector10
vector10:
  pushl $10
80106e3f:	6a 0a                	push   $0xa
  jmp alltraps
80106e41:	e9 7d f9 ff ff       	jmp    801067c3 <alltraps>

80106e46 <vector11>:
.globl vector11
vector11:
  pushl $11
80106e46:	6a 0b                	push   $0xb
  jmp alltraps
80106e48:	e9 76 f9 ff ff       	jmp    801067c3 <alltraps>

80106e4d <vector12>:
.globl vector12
vector12:
  pushl $12
80106e4d:	6a 0c                	push   $0xc
  jmp alltraps
80106e4f:	e9 6f f9 ff ff       	jmp    801067c3 <alltraps>

80106e54 <vector13>:
.globl vector13
vector13:
  pushl $13
80106e54:	6a 0d                	push   $0xd
  jmp alltraps
80106e56:	e9 68 f9 ff ff       	jmp    801067c3 <alltraps>

80106e5b <vector14>:
.globl vector14
vector14:
  pushl $14
80106e5b:	6a 0e                	push   $0xe
  jmp alltraps
80106e5d:	e9 61 f9 ff ff       	jmp    801067c3 <alltraps>

80106e62 <vector15>:
.globl vector15
vector15:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $15
80106e64:	6a 0f                	push   $0xf
  jmp alltraps
80106e66:	e9 58 f9 ff ff       	jmp    801067c3 <alltraps>

80106e6b <vector16>:
.globl vector16
vector16:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $16
80106e6d:	6a 10                	push   $0x10
  jmp alltraps
80106e6f:	e9 4f f9 ff ff       	jmp    801067c3 <alltraps>

80106e74 <vector17>:
.globl vector17
vector17:
  pushl $17
80106e74:	6a 11                	push   $0x11
  jmp alltraps
80106e76:	e9 48 f9 ff ff       	jmp    801067c3 <alltraps>

80106e7b <vector18>:
.globl vector18
vector18:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $18
80106e7d:	6a 12                	push   $0x12
  jmp alltraps
80106e7f:	e9 3f f9 ff ff       	jmp    801067c3 <alltraps>

80106e84 <vector19>:
.globl vector19
vector19:
  pushl $0
80106e84:	6a 00                	push   $0x0
  pushl $19
80106e86:	6a 13                	push   $0x13
  jmp alltraps
80106e88:	e9 36 f9 ff ff       	jmp    801067c3 <alltraps>

80106e8d <vector20>:
.globl vector20
vector20:
  pushl $0
80106e8d:	6a 00                	push   $0x0
  pushl $20
80106e8f:	6a 14                	push   $0x14
  jmp alltraps
80106e91:	e9 2d f9 ff ff       	jmp    801067c3 <alltraps>

80106e96 <vector21>:
.globl vector21
vector21:
  pushl $0
80106e96:	6a 00                	push   $0x0
  pushl $21
80106e98:	6a 15                	push   $0x15
  jmp alltraps
80106e9a:	e9 24 f9 ff ff       	jmp    801067c3 <alltraps>

80106e9f <vector22>:
.globl vector22
vector22:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $22
80106ea1:	6a 16                	push   $0x16
  jmp alltraps
80106ea3:	e9 1b f9 ff ff       	jmp    801067c3 <alltraps>

80106ea8 <vector23>:
.globl vector23
vector23:
  pushl $0
80106ea8:	6a 00                	push   $0x0
  pushl $23
80106eaa:	6a 17                	push   $0x17
  jmp alltraps
80106eac:	e9 12 f9 ff ff       	jmp    801067c3 <alltraps>

80106eb1 <vector24>:
.globl vector24
vector24:
  pushl $0
80106eb1:	6a 00                	push   $0x0
  pushl $24
80106eb3:	6a 18                	push   $0x18
  jmp alltraps
80106eb5:	e9 09 f9 ff ff       	jmp    801067c3 <alltraps>

80106eba <vector25>:
.globl vector25
vector25:
  pushl $0
80106eba:	6a 00                	push   $0x0
  pushl $25
80106ebc:	6a 19                	push   $0x19
  jmp alltraps
80106ebe:	e9 00 f9 ff ff       	jmp    801067c3 <alltraps>

80106ec3 <vector26>:
.globl vector26
vector26:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $26
80106ec5:	6a 1a                	push   $0x1a
  jmp alltraps
80106ec7:	e9 f7 f8 ff ff       	jmp    801067c3 <alltraps>

80106ecc <vector27>:
.globl vector27
vector27:
  pushl $0
80106ecc:	6a 00                	push   $0x0
  pushl $27
80106ece:	6a 1b                	push   $0x1b
  jmp alltraps
80106ed0:	e9 ee f8 ff ff       	jmp    801067c3 <alltraps>

80106ed5 <vector28>:
.globl vector28
vector28:
  pushl $0
80106ed5:	6a 00                	push   $0x0
  pushl $28
80106ed7:	6a 1c                	push   $0x1c
  jmp alltraps
80106ed9:	e9 e5 f8 ff ff       	jmp    801067c3 <alltraps>

80106ede <vector29>:
.globl vector29
vector29:
  pushl $0
80106ede:	6a 00                	push   $0x0
  pushl $29
80106ee0:	6a 1d                	push   $0x1d
  jmp alltraps
80106ee2:	e9 dc f8 ff ff       	jmp    801067c3 <alltraps>

80106ee7 <vector30>:
.globl vector30
vector30:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $30
80106ee9:	6a 1e                	push   $0x1e
  jmp alltraps
80106eeb:	e9 d3 f8 ff ff       	jmp    801067c3 <alltraps>

80106ef0 <vector31>:
.globl vector31
vector31:
  pushl $0
80106ef0:	6a 00                	push   $0x0
  pushl $31
80106ef2:	6a 1f                	push   $0x1f
  jmp alltraps
80106ef4:	e9 ca f8 ff ff       	jmp    801067c3 <alltraps>

80106ef9 <vector32>:
.globl vector32
vector32:
  pushl $0
80106ef9:	6a 00                	push   $0x0
  pushl $32
80106efb:	6a 20                	push   $0x20
  jmp alltraps
80106efd:	e9 c1 f8 ff ff       	jmp    801067c3 <alltraps>

80106f02 <vector33>:
.globl vector33
vector33:
  pushl $0
80106f02:	6a 00                	push   $0x0
  pushl $33
80106f04:	6a 21                	push   $0x21
  jmp alltraps
80106f06:	e9 b8 f8 ff ff       	jmp    801067c3 <alltraps>

80106f0b <vector34>:
.globl vector34
vector34:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $34
80106f0d:	6a 22                	push   $0x22
  jmp alltraps
80106f0f:	e9 af f8 ff ff       	jmp    801067c3 <alltraps>

80106f14 <vector35>:
.globl vector35
vector35:
  pushl $0
80106f14:	6a 00                	push   $0x0
  pushl $35
80106f16:	6a 23                	push   $0x23
  jmp alltraps
80106f18:	e9 a6 f8 ff ff       	jmp    801067c3 <alltraps>

80106f1d <vector36>:
.globl vector36
vector36:
  pushl $0
80106f1d:	6a 00                	push   $0x0
  pushl $36
80106f1f:	6a 24                	push   $0x24
  jmp alltraps
80106f21:	e9 9d f8 ff ff       	jmp    801067c3 <alltraps>

80106f26 <vector37>:
.globl vector37
vector37:
  pushl $0
80106f26:	6a 00                	push   $0x0
  pushl $37
80106f28:	6a 25                	push   $0x25
  jmp alltraps
80106f2a:	e9 94 f8 ff ff       	jmp    801067c3 <alltraps>

80106f2f <vector38>:
.globl vector38
vector38:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $38
80106f31:	6a 26                	push   $0x26
  jmp alltraps
80106f33:	e9 8b f8 ff ff       	jmp    801067c3 <alltraps>

80106f38 <vector39>:
.globl vector39
vector39:
  pushl $0
80106f38:	6a 00                	push   $0x0
  pushl $39
80106f3a:	6a 27                	push   $0x27
  jmp alltraps
80106f3c:	e9 82 f8 ff ff       	jmp    801067c3 <alltraps>

80106f41 <vector40>:
.globl vector40
vector40:
  pushl $0
80106f41:	6a 00                	push   $0x0
  pushl $40
80106f43:	6a 28                	push   $0x28
  jmp alltraps
80106f45:	e9 79 f8 ff ff       	jmp    801067c3 <alltraps>

80106f4a <vector41>:
.globl vector41
vector41:
  pushl $0
80106f4a:	6a 00                	push   $0x0
  pushl $41
80106f4c:	6a 29                	push   $0x29
  jmp alltraps
80106f4e:	e9 70 f8 ff ff       	jmp    801067c3 <alltraps>

80106f53 <vector42>:
.globl vector42
vector42:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $42
80106f55:	6a 2a                	push   $0x2a
  jmp alltraps
80106f57:	e9 67 f8 ff ff       	jmp    801067c3 <alltraps>

80106f5c <vector43>:
.globl vector43
vector43:
  pushl $0
80106f5c:	6a 00                	push   $0x0
  pushl $43
80106f5e:	6a 2b                	push   $0x2b
  jmp alltraps
80106f60:	e9 5e f8 ff ff       	jmp    801067c3 <alltraps>

80106f65 <vector44>:
.globl vector44
vector44:
  pushl $0
80106f65:	6a 00                	push   $0x0
  pushl $44
80106f67:	6a 2c                	push   $0x2c
  jmp alltraps
80106f69:	e9 55 f8 ff ff       	jmp    801067c3 <alltraps>

80106f6e <vector45>:
.globl vector45
vector45:
  pushl $0
80106f6e:	6a 00                	push   $0x0
  pushl $45
80106f70:	6a 2d                	push   $0x2d
  jmp alltraps
80106f72:	e9 4c f8 ff ff       	jmp    801067c3 <alltraps>

80106f77 <vector46>:
.globl vector46
vector46:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $46
80106f79:	6a 2e                	push   $0x2e
  jmp alltraps
80106f7b:	e9 43 f8 ff ff       	jmp    801067c3 <alltraps>

80106f80 <vector47>:
.globl vector47
vector47:
  pushl $0
80106f80:	6a 00                	push   $0x0
  pushl $47
80106f82:	6a 2f                	push   $0x2f
  jmp alltraps
80106f84:	e9 3a f8 ff ff       	jmp    801067c3 <alltraps>

80106f89 <vector48>:
.globl vector48
vector48:
  pushl $0
80106f89:	6a 00                	push   $0x0
  pushl $48
80106f8b:	6a 30                	push   $0x30
  jmp alltraps
80106f8d:	e9 31 f8 ff ff       	jmp    801067c3 <alltraps>

80106f92 <vector49>:
.globl vector49
vector49:
  pushl $0
80106f92:	6a 00                	push   $0x0
  pushl $49
80106f94:	6a 31                	push   $0x31
  jmp alltraps
80106f96:	e9 28 f8 ff ff       	jmp    801067c3 <alltraps>

80106f9b <vector50>:
.globl vector50
vector50:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $50
80106f9d:	6a 32                	push   $0x32
  jmp alltraps
80106f9f:	e9 1f f8 ff ff       	jmp    801067c3 <alltraps>

80106fa4 <vector51>:
.globl vector51
vector51:
  pushl $0
80106fa4:	6a 00                	push   $0x0
  pushl $51
80106fa6:	6a 33                	push   $0x33
  jmp alltraps
80106fa8:	e9 16 f8 ff ff       	jmp    801067c3 <alltraps>

80106fad <vector52>:
.globl vector52
vector52:
  pushl $0
80106fad:	6a 00                	push   $0x0
  pushl $52
80106faf:	6a 34                	push   $0x34
  jmp alltraps
80106fb1:	e9 0d f8 ff ff       	jmp    801067c3 <alltraps>

80106fb6 <vector53>:
.globl vector53
vector53:
  pushl $0
80106fb6:	6a 00                	push   $0x0
  pushl $53
80106fb8:	6a 35                	push   $0x35
  jmp alltraps
80106fba:	e9 04 f8 ff ff       	jmp    801067c3 <alltraps>

80106fbf <vector54>:
.globl vector54
vector54:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $54
80106fc1:	6a 36                	push   $0x36
  jmp alltraps
80106fc3:	e9 fb f7 ff ff       	jmp    801067c3 <alltraps>

80106fc8 <vector55>:
.globl vector55
vector55:
  pushl $0
80106fc8:	6a 00                	push   $0x0
  pushl $55
80106fca:	6a 37                	push   $0x37
  jmp alltraps
80106fcc:	e9 f2 f7 ff ff       	jmp    801067c3 <alltraps>

80106fd1 <vector56>:
.globl vector56
vector56:
  pushl $0
80106fd1:	6a 00                	push   $0x0
  pushl $56
80106fd3:	6a 38                	push   $0x38
  jmp alltraps
80106fd5:	e9 e9 f7 ff ff       	jmp    801067c3 <alltraps>

80106fda <vector57>:
.globl vector57
vector57:
  pushl $0
80106fda:	6a 00                	push   $0x0
  pushl $57
80106fdc:	6a 39                	push   $0x39
  jmp alltraps
80106fde:	e9 e0 f7 ff ff       	jmp    801067c3 <alltraps>

80106fe3 <vector58>:
.globl vector58
vector58:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $58
80106fe5:	6a 3a                	push   $0x3a
  jmp alltraps
80106fe7:	e9 d7 f7 ff ff       	jmp    801067c3 <alltraps>

80106fec <vector59>:
.globl vector59
vector59:
  pushl $0
80106fec:	6a 00                	push   $0x0
  pushl $59
80106fee:	6a 3b                	push   $0x3b
  jmp alltraps
80106ff0:	e9 ce f7 ff ff       	jmp    801067c3 <alltraps>

80106ff5 <vector60>:
.globl vector60
vector60:
  pushl $0
80106ff5:	6a 00                	push   $0x0
  pushl $60
80106ff7:	6a 3c                	push   $0x3c
  jmp alltraps
80106ff9:	e9 c5 f7 ff ff       	jmp    801067c3 <alltraps>

80106ffe <vector61>:
.globl vector61
vector61:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $61
80107000:	6a 3d                	push   $0x3d
  jmp alltraps
80107002:	e9 bc f7 ff ff       	jmp    801067c3 <alltraps>

80107007 <vector62>:
.globl vector62
vector62:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $62
80107009:	6a 3e                	push   $0x3e
  jmp alltraps
8010700b:	e9 b3 f7 ff ff       	jmp    801067c3 <alltraps>

80107010 <vector63>:
.globl vector63
vector63:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $63
80107012:	6a 3f                	push   $0x3f
  jmp alltraps
80107014:	e9 aa f7 ff ff       	jmp    801067c3 <alltraps>

80107019 <vector64>:
.globl vector64
vector64:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $64
8010701b:	6a 40                	push   $0x40
  jmp alltraps
8010701d:	e9 a1 f7 ff ff       	jmp    801067c3 <alltraps>

80107022 <vector65>:
.globl vector65
vector65:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $65
80107024:	6a 41                	push   $0x41
  jmp alltraps
80107026:	e9 98 f7 ff ff       	jmp    801067c3 <alltraps>

8010702b <vector66>:
.globl vector66
vector66:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $66
8010702d:	6a 42                	push   $0x42
  jmp alltraps
8010702f:	e9 8f f7 ff ff       	jmp    801067c3 <alltraps>

80107034 <vector67>:
.globl vector67
vector67:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $67
80107036:	6a 43                	push   $0x43
  jmp alltraps
80107038:	e9 86 f7 ff ff       	jmp    801067c3 <alltraps>

8010703d <vector68>:
.globl vector68
vector68:
  pushl $0
8010703d:	6a 00                	push   $0x0
  pushl $68
8010703f:	6a 44                	push   $0x44
  jmp alltraps
80107041:	e9 7d f7 ff ff       	jmp    801067c3 <alltraps>

80107046 <vector69>:
.globl vector69
vector69:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $69
80107048:	6a 45                	push   $0x45
  jmp alltraps
8010704a:	e9 74 f7 ff ff       	jmp    801067c3 <alltraps>

8010704f <vector70>:
.globl vector70
vector70:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $70
80107051:	6a 46                	push   $0x46
  jmp alltraps
80107053:	e9 6b f7 ff ff       	jmp    801067c3 <alltraps>

80107058 <vector71>:
.globl vector71
vector71:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $71
8010705a:	6a 47                	push   $0x47
  jmp alltraps
8010705c:	e9 62 f7 ff ff       	jmp    801067c3 <alltraps>

80107061 <vector72>:
.globl vector72
vector72:
  pushl $0
80107061:	6a 00                	push   $0x0
  pushl $72
80107063:	6a 48                	push   $0x48
  jmp alltraps
80107065:	e9 59 f7 ff ff       	jmp    801067c3 <alltraps>

8010706a <vector73>:
.globl vector73
vector73:
  pushl $0
8010706a:	6a 00                	push   $0x0
  pushl $73
8010706c:	6a 49                	push   $0x49
  jmp alltraps
8010706e:	e9 50 f7 ff ff       	jmp    801067c3 <alltraps>

80107073 <vector74>:
.globl vector74
vector74:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $74
80107075:	6a 4a                	push   $0x4a
  jmp alltraps
80107077:	e9 47 f7 ff ff       	jmp    801067c3 <alltraps>

8010707c <vector75>:
.globl vector75
vector75:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $75
8010707e:	6a 4b                	push   $0x4b
  jmp alltraps
80107080:	e9 3e f7 ff ff       	jmp    801067c3 <alltraps>

80107085 <vector76>:
.globl vector76
vector76:
  pushl $0
80107085:	6a 00                	push   $0x0
  pushl $76
80107087:	6a 4c                	push   $0x4c
  jmp alltraps
80107089:	e9 35 f7 ff ff       	jmp    801067c3 <alltraps>

8010708e <vector77>:
.globl vector77
vector77:
  pushl $0
8010708e:	6a 00                	push   $0x0
  pushl $77
80107090:	6a 4d                	push   $0x4d
  jmp alltraps
80107092:	e9 2c f7 ff ff       	jmp    801067c3 <alltraps>

80107097 <vector78>:
.globl vector78
vector78:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $78
80107099:	6a 4e                	push   $0x4e
  jmp alltraps
8010709b:	e9 23 f7 ff ff       	jmp    801067c3 <alltraps>

801070a0 <vector79>:
.globl vector79
vector79:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $79
801070a2:	6a 4f                	push   $0x4f
  jmp alltraps
801070a4:	e9 1a f7 ff ff       	jmp    801067c3 <alltraps>

801070a9 <vector80>:
.globl vector80
vector80:
  pushl $0
801070a9:	6a 00                	push   $0x0
  pushl $80
801070ab:	6a 50                	push   $0x50
  jmp alltraps
801070ad:	e9 11 f7 ff ff       	jmp    801067c3 <alltraps>

801070b2 <vector81>:
.globl vector81
vector81:
  pushl $0
801070b2:	6a 00                	push   $0x0
  pushl $81
801070b4:	6a 51                	push   $0x51
  jmp alltraps
801070b6:	e9 08 f7 ff ff       	jmp    801067c3 <alltraps>

801070bb <vector82>:
.globl vector82
vector82:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $82
801070bd:	6a 52                	push   $0x52
  jmp alltraps
801070bf:	e9 ff f6 ff ff       	jmp    801067c3 <alltraps>

801070c4 <vector83>:
.globl vector83
vector83:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $83
801070c6:	6a 53                	push   $0x53
  jmp alltraps
801070c8:	e9 f6 f6 ff ff       	jmp    801067c3 <alltraps>

801070cd <vector84>:
.globl vector84
vector84:
  pushl $0
801070cd:	6a 00                	push   $0x0
  pushl $84
801070cf:	6a 54                	push   $0x54
  jmp alltraps
801070d1:	e9 ed f6 ff ff       	jmp    801067c3 <alltraps>

801070d6 <vector85>:
.globl vector85
vector85:
  pushl $0
801070d6:	6a 00                	push   $0x0
  pushl $85
801070d8:	6a 55                	push   $0x55
  jmp alltraps
801070da:	e9 e4 f6 ff ff       	jmp    801067c3 <alltraps>

801070df <vector86>:
.globl vector86
vector86:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $86
801070e1:	6a 56                	push   $0x56
  jmp alltraps
801070e3:	e9 db f6 ff ff       	jmp    801067c3 <alltraps>

801070e8 <vector87>:
.globl vector87
vector87:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $87
801070ea:	6a 57                	push   $0x57
  jmp alltraps
801070ec:	e9 d2 f6 ff ff       	jmp    801067c3 <alltraps>

801070f1 <vector88>:
.globl vector88
vector88:
  pushl $0
801070f1:	6a 00                	push   $0x0
  pushl $88
801070f3:	6a 58                	push   $0x58
  jmp alltraps
801070f5:	e9 c9 f6 ff ff       	jmp    801067c3 <alltraps>

801070fa <vector89>:
.globl vector89
vector89:
  pushl $0
801070fa:	6a 00                	push   $0x0
  pushl $89
801070fc:	6a 59                	push   $0x59
  jmp alltraps
801070fe:	e9 c0 f6 ff ff       	jmp    801067c3 <alltraps>

80107103 <vector90>:
.globl vector90
vector90:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $90
80107105:	6a 5a                	push   $0x5a
  jmp alltraps
80107107:	e9 b7 f6 ff ff       	jmp    801067c3 <alltraps>

8010710c <vector91>:
.globl vector91
vector91:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $91
8010710e:	6a 5b                	push   $0x5b
  jmp alltraps
80107110:	e9 ae f6 ff ff       	jmp    801067c3 <alltraps>

80107115 <vector92>:
.globl vector92
vector92:
  pushl $0
80107115:	6a 00                	push   $0x0
  pushl $92
80107117:	6a 5c                	push   $0x5c
  jmp alltraps
80107119:	e9 a5 f6 ff ff       	jmp    801067c3 <alltraps>

8010711e <vector93>:
.globl vector93
vector93:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $93
80107120:	6a 5d                	push   $0x5d
  jmp alltraps
80107122:	e9 9c f6 ff ff       	jmp    801067c3 <alltraps>

80107127 <vector94>:
.globl vector94
vector94:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $94
80107129:	6a 5e                	push   $0x5e
  jmp alltraps
8010712b:	e9 93 f6 ff ff       	jmp    801067c3 <alltraps>

80107130 <vector95>:
.globl vector95
vector95:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $95
80107132:	6a 5f                	push   $0x5f
  jmp alltraps
80107134:	e9 8a f6 ff ff       	jmp    801067c3 <alltraps>

80107139 <vector96>:
.globl vector96
vector96:
  pushl $0
80107139:	6a 00                	push   $0x0
  pushl $96
8010713b:	6a 60                	push   $0x60
  jmp alltraps
8010713d:	e9 81 f6 ff ff       	jmp    801067c3 <alltraps>

80107142 <vector97>:
.globl vector97
vector97:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $97
80107144:	6a 61                	push   $0x61
  jmp alltraps
80107146:	e9 78 f6 ff ff       	jmp    801067c3 <alltraps>

8010714b <vector98>:
.globl vector98
vector98:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $98
8010714d:	6a 62                	push   $0x62
  jmp alltraps
8010714f:	e9 6f f6 ff ff       	jmp    801067c3 <alltraps>

80107154 <vector99>:
.globl vector99
vector99:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $99
80107156:	6a 63                	push   $0x63
  jmp alltraps
80107158:	e9 66 f6 ff ff       	jmp    801067c3 <alltraps>

8010715d <vector100>:
.globl vector100
vector100:
  pushl $0
8010715d:	6a 00                	push   $0x0
  pushl $100
8010715f:	6a 64                	push   $0x64
  jmp alltraps
80107161:	e9 5d f6 ff ff       	jmp    801067c3 <alltraps>

80107166 <vector101>:
.globl vector101
vector101:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $101
80107168:	6a 65                	push   $0x65
  jmp alltraps
8010716a:	e9 54 f6 ff ff       	jmp    801067c3 <alltraps>

8010716f <vector102>:
.globl vector102
vector102:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $102
80107171:	6a 66                	push   $0x66
  jmp alltraps
80107173:	e9 4b f6 ff ff       	jmp    801067c3 <alltraps>

80107178 <vector103>:
.globl vector103
vector103:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $103
8010717a:	6a 67                	push   $0x67
  jmp alltraps
8010717c:	e9 42 f6 ff ff       	jmp    801067c3 <alltraps>

80107181 <vector104>:
.globl vector104
vector104:
  pushl $0
80107181:	6a 00                	push   $0x0
  pushl $104
80107183:	6a 68                	push   $0x68
  jmp alltraps
80107185:	e9 39 f6 ff ff       	jmp    801067c3 <alltraps>

8010718a <vector105>:
.globl vector105
vector105:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $105
8010718c:	6a 69                	push   $0x69
  jmp alltraps
8010718e:	e9 30 f6 ff ff       	jmp    801067c3 <alltraps>

80107193 <vector106>:
.globl vector106
vector106:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $106
80107195:	6a 6a                	push   $0x6a
  jmp alltraps
80107197:	e9 27 f6 ff ff       	jmp    801067c3 <alltraps>

8010719c <vector107>:
.globl vector107
vector107:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $107
8010719e:	6a 6b                	push   $0x6b
  jmp alltraps
801071a0:	e9 1e f6 ff ff       	jmp    801067c3 <alltraps>

801071a5 <vector108>:
.globl vector108
vector108:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $108
801071a7:	6a 6c                	push   $0x6c
  jmp alltraps
801071a9:	e9 15 f6 ff ff       	jmp    801067c3 <alltraps>

801071ae <vector109>:
.globl vector109
vector109:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $109
801071b0:	6a 6d                	push   $0x6d
  jmp alltraps
801071b2:	e9 0c f6 ff ff       	jmp    801067c3 <alltraps>

801071b7 <vector110>:
.globl vector110
vector110:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $110
801071b9:	6a 6e                	push   $0x6e
  jmp alltraps
801071bb:	e9 03 f6 ff ff       	jmp    801067c3 <alltraps>

801071c0 <vector111>:
.globl vector111
vector111:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $111
801071c2:	6a 6f                	push   $0x6f
  jmp alltraps
801071c4:	e9 fa f5 ff ff       	jmp    801067c3 <alltraps>

801071c9 <vector112>:
.globl vector112
vector112:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $112
801071cb:	6a 70                	push   $0x70
  jmp alltraps
801071cd:	e9 f1 f5 ff ff       	jmp    801067c3 <alltraps>

801071d2 <vector113>:
.globl vector113
vector113:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $113
801071d4:	6a 71                	push   $0x71
  jmp alltraps
801071d6:	e9 e8 f5 ff ff       	jmp    801067c3 <alltraps>

801071db <vector114>:
.globl vector114
vector114:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $114
801071dd:	6a 72                	push   $0x72
  jmp alltraps
801071df:	e9 df f5 ff ff       	jmp    801067c3 <alltraps>

801071e4 <vector115>:
.globl vector115
vector115:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $115
801071e6:	6a 73                	push   $0x73
  jmp alltraps
801071e8:	e9 d6 f5 ff ff       	jmp    801067c3 <alltraps>

801071ed <vector116>:
.globl vector116
vector116:
  pushl $0
801071ed:	6a 00                	push   $0x0
  pushl $116
801071ef:	6a 74                	push   $0x74
  jmp alltraps
801071f1:	e9 cd f5 ff ff       	jmp    801067c3 <alltraps>

801071f6 <vector117>:
.globl vector117
vector117:
  pushl $0
801071f6:	6a 00                	push   $0x0
  pushl $117
801071f8:	6a 75                	push   $0x75
  jmp alltraps
801071fa:	e9 c4 f5 ff ff       	jmp    801067c3 <alltraps>

801071ff <vector118>:
.globl vector118
vector118:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $118
80107201:	6a 76                	push   $0x76
  jmp alltraps
80107203:	e9 bb f5 ff ff       	jmp    801067c3 <alltraps>

80107208 <vector119>:
.globl vector119
vector119:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $119
8010720a:	6a 77                	push   $0x77
  jmp alltraps
8010720c:	e9 b2 f5 ff ff       	jmp    801067c3 <alltraps>

80107211 <vector120>:
.globl vector120
vector120:
  pushl $0
80107211:	6a 00                	push   $0x0
  pushl $120
80107213:	6a 78                	push   $0x78
  jmp alltraps
80107215:	e9 a9 f5 ff ff       	jmp    801067c3 <alltraps>

8010721a <vector121>:
.globl vector121
vector121:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $121
8010721c:	6a 79                	push   $0x79
  jmp alltraps
8010721e:	e9 a0 f5 ff ff       	jmp    801067c3 <alltraps>

80107223 <vector122>:
.globl vector122
vector122:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $122
80107225:	6a 7a                	push   $0x7a
  jmp alltraps
80107227:	e9 97 f5 ff ff       	jmp    801067c3 <alltraps>

8010722c <vector123>:
.globl vector123
vector123:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $123
8010722e:	6a 7b                	push   $0x7b
  jmp alltraps
80107230:	e9 8e f5 ff ff       	jmp    801067c3 <alltraps>

80107235 <vector124>:
.globl vector124
vector124:
  pushl $0
80107235:	6a 00                	push   $0x0
  pushl $124
80107237:	6a 7c                	push   $0x7c
  jmp alltraps
80107239:	e9 85 f5 ff ff       	jmp    801067c3 <alltraps>

8010723e <vector125>:
.globl vector125
vector125:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $125
80107240:	6a 7d                	push   $0x7d
  jmp alltraps
80107242:	e9 7c f5 ff ff       	jmp    801067c3 <alltraps>

80107247 <vector126>:
.globl vector126
vector126:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $126
80107249:	6a 7e                	push   $0x7e
  jmp alltraps
8010724b:	e9 73 f5 ff ff       	jmp    801067c3 <alltraps>

80107250 <vector127>:
.globl vector127
vector127:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $127
80107252:	6a 7f                	push   $0x7f
  jmp alltraps
80107254:	e9 6a f5 ff ff       	jmp    801067c3 <alltraps>

80107259 <vector128>:
.globl vector128
vector128:
  pushl $0
80107259:	6a 00                	push   $0x0
  pushl $128
8010725b:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107260:	e9 5e f5 ff ff       	jmp    801067c3 <alltraps>

80107265 <vector129>:
.globl vector129
vector129:
  pushl $0
80107265:	6a 00                	push   $0x0
  pushl $129
80107267:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010726c:	e9 52 f5 ff ff       	jmp    801067c3 <alltraps>

80107271 <vector130>:
.globl vector130
vector130:
  pushl $0
80107271:	6a 00                	push   $0x0
  pushl $130
80107273:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107278:	e9 46 f5 ff ff       	jmp    801067c3 <alltraps>

8010727d <vector131>:
.globl vector131
vector131:
  pushl $0
8010727d:	6a 00                	push   $0x0
  pushl $131
8010727f:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107284:	e9 3a f5 ff ff       	jmp    801067c3 <alltraps>

80107289 <vector132>:
.globl vector132
vector132:
  pushl $0
80107289:	6a 00                	push   $0x0
  pushl $132
8010728b:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107290:	e9 2e f5 ff ff       	jmp    801067c3 <alltraps>

80107295 <vector133>:
.globl vector133
vector133:
  pushl $0
80107295:	6a 00                	push   $0x0
  pushl $133
80107297:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010729c:	e9 22 f5 ff ff       	jmp    801067c3 <alltraps>

801072a1 <vector134>:
.globl vector134
vector134:
  pushl $0
801072a1:	6a 00                	push   $0x0
  pushl $134
801072a3:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801072a8:	e9 16 f5 ff ff       	jmp    801067c3 <alltraps>

801072ad <vector135>:
.globl vector135
vector135:
  pushl $0
801072ad:	6a 00                	push   $0x0
  pushl $135
801072af:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801072b4:	e9 0a f5 ff ff       	jmp    801067c3 <alltraps>

801072b9 <vector136>:
.globl vector136
vector136:
  pushl $0
801072b9:	6a 00                	push   $0x0
  pushl $136
801072bb:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801072c0:	e9 fe f4 ff ff       	jmp    801067c3 <alltraps>

801072c5 <vector137>:
.globl vector137
vector137:
  pushl $0
801072c5:	6a 00                	push   $0x0
  pushl $137
801072c7:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801072cc:	e9 f2 f4 ff ff       	jmp    801067c3 <alltraps>

801072d1 <vector138>:
.globl vector138
vector138:
  pushl $0
801072d1:	6a 00                	push   $0x0
  pushl $138
801072d3:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801072d8:	e9 e6 f4 ff ff       	jmp    801067c3 <alltraps>

801072dd <vector139>:
.globl vector139
vector139:
  pushl $0
801072dd:	6a 00                	push   $0x0
  pushl $139
801072df:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801072e4:	e9 da f4 ff ff       	jmp    801067c3 <alltraps>

801072e9 <vector140>:
.globl vector140
vector140:
  pushl $0
801072e9:	6a 00                	push   $0x0
  pushl $140
801072eb:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801072f0:	e9 ce f4 ff ff       	jmp    801067c3 <alltraps>

801072f5 <vector141>:
.globl vector141
vector141:
  pushl $0
801072f5:	6a 00                	push   $0x0
  pushl $141
801072f7:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801072fc:	e9 c2 f4 ff ff       	jmp    801067c3 <alltraps>

80107301 <vector142>:
.globl vector142
vector142:
  pushl $0
80107301:	6a 00                	push   $0x0
  pushl $142
80107303:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107308:	e9 b6 f4 ff ff       	jmp    801067c3 <alltraps>

8010730d <vector143>:
.globl vector143
vector143:
  pushl $0
8010730d:	6a 00                	push   $0x0
  pushl $143
8010730f:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107314:	e9 aa f4 ff ff       	jmp    801067c3 <alltraps>

80107319 <vector144>:
.globl vector144
vector144:
  pushl $0
80107319:	6a 00                	push   $0x0
  pushl $144
8010731b:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107320:	e9 9e f4 ff ff       	jmp    801067c3 <alltraps>

80107325 <vector145>:
.globl vector145
vector145:
  pushl $0
80107325:	6a 00                	push   $0x0
  pushl $145
80107327:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010732c:	e9 92 f4 ff ff       	jmp    801067c3 <alltraps>

80107331 <vector146>:
.globl vector146
vector146:
  pushl $0
80107331:	6a 00                	push   $0x0
  pushl $146
80107333:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107338:	e9 86 f4 ff ff       	jmp    801067c3 <alltraps>

8010733d <vector147>:
.globl vector147
vector147:
  pushl $0
8010733d:	6a 00                	push   $0x0
  pushl $147
8010733f:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107344:	e9 7a f4 ff ff       	jmp    801067c3 <alltraps>

80107349 <vector148>:
.globl vector148
vector148:
  pushl $0
80107349:	6a 00                	push   $0x0
  pushl $148
8010734b:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107350:	e9 6e f4 ff ff       	jmp    801067c3 <alltraps>

80107355 <vector149>:
.globl vector149
vector149:
  pushl $0
80107355:	6a 00                	push   $0x0
  pushl $149
80107357:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010735c:	e9 62 f4 ff ff       	jmp    801067c3 <alltraps>

80107361 <vector150>:
.globl vector150
vector150:
  pushl $0
80107361:	6a 00                	push   $0x0
  pushl $150
80107363:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107368:	e9 56 f4 ff ff       	jmp    801067c3 <alltraps>

8010736d <vector151>:
.globl vector151
vector151:
  pushl $0
8010736d:	6a 00                	push   $0x0
  pushl $151
8010736f:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107374:	e9 4a f4 ff ff       	jmp    801067c3 <alltraps>

80107379 <vector152>:
.globl vector152
vector152:
  pushl $0
80107379:	6a 00                	push   $0x0
  pushl $152
8010737b:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107380:	e9 3e f4 ff ff       	jmp    801067c3 <alltraps>

80107385 <vector153>:
.globl vector153
vector153:
  pushl $0
80107385:	6a 00                	push   $0x0
  pushl $153
80107387:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010738c:	e9 32 f4 ff ff       	jmp    801067c3 <alltraps>

80107391 <vector154>:
.globl vector154
vector154:
  pushl $0
80107391:	6a 00                	push   $0x0
  pushl $154
80107393:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107398:	e9 26 f4 ff ff       	jmp    801067c3 <alltraps>

8010739d <vector155>:
.globl vector155
vector155:
  pushl $0
8010739d:	6a 00                	push   $0x0
  pushl $155
8010739f:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801073a4:	e9 1a f4 ff ff       	jmp    801067c3 <alltraps>

801073a9 <vector156>:
.globl vector156
vector156:
  pushl $0
801073a9:	6a 00                	push   $0x0
  pushl $156
801073ab:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801073b0:	e9 0e f4 ff ff       	jmp    801067c3 <alltraps>

801073b5 <vector157>:
.globl vector157
vector157:
  pushl $0
801073b5:	6a 00                	push   $0x0
  pushl $157
801073b7:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801073bc:	e9 02 f4 ff ff       	jmp    801067c3 <alltraps>

801073c1 <vector158>:
.globl vector158
vector158:
  pushl $0
801073c1:	6a 00                	push   $0x0
  pushl $158
801073c3:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801073c8:	e9 f6 f3 ff ff       	jmp    801067c3 <alltraps>

801073cd <vector159>:
.globl vector159
vector159:
  pushl $0
801073cd:	6a 00                	push   $0x0
  pushl $159
801073cf:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801073d4:	e9 ea f3 ff ff       	jmp    801067c3 <alltraps>

801073d9 <vector160>:
.globl vector160
vector160:
  pushl $0
801073d9:	6a 00                	push   $0x0
  pushl $160
801073db:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801073e0:	e9 de f3 ff ff       	jmp    801067c3 <alltraps>

801073e5 <vector161>:
.globl vector161
vector161:
  pushl $0
801073e5:	6a 00                	push   $0x0
  pushl $161
801073e7:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801073ec:	e9 d2 f3 ff ff       	jmp    801067c3 <alltraps>

801073f1 <vector162>:
.globl vector162
vector162:
  pushl $0
801073f1:	6a 00                	push   $0x0
  pushl $162
801073f3:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801073f8:	e9 c6 f3 ff ff       	jmp    801067c3 <alltraps>

801073fd <vector163>:
.globl vector163
vector163:
  pushl $0
801073fd:	6a 00                	push   $0x0
  pushl $163
801073ff:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107404:	e9 ba f3 ff ff       	jmp    801067c3 <alltraps>

80107409 <vector164>:
.globl vector164
vector164:
  pushl $0
80107409:	6a 00                	push   $0x0
  pushl $164
8010740b:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107410:	e9 ae f3 ff ff       	jmp    801067c3 <alltraps>

80107415 <vector165>:
.globl vector165
vector165:
  pushl $0
80107415:	6a 00                	push   $0x0
  pushl $165
80107417:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010741c:	e9 a2 f3 ff ff       	jmp    801067c3 <alltraps>

80107421 <vector166>:
.globl vector166
vector166:
  pushl $0
80107421:	6a 00                	push   $0x0
  pushl $166
80107423:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107428:	e9 96 f3 ff ff       	jmp    801067c3 <alltraps>

8010742d <vector167>:
.globl vector167
vector167:
  pushl $0
8010742d:	6a 00                	push   $0x0
  pushl $167
8010742f:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107434:	e9 8a f3 ff ff       	jmp    801067c3 <alltraps>

80107439 <vector168>:
.globl vector168
vector168:
  pushl $0
80107439:	6a 00                	push   $0x0
  pushl $168
8010743b:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107440:	e9 7e f3 ff ff       	jmp    801067c3 <alltraps>

80107445 <vector169>:
.globl vector169
vector169:
  pushl $0
80107445:	6a 00                	push   $0x0
  pushl $169
80107447:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010744c:	e9 72 f3 ff ff       	jmp    801067c3 <alltraps>

80107451 <vector170>:
.globl vector170
vector170:
  pushl $0
80107451:	6a 00                	push   $0x0
  pushl $170
80107453:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107458:	e9 66 f3 ff ff       	jmp    801067c3 <alltraps>

8010745d <vector171>:
.globl vector171
vector171:
  pushl $0
8010745d:	6a 00                	push   $0x0
  pushl $171
8010745f:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107464:	e9 5a f3 ff ff       	jmp    801067c3 <alltraps>

80107469 <vector172>:
.globl vector172
vector172:
  pushl $0
80107469:	6a 00                	push   $0x0
  pushl $172
8010746b:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107470:	e9 4e f3 ff ff       	jmp    801067c3 <alltraps>

80107475 <vector173>:
.globl vector173
vector173:
  pushl $0
80107475:	6a 00                	push   $0x0
  pushl $173
80107477:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010747c:	e9 42 f3 ff ff       	jmp    801067c3 <alltraps>

80107481 <vector174>:
.globl vector174
vector174:
  pushl $0
80107481:	6a 00                	push   $0x0
  pushl $174
80107483:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107488:	e9 36 f3 ff ff       	jmp    801067c3 <alltraps>

8010748d <vector175>:
.globl vector175
vector175:
  pushl $0
8010748d:	6a 00                	push   $0x0
  pushl $175
8010748f:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107494:	e9 2a f3 ff ff       	jmp    801067c3 <alltraps>

80107499 <vector176>:
.globl vector176
vector176:
  pushl $0
80107499:	6a 00                	push   $0x0
  pushl $176
8010749b:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801074a0:	e9 1e f3 ff ff       	jmp    801067c3 <alltraps>

801074a5 <vector177>:
.globl vector177
vector177:
  pushl $0
801074a5:	6a 00                	push   $0x0
  pushl $177
801074a7:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801074ac:	e9 12 f3 ff ff       	jmp    801067c3 <alltraps>

801074b1 <vector178>:
.globl vector178
vector178:
  pushl $0
801074b1:	6a 00                	push   $0x0
  pushl $178
801074b3:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801074b8:	e9 06 f3 ff ff       	jmp    801067c3 <alltraps>

801074bd <vector179>:
.globl vector179
vector179:
  pushl $0
801074bd:	6a 00                	push   $0x0
  pushl $179
801074bf:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801074c4:	e9 fa f2 ff ff       	jmp    801067c3 <alltraps>

801074c9 <vector180>:
.globl vector180
vector180:
  pushl $0
801074c9:	6a 00                	push   $0x0
  pushl $180
801074cb:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801074d0:	e9 ee f2 ff ff       	jmp    801067c3 <alltraps>

801074d5 <vector181>:
.globl vector181
vector181:
  pushl $0
801074d5:	6a 00                	push   $0x0
  pushl $181
801074d7:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801074dc:	e9 e2 f2 ff ff       	jmp    801067c3 <alltraps>

801074e1 <vector182>:
.globl vector182
vector182:
  pushl $0
801074e1:	6a 00                	push   $0x0
  pushl $182
801074e3:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801074e8:	e9 d6 f2 ff ff       	jmp    801067c3 <alltraps>

801074ed <vector183>:
.globl vector183
vector183:
  pushl $0
801074ed:	6a 00                	push   $0x0
  pushl $183
801074ef:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801074f4:	e9 ca f2 ff ff       	jmp    801067c3 <alltraps>

801074f9 <vector184>:
.globl vector184
vector184:
  pushl $0
801074f9:	6a 00                	push   $0x0
  pushl $184
801074fb:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107500:	e9 be f2 ff ff       	jmp    801067c3 <alltraps>

80107505 <vector185>:
.globl vector185
vector185:
  pushl $0
80107505:	6a 00                	push   $0x0
  pushl $185
80107507:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010750c:	e9 b2 f2 ff ff       	jmp    801067c3 <alltraps>

80107511 <vector186>:
.globl vector186
vector186:
  pushl $0
80107511:	6a 00                	push   $0x0
  pushl $186
80107513:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107518:	e9 a6 f2 ff ff       	jmp    801067c3 <alltraps>

8010751d <vector187>:
.globl vector187
vector187:
  pushl $0
8010751d:	6a 00                	push   $0x0
  pushl $187
8010751f:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107524:	e9 9a f2 ff ff       	jmp    801067c3 <alltraps>

80107529 <vector188>:
.globl vector188
vector188:
  pushl $0
80107529:	6a 00                	push   $0x0
  pushl $188
8010752b:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107530:	e9 8e f2 ff ff       	jmp    801067c3 <alltraps>

80107535 <vector189>:
.globl vector189
vector189:
  pushl $0
80107535:	6a 00                	push   $0x0
  pushl $189
80107537:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010753c:	e9 82 f2 ff ff       	jmp    801067c3 <alltraps>

80107541 <vector190>:
.globl vector190
vector190:
  pushl $0
80107541:	6a 00                	push   $0x0
  pushl $190
80107543:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107548:	e9 76 f2 ff ff       	jmp    801067c3 <alltraps>

8010754d <vector191>:
.globl vector191
vector191:
  pushl $0
8010754d:	6a 00                	push   $0x0
  pushl $191
8010754f:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107554:	e9 6a f2 ff ff       	jmp    801067c3 <alltraps>

80107559 <vector192>:
.globl vector192
vector192:
  pushl $0
80107559:	6a 00                	push   $0x0
  pushl $192
8010755b:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107560:	e9 5e f2 ff ff       	jmp    801067c3 <alltraps>

80107565 <vector193>:
.globl vector193
vector193:
  pushl $0
80107565:	6a 00                	push   $0x0
  pushl $193
80107567:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010756c:	e9 52 f2 ff ff       	jmp    801067c3 <alltraps>

80107571 <vector194>:
.globl vector194
vector194:
  pushl $0
80107571:	6a 00                	push   $0x0
  pushl $194
80107573:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107578:	e9 46 f2 ff ff       	jmp    801067c3 <alltraps>

8010757d <vector195>:
.globl vector195
vector195:
  pushl $0
8010757d:	6a 00                	push   $0x0
  pushl $195
8010757f:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107584:	e9 3a f2 ff ff       	jmp    801067c3 <alltraps>

80107589 <vector196>:
.globl vector196
vector196:
  pushl $0
80107589:	6a 00                	push   $0x0
  pushl $196
8010758b:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107590:	e9 2e f2 ff ff       	jmp    801067c3 <alltraps>

80107595 <vector197>:
.globl vector197
vector197:
  pushl $0
80107595:	6a 00                	push   $0x0
  pushl $197
80107597:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010759c:	e9 22 f2 ff ff       	jmp    801067c3 <alltraps>

801075a1 <vector198>:
.globl vector198
vector198:
  pushl $0
801075a1:	6a 00                	push   $0x0
  pushl $198
801075a3:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801075a8:	e9 16 f2 ff ff       	jmp    801067c3 <alltraps>

801075ad <vector199>:
.globl vector199
vector199:
  pushl $0
801075ad:	6a 00                	push   $0x0
  pushl $199
801075af:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801075b4:	e9 0a f2 ff ff       	jmp    801067c3 <alltraps>

801075b9 <vector200>:
.globl vector200
vector200:
  pushl $0
801075b9:	6a 00                	push   $0x0
  pushl $200
801075bb:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801075c0:	e9 fe f1 ff ff       	jmp    801067c3 <alltraps>

801075c5 <vector201>:
.globl vector201
vector201:
  pushl $0
801075c5:	6a 00                	push   $0x0
  pushl $201
801075c7:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801075cc:	e9 f2 f1 ff ff       	jmp    801067c3 <alltraps>

801075d1 <vector202>:
.globl vector202
vector202:
  pushl $0
801075d1:	6a 00                	push   $0x0
  pushl $202
801075d3:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801075d8:	e9 e6 f1 ff ff       	jmp    801067c3 <alltraps>

801075dd <vector203>:
.globl vector203
vector203:
  pushl $0
801075dd:	6a 00                	push   $0x0
  pushl $203
801075df:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801075e4:	e9 da f1 ff ff       	jmp    801067c3 <alltraps>

801075e9 <vector204>:
.globl vector204
vector204:
  pushl $0
801075e9:	6a 00                	push   $0x0
  pushl $204
801075eb:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801075f0:	e9 ce f1 ff ff       	jmp    801067c3 <alltraps>

801075f5 <vector205>:
.globl vector205
vector205:
  pushl $0
801075f5:	6a 00                	push   $0x0
  pushl $205
801075f7:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801075fc:	e9 c2 f1 ff ff       	jmp    801067c3 <alltraps>

80107601 <vector206>:
.globl vector206
vector206:
  pushl $0
80107601:	6a 00                	push   $0x0
  pushl $206
80107603:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107608:	e9 b6 f1 ff ff       	jmp    801067c3 <alltraps>

8010760d <vector207>:
.globl vector207
vector207:
  pushl $0
8010760d:	6a 00                	push   $0x0
  pushl $207
8010760f:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107614:	e9 aa f1 ff ff       	jmp    801067c3 <alltraps>

80107619 <vector208>:
.globl vector208
vector208:
  pushl $0
80107619:	6a 00                	push   $0x0
  pushl $208
8010761b:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107620:	e9 9e f1 ff ff       	jmp    801067c3 <alltraps>

80107625 <vector209>:
.globl vector209
vector209:
  pushl $0
80107625:	6a 00                	push   $0x0
  pushl $209
80107627:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010762c:	e9 92 f1 ff ff       	jmp    801067c3 <alltraps>

80107631 <vector210>:
.globl vector210
vector210:
  pushl $0
80107631:	6a 00                	push   $0x0
  pushl $210
80107633:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107638:	e9 86 f1 ff ff       	jmp    801067c3 <alltraps>

8010763d <vector211>:
.globl vector211
vector211:
  pushl $0
8010763d:	6a 00                	push   $0x0
  pushl $211
8010763f:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107644:	e9 7a f1 ff ff       	jmp    801067c3 <alltraps>

80107649 <vector212>:
.globl vector212
vector212:
  pushl $0
80107649:	6a 00                	push   $0x0
  pushl $212
8010764b:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107650:	e9 6e f1 ff ff       	jmp    801067c3 <alltraps>

80107655 <vector213>:
.globl vector213
vector213:
  pushl $0
80107655:	6a 00                	push   $0x0
  pushl $213
80107657:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010765c:	e9 62 f1 ff ff       	jmp    801067c3 <alltraps>

80107661 <vector214>:
.globl vector214
vector214:
  pushl $0
80107661:	6a 00                	push   $0x0
  pushl $214
80107663:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107668:	e9 56 f1 ff ff       	jmp    801067c3 <alltraps>

8010766d <vector215>:
.globl vector215
vector215:
  pushl $0
8010766d:	6a 00                	push   $0x0
  pushl $215
8010766f:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107674:	e9 4a f1 ff ff       	jmp    801067c3 <alltraps>

80107679 <vector216>:
.globl vector216
vector216:
  pushl $0
80107679:	6a 00                	push   $0x0
  pushl $216
8010767b:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107680:	e9 3e f1 ff ff       	jmp    801067c3 <alltraps>

80107685 <vector217>:
.globl vector217
vector217:
  pushl $0
80107685:	6a 00                	push   $0x0
  pushl $217
80107687:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010768c:	e9 32 f1 ff ff       	jmp    801067c3 <alltraps>

80107691 <vector218>:
.globl vector218
vector218:
  pushl $0
80107691:	6a 00                	push   $0x0
  pushl $218
80107693:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107698:	e9 26 f1 ff ff       	jmp    801067c3 <alltraps>

8010769d <vector219>:
.globl vector219
vector219:
  pushl $0
8010769d:	6a 00                	push   $0x0
  pushl $219
8010769f:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801076a4:	e9 1a f1 ff ff       	jmp    801067c3 <alltraps>

801076a9 <vector220>:
.globl vector220
vector220:
  pushl $0
801076a9:	6a 00                	push   $0x0
  pushl $220
801076ab:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801076b0:	e9 0e f1 ff ff       	jmp    801067c3 <alltraps>

801076b5 <vector221>:
.globl vector221
vector221:
  pushl $0
801076b5:	6a 00                	push   $0x0
  pushl $221
801076b7:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801076bc:	e9 02 f1 ff ff       	jmp    801067c3 <alltraps>

801076c1 <vector222>:
.globl vector222
vector222:
  pushl $0
801076c1:	6a 00                	push   $0x0
  pushl $222
801076c3:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801076c8:	e9 f6 f0 ff ff       	jmp    801067c3 <alltraps>

801076cd <vector223>:
.globl vector223
vector223:
  pushl $0
801076cd:	6a 00                	push   $0x0
  pushl $223
801076cf:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801076d4:	e9 ea f0 ff ff       	jmp    801067c3 <alltraps>

801076d9 <vector224>:
.globl vector224
vector224:
  pushl $0
801076d9:	6a 00                	push   $0x0
  pushl $224
801076db:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801076e0:	e9 de f0 ff ff       	jmp    801067c3 <alltraps>

801076e5 <vector225>:
.globl vector225
vector225:
  pushl $0
801076e5:	6a 00                	push   $0x0
  pushl $225
801076e7:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801076ec:	e9 d2 f0 ff ff       	jmp    801067c3 <alltraps>

801076f1 <vector226>:
.globl vector226
vector226:
  pushl $0
801076f1:	6a 00                	push   $0x0
  pushl $226
801076f3:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801076f8:	e9 c6 f0 ff ff       	jmp    801067c3 <alltraps>

801076fd <vector227>:
.globl vector227
vector227:
  pushl $0
801076fd:	6a 00                	push   $0x0
  pushl $227
801076ff:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107704:	e9 ba f0 ff ff       	jmp    801067c3 <alltraps>

80107709 <vector228>:
.globl vector228
vector228:
  pushl $0
80107709:	6a 00                	push   $0x0
  pushl $228
8010770b:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107710:	e9 ae f0 ff ff       	jmp    801067c3 <alltraps>

80107715 <vector229>:
.globl vector229
vector229:
  pushl $0
80107715:	6a 00                	push   $0x0
  pushl $229
80107717:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010771c:	e9 a2 f0 ff ff       	jmp    801067c3 <alltraps>

80107721 <vector230>:
.globl vector230
vector230:
  pushl $0
80107721:	6a 00                	push   $0x0
  pushl $230
80107723:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107728:	e9 96 f0 ff ff       	jmp    801067c3 <alltraps>

8010772d <vector231>:
.globl vector231
vector231:
  pushl $0
8010772d:	6a 00                	push   $0x0
  pushl $231
8010772f:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107734:	e9 8a f0 ff ff       	jmp    801067c3 <alltraps>

80107739 <vector232>:
.globl vector232
vector232:
  pushl $0
80107739:	6a 00                	push   $0x0
  pushl $232
8010773b:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107740:	e9 7e f0 ff ff       	jmp    801067c3 <alltraps>

80107745 <vector233>:
.globl vector233
vector233:
  pushl $0
80107745:	6a 00                	push   $0x0
  pushl $233
80107747:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010774c:	e9 72 f0 ff ff       	jmp    801067c3 <alltraps>

80107751 <vector234>:
.globl vector234
vector234:
  pushl $0
80107751:	6a 00                	push   $0x0
  pushl $234
80107753:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107758:	e9 66 f0 ff ff       	jmp    801067c3 <alltraps>

8010775d <vector235>:
.globl vector235
vector235:
  pushl $0
8010775d:	6a 00                	push   $0x0
  pushl $235
8010775f:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107764:	e9 5a f0 ff ff       	jmp    801067c3 <alltraps>

80107769 <vector236>:
.globl vector236
vector236:
  pushl $0
80107769:	6a 00                	push   $0x0
  pushl $236
8010776b:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107770:	e9 4e f0 ff ff       	jmp    801067c3 <alltraps>

80107775 <vector237>:
.globl vector237
vector237:
  pushl $0
80107775:	6a 00                	push   $0x0
  pushl $237
80107777:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010777c:	e9 42 f0 ff ff       	jmp    801067c3 <alltraps>

80107781 <vector238>:
.globl vector238
vector238:
  pushl $0
80107781:	6a 00                	push   $0x0
  pushl $238
80107783:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107788:	e9 36 f0 ff ff       	jmp    801067c3 <alltraps>

8010778d <vector239>:
.globl vector239
vector239:
  pushl $0
8010778d:	6a 00                	push   $0x0
  pushl $239
8010778f:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107794:	e9 2a f0 ff ff       	jmp    801067c3 <alltraps>

80107799 <vector240>:
.globl vector240
vector240:
  pushl $0
80107799:	6a 00                	push   $0x0
  pushl $240
8010779b:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801077a0:	e9 1e f0 ff ff       	jmp    801067c3 <alltraps>

801077a5 <vector241>:
.globl vector241
vector241:
  pushl $0
801077a5:	6a 00                	push   $0x0
  pushl $241
801077a7:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801077ac:	e9 12 f0 ff ff       	jmp    801067c3 <alltraps>

801077b1 <vector242>:
.globl vector242
vector242:
  pushl $0
801077b1:	6a 00                	push   $0x0
  pushl $242
801077b3:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801077b8:	e9 06 f0 ff ff       	jmp    801067c3 <alltraps>

801077bd <vector243>:
.globl vector243
vector243:
  pushl $0
801077bd:	6a 00                	push   $0x0
  pushl $243
801077bf:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801077c4:	e9 fa ef ff ff       	jmp    801067c3 <alltraps>

801077c9 <vector244>:
.globl vector244
vector244:
  pushl $0
801077c9:	6a 00                	push   $0x0
  pushl $244
801077cb:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801077d0:	e9 ee ef ff ff       	jmp    801067c3 <alltraps>

801077d5 <vector245>:
.globl vector245
vector245:
  pushl $0
801077d5:	6a 00                	push   $0x0
  pushl $245
801077d7:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801077dc:	e9 e2 ef ff ff       	jmp    801067c3 <alltraps>

801077e1 <vector246>:
.globl vector246
vector246:
  pushl $0
801077e1:	6a 00                	push   $0x0
  pushl $246
801077e3:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801077e8:	e9 d6 ef ff ff       	jmp    801067c3 <alltraps>

801077ed <vector247>:
.globl vector247
vector247:
  pushl $0
801077ed:	6a 00                	push   $0x0
  pushl $247
801077ef:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801077f4:	e9 ca ef ff ff       	jmp    801067c3 <alltraps>

801077f9 <vector248>:
.globl vector248
vector248:
  pushl $0
801077f9:	6a 00                	push   $0x0
  pushl $248
801077fb:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107800:	e9 be ef ff ff       	jmp    801067c3 <alltraps>

80107805 <vector249>:
.globl vector249
vector249:
  pushl $0
80107805:	6a 00                	push   $0x0
  pushl $249
80107807:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010780c:	e9 b2 ef ff ff       	jmp    801067c3 <alltraps>

80107811 <vector250>:
.globl vector250
vector250:
  pushl $0
80107811:	6a 00                	push   $0x0
  pushl $250
80107813:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107818:	e9 a6 ef ff ff       	jmp    801067c3 <alltraps>

8010781d <vector251>:
.globl vector251
vector251:
  pushl $0
8010781d:	6a 00                	push   $0x0
  pushl $251
8010781f:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107824:	e9 9a ef ff ff       	jmp    801067c3 <alltraps>

80107829 <vector252>:
.globl vector252
vector252:
  pushl $0
80107829:	6a 00                	push   $0x0
  pushl $252
8010782b:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107830:	e9 8e ef ff ff       	jmp    801067c3 <alltraps>

80107835 <vector253>:
.globl vector253
vector253:
  pushl $0
80107835:	6a 00                	push   $0x0
  pushl $253
80107837:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010783c:	e9 82 ef ff ff       	jmp    801067c3 <alltraps>

80107841 <vector254>:
.globl vector254
vector254:
  pushl $0
80107841:	6a 00                	push   $0x0
  pushl $254
80107843:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107848:	e9 76 ef ff ff       	jmp    801067c3 <alltraps>

8010784d <vector255>:
.globl vector255
vector255:
  pushl $0
8010784d:	6a 00                	push   $0x0
  pushl $255
8010784f:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107854:	e9 6a ef ff ff       	jmp    801067c3 <alltraps>

80107859 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107859:	55                   	push   %ebp
8010785a:	89 e5                	mov    %esp,%ebp
8010785c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010785f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107862:	83 e8 01             	sub    $0x1,%eax
80107865:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107869:	8b 45 08             	mov    0x8(%ebp),%eax
8010786c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107870:	8b 45 08             	mov    0x8(%ebp),%eax
80107873:	c1 e8 10             	shr    $0x10,%eax
80107876:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010787a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010787d:	0f 01 10             	lgdtl  (%eax)
}
80107880:	90                   	nop
80107881:	c9                   	leave  
80107882:	c3                   	ret    

80107883 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107883:	55                   	push   %ebp
80107884:	89 e5                	mov    %esp,%ebp
80107886:	83 ec 04             	sub    $0x4,%esp
80107889:	8b 45 08             	mov    0x8(%ebp),%eax
8010788c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107890:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107894:	0f 00 d8             	ltr    %ax
}
80107897:	90                   	nop
80107898:	c9                   	leave  
80107899:	c3                   	ret    

8010789a <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
8010789a:	55                   	push   %ebp
8010789b:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010789d:	8b 45 08             	mov    0x8(%ebp),%eax
801078a0:	0f 22 d8             	mov    %eax,%cr3
}
801078a3:	90                   	nop
801078a4:	5d                   	pop    %ebp
801078a5:	c3                   	ret    

801078a6 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801078a6:	55                   	push   %ebp
801078a7:	89 e5                	mov    %esp,%ebp
801078a9:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801078ac:	e8 ee c9 ff ff       	call   8010429f <cpuid>
801078b1:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801078b7:	05 20 38 11 80       	add    $0x80113820,%eax
801078bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801078bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c2:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801078c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078cb:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801078d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d4:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801078d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078db:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801078df:	83 e2 f0             	and    $0xfffffff0,%edx
801078e2:	83 ca 0a             	or     $0xa,%edx
801078e5:	88 50 7d             	mov    %dl,0x7d(%eax)
801078e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078eb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801078ef:	83 ca 10             	or     $0x10,%edx
801078f2:	88 50 7d             	mov    %dl,0x7d(%eax)
801078f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f8:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801078fc:	83 e2 9f             	and    $0xffffff9f,%edx
801078ff:	88 50 7d             	mov    %dl,0x7d(%eax)
80107902:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107905:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107909:	83 ca 80             	or     $0xffffff80,%edx
8010790c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010790f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107912:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107916:	83 ca 0f             	or     $0xf,%edx
80107919:	88 50 7e             	mov    %dl,0x7e(%eax)
8010791c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107923:	83 e2 ef             	and    $0xffffffef,%edx
80107926:	88 50 7e             	mov    %dl,0x7e(%eax)
80107929:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107930:	83 e2 df             	and    $0xffffffdf,%edx
80107933:	88 50 7e             	mov    %dl,0x7e(%eax)
80107936:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107939:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010793d:	83 ca 40             	or     $0x40,%edx
80107940:	88 50 7e             	mov    %dl,0x7e(%eax)
80107943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107946:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010794a:	83 ca 80             	or     $0xffffff80,%edx
8010794d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107953:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107957:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010795a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107961:	ff ff 
80107963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107966:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010796d:	00 00 
8010796f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107972:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107979:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107983:	83 e2 f0             	and    $0xfffffff0,%edx
80107986:	83 ca 02             	or     $0x2,%edx
80107989:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010798f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107992:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107999:	83 ca 10             	or     $0x10,%edx
8010799c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801079a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801079ac:	83 e2 9f             	and    $0xffffff9f,%edx
801079af:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801079b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801079bf:	83 ca 80             	or     $0xffffff80,%edx
801079c2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801079c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079cb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801079d2:	83 ca 0f             	or     $0xf,%edx
801079d5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801079db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079de:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801079e5:	83 e2 ef             	and    $0xffffffef,%edx
801079e8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801079ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801079f8:	83 e2 df             	and    $0xffffffdf,%edx
801079fb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a04:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107a0b:	83 ca 40             	or     $0x40,%edx
80107a0e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a17:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107a1e:	83 ca 80             	or     $0xffffff80,%edx
80107a21:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a34:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107a3b:	ff ff 
80107a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a40:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107a47:	00 00 
80107a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4c:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a56:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a5d:	83 e2 f0             	and    $0xfffffff0,%edx
80107a60:	83 ca 0a             	or     $0xa,%edx
80107a63:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a73:	83 ca 10             	or     $0x10,%edx
80107a76:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a86:	83 ca 60             	or     $0x60,%edx
80107a89:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a92:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a99:	83 ca 80             	or     $0xffffff80,%edx
80107a9c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa5:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107aac:	83 ca 0f             	or     $0xf,%edx
80107aaf:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab8:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107abf:	83 e2 ef             	and    $0xffffffef,%edx
80107ac2:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107acb:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107ad2:	83 e2 df             	and    $0xffffffdf,%edx
80107ad5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ade:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107ae5:	83 ca 40             	or     $0x40,%edx
80107ae8:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af1:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107af8:	83 ca 80             	or     $0xffffff80,%edx
80107afb:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b04:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107b15:	ff ff 
80107b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1a:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107b21:	00 00 
80107b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b26:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b30:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107b37:	83 e2 f0             	and    $0xfffffff0,%edx
80107b3a:	83 ca 02             	or     $0x2,%edx
80107b3d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b46:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107b4d:	83 ca 10             	or     $0x10,%edx
80107b50:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b59:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107b60:	83 ca 60             	or     $0x60,%edx
80107b63:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107b73:	83 ca 80             	or     $0xffffff80,%edx
80107b76:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b7f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107b86:	83 ca 0f             	or     $0xf,%edx
80107b89:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b92:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107b99:	83 e2 ef             	and    $0xffffffef,%edx
80107b9c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107bac:	83 e2 df             	and    $0xffffffdf,%edx
80107baf:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107bbf:	83 ca 40             	or     $0x40,%edx
80107bc2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bcb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107bd2:	83 ca 80             	or     $0xffffff80,%edx
80107bd5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bde:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be8:	83 c0 70             	add    $0x70,%eax
80107beb:	83 ec 08             	sub    $0x8,%esp
80107bee:	6a 30                	push   $0x30
80107bf0:	50                   	push   %eax
80107bf1:	e8 63 fc ff ff       	call   80107859 <lgdt>
80107bf6:	83 c4 10             	add    $0x10,%esp
}
80107bf9:	90                   	nop
80107bfa:	c9                   	leave  
80107bfb:	c3                   	ret    

80107bfc <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107bfc:	55                   	push   %ebp
80107bfd:	89 e5                	mov    %esp,%ebp
80107bff:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107c02:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c05:	c1 e8 16             	shr    $0x16,%eax
80107c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107c0f:	8b 45 08             	mov    0x8(%ebp),%eax
80107c12:	01 d0                	add    %edx,%eax
80107c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c1a:	8b 00                	mov    (%eax),%eax
80107c1c:	83 e0 01             	and    $0x1,%eax
80107c1f:	85 c0                	test   %eax,%eax
80107c21:	74 14                	je     80107c37 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c26:	8b 00                	mov    (%eax),%eax
80107c28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c2d:	05 00 00 00 80       	add    $0x80000000,%eax
80107c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c35:	eb 42                	jmp    80107c79 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107c37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107c3b:	74 0e                	je     80107c4b <walkpgdir+0x4f>
80107c3d:	e8 53 b0 ff ff       	call   80102c95 <kalloc>
80107c42:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c49:	75 07                	jne    80107c52 <walkpgdir+0x56>
      return 0;
80107c4b:	b8 00 00 00 00       	mov    $0x0,%eax
80107c50:	eb 3e                	jmp    80107c90 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107c52:	83 ec 04             	sub    $0x4,%esp
80107c55:	68 00 10 00 00       	push   $0x1000
80107c5a:	6a 00                	push   $0x0
80107c5c:	ff 75 f4             	pushl  -0xc(%ebp)
80107c5f:	e8 44 d7 ff ff       	call   801053a8 <memset>
80107c64:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6a:	05 00 00 00 80       	add    $0x80000000,%eax
80107c6f:	83 c8 07             	or     $0x7,%eax
80107c72:	89 c2                	mov    %eax,%edx
80107c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c77:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107c79:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c7c:	c1 e8 0c             	shr    $0xc,%eax
80107c7f:	25 ff 03 00 00       	and    $0x3ff,%eax
80107c84:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8e:	01 d0                	add    %edx,%eax
}
80107c90:	c9                   	leave  
80107c91:	c3                   	ret    

80107c92 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107c92:	55                   	push   %ebp
80107c93:	89 e5                	mov    %esp,%ebp
80107c95:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107c98:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ca6:	8b 45 10             	mov    0x10(%ebp),%eax
80107ca9:	01 d0                	add    %edx,%eax
80107cab:	83 e8 01             	sub    $0x1,%eax
80107cae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107cb6:	83 ec 04             	sub    $0x4,%esp
80107cb9:	6a 01                	push   $0x1
80107cbb:	ff 75 f4             	pushl  -0xc(%ebp)
80107cbe:	ff 75 08             	pushl  0x8(%ebp)
80107cc1:	e8 36 ff ff ff       	call   80107bfc <walkpgdir>
80107cc6:	83 c4 10             	add    $0x10,%esp
80107cc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107ccc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107cd0:	75 07                	jne    80107cd9 <mappages+0x47>
      return -1;
80107cd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cd7:	eb 47                	jmp    80107d20 <mappages+0x8e>
    if(*pte & PTE_P)
80107cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cdc:	8b 00                	mov    (%eax),%eax
80107cde:	83 e0 01             	and    $0x1,%eax
80107ce1:	85 c0                	test   %eax,%eax
80107ce3:	74 0d                	je     80107cf2 <mappages+0x60>
      panic("remap");
80107ce5:	83 ec 0c             	sub    $0xc,%esp
80107ce8:	68 98 8d 10 80       	push   $0x80108d98
80107ced:	e8 ae 88 ff ff       	call   801005a0 <panic>
    *pte = pa | perm | PTE_P;
80107cf2:	8b 45 18             	mov    0x18(%ebp),%eax
80107cf5:	0b 45 14             	or     0x14(%ebp),%eax
80107cf8:	83 c8 01             	or     $0x1,%eax
80107cfb:	89 c2                	mov    %eax,%edx
80107cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d00:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107d08:	74 10                	je     80107d1a <mappages+0x88>
      break;
    a += PGSIZE;
80107d0a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107d11:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107d18:	eb 9c                	jmp    80107cb6 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107d1a:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107d1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d20:	c9                   	leave  
80107d21:	c3                   	ret    

80107d22 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107d22:	55                   	push   %ebp
80107d23:	89 e5                	mov    %esp,%ebp
80107d25:	53                   	push   %ebx
80107d26:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107d29:	e8 67 af ff ff       	call   80102c95 <kalloc>
80107d2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d35:	75 07                	jne    80107d3e <setupkvm+0x1c>
    return 0;
80107d37:	b8 00 00 00 00       	mov    $0x0,%eax
80107d3c:	eb 78                	jmp    80107db6 <setupkvm+0x94>
  memset(pgdir, 0, PGSIZE);
80107d3e:	83 ec 04             	sub    $0x4,%esp
80107d41:	68 00 10 00 00       	push   $0x1000
80107d46:	6a 00                	push   $0x0
80107d48:	ff 75 f0             	pushl  -0x10(%ebp)
80107d4b:	e8 58 d6 ff ff       	call   801053a8 <memset>
80107d50:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d53:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107d5a:	eb 4e                	jmp    80107daa <setupkvm+0x88>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5f:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80107d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d65:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6b:	8b 58 08             	mov    0x8(%eax),%ebx
80107d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d71:	8b 40 04             	mov    0x4(%eax),%eax
80107d74:	29 c3                	sub    %eax,%ebx
80107d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d79:	8b 00                	mov    (%eax),%eax
80107d7b:	83 ec 0c             	sub    $0xc,%esp
80107d7e:	51                   	push   %ecx
80107d7f:	52                   	push   %edx
80107d80:	53                   	push   %ebx
80107d81:	50                   	push   %eax
80107d82:	ff 75 f0             	pushl  -0x10(%ebp)
80107d85:	e8 08 ff ff ff       	call   80107c92 <mappages>
80107d8a:	83 c4 20             	add    $0x20,%esp
80107d8d:	85 c0                	test   %eax,%eax
80107d8f:	79 15                	jns    80107da6 <setupkvm+0x84>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107d91:	83 ec 0c             	sub    $0xc,%esp
80107d94:	ff 75 f0             	pushl  -0x10(%ebp)
80107d97:	e8 f6 04 00 00       	call   80108292 <freevm>
80107d9c:	83 c4 10             	add    $0x10,%esp
      return 0;
80107d9f:	b8 00 00 00 00       	mov    $0x0,%eax
80107da4:	eb 10                	jmp    80107db6 <setupkvm+0x94>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107da6:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107daa:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107db1:	72 a9                	jb     80107d5c <setupkvm+0x3a>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
80107db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107db6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107db9:	c9                   	leave  
80107dba:	c3                   	ret    

80107dbb <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107dbb:	55                   	push   %ebp
80107dbc:	89 e5                	mov    %esp,%ebp
80107dbe:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107dc1:	e8 5c ff ff ff       	call   80107d22 <setupkvm>
80107dc6:	a3 60 69 11 80       	mov    %eax,0x80116960
  switchkvm();
80107dcb:	e8 03 00 00 00       	call   80107dd3 <switchkvm>
}
80107dd0:	90                   	nop
80107dd1:	c9                   	leave  
80107dd2:	c3                   	ret    

80107dd3 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107dd3:	55                   	push   %ebp
80107dd4:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107dd6:	a1 60 69 11 80       	mov    0x80116960,%eax
80107ddb:	05 00 00 00 80       	add    $0x80000000,%eax
80107de0:	50                   	push   %eax
80107de1:	e8 b4 fa ff ff       	call   8010789a <lcr3>
80107de6:	83 c4 04             	add    $0x4,%esp
}
80107de9:	90                   	nop
80107dea:	c9                   	leave  
80107deb:	c3                   	ret    

80107dec <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107dec:	55                   	push   %ebp
80107ded:	89 e5                	mov    %esp,%ebp
80107def:	56                   	push   %esi
80107df0:	53                   	push   %ebx
80107df1:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80107df4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107df8:	75 0d                	jne    80107e07 <switchuvm+0x1b>
    panic("switchuvm: no process");
80107dfa:	83 ec 0c             	sub    $0xc,%esp
80107dfd:	68 9e 8d 10 80       	push   $0x80108d9e
80107e02:	e8 99 87 ff ff       	call   801005a0 <panic>
  if(p->kstack == 0)
80107e07:	8b 45 08             	mov    0x8(%ebp),%eax
80107e0a:	8b 40 08             	mov    0x8(%eax),%eax
80107e0d:	85 c0                	test   %eax,%eax
80107e0f:	75 0d                	jne    80107e1e <switchuvm+0x32>
    panic("switchuvm: no kstack");
80107e11:	83 ec 0c             	sub    $0xc,%esp
80107e14:	68 b4 8d 10 80       	push   $0x80108db4
80107e19:	e8 82 87 ff ff       	call   801005a0 <panic>
  if(p->pgdir == 0)
80107e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80107e21:	8b 40 04             	mov    0x4(%eax),%eax
80107e24:	85 c0                	test   %eax,%eax
80107e26:	75 0d                	jne    80107e35 <switchuvm+0x49>
    panic("switchuvm: no pgdir");
80107e28:	83 ec 0c             	sub    $0xc,%esp
80107e2b:	68 c9 8d 10 80       	push   $0x80108dc9
80107e30:	e8 6b 87 ff ff       	call   801005a0 <panic>

  pushcli();
80107e35:	e8 62 d4 ff ff       	call   8010529c <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107e3a:	e8 81 c4 ff ff       	call   801042c0 <mycpu>
80107e3f:	89 c3                	mov    %eax,%ebx
80107e41:	e8 7a c4 ff ff       	call   801042c0 <mycpu>
80107e46:	83 c0 08             	add    $0x8,%eax
80107e49:	89 c6                	mov    %eax,%esi
80107e4b:	e8 70 c4 ff ff       	call   801042c0 <mycpu>
80107e50:	83 c0 08             	add    $0x8,%eax
80107e53:	c1 e8 10             	shr    $0x10,%eax
80107e56:	88 45 f7             	mov    %al,-0x9(%ebp)
80107e59:	e8 62 c4 ff ff       	call   801042c0 <mycpu>
80107e5e:	83 c0 08             	add    $0x8,%eax
80107e61:	c1 e8 18             	shr    $0x18,%eax
80107e64:	89 c2                	mov    %eax,%edx
80107e66:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107e6d:	67 00 
80107e6f:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107e76:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107e7a:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80107e80:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107e87:	83 e0 f0             	and    $0xfffffff0,%eax
80107e8a:	83 c8 09             	or     $0x9,%eax
80107e8d:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107e93:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107e9a:	83 c8 10             	or     $0x10,%eax
80107e9d:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107ea3:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107eaa:	83 e0 9f             	and    $0xffffff9f,%eax
80107ead:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107eb3:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107eba:	83 c8 80             	or     $0xffffff80,%eax
80107ebd:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107ec3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107eca:	83 e0 f0             	and    $0xfffffff0,%eax
80107ecd:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107ed3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107eda:	83 e0 ef             	and    $0xffffffef,%eax
80107edd:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107ee3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107eea:	83 e0 df             	and    $0xffffffdf,%eax
80107eed:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107ef3:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107efa:	83 c8 40             	or     $0x40,%eax
80107efd:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107f03:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107f0a:	83 e0 7f             	and    $0x7f,%eax
80107f0d:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107f13:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107f19:	e8 a2 c3 ff ff       	call   801042c0 <mycpu>
80107f1e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f25:	83 e2 ef             	and    $0xffffffef,%edx
80107f28:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107f2e:	e8 8d c3 ff ff       	call   801042c0 <mycpu>
80107f33:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107f39:	e8 82 c3 ff ff       	call   801042c0 <mycpu>
80107f3e:	89 c2                	mov    %eax,%edx
80107f40:	8b 45 08             	mov    0x8(%ebp),%eax
80107f43:	8b 40 08             	mov    0x8(%eax),%eax
80107f46:	05 00 10 00 00       	add    $0x1000,%eax
80107f4b:	89 42 0c             	mov    %eax,0xc(%edx)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107f4e:	e8 6d c3 ff ff       	call   801042c0 <mycpu>
80107f53:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107f59:	83 ec 0c             	sub    $0xc,%esp
80107f5c:	6a 28                	push   $0x28
80107f5e:	e8 20 f9 ff ff       	call   80107883 <ltr>
80107f63:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107f66:	8b 45 08             	mov    0x8(%ebp),%eax
80107f69:	8b 40 04             	mov    0x4(%eax),%eax
80107f6c:	05 00 00 00 80       	add    $0x80000000,%eax
80107f71:	83 ec 0c             	sub    $0xc,%esp
80107f74:	50                   	push   %eax
80107f75:	e8 20 f9 ff ff       	call   8010789a <lcr3>
80107f7a:	83 c4 10             	add    $0x10,%esp
  popcli();
80107f7d:	e8 68 d3 ff ff       	call   801052ea <popcli>
}
80107f82:	90                   	nop
80107f83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107f86:	5b                   	pop    %ebx
80107f87:	5e                   	pop    %esi
80107f88:	5d                   	pop    %ebp
80107f89:	c3                   	ret    

80107f8a <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107f8a:	55                   	push   %ebp
80107f8b:	89 e5                	mov    %esp,%ebp
80107f8d:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80107f90:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107f97:	76 0d                	jbe    80107fa6 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107f99:	83 ec 0c             	sub    $0xc,%esp
80107f9c:	68 dd 8d 10 80       	push   $0x80108ddd
80107fa1:	e8 fa 85 ff ff       	call   801005a0 <panic>
  mem = kalloc();
80107fa6:	e8 ea ac ff ff       	call   80102c95 <kalloc>
80107fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107fae:	83 ec 04             	sub    $0x4,%esp
80107fb1:	68 00 10 00 00       	push   $0x1000
80107fb6:	6a 00                	push   $0x0
80107fb8:	ff 75 f4             	pushl  -0xc(%ebp)
80107fbb:	e8 e8 d3 ff ff       	call   801053a8 <memset>
80107fc0:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc6:	05 00 00 00 80       	add    $0x80000000,%eax
80107fcb:	83 ec 0c             	sub    $0xc,%esp
80107fce:	6a 06                	push   $0x6
80107fd0:	50                   	push   %eax
80107fd1:	68 00 10 00 00       	push   $0x1000
80107fd6:	6a 00                	push   $0x0
80107fd8:	ff 75 08             	pushl  0x8(%ebp)
80107fdb:	e8 b2 fc ff ff       	call   80107c92 <mappages>
80107fe0:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107fe3:	83 ec 04             	sub    $0x4,%esp
80107fe6:	ff 75 10             	pushl  0x10(%ebp)
80107fe9:	ff 75 0c             	pushl  0xc(%ebp)
80107fec:	ff 75 f4             	pushl  -0xc(%ebp)
80107fef:	e8 73 d4 ff ff       	call   80105467 <memmove>
80107ff4:	83 c4 10             	add    $0x10,%esp
}
80107ff7:	90                   	nop
80107ff8:	c9                   	leave  
80107ff9:	c3                   	ret    

80107ffa <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107ffa:	55                   	push   %ebp
80107ffb:	89 e5                	mov    %esp,%ebp
80107ffd:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108000:	8b 45 0c             	mov    0xc(%ebp),%eax
80108003:	25 ff 0f 00 00       	and    $0xfff,%eax
80108008:	85 c0                	test   %eax,%eax
8010800a:	74 0d                	je     80108019 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
8010800c:	83 ec 0c             	sub    $0xc,%esp
8010800f:	68 f8 8d 10 80       	push   $0x80108df8
80108014:	e8 87 85 ff ff       	call   801005a0 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108019:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108020:	e9 8f 00 00 00       	jmp    801080b4 <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108025:	8b 55 0c             	mov    0xc(%ebp),%edx
80108028:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802b:	01 d0                	add    %edx,%eax
8010802d:	83 ec 04             	sub    $0x4,%esp
80108030:	6a 00                	push   $0x0
80108032:	50                   	push   %eax
80108033:	ff 75 08             	pushl  0x8(%ebp)
80108036:	e8 c1 fb ff ff       	call   80107bfc <walkpgdir>
8010803b:	83 c4 10             	add    $0x10,%esp
8010803e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108041:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108045:	75 0d                	jne    80108054 <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80108047:	83 ec 0c             	sub    $0xc,%esp
8010804a:	68 1b 8e 10 80       	push   $0x80108e1b
8010804f:	e8 4c 85 ff ff       	call   801005a0 <panic>
    pa = PTE_ADDR(*pte);
80108054:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108057:	8b 00                	mov    (%eax),%eax
80108059:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010805e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108061:	8b 45 18             	mov    0x18(%ebp),%eax
80108064:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108067:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010806c:	77 0b                	ja     80108079 <loaduvm+0x7f>
      n = sz - i;
8010806e:	8b 45 18             	mov    0x18(%ebp),%eax
80108071:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108074:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108077:	eb 07                	jmp    80108080 <loaduvm+0x86>
    else
      n = PGSIZE;
80108079:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108080:	8b 55 14             	mov    0x14(%ebp),%edx
80108083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108086:	01 d0                	add    %edx,%eax
80108088:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010808b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108091:	ff 75 f0             	pushl  -0x10(%ebp)
80108094:	50                   	push   %eax
80108095:	52                   	push   %edx
80108096:	ff 75 10             	pushl  0x10(%ebp)
80108099:	e8 63 9e ff ff       	call   80101f01 <readi>
8010809e:	83 c4 10             	add    $0x10,%esp
801080a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801080a4:	74 07                	je     801080ad <loaduvm+0xb3>
      return -1;
801080a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080ab:	eb 18                	jmp    801080c5 <loaduvm+0xcb>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801080ad:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b7:	3b 45 18             	cmp    0x18(%ebp),%eax
801080ba:	0f 82 65 ff ff ff    	jb     80108025 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801080c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080c5:	c9                   	leave  
801080c6:	c3                   	ret    

801080c7 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080c7:	55                   	push   %ebp
801080c8:	89 e5                	mov    %esp,%ebp
801080ca:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE - NSHAREDPG*PGSIZE)
801080cd:	81 7d 10 ff bf ff 7f 	cmpl   $0x7fffbfff,0x10(%ebp)
801080d4:	76 0a                	jbe    801080e0 <allocuvm+0x19>
    return 0;
801080d6:	b8 00 00 00 00       	mov    $0x0,%eax
801080db:	e9 ec 00 00 00       	jmp    801081cc <allocuvm+0x105>
  if(newsz < oldsz)
801080e0:	8b 45 10             	mov    0x10(%ebp),%eax
801080e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080e6:	73 08                	jae    801080f0 <allocuvm+0x29>
    return oldsz;
801080e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801080eb:	e9 dc 00 00 00       	jmp    801081cc <allocuvm+0x105>

  a = PGROUNDUP(oldsz);
801080f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801080f3:	05 ff 0f 00 00       	add    $0xfff,%eax
801080f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108100:	e9 b8 00 00 00       	jmp    801081bd <allocuvm+0xf6>
    mem = kalloc();
80108105:	e8 8b ab ff ff       	call   80102c95 <kalloc>
8010810a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010810d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108111:	75 2e                	jne    80108141 <allocuvm+0x7a>
      cprintf("allocuvm out of memory\n");
80108113:	83 ec 0c             	sub    $0xc,%esp
80108116:	68 39 8e 10 80       	push   $0x80108e39
8010811b:	e8 e0 82 ff ff       	call   80100400 <cprintf>
80108120:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108123:	83 ec 04             	sub    $0x4,%esp
80108126:	ff 75 0c             	pushl  0xc(%ebp)
80108129:	ff 75 10             	pushl  0x10(%ebp)
8010812c:	ff 75 08             	pushl  0x8(%ebp)
8010812f:	e8 9a 00 00 00       	call   801081ce <deallocuvm>
80108134:	83 c4 10             	add    $0x10,%esp
      return 0;
80108137:	b8 00 00 00 00       	mov    $0x0,%eax
8010813c:	e9 8b 00 00 00       	jmp    801081cc <allocuvm+0x105>
    }
    memset(mem, 0, PGSIZE);
80108141:	83 ec 04             	sub    $0x4,%esp
80108144:	68 00 10 00 00       	push   $0x1000
80108149:	6a 00                	push   $0x0
8010814b:	ff 75 f0             	pushl  -0x10(%ebp)
8010814e:	e8 55 d2 ff ff       	call   801053a8 <memset>
80108153:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108156:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108159:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
8010815f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108162:	83 ec 0c             	sub    $0xc,%esp
80108165:	6a 06                	push   $0x6
80108167:	52                   	push   %edx
80108168:	68 00 10 00 00       	push   $0x1000
8010816d:	50                   	push   %eax
8010816e:	ff 75 08             	pushl  0x8(%ebp)
80108171:	e8 1c fb ff ff       	call   80107c92 <mappages>
80108176:	83 c4 20             	add    $0x20,%esp
80108179:	85 c0                	test   %eax,%eax
8010817b:	79 39                	jns    801081b6 <allocuvm+0xef>
      cprintf("allocuvm out of memory (2)\n");
8010817d:	83 ec 0c             	sub    $0xc,%esp
80108180:	68 51 8e 10 80       	push   $0x80108e51
80108185:	e8 76 82 ff ff       	call   80100400 <cprintf>
8010818a:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010818d:	83 ec 04             	sub    $0x4,%esp
80108190:	ff 75 0c             	pushl  0xc(%ebp)
80108193:	ff 75 10             	pushl  0x10(%ebp)
80108196:	ff 75 08             	pushl  0x8(%ebp)
80108199:	e8 30 00 00 00       	call   801081ce <deallocuvm>
8010819e:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
801081a1:	83 ec 0c             	sub    $0xc,%esp
801081a4:	ff 75 f0             	pushl  -0x10(%ebp)
801081a7:	e8 4f aa ff ff       	call   80102bfb <kfree>
801081ac:	83 c4 10             	add    $0x10,%esp
      return 0;
801081af:	b8 00 00 00 00       	mov    $0x0,%eax
801081b4:	eb 16                	jmp    801081cc <allocuvm+0x105>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801081b6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801081bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c0:	3b 45 10             	cmp    0x10(%ebp),%eax
801081c3:	0f 82 3c ff ff ff    	jb     80108105 <allocuvm+0x3e>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
801081c9:	8b 45 10             	mov    0x10(%ebp),%eax
}
801081cc:	c9                   	leave  
801081cd:	c3                   	ret    

801081ce <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801081ce:	55                   	push   %ebp
801081cf:	89 e5                	mov    %esp,%ebp
801081d1:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801081d4:	8b 45 10             	mov    0x10(%ebp),%eax
801081d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081da:	72 08                	jb     801081e4 <deallocuvm+0x16>
    return oldsz;
801081dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801081df:	e9 ac 00 00 00       	jmp    80108290 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
801081e4:	8b 45 10             	mov    0x10(%ebp),%eax
801081e7:	05 ff 0f 00 00       	add    $0xfff,%eax
801081ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801081f4:	e9 88 00 00 00       	jmp    80108281 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
801081f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fc:	83 ec 04             	sub    $0x4,%esp
801081ff:	6a 00                	push   $0x0
80108201:	50                   	push   %eax
80108202:	ff 75 08             	pushl  0x8(%ebp)
80108205:	e8 f2 f9 ff ff       	call   80107bfc <walkpgdir>
8010820a:	83 c4 10             	add    $0x10,%esp
8010820d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108210:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108214:	75 16                	jne    8010822c <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108219:	c1 e8 16             	shr    $0x16,%eax
8010821c:	83 c0 01             	add    $0x1,%eax
8010821f:	c1 e0 16             	shl    $0x16,%eax
80108222:	2d 00 10 00 00       	sub    $0x1000,%eax
80108227:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010822a:	eb 4e                	jmp    8010827a <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
8010822c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010822f:	8b 00                	mov    (%eax),%eax
80108231:	83 e0 01             	and    $0x1,%eax
80108234:	85 c0                	test   %eax,%eax
80108236:	74 42                	je     8010827a <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80108238:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010823b:	8b 00                	mov    (%eax),%eax
8010823d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108242:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108245:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108249:	75 0d                	jne    80108258 <deallocuvm+0x8a>
        panic("kfree");
8010824b:	83 ec 0c             	sub    $0xc,%esp
8010824e:	68 6d 8e 10 80       	push   $0x80108e6d
80108253:	e8 48 83 ff ff       	call   801005a0 <panic>
      char *v = P2V(pa);
80108258:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010825b:	05 00 00 00 80       	add    $0x80000000,%eax
80108260:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108263:	83 ec 0c             	sub    $0xc,%esp
80108266:	ff 75 e8             	pushl  -0x18(%ebp)
80108269:	e8 8d a9 ff ff       	call   80102bfb <kfree>
8010826e:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108271:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108274:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010827a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108284:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108287:	0f 82 6c ff ff ff    	jb     801081f9 <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010828d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108290:	c9                   	leave  
80108291:	c3                   	ret    

80108292 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108292:	55                   	push   %ebp
80108293:	89 e5                	mov    %esp,%ebp
80108295:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108298:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010829c:	75 0d                	jne    801082ab <freevm+0x19>
    panic("freevm: no pgdir");
8010829e:	83 ec 0c             	sub    $0xc,%esp
801082a1:	68 73 8e 10 80       	push   $0x80108e73
801082a6:	e8 f5 82 ff ff       	call   801005a0 <panic>
  deallocuvm(pgdir, KERNBASE-4*PGSIZE, 0);
801082ab:	83 ec 04             	sub    $0x4,%esp
801082ae:	6a 00                	push   $0x0
801082b0:	68 00 c0 ff 7f       	push   $0x7fffc000
801082b5:	ff 75 08             	pushl  0x8(%ebp)
801082b8:	e8 11 ff ff ff       	call   801081ce <deallocuvm>
801082bd:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801082c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082c7:	eb 48                	jmp    80108311 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
801082c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082d3:	8b 45 08             	mov    0x8(%ebp),%eax
801082d6:	01 d0                	add    %edx,%eax
801082d8:	8b 00                	mov    (%eax),%eax
801082da:	83 e0 01             	and    $0x1,%eax
801082dd:	85 c0                	test   %eax,%eax
801082df:	74 2c                	je     8010830d <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801082e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082eb:	8b 45 08             	mov    0x8(%ebp),%eax
801082ee:	01 d0                	add    %edx,%eax
801082f0:	8b 00                	mov    (%eax),%eax
801082f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082f7:	05 00 00 00 80       	add    $0x80000000,%eax
801082fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801082ff:	83 ec 0c             	sub    $0xc,%esp
80108302:	ff 75 f0             	pushl  -0x10(%ebp)
80108305:	e8 f1 a8 ff ff       	call   80102bfb <kfree>
8010830a:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE-4*PGSIZE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010830d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108311:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108318:	76 af                	jbe    801082c9 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010831a:	83 ec 0c             	sub    $0xc,%esp
8010831d:	ff 75 08             	pushl  0x8(%ebp)
80108320:	e8 d6 a8 ff ff       	call   80102bfb <kfree>
80108325:	83 c4 10             	add    $0x10,%esp
}
80108328:	90                   	nop
80108329:	c9                   	leave  
8010832a:	c3                   	ret    

8010832b <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010832b:	55                   	push   %ebp
8010832c:	89 e5                	mov    %esp,%ebp
8010832e:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108331:	83 ec 04             	sub    $0x4,%esp
80108334:	6a 00                	push   $0x0
80108336:	ff 75 0c             	pushl  0xc(%ebp)
80108339:	ff 75 08             	pushl  0x8(%ebp)
8010833c:	e8 bb f8 ff ff       	call   80107bfc <walkpgdir>
80108341:	83 c4 10             	add    $0x10,%esp
80108344:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108347:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010834b:	75 0d                	jne    8010835a <clearpteu+0x2f>
    panic("clearpteu");
8010834d:	83 ec 0c             	sub    $0xc,%esp
80108350:	68 84 8e 10 80       	push   $0x80108e84
80108355:	e8 46 82 ff ff       	call   801005a0 <panic>
  *pte &= ~PTE_U;
8010835a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835d:	8b 00                	mov    (%eax),%eax
8010835f:	83 e0 fb             	and    $0xfffffffb,%eax
80108362:	89 c2                	mov    %eax,%edx
80108364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108367:	89 10                	mov    %edx,(%eax)
}
80108369:	90                   	nop
8010836a:	c9                   	leave  
8010836b:	c3                   	ret    

8010836c <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010836c:	55                   	push   %ebp
8010836d:	89 e5                	mov    %esp,%ebp
8010836f:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108372:	e8 ab f9 ff ff       	call   80107d22 <setupkvm>
80108377:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010837a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010837e:	75 0a                	jne    8010838a <copyuvm+0x1e>
    return 0;
80108380:	b8 00 00 00 00       	mov    $0x0,%eax
80108385:	e9 f8 00 00 00       	jmp    80108482 <copyuvm+0x116>
  // pj2
  for(i = PGSIZE; i < sz; i += PGSIZE){
8010838a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
80108391:	e9 c7 00 00 00       	jmp    8010845d <copyuvm+0xf1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108399:	83 ec 04             	sub    $0x4,%esp
8010839c:	6a 00                	push   $0x0
8010839e:	50                   	push   %eax
8010839f:	ff 75 08             	pushl  0x8(%ebp)
801083a2:	e8 55 f8 ff ff       	call   80107bfc <walkpgdir>
801083a7:	83 c4 10             	add    $0x10,%esp
801083aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
801083ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801083b1:	75 0d                	jne    801083c0 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
801083b3:	83 ec 0c             	sub    $0xc,%esp
801083b6:	68 8e 8e 10 80       	push   $0x80108e8e
801083bb:	e8 e0 81 ff ff       	call   801005a0 <panic>
    if(!(*pte & PTE_P))
801083c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083c3:	8b 00                	mov    (%eax),%eax
801083c5:	83 e0 01             	and    $0x1,%eax
801083c8:	85 c0                	test   %eax,%eax
801083ca:	75 0d                	jne    801083d9 <copyuvm+0x6d>
      panic("copyuvm: page not present");
801083cc:	83 ec 0c             	sub    $0xc,%esp
801083cf:	68 a8 8e 10 80       	push   $0x80108ea8
801083d4:	e8 c7 81 ff ff       	call   801005a0 <panic>
    pa = PTE_ADDR(*pte);
801083d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083dc:	8b 00                	mov    (%eax),%eax
801083de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801083e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083e9:	8b 00                	mov    (%eax),%eax
801083eb:	25 ff 0f 00 00       	and    $0xfff,%eax
801083f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801083f3:	e8 9d a8 ff ff       	call   80102c95 <kalloc>
801083f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801083ff:	74 6d                	je     8010846e <copyuvm+0x102>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108401:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108404:	05 00 00 00 80       	add    $0x80000000,%eax
80108409:	83 ec 04             	sub    $0x4,%esp
8010840c:	68 00 10 00 00       	push   $0x1000
80108411:	50                   	push   %eax
80108412:	ff 75 e0             	pushl  -0x20(%ebp)
80108415:	e8 4d d0 ff ff       	call   80105467 <memmove>
8010841a:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010841d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108420:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108423:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80108429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010842c:	83 ec 0c             	sub    $0xc,%esp
8010842f:	52                   	push   %edx
80108430:	51                   	push   %ecx
80108431:	68 00 10 00 00       	push   $0x1000
80108436:	50                   	push   %eax
80108437:	ff 75 f0             	pushl  -0x10(%ebp)
8010843a:	e8 53 f8 ff ff       	call   80107c92 <mappages>
8010843f:	83 c4 20             	add    $0x20,%esp
80108442:	85 c0                	test   %eax,%eax
80108444:	79 10                	jns    80108456 <copyuvm+0xea>
      kfree(mem);
80108446:	83 ec 0c             	sub    $0xc,%esp
80108449:	ff 75 e0             	pushl  -0x20(%ebp)
8010844c:	e8 aa a7 ff ff       	call   80102bfb <kfree>
80108451:	83 c4 10             	add    $0x10,%esp
      goto bad;
80108454:	eb 19                	jmp    8010846f <copyuvm+0x103>
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  // pj2
  for(i = PGSIZE; i < sz; i += PGSIZE){
80108456:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010845d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108460:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108463:	0f 82 2d ff ff ff    	jb     80108396 <copyuvm+0x2a>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
      goto bad;
    }
  }
  return d;
80108469:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010846c:	eb 14                	jmp    80108482 <copyuvm+0x116>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
8010846e:	90                   	nop
    }
  }
  return d;

bad:
  freevm(d);
8010846f:	83 ec 0c             	sub    $0xc,%esp
80108472:	ff 75 f0             	pushl  -0x10(%ebp)
80108475:	e8 18 fe ff ff       	call   80108292 <freevm>
8010847a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010847d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108482:	c9                   	leave  
80108483:	c3                   	ret    

80108484 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108484:	55                   	push   %ebp
80108485:	89 e5                	mov    %esp,%ebp
80108487:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010848a:	83 ec 04             	sub    $0x4,%esp
8010848d:	6a 00                	push   $0x0
8010848f:	ff 75 0c             	pushl  0xc(%ebp)
80108492:	ff 75 08             	pushl  0x8(%ebp)
80108495:	e8 62 f7 ff ff       	call   80107bfc <walkpgdir>
8010849a:	83 c4 10             	add    $0x10,%esp
8010849d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801084a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a3:	8b 00                	mov    (%eax),%eax
801084a5:	83 e0 01             	and    $0x1,%eax
801084a8:	85 c0                	test   %eax,%eax
801084aa:	75 07                	jne    801084b3 <uva2ka+0x2f>
    return 0;
801084ac:	b8 00 00 00 00       	mov    $0x0,%eax
801084b1:	eb 22                	jmp    801084d5 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
801084b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b6:	8b 00                	mov    (%eax),%eax
801084b8:	83 e0 04             	and    $0x4,%eax
801084bb:	85 c0                	test   %eax,%eax
801084bd:	75 07                	jne    801084c6 <uva2ka+0x42>
    return 0;
801084bf:	b8 00 00 00 00       	mov    $0x0,%eax
801084c4:	eb 0f                	jmp    801084d5 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
801084c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c9:	8b 00                	mov    (%eax),%eax
801084cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084d0:	05 00 00 00 80       	add    $0x80000000,%eax
}
801084d5:	c9                   	leave  
801084d6:	c3                   	ret    

801084d7 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801084d7:	55                   	push   %ebp
801084d8:	89 e5                	mov    %esp,%ebp
801084da:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801084dd:	8b 45 10             	mov    0x10(%ebp),%eax
801084e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801084e3:	eb 7f                	jmp    80108564 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801084e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801084e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801084f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084f3:	83 ec 08             	sub    $0x8,%esp
801084f6:	50                   	push   %eax
801084f7:	ff 75 08             	pushl  0x8(%ebp)
801084fa:	e8 85 ff ff ff       	call   80108484 <uva2ka>
801084ff:	83 c4 10             	add    $0x10,%esp
80108502:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108505:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108509:	75 07                	jne    80108512 <copyout+0x3b>
      return -1;
8010850b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108510:	eb 61                	jmp    80108573 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108512:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108515:	2b 45 0c             	sub    0xc(%ebp),%eax
80108518:	05 00 10 00 00       	add    $0x1000,%eax
8010851d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108520:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108523:	3b 45 14             	cmp    0x14(%ebp),%eax
80108526:	76 06                	jbe    8010852e <copyout+0x57>
      n = len;
80108528:	8b 45 14             	mov    0x14(%ebp),%eax
8010852b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010852e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108531:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108534:	89 c2                	mov    %eax,%edx
80108536:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108539:	01 d0                	add    %edx,%eax
8010853b:	83 ec 04             	sub    $0x4,%esp
8010853e:	ff 75 f0             	pushl  -0x10(%ebp)
80108541:	ff 75 f4             	pushl  -0xc(%ebp)
80108544:	50                   	push   %eax
80108545:	e8 1d cf ff ff       	call   80105467 <memmove>
8010854a:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010854d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108550:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108553:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108556:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108559:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010855c:	05 00 10 00 00       	add    $0x1000,%eax
80108561:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108564:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108568:	0f 85 77 ff ff ff    	jne    801084e5 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010856e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108573:	c9                   	leave  
80108574:	c3                   	ret    

80108575 <shmeminit>:

// pj2 share memory initial in the main.c
int shmeminit(){
80108575:	55                   	push   %ebp
80108576:	89 e5                	mov    %esp,%ebp
80108578:	83 ec 18             	sub    $0x18,%esp
  char* mem;
  for(int i = 0; i < NSHAREDPG; i++){
8010857b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108582:	eb 68                	jmp    801085ec <shmeminit+0x77>
    if((mem = kalloc())== 0){
80108584:	e8 0c a7 ff ff       	call   80102c95 <kalloc>
80108589:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010858c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108590:	75 0d                	jne    8010859f <shmeminit+0x2a>
      panic("share memory allocate fail");
80108592:	83 ec 0c             	sub    $0xc,%esp
80108595:	68 c2 8e 10 80       	push   $0x80108ec2
8010859a:	e8 01 80 ff ff       	call   801005a0 <panic>
      return 0;
    }
    sharepages[i].vaddr = mem;
8010859f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801085a5:	89 14 c5 80 69 11 80 	mov    %edx,-0x7fee9680(,%eax,8)
    sharepages[i].count = 0;
801085ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085af:	c7 04 c5 84 69 11 80 	movl   $0x0,-0x7fee967c(,%eax,8)
801085b6:	00 00 00 00 
    memset(mem, 0, PGSIZE);
801085ba:	83 ec 04             	sub    $0x4,%esp
801085bd:	68 00 10 00 00       	push   $0x1000
801085c2:	6a 00                	push   $0x0
801085c4:	ff 75 f0             	pushl  -0x10(%ebp)
801085c7:	e8 dc cd ff ff       	call   801053a8 <memset>
801085cc:	83 c4 10             	add    $0x10,%esp
    cprintf("initial share memory address: %x\n", V2P(mem));
801085cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085d2:	05 00 00 00 80       	add    $0x80000000,%eax
801085d7:	83 ec 08             	sub    $0x8,%esp
801085da:	50                   	push   %eax
801085db:	68 e0 8e 10 80       	push   $0x80108ee0
801085e0:	e8 1b 7e ff ff       	call   80100400 <cprintf>
801085e5:	83 c4 10             	add    $0x10,%esp
}

// pj2 share memory initial in the main.c
int shmeminit(){
  char* mem;
  for(int i = 0; i < NSHAREDPG; i++){
801085e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801085ec:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
801085f0:	7e 92                	jle    80108584 <shmeminit+0xf>
    sharepages[i].vaddr = mem;
    sharepages[i].count = 0;
    memset(mem, 0, PGSIZE);
    cprintf("initial share memory address: %x\n", V2P(mem));
  }
  return 1;
801085f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
801085f7:	c9                   	leave  
801085f8:	c3                   	ret    

801085f9 <shmem_access>:

// get share memory virtual address
int shmem_access(int pgindex)
{
801085f9:	55                   	push   %ebp
801085fa:	89 e5                	mov    %esp,%ebp
801085fc:	83 ec 18             	sub    $0x18,%esp
  if(pgindex < 0 || pgindex >= NSHAREDPG){
801085ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108603:	78 06                	js     8010860b <shmem_access+0x12>
80108605:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
80108609:	7e 1a                	jle    80108625 <shmem_access+0x2c>
    cprintf("illegal share page number\n");
8010860b:	83 ec 0c             	sub    $0xc,%esp
8010860e:	68 02 8f 10 80       	push   $0x80108f02
80108613:	e8 e8 7d ff ff       	call   80100400 <cprintf>
80108618:	83 c4 10             	add    $0x10,%esp
    return 0;
8010861b:	b8 00 00 00 00       	mov    $0x0,%eax
80108620:	e9 00 01 00 00       	jmp    80108725 <shmem_access+0x12c>
  }
  cprintf("share memory access begin\n");
80108625:	83 ec 0c             	sub    $0xc,%esp
80108628:	68 1d 8f 10 80       	push   $0x80108f1d
8010862d:	e8 ce 7d ff ff       	call   80100400 <cprintf>
80108632:	83 c4 10             	add    $0x10,%esp
  struct sharemem *sh;
  struct proc *curproc = myproc();
80108635:	e8 fe bc ff ff       	call   80104338 <myproc>
8010863a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // if already have the share memory map, return it directly
  if(curproc->share[pgindex])
8010863d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108640:	8b 55 08             	mov    0x8(%ebp),%edx
80108643:	83 c2 1c             	add    $0x1c,%edx
80108646:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010864a:	85 c0                	test   %eax,%eax
8010864c:	74 22                	je     80108670 <shmem_access+0x77>
  {
    cprintf("share memory have mapped so return directly\n");
8010864e:	83 ec 0c             	sub    $0xc,%esp
80108651:	68 38 8f 10 80       	push   $0x80108f38
80108656:	e8 a5 7d ff ff       	call   80100400 <cprintf>
8010865b:	83 c4 10             	add    $0x10,%esp
    return (int)(curproc->share[pgindex]);
8010865e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108661:	8b 55 08             	mov    0x8(%ebp),%edx
80108664:	83 c2 1c             	add    $0x1c,%edx
80108667:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010866b:	e9 b5 00 00 00       	jmp    80108725 <shmem_access+0x12c>
  }
  sh = &sharepages[pgindex];
80108670:	8b 45 08             	mov    0x8(%ebp),%eax
80108673:	c1 e0 03             	shl    $0x3,%eax
80108676:	05 80 69 11 80       	add    $0x80116980,%eax
8010867b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  cprintf("physical address:%d", V2P(sh->vaddr));
8010867e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108681:	8b 00                	mov    (%eax),%eax
80108683:	05 00 00 00 80       	add    $0x80000000,%eax
80108688:	83 ec 08             	sub    $0x8,%esp
8010868b:	50                   	push   %eax
8010868c:	68 65 8f 10 80       	push   $0x80108f65
80108691:	e8 6a 7d ff ff       	call   80100400 <cprintf>
80108696:	83 c4 10             	add    $0x10,%esp
  mappages(curproc->pgdir, (void*)(KERNBASE-PGSIZE*(pgindex+1)), PGSIZE, V2P(sh->vaddr), PTE_W|PTE_U);
80108699:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010869c:	8b 00                	mov    (%eax),%eax
8010869e:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801086a4:	8b 45 08             	mov    0x8(%ebp),%eax
801086a7:	83 c0 01             	add    $0x1,%eax
801086aa:	c1 e0 0c             	shl    $0xc,%eax
801086ad:	b9 00 00 00 80       	mov    $0x80000000,%ecx
801086b2:	29 c1                	sub    %eax,%ecx
801086b4:	89 c8                	mov    %ecx,%eax
801086b6:	89 c1                	mov    %eax,%ecx
801086b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086bb:	8b 40 04             	mov    0x4(%eax),%eax
801086be:	83 ec 0c             	sub    $0xc,%esp
801086c1:	6a 06                	push   $0x6
801086c3:	52                   	push   %edx
801086c4:	68 00 10 00 00       	push   $0x1000
801086c9:	51                   	push   %ecx
801086ca:	50                   	push   %eax
801086cb:	e8 c2 f5 ff ff       	call   80107c92 <mappages>
801086d0:	83 c4 20             	add    $0x20,%esp

  curproc->share[pgindex] = (void*)(KERNBASE - (pgindex+1)*PGSIZE);
801086d3:	8b 45 08             	mov    0x8(%ebp),%eax
801086d6:	83 c0 01             	add    $0x1,%eax
801086d9:	c1 e0 0c             	shl    $0xc,%eax
801086dc:	ba 00 00 00 80       	mov    $0x80000000,%edx
801086e1:	29 c2                	sub    %eax,%edx
801086e3:	89 d0                	mov    %edx,%eax
801086e5:	89 c1                	mov    %eax,%ecx
801086e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ea:	8b 55 08             	mov    0x8(%ebp),%edx
801086ed:	83 c2 1c             	add    $0x1c,%edx
801086f0:	89 4c 90 0c          	mov    %ecx,0xc(%eax,%edx,4)
  sh->count++;
801086f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086f7:	8b 40 04             	mov    0x4(%eax),%eax
801086fa:	8d 50 01             	lea    0x1(%eax),%edx
801086fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108700:	89 50 04             	mov    %edx,0x4(%eax)
  cprintf("share memory map success\n");
80108703:	83 ec 0c             	sub    $0xc,%esp
80108706:	68 79 8f 10 80       	push   $0x80108f79
8010870b:	e8 f0 7c ff ff       	call   80100400 <cprintf>
80108710:	83 c4 10             	add    $0x10,%esp

  return (int)(KERNBASE - (pgindex+1)*PGSIZE);
80108713:	8b 45 08             	mov    0x8(%ebp),%eax
80108716:	83 c0 01             	add    $0x1,%eax
80108719:	c1 e0 0c             	shl    $0xc,%eax
8010871c:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108721:	29 c2                	sub    %eax,%edx
80108723:	89 d0                	mov    %edx,%eax
  ;
}
80108725:	c9                   	leave  
80108726:	c3                   	ret    

80108727 <shmem_count>:

// get the processes number which is using share memory
int shmem_count(int pgindex)
{
80108727:	55                   	push   %ebp
80108728:	89 e5                	mov    %esp,%ebp
8010872a:	83 ec 10             	sub    $0x10,%esp
  struct sharemem *sh;
  sh = &sharepages[pgindex];
8010872d:	8b 45 08             	mov    0x8(%ebp),%eax
80108730:	c1 e0 03             	shl    $0x3,%eax
80108733:	05 80 69 11 80       	add    $0x80116980,%eax
80108738:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(sh == 0)
8010873b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010873f:	75 07                	jne    80108748 <shmem_count+0x21>
    return -1;
80108741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108746:	eb 06                	jmp    8010874e <shmem_count+0x27>
  return sh->count;
80108748:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010874b:	8b 40 04             	mov    0x4(%eax),%eax

}
8010874e:	c9                   	leave  
8010874f:	c3                   	ret    
