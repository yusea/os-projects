
_echo:     file format elf32-i386


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
    100f:	83 ec 10             	sub    $0x10,%esp
    1012:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
    1014:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    101b:	eb 3c                	jmp    1059 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
    101d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1020:	83 c0 01             	add    $0x1,%eax
    1023:	3b 03                	cmp    (%ebx),%eax
    1025:	7d 07                	jge    102e <main+0x2e>
    1027:	ba 01 18 00 00       	mov    $0x1801,%edx
    102c:	eb 05                	jmp    1033 <main+0x33>
    102e:	ba 03 18 00 00       	mov    $0x1803,%edx
    1033:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1036:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    103d:	8b 43 04             	mov    0x4(%ebx),%eax
    1040:	01 c8                	add    %ecx,%eax
    1042:	8b 00                	mov    (%eax),%eax
    1044:	52                   	push   %edx
    1045:	50                   	push   %eax
    1046:	68 05 18 00 00       	push   $0x1805
    104b:	6a 01                	push   $0x1
    104d:	e8 f9 03 00 00       	call   144b <printf>
    1052:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
    1055:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1059:	8b 45 f4             	mov    -0xc(%ebp),%eax
    105c:	3b 03                	cmp    (%ebx),%eax
    105e:	7c bd                	jl     101d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
    1060:	e8 57 02 00 00       	call   12bc <exit>

00001065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1065:	55                   	push   %ebp
    1066:	89 e5                	mov    %esp,%ebp
    1068:	57                   	push   %edi
    1069:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    106a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    106d:	8b 55 10             	mov    0x10(%ebp),%edx
    1070:	8b 45 0c             	mov    0xc(%ebp),%eax
    1073:	89 cb                	mov    %ecx,%ebx
    1075:	89 df                	mov    %ebx,%edi
    1077:	89 d1                	mov    %edx,%ecx
    1079:	fc                   	cld    
    107a:	f3 aa                	rep stos %al,%es:(%edi)
    107c:	89 ca                	mov    %ecx,%edx
    107e:	89 fb                	mov    %edi,%ebx
    1080:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1083:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1086:	90                   	nop
    1087:	5b                   	pop    %ebx
    1088:	5f                   	pop    %edi
    1089:	5d                   	pop    %ebp
    108a:	c3                   	ret    

0000108b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    108b:	55                   	push   %ebp
    108c:	89 e5                	mov    %esp,%ebp
    108e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1091:	8b 45 08             	mov    0x8(%ebp),%eax
    1094:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1097:	90                   	nop
    1098:	8b 45 08             	mov    0x8(%ebp),%eax
    109b:	8d 50 01             	lea    0x1(%eax),%edx
    109e:	89 55 08             	mov    %edx,0x8(%ebp)
    10a1:	8b 55 0c             	mov    0xc(%ebp),%edx
    10a4:	8d 4a 01             	lea    0x1(%edx),%ecx
    10a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10aa:	0f b6 12             	movzbl (%edx),%edx
    10ad:	88 10                	mov    %dl,(%eax)
    10af:	0f b6 00             	movzbl (%eax),%eax
    10b2:	84 c0                	test   %al,%al
    10b4:	75 e2                	jne    1098 <strcpy+0xd>
    ;
  return os;
    10b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10b9:	c9                   	leave  
    10ba:	c3                   	ret    

000010bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10bb:	55                   	push   %ebp
    10bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10be:	eb 08                	jmp    10c8 <strcmp+0xd>
    p++, q++;
    10c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10c8:	8b 45 08             	mov    0x8(%ebp),%eax
    10cb:	0f b6 00             	movzbl (%eax),%eax
    10ce:	84 c0                	test   %al,%al
    10d0:	74 10                	je     10e2 <strcmp+0x27>
    10d2:	8b 45 08             	mov    0x8(%ebp),%eax
    10d5:	0f b6 10             	movzbl (%eax),%edx
    10d8:	8b 45 0c             	mov    0xc(%ebp),%eax
    10db:	0f b6 00             	movzbl (%eax),%eax
    10de:	38 c2                	cmp    %al,%dl
    10e0:	74 de                	je     10c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10e2:	8b 45 08             	mov    0x8(%ebp),%eax
    10e5:	0f b6 00             	movzbl (%eax),%eax
    10e8:	0f b6 d0             	movzbl %al,%edx
    10eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ee:	0f b6 00             	movzbl (%eax),%eax
    10f1:	0f b6 c0             	movzbl %al,%eax
    10f4:	29 c2                	sub    %eax,%edx
    10f6:	89 d0                	mov    %edx,%eax
}
    10f8:	5d                   	pop    %ebp
    10f9:	c3                   	ret    

