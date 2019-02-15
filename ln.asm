
_ln:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	53                   	push   %ebx
    100e:	51                   	push   %ecx
    100f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
    1011:	83 3b 03             	cmpl   $0x3,(%ebx)
    1014:	74 17                	je     102d <main+0x2d>
    printf(2, "Usage: ln old new\n");
    1016:	83 ec 08             	sub    $0x8,%esp
    1019:	68 10 18 00 00       	push   $0x1810
    101e:	6a 02                	push   $0x2
    1020:	e8 35 04 00 00       	call   145a <printf>
    1025:	83 c4 10             	add    $0x10,%esp
    exit();
    1028:	e8 9e 02 00 00       	call   12cb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
    102d:	8b 43 04             	mov    0x4(%ebx),%eax
    1030:	83 c0 08             	add    $0x8,%eax
    1033:	8b 10                	mov    (%eax),%edx
    1035:	8b 43 04             	mov    0x4(%ebx),%eax
    1038:	83 c0 04             	add    $0x4,%eax
    103b:	8b 00                	mov    (%eax),%eax
    103d:	83 ec 08             	sub    $0x8,%esp
    1040:	52                   	push   %edx
    1041:	50                   	push   %eax
    1042:	e8 e4 02 00 00       	call   132b <link>
    1047:	83 c4 10             	add    $0x10,%esp
    104a:	85 c0                	test   %eax,%eax
    104c:	79 21                	jns    106f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
    104e:	8b 43 04             	mov    0x4(%ebx),%eax
    1051:	83 c0 08             	add    $0x8,%eax
    1054:	8b 10                	mov    (%eax),%edx
    1056:	8b 43 04             	mov    0x4(%ebx),%eax
    1059:	83 c0 04             	add    $0x4,%eax
    105c:	8b 00                	mov    (%eax),%eax
    105e:	52                   	push   %edx
    105f:	50                   	push   %eax
    1060:	68 23 18 00 00       	push   $0x1823
    1065:	6a 02                	push   $0x2
    1067:	e8 ee 03 00 00       	call   145a <printf>
    106c:	83 c4 10             	add    $0x10,%esp
  exit();
    106f:	e8 57 02 00 00       	call   12cb <exit>

00001074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1074:	55                   	push   %ebp
    1075:	89 e5                	mov    %esp,%ebp
    1077:	57                   	push   %edi
    1078:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1079:	8b 4d 08             	mov    0x8(%ebp),%ecx
    107c:	8b 55 10             	mov    0x10(%ebp),%edx
    107f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1082:	89 cb                	mov    %ecx,%ebx
    1084:	89 df                	mov    %ebx,%edi
    1086:	89 d1                	mov    %edx,%ecx
    1088:	fc                   	cld    
    1089:	f3 aa                	rep stos %al,%es:(%edi)
    108b:	89 ca                	mov    %ecx,%edx
    108d:	89 fb                	mov    %edi,%ebx
    108f:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1092:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1095:	90                   	nop
    1096:	5b                   	pop    %ebx
    1097:	5f                   	pop    %edi
    1098:	5d                   	pop    %ebp
    1099:	c3                   	ret    

0000109a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    109a:	55                   	push   %ebp
    109b:	89 e5                	mov    %esp,%ebp
    109d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10a0:	8b 45 08             	mov    0x8(%ebp),%eax
    10a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10a6:	90                   	nop
    10a7:	8b 45 08             	mov    0x8(%ebp),%eax
    10aa:	8d 50 01             	lea    0x1(%eax),%edx
    10ad:	89 55 08             	mov    %edx,0x8(%ebp)
    10b0:	8b 55 0c             	mov    0xc(%ebp),%edx
    10b3:	8d 4a 01             	lea    0x1(%edx),%ecx
    10b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10b9:	0f b6 12             	movzbl (%edx),%edx
    10bc:	88 10                	mov    %dl,(%eax)
    10be:	0f b6 00             	movzbl (%eax),%eax
    10c1:	84 c0                	test   %al,%al
    10c3:	75 e2                	jne    10a7 <strcpy+0xd>
    ;
  return os;
    10c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10c8:	c9                   	leave  
    10c9:	c3                   	ret    

