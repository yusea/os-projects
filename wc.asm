
_wc:     file format elf32-i386


Disassembly of section .text:

00001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
    1006:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    100d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1010:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1013:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
    1019:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1020:	eb 69                	jmp    108b <wc+0x8b>
    for(i=0; i<n; i++){
    1022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1029:	eb 58                	jmp    1083 <wc+0x83>
      c++;
    102b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
    102f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1032:	05 40 1c 00 00       	add    $0x1c40,%eax
    1037:	0f b6 00             	movzbl (%eax),%eax
    103a:	3c 0a                	cmp    $0xa,%al
    103c:	75 04                	jne    1042 <wc+0x42>
        l++;
    103e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
    1042:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1045:	05 40 1c 00 00       	add    $0x1c40,%eax
    104a:	0f b6 00             	movzbl (%eax),%eax
    104d:	0f be c0             	movsbl %al,%eax
    1050:	83 ec 08             	sub    $0x8,%esp
    1053:	50                   	push   %eax
    1054:	68 59 19 00 00       	push   $0x1959
    1059:	e8 35 02 00 00       	call   1293 <strchr>
    105e:	83 c4 10             	add    $0x10,%esp
    1061:	85 c0                	test   %eax,%eax
    1063:	74 09                	je     106e <wc+0x6e>
        inword = 0;
    1065:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    106c:	eb 11                	jmp    107f <wc+0x7f>
      else if(!inword){
    106e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1072:	75 0b                	jne    107f <wc+0x7f>
        w++;
    1074:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
    1078:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
    107f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1083:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1086:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    1089:	7c a0                	jl     102b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    108b:	83 ec 04             	sub    $0x4,%esp
    108e:	68 00 02 00 00       	push   $0x200
    1093:	68 40 1c 00 00       	push   $0x1c40
    1098:	ff 75 08             	pushl  0x8(%ebp)
    109b:	e8 8c 03 00 00       	call   142c <read>
    10a0:	83 c4 10             	add    $0x10,%esp
    10a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    10a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10aa:	0f 8f 72 ff ff ff    	jg     1022 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
    10b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10b4:	79 17                	jns    10cd <wc+0xcd>
    printf(1, "wc: read error\n");
    10b6:	83 ec 08             	sub    $0x8,%esp
    10b9:	68 5f 19 00 00       	push   $0x195f
    10be:	6a 01                	push   $0x1
    10c0:	e8 de 04 00 00       	call   15a3 <printf>
    10c5:	83 c4 10             	add    $0x10,%esp
    exit();
    10c8:	e8 47 03 00 00       	call   1414 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
    10cd:	83 ec 08             	sub    $0x8,%esp
    10d0:	ff 75 0c             	pushl  0xc(%ebp)
    10d3:	ff 75 e8             	pushl  -0x18(%ebp)
    10d6:	ff 75 ec             	pushl  -0x14(%ebp)
    10d9:	ff 75 f0             	pushl  -0x10(%ebp)
    10dc:	68 6f 19 00 00       	push   $0x196f
    10e1:	6a 01                	push   $0x1
    10e3:	e8 bb 04 00 00       	call   15a3 <printf>
    10e8:	83 c4 20             	add    $0x20,%esp
}
    10eb:	90                   	nop
    10ec:	c9                   	leave  
    10ed:	c3                   	ret    

000010ee <main>:

int
main(int argc, char *argv[])
{
    10ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    10f2:	83 e4 f0             	and    $0xfffffff0,%esp
    10f5:	ff 71 fc             	pushl  -0x4(%ecx)
    10f8:	55                   	push   %ebp
    10f9:	89 e5                	mov    %esp,%ebp
    10fb:	53                   	push   %ebx
    10fc:	51                   	push   %ecx
    10fd:	83 ec 10             	sub    $0x10,%esp
    1100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
    1102:	83 3b 01             	cmpl   $0x1,(%ebx)
    1105:	7f 17                	jg     111e <main+0x30>
    wc(0, "");
    1107:	83 ec 08             	sub    $0x8,%esp
    110a:	68 7c 19 00 00       	push   $0x197c
    110f:	6a 00                	push   $0x0
    1111:	e8 ea fe ff ff       	call   1000 <wc>
    1116:	83 c4 10             	add    $0x10,%esp
    exit();
    1119:	e8 f6 02 00 00       	call   1414 <exit>
  }

  for(i = 1; i < argc; i++){
    111e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    1125:	e9 83 00 00 00       	jmp    11ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
    112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    112d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1134:	8b 43 04             	mov    0x4(%ebx),%eax
    1137:	01 d0                	add    %edx,%eax
    1139:	8b 00                	mov    (%eax),%eax
    113b:	83 ec 08             	sub    $0x8,%esp
    113e:	6a 00                	push   $0x0
    1140:	50                   	push   %eax
    1141:	e8 0e 03 00 00       	call   1454 <open>
    1146:	83 c4 10             	add    $0x10,%esp
    1149:	89 45 f0             	mov    %eax,-0x10(%ebp)
    114c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1150:	79 29                	jns    117b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
    1152:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    115c:	8b 43 04             	mov    0x4(%ebx),%eax
    115f:	01 d0                	add    %edx,%eax
    1161:	8b 00                	mov    (%eax),%eax
    1163:	83 ec 04             	sub    $0x4,%esp
    1166:	50                   	push   %eax
    1167:	68 7d 19 00 00       	push   $0x197d
    116c:	6a 01                	push   $0x1
    116e:	e8 30 04 00 00       	call   15a3 <printf>
    1173:	83 c4 10             	add    $0x10,%esp
      exit();
    1176:	e8 99 02 00 00       	call   1414 <exit>
    }
    wc(fd, argv[i]);
    117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    117e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1185:	8b 43 04             	mov    0x4(%ebx),%eax
    1188:	01 d0                	add    %edx,%eax
    118a:	8b 00                	mov    (%eax),%eax
    118c:	83 ec 08             	sub    $0x8,%esp
    118f:	50                   	push   %eax
    1190:	ff 75 f0             	pushl  -0x10(%ebp)
    1193:	e8 68 fe ff ff       	call   1000 <wc>
    1198:	83 c4 10             	add    $0x10,%esp
    close(fd);
    119b:	83 ec 0c             	sub    $0xc,%esp
    119e:	ff 75 f0             	pushl  -0x10(%ebp)
    11a1:	e8 96 02 00 00       	call   143c <close>
    11a6:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    11a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b0:	3b 03                	cmp    (%ebx),%eax
    11b2:	0f 8c 72 ff ff ff    	jl     112a <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
    11b8:	e8 57 02 00 00       	call   1414 <exit>

000011bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11bd:	55                   	push   %ebp
    11be:	89 e5                	mov    %esp,%ebp
    11c0:	57                   	push   %edi
    11c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    11c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11c5:	8b 55 10             	mov    0x10(%ebp),%edx
    11c8:	8b 45 0c             	mov    0xc(%ebp),%eax
    11cb:	89 cb                	mov    %ecx,%ebx
    11cd:	89 df                	mov    %ebx,%edi
    11cf:	89 d1                	mov    %edx,%ecx
    11d1:	fc                   	cld    
    11d2:	f3 aa                	rep stos %al,%es:(%edi)
    11d4:	89 ca                	mov    %ecx,%edx
    11d6:	89 fb                	mov    %edi,%ebx
    11d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
    11db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11de:	90                   	nop
    11df:	5b                   	pop    %ebx
    11e0:	5f                   	pop    %edi
    11e1:	5d                   	pop    %ebp
    11e2:	c3                   	ret    

000011e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    11e3:	55                   	push   %ebp
    11e4:	89 e5                	mov    %esp,%ebp
    11e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    11e9:	8b 45 08             	mov    0x8(%ebp),%eax
    11ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    11ef:	90                   	nop
    11f0:	8b 45 08             	mov    0x8(%ebp),%eax
    11f3:	8d 50 01             	lea    0x1(%eax),%edx
    11f6:	89 55 08             	mov    %edx,0x8(%ebp)
    11f9:	8b 55 0c             	mov    0xc(%ebp),%edx
    11fc:	8d 4a 01             	lea    0x1(%edx),%ecx
    11ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1202:	0f b6 12             	movzbl (%edx),%edx
    1205:	88 10                	mov    %dl,(%eax)
    1207:	0f b6 00             	movzbl (%eax),%eax
    120a:	84 c0                	test   %al,%al
    120c:	75 e2                	jne    11f0 <strcpy+0xd>
    ;
  return os;
    120e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1211:	c9                   	leave  
    1212:	c3                   	ret    

00001213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1213:	55                   	push   %ebp
    1214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1216:	eb 08                	jmp    1220 <strcmp+0xd>
    p++, q++;
    1218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    121c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1220:	8b 45 08             	mov    0x8(%ebp),%eax
    1223:	0f b6 00             	movzbl (%eax),%eax
    1226:	84 c0                	test   %al,%al
    1228:	74 10                	je     123a <strcmp+0x27>
    122a:	8b 45 08             	mov    0x8(%ebp),%eax
    122d:	0f b6 10             	movzbl (%eax),%edx
    1230:	8b 45 0c             	mov    0xc(%ebp),%eax
    1233:	0f b6 00             	movzbl (%eax),%eax
    1236:	38 c2                	cmp    %al,%dl
    1238:	74 de                	je     1218 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    123a:	8b 45 08             	mov    0x8(%ebp),%eax
    123d:	0f b6 00             	movzbl (%eax),%eax
    1240:	0f b6 d0             	movzbl %al,%edx
    1243:	8b 45 0c             	mov    0xc(%ebp),%eax
    1246:	0f b6 00             	movzbl (%eax),%eax
    1249:	0f b6 c0             	movzbl %al,%eax
    124c:	29 c2                	sub    %eax,%edx
    124e:	89 d0                	mov    %edx,%eax
}
    1250:	5d                   	pop    %ebp
    1251:	c3                   	ret    

