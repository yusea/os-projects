
_testnonpointer:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

 int main(int argc, char* argv[]) 
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	51                   	push   %ecx
    100e:	83 ec 04             	sub    $0x4,%esp

   printf(1, "success: %p", *((int*) 0));
    1011:	b8 00 00 00 00       	mov    $0x0,%eax
    1016:	8b 00                	mov    (%eax),%eax
    1018:	83 ec 04             	sub    $0x4,%esp
    101b:	50                   	push   %eax
    101c:	68 cc 17 00 00       	push   $0x17cc
    1021:	6a 01                	push   $0x1
    1023:	e8 ee 03 00 00       	call   1416 <printf>
    1028:	83 c4 10             	add    $0x10,%esp
  exit();
    102b:	e8 57 02 00 00       	call   1287 <exit>

00001030 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1030:	55                   	push   %ebp
    1031:	89 e5                	mov    %esp,%ebp
    1033:	57                   	push   %edi
    1034:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1035:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1038:	8b 55 10             	mov    0x10(%ebp),%edx
    103b:	8b 45 0c             	mov    0xc(%ebp),%eax
    103e:	89 cb                	mov    %ecx,%ebx
    1040:	89 df                	mov    %ebx,%edi
    1042:	89 d1                	mov    %edx,%ecx
    1044:	fc                   	cld    
    1045:	f3 aa                	rep stos %al,%es:(%edi)
    1047:	89 ca                	mov    %ecx,%edx
    1049:	89 fb                	mov    %edi,%ebx
    104b:	89 5d 08             	mov    %ebx,0x8(%ebp)
    104e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1051:	90                   	nop
    1052:	5b                   	pop    %ebx
    1053:	5f                   	pop    %edi
    1054:	5d                   	pop    %ebp
    1055:	c3                   	ret    

00001056 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1056:	55                   	push   %ebp
    1057:	89 e5                	mov    %esp,%ebp
    1059:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    105c:	8b 45 08             	mov    0x8(%ebp),%eax
    105f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1062:	90                   	nop
    1063:	8b 45 08             	mov    0x8(%ebp),%eax
    1066:	8d 50 01             	lea    0x1(%eax),%edx
    1069:	89 55 08             	mov    %edx,0x8(%ebp)
    106c:	8b 55 0c             	mov    0xc(%ebp),%edx
    106f:	8d 4a 01             	lea    0x1(%edx),%ecx
    1072:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1075:	0f b6 12             	movzbl (%edx),%edx
    1078:	88 10                	mov    %dl,(%eax)
    107a:	0f b6 00             	movzbl (%eax),%eax
    107d:	84 c0                	test   %al,%al
    107f:	75 e2                	jne    1063 <strcpy+0xd>
    ;
  return os;
    1081:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1084:	c9                   	leave  
    1085:	c3                   	ret    

00001086 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1086:	55                   	push   %ebp
    1087:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1089:	eb 08                	jmp    1093 <strcmp+0xd>
    p++, q++;
    108b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    108f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1093:	8b 45 08             	mov    0x8(%ebp),%eax
    1096:	0f b6 00             	movzbl (%eax),%eax
    1099:	84 c0                	test   %al,%al
    109b:	74 10                	je     10ad <strcmp+0x27>
    109d:	8b 45 08             	mov    0x8(%ebp),%eax
    10a0:	0f b6 10             	movzbl (%eax),%edx
    10a3:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a6:	0f b6 00             	movzbl (%eax),%eax
    10a9:	38 c2                	cmp    %al,%dl
    10ab:	74 de                	je     108b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10ad:	8b 45 08             	mov    0x8(%ebp),%eax
    10b0:	0f b6 00             	movzbl (%eax),%eax
    10b3:	0f b6 d0             	movzbl %al,%edx
    10b6:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b9:	0f b6 00             	movzbl (%eax),%eax
    10bc:	0f b6 c0             	movzbl %al,%eax
    10bf:	29 c2                	sub    %eax,%edx
    10c1:	89 d0                	mov    %edx,%eax
}
    10c3:	5d                   	pop    %ebp
    10c4:	c3                   	ret    

000010c5 <strlen>:

