
_stressfs:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	51                   	push   %ecx
    100e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
    1014:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
    101b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
    1022:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
    1028:	83 ec 08             	sub    $0x8,%esp
    102b:	68 ee 18 00 00       	push   $0x18ee
    1030:	6a 01                	push   $0x1
    1032:	e8 01 05 00 00       	call   1538 <printf>
    1037:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
    103a:	83 ec 04             	sub    $0x4,%esp
    103d:	68 00 02 00 00       	push   $0x200
    1042:	6a 61                	push   $0x61
    1044:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
    104a:	50                   	push   %eax
    104b:	e8 be 01 00 00       	call   120e <memset>
    1050:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
    1053:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    105a:	eb 0d                	jmp    1069 <main+0x69>
    if(fork() > 0)
    105c:	e8 40 03 00 00       	call   13a1 <fork>
    1061:	85 c0                	test   %eax,%eax
    1063:	7f 0c                	jg     1071 <main+0x71>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
    1065:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1069:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
    106d:	7e ed                	jle    105c <main+0x5c>
    106f:	eb 01                	jmp    1072 <main+0x72>
    if(fork() > 0)
      break;
    1071:	90                   	nop

  printf(1, "write %d\n", i);
    1072:	83 ec 04             	sub    $0x4,%esp
    1075:	ff 75 f4             	pushl  -0xc(%ebp)
    1078:	68 01 19 00 00       	push   $0x1901
    107d:	6a 01                	push   $0x1
    107f:	e8 b4 04 00 00       	call   1538 <printf>
    1084:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
    1087:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
    108b:	89 c2                	mov    %eax,%edx
    108d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1090:	01 d0                	add    %edx,%eax
    1092:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
    1095:	83 ec 08             	sub    $0x8,%esp
    1098:	68 02 02 00 00       	push   $0x202
    109d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    10a0:	50                   	push   %eax
    10a1:	e8 43 03 00 00       	call   13e9 <open>
    10a6:	83 c4 10             	add    $0x10,%esp
    10a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
    10ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10b3:	eb 1e                	jmp    10d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
    10b5:	83 ec 04             	sub    $0x4,%esp
    10b8:	68 00 02 00 00       	push   $0x200
    10bd:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
    10c3:	50                   	push   %eax
    10c4:	ff 75 f0             	pushl  -0x10(%ebp)
    10c7:	e8 fd 02 00 00       	call   13c9 <write>
    10cc:	83 c4 10             	add    $0x10,%esp

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
    10cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10d3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    10d7:	7e dc                	jle    10b5 <main+0xb5>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
    10d9:	83 ec 0c             	sub    $0xc,%esp
    10dc:	ff 75 f0             	pushl  -0x10(%ebp)
    10df:	e8 ed 02 00 00       	call   13d1 <close>
    10e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
    10e7:	83 ec 08             	sub    $0x8,%esp
    10ea:	68 0b 19 00 00       	push   $0x190b
    10ef:	6a 01                	push   $0x1
    10f1:	e8 42 04 00 00       	call   1538 <printf>
    10f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
    10f9:	83 ec 08             	sub    $0x8,%esp
    10fc:	6a 00                	push   $0x0
    10fe:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1101:	50                   	push   %eax
    1102:	e8 e2 02 00 00       	call   13e9 <open>
    1107:	83 c4 10             	add    $0x10,%esp
    110a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
    110d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1114:	eb 1e                	jmp    1134 <main+0x134>
    read(fd, data, sizeof(data));
    1116:	83 ec 04             	sub    $0x4,%esp
    1119:	68 00 02 00 00       	push   $0x200
    111e:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
    1124:	50                   	push   %eax
    1125:	ff 75 f0             	pushl  -0x10(%ebp)
    1128:	e8 94 02 00 00       	call   13c1 <read>
    112d:	83 c4 10             	add    $0x10,%esp
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
    1130:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1134:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1138:	7e dc                	jle    1116 <main+0x116>
    read(fd, data, sizeof(data));
  close(fd);
    113a:	83 ec 0c             	sub    $0xc,%esp
    113d:	ff 75 f0             	pushl  -0x10(%ebp)
    1140:	e8 8c 02 00 00       	call   13d1 <close>
    1145:	83 c4 10             	add    $0x10,%esp

  wait();
    1148:	e8 64 02 00 00       	call   13b1 <wait>

  exit();
    114d:	e8 57 02 00 00       	call   13a9 <exit>