00001252 <strlen>:

uint
strlen(const char *s)
{
    1252:	55                   	push   %ebp
    1253:	89 e5                	mov    %esp,%ebp
    1255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    125f:	eb 04                	jmp    1265 <strlen+0x13>
    1261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1265:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1268:	8b 45 08             	mov    0x8(%ebp),%eax
    126b:	01 d0                	add    %edx,%eax
    126d:	0f b6 00             	movzbl (%eax),%eax
    1270:	84 c0                	test   %al,%al
    1272:	75 ed                	jne    1261 <strlen+0xf>
    ;
  return n;
    1274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1277:	c9                   	leave  
    1278:	c3                   	ret    

00001279 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1279:	55                   	push   %ebp
    127a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    127c:	8b 45 10             	mov    0x10(%ebp),%eax
    127f:	50                   	push   %eax
    1280:	ff 75 0c             	pushl  0xc(%ebp)
    1283:	ff 75 08             	pushl  0x8(%ebp)
    1286:	e8 32 ff ff ff       	call   11bd <stosb>
    128b:	83 c4 0c             	add    $0xc,%esp
  return dst;
    128e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1291:	c9                   	leave  
    1292:	c3                   	ret    

00001293 <strchr>:

char*
strchr(const char *s, char c)
{
    1293:	55                   	push   %ebp
    1294:	89 e5                	mov    %esp,%ebp
    1296:	83 ec 04             	sub    $0x4,%esp
    1299:	8b 45 0c             	mov    0xc(%ebp),%eax
    129c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    129f:	eb 14                	jmp    12b5 <strchr+0x22>
    if(*s == c)
    12a1:	8b 45 08             	mov    0x8(%ebp),%eax
    12a4:	0f b6 00             	movzbl (%eax),%eax
    12a7:	3a 45 fc             	cmp    -0x4(%ebp),%al
    12aa:	75 05                	jne    12b1 <strchr+0x1e>
      return (char*)s;
    12ac:	8b 45 08             	mov    0x8(%ebp),%eax
    12af:	eb 13                	jmp    12c4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    12b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12b5:	8b 45 08             	mov    0x8(%ebp),%eax
    12b8:	0f b6 00             	movzbl (%eax),%eax
    12bb:	84 c0                	test   %al,%al
    12bd:	75 e2                	jne    12a1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    12bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12c4:	c9                   	leave  
    12c5:	c3                   	ret    

000012c6 <gets>:

char*
gets(char *buf, int max)
{
    12c6:	55                   	push   %ebp
    12c7:	89 e5                	mov    %esp,%ebp
    12c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12d3:	eb 42                	jmp    1317 <gets+0x51>
    cc = read(0, &c, 1);
    12d5:	83 ec 04             	sub    $0x4,%esp
    12d8:	6a 01                	push   $0x1
    12da:	8d 45 ef             	lea    -0x11(%ebp),%eax
    12dd:	50                   	push   %eax
    12de:	6a 00                	push   $0x0
    12e0:	e8 47 01 00 00       	call   142c <read>
    12e5:	83 c4 10             	add    $0x10,%esp
    12e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    12eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12ef:	7e 33                	jle    1324 <gets+0x5e>
      break;
    buf[i++] = c;
    12f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f4:	8d 50 01             	lea    0x1(%eax),%edx
    12f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
    12fa:	89 c2                	mov    %eax,%edx
    12fc:	8b 45 08             	mov    0x8(%ebp),%eax
    12ff:	01 c2                	add    %eax,%edx
    1301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    130b:	3c 0a                	cmp    $0xa,%al
    130d:	74 16                	je     1325 <gets+0x5f>
    130f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1313:	3c 0d                	cmp    $0xd,%al
    1315:	74 0e                	je     1325 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1317:	8b 45 f4             	mov    -0xc(%ebp),%eax
    131a:	83 c0 01             	add    $0x1,%eax
    131d:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1320:	7c b3                	jl     12d5 <gets+0xf>
    1322:	eb 01                	jmp    1325 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1324:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1325:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1328:	8b 45 08             	mov    0x8(%ebp),%eax
    132b:	01 d0                	add    %edx,%eax
    132d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1330:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1333:	c9                   	leave  
    1334:	c3                   	ret    

00001335 <stat>:

int
stat(const char *n, struct stat *st)
{
    1335:	55                   	push   %ebp
    1336:	89 e5                	mov    %esp,%ebp
    1338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    133b:	83 ec 08             	sub    $0x8,%esp
    133e:	6a 00                	push   $0x0
    1340:	ff 75 08             	pushl  0x8(%ebp)
    1343:	e8 0c 01 00 00       	call   1454 <open>
    1348:	83 c4 10             	add    $0x10,%esp
    134b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    134e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1352:	79 07                	jns    135b <stat+0x26>
    return -1;
    1354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1359:	eb 25                	jmp    1380 <stat+0x4b>
  r = fstat(fd, st);
    135b:	83 ec 08             	sub    $0x8,%esp
    135e:	ff 75 0c             	pushl  0xc(%ebp)
    1361:	ff 75 f4             	pushl  -0xc(%ebp)
    1364:	e8 03 01 00 00       	call   146c <fstat>
    1369:	83 c4 10             	add    $0x10,%esp
    136c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    136f:	83 ec 0c             	sub    $0xc,%esp
    1372:	ff 75 f4             	pushl  -0xc(%ebp)
    1375:	e8 c2 00 00 00       	call   143c <close>
    137a:	83 c4 10             	add    $0x10,%esp
  return r;
    137d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1380:	c9                   	leave  
    1381:	c3                   	ret    

00001382 <atoi>:

int
atoi(const char *s)
{
    1382:	55                   	push   %ebp
    1383:	89 e5                	mov    %esp,%ebp
    1385:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    138f:	eb 25                	jmp    13b6 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1391:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1394:	89 d0                	mov    %edx,%eax
    1396:	c1 e0 02             	shl    $0x2,%eax
    1399:	01 d0                	add    %edx,%eax
    139b:	01 c0                	add    %eax,%eax
    139d:	89 c1                	mov    %eax,%ecx
    139f:	8b 45 08             	mov    0x8(%ebp),%eax
    13a2:	8d 50 01             	lea    0x1(%eax),%edx
    13a5:	89 55 08             	mov    %edx,0x8(%ebp)
    13a8:	0f b6 00             	movzbl (%eax),%eax
    13ab:	0f be c0             	movsbl %al,%eax
    13ae:	01 c8                	add    %ecx,%eax
    13b0:	83 e8 30             	sub    $0x30,%eax
    13b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    13b6:	8b 45 08             	mov    0x8(%ebp),%eax
    13b9:	0f b6 00             	movzbl (%eax),%eax
    13bc:	3c 2f                	cmp    $0x2f,%al
    13be:	7e 0a                	jle    13ca <atoi+0x48>
    13c0:	8b 45 08             	mov    0x8(%ebp),%eax
    13c3:	0f b6 00             	movzbl (%eax),%eax
    13c6:	3c 39                	cmp    $0x39,%al
    13c8:	7e c7                	jle    1391 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    13ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13cd:	c9                   	leave  
    13ce:	c3                   	ret    

000013cf <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    13cf:	55                   	push   %ebp
    13d0:	89 e5                	mov    %esp,%ebp
    13d2:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    13d5:	8b 45 08             	mov    0x8(%ebp),%eax
    13d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    13db:	8b 45 0c             	mov    0xc(%ebp),%eax
    13de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    13e1:	eb 17                	jmp    13fa <memmove+0x2b>
    *dst++ = *src++;
    13e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13e6:	8d 50 01             	lea    0x1(%eax),%edx
    13e9:	89 55 fc             	mov    %edx,-0x4(%ebp)
    13ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
    13ef:	8d 4a 01             	lea    0x1(%edx),%ecx
    13f2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    13f5:	0f b6 12             	movzbl (%edx),%edx
    13f8:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    13fa:	8b 45 10             	mov    0x10(%ebp),%eax
    13fd:	8d 50 ff             	lea    -0x1(%eax),%edx
    1400:	89 55 10             	mov    %edx,0x10(%ebp)
    1403:	85 c0                	test   %eax,%eax
    1405:	7f dc                	jg     13e3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1407:	8b 45 08             	mov    0x8(%ebp),%eax
}
    140a:	c9                   	leave  
    140b:	c3                   	ret    

0000140c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    140c:	b8 01 00 00 00       	mov    $0x1,%eax
    1411:	cd 40                	int    $0x40
    1413:	c3                   	ret    

00001414 <exit>:
SYSCALL(exit)
    1414:	b8 02 00 00 00       	mov    $0x2,%eax
    1419:	cd 40                	int    $0x40
    141b:	c3                   	ret    

0000141c <wait>:
SYSCALL(wait)
    141c:	b8 03 00 00 00       	mov    $0x3,%eax
    1421:	cd 40                	int    $0x40
    1423:	c3                   	ret    

00001424 <pipe>:
SYSCALL(pipe)
    1424:	b8 04 00 00 00       	mov    $0x4,%eax
    1429:	cd 40                	int    $0x40
    142b:	c3                   	ret    

0000142c <read>:
SYSCALL(read)
    142c:	b8 05 00 00 00       	mov    $0x5,%eax
    1431:	cd 40                	int    $0x40
    1433:	c3                   	ret    

00001434 <write>:
SYSCALL(write)
    1434:	b8 10 00 00 00       	mov    $0x10,%eax
    1439:	cd 40                	int    $0x40
    143b:	c3                   	ret    

0000143c <close>:
SYSCALL(close)
    143c:	b8 15 00 00 00       	mov    $0x15,%eax
    1441:	cd 40                	int    $0x40
    1443:	c3                   	ret    

00001444 <kill>:
SYSCALL(kill)
    1444:	b8 06 00 00 00       	mov    $0x6,%eax
    1449:	cd 40                	int    $0x40
    144b:	c3                   	ret    

0000144c <exec>:
SYSCALL(exec)
    144c:	b8 07 00 00 00       	mov    $0x7,%eax
    1451:	cd 40                	int    $0x40
    1453:	c3                   	ret    

00001454 <open>:
SYSCALL(open)
    1454:	b8 0f 00 00 00       	mov    $0xf,%eax
    1459:	cd 40                	int    $0x40
    145b:	c3                   	ret    

0000145c <mknod>:
SYSCALL(mknod)
    145c:	b8 11 00 00 00       	mov    $0x11,%eax
    1461:	cd 40                	int    $0x40
    1463:	c3                   	ret    

00001464 <unlink>:
SYSCALL(unlink)
    1464:	b8 12 00 00 00       	mov    $0x12,%eax
    1469:	cd 40                	int    $0x40
    146b:	c3                   	ret    

0000146c <fstat>:
SYSCALL(fstat)
    146c:	b8 08 00 00 00       	mov    $0x8,%eax
    1471:	cd 40                	int    $0x40
    1473:	c3                   	ret    

00001474 <link>:
SYSCALL(link)
    1474:	b8 13 00 00 00       	mov    $0x13,%eax
    1479:	cd 40                	int    $0x40
    147b:	c3                   	ret    

0000147c <mkdir>:
SYSCALL(mkdir)
    147c:	b8 14 00 00 00       	mov    $0x14,%eax
    1481:	cd 40                	int    $0x40
    1483:	c3                   	ret    

00001484 <chdir>:
SYSCALL(chdir)
    1484:	b8 09 00 00 00       	mov    $0x9,%eax
    1489:	cd 40                	int    $0x40
    148b:	c3                   	ret    

0000148c <dup>:
SYSCALL(dup)
    148c:	b8 0a 00 00 00       	mov    $0xa,%eax
    1491:	cd 40                	int    $0x40
    1493:	c3                   	ret    

00001494 <getpid>:
SYSCALL(getpid)
    1494:	b8 0b 00 00 00       	mov    $0xb,%eax
    1499:	cd 40                	int    $0x40
    149b:	c3                   	ret    

0000149c <sbrk>:
SYSCALL(sbrk)
    149c:	b8 0c 00 00 00       	mov    $0xc,%eax
    14a1:	cd 40                	int    $0x40
    14a3:	c3                   	ret    

000014a4 <sleep>:
SYSCALL(sleep)
    14a4:	b8 0d 00 00 00       	mov    $0xd,%eax
    14a9:	cd 40                	int    $0x40
    14ab:	c3                   	ret    

000014ac <uptime>:
SYSCALL(uptime)
    14ac:	b8 0e 00 00 00       	mov    $0xe,%eax
    14b1:	cd 40                	int    $0x40
    14b3:	c3                   	ret    

000014b4 <getprocsinfo>:
SYSCALL(getprocsinfo)
    14b4:	b8 16 00 00 00       	mov    $0x16,%eax
    14b9:	cd 40                	int    $0x40
    14bb:	c3                   	ret    

000014bc <shmem_access>:
SYSCALL(shmem_access)
    14bc:	b8 17 00 00 00       	mov    $0x17,%eax
    14c1:	cd 40                	int    $0x40
    14c3:	c3                   	ret    

000014c4 <shmem_count>:
SYSCALL(shmem_count)
    14c4:	b8 18 00 00 00       	mov    $0x18,%eax
    14c9:	cd 40                	int    $0x40
    14cb:	c3                   	ret    

000014cc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14cc:	55                   	push   %ebp
    14cd:	89 e5                	mov    %esp,%ebp
    14cf:	83 ec 18             	sub    $0x18,%esp
    14d2:	8b 45 0c             	mov    0xc(%ebp),%eax
    14d5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14d8:	83 ec 04             	sub    $0x4,%esp
    14db:	6a 01                	push   $0x1
    14dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
    14e0:	50                   	push   %eax
    14e1:	ff 75 08             	pushl  0x8(%ebp)
    14e4:	e8 4b ff ff ff       	call   1434 <write>
    14e9:	83 c4 10             	add    $0x10,%esp
}
    14ec:	90                   	nop
    14ed:	c9                   	leave  
    14ee:	c3                   	ret    

000014ef <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    14ef:	55                   	push   %ebp
    14f0:	89 e5                	mov    %esp,%ebp
    14f2:	53                   	push   %ebx
    14f3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    14f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    14fd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1501:	74 17                	je     151a <printint+0x2b>
    1503:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1507:	79 11                	jns    151a <printint+0x2b>
    neg = 1;
    1509:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1510:	8b 45 0c             	mov    0xc(%ebp),%eax
    1513:	f7 d8                	neg    %eax
    1515:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1518:	eb 06                	jmp    1520 <printint+0x31>
  } else {
    x = xx;
    151a:	8b 45 0c             	mov    0xc(%ebp),%eax
    151d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1527:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    152a:	8d 41 01             	lea    0x1(%ecx),%eax
    152d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1530:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1533:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1536:	ba 00 00 00 00       	mov    $0x0,%edx
    153b:	f7 f3                	div    %ebx
    153d:	89 d0                	mov    %edx,%eax
    153f:	0f b6 80 04 1c 00 00 	movzbl 0x1c04(%eax),%eax
    1546:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    154a:	8b 5d 10             	mov    0x10(%ebp),%ebx
    154d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1550:	ba 00 00 00 00       	mov    $0x0,%edx
    1555:	f7 f3                	div    %ebx
    1557:	89 45 ec             	mov    %eax,-0x14(%ebp)
    155a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    155e:	75 c7                	jne    1527 <printint+0x38>
  if(neg)
    1560:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1564:	74 2d                	je     1593 <printint+0xa4>
    buf[i++] = '-';
    1566:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1569:	8d 50 01             	lea    0x1(%eax),%edx
    156c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    156f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1574:	eb 1d                	jmp    1593 <printint+0xa4>
    putc(fd, buf[i]);
    1576:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1579:	8b 45 f4             	mov    -0xc(%ebp),%eax
    157c:	01 d0                	add    %edx,%eax
    157e:	0f b6 00             	movzbl (%eax),%eax
    1581:	0f be c0             	movsbl %al,%eax
    1584:	83 ec 08             	sub    $0x8,%esp
    1587:	50                   	push   %eax
    1588:	ff 75 08             	pushl  0x8(%ebp)
    158b:	e8 3c ff ff ff       	call   14cc <putc>
    1590:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1593:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    159b:	79 d9                	jns    1576 <printint+0x87>
    putc(fd, buf[i]);
}
    159d:	90                   	nop
    159e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    15a1:	c9                   	leave  
    15a2:	c3                   	ret    

000015a3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    15a3:	55                   	push   %ebp
    15a4:	89 e5                	mov    %esp,%ebp
    15a6:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    15a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    15b0:	8d 45 0c             	lea    0xc(%ebp),%eax
    15b3:	83 c0 04             	add    $0x4,%eax
    15b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    15b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15c0:	e9 59 01 00 00       	jmp    171e <printf+0x17b>
    c = fmt[i] & 0xff;
    15c5:	8b 55 0c             	mov    0xc(%ebp),%edx
    15c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15cb:	01 d0                	add    %edx,%eax
    15cd:	0f b6 00             	movzbl (%eax),%eax
    15d0:	0f be c0             	movsbl %al,%eax
    15d3:	25 ff 00 00 00       	and    $0xff,%eax
    15d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    15db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15df:	75 2c                	jne    160d <printf+0x6a>
      if(c == '%'){
    15e1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15e5:	75 0c                	jne    15f3 <printf+0x50>
        state = '%';
    15e7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    15ee:	e9 27 01 00 00       	jmp    171a <printf+0x177>
      } else {
        putc(fd, c);
    15f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15f6:	0f be c0             	movsbl %al,%eax
    15f9:	83 ec 08             	sub    $0x8,%esp
    15fc:	50                   	push   %eax
    15fd:	ff 75 08             	pushl  0x8(%ebp)
    1600:	e8 c7 fe ff ff       	call   14cc <putc>
    1605:	83 c4 10             	add    $0x10,%esp
    1608:	e9 0d 01 00 00       	jmp    171a <printf+0x177>
      }
    } else if(state == '%'){
    160d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1611:	0f 85 03 01 00 00    	jne    171a <printf+0x177>
      if(c == 'd'){
    1617:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    161b:	75 1e                	jne    163b <printf+0x98>
        printint(fd, *ap, 10, 1);
    161d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1620:	8b 00                	mov    (%eax),%eax
    1622:	6a 01                	push   $0x1
    1624:	6a 0a                	push   $0xa
    1626:	50                   	push   %eax
    1627:	ff 75 08             	pushl  0x8(%ebp)
    162a:	e8 c0 fe ff ff       	call   14ef <printint>
    162f:	83 c4 10             	add    $0x10,%esp
        ap++;
    1632:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1636:	e9 d8 00 00 00       	jmp    1713 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    163b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    163f:	74 06                	je     1647 <printf+0xa4>
    1641:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1645:	75 1e                	jne    1665 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    1647:	8b 45 e8             	mov    -0x18(%ebp),%eax
    164a:	8b 00                	mov    (%eax),%eax
    164c:	6a 00                	push   $0x0
    164e:	6a 10                	push   $0x10
    1650:	50                   	push   %eax
    1651:	ff 75 08             	pushl  0x8(%ebp)
    1654:	e8 96 fe ff ff       	call   14ef <printint>
    1659:	83 c4 10             	add    $0x10,%esp
        ap++;
    165c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1660:	e9 ae 00 00 00       	jmp    1713 <printf+0x170>
      } else if(c == 's'){
    1665:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1669:	75 43                	jne    16ae <printf+0x10b>
        s = (char*)*ap;
    166b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    166e:	8b 00                	mov    (%eax),%eax
    1670:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1673:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    167b:	75 25                	jne    16a2 <printf+0xff>
          s = "(null)";
    167d:	c7 45 f4 91 19 00 00 	movl   $0x1991,-0xc(%ebp)
        while(*s != 0){
    1684:	eb 1c                	jmp    16a2 <printf+0xff>
          putc(fd, *s);
    1686:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1689:	0f b6 00             	movzbl (%eax),%eax
    168c:	0f be c0             	movsbl %al,%eax
    168f:	83 ec 08             	sub    $0x8,%esp
    1692:	50                   	push   %eax
    1693:	ff 75 08             	pushl  0x8(%ebp)
    1696:	e8 31 fe ff ff       	call   14cc <putc>
    169b:	83 c4 10             	add    $0x10,%esp
          s++;
    169e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    16a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16a5:	0f b6 00             	movzbl (%eax),%eax
    16a8:	84 c0                	test   %al,%al
    16aa:	75 da                	jne    1686 <printf+0xe3>
    16ac:	eb 65                	jmp    1713 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16ae:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    16b2:	75 1d                	jne    16d1 <printf+0x12e>
        putc(fd, *ap);
    16b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16b7:	8b 00                	mov    (%eax),%eax
    16b9:	0f be c0             	movsbl %al,%eax
    16bc:	83 ec 08             	sub    $0x8,%esp
    16bf:	50                   	push   %eax
    16c0:	ff 75 08             	pushl  0x8(%ebp)
    16c3:	e8 04 fe ff ff       	call   14cc <putc>
    16c8:	83 c4 10             	add    $0x10,%esp
        ap++;
    16cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16cf:	eb 42                	jmp    1713 <printf+0x170>
      } else if(c == '%'){
    16d1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16d5:	75 17                	jne    16ee <printf+0x14b>
        putc(fd, c);
    16d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16da:	0f be c0             	movsbl %al,%eax
    16dd:	83 ec 08             	sub    $0x8,%esp
    16e0:	50                   	push   %eax
    16e1:	ff 75 08             	pushl  0x8(%ebp)
    16e4:	e8 e3 fd ff ff       	call   14cc <putc>
    16e9:	83 c4 10             	add    $0x10,%esp
    16ec:	eb 25                	jmp    1713 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    16ee:	83 ec 08             	sub    $0x8,%esp
    16f1:	6a 25                	push   $0x25
    16f3:	ff 75 08             	pushl  0x8(%ebp)
    16f6:	e8 d1 fd ff ff       	call   14cc <putc>
    16fb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    16fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1701:	0f be c0             	movsbl %al,%eax
    1704:	83 ec 08             	sub    $0x8,%esp
    1707:	50                   	push   %eax
    1708:	ff 75 08             	pushl  0x8(%ebp)
    170b:	e8 bc fd ff ff       	call   14cc <putc>
    1710:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1713:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    171a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    171e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1721:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1724:	01 d0                	add    %edx,%eax
    1726:	0f b6 00             	movzbl (%eax),%eax
    1729:	84 c0                	test   %al,%al
    172b:	0f 85 94 fe ff ff    	jne    15c5 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1731:	90                   	nop
    1732:	c9                   	leave  
    1733:	c3                   	ret    

00001734 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1734:	55                   	push   %ebp
    1735:	89 e5                	mov    %esp,%ebp
    1737:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    173a:	8b 45 08             	mov    0x8(%ebp),%eax
    173d:	83 e8 08             	sub    $0x8,%eax
    1740:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1743:	a1 28 1c 00 00       	mov    0x1c28,%eax
    1748:	89 45 fc             	mov    %eax,-0x4(%ebp)
    174b:	eb 24                	jmp    1771 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    174d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1750:	8b 00                	mov    (%eax),%eax
    1752:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1755:	77 12                	ja     1769 <free+0x35>
    1757:	8b 45 f8             	mov    -0x8(%ebp),%eax
    175a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    175d:	77 24                	ja     1783 <free+0x4f>
    175f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1762:	8b 00                	mov    (%eax),%eax
    1764:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1767:	77 1a                	ja     1783 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1769:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176c:	8b 00                	mov    (%eax),%eax
    176e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1771:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1774:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1777:	76 d4                	jbe    174d <free+0x19>
    1779:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177c:	8b 00                	mov    (%eax),%eax
    177e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1781:	76 ca                	jbe    174d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1783:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1786:	8b 40 04             	mov    0x4(%eax),%eax
    1789:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1790:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1793:	01 c2                	add    %eax,%edx
    1795:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1798:	8b 00                	mov    (%eax),%eax
    179a:	39 c2                	cmp    %eax,%edx
    179c:	75 24                	jne    17c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    179e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a1:	8b 50 04             	mov    0x4(%eax),%edx
    17a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a7:	8b 00                	mov    (%eax),%eax
    17a9:	8b 40 04             	mov    0x4(%eax),%eax
    17ac:	01 c2                	add    %eax,%edx
    17ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    17b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b7:	8b 00                	mov    (%eax),%eax
    17b9:	8b 10                	mov    (%eax),%edx
    17bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17be:	89 10                	mov    %edx,(%eax)
    17c0:	eb 0a                	jmp    17cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    17c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c5:	8b 10                	mov    (%eax),%edx
    17c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    17cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17cf:	8b 40 04             	mov    0x4(%eax),%eax
    17d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17dc:	01 d0                	add    %edx,%eax
    17de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17e1:	75 20                	jne    1803 <free+0xcf>
    p->s.size += bp->s.size;
    17e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e6:	8b 50 04             	mov    0x4(%eax),%edx
    17e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ec:	8b 40 04             	mov    0x4(%eax),%eax
    17ef:	01 c2                	add    %eax,%edx
    17f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17fa:	8b 10                	mov    (%eax),%edx
    17fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ff:	89 10                	mov    %edx,(%eax)
    1801:	eb 08                	jmp    180b <free+0xd7>
  } else
    p->s.ptr = bp;
    1803:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1806:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1809:	89 10                	mov    %edx,(%eax)
  freep = p;
    180b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    180e:	a3 28 1c 00 00       	mov    %eax,0x1c28
}
    1813:	90                   	nop
    1814:	c9                   	leave  
    1815:	c3                   	ret    

00001816 <morecore>:

static Header*
morecore(uint nu)
{
    1816:	55                   	push   %ebp
    1817:	89 e5                	mov    %esp,%ebp
    1819:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    181c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1823:	77 07                	ja     182c <morecore+0x16>
    nu = 4096;
    1825:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    182c:	8b 45 08             	mov    0x8(%ebp),%eax
    182f:	c1 e0 03             	shl    $0x3,%eax
    1832:	83 ec 0c             	sub    $0xc,%esp
    1835:	50                   	push   %eax
    1836:	e8 61 fc ff ff       	call   149c <sbrk>
    183b:	83 c4 10             	add    $0x10,%esp
    183e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1841:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1845:	75 07                	jne    184e <morecore+0x38>
    return 0;
    1847:	b8 00 00 00 00       	mov    $0x0,%eax
    184c:	eb 26                	jmp    1874 <morecore+0x5e>
  hp = (Header*)p;
    184e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1851:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1854:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1857:	8b 55 08             	mov    0x8(%ebp),%edx
    185a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    185d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1860:	83 c0 08             	add    $0x8,%eax
    1863:	83 ec 0c             	sub    $0xc,%esp
    1866:	50                   	push   %eax
    1867:	e8 c8 fe ff ff       	call   1734 <free>
    186c:	83 c4 10             	add    $0x10,%esp
  return freep;
    186f:	a1 28 1c 00 00       	mov    0x1c28,%eax
}
    1874:	c9                   	leave  
    1875:	c3                   	ret    

00001876 <malloc>:

void*
malloc(uint nbytes)
{
    1876:	55                   	push   %ebp
    1877:	89 e5                	mov    %esp,%ebp
    1879:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    187c:	8b 45 08             	mov    0x8(%ebp),%eax
    187f:	83 c0 07             	add    $0x7,%eax
    1882:	c1 e8 03             	shr    $0x3,%eax
    1885:	83 c0 01             	add    $0x1,%eax
    1888:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    188b:	a1 28 1c 00 00       	mov    0x1c28,%eax
    1890:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1893:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1897:	75 23                	jne    18bc <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1899:	c7 45 f0 20 1c 00 00 	movl   $0x1c20,-0x10(%ebp)
    18a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18a3:	a3 28 1c 00 00       	mov    %eax,0x1c28
    18a8:	a1 28 1c 00 00       	mov    0x1c28,%eax
    18ad:	a3 20 1c 00 00       	mov    %eax,0x1c20
    base.s.size = 0;
    18b2:	c7 05 24 1c 00 00 00 	movl   $0x0,0x1c24
    18b9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18bf:	8b 00                	mov    (%eax),%eax
    18c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    18c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c7:	8b 40 04             	mov    0x4(%eax),%eax
    18ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18cd:	72 4d                	jb     191c <malloc+0xa6>
      if(p->s.size == nunits)
    18cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18d2:	8b 40 04             	mov    0x4(%eax),%eax
    18d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18d8:	75 0c                	jne    18e6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    18da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18dd:	8b 10                	mov    (%eax),%edx
    18df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18e2:	89 10                	mov    %edx,(%eax)
    18e4:	eb 26                	jmp    190c <malloc+0x96>
      else {
        p->s.size -= nunits;
    18e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18e9:	8b 40 04             	mov    0x4(%eax),%eax
    18ec:	2b 45 ec             	sub    -0x14(%ebp),%eax
    18ef:	89 c2                	mov    %eax,%edx
    18f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    18f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18fa:	8b 40 04             	mov    0x4(%eax),%eax
    18fd:	c1 e0 03             	shl    $0x3,%eax
    1900:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1903:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1906:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1909:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    190c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    190f:	a3 28 1c 00 00       	mov    %eax,0x1c28
      return (void*)(p + 1);
    1914:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1917:	83 c0 08             	add    $0x8,%eax
    191a:	eb 3b                	jmp    1957 <malloc+0xe1>
    }
    if(p == freep)
    191c:	a1 28 1c 00 00       	mov    0x1c28,%eax
    1921:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1924:	75 1e                	jne    1944 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    1926:	83 ec 0c             	sub    $0xc,%esp
    1929:	ff 75 ec             	pushl  -0x14(%ebp)
    192c:	e8 e5 fe ff ff       	call   1816 <morecore>
    1931:	83 c4 10             	add    $0x10,%esp
    1934:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1937:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    193b:	75 07                	jne    1944 <malloc+0xce>
        return 0;
    193d:	b8 00 00 00 00       	mov    $0x0,%eax
    1942:	eb 13                	jmp    1957 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1944:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1947:	89 45 f0             	mov    %eax,-0x10(%ebp)
    194a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    194d:	8b 00                	mov    (%eax),%eax
    194f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1952:	e9 6d ff ff ff       	jmp    18c4 <malloc+0x4e>
}
    1957:	c9                   	leave  
    1958:	c3                   	ret    
