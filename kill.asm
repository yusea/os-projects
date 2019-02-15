
_kill:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	53                   	push   %ebx
    100e:	51                   	push   %ecx
    100f:	83 ec 10             	sub    $0x10,%esp
    1012:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
    1014:	83 3b 01             	cmpl   $0x1,(%ebx)
    1017:	7f 17                	jg     1030 <main+0x30>
    printf(2, "usage: kill pid...\n");
    1019:	83 ec 08             	sub    $0x8,%esp
    101c:	68 0e 18 00 00       	push   $0x180e
    1021:	6a 02                	push   $0x2
    1023:	e8 30 04 00 00       	call   1458 <printf>
    1028:	83 c4 10             	add    $0x10,%esp
    exit();
    102b:	e8 99 02 00 00       	call   12c9 <exit>
  }
  for(i=1; i<argc; i++)
    1030:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    1037:	eb 2d                	jmp    1066 <main+0x66>
    kill(atoi(argv[i]));
    1039:	8b 45 f4             	mov    -0xc(%ebp),%eax
    103c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1043:	8b 43 04             	mov    0x4(%ebx),%eax
    1046:	01 d0                	add    %edx,%eax
    1048:	8b 00                	mov    (%eax),%eax
    104a:	83 ec 0c             	sub    $0xc,%esp
    104d:	50                   	push   %eax
    104e:	e8 e4 01 00 00       	call   1237 <atoi>
    1053:	83 c4 10             	add    $0x10,%esp
    1056:	83 ec 0c             	sub    $0xc,%esp
    1059:	50                   	push   %eax
    105a:	e8 9a 02 00 00       	call   12f9 <kill>
    105f:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    1062:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1066:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1069:	3b 03                	cmp    (%ebx),%eax
    106b:	7c cc                	jl     1039 <main+0x39>
    kill(atoi(argv[i]));
  exit();
    106d:	e8 57 02 00 00       	call   12c9 <exit>

00001072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1072:	55                   	push   %ebp
    1073:	89 e5                	mov    %esp,%ebp
    1075:	57                   	push   %edi
    1076:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1077:	8b 4d 08             	mov    0x8(%ebp),%ecx
    107a:	8b 55 10             	mov    0x10(%ebp),%edx
    107d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1080:	89 cb                	mov    %ecx,%ebx
    1082:	89 df                	mov    %ebx,%edi
    1084:	89 d1                	mov    %edx,%ecx
    1086:	fc                   	cld    
    1087:	f3 aa                	rep stos %al,%es:(%edi)
    1089:	89 ca                	mov    %ecx,%edx
    108b:	89 fb                	mov    %edi,%ebx
    108d:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1090:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1093:	90                   	nop
    1094:	5b                   	pop    %ebx
    1095:	5f                   	pop    %edi
    1096:	5d                   	pop    %ebp
    1097:	c3                   	ret    

00001098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1098:	55                   	push   %ebp
    1099:	89 e5                	mov    %esp,%ebp
    109b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    109e:	8b 45 08             	mov    0x8(%ebp),%eax
    10a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10a4:	90                   	nop
    10a5:	8b 45 08             	mov    0x8(%ebp),%eax
    10a8:	8d 50 01             	lea    0x1(%eax),%edx
    10ab:	89 55 08             	mov    %edx,0x8(%ebp)
    10ae:	8b 55 0c             	mov    0xc(%ebp),%edx
    10b1:	8d 4a 01             	lea    0x1(%edx),%ecx
    10b4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10b7:	0f b6 12             	movzbl (%edx),%edx
    10ba:	88 10                	mov    %dl,(%eax)
    10bc:	0f b6 00             	movzbl (%eax),%eax
    10bf:	84 c0                	test   %al,%al
    10c1:	75 e2                	jne    10a5 <strcpy+0xd>
    ;
  return os;
    10c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10c6:	c9                   	leave  
    10c7:	c3                   	ret    

