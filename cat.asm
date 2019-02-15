
_cat:     file format elf32-i386


Disassembly of section .text:

00001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    1006:	eb 31                	jmp    1039 <cat+0x39>
    if (write(1, buf, n) != n) {
    1008:	83 ec 04             	sub    $0x4,%esp
    100b:	ff 75 f4             	pushl  -0xc(%ebp)
    100e:	68 c0 1b 00 00       	push   $0x1bc0
    1013:	6a 01                	push   $0x1
    1015:	e8 88 03 00 00       	call   13a2 <write>
    101a:	83 c4 10             	add    $0x10,%esp
    101d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1020:	74 17                	je     1039 <cat+0x39>
      printf(1, "cat: write error\n");
    1022:	83 ec 08             	sub    $0x8,%esp
    1025:	68 c7 18 00 00       	push   $0x18c7
    102a:	6a 01                	push   $0x1
    102c:	e8 e0 04 00 00       	call   1511 <printf>
    1031:	83 c4 10             	add    $0x10,%esp
      exit();
    1034:	e8 49 03 00 00       	call   1382 <exit>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    1039:	83 ec 04             	sub    $0x4,%esp
    103c:	68 00 02 00 00       	push   $0x200
    1041:	68 c0 1b 00 00       	push   $0x1bc0
    1046:	ff 75 08             	pushl  0x8(%ebp)
    1049:	e8 4c 03 00 00       	call   139a <read>
    104e:	83 c4 10             	add    $0x10,%esp
    1051:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1054:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1058:	7f ae                	jg     1008 <cat+0x8>
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
      exit();
    }
  }
  if(n < 0){
    105a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    105e:	79 17                	jns    1077 <cat+0x77>
    printf(1, "cat: read error\n");
    1060:	83 ec 08             	sub    $0x8,%esp
    1063:	68 d9 18 00 00       	push   $0x18d9
    1068:	6a 01                	push   $0x1
    106a:	e8 a2 04 00 00       	call   1511 <printf>
    106f:	83 c4 10             	add    $0x10,%esp
    exit();
    1072:	e8 0b 03 00 00       	call   1382 <exit>
  }
}
    1077:	90                   	nop
    1078:	c9                   	leave  
    1079:	c3                   	ret    

0000107a <main>:

int
main(int argc, char *argv[])
{
    107a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    107e:	83 e4 f0             	and    $0xfffffff0,%esp
    1081:	ff 71 fc             	pushl  -0x4(%ecx)
    1084:	55                   	push   %ebp
    1085:	89 e5                	mov    %esp,%ebp
    1087:	53                   	push   %ebx
    1088:	51                   	push   %ecx
    1089:	83 ec 10             	sub    $0x10,%esp
    108c:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
    108e:	83 3b 01             	cmpl   $0x1,(%ebx)
    1091:	7f 12                	jg     10a5 <main+0x2b>
    cat(0);
    1093:	83 ec 0c             	sub    $0xc,%esp
    1096:	6a 00                	push   $0x0
    1098:	e8 63 ff ff ff       	call   1000 <cat>
    109d:	83 c4 10             	add    $0x10,%esp
    exit();
    10a0:	e8 dd 02 00 00       	call   1382 <exit>
  }

  for(i = 1; i < argc; i++){
    10a5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    10ac:	eb 71                	jmp    111f <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
    10ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    10b8:	8b 43 04             	mov    0x4(%ebx),%eax
    10bb:	01 d0                	add    %edx,%eax
    10bd:	8b 00                	mov    (%eax),%eax
    10bf:	83 ec 08             	sub    $0x8,%esp
    10c2:	6a 00                	push   $0x0
    10c4:	50                   	push   %eax
    10c5:	e8 f8 02 00 00       	call   13c2 <open>
    10ca:	83 c4 10             	add    $0x10,%esp
    10cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    10d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10d4:	79 29                	jns    10ff <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
    10d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    10e0:	8b 43 04             	mov    0x4(%ebx),%eax
    10e3:	01 d0                	add    %edx,%eax
    10e5:	8b 00                	mov    (%eax),%eax
    10e7:	83 ec 04             	sub    $0x4,%esp
    10ea:	50                   	push   %eax
    10eb:	68 ea 18 00 00       	push   $0x18ea
    10f0:	6a 01                	push   $0x1
    10f2:	e8 1a 04 00 00       	call   1511 <printf>
    10f7:	83 c4 10             	add    $0x10,%esp
      exit();
    10fa:	e8 83 02 00 00       	call   1382 <exit>
    }
    cat(fd);
    10ff:	83 ec 0c             	sub    $0xc,%esp
    1102:	ff 75 f0             	pushl  -0x10(%ebp)
    1105:	e8 f6 fe ff ff       	call   1000 <cat>
    110a:	83 c4 10             	add    $0x10,%esp
    close(fd);
    110d:	83 ec 0c             	sub    $0xc,%esp
    1110:	ff 75 f0             	pushl  -0x10(%ebp)
    1113:	e8 92 02 00 00       	call   13aa <close>
    1118:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    111b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    111f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1122:	3b 03                	cmp    (%ebx),%eax
    1124:	7c 88                	jl     10ae <main+0x34>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
    1126:	e8 57 02 00 00       	call   1382 <exit>