00001152 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1152:	55                   	push   %ebp
    1153:	89 e5                	mov    %esp,%ebp
    1155:	57                   	push   %edi
    1156:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1157:	8b 4d 08             	mov    0x8(%ebp),%ecx
    115a:	8b 55 10             	mov    0x10(%ebp),%edx
    115d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1160:	89 cb                	mov    %ecx,%ebx
    1162:	89 df                	mov    %ebx,%edi
    1164:	89 d1                	mov    %edx,%ecx
    1166:	fc                   	cld    
    1167:	f3 aa                	rep stos %al,%es:(%edi)
    1169:	89 ca                	mov    %ecx,%edx
    116b:	89 fb                	mov    %edi,%ebx
    116d:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1170:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1173:	90                   	nop
    1174:	5b                   	pop    %ebx
    1175:	5f                   	pop    %edi
    1176:	5d                   	pop    %ebp
    1177:	c3                   	ret    

00001178 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1178:	55                   	push   %ebp
    1179:	89 e5                	mov    %esp,%ebp
    117b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    117e:	8b 45 08             	mov    0x8(%ebp),%eax
    1181:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1184:	90                   	nop
    1185:	8b 45 08             	mov    0x8(%ebp),%eax
    1188:	8d 50 01             	lea    0x1(%eax),%edx
    118b:	89 55 08             	mov    %edx,0x8(%ebp)
    118e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1191:	8d 4a 01             	lea    0x1(%edx),%ecx
    1194:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1197:	0f b6 12             	movzbl (%edx),%edx
    119a:	88 10                	mov    %dl,(%eax)
    119c:	0f b6 00             	movzbl (%eax),%eax
    119f:	84 c0                	test   %al,%al
    11a1:	75 e2                	jne    1185 <strcpy+0xd>
    ;
  return os;
    11a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11a6:	c9                   	leave  
    11a7:	c3                   	ret    

000011a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    11a8:	55                   	push   %ebp
    11a9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    11ab:	eb 08                	jmp    11b5 <strcmp+0xd>
    p++, q++;
    11ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11b1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    11b5:	8b 45 08             	mov    0x8(%ebp),%eax
    11b8:	0f b6 00             	movzbl (%eax),%eax
    11bb:	84 c0                	test   %al,%al
    11bd:	74 10                	je     11cf <strcmp+0x27>
    11bf:	8b 45 08             	mov    0x8(%ebp),%eax
    11c2:	0f b6 10             	movzbl (%eax),%edx
    11c5:	8b 45 0c             	mov    0xc(%ebp),%eax
    11c8:	0f b6 00             	movzbl (%eax),%eax
    11cb:	38 c2                	cmp    %al,%dl
    11cd:	74 de                	je     11ad <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    11cf:	8b 45 08             	mov    0x8(%ebp),%eax
    11d2:	0f b6 00             	movzbl (%eax),%eax
    11d5:	0f b6 d0             	movzbl %al,%edx
    11d8:	8b 45 0c             	mov    0xc(%ebp),%eax
    11db:	0f b6 00             	movzbl (%eax),%eax
    11de:	0f b6 c0             	movzbl %al,%eax
    11e1:	29 c2                	sub    %eax,%edx
    11e3:	89 d0                	mov    %edx,%eax
}
    11e5:	5d                   	pop    %ebp
    11e6:	c3                   	ret    

000011e7 <strlen>:

uint
strlen(const char *s)
{
    11e7:	55                   	push   %ebp
    11e8:	89 e5                	mov    %esp,%ebp
    11ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11f4:	eb 04                	jmp    11fa <strlen+0x13>
    11f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1200:	01 d0                	add    %edx,%eax
    1202:	0f b6 00             	movzbl (%eax),%eax
    1205:	84 c0                	test   %al,%al
    1207:	75 ed                	jne    11f6 <strlen+0xf>
    ;
  return n;
    1209:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    120c:	c9                   	leave  
    120d:	c3                   	ret    

0000120e <memset>:

void*
memset(void *dst, int c, uint n)
{
    120e:	55                   	push   %ebp
    120f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    1211:	8b 45 10             	mov    0x10(%ebp),%eax
    1214:	50                   	push   %eax
    1215:	ff 75 0c             	pushl  0xc(%ebp)
    1218:	ff 75 08             	pushl  0x8(%ebp)
    121b:	e8 32 ff ff ff       	call   1152 <stosb>
    1220:	83 c4 0c             	add    $0xc,%esp
  return dst;
    1223:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1226:	c9                   	leave  
    1227:	c3                   	ret    

00001228 <strchr>:

char*
strchr(const char *s, char c)
{
    1228:	55                   	push   %ebp
    1229:	89 e5                	mov    %esp,%ebp
    122b:	83 ec 04             	sub    $0x4,%esp
    122e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1234:	eb 14                	jmp    124a <strchr+0x22>
    if(*s == c)
    1236:	8b 45 08             	mov    0x8(%ebp),%eax
    1239:	0f b6 00             	movzbl (%eax),%eax
    123c:	3a 45 fc             	cmp    -0x4(%ebp),%al
    123f:	75 05                	jne    1246 <strchr+0x1e>
      return (char*)s;
    1241:	8b 45 08             	mov    0x8(%ebp),%eax
    1244:	eb 13                	jmp    1259 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    124a:	8b 45 08             	mov    0x8(%ebp),%eax
    124d:	0f b6 00             	movzbl (%eax),%eax
    1250:	84 c0                	test   %al,%al
    1252:	75 e2                	jne    1236 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1254:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1259:	c9                   	leave  
    125a:	c3                   	ret    

0000125b <gets>:

char*
gets(char *buf, int max)
{
    125b:	55                   	push   %ebp
    125c:	89 e5                	mov    %esp,%ebp
    125e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1268:	eb 42                	jmp    12ac <gets+0x51>
    cc = read(0, &c, 1);
    126a:	83 ec 04             	sub    $0x4,%esp
    126d:	6a 01                	push   $0x1
    126f:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1272:	50                   	push   %eax
    1273:	6a 00                	push   $0x0
    1275:	e8 47 01 00 00       	call   13c1 <read>
    127a:	83 c4 10             	add    $0x10,%esp
    127d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1284:	7e 33                	jle    12b9 <gets+0x5e>
      break;
    buf[i++] = c;
    1286:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1289:	8d 50 01             	lea    0x1(%eax),%edx
    128c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    128f:	89 c2                	mov    %eax,%edx
    1291:	8b 45 08             	mov    0x8(%ebp),%eax
    1294:	01 c2                	add    %eax,%edx
    1296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    129a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    129c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12a0:	3c 0a                	cmp    $0xa,%al
    12a2:	74 16                	je     12ba <gets+0x5f>
    12a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12a8:	3c 0d                	cmp    $0xd,%al
    12aa:	74 0e                	je     12ba <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12af:	83 c0 01             	add    $0x1,%eax
    12b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
    12b5:	7c b3                	jl     126a <gets+0xf>
    12b7:	eb 01                	jmp    12ba <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    12b9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    12ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
    12bd:	8b 45 08             	mov    0x8(%ebp),%eax
    12c0:	01 d0                	add    %edx,%eax
    12c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    12c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12c8:	c9                   	leave  
    12c9:	c3                   	ret    

000012ca <stat>:

int
stat(const char *n, struct stat *st)
{
    12ca:	55                   	push   %ebp
    12cb:	89 e5                	mov    %esp,%ebp
    12cd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12d0:	83 ec 08             	sub    $0x8,%esp
    12d3:	6a 00                	push   $0x0
    12d5:	ff 75 08             	pushl  0x8(%ebp)
    12d8:	e8 0c 01 00 00       	call   13e9 <open>
    12dd:	83 c4 10             	add    $0x10,%esp
    12e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12e7:	79 07                	jns    12f0 <stat+0x26>
    return -1;
    12e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12ee:	eb 25                	jmp    1315 <stat+0x4b>
  r = fstat(fd, st);
    12f0:	83 ec 08             	sub    $0x8,%esp
    12f3:	ff 75 0c             	pushl  0xc(%ebp)
    12f6:	ff 75 f4             	pushl  -0xc(%ebp)
    12f9:	e8 03 01 00 00       	call   1401 <fstat>
    12fe:	83 c4 10             	add    $0x10,%esp
    1301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1304:	83 ec 0c             	sub    $0xc,%esp
    1307:	ff 75 f4             	pushl  -0xc(%ebp)
    130a:	e8 c2 00 00 00       	call   13d1 <close>
    130f:	83 c4 10             	add    $0x10,%esp
  return r;
    1312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1315:	c9                   	leave  
    1316:	c3                   	ret    

00001317 <atoi>:

int
atoi(const char *s)
{
    1317:	55                   	push   %ebp
    1318:	89 e5                	mov    %esp,%ebp
    131a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    131d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1324:	eb 25                	jmp    134b <atoi+0x34>
    n = n*10 + *s++ - '0';
    1326:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1329:	89 d0                	mov    %edx,%eax
    132b:	c1 e0 02             	shl    $0x2,%eax
    132e:	01 d0                	add    %edx,%eax
    1330:	01 c0                	add    %eax,%eax
    1332:	89 c1                	mov    %eax,%ecx
    1334:	8b 45 08             	mov    0x8(%ebp),%eax
    1337:	8d 50 01             	lea    0x1(%eax),%edx
    133a:	89 55 08             	mov    %edx,0x8(%ebp)
    133d:	0f b6 00             	movzbl (%eax),%eax
    1340:	0f be c0             	movsbl %al,%eax
    1343:	01 c8                	add    %ecx,%eax
    1345:	83 e8 30             	sub    $0x30,%eax
    1348:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    134b:	8b 45 08             	mov    0x8(%ebp),%eax
    134e:	0f b6 00             	movzbl (%eax),%eax
    1351:	3c 2f                	cmp    $0x2f,%al
    1353:	7e 0a                	jle    135f <atoi+0x48>
    1355:	8b 45 08             	mov    0x8(%ebp),%eax
    1358:	0f b6 00             	movzbl (%eax),%eax
    135b:	3c 39                	cmp    $0x39,%al
    135d:	7e c7                	jle    1326 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    135f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1362:	c9                   	leave  
    1363:	c3                   	ret    

00001364 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1364:	55                   	push   %ebp
    1365:	89 e5                	mov    %esp,%ebp
    1367:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    136a:	8b 45 08             	mov    0x8(%ebp),%eax
    136d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1370:	8b 45 0c             	mov    0xc(%ebp),%eax
    1373:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1376:	eb 17                	jmp    138f <memmove+0x2b>
    *dst++ = *src++;
    1378:	8b 45 fc             	mov    -0x4(%ebp),%eax
    137b:	8d 50 01             	lea    0x1(%eax),%edx
    137e:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1381:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1384:	8d 4a 01             	lea    0x1(%edx),%ecx
    1387:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    138a:	0f b6 12             	movzbl (%edx),%edx
    138d:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    138f:	8b 45 10             	mov    0x10(%ebp),%eax
    1392:	8d 50 ff             	lea    -0x1(%eax),%edx
    1395:	89 55 10             	mov    %edx,0x10(%ebp)
    1398:	85 c0                	test   %eax,%eax
    139a:	7f dc                	jg     1378 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    139c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    139f:	c9                   	leave  
    13a0:	c3                   	ret    

000013a1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    13a1:	b8 01 00 00 00       	mov    $0x1,%eax
    13a6:	cd 40                	int    $0x40
    13a8:	c3                   	ret    

000013a9 <exit>:
SYSCALL(exit)
    13a9:	b8 02 00 00 00       	mov    $0x2,%eax
    13ae:	cd 40                	int    $0x40
    13b0:	c3                   	ret    

000013b1 <wait>:
SYSCALL(wait)
    13b1:	b8 03 00 00 00       	mov    $0x3,%eax
    13b6:	cd 40                	int    $0x40
    13b8:	c3                   	ret    

000013b9 <pipe>:
SYSCALL(pipe)
    13b9:	b8 04 00 00 00       	mov    $0x4,%eax
    13be:	cd 40                	int    $0x40
    13c0:	c3                   	ret    

000013c1 <read>:
SYSCALL(read)
    13c1:	b8 05 00 00 00       	mov    $0x5,%eax
    13c6:	cd 40                	int    $0x40
    13c8:	c3                   	ret    

000013c9 <write>:
SYSCALL(write)
    13c9:	b8 10 00 00 00       	mov    $0x10,%eax
    13ce:	cd 40                	int    $0x40
    13d0:	c3                   	ret    

000013d1 <close>:
SYSCALL(close)
    13d1:	b8 15 00 00 00       	mov    $0x15,%eax
    13d6:	cd 40                	int    $0x40
    13d8:	c3                   	ret    

000013d9 <kill>:
SYSCALL(kill)
    13d9:	b8 06 00 00 00       	mov    $0x6,%eax
    13de:	cd 40                	int    $0x40
    13e0:	c3                   	ret    

000013e1 <exec>:
SYSCALL(exec)
    13e1:	b8 07 00 00 00       	mov    $0x7,%eax
    13e6:	cd 40                	int    $0x40
    13e8:	c3                   	ret    

000013e9 <open>:
SYSCALL(open)
    13e9:	b8 0f 00 00 00       	mov    $0xf,%eax
    13ee:	cd 40                	int    $0x40
    13f0:	c3                   	ret    

000013f1 <mknod>:
SYSCALL(mknod)
    13f1:	b8 11 00 00 00       	mov    $0x11,%eax
    13f6:	cd 40                	int    $0x40
    13f8:	c3                   	ret    

000013f9 <unlink>:
SYSCALL(unlink)
    13f9:	b8 12 00 00 00       	mov    $0x12,%eax
    13fe:	cd 40                	int    $0x40
    1400:	c3                   	ret    

00001401 <fstat>:
SYSCALL(fstat)
    1401:	b8 08 00 00 00       	mov    $0x8,%eax
    1406:	cd 40                	int    $0x40
    1408:	c3                   	ret    

00001409 <link>:
SYSCALL(link)
    1409:	b8 13 00 00 00       	mov    $0x13,%eax
    140e:	cd 40                	int    $0x40
    1410:	c3                   	ret    

00001411 <mkdir>:
SYSCALL(mkdir)
    1411:	b8 14 00 00 00       	mov    $0x14,%eax
    1416:	cd 40                	int    $0x40
    1418:	c3                   	ret    

00001419 <chdir>:
SYSCALL(chdir)
    1419:	b8 09 00 00 00       	mov    $0x9,%eax
    141e:	cd 40                	int    $0x40
    1420:	c3                   	ret    

00001421 <dup>:
SYSCALL(dup)
    1421:	b8 0a 00 00 00       	mov    $0xa,%eax
    1426:	cd 40                	int    $0x40
    1428:	c3                   	ret    

00001429 <getpid>:
SYSCALL(getpid)
    1429:	b8 0b 00 00 00       	mov    $0xb,%eax
    142e:	cd 40                	int    $0x40
    1430:	c3                   	ret    

00001431 <sbrk>:
SYSCALL(sbrk)
    1431:	b8 0c 00 00 00       	mov    $0xc,%eax
    1436:	cd 40                	int    $0x40
    1438:	c3                   	ret    

00001439 <sleep>:
SYSCALL(sleep)
    1439:	b8 0d 00 00 00       	mov    $0xd,%eax
    143e:	cd 40                	int    $0x40
    1440:	c3                   	ret    

00001441 <uptime>:
SYSCALL(uptime)
    1441:	b8 0e 00 00 00       	mov    $0xe,%eax
    1446:	cd 40                	int    $0x40
    1448:	c3                   	ret    

00001449 <getprocsinfo>:
SYSCALL(getprocsinfo)
    1449:	b8 16 00 00 00       	mov    $0x16,%eax
    144e:	cd 40                	int    $0x40
    1450:	c3                   	ret    

00001451 <shmem_access>:
SYSCALL(shmem_access)
    1451:	b8 17 00 00 00       	mov    $0x17,%eax
    1456:	cd 40                	int    $0x40
    1458:	c3                   	ret    

00001459 <shmem_count>:
SYSCALL(shmem_count)
    1459:	b8 18 00 00 00       	mov    $0x18,%eax
    145e:	cd 40                	int    $0x40
    1460:	c3                   	ret    

00001461 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1461:	55                   	push   %ebp
    1462:	89 e5                	mov    %esp,%ebp
    1464:	83 ec 18             	sub    $0x18,%esp
    1467:	8b 45 0c             	mov    0xc(%ebp),%eax
    146a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    146d:	83 ec 04             	sub    $0x4,%esp
    1470:	6a 01                	push   $0x1
    1472:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1475:	50                   	push   %eax
    1476:	ff 75 08             	pushl  0x8(%ebp)
    1479:	e8 4b ff ff ff       	call   13c9 <write>
    147e:	83 c4 10             	add    $0x10,%esp
}
    1481:	90                   	nop
    1482:	c9                   	leave  
    1483:	c3                   	ret    

00001484 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1484:	55                   	push   %ebp
    1485:	89 e5                	mov    %esp,%ebp
    1487:	53                   	push   %ebx
    1488:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    148b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1492:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1496:	74 17                	je     14af <printint+0x2b>
    1498:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    149c:	79 11                	jns    14af <printint+0x2b>
    neg = 1;
    149e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    14a5:	8b 45 0c             	mov    0xc(%ebp),%eax
    14a8:	f7 d8                	neg    %eax
    14aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14ad:	eb 06                	jmp    14b5 <printint+0x31>
  } else {
    x = xx;
    14af:	8b 45 0c             	mov    0xc(%ebp),%eax
    14b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    14bc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14bf:	8d 41 01             	lea    0x1(%ecx),%eax
    14c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14cb:	ba 00 00 00 00       	mov    $0x0,%edx
    14d0:	f7 f3                	div    %ebx
    14d2:	89 d0                	mov    %edx,%eax
    14d4:	0f b6 80 60 1b 00 00 	movzbl 0x1b60(%eax),%eax
    14db:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14df:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14e5:	ba 00 00 00 00       	mov    $0x0,%edx
    14ea:	f7 f3                	div    %ebx
    14ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14f3:	75 c7                	jne    14bc <printint+0x38>
  if(neg)
    14f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14f9:	74 2d                	je     1528 <printint+0xa4>
    buf[i++] = '-';
    14fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14fe:	8d 50 01             	lea    0x1(%eax),%edx
    1501:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1504:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1509:	eb 1d                	jmp    1528 <printint+0xa4>
    putc(fd, buf[i]);
    150b:	8d 55 dc             	lea    -0x24(%ebp),%edx
    150e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1511:	01 d0                	add    %edx,%eax
    1513:	0f b6 00             	movzbl (%eax),%eax
    1516:	0f be c0             	movsbl %al,%eax
    1519:	83 ec 08             	sub    $0x8,%esp
    151c:	50                   	push   %eax
    151d:	ff 75 08             	pushl  0x8(%ebp)
    1520:	e8 3c ff ff ff       	call   1461 <putc>
    1525:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1528:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    152c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1530:	79 d9                	jns    150b <printint+0x87>
    putc(fd, buf[i]);
}
    1532:	90                   	nop
    1533:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1536:	c9                   	leave  
    1537:	c3                   	ret    

00001538 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1538:	55                   	push   %ebp
    1539:	89 e5                	mov    %esp,%ebp
    153b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    153e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1545:	8d 45 0c             	lea    0xc(%ebp),%eax
    1548:	83 c0 04             	add    $0x4,%eax
    154b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    154e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1555:	e9 59 01 00 00       	jmp    16b3 <printf+0x17b>
    c = fmt[i] & 0xff;
    155a:	8b 55 0c             	mov    0xc(%ebp),%edx
    155d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1560:	01 d0                	add    %edx,%eax
    1562:	0f b6 00             	movzbl (%eax),%eax
    1565:	0f be c0             	movsbl %al,%eax
    1568:	25 ff 00 00 00       	and    $0xff,%eax
    156d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1570:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1574:	75 2c                	jne    15a2 <printf+0x6a>
      if(c == '%'){
    1576:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    157a:	75 0c                	jne    1588 <printf+0x50>
        state = '%';
    157c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1583:	e9 27 01 00 00       	jmp    16af <printf+0x177>
      } else {
        putc(fd, c);
    1588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    158b:	0f be c0             	movsbl %al,%eax
    158e:	83 ec 08             	sub    $0x8,%esp
    1591:	50                   	push   %eax
    1592:	ff 75 08             	pushl  0x8(%ebp)
    1595:	e8 c7 fe ff ff       	call   1461 <putc>
    159a:	83 c4 10             	add    $0x10,%esp
    159d:	e9 0d 01 00 00       	jmp    16af <printf+0x177>
      }
    } else if(state == '%'){
    15a2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    15a6:	0f 85 03 01 00 00    	jne    16af <printf+0x177>
      if(c == 'd'){
    15ac:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15b0:	75 1e                	jne    15d0 <printf+0x98>
        printint(fd, *ap, 10, 1);
    15b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15b5:	8b 00                	mov    (%eax),%eax
    15b7:	6a 01                	push   $0x1
    15b9:	6a 0a                	push   $0xa
    15bb:	50                   	push   %eax
    15bc:	ff 75 08             	pushl  0x8(%ebp)
    15bf:	e8 c0 fe ff ff       	call   1484 <printint>
    15c4:	83 c4 10             	add    $0x10,%esp
        ap++;
    15c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15cb:	e9 d8 00 00 00       	jmp    16a8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    15d0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15d4:	74 06                	je     15dc <printf+0xa4>
    15d6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15da:	75 1e                	jne    15fa <printf+0xc2>
        printint(fd, *ap, 16, 0);
    15dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15df:	8b 00                	mov    (%eax),%eax
    15e1:	6a 00                	push   $0x0
    15e3:	6a 10                	push   $0x10
    15e5:	50                   	push   %eax
    15e6:	ff 75 08             	pushl  0x8(%ebp)
    15e9:	e8 96 fe ff ff       	call   1484 <printint>
    15ee:	83 c4 10             	add    $0x10,%esp
        ap++;
    15f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15f5:	e9 ae 00 00 00       	jmp    16a8 <printf+0x170>
      } else if(c == 's'){
    15fa:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15fe:	75 43                	jne    1643 <printf+0x10b>
        s = (char*)*ap;
    1600:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1603:	8b 00                	mov    (%eax),%eax
    1605:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1608:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    160c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1610:	75 25                	jne    1637 <printf+0xff>
          s = "(null)";
    1612:	c7 45 f4 11 19 00 00 	movl   $0x1911,-0xc(%ebp)
        while(*s != 0){
    1619:	eb 1c                	jmp    1637 <printf+0xff>
          putc(fd, *s);
    161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    161e:	0f b6 00             	movzbl (%eax),%eax
    1621:	0f be c0             	movsbl %al,%eax
    1624:	83 ec 08             	sub    $0x8,%esp
    1627:	50                   	push   %eax
    1628:	ff 75 08             	pushl  0x8(%ebp)
    162b:	e8 31 fe ff ff       	call   1461 <putc>
    1630:	83 c4 10             	add    $0x10,%esp
          s++;
    1633:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1637:	8b 45 f4             	mov    -0xc(%ebp),%eax
    163a:	0f b6 00             	movzbl (%eax),%eax
    163d:	84 c0                	test   %al,%al
    163f:	75 da                	jne    161b <printf+0xe3>
    1641:	eb 65                	jmp    16a8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1643:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1647:	75 1d                	jne    1666 <printf+0x12e>
        putc(fd, *ap);
    1649:	8b 45 e8             	mov    -0x18(%ebp),%eax
    164c:	8b 00                	mov    (%eax),%eax
    164e:	0f be c0             	movsbl %al,%eax
    1651:	83 ec 08             	sub    $0x8,%esp
    1654:	50                   	push   %eax
    1655:	ff 75 08             	pushl  0x8(%ebp)
    1658:	e8 04 fe ff ff       	call   1461 <putc>
    165d:	83 c4 10             	add    $0x10,%esp
        ap++;
    1660:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1664:	eb 42                	jmp    16a8 <printf+0x170>
      } else if(c == '%'){
    1666:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    166a:	75 17                	jne    1683 <printf+0x14b>
        putc(fd, c);
    166c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    166f:	0f be c0             	movsbl %al,%eax
    1672:	83 ec 08             	sub    $0x8,%esp
    1675:	50                   	push   %eax
    1676:	ff 75 08             	pushl  0x8(%ebp)
    1679:	e8 e3 fd ff ff       	call   1461 <putc>
    167e:	83 c4 10             	add    $0x10,%esp
    1681:	eb 25                	jmp    16a8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1683:	83 ec 08             	sub    $0x8,%esp
    1686:	6a 25                	push   $0x25
    1688:	ff 75 08             	pushl  0x8(%ebp)
    168b:	e8 d1 fd ff ff       	call   1461 <putc>
    1690:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1696:	0f be c0             	movsbl %al,%eax
    1699:	83 ec 08             	sub    $0x8,%esp
    169c:	50                   	push   %eax
    169d:	ff 75 08             	pushl  0x8(%ebp)
    16a0:	e8 bc fd ff ff       	call   1461 <putc>
    16a5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    16a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16af:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16b3:	8b 55 0c             	mov    0xc(%ebp),%edx
    16b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16b9:	01 d0                	add    %edx,%eax
    16bb:	0f b6 00             	movzbl (%eax),%eax
    16be:	84 c0                	test   %al,%al
    16c0:	0f 85 94 fe ff ff    	jne    155a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16c6:	90                   	nop
    16c7:	c9                   	leave  
    16c8:	c3                   	ret    

000016c9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16c9:	55                   	push   %ebp
    16ca:	89 e5                	mov    %esp,%ebp
    16cc:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16cf:	8b 45 08             	mov    0x8(%ebp),%eax
    16d2:	83 e8 08             	sub    $0x8,%eax
    16d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16d8:	a1 7c 1b 00 00       	mov    0x1b7c,%eax
    16dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16e0:	eb 24                	jmp    1706 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e5:	8b 00                	mov    (%eax),%eax
    16e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16ea:	77 12                	ja     16fe <free+0x35>
    16ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16f2:	77 24                	ja     1718 <free+0x4f>
    16f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f7:	8b 00                	mov    (%eax),%eax
    16f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16fc:	77 1a                	ja     1718 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1701:	8b 00                	mov    (%eax),%eax
    1703:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1706:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1709:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    170c:	76 d4                	jbe    16e2 <free+0x19>
    170e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1711:	8b 00                	mov    (%eax),%eax
    1713:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1716:	76 ca                	jbe    16e2 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1718:	8b 45 f8             	mov    -0x8(%ebp),%eax
    171b:	8b 40 04             	mov    0x4(%eax),%eax
    171e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1725:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1728:	01 c2                	add    %eax,%edx
    172a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172d:	8b 00                	mov    (%eax),%eax
    172f:	39 c2                	cmp    %eax,%edx
    1731:	75 24                	jne    1757 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1733:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1736:	8b 50 04             	mov    0x4(%eax),%edx
    1739:	8b 45 fc             	mov    -0x4(%ebp),%eax
    173c:	8b 00                	mov    (%eax),%eax
    173e:	8b 40 04             	mov    0x4(%eax),%eax
    1741:	01 c2                	add    %eax,%edx
    1743:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1746:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1749:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174c:	8b 00                	mov    (%eax),%eax
    174e:	8b 10                	mov    (%eax),%edx
    1750:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1753:	89 10                	mov    %edx,(%eax)
    1755:	eb 0a                	jmp    1761 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1757:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175a:	8b 10                	mov    (%eax),%edx
    175c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    175f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1761:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1764:	8b 40 04             	mov    0x4(%eax),%eax
    1767:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    176e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1771:	01 d0                	add    %edx,%eax
    1773:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1776:	75 20                	jne    1798 <free+0xcf>
    p->s.size += bp->s.size;
    1778:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177b:	8b 50 04             	mov    0x4(%eax),%edx
    177e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1781:	8b 40 04             	mov    0x4(%eax),%eax
    1784:	01 c2                	add    %eax,%edx
    1786:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1789:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    178c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    178f:	8b 10                	mov    (%eax),%edx
    1791:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1794:	89 10                	mov    %edx,(%eax)
    1796:	eb 08                	jmp    17a0 <free+0xd7>
  } else
    p->s.ptr = bp;
    1798:	8b 45 fc             	mov    -0x4(%ebp),%eax
    179b:	8b 55 f8             	mov    -0x8(%ebp),%edx
    179e:	89 10                	mov    %edx,(%eax)
  freep = p;
    17a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a3:	a3 7c 1b 00 00       	mov    %eax,0x1b7c
}
    17a8:	90                   	nop
    17a9:	c9                   	leave  
    17aa:	c3                   	ret    

000017ab <morecore>:

static Header*
morecore(uint nu)
{
    17ab:	55                   	push   %ebp
    17ac:	89 e5                	mov    %esp,%ebp
    17ae:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17b1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17b8:	77 07                	ja     17c1 <morecore+0x16>
    nu = 4096;
    17ba:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17c1:	8b 45 08             	mov    0x8(%ebp),%eax
    17c4:	c1 e0 03             	shl    $0x3,%eax
    17c7:	83 ec 0c             	sub    $0xc,%esp
    17ca:	50                   	push   %eax
    17cb:	e8 61 fc ff ff       	call   1431 <sbrk>
    17d0:	83 c4 10             	add    $0x10,%esp
    17d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17d6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17da:	75 07                	jne    17e3 <morecore+0x38>
    return 0;
    17dc:	b8 00 00 00 00       	mov    $0x0,%eax
    17e1:	eb 26                	jmp    1809 <morecore+0x5e>
  hp = (Header*)p;
    17e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ec:	8b 55 08             	mov    0x8(%ebp),%edx
    17ef:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17f5:	83 c0 08             	add    $0x8,%eax
    17f8:	83 ec 0c             	sub    $0xc,%esp
    17fb:	50                   	push   %eax
    17fc:	e8 c8 fe ff ff       	call   16c9 <free>
    1801:	83 c4 10             	add    $0x10,%esp
  return freep;
    1804:	a1 7c 1b 00 00       	mov    0x1b7c,%eax
}
    1809:	c9                   	leave  
    180a:	c3                   	ret    

0000180b <malloc>:

void*
malloc(uint nbytes)
{
    180b:	55                   	push   %ebp
    180c:	89 e5                	mov    %esp,%ebp
    180e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1811:	8b 45 08             	mov    0x8(%ebp),%eax
    1814:	83 c0 07             	add    $0x7,%eax
    1817:	c1 e8 03             	shr    $0x3,%eax
    181a:	83 c0 01             	add    $0x1,%eax
    181d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1820:	a1 7c 1b 00 00       	mov    0x1b7c,%eax
    1825:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1828:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    182c:	75 23                	jne    1851 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    182e:	c7 45 f0 74 1b 00 00 	movl   $0x1b74,-0x10(%ebp)
    1835:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1838:	a3 7c 1b 00 00       	mov    %eax,0x1b7c
    183d:	a1 7c 1b 00 00       	mov    0x1b7c,%eax
    1842:	a3 74 1b 00 00       	mov    %eax,0x1b74
    base.s.size = 0;
    1847:	c7 05 78 1b 00 00 00 	movl   $0x0,0x1b78
    184e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1851:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1854:	8b 00                	mov    (%eax),%eax
    1856:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1859:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185c:	8b 40 04             	mov    0x4(%eax),%eax
    185f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1862:	72 4d                	jb     18b1 <malloc+0xa6>
      if(p->s.size == nunits)
    1864:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1867:	8b 40 04             	mov    0x4(%eax),%eax
    186a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    186d:	75 0c                	jne    187b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    186f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1872:	8b 10                	mov    (%eax),%edx
    1874:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1877:	89 10                	mov    %edx,(%eax)
    1879:	eb 26                	jmp    18a1 <malloc+0x96>
      else {
        p->s.size -= nunits;
    187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187e:	8b 40 04             	mov    0x4(%eax),%eax
    1881:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1884:	89 c2                	mov    %eax,%edx
    1886:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1889:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    188f:	8b 40 04             	mov    0x4(%eax),%eax
    1892:	c1 e0 03             	shl    $0x3,%eax
    1895:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1898:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    189e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18a4:	a3 7c 1b 00 00       	mov    %eax,0x1b7c
      return (void*)(p + 1);
    18a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ac:	83 c0 08             	add    $0x8,%eax
    18af:	eb 3b                	jmp    18ec <malloc+0xe1>
    }
    if(p == freep)
    18b1:	a1 7c 1b 00 00       	mov    0x1b7c,%eax
    18b6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18b9:	75 1e                	jne    18d9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    18bb:	83 ec 0c             	sub    $0xc,%esp
    18be:	ff 75 ec             	pushl  -0x14(%ebp)
    18c1:	e8 e5 fe ff ff       	call   17ab <morecore>
    18c6:	83 c4 10             	add    $0x10,%esp
    18c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18d0:	75 07                	jne    18d9 <malloc+0xce>
        return 0;
    18d2:	b8 00 00 00 00       	mov    $0x0,%eax
    18d7:	eb 13                	jmp    18ec <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18df:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18e2:	8b 00                	mov    (%eax),%eax
    18e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18e7:	e9 6d ff ff ff       	jmp    1859 <malloc+0x4e>
}
    18ec:	c9                   	leave  
    18ed:	c3                   	ret    