uint
strlen(const char *s)
{
    10c5:	55                   	push   %ebp
    10c6:	89 e5                	mov    %esp,%ebp
    10c8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10d2:	eb 04                	jmp    10d8 <strlen+0x13>
    10d4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10db:	8b 45 08             	mov    0x8(%ebp),%eax
    10de:	01 d0                	add    %edx,%eax
    10e0:	0f b6 00             	movzbl (%eax),%eax
    10e3:	84 c0                	test   %al,%al
    10e5:	75 ed                	jne    10d4 <strlen+0xf>
    ;
  return n;
    10e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10ea:	c9                   	leave  
    10eb:	c3                   	ret    

000010ec <memset>:

void*
memset(void *dst, int c, uint n)
{
    10ec:	55                   	push   %ebp
    10ed:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    10ef:	8b 45 10             	mov    0x10(%ebp),%eax
    10f2:	50                   	push   %eax
    10f3:	ff 75 0c             	pushl  0xc(%ebp)
    10f6:	ff 75 08             	pushl  0x8(%ebp)
    10f9:	e8 32 ff ff ff       	call   1030 <stosb>
    10fe:	83 c4 0c             	add    $0xc,%esp
  return dst;
    1101:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1104:	c9                   	leave  
    1105:	c3                   	ret    

00001106 <strchr>:

char*
strchr(const char *s, char c)
{
    1106:	55                   	push   %ebp
    1107:	89 e5                	mov    %esp,%ebp
    1109:	83 ec 04             	sub    $0x4,%esp
    110c:	8b 45 0c             	mov    0xc(%ebp),%eax
    110f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1112:	eb 14                	jmp    1128 <strchr+0x22>
    if(*s == c)
    1114:	8b 45 08             	mov    0x8(%ebp),%eax
    1117:	0f b6 00             	movzbl (%eax),%eax
    111a:	3a 45 fc             	cmp    -0x4(%ebp),%al
    111d:	75 05                	jne    1124 <strchr+0x1e>
      return (char*)s;
    111f:	8b 45 08             	mov    0x8(%ebp),%eax
    1122:	eb 13                	jmp    1137 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1124:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1128:	8b 45 08             	mov    0x8(%ebp),%eax
    112b:	0f b6 00             	movzbl (%eax),%eax
    112e:	84 c0                	test   %al,%al
    1130:	75 e2                	jne    1114 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1132:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1137:	c9                   	leave  
    1138:	c3                   	ret    

00001139 <gets>:

char*
gets(char *buf, int max)
{
    1139:	55                   	push   %ebp
    113a:	89 e5                	mov    %esp,%ebp
    113c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    113f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1146:	eb 42                	jmp    118a <gets+0x51>
    cc = read(0, &c, 1);
    1148:	83 ec 04             	sub    $0x4,%esp
    114b:	6a 01                	push   $0x1
    114d:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1150:	50                   	push   %eax
    1151:	6a 00                	push   $0x0
    1153:	e8 47 01 00 00       	call   129f <read>
    1158:	83 c4 10             	add    $0x10,%esp
    115b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    115e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1162:	7e 33                	jle    1197 <gets+0x5e>
      break;
    buf[i++] = c;
    1164:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1167:	8d 50 01             	lea    0x1(%eax),%edx
    116a:	89 55 f4             	mov    %edx,-0xc(%ebp)
    116d:	89 c2                	mov    %eax,%edx
    116f:	8b 45 08             	mov    0x8(%ebp),%eax
    1172:	01 c2                	add    %eax,%edx
    1174:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1178:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    117a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    117e:	3c 0a                	cmp    $0xa,%al
    1180:	74 16                	je     1198 <gets+0x5f>
    1182:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1186:	3c 0d                	cmp    $0xd,%al
    1188:	74 0e                	je     1198 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    118a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    118d:	83 c0 01             	add    $0x1,%eax
    1190:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1193:	7c b3                	jl     1148 <gets+0xf>
    1195:	eb 01                	jmp    1198 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1197:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1198:	8b 55 f4             	mov    -0xc(%ebp),%edx
    119b:	8b 45 08             	mov    0x8(%ebp),%eax
    119e:	01 d0                	add    %edx,%eax
    11a0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11a6:	c9                   	leave  
    11a7:	c3                   	ret    

000011a8 <stat>:

int
stat(const char *n, struct stat *st)
{
    11a8:	55                   	push   %ebp
    11a9:	89 e5                	mov    %esp,%ebp
    11ab:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11ae:	83 ec 08             	sub    $0x8,%esp
    11b1:	6a 00                	push   $0x0
    11b3:	ff 75 08             	pushl  0x8(%ebp)
    11b6:	e8 0c 01 00 00       	call   12c7 <open>
    11bb:	83 c4 10             	add    $0x10,%esp
    11be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11c5:	79 07                	jns    11ce <stat+0x26>
    return -1;
    11c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11cc:	eb 25                	jmp    11f3 <stat+0x4b>
  r = fstat(fd, st);
    11ce:	83 ec 08             	sub    $0x8,%esp
    11d1:	ff 75 0c             	pushl  0xc(%ebp)
    11d4:	ff 75 f4             	pushl  -0xc(%ebp)
    11d7:	e8 03 01 00 00       	call   12df <fstat>
    11dc:	83 c4 10             	add    $0x10,%esp
    11df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    11e2:	83 ec 0c             	sub    $0xc,%esp
    11e5:	ff 75 f4             	pushl  -0xc(%ebp)
    11e8:	e8 c2 00 00 00       	call   12af <close>
    11ed:	83 c4 10             	add    $0x10,%esp
  return r;
    11f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    11f3:	c9                   	leave  
    11f4:	c3                   	ret    

000011f5 <atoi>:

int
atoi(const char *s)
{
    11f5:	55                   	push   %ebp
    11f6:	89 e5                	mov    %esp,%ebp
    11f8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    11fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1202:	eb 25                	jmp    1229 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1204:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1207:	89 d0                	mov    %edx,%eax
    1209:	c1 e0 02             	shl    $0x2,%eax
    120c:	01 d0                	add    %edx,%eax
    120e:	01 c0                	add    %eax,%eax
    1210:	89 c1                	mov    %eax,%ecx
    1212:	8b 45 08             	mov    0x8(%ebp),%eax
    1215:	8d 50 01             	lea    0x1(%eax),%edx
    1218:	89 55 08             	mov    %edx,0x8(%ebp)
    121b:	0f b6 00             	movzbl (%eax),%eax
    121e:	0f be c0             	movsbl %al,%eax
    1221:	01 c8                	add    %ecx,%eax
    1223:	83 e8 30             	sub    $0x30,%eax
    1226:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1229:	8b 45 08             	mov    0x8(%ebp),%eax
    122c:	0f b6 00             	movzbl (%eax),%eax
    122f:	3c 2f                	cmp    $0x2f,%al
    1231:	7e 0a                	jle    123d <atoi+0x48>
    1233:	8b 45 08             	mov    0x8(%ebp),%eax
    1236:	0f b6 00             	movzbl (%eax),%eax
    1239:	3c 39                	cmp    $0x39,%al
    123b:	7e c7                	jle    1204 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    123d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1240:	c9                   	leave  
    1241:	c3                   	ret    

00001242 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1242:	55                   	push   %ebp
    1243:	89 e5                	mov    %esp,%ebp
    1245:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    1248:	8b 45 08             	mov    0x8(%ebp),%eax
    124b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    124e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1251:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1254:	eb 17                	jmp    126d <memmove+0x2b>
    *dst++ = *src++;
    1256:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1259:	8d 50 01             	lea    0x1(%eax),%edx
    125c:	89 55 fc             	mov    %edx,-0x4(%ebp)
    125f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1262:	8d 4a 01             	lea    0x1(%edx),%ecx
    1265:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1268:	0f b6 12             	movzbl (%edx),%edx
    126b:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    126d:	8b 45 10             	mov    0x10(%ebp),%eax
    1270:	8d 50 ff             	lea    -0x1(%eax),%edx
    1273:	89 55 10             	mov    %edx,0x10(%ebp)
    1276:	85 c0                	test   %eax,%eax
    1278:	7f dc                	jg     1256 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    127a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    127d:	c9                   	leave  
    127e:	c3                   	ret    

0000127f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    127f:	b8 01 00 00 00       	mov    $0x1,%eax
    1284:	cd 40                	int    $0x40
    1286:	c3                   	ret    

00001287 <exit>:
SYSCALL(exit)
    1287:	b8 02 00 00 00       	mov    $0x2,%eax
    128c:	cd 40                	int    $0x40
    128e:	c3                   	ret    

0000128f <wait>:
SYSCALL(wait)
    128f:	b8 03 00 00 00       	mov    $0x3,%eax
    1294:	cd 40                	int    $0x40
    1296:	c3                   	ret    

00001297 <pipe>:
SYSCALL(pipe)
    1297:	b8 04 00 00 00       	mov    $0x4,%eax
    129c:	cd 40                	int    $0x40
    129e:	c3                   	ret    

0000129f <read>:
SYSCALL(read)
    129f:	b8 05 00 00 00       	mov    $0x5,%eax
    12a4:	cd 40                	int    $0x40
    12a6:	c3                   	ret    

000012a7 <write>:
SYSCALL(write)
    12a7:	b8 10 00 00 00       	mov    $0x10,%eax
    12ac:	cd 40                	int    $0x40
    12ae:	c3                   	ret    

000012af <close>:
SYSCALL(close)
    12af:	b8 15 00 00 00       	mov    $0x15,%eax
    12b4:	cd 40                	int    $0x40
    12b6:	c3                   	ret    

000012b7 <kill>:
SYSCALL(kill)
    12b7:	b8 06 00 00 00       	mov    $0x6,%eax
    12bc:	cd 40                	int    $0x40
    12be:	c3                   	ret    

000012bf <exec>:
SYSCALL(exec)
    12bf:	b8 07 00 00 00       	mov    $0x7,%eax
    12c4:	cd 40                	int    $0x40
    12c6:	c3                   	ret    

000012c7 <open>:
SYSCALL(open)
    12c7:	b8 0f 00 00 00       	mov    $0xf,%eax
    12cc:	cd 40                	int    $0x40
    12ce:	c3                   	ret    

000012cf <mknod>:
SYSCALL(mknod)
    12cf:	b8 11 00 00 00       	mov    $0x11,%eax
    12d4:	cd 40                	int    $0x40
    12d6:	c3                   	ret    

000012d7 <unlink>:
SYSCALL(unlink)
    12d7:	b8 12 00 00 00       	mov    $0x12,%eax
    12dc:	cd 40                	int    $0x40
    12de:	c3                   	ret    

000012df <fstat>:
SYSCALL(fstat)
    12df:	b8 08 00 00 00       	mov    $0x8,%eax
    12e4:	cd 40                	int    $0x40
    12e6:	c3                   	ret    

000012e7 <link>:
SYSCALL(link)
    12e7:	b8 13 00 00 00       	mov    $0x13,%eax
    12ec:	cd 40                	int    $0x40
    12ee:	c3                   	ret    

000012ef <mkdir>:
SYSCALL(mkdir)
    12ef:	b8 14 00 00 00       	mov    $0x14,%eax
    12f4:	cd 40                	int    $0x40
    12f6:	c3                   	ret    

000012f7 <chdir>:
SYSCALL(chdir)
    12f7:	b8 09 00 00 00       	mov    $0x9,%eax
    12fc:	cd 40                	int    $0x40
    12fe:	c3                   	ret    

000012ff <dup>:
SYSCALL(dup)
    12ff:	b8 0a 00 00 00       	mov    $0xa,%eax
    1304:	cd 40                	int    $0x40
    1306:	c3                   	ret    

00001307 <getpid>:
SYSCALL(getpid)
    1307:	b8 0b 00 00 00       	mov    $0xb,%eax
    130c:	cd 40                	int    $0x40
    130e:	c3                   	ret    

0000130f <sbrk>:
SYSCALL(sbrk)
    130f:	b8 0c 00 00 00       	mov    $0xc,%eax
    1314:	cd 40                	int    $0x40
    1316:	c3                   	ret    

00001317 <sleep>:
SYSCALL(sleep)
    1317:	b8 0d 00 00 00       	mov    $0xd,%eax
    131c:	cd 40                	int    $0x40
    131e:	c3                   	ret    

0000131f <uptime>:
SYSCALL(uptime)
    131f:	b8 0e 00 00 00       	mov    $0xe,%eax
    1324:	cd 40                	int    $0x40
    1326:	c3                   	ret    

00001327 <getprocsinfo>:
SYSCALL(getprocsinfo)
    1327:	b8 16 00 00 00       	mov    $0x16,%eax
    132c:	cd 40                	int    $0x40
    132e:	c3                   	ret    

0000132f <shmem_access>:
SYSCALL(shmem_access)
    132f:	b8 17 00 00 00       	mov    $0x17,%eax
    1334:	cd 40                	int    $0x40
    1336:	c3                   	ret    

00001337 <shmem_count>:
SYSCALL(shmem_count)
    1337:	b8 18 00 00 00       	mov    $0x18,%eax
    133c:	cd 40                	int    $0x40
    133e:	c3                   	ret    

0000133f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    133f:	55                   	push   %ebp
    1340:	89 e5                	mov    %esp,%ebp
    1342:	83 ec 18             	sub    $0x18,%esp
    1345:	8b 45 0c             	mov    0xc(%ebp),%eax
    1348:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    134b:	83 ec 04             	sub    $0x4,%esp
    134e:	6a 01                	push   $0x1
    1350:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1353:	50                   	push   %eax
    1354:	ff 75 08             	pushl  0x8(%ebp)
    1357:	e8 4b ff ff ff       	call   12a7 <write>
    135c:	83 c4 10             	add    $0x10,%esp
}
    135f:	90                   	nop
    1360:	c9                   	leave  
    1361:	c3                   	ret    

00001362 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1362:	55                   	push   %ebp
    1363:	89 e5                	mov    %esp,%ebp
    1365:	53                   	push   %ebx
    1366:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1369:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1370:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1374:	74 17                	je     138d <printint+0x2b>
    1376:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    137a:	79 11                	jns    138d <printint+0x2b>
    neg = 1;
    137c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1383:	8b 45 0c             	mov    0xc(%ebp),%eax
    1386:	f7 d8                	neg    %eax
    1388:	89 45 ec             	mov    %eax,-0x14(%ebp)
    138b:	eb 06                	jmp    1393 <printint+0x31>
  } else {
    x = xx;
    138d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1390:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1393:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    139a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    139d:	8d 41 01             	lea    0x1(%ecx),%eax
    13a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13a9:	ba 00 00 00 00       	mov    $0x0,%edx
    13ae:	f7 f3                	div    %ebx
    13b0:	89 d0                	mov    %edx,%eax
    13b2:	0f b6 80 28 1a 00 00 	movzbl 0x1a28(%eax),%eax
    13b9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13c3:	ba 00 00 00 00       	mov    $0x0,%edx
    13c8:	f7 f3                	div    %ebx
    13ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13d1:	75 c7                	jne    139a <printint+0x38>
  if(neg)
    13d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13d7:	74 2d                	je     1406 <printint+0xa4>
    buf[i++] = '-';
    13d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13dc:	8d 50 01             	lea    0x1(%eax),%edx
    13df:	89 55 f4             	mov    %edx,-0xc(%ebp)
    13e2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    13e7:	eb 1d                	jmp    1406 <printint+0xa4>
    putc(fd, buf[i]);
    13e9:	8d 55 dc             	lea    -0x24(%ebp),%edx
    13ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ef:	01 d0                	add    %edx,%eax
    13f1:	0f b6 00             	movzbl (%eax),%eax
    13f4:	0f be c0             	movsbl %al,%eax
    13f7:	83 ec 08             	sub    $0x8,%esp
    13fa:	50                   	push   %eax
    13fb:	ff 75 08             	pushl  0x8(%ebp)
    13fe:	e8 3c ff ff ff       	call   133f <putc>
    1403:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1406:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    140a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    140e:	79 d9                	jns    13e9 <printint+0x87>
    putc(fd, buf[i]);
}
    1410:	90                   	nop
    1411:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1414:	c9                   	leave  
    1415:	c3                   	ret    

00001416 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1416:	55                   	push   %ebp
    1417:	89 e5                	mov    %esp,%ebp
    1419:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    141c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1423:	8d 45 0c             	lea    0xc(%ebp),%eax
    1426:	83 c0 04             	add    $0x4,%eax
    1429:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    142c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1433:	e9 59 01 00 00       	jmp    1591 <printf+0x17b>
    c = fmt[i] & 0xff;
    1438:	8b 55 0c             	mov    0xc(%ebp),%edx
    143b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    143e:	01 d0                	add    %edx,%eax
    1440:	0f b6 00             	movzbl (%eax),%eax
    1443:	0f be c0             	movsbl %al,%eax
    1446:	25 ff 00 00 00       	and    $0xff,%eax
    144b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    144e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1452:	75 2c                	jne    1480 <printf+0x6a>
      if(c == '%'){
    1454:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1458:	75 0c                	jne    1466 <printf+0x50>
        state = '%';
    145a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1461:	e9 27 01 00 00       	jmp    158d <printf+0x177>
      } else {
        putc(fd, c);
    1466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1469:	0f be c0             	movsbl %al,%eax
    146c:	83 ec 08             	sub    $0x8,%esp
    146f:	50                   	push   %eax
    1470:	ff 75 08             	pushl  0x8(%ebp)
    1473:	e8 c7 fe ff ff       	call   133f <putc>
    1478:	83 c4 10             	add    $0x10,%esp
    147b:	e9 0d 01 00 00       	jmp    158d <printf+0x177>
      }
    } else if(state == '%'){
    1480:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1484:	0f 85 03 01 00 00    	jne    158d <printf+0x177>
      if(c == 'd'){
    148a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    148e:	75 1e                	jne    14ae <printf+0x98>
        printint(fd, *ap, 10, 1);
    1490:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1493:	8b 00                	mov    (%eax),%eax
    1495:	6a 01                	push   $0x1
    1497:	6a 0a                	push   $0xa
    1499:	50                   	push   %eax
    149a:	ff 75 08             	pushl  0x8(%ebp)
    149d:	e8 c0 fe ff ff       	call   1362 <printint>
    14a2:	83 c4 10             	add    $0x10,%esp
        ap++;
    14a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14a9:	e9 d8 00 00 00       	jmp    1586 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    14ae:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14b2:	74 06                	je     14ba <printf+0xa4>
    14b4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14b8:	75 1e                	jne    14d8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    14ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14bd:	8b 00                	mov    (%eax),%eax
    14bf:	6a 00                	push   $0x0
    14c1:	6a 10                	push   $0x10
    14c3:	50                   	push   %eax
    14c4:	ff 75 08             	pushl  0x8(%ebp)
    14c7:	e8 96 fe ff ff       	call   1362 <printint>
    14cc:	83 c4 10             	add    $0x10,%esp
        ap++;
    14cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14d3:	e9 ae 00 00 00       	jmp    1586 <printf+0x170>
      } else if(c == 's'){
    14d8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    14dc:	75 43                	jne    1521 <printf+0x10b>
        s = (char*)*ap;
    14de:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14e1:	8b 00                	mov    (%eax),%eax
    14e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    14e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    14ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14ee:	75 25                	jne    1515 <printf+0xff>
          s = "(null)";
    14f0:	c7 45 f4 d8 17 00 00 	movl   $0x17d8,-0xc(%ebp)
        while(*s != 0){
    14f7:	eb 1c                	jmp    1515 <printf+0xff>
          putc(fd, *s);
    14f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14fc:	0f b6 00             	movzbl (%eax),%eax
    14ff:	0f be c0             	movsbl %al,%eax
    1502:	83 ec 08             	sub    $0x8,%esp
    1505:	50                   	push   %eax
    1506:	ff 75 08             	pushl  0x8(%ebp)
    1509:	e8 31 fe ff ff       	call   133f <putc>
    150e:	83 c4 10             	add    $0x10,%esp
          s++;
    1511:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1515:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1518:	0f b6 00             	movzbl (%eax),%eax
    151b:	84 c0                	test   %al,%al
    151d:	75 da                	jne    14f9 <printf+0xe3>
    151f:	eb 65                	jmp    1586 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1521:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1525:	75 1d                	jne    1544 <printf+0x12e>
        putc(fd, *ap);
    1527:	8b 45 e8             	mov    -0x18(%ebp),%eax
    152a:	8b 00                	mov    (%eax),%eax
    152c:	0f be c0             	movsbl %al,%eax
    152f:	83 ec 08             	sub    $0x8,%esp
    1532:	50                   	push   %eax
    1533:	ff 75 08             	pushl  0x8(%ebp)
    1536:	e8 04 fe ff ff       	call   133f <putc>
    153b:	83 c4 10             	add    $0x10,%esp
        ap++;
    153e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1542:	eb 42                	jmp    1586 <printf+0x170>
      } else if(c == '%'){
    1544:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1548:	75 17                	jne    1561 <printf+0x14b>
        putc(fd, c);
    154a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    154d:	0f be c0             	movsbl %al,%eax
    1550:	83 ec 08             	sub    $0x8,%esp
    1553:	50                   	push   %eax
    1554:	ff 75 08             	pushl  0x8(%ebp)
    1557:	e8 e3 fd ff ff       	call   133f <putc>
    155c:	83 c4 10             	add    $0x10,%esp
    155f:	eb 25                	jmp    1586 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1561:	83 ec 08             	sub    $0x8,%esp
    1564:	6a 25                	push   $0x25
    1566:	ff 75 08             	pushl  0x8(%ebp)
    1569:	e8 d1 fd ff ff       	call   133f <putc>
    156e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1574:	0f be c0             	movsbl %al,%eax
    1577:	83 ec 08             	sub    $0x8,%esp
    157a:	50                   	push   %eax
    157b:	ff 75 08             	pushl  0x8(%ebp)
    157e:	e8 bc fd ff ff       	call   133f <putc>
    1583:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1586:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    158d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1591:	8b 55 0c             	mov    0xc(%ebp),%edx
    1594:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1597:	01 d0                	add    %edx,%eax
    1599:	0f b6 00             	movzbl (%eax),%eax
    159c:	84 c0                	test   %al,%al
    159e:	0f 85 94 fe ff ff    	jne    1438 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15a4:	90                   	nop
    15a5:	c9                   	leave  
    15a6:	c3                   	ret    

000015a7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15a7:	55                   	push   %ebp
    15a8:	89 e5                	mov    %esp,%ebp
    15aa:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15ad:	8b 45 08             	mov    0x8(%ebp),%eax
    15b0:	83 e8 08             	sub    $0x8,%eax
    15b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15b6:	a1 44 1a 00 00       	mov    0x1a44,%eax
    15bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15be:	eb 24                	jmp    15e4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15c3:	8b 00                	mov    (%eax),%eax
    15c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15c8:	77 12                	ja     15dc <free+0x35>
    15ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15d0:	77 24                	ja     15f6 <free+0x4f>
    15d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15d5:	8b 00                	mov    (%eax),%eax
    15d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15da:	77 1a                	ja     15f6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15df:	8b 00                	mov    (%eax),%eax
    15e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15ea:	76 d4                	jbe    15c0 <free+0x19>
    15ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15ef:	8b 00                	mov    (%eax),%eax
    15f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15f4:	76 ca                	jbe    15c0 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    15f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15f9:	8b 40 04             	mov    0x4(%eax),%eax
    15fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1603:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1606:	01 c2                	add    %eax,%edx
    1608:	8b 45 fc             	mov    -0x4(%ebp),%eax
    160b:	8b 00                	mov    (%eax),%eax
    160d:	39 c2                	cmp    %eax,%edx
    160f:	75 24                	jne    1635 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1611:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1614:	8b 50 04             	mov    0x4(%eax),%edx
    1617:	8b 45 fc             	mov    -0x4(%ebp),%eax
    161a:	8b 00                	mov    (%eax),%eax
    161c:	8b 40 04             	mov    0x4(%eax),%eax
    161f:	01 c2                	add    %eax,%edx
    1621:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1624:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1627:	8b 45 fc             	mov    -0x4(%ebp),%eax
    162a:	8b 00                	mov    (%eax),%eax
    162c:	8b 10                	mov    (%eax),%edx
    162e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1631:	89 10                	mov    %edx,(%eax)
    1633:	eb 0a                	jmp    163f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1635:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1638:	8b 10                	mov    (%eax),%edx
    163a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    163d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1642:	8b 40 04             	mov    0x4(%eax),%eax
    1645:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    164c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164f:	01 d0                	add    %edx,%eax
    1651:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1654:	75 20                	jne    1676 <free+0xcf>
    p->s.size += bp->s.size;
    1656:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1659:	8b 50 04             	mov    0x4(%eax),%edx
    165c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165f:	8b 40 04             	mov    0x4(%eax),%eax
    1662:	01 c2                	add    %eax,%edx
    1664:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1667:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    166a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166d:	8b 10                	mov    (%eax),%edx
    166f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1672:	89 10                	mov    %edx,(%eax)
    1674:	eb 08                	jmp    167e <free+0xd7>
  } else
    p->s.ptr = bp;
    1676:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1679:	8b 55 f8             	mov    -0x8(%ebp),%edx
    167c:	89 10                	mov    %edx,(%eax)
  freep = p;
    167e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1681:	a3 44 1a 00 00       	mov    %eax,0x1a44
}
    1686:	90                   	nop
    1687:	c9                   	leave  
    1688:	c3                   	ret    

00001689 <morecore>:

static Header*
morecore(uint nu)
{
    1689:	55                   	push   %ebp
    168a:	89 e5                	mov    %esp,%ebp
    168c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    168f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1696:	77 07                	ja     169f <morecore+0x16>
    nu = 4096;
    1698:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    169f:	8b 45 08             	mov    0x8(%ebp),%eax
    16a2:	c1 e0 03             	shl    $0x3,%eax
    16a5:	83 ec 0c             	sub    $0xc,%esp
    16a8:	50                   	push   %eax
    16a9:	e8 61 fc ff ff       	call   130f <sbrk>
    16ae:	83 c4 10             	add    $0x10,%esp
    16b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16b4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16b8:	75 07                	jne    16c1 <morecore+0x38>
    return 0;
    16ba:	b8 00 00 00 00       	mov    $0x0,%eax
    16bf:	eb 26                	jmp    16e7 <morecore+0x5e>
  hp = (Header*)p;
    16c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    16c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16ca:	8b 55 08             	mov    0x8(%ebp),%edx
    16cd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    16d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16d3:	83 c0 08             	add    $0x8,%eax
    16d6:	83 ec 0c             	sub    $0xc,%esp
    16d9:	50                   	push   %eax
    16da:	e8 c8 fe ff ff       	call   15a7 <free>
    16df:	83 c4 10             	add    $0x10,%esp
  return freep;
    16e2:	a1 44 1a 00 00       	mov    0x1a44,%eax
}
    16e7:	c9                   	leave  
    16e8:	c3                   	ret    

000016e9 <malloc>:

void*
malloc(uint nbytes)
{
    16e9:	55                   	push   %ebp
    16ea:	89 e5                	mov    %esp,%ebp
    16ec:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16ef:	8b 45 08             	mov    0x8(%ebp),%eax
    16f2:	83 c0 07             	add    $0x7,%eax
    16f5:	c1 e8 03             	shr    $0x3,%eax
    16f8:	83 c0 01             	add    $0x1,%eax
    16fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    16fe:	a1 44 1a 00 00       	mov    0x1a44,%eax
    1703:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    170a:	75 23                	jne    172f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    170c:	c7 45 f0 3c 1a 00 00 	movl   $0x1a3c,-0x10(%ebp)
    1713:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1716:	a3 44 1a 00 00       	mov    %eax,0x1a44
    171b:	a1 44 1a 00 00       	mov    0x1a44,%eax
    1720:	a3 3c 1a 00 00       	mov    %eax,0x1a3c
    base.s.size = 0;
    1725:	c7 05 40 1a 00 00 00 	movl   $0x0,0x1a40
    172c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    172f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1732:	8b 00                	mov    (%eax),%eax
    1734:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1737:	8b 45 f4             	mov    -0xc(%ebp),%eax
    173a:	8b 40 04             	mov    0x4(%eax),%eax
    173d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1740:	72 4d                	jb     178f <malloc+0xa6>
      if(p->s.size == nunits)
    1742:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1745:	8b 40 04             	mov    0x4(%eax),%eax
    1748:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    174b:	75 0c                	jne    1759 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    174d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1750:	8b 10                	mov    (%eax),%edx
    1752:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1755:	89 10                	mov    %edx,(%eax)
    1757:	eb 26                	jmp    177f <malloc+0x96>
      else {
        p->s.size -= nunits;
    1759:	8b 45 f4             	mov    -0xc(%ebp),%eax
    175c:	8b 40 04             	mov    0x4(%eax),%eax
    175f:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1762:	89 c2                	mov    %eax,%edx
    1764:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1767:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    176a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    176d:	8b 40 04             	mov    0x4(%eax),%eax
    1770:	c1 e0 03             	shl    $0x3,%eax
    1773:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1776:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1779:	8b 55 ec             	mov    -0x14(%ebp),%edx
    177c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    177f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1782:	a3 44 1a 00 00       	mov    %eax,0x1a44
      return (void*)(p + 1);
    1787:	8b 45 f4             	mov    -0xc(%ebp),%eax
    178a:	83 c0 08             	add    $0x8,%eax
    178d:	eb 3b                	jmp    17ca <malloc+0xe1>
    }
    if(p == freep)
    178f:	a1 44 1a 00 00       	mov    0x1a44,%eax
    1794:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1797:	75 1e                	jne    17b7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    1799:	83 ec 0c             	sub    $0xc,%esp
    179c:	ff 75 ec             	pushl  -0x14(%ebp)
    179f:	e8 e5 fe ff ff       	call   1689 <morecore>
    17a4:	83 c4 10             	add    $0x10,%esp
    17a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17ae:	75 07                	jne    17b7 <malloc+0xce>
        return 0;
    17b0:	b8 00 00 00 00       	mov    $0x0,%eax
    17b5:	eb 13                	jmp    17ca <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c0:	8b 00                	mov    (%eax),%eax
    17c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    17c5:	e9 6d ff ff ff       	jmp    1737 <malloc+0x4e>
}
    17ca:	c9                   	leave  
    17cb:	c3                   	ret    