0000112b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    112b:	55                   	push   %ebp
    112c:	89 e5                	mov    %esp,%ebp
    112e:	57                   	push   %edi
    112f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1130:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1133:	8b 55 10             	mov    0x10(%ebp),%edx
    1136:	8b 45 0c             	mov    0xc(%ebp),%eax
    1139:	89 cb                	mov    %ecx,%ebx
    113b:	89 df                	mov    %ebx,%edi
    113d:	89 d1                	mov    %edx,%ecx
    113f:	fc                   	cld    
    1140:	f3 aa                	rep stos %al,%es:(%edi)
    1142:	89 ca                	mov    %ecx,%edx
    1144:	89 fb                	mov    %edi,%ebx
    1146:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1149:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    114c:	90                   	nop
    114d:	5b                   	pop    %ebx
    114e:	5f                   	pop    %edi
    114f:	5d                   	pop    %ebp
    1150:	c3                   	ret    

00001151 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1151:	55                   	push   %ebp
    1152:	89 e5                	mov    %esp,%ebp
    1154:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1157:	8b 45 08             	mov    0x8(%ebp),%eax
    115a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    115d:	90                   	nop
    115e:	8b 45 08             	mov    0x8(%ebp),%eax
    1161:	8d 50 01             	lea    0x1(%eax),%edx
    1164:	89 55 08             	mov    %edx,0x8(%ebp)
    1167:	8b 55 0c             	mov    0xc(%ebp),%edx
    116a:	8d 4a 01             	lea    0x1(%edx),%ecx
    116d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1170:	0f b6 12             	movzbl (%edx),%edx
    1173:	88 10                	mov    %dl,(%eax)
    1175:	0f b6 00             	movzbl (%eax),%eax
    1178:	84 c0                	test   %al,%al
    117a:	75 e2                	jne    115e <strcpy+0xd>
    ;
  return os;
    117c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    117f:	c9                   	leave  
    1180:	c3                   	ret    

00001181 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1181:	55                   	push   %ebp
    1182:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1184:	eb 08                	jmp    118e <strcmp+0xd>
    p++, q++;
    1186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    118a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    118e:	8b 45 08             	mov    0x8(%ebp),%eax
    1191:	0f b6 00             	movzbl (%eax),%eax
    1194:	84 c0                	test   %al,%al
    1196:	74 10                	je     11a8 <strcmp+0x27>
    1198:	8b 45 08             	mov    0x8(%ebp),%eax
    119b:	0f b6 10             	movzbl (%eax),%edx
    119e:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a1:	0f b6 00             	movzbl (%eax),%eax
    11a4:	38 c2                	cmp    %al,%dl
    11a6:	74 de                	je     1186 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    11a8:	8b 45 08             	mov    0x8(%ebp),%eax
    11ab:	0f b6 00             	movzbl (%eax),%eax
    11ae:	0f b6 d0             	movzbl %al,%edx
    11b1:	8b 45 0c             	mov    0xc(%ebp),%eax
    11b4:	0f b6 00             	movzbl (%eax),%eax
    11b7:	0f b6 c0             	movzbl %al,%eax
    11ba:	29 c2                	sub    %eax,%edx
    11bc:	89 d0                	mov    %edx,%eax
}
    11be:	5d                   	pop    %ebp
    11bf:	c3                   	ret    

000011c0 <strlen>:

uint
strlen(const char *s)
{
    11c0:	55                   	push   %ebp
    11c1:	89 e5                	mov    %esp,%ebp
    11c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11cd:	eb 04                	jmp    11d3 <strlen+0x13>
    11cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11d6:	8b 45 08             	mov    0x8(%ebp),%eax
    11d9:	01 d0                	add    %edx,%eax
    11db:	0f b6 00             	movzbl (%eax),%eax
    11de:	84 c0                	test   %al,%al
    11e0:	75 ed                	jne    11cf <strlen+0xf>
    ;
  return n;
    11e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11e5:	c9                   	leave  
    11e6:	c3                   	ret    

000011e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11e7:	55                   	push   %ebp
    11e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    11ea:	8b 45 10             	mov    0x10(%ebp),%eax
    11ed:	50                   	push   %eax
    11ee:	ff 75 0c             	pushl  0xc(%ebp)
    11f1:	ff 75 08             	pushl  0x8(%ebp)
    11f4:	e8 32 ff ff ff       	call   112b <stosb>
    11f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
    11fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ff:	c9                   	leave  
    1200:	c3                   	ret    

00001201 <strchr>:

char*
strchr(const char *s, char c)
{
    1201:	55                   	push   %ebp
    1202:	89 e5                	mov    %esp,%ebp
    1204:	83 ec 04             	sub    $0x4,%esp
    1207:	8b 45 0c             	mov    0xc(%ebp),%eax
    120a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    120d:	eb 14                	jmp    1223 <strchr+0x22>
    if(*s == c)
    120f:	8b 45 08             	mov    0x8(%ebp),%eax
    1212:	0f b6 00             	movzbl (%eax),%eax
    1215:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1218:	75 05                	jne    121f <strchr+0x1e>
      return (char*)s;
    121a:	8b 45 08             	mov    0x8(%ebp),%eax
    121d:	eb 13                	jmp    1232 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    121f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1223:	8b 45 08             	mov    0x8(%ebp),%eax
    1226:	0f b6 00             	movzbl (%eax),%eax
    1229:	84 c0                	test   %al,%al
    122b:	75 e2                	jne    120f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    122d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1232:	c9                   	leave  
    1233:	c3                   	ret    

00001234 <gets>:

char*
gets(char *buf, int max)
{
    1234:	55                   	push   %ebp
    1235:	89 e5                	mov    %esp,%ebp
    1237:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    123a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1241:	eb 42                	jmp    1285 <gets+0x51>
    cc = read(0, &c, 1);
    1243:	83 ec 04             	sub    $0x4,%esp
    1246:	6a 01                	push   $0x1
    1248:	8d 45 ef             	lea    -0x11(%ebp),%eax
    124b:	50                   	push   %eax
    124c:	6a 00                	push   $0x0
    124e:	e8 47 01 00 00       	call   139a <read>
    1253:	83 c4 10             	add    $0x10,%esp
    1256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1259:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    125d:	7e 33                	jle    1292 <gets+0x5e>
      break;
    buf[i++] = c;
    125f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1262:	8d 50 01             	lea    0x1(%eax),%edx
    1265:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1268:	89 c2                	mov    %eax,%edx
    126a:	8b 45 08             	mov    0x8(%ebp),%eax
    126d:	01 c2                	add    %eax,%edx
    126f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1273:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1275:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1279:	3c 0a                	cmp    $0xa,%al
    127b:	74 16                	je     1293 <gets+0x5f>
    127d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1281:	3c 0d                	cmp    $0xd,%al
    1283:	74 0e                	je     1293 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1285:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1288:	83 c0 01             	add    $0x1,%eax
    128b:	3b 45 0c             	cmp    0xc(%ebp),%eax
    128e:	7c b3                	jl     1243 <gets+0xf>
    1290:	eb 01                	jmp    1293 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1292:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1293:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1296:	8b 45 08             	mov    0x8(%ebp),%eax
    1299:	01 d0                	add    %edx,%eax
    129b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    129e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12a1:	c9                   	leave  
    12a2:	c3                   	ret    

000012a3 <stat>:

int
stat(const char *n, struct stat *st)
{
    12a3:	55                   	push   %ebp
    12a4:	89 e5                	mov    %esp,%ebp
    12a6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12a9:	83 ec 08             	sub    $0x8,%esp
    12ac:	6a 00                	push   $0x0
    12ae:	ff 75 08             	pushl  0x8(%ebp)
    12b1:	e8 0c 01 00 00       	call   13c2 <open>
    12b6:	83 c4 10             	add    $0x10,%esp
    12b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12c0:	79 07                	jns    12c9 <stat+0x26>
    return -1;
    12c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12c7:	eb 25                	jmp    12ee <stat+0x4b>
  r = fstat(fd, st);
    12c9:	83 ec 08             	sub    $0x8,%esp
    12cc:	ff 75 0c             	pushl  0xc(%ebp)
    12cf:	ff 75 f4             	pushl  -0xc(%ebp)
    12d2:	e8 03 01 00 00       	call   13da <fstat>
    12d7:	83 c4 10             	add    $0x10,%esp
    12da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12dd:	83 ec 0c             	sub    $0xc,%esp
    12e0:	ff 75 f4             	pushl  -0xc(%ebp)
    12e3:	e8 c2 00 00 00       	call   13aa <close>
    12e8:	83 c4 10             	add    $0x10,%esp
  return r;
    12eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12ee:	c9                   	leave  
    12ef:	c3                   	ret    

000012f0 <atoi>:

int
atoi(const char *s)
{
    12f0:	55                   	push   %ebp
    12f1:	89 e5                	mov    %esp,%ebp
    12f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12fd:	eb 25                	jmp    1324 <atoi+0x34>
    n = n*10 + *s++ - '0';
    12ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1302:	89 d0                	mov    %edx,%eax
    1304:	c1 e0 02             	shl    $0x2,%eax
    1307:	01 d0                	add    %edx,%eax
    1309:	01 c0                	add    %eax,%eax
    130b:	89 c1                	mov    %eax,%ecx
    130d:	8b 45 08             	mov    0x8(%ebp),%eax
    1310:	8d 50 01             	lea    0x1(%eax),%edx
    1313:	89 55 08             	mov    %edx,0x8(%ebp)
    1316:	0f b6 00             	movzbl (%eax),%eax
    1319:	0f be c0             	movsbl %al,%eax
    131c:	01 c8                	add    %ecx,%eax
    131e:	83 e8 30             	sub    $0x30,%eax
    1321:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1324:	8b 45 08             	mov    0x8(%ebp),%eax
    1327:	0f b6 00             	movzbl (%eax),%eax
    132a:	3c 2f                	cmp    $0x2f,%al
    132c:	7e 0a                	jle    1338 <atoi+0x48>
    132e:	8b 45 08             	mov    0x8(%ebp),%eax
    1331:	0f b6 00             	movzbl (%eax),%eax
    1334:	3c 39                	cmp    $0x39,%al
    1336:	7e c7                	jle    12ff <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1338:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    133b:	c9                   	leave  
    133c:	c3                   	ret    

0000133d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    133d:	55                   	push   %ebp
    133e:	89 e5                	mov    %esp,%ebp
    1340:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    1343:	8b 45 08             	mov    0x8(%ebp),%eax
    1346:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1349:	8b 45 0c             	mov    0xc(%ebp),%eax
    134c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    134f:	eb 17                	jmp    1368 <memmove+0x2b>
    *dst++ = *src++;
    1351:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1354:	8d 50 01             	lea    0x1(%eax),%edx
    1357:	89 55 fc             	mov    %edx,-0x4(%ebp)
    135a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    135d:	8d 4a 01             	lea    0x1(%edx),%ecx
    1360:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1363:	0f b6 12             	movzbl (%edx),%edx
    1366:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1368:	8b 45 10             	mov    0x10(%ebp),%eax
    136b:	8d 50 ff             	lea    -0x1(%eax),%edx
    136e:	89 55 10             	mov    %edx,0x10(%ebp)
    1371:	85 c0                	test   %eax,%eax
    1373:	7f dc                	jg     1351 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1375:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1378:	c9                   	leave  
    1379:	c3                   	ret    

0000137a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    137a:	b8 01 00 00 00       	mov    $0x1,%eax
    137f:	cd 40                	int    $0x40
    1381:	c3                   	ret    

00001382 <exit>:
SYSCALL(exit)
    1382:	b8 02 00 00 00       	mov    $0x2,%eax
    1387:	cd 40                	int    $0x40
    1389:	c3                   	ret    

0000138a <wait>:
SYSCALL(wait)
    138a:	b8 03 00 00 00       	mov    $0x3,%eax
    138f:	cd 40                	int    $0x40
    1391:	c3                   	ret    

00001392 <pipe>:
SYSCALL(pipe)
    1392:	b8 04 00 00 00       	mov    $0x4,%eax
    1397:	cd 40                	int    $0x40
    1399:	c3                   	ret    

0000139a <read>:
SYSCALL(read)
    139a:	b8 05 00 00 00       	mov    $0x5,%eax
    139f:	cd 40                	int    $0x40
    13a1:	c3                   	ret    

000013a2 <write>:
SYSCALL(write)
    13a2:	b8 10 00 00 00       	mov    $0x10,%eax
    13a7:	cd 40                	int    $0x40
    13a9:	c3                   	ret    

000013aa <close>:
SYSCALL(close)
    13aa:	b8 15 00 00 00       	mov    $0x15,%eax
    13af:	cd 40                	int    $0x40
    13b1:	c3                   	ret    

000013b2 <kill>:
SYSCALL(kill)
    13b2:	b8 06 00 00 00       	mov    $0x6,%eax
    13b7:	cd 40                	int    $0x40
    13b9:	c3                   	ret    

000013ba <exec>:
SYSCALL(exec)
    13ba:	b8 07 00 00 00       	mov    $0x7,%eax
    13bf:	cd 40                	int    $0x40
    13c1:	c3                   	ret    

000013c2 <open>:
SYSCALL(open)
    13c2:	b8 0f 00 00 00       	mov    $0xf,%eax
    13c7:	cd 40                	int    $0x40
    13c9:	c3                   	ret    

000013ca <mknod>:
SYSCALL(mknod)
    13ca:	b8 11 00 00 00       	mov    $0x11,%eax
    13cf:	cd 40                	int    $0x40
    13d1:	c3                   	ret    

000013d2 <unlink>:
SYSCALL(unlink)
    13d2:	b8 12 00 00 00       	mov    $0x12,%eax
    13d7:	cd 40                	int    $0x40
    13d9:	c3                   	ret    

000013da <fstat>:
SYSCALL(fstat)
    13da:	b8 08 00 00 00       	mov    $0x8,%eax
    13df:	cd 40                	int    $0x40
    13e1:	c3                   	ret    

000013e2 <link>:
SYSCALL(link)
    13e2:	b8 13 00 00 00       	mov    $0x13,%eax
    13e7:	cd 40                	int    $0x40
    13e9:	c3                   	ret    

000013ea <mkdir>:
SYSCALL(mkdir)
    13ea:	b8 14 00 00 00       	mov    $0x14,%eax
    13ef:	cd 40                	int    $0x40
    13f1:	c3                   	ret    

000013f2 <chdir>:
SYSCALL(chdir)
    13f2:	b8 09 00 00 00       	mov    $0x9,%eax
    13f7:	cd 40                	int    $0x40
    13f9:	c3                   	ret    

000013fa <dup>:
SYSCALL(dup)
    13fa:	b8 0a 00 00 00       	mov    $0xa,%eax
    13ff:	cd 40                	int    $0x40
    1401:	c3                   	ret    

00001402 <getpid>:
SYSCALL(getpid)
    1402:	b8 0b 00 00 00       	mov    $0xb,%eax
    1407:	cd 40                	int    $0x40
    1409:	c3                   	ret    

0000140a <sbrk>:
SYSCALL(sbrk)
    140a:	b8 0c 00 00 00       	mov    $0xc,%eax
    140f:	cd 40                	int    $0x40
    1411:	c3                   	ret    

00001412 <sleep>:
SYSCALL(sleep)
    1412:	b8 0d 00 00 00       	mov    $0xd,%eax
    1417:	cd 40                	int    $0x40
    1419:	c3                   	ret    

0000141a <uptime>:
SYSCALL(uptime)
    141a:	b8 0e 00 00 00       	mov    $0xe,%eax
    141f:	cd 40                	int    $0x40
    1421:	c3                   	ret    

00001422 <getprocsinfo>:
SYSCALL(getprocsinfo)
    1422:	b8 16 00 00 00       	mov    $0x16,%eax
    1427:	cd 40                	int    $0x40
    1429:	c3                   	ret    

0000142a <shmem_access>:
SYSCALL(shmem_access)
    142a:	b8 17 00 00 00       	mov    $0x17,%eax
    142f:	cd 40                	int    $0x40
    1431:	c3                   	ret    

00001432 <shmem_count>:
SYSCALL(shmem_count)
    1432:	b8 18 00 00 00       	mov    $0x18,%eax
    1437:	cd 40                	int    $0x40
    1439:	c3                   	ret    

0000143a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    143a:	55                   	push   %ebp
    143b:	89 e5                	mov    %esp,%ebp
    143d:	83 ec 18             	sub    $0x18,%esp
    1440:	8b 45 0c             	mov    0xc(%ebp),%eax
    1443:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1446:	83 ec 04             	sub    $0x4,%esp
    1449:	6a 01                	push   $0x1
    144b:	8d 45 f4             	lea    -0xc(%ebp),%eax
    144e:	50                   	push   %eax
    144f:	ff 75 08             	pushl  0x8(%ebp)
    1452:	e8 4b ff ff ff       	call   13a2 <write>
    1457:	83 c4 10             	add    $0x10,%esp
}
    145a:	90                   	nop
    145b:	c9                   	leave  
    145c:	c3                   	ret    

0000145d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    145d:	55                   	push   %ebp
    145e:	89 e5                	mov    %esp,%ebp
    1460:	53                   	push   %ebx
    1461:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1464:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    146b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    146f:	74 17                	je     1488 <printint+0x2b>
    1471:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1475:	79 11                	jns    1488 <printint+0x2b>
    neg = 1;
    1477:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    147e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1481:	f7 d8                	neg    %eax
    1483:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1486:	eb 06                	jmp    148e <printint+0x31>
  } else {
    x = xx;
    1488:	8b 45 0c             	mov    0xc(%ebp),%eax
    148b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    148e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1495:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1498:	8d 41 01             	lea    0x1(%ecx),%eax
    149b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    149e:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14a4:	ba 00 00 00 00       	mov    $0x0,%edx
    14a9:	f7 f3                	div    %ebx
    14ab:	89 d0                	mov    %edx,%eax
    14ad:	0f b6 80 74 1b 00 00 	movzbl 0x1b74(%eax),%eax
    14b4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14be:	ba 00 00 00 00       	mov    $0x0,%edx
    14c3:	f7 f3                	div    %ebx
    14c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14cc:	75 c7                	jne    1495 <printint+0x38>
  if(neg)
    14ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14d2:	74 2d                	je     1501 <printint+0xa4>
    buf[i++] = '-';
    14d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d7:	8d 50 01             	lea    0x1(%eax),%edx
    14da:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14dd:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    14e2:	eb 1d                	jmp    1501 <printint+0xa4>
    putc(fd, buf[i]);
    14e4:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ea:	01 d0                	add    %edx,%eax
    14ec:	0f b6 00             	movzbl (%eax),%eax
    14ef:	0f be c0             	movsbl %al,%eax
    14f2:	83 ec 08             	sub    $0x8,%esp
    14f5:	50                   	push   %eax
    14f6:	ff 75 08             	pushl  0x8(%ebp)
    14f9:	e8 3c ff ff ff       	call   143a <putc>
    14fe:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1501:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1509:	79 d9                	jns    14e4 <printint+0x87>
    putc(fd, buf[i]);
}
    150b:	90                   	nop
    150c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    150f:	c9                   	leave  
    1510:	c3                   	ret    

00001511 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1511:	55                   	push   %ebp
    1512:	89 e5                	mov    %esp,%ebp
    1514:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1517:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    151e:	8d 45 0c             	lea    0xc(%ebp),%eax
    1521:	83 c0 04             	add    $0x4,%eax
    1524:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1527:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    152e:	e9 59 01 00 00       	jmp    168c <printf+0x17b>
    c = fmt[i] & 0xff;
    1533:	8b 55 0c             	mov    0xc(%ebp),%edx
    1536:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1539:	01 d0                	add    %edx,%eax
    153b:	0f b6 00             	movzbl (%eax),%eax
    153e:	0f be c0             	movsbl %al,%eax
    1541:	25 ff 00 00 00       	and    $0xff,%eax
    1546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1549:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    154d:	75 2c                	jne    157b <printf+0x6a>
      if(c == '%'){
    154f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1553:	75 0c                	jne    1561 <printf+0x50>
        state = '%';
    1555:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    155c:	e9 27 01 00 00       	jmp    1688 <printf+0x177>
      } else {
        putc(fd, c);
    1561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1564:	0f be c0             	movsbl %al,%eax
    1567:	83 ec 08             	sub    $0x8,%esp
    156a:	50                   	push   %eax
    156b:	ff 75 08             	pushl  0x8(%ebp)
    156e:	e8 c7 fe ff ff       	call   143a <putc>
    1573:	83 c4 10             	add    $0x10,%esp
    1576:	e9 0d 01 00 00       	jmp    1688 <printf+0x177>
      }
    } else if(state == '%'){
    157b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    157f:	0f 85 03 01 00 00    	jne    1688 <printf+0x177>
      if(c == 'd'){
    1585:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1589:	75 1e                	jne    15a9 <printf+0x98>
        printint(fd, *ap, 10, 1);
    158b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    158e:	8b 00                	mov    (%eax),%eax
    1590:	6a 01                	push   $0x1
    1592:	6a 0a                	push   $0xa
    1594:	50                   	push   %eax
    1595:	ff 75 08             	pushl  0x8(%ebp)
    1598:	e8 c0 fe ff ff       	call   145d <printint>
    159d:	83 c4 10             	add    $0x10,%esp
        ap++;
    15a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15a4:	e9 d8 00 00 00       	jmp    1681 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    15a9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15ad:	74 06                	je     15b5 <printf+0xa4>
    15af:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15b3:	75 1e                	jne    15d3 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    15b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15b8:	8b 00                	mov    (%eax),%eax
    15ba:	6a 00                	push   $0x0
    15bc:	6a 10                	push   $0x10
    15be:	50                   	push   %eax
    15bf:	ff 75 08             	pushl  0x8(%ebp)
    15c2:	e8 96 fe ff ff       	call   145d <printint>
    15c7:	83 c4 10             	add    $0x10,%esp
        ap++;
    15ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15ce:	e9 ae 00 00 00       	jmp    1681 <printf+0x170>
      } else if(c == 's'){
    15d3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15d7:	75 43                	jne    161c <printf+0x10b>
        s = (char*)*ap;
    15d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15dc:	8b 00                	mov    (%eax),%eax
    15de:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    15e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    15e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15e9:	75 25                	jne    1610 <printf+0xff>
          s = "(null)";
    15eb:	c7 45 f4 ff 18 00 00 	movl   $0x18ff,-0xc(%ebp)
        while(*s != 0){
    15f2:	eb 1c                	jmp    1610 <printf+0xff>
          putc(fd, *s);
    15f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15f7:	0f b6 00             	movzbl (%eax),%eax
    15fa:	0f be c0             	movsbl %al,%eax
    15fd:	83 ec 08             	sub    $0x8,%esp
    1600:	50                   	push   %eax
    1601:	ff 75 08             	pushl  0x8(%ebp)
    1604:	e8 31 fe ff ff       	call   143a <putc>
    1609:	83 c4 10             	add    $0x10,%esp
          s++;
    160c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1610:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1613:	0f b6 00             	movzbl (%eax),%eax
    1616:	84 c0                	test   %al,%al
    1618:	75 da                	jne    15f4 <printf+0xe3>
    161a:	eb 65                	jmp    1681 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    161c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1620:	75 1d                	jne    163f <printf+0x12e>
        putc(fd, *ap);
    1622:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1625:	8b 00                	mov    (%eax),%eax
    1627:	0f be c0             	movsbl %al,%eax
    162a:	83 ec 08             	sub    $0x8,%esp
    162d:	50                   	push   %eax
    162e:	ff 75 08             	pushl  0x8(%ebp)
    1631:	e8 04 fe ff ff       	call   143a <putc>
    1636:	83 c4 10             	add    $0x10,%esp
        ap++;
    1639:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    163d:	eb 42                	jmp    1681 <printf+0x170>
      } else if(c == '%'){
    163f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1643:	75 17                	jne    165c <printf+0x14b>
        putc(fd, c);
    1645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1648:	0f be c0             	movsbl %al,%eax
    164b:	83 ec 08             	sub    $0x8,%esp
    164e:	50                   	push   %eax
    164f:	ff 75 08             	pushl  0x8(%ebp)
    1652:	e8 e3 fd ff ff       	call   143a <putc>
    1657:	83 c4 10             	add    $0x10,%esp
    165a:	eb 25                	jmp    1681 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    165c:	83 ec 08             	sub    $0x8,%esp
    165f:	6a 25                	push   $0x25
    1661:	ff 75 08             	pushl  0x8(%ebp)
    1664:	e8 d1 fd ff ff       	call   143a <putc>
    1669:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    166c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    166f:	0f be c0             	movsbl %al,%eax
    1672:	83 ec 08             	sub    $0x8,%esp
    1675:	50                   	push   %eax
    1676:	ff 75 08             	pushl  0x8(%ebp)
    1679:	e8 bc fd ff ff       	call   143a <putc>
    167e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1681:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1688:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    168c:	8b 55 0c             	mov    0xc(%ebp),%edx
    168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1692:	01 d0                	add    %edx,%eax
    1694:	0f b6 00             	movzbl (%eax),%eax
    1697:	84 c0                	test   %al,%al
    1699:	0f 85 94 fe ff ff    	jne    1533 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    169f:	90                   	nop
    16a0:	c9                   	leave  
    16a1:	c3                   	ret    

000016a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16a2:	55                   	push   %ebp
    16a3:	89 e5                	mov    %esp,%ebp
    16a5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16a8:	8b 45 08             	mov    0x8(%ebp),%eax
    16ab:	83 e8 08             	sub    $0x8,%eax
    16ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16b1:	a1 a8 1b 00 00       	mov    0x1ba8,%eax
    16b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16b9:	eb 24                	jmp    16df <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16be:	8b 00                	mov    (%eax),%eax
    16c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16c3:	77 12                	ja     16d7 <free+0x35>
    16c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16cb:	77 24                	ja     16f1 <free+0x4f>
    16cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d0:	8b 00                	mov    (%eax),%eax
    16d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16d5:	77 1a                	ja     16f1 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16da:	8b 00                	mov    (%eax),%eax
    16dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16df:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16e5:	76 d4                	jbe    16bb <free+0x19>
    16e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ea:	8b 00                	mov    (%eax),%eax
    16ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16ef:	76 ca                	jbe    16bb <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    16f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16f4:	8b 40 04             	mov    0x4(%eax),%eax
    16f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1701:	01 c2                	add    %eax,%edx
    1703:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1706:	8b 00                	mov    (%eax),%eax
    1708:	39 c2                	cmp    %eax,%edx
    170a:	75 24                	jne    1730 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    170c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170f:	8b 50 04             	mov    0x4(%eax),%edx
    1712:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1715:	8b 00                	mov    (%eax),%eax
    1717:	8b 40 04             	mov    0x4(%eax),%eax
    171a:	01 c2                	add    %eax,%edx
    171c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    171f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1722:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1725:	8b 00                	mov    (%eax),%eax
    1727:	8b 10                	mov    (%eax),%edx
    1729:	8b 45 f8             	mov    -0x8(%ebp),%eax
    172c:	89 10                	mov    %edx,(%eax)
    172e:	eb 0a                	jmp    173a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1730:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1733:	8b 10                	mov    (%eax),%edx
    1735:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1738:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    173a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    173d:	8b 40 04             	mov    0x4(%eax),%eax
    1740:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1747:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174a:	01 d0                	add    %edx,%eax
    174c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    174f:	75 20                	jne    1771 <free+0xcf>
    p->s.size += bp->s.size;
    1751:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1754:	8b 50 04             	mov    0x4(%eax),%edx
    1757:	8b 45 f8             	mov    -0x8(%ebp),%eax
    175a:	8b 40 04             	mov    0x4(%eax),%eax
    175d:	01 c2                	add    %eax,%edx
    175f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1762:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1765:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1768:	8b 10                	mov    (%eax),%edx
    176a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176d:	89 10                	mov    %edx,(%eax)
    176f:	eb 08                	jmp    1779 <free+0xd7>
  } else
    p->s.ptr = bp;
    1771:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1774:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1777:	89 10                	mov    %edx,(%eax)
  freep = p;
    1779:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177c:	a3 a8 1b 00 00       	mov    %eax,0x1ba8
}
    1781:	90                   	nop
    1782:	c9                   	leave  
    1783:	c3                   	ret    

00001784 <morecore>:

static Header*
morecore(uint nu)
{
    1784:	55                   	push   %ebp
    1785:	89 e5                	mov    %esp,%ebp
    1787:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    178a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1791:	77 07                	ja     179a <morecore+0x16>
    nu = 4096;
    1793:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    179a:	8b 45 08             	mov    0x8(%ebp),%eax
    179d:	c1 e0 03             	shl    $0x3,%eax
    17a0:	83 ec 0c             	sub    $0xc,%esp
    17a3:	50                   	push   %eax
    17a4:	e8 61 fc ff ff       	call   140a <sbrk>
    17a9:	83 c4 10             	add    $0x10,%esp
    17ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17af:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17b3:	75 07                	jne    17bc <morecore+0x38>
    return 0;
    17b5:	b8 00 00 00 00       	mov    $0x0,%eax
    17ba:	eb 26                	jmp    17e2 <morecore+0x5e>
  hp = (Header*)p;
    17bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17c5:	8b 55 08             	mov    0x8(%ebp),%edx
    17c8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ce:	83 c0 08             	add    $0x8,%eax
    17d1:	83 ec 0c             	sub    $0xc,%esp
    17d4:	50                   	push   %eax
    17d5:	e8 c8 fe ff ff       	call   16a2 <free>
    17da:	83 c4 10             	add    $0x10,%esp
  return freep;
    17dd:	a1 a8 1b 00 00       	mov    0x1ba8,%eax
}
    17e2:	c9                   	leave  
    17e3:	c3                   	ret    

000017e4 <malloc>:

void*
malloc(uint nbytes)
{
    17e4:	55                   	push   %ebp
    17e5:	89 e5                	mov    %esp,%ebp
    17e7:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17ea:	8b 45 08             	mov    0x8(%ebp),%eax
    17ed:	83 c0 07             	add    $0x7,%eax
    17f0:	c1 e8 03             	shr    $0x3,%eax
    17f3:	83 c0 01             	add    $0x1,%eax
    17f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    17f9:	a1 a8 1b 00 00       	mov    0x1ba8,%eax
    17fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1801:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1805:	75 23                	jne    182a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1807:	c7 45 f0 a0 1b 00 00 	movl   $0x1ba0,-0x10(%ebp)
    180e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1811:	a3 a8 1b 00 00       	mov    %eax,0x1ba8
    1816:	a1 a8 1b 00 00       	mov    0x1ba8,%eax
    181b:	a3 a0 1b 00 00       	mov    %eax,0x1ba0
    base.s.size = 0;
    1820:	c7 05 a4 1b 00 00 00 	movl   $0x0,0x1ba4
    1827:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    182a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    182d:	8b 00                	mov    (%eax),%eax
    182f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1832:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1835:	8b 40 04             	mov    0x4(%eax),%eax
    1838:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    183b:	72 4d                	jb     188a <malloc+0xa6>
      if(p->s.size == nunits)
    183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1840:	8b 40 04             	mov    0x4(%eax),%eax
    1843:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1846:	75 0c                	jne    1854 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1848:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184b:	8b 10                	mov    (%eax),%edx
    184d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1850:	89 10                	mov    %edx,(%eax)
    1852:	eb 26                	jmp    187a <malloc+0x96>
      else {
        p->s.size -= nunits;
    1854:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1857:	8b 40 04             	mov    0x4(%eax),%eax
    185a:	2b 45 ec             	sub    -0x14(%ebp),%eax
    185d:	89 c2                	mov    %eax,%edx
    185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1862:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1865:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1868:	8b 40 04             	mov    0x4(%eax),%eax
    186b:	c1 e0 03             	shl    $0x3,%eax
    186e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1871:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1874:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1877:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    187a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    187d:	a3 a8 1b 00 00       	mov    %eax,0x1ba8
      return (void*)(p + 1);
    1882:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1885:	83 c0 08             	add    $0x8,%eax
    1888:	eb 3b                	jmp    18c5 <malloc+0xe1>
    }
    if(p == freep)
    188a:	a1 a8 1b 00 00       	mov    0x1ba8,%eax
    188f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1892:	75 1e                	jne    18b2 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    1894:	83 ec 0c             	sub    $0xc,%esp
    1897:	ff 75 ec             	pushl  -0x14(%ebp)
    189a:	e8 e5 fe ff ff       	call   1784 <morecore>
    189f:	83 c4 10             	add    $0x10,%esp
    18a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18a9:	75 07                	jne    18b2 <malloc+0xce>
        return 0;
    18ab:	b8 00 00 00 00       	mov    $0x0,%eax
    18b0:	eb 13                	jmp    18c5 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18bb:	8b 00                	mov    (%eax),%eax
    18bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18c0:	e9 6d ff ff ff       	jmp    1832 <malloc+0x4e>
}
    18c5:	c9                   	leave  
    18c6:	c3                   	ret    