000010ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10ca:	55                   	push   %ebp
    10cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10cd:	eb 08                	jmp    10d7 <strcmp+0xd>
    p++, q++;
    10cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10d7:	8b 45 08             	mov    0x8(%ebp),%eax
    10da:	0f b6 00             	movzbl (%eax),%eax
    10dd:	84 c0                	test   %al,%al
    10df:	74 10                	je     10f1 <strcmp+0x27>
    10e1:	8b 45 08             	mov    0x8(%ebp),%eax
    10e4:	0f b6 10             	movzbl (%eax),%edx
    10e7:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ea:	0f b6 00             	movzbl (%eax),%eax
    10ed:	38 c2                	cmp    %al,%dl
    10ef:	74 de                	je     10cf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10f1:	8b 45 08             	mov    0x8(%ebp),%eax
    10f4:	0f b6 00             	movzbl (%eax),%eax
    10f7:	0f b6 d0             	movzbl %al,%edx
    10fa:	8b 45 0c             	mov    0xc(%ebp),%eax
    10fd:	0f b6 00             	movzbl (%eax),%eax
    1100:	0f b6 c0             	movzbl %al,%eax
    1103:	29 c2                	sub    %eax,%edx
    1105:	89 d0                	mov    %edx,%eax
}
    1107:	5d                   	pop    %ebp
    1108:	c3                   	ret    

00001109 <strlen>:

