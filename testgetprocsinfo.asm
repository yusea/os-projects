
_testgetprocsinfo:     file format elf32-i386


Disassembly of section .text:

00001000 <getprocsinfotest>:
#include "procinfo.h"

int stdout = 1;

void
getprocsinfotest(){
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	81 ec 18 05 00 00    	sub    $0x518,%esp
  struct procinfo info[64];
  int procnum = getprocsinfo(info);
    1009:	83 ec 0c             	sub    $0xc,%esp
    100c:	8d 85 f0 fa ff ff    	lea    -0x510(%ebp),%eax
    1012:	50                   	push   %eax
    1013:	e8 b2 03 00 00       	call   13ca <getprocsinfo>
    1018:	83 c4 10             	add    $0x10,%esp
    101b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(procnum < 0)
    101e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1022:	79 1b                	jns    103f <getprocsinfotest+0x3f>
  {
    printf(stdout,"test case failed");
    1024:	a1 28 1b 00 00       	mov    0x1b28,%eax
    1029:	83 ec 08             	sub    $0x8,%esp
    102c:	68 6f 18 00 00       	push   $0x186f
    1031:	50                   	push   %eax
    1032:	e8 82 04 00 00       	call   14b9 <printf>
    1037:	83 c4 10             	add    $0x10,%esp
	exit();
    103a:	e8 eb 02 00 00       	call   132a <exit>
  }
  else{
	printf(stdout, "processes:%d\n", procnum);
    103f:	a1 28 1b 00 00       	mov    0x1b28,%eax
    1044:	83 ec 04             	sub    $0x4,%esp
    1047:	ff 75 f0             	pushl  -0x10(%ebp)
    104a:	68 80 18 00 00       	push   $0x1880
    104f:	50                   	push   %eax
    1050:	e8 64 04 00 00       	call   14b9 <printf>
    1055:	83 c4 10             	add    $0x10,%esp

	struct procinfo *in;
  	for(in = info; in < &info[procnum]; in++)
    1058:	8d 85 f0 fa ff ff    	lea    -0x510(%ebp),%eax
    105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1061:	eb 24                	jmp    1087 <getprocsinfotest+0x87>
    {
	  printf(stdout, "pid:%d, name:%s\n", in->pid, in->pname);
    1063:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1066:	8d 48 04             	lea    0x4(%eax),%ecx
    1069:	8b 45 f4             	mov    -0xc(%ebp),%eax
    106c:	8b 10                	mov    (%eax),%edx
    106e:	a1 28 1b 00 00       	mov    0x1b28,%eax
    1073:	51                   	push   %ecx
    1074:	52                   	push   %edx
    1075:	68 8e 18 00 00       	push   $0x188e
    107a:	50                   	push   %eax
    107b:	e8 39 04 00 00       	call   14b9 <printf>
    1080:	83 c4 10             	add    $0x10,%esp
  }
  else{
	printf(stdout, "processes:%d\n", procnum);

	struct procinfo *in;
  	for(in = info; in < &info[procnum]; in++)
    1083:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
    1087:	8d 8d f0 fa ff ff    	lea    -0x510(%ebp),%ecx
    108d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1090:	89 d0                	mov    %edx,%eax
    1092:	c1 e0 02             	shl    $0x2,%eax
    1095:	01 d0                	add    %edx,%eax
    1097:	c1 e0 02             	shl    $0x2,%eax
    109a:	01 c8                	add    %ecx,%eax
    109c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    109f:	77 c2                	ja     1063 <getprocsinfotest+0x63>
    {
	  printf(stdout, "pid:%d, name:%s\n", in->pid, in->pname);
    }
	exit();
    10a1:	e8 84 02 00 00       	call   132a <exit>

000010a6 <main>:
}


int
main(int argc, char *argv[])
{
    10a6:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    10aa:	83 e4 f0             	and    $0xfffffff0,%esp
    10ad:	ff 71 fc             	pushl  -0x4(%ecx)
    10b0:	55                   	push   %ebp
    10b1:	89 e5                	mov    %esp,%ebp
    10b3:	51                   	push   %ecx
    10b4:	83 ec 04             	sub    $0x4,%esp
  printf(1, "testgetprocsinfo starting\n");
    10b7:	83 ec 08             	sub    $0x8,%esp
    10ba:	68 9f 18 00 00       	push   $0x189f
    10bf:	6a 01                	push   $0x1
    10c1:	e8 f3 03 00 00       	call   14b9 <printf>
    10c6:	83 c4 10             	add    $0x10,%esp
  getprocsinfotest();
    10c9:	e8 32 ff ff ff       	call   1000 <getprocsinfotest>
  exit();
    10ce:	e8 57 02 00 00       	call   132a <exit>

000010d3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10d3:	55                   	push   %ebp
    10d4:	89 e5                	mov    %esp,%ebp
    10d6:	57                   	push   %edi
    10d7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    10d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10db:	8b 55 10             	mov    0x10(%ebp),%edx
    10de:	8b 45 0c             	mov    0xc(%ebp),%eax
    10e1:	89 cb                	mov    %ecx,%ebx
    10e3:	89 df                	mov    %ebx,%edi
    10e5:	89 d1                	mov    %edx,%ecx
    10e7:	fc                   	cld    
    10e8:	f3 aa                	rep stos %al,%es:(%edi)
    10ea:	89 ca                	mov    %ecx,%edx
    10ec:	89 fb                	mov    %edi,%ebx
    10ee:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10f1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10f4:	90                   	nop
    10f5:	5b                   	pop    %ebx
    10f6:	5f                   	pop    %edi
    10f7:	5d                   	pop    %ebp
    10f8:	c3                   	ret    

000010f9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    10f9:	55                   	push   %ebp
    10fa:	89 e5                	mov    %esp,%ebp
    10fc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1102:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1105:	90                   	nop
    1106:	8b 45 08             	mov    0x8(%ebp),%eax
    1109:	8d 50 01             	lea    0x1(%eax),%edx
    110c:	89 55 08             	mov    %edx,0x8(%ebp)
    110f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1112:	8d 4a 01             	lea    0x1(%edx),%ecx
    1115:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1118:	0f b6 12             	movzbl (%edx),%edx
    111b:	88 10                	mov    %dl,(%eax)
    111d:	0f b6 00             	movzbl (%eax),%eax
    1120:	84 c0                	test   %al,%al
    1122:	75 e2                	jne    1106 <strcpy+0xd>
    ;
  return os;
    1124:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1127:	c9                   	leave  
    1128:	c3                   	ret    

00001129 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1129:	55                   	push   %ebp
    112a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    112c:	eb 08                	jmp    1136 <strcmp+0xd>
    p++, q++;
    112e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1132:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1136:	8b 45 08             	mov    0x8(%ebp),%eax
    1139:	0f b6 00             	movzbl (%eax),%eax
    113c:	84 c0                	test   %al,%al
    113e:	74 10                	je     1150 <strcmp+0x27>
    1140:	8b 45 08             	mov    0x8(%ebp),%eax
    1143:	0f b6 10             	movzbl (%eax),%edx
    1146:	8b 45 0c             	mov    0xc(%ebp),%eax
    1149:	0f b6 00             	movzbl (%eax),%eax
    114c:	38 c2                	cmp    %al,%dl
    114e:	74 de                	je     112e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1150:	8b 45 08             	mov    0x8(%ebp),%eax
    1153:	0f b6 00             	movzbl (%eax),%eax
    1156:	0f b6 d0             	movzbl %al,%edx
    1159:	8b 45 0c             	mov    0xc(%ebp),%eax
    115c:	0f b6 00             	movzbl (%eax),%eax
    115f:	0f b6 c0             	movzbl %al,%eax
    1162:	29 c2                	sub    %eax,%edx
    1164:	89 d0                	mov    %edx,%eax
}
    1166:	5d                   	pop    %ebp
    1167:	c3                   	ret    

00001168 <strlen>:

uint
strlen(const char *s)
{
    1168:	55                   	push   %ebp
    1169:	89 e5                	mov    %esp,%ebp
    116b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    116e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1175:	eb 04                	jmp    117b <strlen+0x13>
    1177:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    117b:	8b 55 fc             	mov    -0x4(%ebp),%edx
    117e:	8b 45 08             	mov    0x8(%ebp),%eax
    1181:	01 d0                	add    %edx,%eax
    1183:	0f b6 00             	movzbl (%eax),%eax
    1186:	84 c0                	test   %al,%al
    1188:	75 ed                	jne    1177 <strlen+0xf>
    ;
  return n;
    118a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    118d:	c9                   	leave  
    118e:	c3                   	ret    

0000118f <memset>:

void*
memset(void *dst, int c, uint n)
{
    118f:	55                   	push   %ebp
    1190:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    1192:	8b 45 10             	mov    0x10(%ebp),%eax
    1195:	50                   	push   %eax
    1196:	ff 75 0c             	pushl  0xc(%ebp)
    1199:	ff 75 08             	pushl  0x8(%ebp)
    119c:	e8 32 ff ff ff       	call   10d3 <stosb>
    11a1:	83 c4 0c             	add    $0xc,%esp
  return dst;
    11a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11a7:	c9                   	leave  
    11a8:	c3                   	ret    

000011a9 <strchr>:

char*
strchr(const char *s, char c)
{
    11a9:	55                   	push   %ebp
    11aa:	89 e5                	mov    %esp,%ebp
    11ac:	83 ec 04             	sub    $0x4,%esp
    11af:	8b 45 0c             	mov    0xc(%ebp),%eax
    11b2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11b5:	eb 14                	jmp    11cb <strchr+0x22>
    if(*s == c)
    11b7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ba:	0f b6 00             	movzbl (%eax),%eax
    11bd:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11c0:	75 05                	jne    11c7 <strchr+0x1e>
      return (char*)s;
    11c2:	8b 45 08             	mov    0x8(%ebp),%eax
    11c5:	eb 13                	jmp    11da <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    11c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11cb:	8b 45 08             	mov    0x8(%ebp),%eax
    11ce:	0f b6 00             	movzbl (%eax),%eax
    11d1:	84 c0                	test   %al,%al
    11d3:	75 e2                	jne    11b7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    11d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11da:	c9                   	leave  
    11db:	c3                   	ret    

000011dc <gets>:

char*
gets(char *buf, int max)
{
    11dc:	55                   	push   %ebp
    11dd:	89 e5                	mov    %esp,%ebp
    11df:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11e9:	eb 42                	jmp    122d <gets+0x51>
    cc = read(0, &c, 1);
    11eb:	83 ec 04             	sub    $0x4,%esp
    11ee:	6a 01                	push   $0x1
    11f0:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11f3:	50                   	push   %eax
    11f4:	6a 00                	push   $0x0
    11f6:	e8 47 01 00 00       	call   1342 <read>
    11fb:	83 c4 10             	add    $0x10,%esp
    11fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1201:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1205:	7e 33                	jle    123a <gets+0x5e>
      break;
    buf[i++] = c;
    1207:	8b 45 f4             	mov    -0xc(%ebp),%eax
    120a:	8d 50 01             	lea    0x1(%eax),%edx
    120d:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1210:	89 c2                	mov    %eax,%edx
    1212:	8b 45 08             	mov    0x8(%ebp),%eax
    1215:	01 c2                	add    %eax,%edx
    1217:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    121b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    121d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1221:	3c 0a                	cmp    $0xa,%al
    1223:	74 16                	je     123b <gets+0x5f>
    1225:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1229:	3c 0d                	cmp    $0xd,%al
    122b:	74 0e                	je     123b <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    122d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1230:	83 c0 01             	add    $0x1,%eax
    1233:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1236:	7c b3                	jl     11eb <gets+0xf>
    1238:	eb 01                	jmp    123b <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    123a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    123b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    123e:	8b 45 08             	mov    0x8(%ebp),%eax
    1241:	01 d0                	add    %edx,%eax
    1243:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1246:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1249:	c9                   	leave  
    124a:	c3                   	ret    

0000124b <stat>:

int
stat(const char *n, struct stat *st)
{
    124b:	55                   	push   %ebp
    124c:	89 e5                	mov    %esp,%ebp
    124e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1251:	83 ec 08             	sub    $0x8,%esp
    1254:	6a 00                	push   $0x0
    1256:	ff 75 08             	pushl  0x8(%ebp)
    1259:	e8 0c 01 00 00       	call   136a <open>
    125e:	83 c4 10             	add    $0x10,%esp
    1261:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1268:	79 07                	jns    1271 <stat+0x26>
    return -1;
    126a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    126f:	eb 25                	jmp    1296 <stat+0x4b>
  r = fstat(fd, st);
    1271:	83 ec 08             	sub    $0x8,%esp
    1274:	ff 75 0c             	pushl  0xc(%ebp)
    1277:	ff 75 f4             	pushl  -0xc(%ebp)
    127a:	e8 03 01 00 00       	call   1382 <fstat>
    127f:	83 c4 10             	add    $0x10,%esp
    1282:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1285:	83 ec 0c             	sub    $0xc,%esp
    1288:	ff 75 f4             	pushl  -0xc(%ebp)
    128b:	e8 c2 00 00 00       	call   1352 <close>
    1290:	83 c4 10             	add    $0x10,%esp
  return r;
    1293:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1296:	c9                   	leave  
    1297:	c3                   	ret    

00001298 <atoi>:

int
atoi(const char *s)
{
    1298:	55                   	push   %ebp
    1299:	89 e5                	mov    %esp,%ebp
    129b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    129e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12a5:	eb 25                	jmp    12cc <atoi+0x34>
    n = n*10 + *s++ - '0';
    12a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12aa:	89 d0                	mov    %edx,%eax
    12ac:	c1 e0 02             	shl    $0x2,%eax
    12af:	01 d0                	add    %edx,%eax
    12b1:	01 c0                	add    %eax,%eax
    12b3:	89 c1                	mov    %eax,%ecx
    12b5:	8b 45 08             	mov    0x8(%ebp),%eax
    12b8:	8d 50 01             	lea    0x1(%eax),%edx
    12bb:	89 55 08             	mov    %edx,0x8(%ebp)
    12be:	0f b6 00             	movzbl (%eax),%eax
    12c1:	0f be c0             	movsbl %al,%eax
    12c4:	01 c8                	add    %ecx,%eax
    12c6:	83 e8 30             	sub    $0x30,%eax
    12c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12cc:	8b 45 08             	mov    0x8(%ebp),%eax
    12cf:	0f b6 00             	movzbl (%eax),%eax
    12d2:	3c 2f                	cmp    $0x2f,%al
    12d4:	7e 0a                	jle    12e0 <atoi+0x48>
    12d6:	8b 45 08             	mov    0x8(%ebp),%eax
    12d9:	0f b6 00             	movzbl (%eax),%eax
    12dc:	3c 39                	cmp    $0x39,%al
    12de:	7e c7                	jle    12a7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    12e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12e3:	c9                   	leave  
    12e4:	c3                   	ret    

000012e5 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12e5:	55                   	push   %ebp
    12e6:	89 e5                	mov    %esp,%ebp
    12e8:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    12eb:	8b 45 08             	mov    0x8(%ebp),%eax
    12ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    12f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12f7:	eb 17                	jmp    1310 <memmove+0x2b>
    *dst++ = *src++;
    12f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12fc:	8d 50 01             	lea    0x1(%eax),%edx
    12ff:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1302:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1305:	8d 4a 01             	lea    0x1(%edx),%ecx
    1308:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    130b:	0f b6 12             	movzbl (%edx),%edx
    130e:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1310:	8b 45 10             	mov    0x10(%ebp),%eax
    1313:	8d 50 ff             	lea    -0x1(%eax),%edx
    1316:	89 55 10             	mov    %edx,0x10(%ebp)
    1319:	85 c0                	test   %eax,%eax
    131b:	7f dc                	jg     12f9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    131d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1320:	c9                   	leave  
    1321:	c3                   	ret    

00001322 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1322:	b8 01 00 00 00       	mov    $0x1,%eax
    1327:	cd 40                	int    $0x40
    1329:	c3                   	ret    

0000132a <exit>:
SYSCALL(exit)
    132a:	b8 02 00 00 00       	mov    $0x2,%eax
    132f:	cd 40                	int    $0x40
    1331:	c3                   	ret    

00001332 <wait>:
SYSCALL(wait)
    1332:	b8 03 00 00 00       	mov    $0x3,%eax
    1337:	cd 40                	int    $0x40
    1339:	c3                   	ret    

0000133a <pipe>:
SYSCALL(pipe)
    133a:	b8 04 00 00 00       	mov    $0x4,%eax
    133f:	cd 40                	int    $0x40
    1341:	c3                   	ret    

00001342 <read>:
SYSCALL(read)
    1342:	b8 05 00 00 00       	mov    $0x5,%eax
    1347:	cd 40                	int    $0x40
    1349:	c3                   	ret    

0000134a <write>:
SYSCALL(write)
    134a:	b8 10 00 00 00       	mov    $0x10,%eax
    134f:	cd 40                	int    $0x40
    1351:	c3                   	ret    

00001352 <close>:
SYSCALL(close)
    1352:	b8 15 00 00 00       	mov    $0x15,%eax
    1357:	cd 40                	int    $0x40
    1359:	c3                   	ret    

0000135a <kill>:
SYSCALL(kill)
    135a:	b8 06 00 00 00       	mov    $0x6,%eax
    135f:	cd 40                	int    $0x40
    1361:	c3                   	ret    

00001362 <exec>:
SYSCALL(exec)
    1362:	b8 07 00 00 00       	mov    $0x7,%eax
    1367:	cd 40                	int    $0x40
    1369:	c3                   	ret    

0000136a <open>:
SYSCALL(open)
    136a:	b8 0f 00 00 00       	mov    $0xf,%eax
    136f:	cd 40                	int    $0x40
    1371:	c3                   	ret    

00001372 <mknod>:
SYSCALL(mknod)
    1372:	b8 11 00 00 00       	mov    $0x11,%eax
    1377:	cd 40                	int    $0x40
    1379:	c3                   	ret    

0000137a <unlink>:
SYSCALL(unlink)
    137a:	b8 12 00 00 00       	mov    $0x12,%eax
    137f:	cd 40                	int    $0x40
    1381:	c3                   	ret    

00001382 <fstat>:
SYSCALL(fstat)
    1382:	b8 08 00 00 00       	mov    $0x8,%eax
    1387:	cd 40                	int    $0x40
    1389:	c3                   	ret    

0000138a <link>:
SYSCALL(link)
    138a:	b8 13 00 00 00       	mov    $0x13,%eax
    138f:	cd 40                	int    $0x40
    1391:	c3                   	ret    

00001392 <mkdir>:
SYSCALL(mkdir)
    1392:	b8 14 00 00 00       	mov    $0x14,%eax
    1397:	cd 40                	int    $0x40
    1399:	c3                   	ret    

0000139a <chdir>:
SYSCALL(chdir)
    139a:	b8 09 00 00 00       	mov    $0x9,%eax
    139f:	cd 40                	int    $0x40
    13a1:	c3                   	ret    

000013a2 <dup>:
SYSCALL(dup)
    13a2:	b8 0a 00 00 00       	mov    $0xa,%eax
    13a7:	cd 40                	int    $0x40
    13a9:	c3                   	ret    

000013aa <getpid>:
SYSCALL(getpid)
    13aa:	b8 0b 00 00 00       	mov    $0xb,%eax
    13af:	cd 40                	int    $0x40
    13b1:	c3                   	ret    

000013b2 <sbrk>:
SYSCALL(sbrk)
    13b2:	b8 0c 00 00 00       	mov    $0xc,%eax
    13b7:	cd 40                	int    $0x40
    13b9:	c3                   	ret    

000013ba <sleep>:
SYSCALL(sleep)
    13ba:	b8 0d 00 00 00       	mov    $0xd,%eax
    13bf:	cd 40                	int    $0x40
    13c1:	c3                   	ret    

000013c2 <uptime>:
SYSCALL(uptime)
    13c2:	b8 0e 00 00 00       	mov    $0xe,%eax
    13c7:	cd 40                	int    $0x40
    13c9:	c3                   	ret    

000013ca <getprocsinfo>:
SYSCALL(getprocsinfo)
    13ca:	b8 16 00 00 00       	mov    $0x16,%eax
    13cf:	cd 40                	int    $0x40
    13d1:	c3                   	ret    

000013d2 <shmem_access>:
SYSCALL(shmem_access)
    13d2:	b8 17 00 00 00       	mov    $0x17,%eax
    13d7:	cd 40                	int    $0x40
    13d9:	c3                   	ret    

000013da <shmem_count>:
SYSCALL(shmem_count)
    13da:	b8 18 00 00 00       	mov    $0x18,%eax
    13df:	cd 40                	int    $0x40
    13e1:	c3                   	ret    

000013e2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    13e2:	55                   	push   %ebp
    13e3:	89 e5                	mov    %esp,%ebp
    13e5:	83 ec 18             	sub    $0x18,%esp
    13e8:	8b 45 0c             	mov    0xc(%ebp),%eax
    13eb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    13ee:	83 ec 04             	sub    $0x4,%esp
    13f1:	6a 01                	push   $0x1
    13f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13f6:	50                   	push   %eax
    13f7:	ff 75 08             	pushl  0x8(%ebp)
    13fa:	e8 4b ff ff ff       	call   134a <write>
    13ff:	83 c4 10             	add    $0x10,%esp
}
    1402:	90                   	nop
    1403:	c9                   	leave  
    1404:	c3                   	ret    

00001405 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1405:	55                   	push   %ebp
    1406:	89 e5                	mov    %esp,%ebp
    1408:	53                   	push   %ebx
    1409:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    140c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1413:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1417:	74 17                	je     1430 <printint+0x2b>
    1419:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    141d:	79 11                	jns    1430 <printint+0x2b>
    neg = 1;
    141f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1426:	8b 45 0c             	mov    0xc(%ebp),%eax
    1429:	f7 d8                	neg    %eax
    142b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    142e:	eb 06                	jmp    1436 <printint+0x31>
  } else {
    x = xx;
    1430:	8b 45 0c             	mov    0xc(%ebp),%eax
    1433:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1436:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    143d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1440:	8d 41 01             	lea    0x1(%ecx),%eax
    1443:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1446:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1449:	8b 45 ec             	mov    -0x14(%ebp),%eax
    144c:	ba 00 00 00 00       	mov    $0x0,%edx
    1451:	f7 f3                	div    %ebx
    1453:	89 d0                	mov    %edx,%eax
    1455:	0f b6 80 2c 1b 00 00 	movzbl 0x1b2c(%eax),%eax
    145c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1460:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1463:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1466:	ba 00 00 00 00       	mov    $0x0,%edx
    146b:	f7 f3                	div    %ebx
    146d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1470:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1474:	75 c7                	jne    143d <printint+0x38>
  if(neg)
    1476:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    147a:	74 2d                	je     14a9 <printint+0xa4>
    buf[i++] = '-';
    147c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    147f:	8d 50 01             	lea    0x1(%eax),%edx
    1482:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1485:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    148a:	eb 1d                	jmp    14a9 <printint+0xa4>
    putc(fd, buf[i]);
    148c:	8d 55 dc             	lea    -0x24(%ebp),%edx
    148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1492:	01 d0                	add    %edx,%eax
    1494:	0f b6 00             	movzbl (%eax),%eax
    1497:	0f be c0             	movsbl %al,%eax
    149a:	83 ec 08             	sub    $0x8,%esp
    149d:	50                   	push   %eax
    149e:	ff 75 08             	pushl  0x8(%ebp)
    14a1:	e8 3c ff ff ff       	call   13e2 <putc>
    14a6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    14a9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    14ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14b1:	79 d9                	jns    148c <printint+0x87>
    putc(fd, buf[i]);
}
    14b3:	90                   	nop
    14b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    14b7:	c9                   	leave  
    14b8:	c3                   	ret    

000014b9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    14b9:	55                   	push   %ebp
    14ba:	89 e5                	mov    %esp,%ebp
    14bc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    14bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    14c6:	8d 45 0c             	lea    0xc(%ebp),%eax
    14c9:	83 c0 04             	add    $0x4,%eax
    14cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    14cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14d6:	e9 59 01 00 00       	jmp    1634 <printf+0x17b>
    c = fmt[i] & 0xff;
    14db:	8b 55 0c             	mov    0xc(%ebp),%edx
    14de:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14e1:	01 d0                	add    %edx,%eax
    14e3:	0f b6 00             	movzbl (%eax),%eax
    14e6:	0f be c0             	movsbl %al,%eax
    14e9:	25 ff 00 00 00       	and    $0xff,%eax
    14ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14f5:	75 2c                	jne    1523 <printf+0x6a>
      if(c == '%'){
    14f7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14fb:	75 0c                	jne    1509 <printf+0x50>
        state = '%';
    14fd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1504:	e9 27 01 00 00       	jmp    1630 <printf+0x177>
      } else {
        putc(fd, c);
    1509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    150c:	0f be c0             	movsbl %al,%eax
    150f:	83 ec 08             	sub    $0x8,%esp
    1512:	50                   	push   %eax
    1513:	ff 75 08             	pushl  0x8(%ebp)
    1516:	e8 c7 fe ff ff       	call   13e2 <putc>
    151b:	83 c4 10             	add    $0x10,%esp
    151e:	e9 0d 01 00 00       	jmp    1630 <printf+0x177>
      }
    } else if(state == '%'){
    1523:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1527:	0f 85 03 01 00 00    	jne    1630 <printf+0x177>
      if(c == 'd'){
    152d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1531:	75 1e                	jne    1551 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1533:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1536:	8b 00                	mov    (%eax),%eax
    1538:	6a 01                	push   $0x1
    153a:	6a 0a                	push   $0xa
    153c:	50                   	push   %eax
    153d:	ff 75 08             	pushl  0x8(%ebp)
    1540:	e8 c0 fe ff ff       	call   1405 <printint>
    1545:	83 c4 10             	add    $0x10,%esp
        ap++;
    1548:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    154c:	e9 d8 00 00 00       	jmp    1629 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    1551:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1555:	74 06                	je     155d <printf+0xa4>
    1557:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    155b:	75 1e                	jne    157b <printf+0xc2>
        printint(fd, *ap, 16, 0);
    155d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1560:	8b 00                	mov    (%eax),%eax
    1562:	6a 00                	push   $0x0
    1564:	6a 10                	push   $0x10
    1566:	50                   	push   %eax
    1567:	ff 75 08             	pushl  0x8(%ebp)
    156a:	e8 96 fe ff ff       	call   1405 <printint>
    156f:	83 c4 10             	add    $0x10,%esp
        ap++;
    1572:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1576:	e9 ae 00 00 00       	jmp    1629 <printf+0x170>
      } else if(c == 's'){
    157b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    157f:	75 43                	jne    15c4 <printf+0x10b>
        s = (char*)*ap;
    1581:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1584:	8b 00                	mov    (%eax),%eax
    1586:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1589:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    158d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1591:	75 25                	jne    15b8 <printf+0xff>
          s = "(null)";
    1593:	c7 45 f4 ba 18 00 00 	movl   $0x18ba,-0xc(%ebp)
        while(*s != 0){
    159a:	eb 1c                	jmp    15b8 <printf+0xff>
          putc(fd, *s);
    159c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    159f:	0f b6 00             	movzbl (%eax),%eax
    15a2:	0f be c0             	movsbl %al,%eax
    15a5:	83 ec 08             	sub    $0x8,%esp
    15a8:	50                   	push   %eax
    15a9:	ff 75 08             	pushl  0x8(%ebp)
    15ac:	e8 31 fe ff ff       	call   13e2 <putc>
    15b1:	83 c4 10             	add    $0x10,%esp
          s++;
    15b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    15b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15bb:	0f b6 00             	movzbl (%eax),%eax
    15be:	84 c0                	test   %al,%al
    15c0:	75 da                	jne    159c <printf+0xe3>
    15c2:	eb 65                	jmp    1629 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    15c4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    15c8:	75 1d                	jne    15e7 <printf+0x12e>
        putc(fd, *ap);
    15ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15cd:	8b 00                	mov    (%eax),%eax
    15cf:	0f be c0             	movsbl %al,%eax
    15d2:	83 ec 08             	sub    $0x8,%esp
    15d5:	50                   	push   %eax
    15d6:	ff 75 08             	pushl  0x8(%ebp)
    15d9:	e8 04 fe ff ff       	call   13e2 <putc>
    15de:	83 c4 10             	add    $0x10,%esp
        ap++;
    15e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15e5:	eb 42                	jmp    1629 <printf+0x170>
      } else if(c == '%'){
    15e7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15eb:	75 17                	jne    1604 <printf+0x14b>
        putc(fd, c);
    15ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15f0:	0f be c0             	movsbl %al,%eax
    15f3:	83 ec 08             	sub    $0x8,%esp
    15f6:	50                   	push   %eax
    15f7:	ff 75 08             	pushl  0x8(%ebp)
    15fa:	e8 e3 fd ff ff       	call   13e2 <putc>
    15ff:	83 c4 10             	add    $0x10,%esp
    1602:	eb 25                	jmp    1629 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1604:	83 ec 08             	sub    $0x8,%esp
    1607:	6a 25                	push   $0x25
    1609:	ff 75 08             	pushl  0x8(%ebp)
    160c:	e8 d1 fd ff ff       	call   13e2 <putc>
    1611:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1617:	0f be c0             	movsbl %al,%eax
    161a:	83 ec 08             	sub    $0x8,%esp
    161d:	50                   	push   %eax
    161e:	ff 75 08             	pushl  0x8(%ebp)
    1621:	e8 bc fd ff ff       	call   13e2 <putc>
    1626:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1629:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1630:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1634:	8b 55 0c             	mov    0xc(%ebp),%edx
    1637:	8b 45 f0             	mov    -0x10(%ebp),%eax
    163a:	01 d0                	add    %edx,%eax
    163c:	0f b6 00             	movzbl (%eax),%eax
    163f:	84 c0                	test   %al,%al
    1641:	0f 85 94 fe ff ff    	jne    14db <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1647:	90                   	nop
    1648:	c9                   	leave  
    1649:	c3                   	ret    

0000164a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    164a:	55                   	push   %ebp
    164b:	89 e5                	mov    %esp,%ebp
    164d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1650:	8b 45 08             	mov    0x8(%ebp),%eax
    1653:	83 e8 08             	sub    $0x8,%eax
    1656:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1659:	a1 48 1b 00 00       	mov    0x1b48,%eax
    165e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1661:	eb 24                	jmp    1687 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1663:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1666:	8b 00                	mov    (%eax),%eax
    1668:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    166b:	77 12                	ja     167f <free+0x35>
    166d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1670:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1673:	77 24                	ja     1699 <free+0x4f>
    1675:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1678:	8b 00                	mov    (%eax),%eax
    167a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    167d:	77 1a                	ja     1699 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1682:	8b 00                	mov    (%eax),%eax
    1684:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1687:	8b 45 f8             	mov    -0x8(%ebp),%eax
    168a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    168d:	76 d4                	jbe    1663 <free+0x19>
    168f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1692:	8b 00                	mov    (%eax),%eax
    1694:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1697:	76 ca                	jbe    1663 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1699:	8b 45 f8             	mov    -0x8(%ebp),%eax
    169c:	8b 40 04             	mov    0x4(%eax),%eax
    169f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a9:	01 c2                	add    %eax,%edx
    16ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ae:	8b 00                	mov    (%eax),%eax
    16b0:	39 c2                	cmp    %eax,%edx
    16b2:	75 24                	jne    16d8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    16b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b7:	8b 50 04             	mov    0x4(%eax),%edx
    16ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16bd:	8b 00                	mov    (%eax),%eax
    16bf:	8b 40 04             	mov    0x4(%eax),%eax
    16c2:	01 c2                	add    %eax,%edx
    16c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    16ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16cd:	8b 00                	mov    (%eax),%eax
    16cf:	8b 10                	mov    (%eax),%edx
    16d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d4:	89 10                	mov    %edx,(%eax)
    16d6:	eb 0a                	jmp    16e2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16db:	8b 10                	mov    (%eax),%edx
    16dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16e0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e5:	8b 40 04             	mov    0x4(%eax),%eax
    16e8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f2:	01 d0                	add    %edx,%eax
    16f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16f7:	75 20                	jne    1719 <free+0xcf>
    p->s.size += bp->s.size;
    16f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16fc:	8b 50 04             	mov    0x4(%eax),%edx
    16ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1702:	8b 40 04             	mov    0x4(%eax),%eax
    1705:	01 c2                	add    %eax,%edx
    1707:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    170d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1710:	8b 10                	mov    (%eax),%edx
    1712:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1715:	89 10                	mov    %edx,(%eax)
    1717:	eb 08                	jmp    1721 <free+0xd7>
  } else
    p->s.ptr = bp;
    1719:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    171f:	89 10                	mov    %edx,(%eax)
  freep = p;
    1721:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1724:	a3 48 1b 00 00       	mov    %eax,0x1b48
}
    1729:	90                   	nop
    172a:	c9                   	leave  
    172b:	c3                   	ret    

0000172c <morecore>:

static Header*
morecore(uint nu)
{
    172c:	55                   	push   %ebp
    172d:	89 e5                	mov    %esp,%ebp
    172f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1732:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1739:	77 07                	ja     1742 <morecore+0x16>
    nu = 4096;
    173b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1742:	8b 45 08             	mov    0x8(%ebp),%eax
    1745:	c1 e0 03             	shl    $0x3,%eax
    1748:	83 ec 0c             	sub    $0xc,%esp
    174b:	50                   	push   %eax
    174c:	e8 61 fc ff ff       	call   13b2 <sbrk>
    1751:	83 c4 10             	add    $0x10,%esp
    1754:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1757:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    175b:	75 07                	jne    1764 <morecore+0x38>
    return 0;
    175d:	b8 00 00 00 00       	mov    $0x0,%eax
    1762:	eb 26                	jmp    178a <morecore+0x5e>
  hp = (Header*)p;
    1764:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1767:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    176d:	8b 55 08             	mov    0x8(%ebp),%edx
    1770:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1773:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1776:	83 c0 08             	add    $0x8,%eax
    1779:	83 ec 0c             	sub    $0xc,%esp
    177c:	50                   	push   %eax
    177d:	e8 c8 fe ff ff       	call   164a <free>
    1782:	83 c4 10             	add    $0x10,%esp
  return freep;
    1785:	a1 48 1b 00 00       	mov    0x1b48,%eax
}
    178a:	c9                   	leave  
    178b:	c3                   	ret    

0000178c <malloc>:

void*
malloc(uint nbytes)
{
    178c:	55                   	push   %ebp
    178d:	89 e5                	mov    %esp,%ebp
    178f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1792:	8b 45 08             	mov    0x8(%ebp),%eax
    1795:	83 c0 07             	add    $0x7,%eax
    1798:	c1 e8 03             	shr    $0x3,%eax
    179b:	83 c0 01             	add    $0x1,%eax
    179e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    17a1:	a1 48 1b 00 00       	mov    0x1b48,%eax
    17a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17ad:	75 23                	jne    17d2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    17af:	c7 45 f0 40 1b 00 00 	movl   $0x1b40,-0x10(%ebp)
    17b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b9:	a3 48 1b 00 00       	mov    %eax,0x1b48
    17be:	a1 48 1b 00 00       	mov    0x1b48,%eax
    17c3:	a3 40 1b 00 00       	mov    %eax,0x1b40
    base.s.size = 0;
    17c8:	c7 05 44 1b 00 00 00 	movl   $0x0,0x1b44
    17cf:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17d5:	8b 00                	mov    (%eax),%eax
    17d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17dd:	8b 40 04             	mov    0x4(%eax),%eax
    17e0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17e3:	72 4d                	jb     1832 <malloc+0xa6>
      if(p->s.size == nunits)
    17e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e8:	8b 40 04             	mov    0x4(%eax),%eax
    17eb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17ee:	75 0c                	jne    17fc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f3:	8b 10                	mov    (%eax),%edx
    17f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17f8:	89 10                	mov    %edx,(%eax)
    17fa:	eb 26                	jmp    1822 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ff:	8b 40 04             	mov    0x4(%eax),%eax
    1802:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1805:	89 c2                	mov    %eax,%edx
    1807:	8b 45 f4             	mov    -0xc(%ebp),%eax
    180a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    180d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1810:	8b 40 04             	mov    0x4(%eax),%eax
    1813:	c1 e0 03             	shl    $0x3,%eax
    1816:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1819:	8b 45 f4             	mov    -0xc(%ebp),%eax
    181c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    181f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1822:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1825:	a3 48 1b 00 00       	mov    %eax,0x1b48
      return (void*)(p + 1);
    182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    182d:	83 c0 08             	add    $0x8,%eax
    1830:	eb 3b                	jmp    186d <malloc+0xe1>
    }
    if(p == freep)
    1832:	a1 48 1b 00 00       	mov    0x1b48,%eax
    1837:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    183a:	75 1e                	jne    185a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    183c:	83 ec 0c             	sub    $0xc,%esp
    183f:	ff 75 ec             	pushl  -0x14(%ebp)
    1842:	e8 e5 fe ff ff       	call   172c <morecore>
    1847:	83 c4 10             	add    $0x10,%esp
    184a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    184d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1851:	75 07                	jne    185a <malloc+0xce>
        return 0;
    1853:	b8 00 00 00 00       	mov    $0x0,%eax
    1858:	eb 13                	jmp    186d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1860:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1863:	8b 00                	mov    (%eax),%eax
    1865:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1868:	e9 6d ff ff ff       	jmp    17da <malloc+0x4e>
}
    186d:	c9                   	leave  
    186e:	c3                   	ret    