000010c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10c8:	55                   	push   %ebp
    10c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10cb:	eb 08                	jmp    10d5 <strcmp+0xd>
    p++, q++;
    10cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10d5:	8b 45 08             	mov    0x8(%ebp),%eax
    10d8:	0f b6 00             	movzbl (%eax),%eax
    10db:	84 c0                	test   %al,%al
    10dd:	74 10                	je     10ef <strcmp+0x27>
    10df:	8b 45 08             	mov    0x8(%ebp),%eax
    10e2:	0f b6 10             	movzbl (%eax),%edx
    10e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    10e8:	0f b6 00             	movzbl (%eax),%eax
    10eb:	38 c2                	cmp    %al,%dl
    10ed:	74 de                	je     10cd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10ef:	8b 45 08             	mov    0x8(%ebp),%eax
    10f2:	0f b6 00             	movzbl (%eax),%eax
    10f5:	0f b6 d0             	movzbl %al,%edx
    10f8:	8b 45 0c             	mov    0xc(%ebp),%eax
    10fb:	0f b6 00             	movzbl (%eax),%eax
    10fe:	0f b6 c0             	movzbl %al,%eax
    1101:	29 c2                	sub    %eax,%edx
    1103:	89 d0                	mov    %edx,%eax
}
    1105:	5d                   	pop    %ebp
    1106:	c3                   	ret    

00001107 <strlen>:

uint
strlen(const char *s)
{
    1107:	55                   	push   %ebp
    1108:	89 e5                	mov    %esp,%ebp
    110a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    110d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1114:	eb 04                	jmp    111a <strlen+0x13>
    1116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    111a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    111d:	8b 45 08             	mov    0x8(%ebp),%eax
    1120:	01 d0                	add    %edx,%eax
    1122:	0f b6 00             	movzbl (%eax),%eax
    1125:	84 c0                	test   %al,%al
    1127:	75 ed                	jne    1116 <strlen+0xf>
    ;
  return n;
    1129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    112c:	c9                   	leave  
    112d:	c3                   	ret    

0000112e <memset>:

void*
memset(void *dst, int c, uint n)
{
    112e:	55                   	push   %ebp
    112f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    1131:	8b 45 10             	mov    0x10(%ebp),%eax
    1134:	50                   	push   %eax
    1135:	ff 75 0c             	pushl  0xc(%ebp)
    1138:	ff 75 08             	pushl  0x8(%ebp)
    113b:	e8 32 ff ff ff       	call   1072 <stosb>
    1140:	83 c4 0c             	add    $0xc,%esp
  return dst;
    1143:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1146:	c9                   	leave  
    1147:	c3                   	ret    

00001148 <strchr>:

char*
strchr(const char *s, char c)
{
    1148:	55                   	push   %ebp
    1149:	89 e5                	mov    %esp,%ebp
    114b:	83 ec 04             	sub    $0x4,%esp
    114e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1154:	eb 14                	jmp    116a <strchr+0x22>
    if(*s == c)
    1156:	8b 45 08             	mov    0x8(%ebp),%eax
    1159:	0f b6 00             	movzbl (%eax),%eax
    115c:	3a 45 fc             	cmp    -0x4(%ebp),%al
    115f:	75 05                	jne    1166 <strchr+0x1e>
      return (char*)s;
    1161:	8b 45 08             	mov    0x8(%ebp),%eax
    1164:	eb 13                	jmp    1179 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116a:	8b 45 08             	mov    0x8(%ebp),%eax
    116d:	0f b6 00             	movzbl (%eax),%eax
    1170:	84 c0                	test   %al,%al
    1172:	75 e2                	jne    1156 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1174:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1179:	c9                   	leave  
    117a:	c3                   	ret    

0000117b <gets>:

char*
gets(char *buf, int max)
{
    117b:	55                   	push   %ebp
    117c:	89 e5                	mov    %esp,%ebp
    117e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1188:	eb 42                	jmp    11cc <gets+0x51>
    cc = read(0, &c, 1);
    118a:	83 ec 04             	sub    $0x4,%esp
    118d:	6a 01                	push   $0x1
    118f:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1192:	50                   	push   %eax
    1193:	6a 00                	push   $0x0
    1195:	e8 47 01 00 00       	call   12e1 <read>
    119a:	83 c4 10             	add    $0x10,%esp
    119d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11a4:	7e 33                	jle    11d9 <gets+0x5e>
      break;
    buf[i++] = c;
    11a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11a9:	8d 50 01             	lea    0x1(%eax),%edx
    11ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11af:	89 c2                	mov    %eax,%edx
    11b1:	8b 45 08             	mov    0x8(%ebp),%eax
    11b4:	01 c2                	add    %eax,%edx
    11b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c0:	3c 0a                	cmp    $0xa,%al
    11c2:	74 16                	je     11da <gets+0x5f>
    11c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c8:	3c 0d                	cmp    $0xd,%al
    11ca:	74 0e                	je     11da <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11cf:	83 c0 01             	add    $0x1,%eax
    11d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11d5:	7c b3                	jl     118a <gets+0xf>
    11d7:	eb 01                	jmp    11da <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    11d9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11da:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11dd:	8b 45 08             	mov    0x8(%ebp),%eax
    11e0:	01 d0                	add    %edx,%eax
    11e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11e8:	c9                   	leave  
    11e9:	c3                   	ret    

000011ea <stat>:

int
stat(const char *n, struct stat *st)
{
    11ea:	55                   	push   %ebp
    11eb:	89 e5                	mov    %esp,%ebp
    11ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11f0:	83 ec 08             	sub    $0x8,%esp
    11f3:	6a 00                	push   $0x0
    11f5:	ff 75 08             	pushl  0x8(%ebp)
    11f8:	e8 0c 01 00 00       	call   1309 <open>
    11fd:	83 c4 10             	add    $0x10,%esp
    1200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1207:	79 07                	jns    1210 <stat+0x26>
    return -1;
    1209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    120e:	eb 25                	jmp    1235 <stat+0x4b>
  r = fstat(fd, st);
    1210:	83 ec 08             	sub    $0x8,%esp
    1213:	ff 75 0c             	pushl  0xc(%ebp)
    1216:	ff 75 f4             	pushl  -0xc(%ebp)
    1219:	e8 03 01 00 00       	call   1321 <fstat>
    121e:	83 c4 10             	add    $0x10,%esp
    1221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1224:	83 ec 0c             	sub    $0xc,%esp
    1227:	ff 75 f4             	pushl  -0xc(%ebp)
    122a:	e8 c2 00 00 00       	call   12f1 <close>
    122f:	83 c4 10             	add    $0x10,%esp
  return r;
    1232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1235:	c9                   	leave  
    1236:	c3                   	ret    

00001237 <atoi>:

int
atoi(const char *s)
{
    1237:	55                   	push   %ebp
    1238:	89 e5                	mov    %esp,%ebp
    123a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    123d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1244:	eb 25                	jmp    126b <atoi+0x34>
    n = n*10 + *s++ - '0';
    1246:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1249:	89 d0                	mov    %edx,%eax
    124b:	c1 e0 02             	shl    $0x2,%eax
    124e:	01 d0                	add    %edx,%eax
    1250:	01 c0                	add    %eax,%eax
    1252:	89 c1                	mov    %eax,%ecx
    1254:	8b 45 08             	mov    0x8(%ebp),%eax
    1257:	8d 50 01             	lea    0x1(%eax),%edx
    125a:	89 55 08             	mov    %edx,0x8(%ebp)
    125d:	0f b6 00             	movzbl (%eax),%eax
    1260:	0f be c0             	movsbl %al,%eax
    1263:	01 c8                	add    %ecx,%eax
    1265:	83 e8 30             	sub    $0x30,%eax
    1268:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    126b:	8b 45 08             	mov    0x8(%ebp),%eax
    126e:	0f b6 00             	movzbl (%eax),%eax
    1271:	3c 2f                	cmp    $0x2f,%al
    1273:	7e 0a                	jle    127f <atoi+0x48>
    1275:	8b 45 08             	mov    0x8(%ebp),%eax
    1278:	0f b6 00             	movzbl (%eax),%eax
    127b:	3c 39                	cmp    $0x39,%al
    127d:	7e c7                	jle    1246 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    127f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1282:	c9                   	leave  
    1283:	c3                   	ret    

00001284 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1284:	55                   	push   %ebp
    1285:	89 e5                	mov    %esp,%ebp
    1287:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    128a:	8b 45 08             	mov    0x8(%ebp),%eax
    128d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1290:	8b 45 0c             	mov    0xc(%ebp),%eax
    1293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1296:	eb 17                	jmp    12af <memmove+0x2b>
    *dst++ = *src++;
    1298:	8b 45 fc             	mov    -0x4(%ebp),%eax
    129b:	8d 50 01             	lea    0x1(%eax),%edx
    129e:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12a4:	8d 4a 01             	lea    0x1(%edx),%ecx
    12a7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12aa:	0f b6 12             	movzbl (%edx),%edx
    12ad:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12af:	8b 45 10             	mov    0x10(%ebp),%eax
    12b2:	8d 50 ff             	lea    -0x1(%eax),%edx
    12b5:	89 55 10             	mov    %edx,0x10(%ebp)
    12b8:	85 c0                	test   %eax,%eax
    12ba:	7f dc                	jg     1298 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12bf:	c9                   	leave  
    12c0:	c3                   	ret    

000012c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12c1:	b8 01 00 00 00       	mov    $0x1,%eax
    12c6:	cd 40                	int    $0x40
    12c8:	c3                   	ret    

000012c9 <exit>:
SYSCALL(exit)
    12c9:	b8 02 00 00 00       	mov    $0x2,%eax
    12ce:	cd 40                	int    $0x40
    12d0:	c3                   	ret    

000012d1 <wait>:
SYSCALL(wait)
    12d1:	b8 03 00 00 00       	mov    $0x3,%eax
    12d6:	cd 40                	int    $0x40
    12d8:	c3                   	ret    

000012d9 <pipe>:
SYSCALL(pipe)
    12d9:	b8 04 00 00 00       	mov    $0x4,%eax
    12de:	cd 40                	int    $0x40
    12e0:	c3                   	ret    

000012e1 <read>:
SYSCALL(read)
    12e1:	b8 05 00 00 00       	mov    $0x5,%eax
    12e6:	cd 40                	int    $0x40
    12e8:	c3                   	ret    

000012e9 <write>:
SYSCALL(write)
    12e9:	b8 10 00 00 00       	mov    $0x10,%eax
    12ee:	cd 40                	int    $0x40
    12f0:	c3                   	ret    

000012f1 <close>:
SYSCALL(close)
    12f1:	b8 15 00 00 00       	mov    $0x15,%eax
    12f6:	cd 40                	int    $0x40
    12f8:	c3                   	ret    

000012f9 <kill>:
SYSCALL(kill)
    12f9:	b8 06 00 00 00       	mov    $0x6,%eax
    12fe:	cd 40                	int    $0x40
    1300:	c3                   	ret    

00001301 <exec>:
SYSCALL(exec)
    1301:	b8 07 00 00 00       	mov    $0x7,%eax
    1306:	cd 40                	int    $0x40
    1308:	c3                   	ret    

00001309 <open>:
SYSCALL(open)
    1309:	b8 0f 00 00 00       	mov    $0xf,%eax
    130e:	cd 40                	int    $0x40
    1310:	c3                   	ret    

00001311 <mknod>:
SYSCALL(mknod)
    1311:	b8 11 00 00 00       	mov    $0x11,%eax
    1316:	cd 40                	int    $0x40
    1318:	c3                   	ret    

00001319 <unlink>:
SYSCALL(unlink)
    1319:	b8 12 00 00 00       	mov    $0x12,%eax
    131e:	cd 40                	int    $0x40
    1320:	c3                   	ret    

00001321 <fstat>:
SYSCALL(fstat)
    1321:	b8 08 00 00 00       	mov    $0x8,%eax
    1326:	cd 40                	int    $0x40
    1328:	c3                   	ret    

00001329 <link>:
SYSCALL(link)
    1329:	b8 13 00 00 00       	mov    $0x13,%eax
    132e:	cd 40                	int    $0x40
    1330:	c3                   	ret    

00001331 <mkdir>:
SYSCALL(mkdir)
    1331:	b8 14 00 00 00       	mov    $0x14,%eax
    1336:	cd 40                	int    $0x40
    1338:	c3                   	ret    

00001339 <chdir>:
SYSCALL(chdir)
    1339:	b8 09 00 00 00       	mov    $0x9,%eax
    133e:	cd 40                	int    $0x40
    1340:	c3                   	ret    

00001341 <dup>:
SYSCALL(dup)
    1341:	b8 0a 00 00 00       	mov    $0xa,%eax
    1346:	cd 40                	int    $0x40
    1348:	c3                   	ret    

00001349 <getpid>:
SYSCALL(getpid)
    1349:	b8 0b 00 00 00       	mov    $0xb,%eax
    134e:	cd 40                	int    $0x40
    1350:	c3                   	ret    

00001351 <sbrk>:
SYSCALL(sbrk)
    1351:	b8 0c 00 00 00       	mov    $0xc,%eax
    1356:	cd 40                	int    $0x40
    1358:	c3                   	ret    

00001359 <sleep>:
SYSCALL(sleep)
    1359:	b8 0d 00 00 00       	mov    $0xd,%eax
    135e:	cd 40                	int    $0x40
    1360:	c3                   	ret    

00001361 <uptime>:
SYSCALL(uptime)
    1361:	b8 0e 00 00 00       	mov    $0xe,%eax
    1366:	cd 40                	int    $0x40
    1368:	c3                   	ret    

00001369 <getprocsinfo>:
SYSCALL(getprocsinfo)
    1369:	b8 16 00 00 00       	mov    $0x16,%eax
    136e:	cd 40                	int    $0x40
    1370:	c3                   	ret    

00001371 <shmem_access>:
SYSCALL(shmem_access)
    1371:	b8 17 00 00 00       	mov    $0x17,%eax
    1376:	cd 40                	int    $0x40
    1378:	c3                   	ret    

00001379 <shmem_count>:
SYSCALL(shmem_count)
    1379:	b8 18 00 00 00       	mov    $0x18,%eax
    137e:	cd 40                	int    $0x40
    1380:	c3                   	ret    

00001381 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1381:	55                   	push   %ebp
    1382:	89 e5                	mov    %esp,%ebp
    1384:	83 ec 18             	sub    $0x18,%esp
    1387:	8b 45 0c             	mov    0xc(%ebp),%eax
    138a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    138d:	83 ec 04             	sub    $0x4,%esp
    1390:	6a 01                	push   $0x1
    1392:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1395:	50                   	push   %eax
    1396:	ff 75 08             	pushl  0x8(%ebp)
    1399:	e8 4b ff ff ff       	call   12e9 <write>
    139e:	83 c4 10             	add    $0x10,%esp
}
    13a1:	90                   	nop
    13a2:	c9                   	leave  
    13a3:	c3                   	ret    

000013a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13a4:	55                   	push   %ebp
    13a5:	89 e5                	mov    %esp,%ebp
    13a7:	53                   	push   %ebx
    13a8:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13b2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13b6:	74 17                	je     13cf <printint+0x2b>
    13b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13bc:	79 11                	jns    13cf <printint+0x2b>
    neg = 1;
    13be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13c5:	8b 45 0c             	mov    0xc(%ebp),%eax
    13c8:	f7 d8                	neg    %eax
    13ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13cd:	eb 06                	jmp    13d5 <printint+0x31>
  } else {
    x = xx;
    13cf:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13df:	8d 41 01             	lea    0x1(%ecx),%eax
    13e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13eb:	ba 00 00 00 00       	mov    $0x0,%edx
    13f0:	f7 f3                	div    %ebx
    13f2:	89 d0                	mov    %edx,%eax
    13f4:	0f b6 80 78 1a 00 00 	movzbl 0x1a78(%eax),%eax
    13fb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1402:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1405:	ba 00 00 00 00       	mov    $0x0,%edx
    140a:	f7 f3                	div    %ebx
    140c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    140f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1413:	75 c7                	jne    13dc <printint+0x38>
  if(neg)
    1415:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1419:	74 2d                	je     1448 <printint+0xa4>
    buf[i++] = '-';
    141b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141e:	8d 50 01             	lea    0x1(%eax),%edx
    1421:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1424:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1429:	eb 1d                	jmp    1448 <printint+0xa4>
    putc(fd, buf[i]);
    142b:	8d 55 dc             	lea    -0x24(%ebp),%edx
    142e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1431:	01 d0                	add    %edx,%eax
    1433:	0f b6 00             	movzbl (%eax),%eax
    1436:	0f be c0             	movsbl %al,%eax
    1439:	83 ec 08             	sub    $0x8,%esp
    143c:	50                   	push   %eax
    143d:	ff 75 08             	pushl  0x8(%ebp)
    1440:	e8 3c ff ff ff       	call   1381 <putc>
    1445:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1448:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    144c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1450:	79 d9                	jns    142b <printint+0x87>
    putc(fd, buf[i]);
}
    1452:	90                   	nop
    1453:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1456:	c9                   	leave  
    1457:	c3                   	ret    

00001458 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1458:	55                   	push   %ebp
    1459:	89 e5                	mov    %esp,%ebp
    145b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    145e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1465:	8d 45 0c             	lea    0xc(%ebp),%eax
    1468:	83 c0 04             	add    $0x4,%eax
    146b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    146e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1475:	e9 59 01 00 00       	jmp    15d3 <printf+0x17b>
    c = fmt[i] & 0xff;
    147a:	8b 55 0c             	mov    0xc(%ebp),%edx
    147d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1480:	01 d0                	add    %edx,%eax
    1482:	0f b6 00             	movzbl (%eax),%eax
    1485:	0f be c0             	movsbl %al,%eax
    1488:	25 ff 00 00 00       	and    $0xff,%eax
    148d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1490:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1494:	75 2c                	jne    14c2 <printf+0x6a>
      if(c == '%'){
    1496:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    149a:	75 0c                	jne    14a8 <printf+0x50>
        state = '%';
    149c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14a3:	e9 27 01 00 00       	jmp    15cf <printf+0x177>
      } else {
        putc(fd, c);
    14a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14ab:	0f be c0             	movsbl %al,%eax
    14ae:	83 ec 08             	sub    $0x8,%esp
    14b1:	50                   	push   %eax
    14b2:	ff 75 08             	pushl  0x8(%ebp)
    14b5:	e8 c7 fe ff ff       	call   1381 <putc>
    14ba:	83 c4 10             	add    $0x10,%esp
    14bd:	e9 0d 01 00 00       	jmp    15cf <printf+0x177>
      }
    } else if(state == '%'){
    14c2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14c6:	0f 85 03 01 00 00    	jne    15cf <printf+0x177>
      if(c == 'd'){
    14cc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14d0:	75 1e                	jne    14f0 <printf+0x98>
        printint(fd, *ap, 10, 1);
    14d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14d5:	8b 00                	mov    (%eax),%eax
    14d7:	6a 01                	push   $0x1
    14d9:	6a 0a                	push   $0xa
    14db:	50                   	push   %eax
    14dc:	ff 75 08             	pushl  0x8(%ebp)
    14df:	e8 c0 fe ff ff       	call   13a4 <printint>
    14e4:	83 c4 10             	add    $0x10,%esp
        ap++;
    14e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14eb:	e9 d8 00 00 00       	jmp    15c8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    14f0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14f4:	74 06                	je     14fc <printf+0xa4>
    14f6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14fa:	75 1e                	jne    151a <printf+0xc2>
        printint(fd, *ap, 16, 0);
    14fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14ff:	8b 00                	mov    (%eax),%eax
    1501:	6a 00                	push   $0x0
    1503:	6a 10                	push   $0x10
    1505:	50                   	push   %eax
    1506:	ff 75 08             	pushl  0x8(%ebp)
    1509:	e8 96 fe ff ff       	call   13a4 <printint>
    150e:	83 c4 10             	add    $0x10,%esp
        ap++;
    1511:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1515:	e9 ae 00 00 00       	jmp    15c8 <printf+0x170>
      } else if(c == 's'){
    151a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    151e:	75 43                	jne    1563 <printf+0x10b>
        s = (char*)*ap;
    1520:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1523:	8b 00                	mov    (%eax),%eax
    1525:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1528:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    152c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1530:	75 25                	jne    1557 <printf+0xff>
          s = "(null)";
    1532:	c7 45 f4 22 18 00 00 	movl   $0x1822,-0xc(%ebp)
        while(*s != 0){
    1539:	eb 1c                	jmp    1557 <printf+0xff>
          putc(fd, *s);
    153b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    153e:	0f b6 00             	movzbl (%eax),%eax
    1541:	0f be c0             	movsbl %al,%eax
    1544:	83 ec 08             	sub    $0x8,%esp
    1547:	50                   	push   %eax
    1548:	ff 75 08             	pushl  0x8(%ebp)
    154b:	e8 31 fe ff ff       	call   1381 <putc>
    1550:	83 c4 10             	add    $0x10,%esp
          s++;
    1553:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1557:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155a:	0f b6 00             	movzbl (%eax),%eax
    155d:	84 c0                	test   %al,%al
    155f:	75 da                	jne    153b <printf+0xe3>
    1561:	eb 65                	jmp    15c8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1563:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1567:	75 1d                	jne    1586 <printf+0x12e>
        putc(fd, *ap);
    1569:	8b 45 e8             	mov    -0x18(%ebp),%eax
    156c:	8b 00                	mov    (%eax),%eax
    156e:	0f be c0             	movsbl %al,%eax
    1571:	83 ec 08             	sub    $0x8,%esp
    1574:	50                   	push   %eax
    1575:	ff 75 08             	pushl  0x8(%ebp)
    1578:	e8 04 fe ff ff       	call   1381 <putc>
    157d:	83 c4 10             	add    $0x10,%esp
        ap++;
    1580:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1584:	eb 42                	jmp    15c8 <printf+0x170>
      } else if(c == '%'){
    1586:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    158a:	75 17                	jne    15a3 <printf+0x14b>
        putc(fd, c);
    158c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    158f:	0f be c0             	movsbl %al,%eax
    1592:	83 ec 08             	sub    $0x8,%esp
    1595:	50                   	push   %eax
    1596:	ff 75 08             	pushl  0x8(%ebp)
    1599:	e8 e3 fd ff ff       	call   1381 <putc>
    159e:	83 c4 10             	add    $0x10,%esp
    15a1:	eb 25                	jmp    15c8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15a3:	83 ec 08             	sub    $0x8,%esp
    15a6:	6a 25                	push   $0x25
    15a8:	ff 75 08             	pushl  0x8(%ebp)
    15ab:	e8 d1 fd ff ff       	call   1381 <putc>
    15b0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    15b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15b6:	0f be c0             	movsbl %al,%eax
    15b9:	83 ec 08             	sub    $0x8,%esp
    15bc:	50                   	push   %eax
    15bd:	ff 75 08             	pushl  0x8(%ebp)
    15c0:	e8 bc fd ff ff       	call   1381 <putc>
    15c5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    15c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15cf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15d3:	8b 55 0c             	mov    0xc(%ebp),%edx
    15d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15d9:	01 d0                	add    %edx,%eax
    15db:	0f b6 00             	movzbl (%eax),%eax
    15de:	84 c0                	test   %al,%al
    15e0:	0f 85 94 fe ff ff    	jne    147a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15e6:	90                   	nop
    15e7:	c9                   	leave  
    15e8:	c3                   	ret    

000015e9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15e9:	55                   	push   %ebp
    15ea:	89 e5                	mov    %esp,%ebp
    15ec:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15ef:	8b 45 08             	mov    0x8(%ebp),%eax
    15f2:	83 e8 08             	sub    $0x8,%eax
    15f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15f8:	a1 94 1a 00 00       	mov    0x1a94,%eax
    15fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1600:	eb 24                	jmp    1626 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1602:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1605:	8b 00                	mov    (%eax),%eax
    1607:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    160a:	77 12                	ja     161e <free+0x35>
    160c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    160f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1612:	77 24                	ja     1638 <free+0x4f>
    1614:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1617:	8b 00                	mov    (%eax),%eax
    1619:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    161c:	77 1a                	ja     1638 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    161e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1621:	8b 00                	mov    (%eax),%eax
    1623:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1626:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1629:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    162c:	76 d4                	jbe    1602 <free+0x19>
    162e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1631:	8b 00                	mov    (%eax),%eax
    1633:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1636:	76 ca                	jbe    1602 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1638:	8b 45 f8             	mov    -0x8(%ebp),%eax
    163b:	8b 40 04             	mov    0x4(%eax),%eax
    163e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1645:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1648:	01 c2                	add    %eax,%edx
    164a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164d:	8b 00                	mov    (%eax),%eax
    164f:	39 c2                	cmp    %eax,%edx
    1651:	75 24                	jne    1677 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1653:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1656:	8b 50 04             	mov    0x4(%eax),%edx
    1659:	8b 45 fc             	mov    -0x4(%ebp),%eax
    165c:	8b 00                	mov    (%eax),%eax
    165e:	8b 40 04             	mov    0x4(%eax),%eax
    1661:	01 c2                	add    %eax,%edx
    1663:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1666:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1669:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166c:	8b 00                	mov    (%eax),%eax
    166e:	8b 10                	mov    (%eax),%edx
    1670:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1673:	89 10                	mov    %edx,(%eax)
    1675:	eb 0a                	jmp    1681 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1677:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167a:	8b 10                	mov    (%eax),%edx
    167c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1681:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1684:	8b 40 04             	mov    0x4(%eax),%eax
    1687:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1691:	01 d0                	add    %edx,%eax
    1693:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1696:	75 20                	jne    16b8 <free+0xcf>
    p->s.size += bp->s.size;
    1698:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169b:	8b 50 04             	mov    0x4(%eax),%edx
    169e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a1:	8b 40 04             	mov    0x4(%eax),%eax
    16a4:	01 c2                	add    %eax,%edx
    16a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16af:	8b 10                	mov    (%eax),%edx
    16b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b4:	89 10                	mov    %edx,(%eax)
    16b6:	eb 08                	jmp    16c0 <free+0xd7>
  } else
    p->s.ptr = bp;
    16b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16be:	89 10                	mov    %edx,(%eax)
  freep = p;
    16c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c3:	a3 94 1a 00 00       	mov    %eax,0x1a94
}
    16c8:	90                   	nop
    16c9:	c9                   	leave  
    16ca:	c3                   	ret    

000016cb <morecore>:

static Header*
morecore(uint nu)
{
    16cb:	55                   	push   %ebp
    16cc:	89 e5                	mov    %esp,%ebp
    16ce:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16d8:	77 07                	ja     16e1 <morecore+0x16>
    nu = 4096;
    16da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16e1:	8b 45 08             	mov    0x8(%ebp),%eax
    16e4:	c1 e0 03             	shl    $0x3,%eax
    16e7:	83 ec 0c             	sub    $0xc,%esp
    16ea:	50                   	push   %eax
    16eb:	e8 61 fc ff ff       	call   1351 <sbrk>
    16f0:	83 c4 10             	add    $0x10,%esp
    16f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16fa:	75 07                	jne    1703 <morecore+0x38>
    return 0;
    16fc:	b8 00 00 00 00       	mov    $0x0,%eax
    1701:	eb 26                	jmp    1729 <morecore+0x5e>
  hp = (Header*)p;
    1703:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1709:	8b 45 f0             	mov    -0x10(%ebp),%eax
    170c:	8b 55 08             	mov    0x8(%ebp),%edx
    170f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1712:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1715:	83 c0 08             	add    $0x8,%eax
    1718:	83 ec 0c             	sub    $0xc,%esp
    171b:	50                   	push   %eax
    171c:	e8 c8 fe ff ff       	call   15e9 <free>
    1721:	83 c4 10             	add    $0x10,%esp
  return freep;
    1724:	a1 94 1a 00 00       	mov    0x1a94,%eax
}
    1729:	c9                   	leave  
    172a:	c3                   	ret    

0000172b <malloc>:

void*
malloc(uint nbytes)
{
    172b:	55                   	push   %ebp
    172c:	89 e5                	mov    %esp,%ebp
    172e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1731:	8b 45 08             	mov    0x8(%ebp),%eax
    1734:	83 c0 07             	add    $0x7,%eax
    1737:	c1 e8 03             	shr    $0x3,%eax
    173a:	83 c0 01             	add    $0x1,%eax
    173d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1740:	a1 94 1a 00 00       	mov    0x1a94,%eax
    1745:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1748:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    174c:	75 23                	jne    1771 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    174e:	c7 45 f0 8c 1a 00 00 	movl   $0x1a8c,-0x10(%ebp)
    1755:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1758:	a3 94 1a 00 00       	mov    %eax,0x1a94
    175d:	a1 94 1a 00 00       	mov    0x1a94,%eax
    1762:	a3 8c 1a 00 00       	mov    %eax,0x1a8c
    base.s.size = 0;
    1767:	c7 05 90 1a 00 00 00 	movl   $0x0,0x1a90
    176e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1771:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1774:	8b 00                	mov    (%eax),%eax
    1776:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1779:	8b 45 f4             	mov    -0xc(%ebp),%eax
    177c:	8b 40 04             	mov    0x4(%eax),%eax
    177f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1782:	72 4d                	jb     17d1 <malloc+0xa6>
      if(p->s.size == nunits)
    1784:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1787:	8b 40 04             	mov    0x4(%eax),%eax
    178a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    178d:	75 0c                	jne    179b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    178f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1792:	8b 10                	mov    (%eax),%edx
    1794:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1797:	89 10                	mov    %edx,(%eax)
    1799:	eb 26                	jmp    17c1 <malloc+0x96>
      else {
        p->s.size -= nunits;
    179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179e:	8b 40 04             	mov    0x4(%eax),%eax
    17a1:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17a4:	89 c2                	mov    %eax,%edx
    17a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17af:	8b 40 04             	mov    0x4(%eax),%eax
    17b2:	c1 e0 03             	shl    $0x3,%eax
    17b5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17be:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17c4:	a3 94 1a 00 00       	mov    %eax,0x1a94
      return (void*)(p + 1);
    17c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17cc:	83 c0 08             	add    $0x8,%eax
    17cf:	eb 3b                	jmp    180c <malloc+0xe1>
    }
    if(p == freep)
    17d1:	a1 94 1a 00 00       	mov    0x1a94,%eax
    17d6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17d9:	75 1e                	jne    17f9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    17db:	83 ec 0c             	sub    $0xc,%esp
    17de:	ff 75 ec             	pushl  -0x14(%ebp)
    17e1:	e8 e5 fe ff ff       	call   16cb <morecore>
    17e6:	83 c4 10             	add    $0x10,%esp
    17e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17f0:	75 07                	jne    17f9 <malloc+0xce>
        return 0;
    17f2:	b8 00 00 00 00       	mov    $0x0,%eax
    17f7:	eb 13                	jmp    180c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1802:	8b 00                	mov    (%eax),%eax
    1804:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1807:	e9 6d ff ff ff       	jmp    1779 <malloc+0x4e>
}
    180c:	c9                   	leave  
    180d:	c3                   	ret    