uint
strlen(const char *s)
{
    1109:	55                   	push   %ebp
    110a:	89 e5                	mov    %esp,%ebp
    110c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    110f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1116:	eb 04                	jmp    111c <strlen+0x13>
    1118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    111c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    111f:	8b 45 08             	mov    0x8(%ebp),%eax
    1122:	01 d0                	add    %edx,%eax
    1124:	0f b6 00             	movzbl (%eax),%eax
    1127:	84 c0                	test   %al,%al
    1129:	75 ed                	jne    1118 <strlen+0xf>
    ;
  return n;
    112b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    112e:	c9                   	leave  
    112f:	c3                   	ret    

00001130 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1130:	55                   	push   %ebp
    1131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    1133:	8b 45 10             	mov    0x10(%ebp),%eax
    1136:	50                   	push   %eax
    1137:	ff 75 0c             	pushl  0xc(%ebp)
    113a:	ff 75 08             	pushl  0x8(%ebp)
    113d:	e8 32 ff ff ff       	call   1074 <stosb>
    1142:	83 c4 0c             	add    $0xc,%esp
  return dst;
    1145:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1148:	c9                   	leave  
    1149:	c3                   	ret    

0000114a <strchr>:

char*
strchr(const char *s, char c)
{
    114a:	55                   	push   %ebp
    114b:	89 e5                	mov    %esp,%ebp
    114d:	83 ec 04             	sub    $0x4,%esp
    1150:	8b 45 0c             	mov    0xc(%ebp),%eax
    1153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1156:	eb 14                	jmp    116c <strchr+0x22>
    if(*s == c)
    1158:	8b 45 08             	mov    0x8(%ebp),%eax
    115b:	0f b6 00             	movzbl (%eax),%eax
    115e:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1161:	75 05                	jne    1168 <strchr+0x1e>
      return (char*)s;
    1163:	8b 45 08             	mov    0x8(%ebp),%eax
    1166:	eb 13                	jmp    117b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116c:	8b 45 08             	mov    0x8(%ebp),%eax
    116f:	0f b6 00             	movzbl (%eax),%eax
    1172:	84 c0                	test   %al,%al
    1174:	75 e2                	jne    1158 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1176:	b8 00 00 00 00       	mov    $0x0,%eax
}
    117b:	c9                   	leave  
    117c:	c3                   	ret    

0000117d <gets>:

char*
gets(char *buf, int max)
{
    117d:	55                   	push   %ebp
    117e:	89 e5                	mov    %esp,%ebp
    1180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    118a:	eb 42                	jmp    11ce <gets+0x51>
    cc = read(0, &c, 1);
    118c:	83 ec 04             	sub    $0x4,%esp
    118f:	6a 01                	push   $0x1
    1191:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1194:	50                   	push   %eax
    1195:	6a 00                	push   $0x0
    1197:	e8 47 01 00 00       	call   12e3 <read>
    119c:	83 c4 10             	add    $0x10,%esp
    119f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11a6:	7e 33                	jle    11db <gets+0x5e>
      break;
    buf[i++] = c;
    11a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ab:	8d 50 01             	lea    0x1(%eax),%edx
    11ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11b1:	89 c2                	mov    %eax,%edx
    11b3:	8b 45 08             	mov    0x8(%ebp),%eax
    11b6:	01 c2                	add    %eax,%edx
    11b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c2:	3c 0a                	cmp    $0xa,%al
    11c4:	74 16                	je     11dc <gets+0x5f>
    11c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11ca:	3c 0d                	cmp    $0xd,%al
    11cc:	74 0e                	je     11dc <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d1:	83 c0 01             	add    $0x1,%eax
    11d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11d7:	7c b3                	jl     118c <gets+0xf>
    11d9:	eb 01                	jmp    11dc <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    11db:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11df:	8b 45 08             	mov    0x8(%ebp),%eax
    11e2:	01 d0                	add    %edx,%eax
    11e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ea:	c9                   	leave  
    11eb:	c3                   	ret    

000011ec <stat>:

int
stat(const char *n, struct stat *st)
{
    11ec:	55                   	push   %ebp
    11ed:	89 e5                	mov    %esp,%ebp
    11ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11f2:	83 ec 08             	sub    $0x8,%esp
    11f5:	6a 00                	push   $0x0
    11f7:	ff 75 08             	pushl  0x8(%ebp)
    11fa:	e8 0c 01 00 00       	call   130b <open>
    11ff:	83 c4 10             	add    $0x10,%esp
    1202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1209:	79 07                	jns    1212 <stat+0x26>
    return -1;
    120b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1210:	eb 25                	jmp    1237 <stat+0x4b>
  r = fstat(fd, st);
    1212:	83 ec 08             	sub    $0x8,%esp
    1215:	ff 75 0c             	pushl  0xc(%ebp)
    1218:	ff 75 f4             	pushl  -0xc(%ebp)
    121b:	e8 03 01 00 00       	call   1323 <fstat>
    1220:	83 c4 10             	add    $0x10,%esp
    1223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1226:	83 ec 0c             	sub    $0xc,%esp
    1229:	ff 75 f4             	pushl  -0xc(%ebp)
    122c:	e8 c2 00 00 00       	call   12f3 <close>
    1231:	83 c4 10             	add    $0x10,%esp
  return r;
    1234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1237:	c9                   	leave  
    1238:	c3                   	ret    

00001239 <atoi>:

int
atoi(const char *s)
{
    1239:	55                   	push   %ebp
    123a:	89 e5                	mov    %esp,%ebp
    123c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    123f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1246:	eb 25                	jmp    126d <atoi+0x34>
    n = n*10 + *s++ - '0';
    1248:	8b 55 fc             	mov    -0x4(%ebp),%edx
    124b:	89 d0                	mov    %edx,%eax
    124d:	c1 e0 02             	shl    $0x2,%eax
    1250:	01 d0                	add    %edx,%eax
    1252:	01 c0                	add    %eax,%eax
    1254:	89 c1                	mov    %eax,%ecx
    1256:	8b 45 08             	mov    0x8(%ebp),%eax
    1259:	8d 50 01             	lea    0x1(%eax),%edx
    125c:	89 55 08             	mov    %edx,0x8(%ebp)
    125f:	0f b6 00             	movzbl (%eax),%eax
    1262:	0f be c0             	movsbl %al,%eax
    1265:	01 c8                	add    %ecx,%eax
    1267:	83 e8 30             	sub    $0x30,%eax
    126a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    126d:	8b 45 08             	mov    0x8(%ebp),%eax
    1270:	0f b6 00             	movzbl (%eax),%eax
    1273:	3c 2f                	cmp    $0x2f,%al
    1275:	7e 0a                	jle    1281 <atoi+0x48>
    1277:	8b 45 08             	mov    0x8(%ebp),%eax
    127a:	0f b6 00             	movzbl (%eax),%eax
    127d:	3c 39                	cmp    $0x39,%al
    127f:	7e c7                	jle    1248 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1284:	c9                   	leave  
    1285:	c3                   	ret    

00001286 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1286:	55                   	push   %ebp
    1287:	89 e5                	mov    %esp,%ebp
    1289:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    128c:	8b 45 08             	mov    0x8(%ebp),%eax
    128f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1292:	8b 45 0c             	mov    0xc(%ebp),%eax
    1295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1298:	eb 17                	jmp    12b1 <memmove+0x2b>
    *dst++ = *src++;
    129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    129d:	8d 50 01             	lea    0x1(%eax),%edx
    12a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12a6:	8d 4a 01             	lea    0x1(%edx),%ecx
    12a9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12ac:	0f b6 12             	movzbl (%edx),%edx
    12af:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12b1:	8b 45 10             	mov    0x10(%ebp),%eax
    12b4:	8d 50 ff             	lea    -0x1(%eax),%edx
    12b7:	89 55 10             	mov    %edx,0x10(%ebp)
    12ba:	85 c0                	test   %eax,%eax
    12bc:	7f dc                	jg     129a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12be:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12c1:	c9                   	leave  
    12c2:	c3                   	ret    

000012c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12c3:	b8 01 00 00 00       	mov    $0x1,%eax
    12c8:	cd 40                	int    $0x40
    12ca:	c3                   	ret    

000012cb <exit>:
SYSCALL(exit)
    12cb:	b8 02 00 00 00       	mov    $0x2,%eax
    12d0:	cd 40                	int    $0x40
    12d2:	c3                   	ret    

000012d3 <wait>:
SYSCALL(wait)
    12d3:	b8 03 00 00 00       	mov    $0x3,%eax
    12d8:	cd 40                	int    $0x40
    12da:	c3                   	ret    

000012db <pipe>:
SYSCALL(pipe)
    12db:	b8 04 00 00 00       	mov    $0x4,%eax
    12e0:	cd 40                	int    $0x40
    12e2:	c3                   	ret    

000012e3 <read>:
SYSCALL(read)
    12e3:	b8 05 00 00 00       	mov    $0x5,%eax
    12e8:	cd 40                	int    $0x40
    12ea:	c3                   	ret    

000012eb <write>:
SYSCALL(write)
    12eb:	b8 10 00 00 00       	mov    $0x10,%eax
    12f0:	cd 40                	int    $0x40
    12f2:	c3                   	ret    

000012f3 <close>:
SYSCALL(close)
    12f3:	b8 15 00 00 00       	mov    $0x15,%eax
    12f8:	cd 40                	int    $0x40
    12fa:	c3                   	ret    

000012fb <kill>:
SYSCALL(kill)
    12fb:	b8 06 00 00 00       	mov    $0x6,%eax
    1300:	cd 40                	int    $0x40
    1302:	c3                   	ret    

00001303 <exec>:
SYSCALL(exec)
    1303:	b8 07 00 00 00       	mov    $0x7,%eax
    1308:	cd 40                	int    $0x40
    130a:	c3                   	ret    

0000130b <open>:
SYSCALL(open)
    130b:	b8 0f 00 00 00       	mov    $0xf,%eax
    1310:	cd 40                	int    $0x40
    1312:	c3                   	ret    

00001313 <mknod>:
SYSCALL(mknod)
    1313:	b8 11 00 00 00       	mov    $0x11,%eax
    1318:	cd 40                	int    $0x40
    131a:	c3                   	ret    

0000131b <unlink>:
SYSCALL(unlink)
    131b:	b8 12 00 00 00       	mov    $0x12,%eax
    1320:	cd 40                	int    $0x40
    1322:	c3                   	ret    

00001323 <fstat>:
SYSCALL(fstat)
    1323:	b8 08 00 00 00       	mov    $0x8,%eax
    1328:	cd 40                	int    $0x40
    132a:	c3                   	ret    

0000132b <link>:
SYSCALL(link)
    132b:	b8 13 00 00 00       	mov    $0x13,%eax
    1330:	cd 40                	int    $0x40
    1332:	c3                   	ret    

00001333 <mkdir>:
SYSCALL(mkdir)
    1333:	b8 14 00 00 00       	mov    $0x14,%eax
    1338:	cd 40                	int    $0x40
    133a:	c3                   	ret    

0000133b <chdir>:
SYSCALL(chdir)
    133b:	b8 09 00 00 00       	mov    $0x9,%eax
    1340:	cd 40                	int    $0x40
    1342:	c3                   	ret    

00001343 <dup>:
SYSCALL(dup)
    1343:	b8 0a 00 00 00       	mov    $0xa,%eax
    1348:	cd 40                	int    $0x40
    134a:	c3                   	ret    

0000134b <getpid>:
SYSCALL(getpid)
    134b:	b8 0b 00 00 00       	mov    $0xb,%eax
    1350:	cd 40                	int    $0x40
    1352:	c3                   	ret    

00001353 <sbrk>:
SYSCALL(sbrk)
    1353:	b8 0c 00 00 00       	mov    $0xc,%eax
    1358:	cd 40                	int    $0x40
    135a:	c3                   	ret    

0000135b <sleep>:
SYSCALL(sleep)
    135b:	b8 0d 00 00 00       	mov    $0xd,%eax
    1360:	cd 40                	int    $0x40
    1362:	c3                   	ret    

00001363 <uptime>:
SYSCALL(uptime)
    1363:	b8 0e 00 00 00       	mov    $0xe,%eax
    1368:	cd 40                	int    $0x40
    136a:	c3                   	ret    

0000136b <getprocsinfo>:
SYSCALL(getprocsinfo)
    136b:	b8 16 00 00 00       	mov    $0x16,%eax
    1370:	cd 40                	int    $0x40
    1372:	c3                   	ret    

00001373 <shmem_access>:
SYSCALL(shmem_access)
    1373:	b8 17 00 00 00       	mov    $0x17,%eax
    1378:	cd 40                	int    $0x40
    137a:	c3                   	ret    

0000137b <shmem_count>:
SYSCALL(shmem_count)
    137b:	b8 18 00 00 00       	mov    $0x18,%eax
    1380:	cd 40                	int    $0x40
    1382:	c3                   	ret    

00001383 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1383:	55                   	push   %ebp
    1384:	89 e5                	mov    %esp,%ebp
    1386:	83 ec 18             	sub    $0x18,%esp
    1389:	8b 45 0c             	mov    0xc(%ebp),%eax
    138c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    138f:	83 ec 04             	sub    $0x4,%esp
    1392:	6a 01                	push   $0x1
    1394:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1397:	50                   	push   %eax
    1398:	ff 75 08             	pushl  0x8(%ebp)
    139b:	e8 4b ff ff ff       	call   12eb <write>
    13a0:	83 c4 10             	add    $0x10,%esp
}
    13a3:	90                   	nop
    13a4:	c9                   	leave  
    13a5:	c3                   	ret    

000013a6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13a6:	55                   	push   %ebp
    13a7:	89 e5                	mov    %esp,%ebp
    13a9:	53                   	push   %ebx
    13aa:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13b4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13b8:	74 17                	je     13d1 <printint+0x2b>
    13ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13be:	79 11                	jns    13d1 <printint+0x2b>
    neg = 1;
    13c0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ca:	f7 d8                	neg    %eax
    13cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13cf:	eb 06                	jmp    13d7 <printint+0x31>
  } else {
    x = xx;
    13d1:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13de:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13e1:	8d 41 01             	lea    0x1(%ecx),%eax
    13e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13ed:	ba 00 00 00 00       	mov    $0x0,%edx
    13f2:	f7 f3                	div    %ebx
    13f4:	89 d0                	mov    %edx,%eax
    13f6:	0f b6 80 8c 1a 00 00 	movzbl 0x1a8c(%eax),%eax
    13fd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1401:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1404:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1407:	ba 00 00 00 00       	mov    $0x0,%edx
    140c:	f7 f3                	div    %ebx
    140e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1411:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1415:	75 c7                	jne    13de <printint+0x38>
  if(neg)
    1417:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    141b:	74 2d                	je     144a <printint+0xa4>
    buf[i++] = '-';
    141d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1420:	8d 50 01             	lea    0x1(%eax),%edx
    1423:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1426:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    142b:	eb 1d                	jmp    144a <printint+0xa4>
    putc(fd, buf[i]);
    142d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1430:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1433:	01 d0                	add    %edx,%eax
    1435:	0f b6 00             	movzbl (%eax),%eax
    1438:	0f be c0             	movsbl %al,%eax
    143b:	83 ec 08             	sub    $0x8,%esp
    143e:	50                   	push   %eax
    143f:	ff 75 08             	pushl  0x8(%ebp)
    1442:	e8 3c ff ff ff       	call   1383 <putc>
    1447:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    144a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    144e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1452:	79 d9                	jns    142d <printint+0x87>
    putc(fd, buf[i]);
}
    1454:	90                   	nop
    1455:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1458:	c9                   	leave  
    1459:	c3                   	ret    

0000145a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    145a:	55                   	push   %ebp
    145b:	89 e5                	mov    %esp,%ebp
    145d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1460:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1467:	8d 45 0c             	lea    0xc(%ebp),%eax
    146a:	83 c0 04             	add    $0x4,%eax
    146d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1470:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1477:	e9 59 01 00 00       	jmp    15d5 <printf+0x17b>
    c = fmt[i] & 0xff;
    147c:	8b 55 0c             	mov    0xc(%ebp),%edx
    147f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1482:	01 d0                	add    %edx,%eax
    1484:	0f b6 00             	movzbl (%eax),%eax
    1487:	0f be c0             	movsbl %al,%eax
    148a:	25 ff 00 00 00       	and    $0xff,%eax
    148f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1492:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1496:	75 2c                	jne    14c4 <printf+0x6a>
      if(c == '%'){
    1498:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    149c:	75 0c                	jne    14aa <printf+0x50>
        state = '%';
    149e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14a5:	e9 27 01 00 00       	jmp    15d1 <printf+0x177>
      } else {
        putc(fd, c);
    14aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14ad:	0f be c0             	movsbl %al,%eax
    14b0:	83 ec 08             	sub    $0x8,%esp
    14b3:	50                   	push   %eax
    14b4:	ff 75 08             	pushl  0x8(%ebp)
    14b7:	e8 c7 fe ff ff       	call   1383 <putc>
    14bc:	83 c4 10             	add    $0x10,%esp
    14bf:	e9 0d 01 00 00       	jmp    15d1 <printf+0x177>
      }
    } else if(state == '%'){
    14c4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14c8:	0f 85 03 01 00 00    	jne    15d1 <printf+0x177>
      if(c == 'd'){
    14ce:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14d2:	75 1e                	jne    14f2 <printf+0x98>
        printint(fd, *ap, 10, 1);
    14d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14d7:	8b 00                	mov    (%eax),%eax
    14d9:	6a 01                	push   $0x1
    14db:	6a 0a                	push   $0xa
    14dd:	50                   	push   %eax
    14de:	ff 75 08             	pushl  0x8(%ebp)
    14e1:	e8 c0 fe ff ff       	call   13a6 <printint>
    14e6:	83 c4 10             	add    $0x10,%esp
        ap++;
    14e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14ed:	e9 d8 00 00 00       	jmp    15ca <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    14f2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14f6:	74 06                	je     14fe <printf+0xa4>
    14f8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14fc:	75 1e                	jne    151c <printf+0xc2>
        printint(fd, *ap, 16, 0);
    14fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1501:	8b 00                	mov    (%eax),%eax
    1503:	6a 00                	push   $0x0
    1505:	6a 10                	push   $0x10
    1507:	50                   	push   %eax
    1508:	ff 75 08             	pushl  0x8(%ebp)
    150b:	e8 96 fe ff ff       	call   13a6 <printint>
    1510:	83 c4 10             	add    $0x10,%esp
        ap++;
    1513:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1517:	e9 ae 00 00 00       	jmp    15ca <printf+0x170>
      } else if(c == 's'){
    151c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1520:	75 43                	jne    1565 <printf+0x10b>
        s = (char*)*ap;
    1522:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1525:	8b 00                	mov    (%eax),%eax
    1527:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    152a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    152e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1532:	75 25                	jne    1559 <printf+0xff>
          s = "(null)";
    1534:	c7 45 f4 37 18 00 00 	movl   $0x1837,-0xc(%ebp)
        while(*s != 0){
    153b:	eb 1c                	jmp    1559 <printf+0xff>
          putc(fd, *s);
    153d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1540:	0f b6 00             	movzbl (%eax),%eax
    1543:	0f be c0             	movsbl %al,%eax
    1546:	83 ec 08             	sub    $0x8,%esp
    1549:	50                   	push   %eax
    154a:	ff 75 08             	pushl  0x8(%ebp)
    154d:	e8 31 fe ff ff       	call   1383 <putc>
    1552:	83 c4 10             	add    $0x10,%esp
          s++;
    1555:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1559:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155c:	0f b6 00             	movzbl (%eax),%eax
    155f:	84 c0                	test   %al,%al
    1561:	75 da                	jne    153d <printf+0xe3>
    1563:	eb 65                	jmp    15ca <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1565:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1569:	75 1d                	jne    1588 <printf+0x12e>
        putc(fd, *ap);
    156b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    156e:	8b 00                	mov    (%eax),%eax
    1570:	0f be c0             	movsbl %al,%eax
    1573:	83 ec 08             	sub    $0x8,%esp
    1576:	50                   	push   %eax
    1577:	ff 75 08             	pushl  0x8(%ebp)
    157a:	e8 04 fe ff ff       	call   1383 <putc>
    157f:	83 c4 10             	add    $0x10,%esp
        ap++;
    1582:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1586:	eb 42                	jmp    15ca <printf+0x170>
      } else if(c == '%'){
    1588:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    158c:	75 17                	jne    15a5 <printf+0x14b>
        putc(fd, c);
    158e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1591:	0f be c0             	movsbl %al,%eax
    1594:	83 ec 08             	sub    $0x8,%esp
    1597:	50                   	push   %eax
    1598:	ff 75 08             	pushl  0x8(%ebp)
    159b:	e8 e3 fd ff ff       	call   1383 <putc>
    15a0:	83 c4 10             	add    $0x10,%esp
    15a3:	eb 25                	jmp    15ca <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15a5:	83 ec 08             	sub    $0x8,%esp
    15a8:	6a 25                	push   $0x25
    15aa:	ff 75 08             	pushl  0x8(%ebp)
    15ad:	e8 d1 fd ff ff       	call   1383 <putc>
    15b2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    15b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15b8:	0f be c0             	movsbl %al,%eax
    15bb:	83 ec 08             	sub    $0x8,%esp
    15be:	50                   	push   %eax
    15bf:	ff 75 08             	pushl  0x8(%ebp)
    15c2:	e8 bc fd ff ff       	call   1383 <putc>
    15c7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    15ca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15d1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15d5:	8b 55 0c             	mov    0xc(%ebp),%edx
    15d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15db:	01 d0                	add    %edx,%eax
    15dd:	0f b6 00             	movzbl (%eax),%eax
    15e0:	84 c0                	test   %al,%al
    15e2:	0f 85 94 fe ff ff    	jne    147c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15e8:	90                   	nop
    15e9:	c9                   	leave  
    15ea:	c3                   	ret    

000015eb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15eb:	55                   	push   %ebp
    15ec:	89 e5                	mov    %esp,%ebp
    15ee:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15f1:	8b 45 08             	mov    0x8(%ebp),%eax
    15f4:	83 e8 08             	sub    $0x8,%eax
    15f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15fa:	a1 a8 1a 00 00       	mov    0x1aa8,%eax
    15ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1602:	eb 24                	jmp    1628 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1604:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1607:	8b 00                	mov    (%eax),%eax
    1609:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    160c:	77 12                	ja     1620 <free+0x35>
    160e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1611:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1614:	77 24                	ja     163a <free+0x4f>
    1616:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1619:	8b 00                	mov    (%eax),%eax
    161b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    161e:	77 1a                	ja     163a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1620:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1623:	8b 00                	mov    (%eax),%eax
    1625:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1628:	8b 45 f8             	mov    -0x8(%ebp),%eax
    162b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    162e:	76 d4                	jbe    1604 <free+0x19>
    1630:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1633:	8b 00                	mov    (%eax),%eax
    1635:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1638:	76 ca                	jbe    1604 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    163a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    163d:	8b 40 04             	mov    0x4(%eax),%eax
    1640:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1647:	8b 45 f8             	mov    -0x8(%ebp),%eax
    164a:	01 c2                	add    %eax,%edx
    164c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164f:	8b 00                	mov    (%eax),%eax
    1651:	39 c2                	cmp    %eax,%edx
    1653:	75 24                	jne    1679 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1655:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1658:	8b 50 04             	mov    0x4(%eax),%edx
    165b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    165e:	8b 00                	mov    (%eax),%eax
    1660:	8b 40 04             	mov    0x4(%eax),%eax
    1663:	01 c2                	add    %eax,%edx
    1665:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1668:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    166b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166e:	8b 00                	mov    (%eax),%eax
    1670:	8b 10                	mov    (%eax),%edx
    1672:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1675:	89 10                	mov    %edx,(%eax)
    1677:	eb 0a                	jmp    1683 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1679:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167c:	8b 10                	mov    (%eax),%edx
    167e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1681:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1683:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1686:	8b 40 04             	mov    0x4(%eax),%eax
    1689:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1690:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1693:	01 d0                	add    %edx,%eax
    1695:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1698:	75 20                	jne    16ba <free+0xcf>
    p->s.size += bp->s.size;
    169a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169d:	8b 50 04             	mov    0x4(%eax),%edx
    16a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a3:	8b 40 04             	mov    0x4(%eax),%eax
    16a6:	01 c2                	add    %eax,%edx
    16a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ab:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b1:	8b 10                	mov    (%eax),%edx
    16b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b6:	89 10                	mov    %edx,(%eax)
    16b8:	eb 08                	jmp    16c2 <free+0xd7>
  } else
    p->s.ptr = bp;
    16ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16c0:	89 10                	mov    %edx,(%eax)
  freep = p;
    16c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c5:	a3 a8 1a 00 00       	mov    %eax,0x1aa8
}
    16ca:	90                   	nop
    16cb:	c9                   	leave  
    16cc:	c3                   	ret    

000016cd <morecore>:

static Header*
morecore(uint nu)
{
    16cd:	55                   	push   %ebp
    16ce:	89 e5                	mov    %esp,%ebp
    16d0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16d3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16da:	77 07                	ja     16e3 <morecore+0x16>
    nu = 4096;
    16dc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16e3:	8b 45 08             	mov    0x8(%ebp),%eax
    16e6:	c1 e0 03             	shl    $0x3,%eax
    16e9:	83 ec 0c             	sub    $0xc,%esp
    16ec:	50                   	push   %eax
    16ed:	e8 61 fc ff ff       	call   1353 <sbrk>
    16f2:	83 c4 10             	add    $0x10,%esp
    16f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16f8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16fc:	75 07                	jne    1705 <morecore+0x38>
    return 0;
    16fe:	b8 00 00 00 00       	mov    $0x0,%eax
    1703:	eb 26                	jmp    172b <morecore+0x5e>
  hp = (Header*)p;
    1705:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1708:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    170b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    170e:	8b 55 08             	mov    0x8(%ebp),%edx
    1711:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1714:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1717:	83 c0 08             	add    $0x8,%eax
    171a:	83 ec 0c             	sub    $0xc,%esp
    171d:	50                   	push   %eax
    171e:	e8 c8 fe ff ff       	call   15eb <free>
    1723:	83 c4 10             	add    $0x10,%esp
  return freep;
    1726:	a1 a8 1a 00 00       	mov    0x1aa8,%eax
}
    172b:	c9                   	leave  
    172c:	c3                   	ret    

0000172d <malloc>:

void*
malloc(uint nbytes)
{
    172d:	55                   	push   %ebp
    172e:	89 e5                	mov    %esp,%ebp
    1730:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1733:	8b 45 08             	mov    0x8(%ebp),%eax
    1736:	83 c0 07             	add    $0x7,%eax
    1739:	c1 e8 03             	shr    $0x3,%eax
    173c:	83 c0 01             	add    $0x1,%eax
    173f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1742:	a1 a8 1a 00 00       	mov    0x1aa8,%eax
    1747:	89 45 f0             	mov    %eax,-0x10(%ebp)
    174a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    174e:	75 23                	jne    1773 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1750:	c7 45 f0 a0 1a 00 00 	movl   $0x1aa0,-0x10(%ebp)
    1757:	8b 45 f0             	mov    -0x10(%ebp),%eax
    175a:	a3 a8 1a 00 00       	mov    %eax,0x1aa8
    175f:	a1 a8 1a 00 00       	mov    0x1aa8,%eax
    1764:	a3 a0 1a 00 00       	mov    %eax,0x1aa0
    base.s.size = 0;
    1769:	c7 05 a4 1a 00 00 00 	movl   $0x0,0x1aa4
    1770:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1773:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1776:	8b 00                	mov    (%eax),%eax
    1778:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    177b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    177e:	8b 40 04             	mov    0x4(%eax),%eax
    1781:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1784:	72 4d                	jb     17d3 <malloc+0xa6>
      if(p->s.size == nunits)
    1786:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1789:	8b 40 04             	mov    0x4(%eax),%eax
    178c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    178f:	75 0c                	jne    179d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1791:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1794:	8b 10                	mov    (%eax),%edx
    1796:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1799:	89 10                	mov    %edx,(%eax)
    179b:	eb 26                	jmp    17c3 <malloc+0x96>
      else {
        p->s.size -= nunits;
    179d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a0:	8b 40 04             	mov    0x4(%eax),%eax
    17a3:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17a6:	89 c2                	mov    %eax,%edx
    17a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ab:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b1:	8b 40 04             	mov    0x4(%eax),%eax
    17b4:	c1 e0 03             	shl    $0x3,%eax
    17b7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17c0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17c6:	a3 a8 1a 00 00       	mov    %eax,0x1aa8
      return (void*)(p + 1);
    17cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ce:	83 c0 08             	add    $0x8,%eax
    17d1:	eb 3b                	jmp    180e <malloc+0xe1>
    }
    if(p == freep)
    17d3:	a1 a8 1a 00 00       	mov    0x1aa8,%eax
    17d8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17db:	75 1e                	jne    17fb <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    17dd:	83 ec 0c             	sub    $0xc,%esp
    17e0:	ff 75 ec             	pushl  -0x14(%ebp)
    17e3:	e8 e5 fe ff ff       	call   16cd <morecore>
    17e8:	83 c4 10             	add    $0x10,%esp
    17eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17f2:	75 07                	jne    17fb <malloc+0xce>
        return 0;
    17f4:	b8 00 00 00 00       	mov    $0x0,%eax
    17f9:	eb 13                	jmp    180e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1801:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1804:	8b 00                	mov    (%eax),%eax
    1806:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1809:	e9 6d ff ff ff       	jmp    177b <malloc+0x4e>
}
    180e:	c9                   	leave  
    180f:	c3                   	ret    