000010fa <strlen>:

uint
strlen(const char *s)
{
    10fa:	55                   	push   %ebp
    10fb:	89 e5                	mov    %esp,%ebp
    10fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1107:	eb 04                	jmp    110d <strlen+0x13>
    1109:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    110d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1110:	8b 45 08             	mov    0x8(%ebp),%eax
    1113:	01 d0                	add    %edx,%eax
    1115:	0f b6 00             	movzbl (%eax),%eax
    1118:	84 c0                	test   %al,%al
    111a:	75 ed                	jne    1109 <strlen+0xf>
    ;
  return n;
    111c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    111f:	c9                   	leave  
    1120:	c3                   	ret    

00001121 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1121:	55                   	push   %ebp
    1122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    1124:	8b 45 10             	mov    0x10(%ebp),%eax
    1127:	50                   	push   %eax
    1128:	ff 75 0c             	pushl  0xc(%ebp)
    112b:	ff 75 08             	pushl  0x8(%ebp)
    112e:	e8 32 ff ff ff       	call   1065 <stosb>
    1133:	83 c4 0c             	add    $0xc,%esp
  return dst;
    1136:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1139:	c9                   	leave  
    113a:	c3                   	ret    

0000113b <strchr>:

char*
strchr(const char *s, char c)
{
    113b:	55                   	push   %ebp
    113c:	89 e5                	mov    %esp,%ebp
    113e:	83 ec 04             	sub    $0x4,%esp
    1141:	8b 45 0c             	mov    0xc(%ebp),%eax
    1144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1147:	eb 14                	jmp    115d <strchr+0x22>
    if(*s == c)
    1149:	8b 45 08             	mov    0x8(%ebp),%eax
    114c:	0f b6 00             	movzbl (%eax),%eax
    114f:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1152:	75 05                	jne    1159 <strchr+0x1e>
      return (char*)s;
    1154:	8b 45 08             	mov    0x8(%ebp),%eax
    1157:	eb 13                	jmp    116c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    115d:	8b 45 08             	mov    0x8(%ebp),%eax
    1160:	0f b6 00             	movzbl (%eax),%eax
    1163:	84 c0                	test   %al,%al
    1165:	75 e2                	jne    1149 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1167:	b8 00 00 00 00       	mov    $0x0,%eax
}
    116c:	c9                   	leave  
    116d:	c3                   	ret    

0000116e <gets>:

char*
gets(char *buf, int max)
{
    116e:	55                   	push   %ebp
    116f:	89 e5                	mov    %esp,%ebp
    1171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    117b:	eb 42                	jmp    11bf <gets+0x51>
    cc = read(0, &c, 1);
    117d:	83 ec 04             	sub    $0x4,%esp
    1180:	6a 01                	push   $0x1
    1182:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1185:	50                   	push   %eax
    1186:	6a 00                	push   $0x0
    1188:	e8 47 01 00 00       	call   12d4 <read>
    118d:	83 c4 10             	add    $0x10,%esp
    1190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1197:	7e 33                	jle    11cc <gets+0x5e>
      break;
    buf[i++] = c;
    1199:	8b 45 f4             	mov    -0xc(%ebp),%eax
    119c:	8d 50 01             	lea    0x1(%eax),%edx
    119f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11a2:	89 c2                	mov    %eax,%edx
    11a4:	8b 45 08             	mov    0x8(%ebp),%eax
    11a7:	01 c2                	add    %eax,%edx
    11a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11b3:	3c 0a                	cmp    $0xa,%al
    11b5:	74 16                	je     11cd <gets+0x5f>
    11b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11bb:	3c 0d                	cmp    $0xd,%al
    11bd:	74 0e                	je     11cd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c2:	83 c0 01             	add    $0x1,%eax
    11c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11c8:	7c b3                	jl     117d <gets+0xf>
    11ca:	eb 01                	jmp    11cd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    11cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11d0:	8b 45 08             	mov    0x8(%ebp),%eax
    11d3:	01 d0                	add    %edx,%eax
    11d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11db:	c9                   	leave  
    11dc:	c3                   	ret    

000011dd <stat>:

int
stat(const char *n, struct stat *st)
{
    11dd:	55                   	push   %ebp
    11de:	89 e5                	mov    %esp,%ebp
    11e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11e3:	83 ec 08             	sub    $0x8,%esp
    11e6:	6a 00                	push   $0x0
    11e8:	ff 75 08             	pushl  0x8(%ebp)
    11eb:	e8 0c 01 00 00       	call   12fc <open>
    11f0:	83 c4 10             	add    $0x10,%esp
    11f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11fa:	79 07                	jns    1203 <stat+0x26>
    return -1;
    11fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1201:	eb 25                	jmp    1228 <stat+0x4b>
  r = fstat(fd, st);
    1203:	83 ec 08             	sub    $0x8,%esp
    1206:	ff 75 0c             	pushl  0xc(%ebp)
    1209:	ff 75 f4             	pushl  -0xc(%ebp)
    120c:	e8 03 01 00 00       	call   1314 <fstat>
    1211:	83 c4 10             	add    $0x10,%esp
    1214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1217:	83 ec 0c             	sub    $0xc,%esp
    121a:	ff 75 f4             	pushl  -0xc(%ebp)
    121d:	e8 c2 00 00 00       	call   12e4 <close>
    1222:	83 c4 10             	add    $0x10,%esp
  return r;
    1225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1228:	c9                   	leave  
    1229:	c3                   	ret    

0000122a <atoi>:

int
atoi(const char *s)
{
    122a:	55                   	push   %ebp
    122b:	89 e5                	mov    %esp,%ebp
    122d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1237:	eb 25                	jmp    125e <atoi+0x34>
    n = n*10 + *s++ - '0';
    1239:	8b 55 fc             	mov    -0x4(%ebp),%edx
    123c:	89 d0                	mov    %edx,%eax
    123e:	c1 e0 02             	shl    $0x2,%eax
    1241:	01 d0                	add    %edx,%eax
    1243:	01 c0                	add    %eax,%eax
    1245:	89 c1                	mov    %eax,%ecx
    1247:	8b 45 08             	mov    0x8(%ebp),%eax
    124a:	8d 50 01             	lea    0x1(%eax),%edx
    124d:	89 55 08             	mov    %edx,0x8(%ebp)
    1250:	0f b6 00             	movzbl (%eax),%eax
    1253:	0f be c0             	movsbl %al,%eax
    1256:	01 c8                	add    %ecx,%eax
    1258:	83 e8 30             	sub    $0x30,%eax
    125b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    125e:	8b 45 08             	mov    0x8(%ebp),%eax
    1261:	0f b6 00             	movzbl (%eax),%eax
    1264:	3c 2f                	cmp    $0x2f,%al
    1266:	7e 0a                	jle    1272 <atoi+0x48>
    1268:	8b 45 08             	mov    0x8(%ebp),%eax
    126b:	0f b6 00             	movzbl (%eax),%eax
    126e:	3c 39                	cmp    $0x39,%al
    1270:	7e c7                	jle    1239 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1275:	c9                   	leave  
    1276:	c3                   	ret    

00001277 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1277:	55                   	push   %ebp
    1278:	89 e5                	mov    %esp,%ebp
    127a:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    127d:	8b 45 08             	mov    0x8(%ebp),%eax
    1280:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1283:	8b 45 0c             	mov    0xc(%ebp),%eax
    1286:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1289:	eb 17                	jmp    12a2 <memmove+0x2b>
    *dst++ = *src++;
    128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    128e:	8d 50 01             	lea    0x1(%eax),%edx
    1291:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1294:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1297:	8d 4a 01             	lea    0x1(%edx),%ecx
    129a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    129d:	0f b6 12             	movzbl (%edx),%edx
    12a0:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12a2:	8b 45 10             	mov    0x10(%ebp),%eax
    12a5:	8d 50 ff             	lea    -0x1(%eax),%edx
    12a8:	89 55 10             	mov    %edx,0x10(%ebp)
    12ab:	85 c0                	test   %eax,%eax
    12ad:	7f dc                	jg     128b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12af:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12b2:	c9                   	leave  
    12b3:	c3                   	ret    

000012b4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12b4:	b8 01 00 00 00       	mov    $0x1,%eax
    12b9:	cd 40                	int    $0x40
    12bb:	c3                   	ret    

000012bc <exit>:
SYSCALL(exit)
    12bc:	b8 02 00 00 00       	mov    $0x2,%eax
    12c1:	cd 40                	int    $0x40
    12c3:	c3                   	ret    

000012c4 <wait>:
SYSCALL(wait)
    12c4:	b8 03 00 00 00       	mov    $0x3,%eax
    12c9:	cd 40                	int    $0x40
    12cb:	c3                   	ret    

000012cc <pipe>:
SYSCALL(pipe)
    12cc:	b8 04 00 00 00       	mov    $0x4,%eax
    12d1:	cd 40                	int    $0x40
    12d3:	c3                   	ret    

000012d4 <read>:
SYSCALL(read)
    12d4:	b8 05 00 00 00       	mov    $0x5,%eax
    12d9:	cd 40                	int    $0x40
    12db:	c3                   	ret    

000012dc <write>:
SYSCALL(write)
    12dc:	b8 10 00 00 00       	mov    $0x10,%eax
    12e1:	cd 40                	int    $0x40
    12e3:	c3                   	ret    

000012e4 <close>:
SYSCALL(close)
    12e4:	b8 15 00 00 00       	mov    $0x15,%eax
    12e9:	cd 40                	int    $0x40
    12eb:	c3                   	ret    

000012ec <kill>:
SYSCALL(kill)
    12ec:	b8 06 00 00 00       	mov    $0x6,%eax
    12f1:	cd 40                	int    $0x40
    12f3:	c3                   	ret    

000012f4 <exec>:
SYSCALL(exec)
    12f4:	b8 07 00 00 00       	mov    $0x7,%eax
    12f9:	cd 40                	int    $0x40
    12fb:	c3                   	ret    

000012fc <open>:
SYSCALL(open)
    12fc:	b8 0f 00 00 00       	mov    $0xf,%eax
    1301:	cd 40                	int    $0x40
    1303:	c3                   	ret    

00001304 <mknod>:
SYSCALL(mknod)
    1304:	b8 11 00 00 00       	mov    $0x11,%eax
    1309:	cd 40                	int    $0x40
    130b:	c3                   	ret    

0000130c <unlink>:
SYSCALL(unlink)
    130c:	b8 12 00 00 00       	mov    $0x12,%eax
    1311:	cd 40                	int    $0x40
    1313:	c3                   	ret    

00001314 <fstat>:
SYSCALL(fstat)
    1314:	b8 08 00 00 00       	mov    $0x8,%eax
    1319:	cd 40                	int    $0x40
    131b:	c3                   	ret    

0000131c <link>:
SYSCALL(link)
    131c:	b8 13 00 00 00       	mov    $0x13,%eax
    1321:	cd 40                	int    $0x40
    1323:	c3                   	ret    

00001324 <mkdir>:
SYSCALL(mkdir)
    1324:	b8 14 00 00 00       	mov    $0x14,%eax
    1329:	cd 40                	int    $0x40
    132b:	c3                   	ret    

0000132c <chdir>:
SYSCALL(chdir)
    132c:	b8 09 00 00 00       	mov    $0x9,%eax
    1331:	cd 40                	int    $0x40
    1333:	c3                   	ret    

00001334 <dup>:
SYSCALL(dup)
    1334:	b8 0a 00 00 00       	mov    $0xa,%eax
    1339:	cd 40                	int    $0x40
    133b:	c3                   	ret    

0000133c <getpid>:
SYSCALL(getpid)
    133c:	b8 0b 00 00 00       	mov    $0xb,%eax
    1341:	cd 40                	int    $0x40
    1343:	c3                   	ret    

00001344 <sbrk>:
SYSCALL(sbrk)
    1344:	b8 0c 00 00 00       	mov    $0xc,%eax
    1349:	cd 40                	int    $0x40
    134b:	c3                   	ret    

0000134c <sleep>:
SYSCALL(sleep)
    134c:	b8 0d 00 00 00       	mov    $0xd,%eax
    1351:	cd 40                	int    $0x40
    1353:	c3                   	ret    

00001354 <uptime>:
SYSCALL(uptime)
    1354:	b8 0e 00 00 00       	mov    $0xe,%eax
    1359:	cd 40                	int    $0x40
    135b:	c3                   	ret    

0000135c <getprocsinfo>:
SYSCALL(getprocsinfo)
    135c:	b8 16 00 00 00       	mov    $0x16,%eax
    1361:	cd 40                	int    $0x40
    1363:	c3                   	ret    

00001364 <shmem_access>:
SYSCALL(shmem_access)
    1364:	b8 17 00 00 00       	mov    $0x17,%eax
    1369:	cd 40                	int    $0x40
    136b:	c3                   	ret    

0000136c <shmem_count>:
SYSCALL(shmem_count)
    136c:	b8 18 00 00 00       	mov    $0x18,%eax
    1371:	cd 40                	int    $0x40
    1373:	c3                   	ret    

00001374 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1374:	55                   	push   %ebp
    1375:	89 e5                	mov    %esp,%ebp
    1377:	83 ec 18             	sub    $0x18,%esp
    137a:	8b 45 0c             	mov    0xc(%ebp),%eax
    137d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1380:	83 ec 04             	sub    $0x4,%esp
    1383:	6a 01                	push   $0x1
    1385:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1388:	50                   	push   %eax
    1389:	ff 75 08             	pushl  0x8(%ebp)
    138c:	e8 4b ff ff ff       	call   12dc <write>
    1391:	83 c4 10             	add    $0x10,%esp
}
    1394:	90                   	nop
    1395:	c9                   	leave  
    1396:	c3                   	ret    

00001397 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1397:	55                   	push   %ebp
    1398:	89 e5                	mov    %esp,%ebp
    139a:	53                   	push   %ebx
    139b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    139e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13a5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13a9:	74 17                	je     13c2 <printint+0x2b>
    13ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13af:	79 11                	jns    13c2 <printint+0x2b>
    neg = 1;
    13b1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13b8:	8b 45 0c             	mov    0xc(%ebp),%eax
    13bb:	f7 d8                	neg    %eax
    13bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13c0:	eb 06                	jmp    13c8 <printint+0x31>
  } else {
    x = xx;
    13c2:	8b 45 0c             	mov    0xc(%ebp),%eax
    13c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13cf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13d2:	8d 41 01             	lea    0x1(%ecx),%eax
    13d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13db:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13de:	ba 00 00 00 00       	mov    $0x0,%edx
    13e3:	f7 f3                	div    %ebx
    13e5:	89 d0                	mov    %edx,%eax
    13e7:	0f b6 80 60 1a 00 00 	movzbl 0x1a60(%eax),%eax
    13ee:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13f8:	ba 00 00 00 00       	mov    $0x0,%edx
    13fd:	f7 f3                	div    %ebx
    13ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1402:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1406:	75 c7                	jne    13cf <printint+0x38>
  if(neg)
    1408:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    140c:	74 2d                	je     143b <printint+0xa4>
    buf[i++] = '-';
    140e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1411:	8d 50 01             	lea    0x1(%eax),%edx
    1414:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1417:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    141c:	eb 1d                	jmp    143b <printint+0xa4>
    putc(fd, buf[i]);
    141e:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1421:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1424:	01 d0                	add    %edx,%eax
    1426:	0f b6 00             	movzbl (%eax),%eax
    1429:	0f be c0             	movsbl %al,%eax
    142c:	83 ec 08             	sub    $0x8,%esp
    142f:	50                   	push   %eax
    1430:	ff 75 08             	pushl  0x8(%ebp)
    1433:	e8 3c ff ff ff       	call   1374 <putc>
    1438:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    143b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    143f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1443:	79 d9                	jns    141e <printint+0x87>
    putc(fd, buf[i]);
}
    1445:	90                   	nop
    1446:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1449:	c9                   	leave  
    144a:	c3                   	ret    

0000144b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    144b:	55                   	push   %ebp
    144c:	89 e5                	mov    %esp,%ebp
    144e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1451:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1458:	8d 45 0c             	lea    0xc(%ebp),%eax
    145b:	83 c0 04             	add    $0x4,%eax
    145e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1461:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1468:	e9 59 01 00 00       	jmp    15c6 <printf+0x17b>
    c = fmt[i] & 0xff;
    146d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1470:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1473:	01 d0                	add    %edx,%eax
    1475:	0f b6 00             	movzbl (%eax),%eax
    1478:	0f be c0             	movsbl %al,%eax
    147b:	25 ff 00 00 00       	and    $0xff,%eax
    1480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1483:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1487:	75 2c                	jne    14b5 <printf+0x6a>
      if(c == '%'){
    1489:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    148d:	75 0c                	jne    149b <printf+0x50>
        state = '%';
    148f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1496:	e9 27 01 00 00       	jmp    15c2 <printf+0x177>
      } else {
        putc(fd, c);
    149b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    149e:	0f be c0             	movsbl %al,%eax
    14a1:	83 ec 08             	sub    $0x8,%esp
    14a4:	50                   	push   %eax
    14a5:	ff 75 08             	pushl  0x8(%ebp)
    14a8:	e8 c7 fe ff ff       	call   1374 <putc>
    14ad:	83 c4 10             	add    $0x10,%esp
    14b0:	e9 0d 01 00 00       	jmp    15c2 <printf+0x177>
      }
    } else if(state == '%'){
    14b5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14b9:	0f 85 03 01 00 00    	jne    15c2 <printf+0x177>
      if(c == 'd'){
    14bf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14c3:	75 1e                	jne    14e3 <printf+0x98>
        printint(fd, *ap, 10, 1);
    14c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14c8:	8b 00                	mov    (%eax),%eax
    14ca:	6a 01                	push   $0x1
    14cc:	6a 0a                	push   $0xa
    14ce:	50                   	push   %eax
    14cf:	ff 75 08             	pushl  0x8(%ebp)
    14d2:	e8 c0 fe ff ff       	call   1397 <printint>
    14d7:	83 c4 10             	add    $0x10,%esp
        ap++;
    14da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14de:	e9 d8 00 00 00       	jmp    15bb <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    14e3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14e7:	74 06                	je     14ef <printf+0xa4>
    14e9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14ed:	75 1e                	jne    150d <printf+0xc2>
        printint(fd, *ap, 16, 0);
    14ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14f2:	8b 00                	mov    (%eax),%eax
    14f4:	6a 00                	push   $0x0
    14f6:	6a 10                	push   $0x10
    14f8:	50                   	push   %eax
    14f9:	ff 75 08             	pushl  0x8(%ebp)
    14fc:	e8 96 fe ff ff       	call   1397 <printint>
    1501:	83 c4 10             	add    $0x10,%esp
        ap++;
    1504:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1508:	e9 ae 00 00 00       	jmp    15bb <printf+0x170>
      } else if(c == 's'){
    150d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1511:	75 43                	jne    1556 <printf+0x10b>
        s = (char*)*ap;
    1513:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1516:	8b 00                	mov    (%eax),%eax
    1518:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    151b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    151f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1523:	75 25                	jne    154a <printf+0xff>
          s = "(null)";
    1525:	c7 45 f4 0a 18 00 00 	movl   $0x180a,-0xc(%ebp)
        while(*s != 0){
    152c:	eb 1c                	jmp    154a <printf+0xff>
          putc(fd, *s);
    152e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1531:	0f b6 00             	movzbl (%eax),%eax
    1534:	0f be c0             	movsbl %al,%eax
    1537:	83 ec 08             	sub    $0x8,%esp
    153a:	50                   	push   %eax
    153b:	ff 75 08             	pushl  0x8(%ebp)
    153e:	e8 31 fe ff ff       	call   1374 <putc>
    1543:	83 c4 10             	add    $0x10,%esp
          s++;
    1546:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    154a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    154d:	0f b6 00             	movzbl (%eax),%eax
    1550:	84 c0                	test   %al,%al
    1552:	75 da                	jne    152e <printf+0xe3>
    1554:	eb 65                	jmp    15bb <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1556:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    155a:	75 1d                	jne    1579 <printf+0x12e>
        putc(fd, *ap);
    155c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    155f:	8b 00                	mov    (%eax),%eax
    1561:	0f be c0             	movsbl %al,%eax
    1564:	83 ec 08             	sub    $0x8,%esp
    1567:	50                   	push   %eax
    1568:	ff 75 08             	pushl  0x8(%ebp)
    156b:	e8 04 fe ff ff       	call   1374 <putc>
    1570:	83 c4 10             	add    $0x10,%esp
        ap++;
    1573:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1577:	eb 42                	jmp    15bb <printf+0x170>
      } else if(c == '%'){
    1579:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    157d:	75 17                	jne    1596 <printf+0x14b>
        putc(fd, c);
    157f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1582:	0f be c0             	movsbl %al,%eax
    1585:	83 ec 08             	sub    $0x8,%esp
    1588:	50                   	push   %eax
    1589:	ff 75 08             	pushl  0x8(%ebp)
    158c:	e8 e3 fd ff ff       	call   1374 <putc>
    1591:	83 c4 10             	add    $0x10,%esp
    1594:	eb 25                	jmp    15bb <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1596:	83 ec 08             	sub    $0x8,%esp
    1599:	6a 25                	push   $0x25
    159b:	ff 75 08             	pushl  0x8(%ebp)
    159e:	e8 d1 fd ff ff       	call   1374 <putc>
    15a3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    15a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15a9:	0f be c0             	movsbl %al,%eax
    15ac:	83 ec 08             	sub    $0x8,%esp
    15af:	50                   	push   %eax
    15b0:	ff 75 08             	pushl  0x8(%ebp)
    15b3:	e8 bc fd ff ff       	call   1374 <putc>
    15b8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    15bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15c2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15c6:	8b 55 0c             	mov    0xc(%ebp),%edx
    15c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15cc:	01 d0                	add    %edx,%eax
    15ce:	0f b6 00             	movzbl (%eax),%eax
    15d1:	84 c0                	test   %al,%al
    15d3:	0f 85 94 fe ff ff    	jne    146d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15d9:	90                   	nop
    15da:	c9                   	leave  
    15db:	c3                   	ret    

000015dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15dc:	55                   	push   %ebp
    15dd:	89 e5                	mov    %esp,%ebp
    15df:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15e2:	8b 45 08             	mov    0x8(%ebp),%eax
    15e5:	83 e8 08             	sub    $0x8,%eax
    15e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15eb:	a1 7c 1a 00 00       	mov    0x1a7c,%eax
    15f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15f3:	eb 24                	jmp    1619 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15f8:	8b 00                	mov    (%eax),%eax
    15fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15fd:	77 12                	ja     1611 <free+0x35>
    15ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1605:	77 24                	ja     162b <free+0x4f>
    1607:	8b 45 fc             	mov    -0x4(%ebp),%eax
    160a:	8b 00                	mov    (%eax),%eax
    160c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    160f:	77 1a                	ja     162b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1611:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1614:	8b 00                	mov    (%eax),%eax
    1616:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1619:	8b 45 f8             	mov    -0x8(%ebp),%eax
    161c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    161f:	76 d4                	jbe    15f5 <free+0x19>
    1621:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1624:	8b 00                	mov    (%eax),%eax
    1626:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1629:	76 ca                	jbe    15f5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    162b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    162e:	8b 40 04             	mov    0x4(%eax),%eax
    1631:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1638:	8b 45 f8             	mov    -0x8(%ebp),%eax
    163b:	01 c2                	add    %eax,%edx
    163d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1640:	8b 00                	mov    (%eax),%eax
    1642:	39 c2                	cmp    %eax,%edx
    1644:	75 24                	jne    166a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1646:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1649:	8b 50 04             	mov    0x4(%eax),%edx
    164c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164f:	8b 00                	mov    (%eax),%eax
    1651:	8b 40 04             	mov    0x4(%eax),%eax
    1654:	01 c2                	add    %eax,%edx
    1656:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1659:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    165c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    165f:	8b 00                	mov    (%eax),%eax
    1661:	8b 10                	mov    (%eax),%edx
    1663:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1666:	89 10                	mov    %edx,(%eax)
    1668:	eb 0a                	jmp    1674 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    166a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166d:	8b 10                	mov    (%eax),%edx
    166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1672:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1674:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1677:	8b 40 04             	mov    0x4(%eax),%eax
    167a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1681:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1684:	01 d0                	add    %edx,%eax
    1686:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1689:	75 20                	jne    16ab <free+0xcf>
    p->s.size += bp->s.size;
    168b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168e:	8b 50 04             	mov    0x4(%eax),%edx
    1691:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1694:	8b 40 04             	mov    0x4(%eax),%eax
    1697:	01 c2                	add    %eax,%edx
    1699:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    169f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a2:	8b 10                	mov    (%eax),%edx
    16a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a7:	89 10                	mov    %edx,(%eax)
    16a9:	eb 08                	jmp    16b3 <free+0xd7>
  } else
    p->s.ptr = bp;
    16ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16b1:	89 10                	mov    %edx,(%eax)
  freep = p;
    16b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b6:	a3 7c 1a 00 00       	mov    %eax,0x1a7c
}
    16bb:	90                   	nop
    16bc:	c9                   	leave  
    16bd:	c3                   	ret    

000016be <morecore>:

static Header*
morecore(uint nu)
{
    16be:	55                   	push   %ebp
    16bf:	89 e5                	mov    %esp,%ebp
    16c1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16c4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16cb:	77 07                	ja     16d4 <morecore+0x16>
    nu = 4096;
    16cd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16d4:	8b 45 08             	mov    0x8(%ebp),%eax
    16d7:	c1 e0 03             	shl    $0x3,%eax
    16da:	83 ec 0c             	sub    $0xc,%esp
    16dd:	50                   	push   %eax
    16de:	e8 61 fc ff ff       	call   1344 <sbrk>
    16e3:	83 c4 10             	add    $0x10,%esp
    16e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16e9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16ed:	75 07                	jne    16f6 <morecore+0x38>
    return 0;
    16ef:	b8 00 00 00 00       	mov    $0x0,%eax
    16f4:	eb 26                	jmp    171c <morecore+0x5e>
  hp = (Header*)p;
    16f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    16fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16ff:	8b 55 08             	mov    0x8(%ebp),%edx
    1702:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1705:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1708:	83 c0 08             	add    $0x8,%eax
    170b:	83 ec 0c             	sub    $0xc,%esp
    170e:	50                   	push   %eax
    170f:	e8 c8 fe ff ff       	call   15dc <free>
    1714:	83 c4 10             	add    $0x10,%esp
  return freep;
    1717:	a1 7c 1a 00 00       	mov    0x1a7c,%eax
}
    171c:	c9                   	leave  
    171d:	c3                   	ret    

0000171e <malloc>:

void*
malloc(uint nbytes)
{
    171e:	55                   	push   %ebp
    171f:	89 e5                	mov    %esp,%ebp
    1721:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1724:	8b 45 08             	mov    0x8(%ebp),%eax
    1727:	83 c0 07             	add    $0x7,%eax
    172a:	c1 e8 03             	shr    $0x3,%eax
    172d:	83 c0 01             	add    $0x1,%eax
    1730:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1733:	a1 7c 1a 00 00       	mov    0x1a7c,%eax
    1738:	89 45 f0             	mov    %eax,-0x10(%ebp)
    173b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    173f:	75 23                	jne    1764 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1741:	c7 45 f0 74 1a 00 00 	movl   $0x1a74,-0x10(%ebp)
    1748:	8b 45 f0             	mov    -0x10(%ebp),%eax
    174b:	a3 7c 1a 00 00       	mov    %eax,0x1a7c
    1750:	a1 7c 1a 00 00       	mov    0x1a7c,%eax
    1755:	a3 74 1a 00 00       	mov    %eax,0x1a74
    base.s.size = 0;
    175a:	c7 05 78 1a 00 00 00 	movl   $0x0,0x1a78
    1761:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1764:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1767:	8b 00                	mov    (%eax),%eax
    1769:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    176f:	8b 40 04             	mov    0x4(%eax),%eax
    1772:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1775:	72 4d                	jb     17c4 <malloc+0xa6>
      if(p->s.size == nunits)
    1777:	8b 45 f4             	mov    -0xc(%ebp),%eax
    177a:	8b 40 04             	mov    0x4(%eax),%eax
    177d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1780:	75 0c                	jne    178e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1782:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1785:	8b 10                	mov    (%eax),%edx
    1787:	8b 45 f0             	mov    -0x10(%ebp),%eax
    178a:	89 10                	mov    %edx,(%eax)
    178c:	eb 26                	jmp    17b4 <malloc+0x96>
      else {
        p->s.size -= nunits;
    178e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1791:	8b 40 04             	mov    0x4(%eax),%eax
    1794:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1797:	89 c2                	mov    %eax,%edx
    1799:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    179f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a2:	8b 40 04             	mov    0x4(%eax),%eax
    17a5:	c1 e0 03             	shl    $0x3,%eax
    17a8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17b1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b7:	a3 7c 1a 00 00       	mov    %eax,0x1a7c
      return (void*)(p + 1);
    17bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bf:	83 c0 08             	add    $0x8,%eax
    17c2:	eb 3b                	jmp    17ff <malloc+0xe1>
    }
    if(p == freep)
    17c4:	a1 7c 1a 00 00       	mov    0x1a7c,%eax
    17c9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17cc:	75 1e                	jne    17ec <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    17ce:	83 ec 0c             	sub    $0xc,%esp
    17d1:	ff 75 ec             	pushl  -0x14(%ebp)
    17d4:	e8 e5 fe ff ff       	call   16be <morecore>
    17d9:	83 c4 10             	add    $0x10,%esp
    17dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17e3:	75 07                	jne    17ec <malloc+0xce>
        return 0;
    17e5:	b8 00 00 00 00       	mov    $0x0,%eax
    17ea:	eb 13                	jmp    17ff <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f5:	8b 00                	mov    (%eax),%eax
    17f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    17fa:	e9 6d ff ff ff       	jmp    176c <malloc+0x4e>
}
    17ff:	c9                   	leave  
    1800:	c3                   	ret    
