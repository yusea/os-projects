
_zombie:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	51                   	push   %ecx
    100e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
    1011:	e8 65 02 00 00       	call   127b <fork>
    1016:	85 c0                	test   %eax,%eax
    1018:	7e 0d                	jle    1027 <main+0x27>
    sleep(5);  // Let child exit before parent.
    101a:	83 ec 0c             	sub    $0xc,%esp
    101d:	6a 05                	push   $0x5
    101f:	e8 ef 02 00 00       	call   1313 <sleep>
    1024:	83 c4 10             	add    $0x10,%esp
  exit();
    1027:	e8 57 02 00 00       	call   1283 <exit>

0000102c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    102c:	55                   	push   %ebp
    102d:	89 e5                	mov    %esp,%ebp
    102f:	57                   	push   %edi
    1030:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1031:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1034:	8b 55 10             	mov    0x10(%ebp),%edx
    1037:	8b 45 0c             	mov    0xc(%ebp),%eax
    103a:	89 cb                	mov    %ecx,%ebx
    103c:	89 df                	mov    %ebx,%edi
    103e:	89 d1                	mov    %edx,%ecx
    1040:	fc                   	cld    
    1041:	f3 aa                	rep stos %al,%es:(%edi)
    1043:	89 ca                	mov    %ecx,%edx
    1045:	89 fb                	mov    %edi,%ebx
    1047:	89 5d 08             	mov    %ebx,0x8(%ebp)
    104a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    104d:	90                   	nop
    104e:	5b                   	pop    %ebx
    104f:	5f                   	pop    %edi
    1050:	5d                   	pop    %ebp
    1051:	c3                   	ret    

00001052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1052:	55                   	push   %ebp
    1053:	89 e5                	mov    %esp,%ebp
    1055:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1058:	8b 45 08             	mov    0x8(%ebp),%eax
    105b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    105e:	90                   	nop
    105f:	8b 45 08             	mov    0x8(%ebp),%eax
    1062:	8d 50 01             	lea    0x1(%eax),%edx
    1065:	89 55 08             	mov    %edx,0x8(%ebp)
    1068:	8b 55 0c             	mov    0xc(%ebp),%edx
    106b:	8d 4a 01             	lea    0x1(%edx),%ecx
    106e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1071:	0f b6 12             	movzbl (%edx),%edx
    1074:	88 10                	mov    %dl,(%eax)
    1076:	0f b6 00             	movzbl (%eax),%eax
    1079:	84 c0                	test   %al,%al
    107b:	75 e2                	jne    105f <strcpy+0xd>
    ;
  return os;
    107d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1080:	c9                   	leave  
    1081:	c3                   	ret    

00001082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1082:	55                   	push   %ebp
    1083:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1085:	eb 08                	jmp    108f <strcmp+0xd>
    p++, q++;
    1087:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    108b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    108f:	8b 45 08             	mov    0x8(%ebp),%eax
    1092:	0f b6 00             	movzbl (%eax),%eax
    1095:	84 c0                	test   %al,%al
    1097:	74 10                	je     10a9 <strcmp+0x27>
    1099:	8b 45 08             	mov    0x8(%ebp),%eax
    109c:	0f b6 10             	movzbl (%eax),%edx
    109f:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a2:	0f b6 00             	movzbl (%eax),%eax
    10a5:	38 c2                	cmp    %al,%dl
    10a7:	74 de                	je     1087 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10a9:	8b 45 08             	mov    0x8(%ebp),%eax
    10ac:	0f b6 00             	movzbl (%eax),%eax
    10af:	0f b6 d0             	movzbl %al,%edx
    10b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b5:	0f b6 00             	movzbl (%eax),%eax
    10b8:	0f b6 c0             	movzbl %al,%eax
    10bb:	29 c2                	sub    %eax,%edx
    10bd:	89 d0                	mov    %edx,%eax
}
    10bf:	5d                   	pop    %ebp
    10c0:	c3                   	ret    

000010c1 <strlen>:

uint
strlen(const char *s)
{
    10c1:	55                   	push   %ebp
    10c2:	89 e5                	mov    %esp,%ebp
    10c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10ce:	eb 04                	jmp    10d4 <strlen+0x13>
    10d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10d7:	8b 45 08             	mov    0x8(%ebp),%eax
    10da:	01 d0                	add    %edx,%eax
    10dc:	0f b6 00             	movzbl (%eax),%eax
    10df:	84 c0                	test   %al,%al
    10e1:	75 ed                	jne    10d0 <strlen+0xf>
    ;
  return n;
    10e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10e6:	c9                   	leave  
    10e7:	c3                   	ret    

000010e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10e8:	55                   	push   %ebp
    10e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    10eb:	8b 45 10             	mov    0x10(%ebp),%eax
    10ee:	50                   	push   %eax
    10ef:	ff 75 0c             	pushl  0xc(%ebp)
    10f2:	ff 75 08             	pushl  0x8(%ebp)
    10f5:	e8 32 ff ff ff       	call   102c <stosb>
    10fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
    10fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1100:	c9                   	leave  
    1101:	c3                   	ret    

00001102 <strchr>:

char*
strchr(const char *s, char c)
{
    1102:	55                   	push   %ebp
    1103:	89 e5                	mov    %esp,%ebp
    1105:	83 ec 04             	sub    $0x4,%esp
    1108:	8b 45 0c             	mov    0xc(%ebp),%eax
    110b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    110e:	eb 14                	jmp    1124 <strchr+0x22>
    if(*s == c)
    1110:	8b 45 08             	mov    0x8(%ebp),%eax
    1113:	0f b6 00             	movzbl (%eax),%eax
    1116:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1119:	75 05                	jne    1120 <strchr+0x1e>
      return (char*)s;
    111b:	8b 45 08             	mov    0x8(%ebp),%eax
    111e:	eb 13                	jmp    1133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1124:	8b 45 08             	mov    0x8(%ebp),%eax
    1127:	0f b6 00             	movzbl (%eax),%eax
    112a:	84 c0                	test   %al,%al
    112c:	75 e2                	jne    1110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    112e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1133:	c9                   	leave  
    1134:	c3                   	ret    

00001135 <gets>:

char*
gets(char *buf, int max)
{
    1135:	55                   	push   %ebp
    1136:	89 e5                	mov    %esp,%ebp
    1138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1142:	eb 42                	jmp    1186 <gets+0x51>
    cc = read(0, &c, 1);
    1144:	83 ec 04             	sub    $0x4,%esp
    1147:	6a 01                	push   $0x1
    1149:	8d 45 ef             	lea    -0x11(%ebp),%eax
    114c:	50                   	push   %eax
    114d:	6a 00                	push   $0x0
    114f:	e8 47 01 00 00       	call   129b <read>
    1154:	83 c4 10             	add    $0x10,%esp
    1157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    115a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    115e:	7e 33                	jle    1193 <gets+0x5e>
      break;
    buf[i++] = c;
    1160:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1163:	8d 50 01             	lea    0x1(%eax),%edx
    1166:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1169:	89 c2                	mov    %eax,%edx
    116b:	8b 45 08             	mov    0x8(%ebp),%eax
    116e:	01 c2                	add    %eax,%edx
    1170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    117a:	3c 0a                	cmp    $0xa,%al
    117c:	74 16                	je     1194 <gets+0x5f>
    117e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1182:	3c 0d                	cmp    $0xd,%al
    1184:	74 0e                	je     1194 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1186:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1189:	83 c0 01             	add    $0x1,%eax
    118c:	3b 45 0c             	cmp    0xc(%ebp),%eax
    118f:	7c b3                	jl     1144 <gets+0xf>
    1191:	eb 01                	jmp    1194 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1193:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1194:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1197:	8b 45 08             	mov    0x8(%ebp),%eax
    119a:	01 d0                	add    %edx,%eax
    119c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    119f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11a2:	c9                   	leave  
    11a3:	c3                   	ret    

000011a4 <stat>:

int
stat(const char *n, struct stat *st)
{
    11a4:	55                   	push   %ebp
    11a5:	89 e5                	mov    %esp,%ebp
    11a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11aa:	83 ec 08             	sub    $0x8,%esp
    11ad:	6a 00                	push   $0x0
    11af:	ff 75 08             	pushl  0x8(%ebp)
    11b2:	e8 0c 01 00 00       	call   12c3 <open>
    11b7:	83 c4 10             	add    $0x10,%esp
    11ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11c1:	79 07                	jns    11ca <stat+0x26>
    return -1;
    11c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11c8:	eb 25                	jmp    11ef <stat+0x4b>
  r = fstat(fd, st);
    11ca:	83 ec 08             	sub    $0x8,%esp
    11cd:	ff 75 0c             	pushl  0xc(%ebp)
    11d0:	ff 75 f4             	pushl  -0xc(%ebp)
    11d3:	e8 03 01 00 00       	call   12db <fstat>
    11d8:	83 c4 10             	add    $0x10,%esp
    11db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    11de:	83 ec 0c             	sub    $0xc,%esp
    11e1:	ff 75 f4             	pushl  -0xc(%ebp)
    11e4:	e8 c2 00 00 00       	call   12ab <close>
    11e9:	83 c4 10             	add    $0x10,%esp
  return r;
    11ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    11ef:	c9                   	leave  
    11f0:	c3                   	ret    

000011f1 <atoi>:

int
atoi(const char *s)
{
    11f1:	55                   	push   %ebp
    11f2:	89 e5                	mov    %esp,%ebp
    11f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    11f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    11fe:	eb 25                	jmp    1225 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1200:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1203:	89 d0                	mov    %edx,%eax
    1205:	c1 e0 02             	shl    $0x2,%eax
    1208:	01 d0                	add    %edx,%eax
    120a:	01 c0                	add    %eax,%eax
    120c:	89 c1                	mov    %eax,%ecx
    120e:	8b 45 08             	mov    0x8(%ebp),%eax
    1211:	8d 50 01             	lea    0x1(%eax),%edx
    1214:	89 55 08             	mov    %edx,0x8(%ebp)
    1217:	0f b6 00             	movzbl (%eax),%eax
    121a:	0f be c0             	movsbl %al,%eax
    121d:	01 c8                	add    %ecx,%eax
    121f:	83 e8 30             	sub    $0x30,%eax
    1222:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1225:	8b 45 08             	mov    0x8(%ebp),%eax
    1228:	0f b6 00             	movzbl (%eax),%eax
    122b:	3c 2f                	cmp    $0x2f,%al
    122d:	7e 0a                	jle    1239 <atoi+0x48>
    122f:	8b 45 08             	mov    0x8(%ebp),%eax
    1232:	0f b6 00             	movzbl (%eax),%eax
    1235:	3c 39                	cmp    $0x39,%al
    1237:	7e c7                	jle    1200 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1239:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    123c:	c9                   	leave  
    123d:	c3                   	ret    

0000123e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    123e:	55                   	push   %ebp
    123f:	89 e5                	mov    %esp,%ebp
    1241:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    1244:	8b 45 08             	mov    0x8(%ebp),%eax
    1247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    124a:	8b 45 0c             	mov    0xc(%ebp),%eax
    124d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1250:	eb 17                	jmp    1269 <memmove+0x2b>
    *dst++ = *src++;
    1252:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1255:	8d 50 01             	lea    0x1(%eax),%edx
    1258:	89 55 fc             	mov    %edx,-0x4(%ebp)
    125b:	8b 55 f8             	mov    -0x8(%ebp),%edx
    125e:	8d 4a 01             	lea    0x1(%edx),%ecx
    1261:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1264:	0f b6 12             	movzbl (%edx),%edx
    1267:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1269:	8b 45 10             	mov    0x10(%ebp),%eax
    126c:	8d 50 ff             	lea    -0x1(%eax),%edx
    126f:	89 55 10             	mov    %edx,0x10(%ebp)
    1272:	85 c0                	test   %eax,%eax
    1274:	7f dc                	jg     1252 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1276:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1279:	c9                   	leave  
    127a:	c3                   	ret    

0000127b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    127b:	b8 01 00 00 00       	mov    $0x1,%eax
    1280:	cd 40                	int    $0x40
    1282:	c3                   	ret    

00001283 <exit>:
SYSCALL(exit)
    1283:	b8 02 00 00 00       	mov    $0x2,%eax
    1288:	cd 40                	int    $0x40
    128a:	c3                   	ret    

0000128b <wait>:
SYSCALL(wait)
    128b:	b8 03 00 00 00       	mov    $0x3,%eax
    1290:	cd 40                	int    $0x40
    1292:	c3                   	ret    

00001293 <pipe>:
SYSCALL(pipe)
    1293:	b8 04 00 00 00       	mov    $0x4,%eax
    1298:	cd 40                	int    $0x40
    129a:	c3                   	ret    

0000129b <read>:
SYSCALL(read)
    129b:	b8 05 00 00 00       	mov    $0x5,%eax
    12a0:	cd 40                	int    $0x40
    12a2:	c3                   	ret    

000012a3 <write>:
SYSCALL(write)
    12a3:	b8 10 00 00 00       	mov    $0x10,%eax
    12a8:	cd 40                	int    $0x40
    12aa:	c3                   	ret    

000012ab <close>:
SYSCALL(close)
    12ab:	b8 15 00 00 00       	mov    $0x15,%eax
    12b0:	cd 40                	int    $0x40
    12b2:	c3                   	ret    

000012b3 <kill>:
SYSCALL(kill)
    12b3:	b8 06 00 00 00       	mov    $0x6,%eax
    12b8:	cd 40                	int    $0x40
    12ba:	c3                   	ret    

000012bb <exec>:
SYSCALL(exec)
    12bb:	b8 07 00 00 00       	mov    $0x7,%eax
    12c0:	cd 40                	int    $0x40
    12c2:	c3                   	ret    

000012c3 <open>:
SYSCALL(open)
    12c3:	b8 0f 00 00 00       	mov    $0xf,%eax
    12c8:	cd 40                	int    $0x40
    12ca:	c3                   	ret    

000012cb <mknod>:
SYSCALL(mknod)
    12cb:	b8 11 00 00 00       	mov    $0x11,%eax
    12d0:	cd 40                	int    $0x40
    12d2:	c3                   	ret    

000012d3 <unlink>:
SYSCALL(unlink)
    12d3:	b8 12 00 00 00       	mov    $0x12,%eax
    12d8:	cd 40                	int    $0x40
    12da:	c3                   	ret    

000012db <fstat>:
SYSCALL(fstat)
    12db:	b8 08 00 00 00       	mov    $0x8,%eax
    12e0:	cd 40                	int    $0x40
    12e2:	c3                   	ret    

000012e3 <link>:
SYSCALL(link)
    12e3:	b8 13 00 00 00       	mov    $0x13,%eax
    12e8:	cd 40                	int    $0x40
    12ea:	c3                   	ret    

000012eb <mkdir>:
SYSCALL(mkdir)
    12eb:	b8 14 00 00 00       	mov    $0x14,%eax
    12f0:	cd 40                	int    $0x40
    12f2:	c3                   	ret    

000012f3 <chdir>:
SYSCALL(chdir)
    12f3:	b8 09 00 00 00       	mov    $0x9,%eax
    12f8:	cd 40                	int    $0x40
    12fa:	c3                   	ret    

000012fb <dup>:
SYSCALL(dup)
    12fb:	b8 0a 00 00 00       	mov    $0xa,%eax
    1300:	cd 40                	int    $0x40
    1302:	c3                   	ret    

00001303 <getpid>:
SYSCALL(getpid)
    1303:	b8 0b 00 00 00       	mov    $0xb,%eax
    1308:	cd 40                	int    $0x40
    130a:	c3                   	ret    

0000130b <sbrk>:
SYSCALL(sbrk)
    130b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1310:	cd 40                	int    $0x40
    1312:	c3                   	ret    

00001313 <sleep>:
SYSCALL(sleep)
    1313:	b8 0d 00 00 00       	mov    $0xd,%eax
    1318:	cd 40                	int    $0x40
    131a:	c3                   	ret    

0000131b <uptime>:
SYSCALL(uptime)
    131b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1320:	cd 40                	int    $0x40
    1322:	c3                   	ret    

00001323 <getprocsinfo>:
SYSCALL(getprocsinfo)
    1323:	b8 16 00 00 00       	mov    $0x16,%eax
    1328:	cd 40                	int    $0x40
    132a:	c3                   	ret    

0000132b <shmem_access>:
SYSCALL(shmem_access)
    132b:	b8 17 00 00 00       	mov    $0x17,%eax
    1330:	cd 40                	int    $0x40
    1332:	c3                   	ret    

00001333 <shmem_count>:
SYSCALL(shmem_count)
    1333:	b8 18 00 00 00       	mov    $0x18,%eax
    1338:	cd 40                	int    $0x40
    133a:	c3                   	ret    

0000133b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    133b:	55                   	push   %ebp
    133c:	89 e5                	mov    %esp,%ebp
    133e:	83 ec 18             	sub    $0x18,%esp
    1341:	8b 45 0c             	mov    0xc(%ebp),%eax
    1344:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1347:	83 ec 04             	sub    $0x4,%esp
    134a:	6a 01                	push   $0x1
    134c:	8d 45 f4             	lea    -0xc(%ebp),%eax
    134f:	50                   	push   %eax
    1350:	ff 75 08             	pushl  0x8(%ebp)
    1353:	e8 4b ff ff ff       	call   12a3 <write>
    1358:	83 c4 10             	add    $0x10,%esp
}
    135b:	90                   	nop
    135c:	c9                   	leave  
    135d:	c3                   	ret    

0000135e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    135e:	55                   	push   %ebp
    135f:	89 e5                	mov    %esp,%ebp
    1361:	53                   	push   %ebx
    1362:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1365:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    136c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1370:	74 17                	je     1389 <printint+0x2b>
    1372:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1376:	79 11                	jns    1389 <printint+0x2b>
    neg = 1;
    1378:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    137f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1382:	f7 d8                	neg    %eax
    1384:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1387:	eb 06                	jmp    138f <printint+0x31>
  } else {
    x = xx;
    1389:	8b 45 0c             	mov    0xc(%ebp),%eax
    138c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    138f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1396:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1399:	8d 41 01             	lea    0x1(%ecx),%eax
    139c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    139f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13a5:	ba 00 00 00 00       	mov    $0x0,%edx
    13aa:	f7 f3                	div    %ebx
    13ac:	89 d0                	mov    %edx,%eax
    13ae:	0f b6 80 18 1a 00 00 	movzbl 0x1a18(%eax),%eax
    13b5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13bf:	ba 00 00 00 00       	mov    $0x0,%edx
    13c4:	f7 f3                	div    %ebx
    13c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13cd:	75 c7                	jne    1396 <printint+0x38>
  if(neg)
    13cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13d3:	74 2d                	je     1402 <printint+0xa4>
    buf[i++] = '-';
    13d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13d8:	8d 50 01             	lea    0x1(%eax),%edx
    13db:	89 55 f4             	mov    %edx,-0xc(%ebp)
    13de:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    13e3:	eb 1d                	jmp    1402 <printint+0xa4>
    putc(fd, buf[i]);
    13e5:	8d 55 dc             	lea    -0x24(%ebp),%edx
    13e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13eb:	01 d0                	add    %edx,%eax
    13ed:	0f b6 00             	movzbl (%eax),%eax
    13f0:	0f be c0             	movsbl %al,%eax
    13f3:	83 ec 08             	sub    $0x8,%esp
    13f6:	50                   	push   %eax
    13f7:	ff 75 08             	pushl  0x8(%ebp)
    13fa:	e8 3c ff ff ff       	call   133b <putc>
    13ff:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1402:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    140a:	79 d9                	jns    13e5 <printint+0x87>
    putc(fd, buf[i]);
}
    140c:	90                   	nop
    140d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1410:	c9                   	leave  
    1411:	c3                   	ret    

00001412 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1412:	55                   	push   %ebp
    1413:	89 e5                	mov    %esp,%ebp
    1415:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1418:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    141f:	8d 45 0c             	lea    0xc(%ebp),%eax
    1422:	83 c0 04             	add    $0x4,%eax
    1425:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1428:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    142f:	e9 59 01 00 00       	jmp    158d <printf+0x17b>
    c = fmt[i] & 0xff;
    1434:	8b 55 0c             	mov    0xc(%ebp),%edx
    1437:	8b 45 f0             	mov    -0x10(%ebp),%eax
    143a:	01 d0                	add    %edx,%eax
    143c:	0f b6 00             	movzbl (%eax),%eax
    143f:	0f be c0             	movsbl %al,%eax
    1442:	25 ff 00 00 00       	and    $0xff,%eax
    1447:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    144a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    144e:	75 2c                	jne    147c <printf+0x6a>
      if(c == '%'){
    1450:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1454:	75 0c                	jne    1462 <printf+0x50>
        state = '%';
    1456:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    145d:	e9 27 01 00 00       	jmp    1589 <printf+0x177>
      } else {
        putc(fd, c);
    1462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1465:	0f be c0             	movsbl %al,%eax
    1468:	83 ec 08             	sub    $0x8,%esp
    146b:	50                   	push   %eax
    146c:	ff 75 08             	pushl  0x8(%ebp)
    146f:	e8 c7 fe ff ff       	call   133b <putc>
    1474:	83 c4 10             	add    $0x10,%esp
    1477:	e9 0d 01 00 00       	jmp    1589 <printf+0x177>
      }
    } else if(state == '%'){
    147c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1480:	0f 85 03 01 00 00    	jne    1589 <printf+0x177>
      if(c == 'd'){
    1486:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    148a:	75 1e                	jne    14aa <printf+0x98>
        printint(fd, *ap, 10, 1);
    148c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    148f:	8b 00                	mov    (%eax),%eax
    1491:	6a 01                	push   $0x1
    1493:	6a 0a                	push   $0xa
    1495:	50                   	push   %eax
    1496:	ff 75 08             	pushl  0x8(%ebp)
    1499:	e8 c0 fe ff ff       	call   135e <printint>
    149e:	83 c4 10             	add    $0x10,%esp
        ap++;
    14a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14a5:	e9 d8 00 00 00       	jmp    1582 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    14aa:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14ae:	74 06                	je     14b6 <printf+0xa4>
    14b0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14b4:	75 1e                	jne    14d4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    14b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14b9:	8b 00                	mov    (%eax),%eax
    14bb:	6a 00                	push   $0x0
    14bd:	6a 10                	push   $0x10
    14bf:	50                   	push   %eax
    14c0:	ff 75 08             	pushl  0x8(%ebp)
    14c3:	e8 96 fe ff ff       	call   135e <printint>
    14c8:	83 c4 10             	add    $0x10,%esp
        ap++;
    14cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14cf:	e9 ae 00 00 00       	jmp    1582 <printf+0x170>
      } else if(c == 's'){
    14d4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    14d8:	75 43                	jne    151d <printf+0x10b>
        s = (char*)*ap;
    14da:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14dd:	8b 00                	mov    (%eax),%eax
    14df:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    14e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    14e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14ea:	75 25                	jne    1511 <printf+0xff>
          s = "(null)";
    14ec:	c7 45 f4 c8 17 00 00 	movl   $0x17c8,-0xc(%ebp)
        while(*s != 0){
    14f3:	eb 1c                	jmp    1511 <printf+0xff>
          putc(fd, *s);
    14f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f8:	0f b6 00             	movzbl (%eax),%eax
    14fb:	0f be c0             	movsbl %al,%eax
    14fe:	83 ec 08             	sub    $0x8,%esp
    1501:	50                   	push   %eax
    1502:	ff 75 08             	pushl  0x8(%ebp)
    1505:	e8 31 fe ff ff       	call   133b <putc>
    150a:	83 c4 10             	add    $0x10,%esp
          s++;
    150d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1511:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1514:	0f b6 00             	movzbl (%eax),%eax
    1517:	84 c0                	test   %al,%al
    1519:	75 da                	jne    14f5 <printf+0xe3>
    151b:	eb 65                	jmp    1582 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    151d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1521:	75 1d                	jne    1540 <printf+0x12e>
        putc(fd, *ap);
    1523:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1526:	8b 00                	mov    (%eax),%eax
    1528:	0f be c0             	movsbl %al,%eax
    152b:	83 ec 08             	sub    $0x8,%esp
    152e:	50                   	push   %eax
    152f:	ff 75 08             	pushl  0x8(%ebp)
    1532:	e8 04 fe ff ff       	call   133b <putc>
    1537:	83 c4 10             	add    $0x10,%esp
        ap++;
    153a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    153e:	eb 42                	jmp    1582 <printf+0x170>
      } else if(c == '%'){
    1540:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1544:	75 17                	jne    155d <printf+0x14b>
        putc(fd, c);
    1546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1549:	0f be c0             	movsbl %al,%eax
    154c:	83 ec 08             	sub    $0x8,%esp
    154f:	50                   	push   %eax
    1550:	ff 75 08             	pushl  0x8(%ebp)
    1553:	e8 e3 fd ff ff       	call   133b <putc>
    1558:	83 c4 10             	add    $0x10,%esp
    155b:	eb 25                	jmp    1582 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    155d:	83 ec 08             	sub    $0x8,%esp
    1560:	6a 25                	push   $0x25
    1562:	ff 75 08             	pushl  0x8(%ebp)
    1565:	e8 d1 fd ff ff       	call   133b <putc>
    156a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    156d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1570:	0f be c0             	movsbl %al,%eax
    1573:	83 ec 08             	sub    $0x8,%esp
    1576:	50                   	push   %eax
    1577:	ff 75 08             	pushl  0x8(%ebp)
    157a:	e8 bc fd ff ff       	call   133b <putc>
    157f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1582:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1589:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    158d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1590:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1593:	01 d0                	add    %edx,%eax
    1595:	0f b6 00             	movzbl (%eax),%eax
    1598:	84 c0                	test   %al,%al
    159a:	0f 85 94 fe ff ff    	jne    1434 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15a0:	90                   	nop
    15a1:	c9                   	leave  
    15a2:	c3                   	ret    

000015a3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15a3:	55                   	push   %ebp
    15a4:	89 e5                	mov    %esp,%ebp
    15a6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15a9:	8b 45 08             	mov    0x8(%ebp),%eax
    15ac:	83 e8 08             	sub    $0x8,%eax
    15af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15b2:	a1 34 1a 00 00       	mov    0x1a34,%eax
    15b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15ba:	eb 24                	jmp    15e0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15bf:	8b 00                	mov    (%eax),%eax
    15c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15c4:	77 12                	ja     15d8 <free+0x35>
    15c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15cc:	77 24                	ja     15f2 <free+0x4f>
    15ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15d1:	8b 00                	mov    (%eax),%eax
    15d3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15d6:	77 1a                	ja     15f2 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15db:	8b 00                	mov    (%eax),%eax
    15dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15e6:	76 d4                	jbe    15bc <free+0x19>
    15e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15eb:	8b 00                	mov    (%eax),%eax
    15ed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15f0:	76 ca                	jbe    15bc <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    15f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15f5:	8b 40 04             	mov    0x4(%eax),%eax
    15f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    15ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1602:	01 c2                	add    %eax,%edx
    1604:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1607:	8b 00                	mov    (%eax),%eax
    1609:	39 c2                	cmp    %eax,%edx
    160b:	75 24                	jne    1631 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    160d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1610:	8b 50 04             	mov    0x4(%eax),%edx
    1613:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1616:	8b 00                	mov    (%eax),%eax
    1618:	8b 40 04             	mov    0x4(%eax),%eax
    161b:	01 c2                	add    %eax,%edx
    161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1620:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1623:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1626:	8b 00                	mov    (%eax),%eax
    1628:	8b 10                	mov    (%eax),%edx
    162a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    162d:	89 10                	mov    %edx,(%eax)
    162f:	eb 0a                	jmp    163b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1631:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1634:	8b 10                	mov    (%eax),%edx
    1636:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1639:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    163e:	8b 40 04             	mov    0x4(%eax),%eax
    1641:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1648:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164b:	01 d0                	add    %edx,%eax
    164d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1650:	75 20                	jne    1672 <free+0xcf>
    p->s.size += bp->s.size;
    1652:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1655:	8b 50 04             	mov    0x4(%eax),%edx
    1658:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165b:	8b 40 04             	mov    0x4(%eax),%eax
    165e:	01 c2                	add    %eax,%edx
    1660:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1663:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1666:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1669:	8b 10                	mov    (%eax),%edx
    166b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166e:	89 10                	mov    %edx,(%eax)
    1670:	eb 08                	jmp    167a <free+0xd7>
  } else
    p->s.ptr = bp;
    1672:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1675:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1678:	89 10                	mov    %edx,(%eax)
  freep = p;
    167a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167d:	a3 34 1a 00 00       	mov    %eax,0x1a34
}
    1682:	90                   	nop
    1683:	c9                   	leave  
    1684:	c3                   	ret    

00001685 <morecore>:

static Header*
morecore(uint nu)
{
    1685:	55                   	push   %ebp
    1686:	89 e5                	mov    %esp,%ebp
    1688:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    168b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1692:	77 07                	ja     169b <morecore+0x16>
    nu = 4096;
    1694:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    169b:	8b 45 08             	mov    0x8(%ebp),%eax
    169e:	c1 e0 03             	shl    $0x3,%eax
    16a1:	83 ec 0c             	sub    $0xc,%esp
    16a4:	50                   	push   %eax
    16a5:	e8 61 fc ff ff       	call   130b <sbrk>
    16aa:	83 c4 10             	add    $0x10,%esp
    16ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16b0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16b4:	75 07                	jne    16bd <morecore+0x38>
    return 0;
    16b6:	b8 00 00 00 00       	mov    $0x0,%eax
    16bb:	eb 26                	jmp    16e3 <morecore+0x5e>
  hp = (Header*)p;
    16bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    16c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16c6:	8b 55 08             	mov    0x8(%ebp),%edx
    16c9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    16cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16cf:	83 c0 08             	add    $0x8,%eax
    16d2:	83 ec 0c             	sub    $0xc,%esp
    16d5:	50                   	push   %eax
    16d6:	e8 c8 fe ff ff       	call   15a3 <free>
    16db:	83 c4 10             	add    $0x10,%esp
  return freep;
    16de:	a1 34 1a 00 00       	mov    0x1a34,%eax
}
    16e3:	c9                   	leave  
    16e4:	c3                   	ret    

000016e5 <malloc>:

void*
malloc(uint nbytes)
{
    16e5:	55                   	push   %ebp
    16e6:	89 e5                	mov    %esp,%ebp
    16e8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16eb:	8b 45 08             	mov    0x8(%ebp),%eax
    16ee:	83 c0 07             	add    $0x7,%eax
    16f1:	c1 e8 03             	shr    $0x3,%eax
    16f4:	83 c0 01             	add    $0x1,%eax
    16f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    16fa:	a1 34 1a 00 00       	mov    0x1a34,%eax
    16ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1702:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1706:	75 23                	jne    172b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1708:	c7 45 f0 2c 1a 00 00 	movl   $0x1a2c,-0x10(%ebp)
    170f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1712:	a3 34 1a 00 00       	mov    %eax,0x1a34
    1717:	a1 34 1a 00 00       	mov    0x1a34,%eax
    171c:	a3 2c 1a 00 00       	mov    %eax,0x1a2c
    base.s.size = 0;
    1721:	c7 05 30 1a 00 00 00 	movl   $0x0,0x1a30
    1728:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    172b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    172e:	8b 00                	mov    (%eax),%eax
    1730:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1733:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1736:	8b 40 04             	mov    0x4(%eax),%eax
    1739:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    173c:	72 4d                	jb     178b <malloc+0xa6>
      if(p->s.size == nunits)
    173e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1741:	8b 40 04             	mov    0x4(%eax),%eax
    1744:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1747:	75 0c                	jne    1755 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1749:	8b 45 f4             	mov    -0xc(%ebp),%eax
    174c:	8b 10                	mov    (%eax),%edx
    174e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1751:	89 10                	mov    %edx,(%eax)
    1753:	eb 26                	jmp    177b <malloc+0x96>
      else {
        p->s.size -= nunits;
    1755:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1758:	8b 40 04             	mov    0x4(%eax),%eax
    175b:	2b 45 ec             	sub    -0x14(%ebp),%eax
    175e:	89 c2                	mov    %eax,%edx
    1760:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1763:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1766:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1769:	8b 40 04             	mov    0x4(%eax),%eax
    176c:	c1 e0 03             	shl    $0x3,%eax
    176f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1772:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1775:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1778:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    177b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    177e:	a3 34 1a 00 00       	mov    %eax,0x1a34
      return (void*)(p + 1);
    1783:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1786:	83 c0 08             	add    $0x8,%eax
    1789:	eb 3b                	jmp    17c6 <malloc+0xe1>
    }
    if(p == freep)
    178b:	a1 34 1a 00 00       	mov    0x1a34,%eax
    1790:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1793:	75 1e                	jne    17b3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    1795:	83 ec 0c             	sub    $0xc,%esp
    1798:	ff 75 ec             	pushl  -0x14(%ebp)
    179b:	e8 e5 fe ff ff       	call   1685 <morecore>
    17a0:	83 c4 10             	add    $0x10,%esp
    17a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17aa:	75 07                	jne    17b3 <malloc+0xce>
        return 0;
    17ac:	b8 00 00 00 00       	mov    $0x0,%eax
    17b1:	eb 13                	jmp    17c6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bc:	8b 00                	mov    (%eax),%eax
    17be:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    17c1:	e9 6d ff ff ff       	jmp    1733 <malloc+0x4e>
}
    17c6:	c9                   	leave  
    17c7:	c3                   	ret    
