
_rm:     file format elf32-i386


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

  if(argc < 2){
    1014:	83 3b 01             	cmpl   $0x1,(%ebx)
    1017:	7f 17                	jg     1030 <main+0x30>
    printf(2, "Usage: rm files...\n");
    1019:	83 ec 08             	sub    $0x8,%esp
    101c:	68 2c 18 00 00       	push   $0x182c
    1021:	6a 02                	push   $0x2
    1023:	e8 4e 04 00 00       	call   1476 <printf>
    1028:	83 c4 10             	add    $0x10,%esp
    exit();
    102b:	e8 b7 02 00 00       	call   12e7 <exit>
  }

  for(i = 1; i < argc; i++){
    1030:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    1037:	eb 4b                	jmp    1084 <main+0x84>
    if(unlink(argv[i]) < 0){
    1039:	8b 45 f4             	mov    -0xc(%ebp),%eax
    103c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1043:	8b 43 04             	mov    0x4(%ebx),%eax
    1046:	01 d0                	add    %edx,%eax
    1048:	8b 00                	mov    (%eax),%eax
    104a:	83 ec 0c             	sub    $0xc,%esp
    104d:	50                   	push   %eax
    104e:	e8 e4 02 00 00       	call   1337 <unlink>
    1053:	83 c4 10             	add    $0x10,%esp
    1056:	85 c0                	test   %eax,%eax
    1058:	79 26                	jns    1080 <main+0x80>
      printf(2, "rm: %s failed to delete\n", argv[i]);
    105a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    105d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1064:	8b 43 04             	mov    0x4(%ebx),%eax
    1067:	01 d0                	add    %edx,%eax
    1069:	8b 00                	mov    (%eax),%eax
    106b:	83 ec 04             	sub    $0x4,%esp
    106e:	50                   	push   %eax
    106f:	68 40 18 00 00       	push   $0x1840
    1074:	6a 02                	push   $0x2
    1076:	e8 fb 03 00 00       	call   1476 <printf>
    107b:	83 c4 10             	add    $0x10,%esp
      break;
    107e:	eb 0b                	jmp    108b <main+0x8b>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    1080:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1084:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1087:	3b 03                	cmp    (%ebx),%eax
    1089:	7c ae                	jl     1039 <main+0x39>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
    108b:	e8 57 02 00 00       	call   12e7 <exit>

00001090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1090:	55                   	push   %ebp
    1091:	89 e5                	mov    %esp,%ebp
    1093:	57                   	push   %edi
    1094:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1095:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1098:	8b 55 10             	mov    0x10(%ebp),%edx
    109b:	8b 45 0c             	mov    0xc(%ebp),%eax
    109e:	89 cb                	mov    %ecx,%ebx
    10a0:	89 df                	mov    %ebx,%edi
    10a2:	89 d1                	mov    %edx,%ecx
    10a4:	fc                   	cld    
    10a5:	f3 aa                	rep stos %al,%es:(%edi)
    10a7:	89 ca                	mov    %ecx,%edx
    10a9:	89 fb                	mov    %edi,%ebx
    10ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10b1:	90                   	nop
    10b2:	5b                   	pop    %ebx
    10b3:	5f                   	pop    %edi
    10b4:	5d                   	pop    %ebp
    10b5:	c3                   	ret    

000010b6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    10b6:	55                   	push   %ebp
    10b7:	89 e5                	mov    %esp,%ebp
    10b9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10bc:	8b 45 08             	mov    0x8(%ebp),%eax
    10bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10c2:	90                   	nop
    10c3:	8b 45 08             	mov    0x8(%ebp),%eax
    10c6:	8d 50 01             	lea    0x1(%eax),%edx
    10c9:	89 55 08             	mov    %edx,0x8(%ebp)
    10cc:	8b 55 0c             	mov    0xc(%ebp),%edx
    10cf:	8d 4a 01             	lea    0x1(%edx),%ecx
    10d2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10d5:	0f b6 12             	movzbl (%edx),%edx
    10d8:	88 10                	mov    %dl,(%eax)
    10da:	0f b6 00             	movzbl (%eax),%eax
    10dd:	84 c0                	test   %al,%al
    10df:	75 e2                	jne    10c3 <strcpy+0xd>
    ;
  return os;
    10e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10e4:	c9                   	leave  
    10e5:	c3                   	ret    

000010e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10e6:	55                   	push   %ebp
    10e7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10e9:	eb 08                	jmp    10f3 <strcmp+0xd>
    p++, q++;
    10eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10ef:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10f3:	8b 45 08             	mov    0x8(%ebp),%eax
    10f6:	0f b6 00             	movzbl (%eax),%eax
    10f9:	84 c0                	test   %al,%al
    10fb:	74 10                	je     110d <strcmp+0x27>
    10fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1100:	0f b6 10             	movzbl (%eax),%edx
    1103:	8b 45 0c             	mov    0xc(%ebp),%eax
    1106:	0f b6 00             	movzbl (%eax),%eax
    1109:	38 c2                	cmp    %al,%dl
    110b:	74 de                	je     10eb <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    110d:	8b 45 08             	mov    0x8(%ebp),%eax
    1110:	0f b6 00             	movzbl (%eax),%eax
    1113:	0f b6 d0             	movzbl %al,%edx
    1116:	8b 45 0c             	mov    0xc(%ebp),%eax
    1119:	0f b6 00             	movzbl (%eax),%eax
    111c:	0f b6 c0             	movzbl %al,%eax
    111f:	29 c2                	sub    %eax,%edx
    1121:	89 d0                	mov    %edx,%eax
}
    1123:	5d                   	pop    %ebp
    1124:	c3                   	ret    

00001125 <strlen>:

uint
strlen(const char *s)
{
    1125:	55                   	push   %ebp
    1126:	89 e5                	mov    %esp,%ebp
    1128:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    112b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1132:	eb 04                	jmp    1138 <strlen+0x13>
    1134:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1138:	8b 55 fc             	mov    -0x4(%ebp),%edx
    113b:	8b 45 08             	mov    0x8(%ebp),%eax
    113e:	01 d0                	add    %edx,%eax
    1140:	0f b6 00             	movzbl (%eax),%eax
    1143:	84 c0                	test   %al,%al
    1145:	75 ed                	jne    1134 <strlen+0xf>
    ;
  return n;
    1147:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    114a:	c9                   	leave  
    114b:	c3                   	ret    

0000114c <memset>:

void*
memset(void *dst, int c, uint n)
{
    114c:	55                   	push   %ebp
    114d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    114f:	8b 45 10             	mov    0x10(%ebp),%eax
    1152:	50                   	push   %eax
    1153:	ff 75 0c             	pushl  0xc(%ebp)
    1156:	ff 75 08             	pushl  0x8(%ebp)
    1159:	e8 32 ff ff ff       	call   1090 <stosb>
    115e:	83 c4 0c             	add    $0xc,%esp
  return dst;
    1161:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1164:	c9                   	leave  
    1165:	c3                   	ret    

00001166 <strchr>:

char*
strchr(const char *s, char c)
{
    1166:	55                   	push   %ebp
    1167:	89 e5                	mov    %esp,%ebp
    1169:	83 ec 04             	sub    $0x4,%esp
    116c:	8b 45 0c             	mov    0xc(%ebp),%eax
    116f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1172:	eb 14                	jmp    1188 <strchr+0x22>
    if(*s == c)
    1174:	8b 45 08             	mov    0x8(%ebp),%eax
    1177:	0f b6 00             	movzbl (%eax),%eax
    117a:	3a 45 fc             	cmp    -0x4(%ebp),%al
    117d:	75 05                	jne    1184 <strchr+0x1e>
      return (char*)s;
    117f:	8b 45 08             	mov    0x8(%ebp),%eax
    1182:	eb 13                	jmp    1197 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1188:	8b 45 08             	mov    0x8(%ebp),%eax
    118b:	0f b6 00             	movzbl (%eax),%eax
    118e:	84 c0                	test   %al,%al
    1190:	75 e2                	jne    1174 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1192:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1197:	c9                   	leave  
    1198:	c3                   	ret    

00001199 <gets>:

char*
gets(char *buf, int max)
{
    1199:	55                   	push   %ebp
    119a:	89 e5                	mov    %esp,%ebp
    119c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    119f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11a6:	eb 42                	jmp    11ea <gets+0x51>
    cc = read(0, &c, 1);
    11a8:	83 ec 04             	sub    $0x4,%esp
    11ab:	6a 01                	push   $0x1
    11ad:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11b0:	50                   	push   %eax
    11b1:	6a 00                	push   $0x0
    11b3:	e8 47 01 00 00       	call   12ff <read>
    11b8:	83 c4 10             	add    $0x10,%esp
    11bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11c2:	7e 33                	jle    11f7 <gets+0x5e>
      break;
    buf[i++] = c;
    11c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c7:	8d 50 01             	lea    0x1(%eax),%edx
    11ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11cd:	89 c2                	mov    %eax,%edx
    11cf:	8b 45 08             	mov    0x8(%ebp),%eax
    11d2:	01 c2                	add    %eax,%edx
    11d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11d8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11de:	3c 0a                	cmp    $0xa,%al
    11e0:	74 16                	je     11f8 <gets+0x5f>
    11e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11e6:	3c 0d                	cmp    $0xd,%al
    11e8:	74 0e                	je     11f8 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ed:	83 c0 01             	add    $0x1,%eax
    11f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11f3:	7c b3                	jl     11a8 <gets+0xf>
    11f5:	eb 01                	jmp    11f8 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    11f7:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11fb:	8b 45 08             	mov    0x8(%ebp),%eax
    11fe:	01 d0                	add    %edx,%eax
    1200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1203:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1206:	c9                   	leave  
    1207:	c3                   	ret    

00001208 <stat>:

int
stat(const char *n, struct stat *st)
{
    1208:	55                   	push   %ebp
    1209:	89 e5                	mov    %esp,%ebp
    120b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    120e:	83 ec 08             	sub    $0x8,%esp
    1211:	6a 00                	push   $0x0
    1213:	ff 75 08             	pushl  0x8(%ebp)
    1216:	e8 0c 01 00 00       	call   1327 <open>
    121b:	83 c4 10             	add    $0x10,%esp
    121e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1225:	79 07                	jns    122e <stat+0x26>
    return -1;
    1227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    122c:	eb 25                	jmp    1253 <stat+0x4b>
  r = fstat(fd, st);
    122e:	83 ec 08             	sub    $0x8,%esp
    1231:	ff 75 0c             	pushl  0xc(%ebp)
    1234:	ff 75 f4             	pushl  -0xc(%ebp)
    1237:	e8 03 01 00 00       	call   133f <fstat>
    123c:	83 c4 10             	add    $0x10,%esp
    123f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1242:	83 ec 0c             	sub    $0xc,%esp
    1245:	ff 75 f4             	pushl  -0xc(%ebp)
    1248:	e8 c2 00 00 00       	call   130f <close>
    124d:	83 c4 10             	add    $0x10,%esp
  return r;
    1250:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1253:	c9                   	leave  
    1254:	c3                   	ret    

00001255 <atoi>:

int
atoi(const char *s)
{
    1255:	55                   	push   %ebp
    1256:	89 e5                	mov    %esp,%ebp
    1258:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    125b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1262:	eb 25                	jmp    1289 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1264:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1267:	89 d0                	mov    %edx,%eax
    1269:	c1 e0 02             	shl    $0x2,%eax
    126c:	01 d0                	add    %edx,%eax
    126e:	01 c0                	add    %eax,%eax
    1270:	89 c1                	mov    %eax,%ecx
    1272:	8b 45 08             	mov    0x8(%ebp),%eax
    1275:	8d 50 01             	lea    0x1(%eax),%edx
    1278:	89 55 08             	mov    %edx,0x8(%ebp)
    127b:	0f b6 00             	movzbl (%eax),%eax
    127e:	0f be c0             	movsbl %al,%eax
    1281:	01 c8                	add    %ecx,%eax
    1283:	83 e8 30             	sub    $0x30,%eax
    1286:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1289:	8b 45 08             	mov    0x8(%ebp),%eax
    128c:	0f b6 00             	movzbl (%eax),%eax
    128f:	3c 2f                	cmp    $0x2f,%al
    1291:	7e 0a                	jle    129d <atoi+0x48>
    1293:	8b 45 08             	mov    0x8(%ebp),%eax
    1296:	0f b6 00             	movzbl (%eax),%eax
    1299:	3c 39                	cmp    $0x39,%al
    129b:	7e c7                	jle    1264 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    129d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12a0:	c9                   	leave  
    12a1:	c3                   	ret    

000012a2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12a2:	55                   	push   %ebp
    12a3:	89 e5                	mov    %esp,%ebp
    12a5:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    12a8:	8b 45 08             	mov    0x8(%ebp),%eax
    12ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12ae:	8b 45 0c             	mov    0xc(%ebp),%eax
    12b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12b4:	eb 17                	jmp    12cd <memmove+0x2b>
    *dst++ = *src++;
    12b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b9:	8d 50 01             	lea    0x1(%eax),%edx
    12bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12c2:	8d 4a 01             	lea    0x1(%edx),%ecx
    12c5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12c8:	0f b6 12             	movzbl (%edx),%edx
    12cb:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12cd:	8b 45 10             	mov    0x10(%ebp),%eax
    12d0:	8d 50 ff             	lea    -0x1(%eax),%edx
    12d3:	89 55 10             	mov    %edx,0x10(%ebp)
    12d6:	85 c0                	test   %eax,%eax
    12d8:	7f dc                	jg     12b6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12da:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12dd:	c9                   	leave  
    12de:	c3                   	ret    

000012df <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12df:	b8 01 00 00 00       	mov    $0x1,%eax
    12e4:	cd 40                	int    $0x40
    12e6:	c3                   	ret    

000012e7 <exit>:
SYSCALL(exit)
    12e7:	b8 02 00 00 00       	mov    $0x2,%eax
    12ec:	cd 40                	int    $0x40
    12ee:	c3                   	ret    

000012ef <wait>:
SYSCALL(wait)
    12ef:	b8 03 00 00 00       	mov    $0x3,%eax
    12f4:	cd 40                	int    $0x40
    12f6:	c3                   	ret    

000012f7 <pipe>:
SYSCALL(pipe)
    12f7:	b8 04 00 00 00       	mov    $0x4,%eax
    12fc:	cd 40                	int    $0x40
    12fe:	c3                   	ret    

000012ff <read>:
SYSCALL(read)
    12ff:	b8 05 00 00 00       	mov    $0x5,%eax
    1304:	cd 40                	int    $0x40
    1306:	c3                   	ret    

00001307 <write>:
SYSCALL(write)
    1307:	b8 10 00 00 00       	mov    $0x10,%eax
    130c:	cd 40                	int    $0x40
    130e:	c3                   	ret    

0000130f <close>:
SYSCALL(close)
    130f:	b8 15 00 00 00       	mov    $0x15,%eax
    1314:	cd 40                	int    $0x40
    1316:	c3                   	ret    

00001317 <kill>:
SYSCALL(kill)
    1317:	b8 06 00 00 00       	mov    $0x6,%eax
    131c:	cd 40                	int    $0x40
    131e:	c3                   	ret    

0000131f <exec>:
SYSCALL(exec)
    131f:	b8 07 00 00 00       	mov    $0x7,%eax
    1324:	cd 40                	int    $0x40
    1326:	c3                   	ret    

00001327 <open>:
SYSCALL(open)
    1327:	b8 0f 00 00 00       	mov    $0xf,%eax
    132c:	cd 40                	int    $0x40
    132e:	c3                   	ret    

0000132f <mknod>:
SYSCALL(mknod)
    132f:	b8 11 00 00 00       	mov    $0x11,%eax
    1334:	cd 40                	int    $0x40
    1336:	c3                   	ret    

00001337 <unlink>:
SYSCALL(unlink)
    1337:	b8 12 00 00 00       	mov    $0x12,%eax
    133c:	cd 40                	int    $0x40
    133e:	c3                   	ret    

0000133f <fstat>:
SYSCALL(fstat)
    133f:	b8 08 00 00 00       	mov    $0x8,%eax
    1344:	cd 40                	int    $0x40
    1346:	c3                   	ret    

00001347 <link>:
SYSCALL(link)
    1347:	b8 13 00 00 00       	mov    $0x13,%eax
    134c:	cd 40                	int    $0x40
    134e:	c3                   	ret    

0000134f <mkdir>:
SYSCALL(mkdir)
    134f:	b8 14 00 00 00       	mov    $0x14,%eax
    1354:	cd 40                	int    $0x40
    1356:	c3                   	ret    

00001357 <chdir>:
SYSCALL(chdir)
    1357:	b8 09 00 00 00       	mov    $0x9,%eax
    135c:	cd 40                	int    $0x40
    135e:	c3                   	ret    

0000135f <dup>:
SYSCALL(dup)
    135f:	b8 0a 00 00 00       	mov    $0xa,%eax
    1364:	cd 40                	int    $0x40
    1366:	c3                   	ret    

00001367 <getpid>:
SYSCALL(getpid)
    1367:	b8 0b 00 00 00       	mov    $0xb,%eax
    136c:	cd 40                	int    $0x40
    136e:	c3                   	ret    

0000136f <sbrk>:
SYSCALL(sbrk)
    136f:	b8 0c 00 00 00       	mov    $0xc,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <sleep>:
SYSCALL(sleep)
    1377:	b8 0d 00 00 00       	mov    $0xd,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <uptime>:
SYSCALL(uptime)
    137f:	b8 0e 00 00 00       	mov    $0xe,%eax
    1384:	cd 40                	int    $0x40
    1386:	c3                   	ret    

00001387 <getprocsinfo>:
SYSCALL(getprocsinfo)
    1387:	b8 16 00 00 00       	mov    $0x16,%eax
    138c:	cd 40                	int    $0x40
    138e:	c3                   	ret    

0000138f <shmem_access>:
SYSCALL(shmem_access)
    138f:	b8 17 00 00 00       	mov    $0x17,%eax
    1394:	cd 40                	int    $0x40
    1396:	c3                   	ret    

00001397 <shmem_count>:
SYSCALL(shmem_count)
    1397:	b8 18 00 00 00       	mov    $0x18,%eax
    139c:	cd 40                	int    $0x40
    139e:	c3                   	ret    

0000139f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    139f:	55                   	push   %ebp
    13a0:	89 e5                	mov    %esp,%ebp
    13a2:	83 ec 18             	sub    $0x18,%esp
    13a5:	8b 45 0c             	mov    0xc(%ebp),%eax
    13a8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    13ab:	83 ec 04             	sub    $0x4,%esp
    13ae:	6a 01                	push   $0x1
    13b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13b3:	50                   	push   %eax
    13b4:	ff 75 08             	pushl  0x8(%ebp)
    13b7:	e8 4b ff ff ff       	call   1307 <write>
    13bc:	83 c4 10             	add    $0x10,%esp
}
    13bf:	90                   	nop
    13c0:	c9                   	leave  
    13c1:	c3                   	ret    

000013c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13c2:	55                   	push   %ebp
    13c3:	89 e5                	mov    %esp,%ebp
    13c5:	53                   	push   %ebx
    13c6:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13d0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13d4:	74 17                	je     13ed <printint+0x2b>
    13d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13da:	79 11                	jns    13ed <printint+0x2b>
    neg = 1;
    13dc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13e3:	8b 45 0c             	mov    0xc(%ebp),%eax
    13e6:	f7 d8                	neg    %eax
    13e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13eb:	eb 06                	jmp    13f3 <printint+0x31>
  } else {
    x = xx;
    13ed:	8b 45 0c             	mov    0xc(%ebp),%eax
    13f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13fa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13fd:	8d 41 01             	lea    0x1(%ecx),%eax
    1400:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1403:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1406:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1409:	ba 00 00 00 00       	mov    $0x0,%edx
    140e:	f7 f3                	div    %ebx
    1410:	89 d0                	mov    %edx,%eax
    1412:	0f b6 80 ac 1a 00 00 	movzbl 0x1aac(%eax),%eax
    1419:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    141d:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1420:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1423:	ba 00 00 00 00       	mov    $0x0,%edx
    1428:	f7 f3                	div    %ebx
    142a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    142d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1431:	75 c7                	jne    13fa <printint+0x38>
  if(neg)
    1433:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1437:	74 2d                	je     1466 <printint+0xa4>
    buf[i++] = '-';
    1439:	8b 45 f4             	mov    -0xc(%ebp),%eax
    143c:	8d 50 01             	lea    0x1(%eax),%edx
    143f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1442:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1447:	eb 1d                	jmp    1466 <printint+0xa4>
    putc(fd, buf[i]);
    1449:	8d 55 dc             	lea    -0x24(%ebp),%edx
    144c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    144f:	01 d0                	add    %edx,%eax
    1451:	0f b6 00             	movzbl (%eax),%eax
    1454:	0f be c0             	movsbl %al,%eax
    1457:	83 ec 08             	sub    $0x8,%esp
    145a:	50                   	push   %eax
    145b:	ff 75 08             	pushl  0x8(%ebp)
    145e:	e8 3c ff ff ff       	call   139f <putc>
    1463:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1466:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    146a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    146e:	79 d9                	jns    1449 <printint+0x87>
    putc(fd, buf[i]);
}
    1470:	90                   	nop
    1471:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1474:	c9                   	leave  
    1475:	c3                   	ret    

00001476 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1476:	55                   	push   %ebp
    1477:	89 e5                	mov    %esp,%ebp
    1479:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    147c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1483:	8d 45 0c             	lea    0xc(%ebp),%eax
    1486:	83 c0 04             	add    $0x4,%eax
    1489:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    148c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1493:	e9 59 01 00 00       	jmp    15f1 <printf+0x17b>
    c = fmt[i] & 0xff;
    1498:	8b 55 0c             	mov    0xc(%ebp),%edx
    149b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    149e:	01 d0                	add    %edx,%eax
    14a0:	0f b6 00             	movzbl (%eax),%eax
    14a3:	0f be c0             	movsbl %al,%eax
    14a6:	25 ff 00 00 00       	and    $0xff,%eax
    14ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14b2:	75 2c                	jne    14e0 <printf+0x6a>
      if(c == '%'){
    14b4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14b8:	75 0c                	jne    14c6 <printf+0x50>
        state = '%';
    14ba:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14c1:	e9 27 01 00 00       	jmp    15ed <printf+0x177>
      } else {
        putc(fd, c);
    14c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14c9:	0f be c0             	movsbl %al,%eax
    14cc:	83 ec 08             	sub    $0x8,%esp
    14cf:	50                   	push   %eax
    14d0:	ff 75 08             	pushl  0x8(%ebp)
    14d3:	e8 c7 fe ff ff       	call   139f <putc>
    14d8:	83 c4 10             	add    $0x10,%esp
    14db:	e9 0d 01 00 00       	jmp    15ed <printf+0x177>
      }
    } else if(state == '%'){
    14e0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14e4:	0f 85 03 01 00 00    	jne    15ed <printf+0x177>
      if(c == 'd'){
    14ea:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14ee:	75 1e                	jne    150e <printf+0x98>
        printint(fd, *ap, 10, 1);
    14f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14f3:	8b 00                	mov    (%eax),%eax
    14f5:	6a 01                	push   $0x1
    14f7:	6a 0a                	push   $0xa
    14f9:	50                   	push   %eax
    14fa:	ff 75 08             	pushl  0x8(%ebp)
    14fd:	e8 c0 fe ff ff       	call   13c2 <printint>
    1502:	83 c4 10             	add    $0x10,%esp
        ap++;
    1505:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1509:	e9 d8 00 00 00       	jmp    15e6 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    150e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1512:	74 06                	je     151a <printf+0xa4>
    1514:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1518:	75 1e                	jne    1538 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    151a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    151d:	8b 00                	mov    (%eax),%eax
    151f:	6a 00                	push   $0x0
    1521:	6a 10                	push   $0x10
    1523:	50                   	push   %eax
    1524:	ff 75 08             	pushl  0x8(%ebp)
    1527:	e8 96 fe ff ff       	call   13c2 <printint>
    152c:	83 c4 10             	add    $0x10,%esp
        ap++;
    152f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1533:	e9 ae 00 00 00       	jmp    15e6 <printf+0x170>
      } else if(c == 's'){
    1538:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    153c:	75 43                	jne    1581 <printf+0x10b>
        s = (char*)*ap;
    153e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1541:	8b 00                	mov    (%eax),%eax
    1543:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1546:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    154a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    154e:	75 25                	jne    1575 <printf+0xff>
          s = "(null)";
    1550:	c7 45 f4 59 18 00 00 	movl   $0x1859,-0xc(%ebp)
        while(*s != 0){
    1557:	eb 1c                	jmp    1575 <printf+0xff>
          putc(fd, *s);
    1559:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155c:	0f b6 00             	movzbl (%eax),%eax
    155f:	0f be c0             	movsbl %al,%eax
    1562:	83 ec 08             	sub    $0x8,%esp
    1565:	50                   	push   %eax
    1566:	ff 75 08             	pushl  0x8(%ebp)
    1569:	e8 31 fe ff ff       	call   139f <putc>
    156e:	83 c4 10             	add    $0x10,%esp
          s++;
    1571:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1575:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1578:	0f b6 00             	movzbl (%eax),%eax
    157b:	84 c0                	test   %al,%al
    157d:	75 da                	jne    1559 <printf+0xe3>
    157f:	eb 65                	jmp    15e6 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1581:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1585:	75 1d                	jne    15a4 <printf+0x12e>
        putc(fd, *ap);
    1587:	8b 45 e8             	mov    -0x18(%ebp),%eax
    158a:	8b 00                	mov    (%eax),%eax
    158c:	0f be c0             	movsbl %al,%eax
    158f:	83 ec 08             	sub    $0x8,%esp
    1592:	50                   	push   %eax
    1593:	ff 75 08             	pushl  0x8(%ebp)
    1596:	e8 04 fe ff ff       	call   139f <putc>
    159b:	83 c4 10             	add    $0x10,%esp
        ap++;
    159e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15a2:	eb 42                	jmp    15e6 <printf+0x170>
      } else if(c == '%'){
    15a4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15a8:	75 17                	jne    15c1 <printf+0x14b>
        putc(fd, c);
    15aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15ad:	0f be c0             	movsbl %al,%eax
    15b0:	83 ec 08             	sub    $0x8,%esp
    15b3:	50                   	push   %eax
    15b4:	ff 75 08             	pushl  0x8(%ebp)
    15b7:	e8 e3 fd ff ff       	call   139f <putc>
    15bc:	83 c4 10             	add    $0x10,%esp
    15bf:	eb 25                	jmp    15e6 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15c1:	83 ec 08             	sub    $0x8,%esp
    15c4:	6a 25                	push   $0x25
    15c6:	ff 75 08             	pushl  0x8(%ebp)
    15c9:	e8 d1 fd ff ff       	call   139f <putc>
    15ce:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    15d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15d4:	0f be c0             	movsbl %al,%eax
    15d7:	83 ec 08             	sub    $0x8,%esp
    15da:	50                   	push   %eax
    15db:	ff 75 08             	pushl  0x8(%ebp)
    15de:	e8 bc fd ff ff       	call   139f <putc>
    15e3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    15e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15ed:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15f1:	8b 55 0c             	mov    0xc(%ebp),%edx
    15f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f7:	01 d0                	add    %edx,%eax
    15f9:	0f b6 00             	movzbl (%eax),%eax
    15fc:	84 c0                	test   %al,%al
    15fe:	0f 85 94 fe ff ff    	jne    1498 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1604:	90                   	nop
    1605:	c9                   	leave  
    1606:	c3                   	ret    

00001607 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1607:	55                   	push   %ebp
    1608:	89 e5                	mov    %esp,%ebp
    160a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    160d:	8b 45 08             	mov    0x8(%ebp),%eax
    1610:	83 e8 08             	sub    $0x8,%eax
    1613:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1616:	a1 c8 1a 00 00       	mov    0x1ac8,%eax
    161b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    161e:	eb 24                	jmp    1644 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1620:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1623:	8b 00                	mov    (%eax),%eax
    1625:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1628:	77 12                	ja     163c <free+0x35>
    162a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    162d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1630:	77 24                	ja     1656 <free+0x4f>
    1632:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1635:	8b 00                	mov    (%eax),%eax
    1637:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    163a:	77 1a                	ja     1656 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    163c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    163f:	8b 00                	mov    (%eax),%eax
    1641:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1644:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1647:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    164a:	76 d4                	jbe    1620 <free+0x19>
    164c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164f:	8b 00                	mov    (%eax),%eax
    1651:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1654:	76 ca                	jbe    1620 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1656:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1659:	8b 40 04             	mov    0x4(%eax),%eax
    165c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1663:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1666:	01 c2                	add    %eax,%edx
    1668:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166b:	8b 00                	mov    (%eax),%eax
    166d:	39 c2                	cmp    %eax,%edx
    166f:	75 24                	jne    1695 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1671:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1674:	8b 50 04             	mov    0x4(%eax),%edx
    1677:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167a:	8b 00                	mov    (%eax),%eax
    167c:	8b 40 04             	mov    0x4(%eax),%eax
    167f:	01 c2                	add    %eax,%edx
    1681:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1684:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1687:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168a:	8b 00                	mov    (%eax),%eax
    168c:	8b 10                	mov    (%eax),%edx
    168e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1691:	89 10                	mov    %edx,(%eax)
    1693:	eb 0a                	jmp    169f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1695:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1698:	8b 10                	mov    (%eax),%edx
    169a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    169d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    169f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a2:	8b 40 04             	mov    0x4(%eax),%eax
    16a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16af:	01 d0                	add    %edx,%eax
    16b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16b4:	75 20                	jne    16d6 <free+0xcf>
    p->s.size += bp->s.size;
    16b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b9:	8b 50 04             	mov    0x4(%eax),%edx
    16bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16bf:	8b 40 04             	mov    0x4(%eax),%eax
    16c2:	01 c2                	add    %eax,%edx
    16c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16cd:	8b 10                	mov    (%eax),%edx
    16cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d2:	89 10                	mov    %edx,(%eax)
    16d4:	eb 08                	jmp    16de <free+0xd7>
  } else
    p->s.ptr = bp;
    16d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16dc:	89 10                	mov    %edx,(%eax)
  freep = p;
    16de:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e1:	a3 c8 1a 00 00       	mov    %eax,0x1ac8
}
    16e6:	90                   	nop
    16e7:	c9                   	leave  
    16e8:	c3                   	ret    

000016e9 <morecore>:

static Header*
morecore(uint nu)
{
    16e9:	55                   	push   %ebp
    16ea:	89 e5                	mov    %esp,%ebp
    16ec:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16ef:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16f6:	77 07                	ja     16ff <morecore+0x16>
    nu = 4096;
    16f8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1702:	c1 e0 03             	shl    $0x3,%eax
    1705:	83 ec 0c             	sub    $0xc,%esp
    1708:	50                   	push   %eax
    1709:	e8 61 fc ff ff       	call   136f <sbrk>
    170e:	83 c4 10             	add    $0x10,%esp
    1711:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1714:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1718:	75 07                	jne    1721 <morecore+0x38>
    return 0;
    171a:	b8 00 00 00 00       	mov    $0x0,%eax
    171f:	eb 26                	jmp    1747 <morecore+0x5e>
  hp = (Header*)p;
    1721:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1724:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1727:	8b 45 f0             	mov    -0x10(%ebp),%eax
    172a:	8b 55 08             	mov    0x8(%ebp),%edx
    172d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1730:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1733:	83 c0 08             	add    $0x8,%eax
    1736:	83 ec 0c             	sub    $0xc,%esp
    1739:	50                   	push   %eax
    173a:	e8 c8 fe ff ff       	call   1607 <free>
    173f:	83 c4 10             	add    $0x10,%esp
  return freep;
    1742:	a1 c8 1a 00 00       	mov    0x1ac8,%eax
}
    1747:	c9                   	leave  
    1748:	c3                   	ret    

00001749 <malloc>:

void*
malloc(uint nbytes)
{
    1749:	55                   	push   %ebp
    174a:	89 e5                	mov    %esp,%ebp
    174c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    174f:	8b 45 08             	mov    0x8(%ebp),%eax
    1752:	83 c0 07             	add    $0x7,%eax
    1755:	c1 e8 03             	shr    $0x3,%eax
    1758:	83 c0 01             	add    $0x1,%eax
    175b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    175e:	a1 c8 1a 00 00       	mov    0x1ac8,%eax
    1763:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1766:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    176a:	75 23                	jne    178f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    176c:	c7 45 f0 c0 1a 00 00 	movl   $0x1ac0,-0x10(%ebp)
    1773:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1776:	a3 c8 1a 00 00       	mov    %eax,0x1ac8
    177b:	a1 c8 1a 00 00       	mov    0x1ac8,%eax
    1780:	a3 c0 1a 00 00       	mov    %eax,0x1ac0
    base.s.size = 0;
    1785:	c7 05 c4 1a 00 00 00 	movl   $0x0,0x1ac4
    178c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1792:	8b 00                	mov    (%eax),%eax
    1794:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1797:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179a:	8b 40 04             	mov    0x4(%eax),%eax
    179d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17a0:	72 4d                	jb     17ef <malloc+0xa6>
      if(p->s.size == nunits)
    17a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a5:	8b 40 04             	mov    0x4(%eax),%eax
    17a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17ab:	75 0c                	jne    17b9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b0:	8b 10                	mov    (%eax),%edx
    17b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b5:	89 10                	mov    %edx,(%eax)
    17b7:	eb 26                	jmp    17df <malloc+0x96>
      else {
        p->s.size -= nunits;
    17b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bc:	8b 40 04             	mov    0x4(%eax),%eax
    17bf:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17c2:	89 c2                	mov    %eax,%edx
    17c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17cd:	8b 40 04             	mov    0x4(%eax),%eax
    17d0:	c1 e0 03             	shl    $0x3,%eax
    17d3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17dc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e2:	a3 c8 1a 00 00       	mov    %eax,0x1ac8
      return (void*)(p + 1);
    17e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ea:	83 c0 08             	add    $0x8,%eax
    17ed:	eb 3b                	jmp    182a <malloc+0xe1>
    }
    if(p == freep)
    17ef:	a1 c8 1a 00 00       	mov    0x1ac8,%eax
    17f4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17f7:	75 1e                	jne    1817 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    17f9:	83 ec 0c             	sub    $0xc,%esp
    17fc:	ff 75 ec             	pushl  -0x14(%ebp)
    17ff:	e8 e5 fe ff ff       	call   16e9 <morecore>
    1804:	83 c4 10             	add    $0x10,%esp
    1807:	89 45 f4             	mov    %eax,-0xc(%ebp)
    180a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    180e:	75 07                	jne    1817 <malloc+0xce>
        return 0;
    1810:	b8 00 00 00 00       	mov    $0x0,%eax
    1815:	eb 13                	jmp    182a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1817:	8b 45 f4             	mov    -0xc(%ebp),%eax
    181a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    181d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1820:	8b 00                	mov    (%eax),%eax
    1822:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1825:	e9 6d ff ff ff       	jmp    1797 <malloc+0x4e>
}
    182a:	c9                   	leave  
    182b:	c3                   	ret    
