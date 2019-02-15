
_testmemory:     file format elf32-i386


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
    100e:	83 ec 24             	sub    $0x24,%esp

    //int p = 0;
    char* test;
    char value = 'a';
    1011:	c6 45 df 61          	movb   $0x61,-0x21(%ebp)
    char *x = &value;
    1015:	8d 45 df             	lea    -0x21(%ebp),%eax
    1018:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int pid = -2;
    101b:	c7 45 f0 fe ff ff ff 	movl   $0xfffffffe,-0x10(%ebp)

    if((pid = fork()) == 0)
    1022:	e8 c5 03 00 00       	call   13ec <fork>
    1027:	89 45 f0             	mov    %eax,-0x10(%ebp)
    102a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    102e:	0f 85 e9 00 00 00    	jne    111d <main+0x11d>
    {
        if(fork() == 0){
    1034:	e8 b3 03 00 00       	call   13ec <fork>
    1039:	85 c0                	test   %eax,%eax
    103b:	75 72                	jne    10af <main+0xaf>
            test = (char*)shmem_access(0);
    103d:	83 ec 0c             	sub    $0xc,%esp
    1040:	6a 00                	push   $0x0
    1042:	e8 55 04 00 00       	call   149c <shmem_access>
    1047:	83 c4 10             	add    $0x10,%esp
    104a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            int count1 = shmem_count(0);
    104d:	83 ec 0c             	sub    $0xc,%esp
    1050:	6a 00                	push   $0x0
    1052:	e8 4d 04 00 00       	call   14a4 <shmem_count>
    1057:	83 c4 10             	add    $0x10,%esp
    105a:	89 45 e8             	mov    %eax,-0x18(%ebp)
            printf(1, "share memory index 0 have %d number process in use\n", count1);
    105d:	83 ec 04             	sub    $0x4,%esp
    1060:	ff 75 e8             	pushl  -0x18(%ebp)
    1063:	68 3c 19 00 00       	push   $0x193c
    1068:	6a 01                	push   $0x1
    106a:	e8 14 05 00 00       	call   1583 <printf>
    106f:	83 c4 10             	add    $0x10,%esp
            *test = 'b';
    1072:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1075:	c6 00 62             	movb   $0x62,(%eax)
            *x = 'c';
    1078:	8b 45 f4             	mov    -0xc(%ebp),%eax
    107b:	c6 00 63             	movb   $0x63,(%eax)
            printf(1, "son1: test addr:%x, test value:%c, x addr:%x, x value:%c\n", test, *test, x, *x);
    107e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1081:	0f b6 00             	movzbl (%eax),%eax
    1084:	0f be d0             	movsbl %al,%edx
    1087:	8b 45 ec             	mov    -0x14(%ebp),%eax
    108a:	0f b6 00             	movzbl (%eax),%eax
    108d:	0f be c0             	movsbl %al,%eax
    1090:	83 ec 08             	sub    $0x8,%esp
    1093:	52                   	push   %edx
    1094:	ff 75 f4             	pushl  -0xc(%ebp)
    1097:	50                   	push   %eax
    1098:	ff 75 ec             	pushl  -0x14(%ebp)
    109b:	68 70 19 00 00       	push   $0x1970
    10a0:	6a 01                	push   $0x1
    10a2:	e8 dc 04 00 00       	call   1583 <printf>
    10a7:	83 c4 20             	add    $0x20,%esp
    10aa:	e9 d4 00 00 00       	jmp    1183 <main+0x183>
        } else{
            wait();
    10af:	e8 48 03 00 00       	call   13fc <wait>
            //for(int i = 0; i < 100000;i++);
            test = (char*)shmem_access(0);
    10b4:	83 ec 0c             	sub    $0xc,%esp
    10b7:	6a 00                	push   $0x0
    10b9:	e8 de 03 00 00       	call   149c <shmem_access>
    10be:	83 c4 10             	add    $0x10,%esp
    10c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
            int count2 = shmem_count(0);
    10c4:	83 ec 0c             	sub    $0xc,%esp
    10c7:	6a 00                	push   $0x0
    10c9:	e8 d6 03 00 00       	call   14a4 <shmem_count>
    10ce:	83 c4 10             	add    $0x10,%esp
    10d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            printf(1, "share memory index 0 have %d number process in use\n", count2);
    10d4:	83 ec 04             	sub    $0x4,%esp
    10d7:	ff 75 e4             	pushl  -0x1c(%ebp)
    10da:	68 3c 19 00 00       	push   $0x193c
    10df:	6a 01                	push   $0x1
    10e1:	e8 9d 04 00 00       	call   1583 <printf>
    10e6:	83 c4 10             	add    $0x10,%esp
            *test = 'd';
    10e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10ec:	c6 00 64             	movb   $0x64,(%eax)
            //	test = (int*)p;
            printf(1, "son2: test addr:%x, test value:%c, x addr:%x, x value:%c\n", test, *test, x, *x);
    10ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10f2:	0f b6 00             	movzbl (%eax),%eax
    10f5:	0f be d0             	movsbl %al,%edx
    10f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10fb:	0f b6 00             	movzbl (%eax),%eax
    10fe:	0f be c0             	movsbl %al,%eax
    1101:	83 ec 08             	sub    $0x8,%esp
    1104:	52                   	push   %edx
    1105:	ff 75 f4             	pushl  -0xc(%ebp)
    1108:	50                   	push   %eax
    1109:	ff 75 ec             	pushl  -0x14(%ebp)
    110c:	68 ac 19 00 00       	push   $0x19ac
    1111:	6a 01                	push   $0x1
    1113:	e8 6b 04 00 00       	call   1583 <printf>
    1118:	83 c4 20             	add    $0x20,%esp
    111b:	eb 66                	jmp    1183 <main+0x183>

        }
    }
    else{

        wait();
    111d:	e8 da 02 00 00       	call   13fc <wait>
        //for(int i = 0; i < 100000;i++);
        test = (char*)shmem_access(0);
    1122:	83 ec 0c             	sub    $0xc,%esp
    1125:	6a 00                	push   $0x0
    1127:	e8 70 03 00 00       	call   149c <shmem_access>
    112c:	83 c4 10             	add    $0x10,%esp
    112f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        int count3 = shmem_count(0);
    1132:	83 ec 0c             	sub    $0xc,%esp
    1135:	6a 00                	push   $0x0
    1137:	e8 68 03 00 00       	call   14a4 <shmem_count>
    113c:	83 c4 10             	add    $0x10,%esp
    113f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        printf(1, "share memory index 0 have %d number process in use\n", count3);
    1142:	83 ec 04             	sub    $0x4,%esp
    1145:	ff 75 e0             	pushl  -0x20(%ebp)
    1148:	68 3c 19 00 00       	push   $0x193c
    114d:	6a 01                	push   $0x1
    114f:	e8 2f 04 00 00       	call   1583 <printf>
    1154:	83 c4 10             	add    $0x10,%esp
        // test = (int*)p;
        printf(1, "parent: test addr:%x, test value:%c, x addr:%x, x value:%c\n", test, *test, x, *x);
    1157:	8b 45 f4             	mov    -0xc(%ebp),%eax
    115a:	0f b6 00             	movzbl (%eax),%eax
    115d:	0f be d0             	movsbl %al,%edx
    1160:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1163:	0f b6 00             	movzbl (%eax),%eax
    1166:	0f be c0             	movsbl %al,%eax
    1169:	83 ec 08             	sub    $0x8,%esp
    116c:	52                   	push   %edx
    116d:	ff 75 f4             	pushl  -0xc(%ebp)
    1170:	50                   	push   %eax
    1171:	ff 75 ec             	pushl  -0x14(%ebp)
    1174:	68 e8 19 00 00       	push   $0x19e8
    1179:	6a 01                	push   $0x1
    117b:	e8 03 04 00 00       	call   1583 <printf>
    1180:	83 c4 20             	add    $0x20,%esp

    }
    printf(1,"pid:%d\n", pid);
    1183:	83 ec 04             	sub    $0x4,%esp
    1186:	ff 75 f0             	pushl  -0x10(%ebp)
    1189:	68 24 1a 00 00       	push   $0x1a24
    118e:	6a 01                	push   $0x1
    1190:	e8 ee 03 00 00       	call   1583 <printf>
    1195:	83 c4 10             	add    $0x10,%esp
    exit();
    1198:	e8 57 02 00 00       	call   13f4 <exit>

0000119d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    119d:	55                   	push   %ebp
    119e:	89 e5                	mov    %esp,%ebp
    11a0:	57                   	push   %edi
    11a1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    11a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11a5:	8b 55 10             	mov    0x10(%ebp),%edx
    11a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ab:	89 cb                	mov    %ecx,%ebx
    11ad:	89 df                	mov    %ebx,%edi
    11af:	89 d1                	mov    %edx,%ecx
    11b1:	fc                   	cld    
    11b2:	f3 aa                	rep stos %al,%es:(%edi)
    11b4:	89 ca                	mov    %ecx,%edx
    11b6:	89 fb                	mov    %edi,%ebx
    11b8:	89 5d 08             	mov    %ebx,0x8(%ebp)
    11bb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11be:	90                   	nop
    11bf:	5b                   	pop    %ebx
    11c0:	5f                   	pop    %edi
    11c1:	5d                   	pop    %ebp
    11c2:	c3                   	ret    

000011c3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    11c3:	55                   	push   %ebp
    11c4:	89 e5                	mov    %esp,%ebp
    11c6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    11c9:	8b 45 08             	mov    0x8(%ebp),%eax
    11cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    11cf:	90                   	nop
    11d0:	8b 45 08             	mov    0x8(%ebp),%eax
    11d3:	8d 50 01             	lea    0x1(%eax),%edx
    11d6:	89 55 08             	mov    %edx,0x8(%ebp)
    11d9:	8b 55 0c             	mov    0xc(%ebp),%edx
    11dc:	8d 4a 01             	lea    0x1(%edx),%ecx
    11df:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    11e2:	0f b6 12             	movzbl (%edx),%edx
    11e5:	88 10                	mov    %dl,(%eax)
    11e7:	0f b6 00             	movzbl (%eax),%eax
    11ea:	84 c0                	test   %al,%al
    11ec:	75 e2                	jne    11d0 <strcpy+0xd>
    ;
  return os;
    11ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11f1:	c9                   	leave  
    11f2:	c3                   	ret    

000011f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    11f3:	55                   	push   %ebp
    11f4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    11f6:	eb 08                	jmp    1200 <strcmp+0xd>
    p++, q++;
    11f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11fc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1200:	8b 45 08             	mov    0x8(%ebp),%eax
    1203:	0f b6 00             	movzbl (%eax),%eax
    1206:	84 c0                	test   %al,%al
    1208:	74 10                	je     121a <strcmp+0x27>
    120a:	8b 45 08             	mov    0x8(%ebp),%eax
    120d:	0f b6 10             	movzbl (%eax),%edx
    1210:	8b 45 0c             	mov    0xc(%ebp),%eax
    1213:	0f b6 00             	movzbl (%eax),%eax
    1216:	38 c2                	cmp    %al,%dl
    1218:	74 de                	je     11f8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    121a:	8b 45 08             	mov    0x8(%ebp),%eax
    121d:	0f b6 00             	movzbl (%eax),%eax
    1220:	0f b6 d0             	movzbl %al,%edx
    1223:	8b 45 0c             	mov    0xc(%ebp),%eax
    1226:	0f b6 00             	movzbl (%eax),%eax
    1229:	0f b6 c0             	movzbl %al,%eax
    122c:	29 c2                	sub    %eax,%edx
    122e:	89 d0                	mov    %edx,%eax
}
    1230:	5d                   	pop    %ebp
    1231:	c3                   	ret    

00001232 <strlen>:

uint
strlen(const char *s)
{
    1232:	55                   	push   %ebp
    1233:	89 e5                	mov    %esp,%ebp
    1235:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1238:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    123f:	eb 04                	jmp    1245 <strlen+0x13>
    1241:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1245:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1248:	8b 45 08             	mov    0x8(%ebp),%eax
    124b:	01 d0                	add    %edx,%eax
    124d:	0f b6 00             	movzbl (%eax),%eax
    1250:	84 c0                	test   %al,%al
    1252:	75 ed                	jne    1241 <strlen+0xf>
    ;
  return n;
    1254:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1257:	c9                   	leave  
    1258:	c3                   	ret    

00001259 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1259:	55                   	push   %ebp
    125a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    125c:	8b 45 10             	mov    0x10(%ebp),%eax
    125f:	50                   	push   %eax
    1260:	ff 75 0c             	pushl  0xc(%ebp)
    1263:	ff 75 08             	pushl  0x8(%ebp)
    1266:	e8 32 ff ff ff       	call   119d <stosb>
    126b:	83 c4 0c             	add    $0xc,%esp
  return dst;
    126e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1271:	c9                   	leave  
    1272:	c3                   	ret    

00001273 <strchr>:

char*
strchr(const char *s, char c)
{
    1273:	55                   	push   %ebp
    1274:	89 e5                	mov    %esp,%ebp
    1276:	83 ec 04             	sub    $0x4,%esp
    1279:	8b 45 0c             	mov    0xc(%ebp),%eax
    127c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    127f:	eb 14                	jmp    1295 <strchr+0x22>
    if(*s == c)
    1281:	8b 45 08             	mov    0x8(%ebp),%eax
    1284:	0f b6 00             	movzbl (%eax),%eax
    1287:	3a 45 fc             	cmp    -0x4(%ebp),%al
    128a:	75 05                	jne    1291 <strchr+0x1e>
      return (char*)s;
    128c:	8b 45 08             	mov    0x8(%ebp),%eax
    128f:	eb 13                	jmp    12a4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1291:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1295:	8b 45 08             	mov    0x8(%ebp),%eax
    1298:	0f b6 00             	movzbl (%eax),%eax
    129b:	84 c0                	test   %al,%al
    129d:	75 e2                	jne    1281 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    129f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12a4:	c9                   	leave  
    12a5:	c3                   	ret    

000012a6 <gets>:

char*
gets(char *buf, int max)
{
    12a6:	55                   	push   %ebp
    12a7:	89 e5                	mov    %esp,%ebp
    12a9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12b3:	eb 42                	jmp    12f7 <gets+0x51>
    cc = read(0, &c, 1);
    12b5:	83 ec 04             	sub    $0x4,%esp
    12b8:	6a 01                	push   $0x1
    12ba:	8d 45 ef             	lea    -0x11(%ebp),%eax
    12bd:	50                   	push   %eax
    12be:	6a 00                	push   $0x0
    12c0:	e8 47 01 00 00       	call   140c <read>
    12c5:	83 c4 10             	add    $0x10,%esp
    12c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    12cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12cf:	7e 33                	jle    1304 <gets+0x5e>
      break;
    buf[i++] = c;
    12d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d4:	8d 50 01             	lea    0x1(%eax),%edx
    12d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
    12da:	89 c2                	mov    %eax,%edx
    12dc:	8b 45 08             	mov    0x8(%ebp),%eax
    12df:	01 c2                	add    %eax,%edx
    12e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12e5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    12e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12eb:	3c 0a                	cmp    $0xa,%al
    12ed:	74 16                	je     1305 <gets+0x5f>
    12ef:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12f3:	3c 0d                	cmp    $0xd,%al
    12f5:	74 0e                	je     1305 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12fa:	83 c0 01             	add    $0x1,%eax
    12fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1300:	7c b3                	jl     12b5 <gets+0xf>
    1302:	eb 01                	jmp    1305 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1304:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1305:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1308:	8b 45 08             	mov    0x8(%ebp),%eax
    130b:	01 d0                	add    %edx,%eax
    130d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1310:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1313:	c9                   	leave  
    1314:	c3                   	ret    

00001315 <stat>:

int
stat(const char *n, struct stat *st)
{
    1315:	55                   	push   %ebp
    1316:	89 e5                	mov    %esp,%ebp
    1318:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    131b:	83 ec 08             	sub    $0x8,%esp
    131e:	6a 00                	push   $0x0
    1320:	ff 75 08             	pushl  0x8(%ebp)
    1323:	e8 0c 01 00 00       	call   1434 <open>
    1328:	83 c4 10             	add    $0x10,%esp
    132b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    132e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1332:	79 07                	jns    133b <stat+0x26>
    return -1;
    1334:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1339:	eb 25                	jmp    1360 <stat+0x4b>
  r = fstat(fd, st);
    133b:	83 ec 08             	sub    $0x8,%esp
    133e:	ff 75 0c             	pushl  0xc(%ebp)
    1341:	ff 75 f4             	pushl  -0xc(%ebp)
    1344:	e8 03 01 00 00       	call   144c <fstat>
    1349:	83 c4 10             	add    $0x10,%esp
    134c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    134f:	83 ec 0c             	sub    $0xc,%esp
    1352:	ff 75 f4             	pushl  -0xc(%ebp)
    1355:	e8 c2 00 00 00       	call   141c <close>
    135a:	83 c4 10             	add    $0x10,%esp
  return r;
    135d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1360:	c9                   	leave  
    1361:	c3                   	ret    

00001362 <atoi>:

int
atoi(const char *s)
{
    1362:	55                   	push   %ebp
    1363:	89 e5                	mov    %esp,%ebp
    1365:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1368:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    136f:	eb 25                	jmp    1396 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1371:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1374:	89 d0                	mov    %edx,%eax
    1376:	c1 e0 02             	shl    $0x2,%eax
    1379:	01 d0                	add    %edx,%eax
    137b:	01 c0                	add    %eax,%eax
    137d:	89 c1                	mov    %eax,%ecx
    137f:	8b 45 08             	mov    0x8(%ebp),%eax
    1382:	8d 50 01             	lea    0x1(%eax),%edx
    1385:	89 55 08             	mov    %edx,0x8(%ebp)
    1388:	0f b6 00             	movzbl (%eax),%eax
    138b:	0f be c0             	movsbl %al,%eax
    138e:	01 c8                	add    %ecx,%eax
    1390:	83 e8 30             	sub    $0x30,%eax
    1393:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1396:	8b 45 08             	mov    0x8(%ebp),%eax
    1399:	0f b6 00             	movzbl (%eax),%eax
    139c:	3c 2f                	cmp    $0x2f,%al
    139e:	7e 0a                	jle    13aa <atoi+0x48>
    13a0:	8b 45 08             	mov    0x8(%ebp),%eax
    13a3:	0f b6 00             	movzbl (%eax),%eax
    13a6:	3c 39                	cmp    $0x39,%al
    13a8:	7e c7                	jle    1371 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    13aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13ad:	c9                   	leave  
    13ae:	c3                   	ret    

000013af <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    13af:	55                   	push   %ebp
    13b0:	89 e5                	mov    %esp,%ebp
    13b2:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    13b5:	8b 45 08             	mov    0x8(%ebp),%eax
    13b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    13bb:	8b 45 0c             	mov    0xc(%ebp),%eax
    13be:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    13c1:	eb 17                	jmp    13da <memmove+0x2b>
    *dst++ = *src++;
    13c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13c6:	8d 50 01             	lea    0x1(%eax),%edx
    13c9:	89 55 fc             	mov    %edx,-0x4(%ebp)
    13cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
    13cf:	8d 4a 01             	lea    0x1(%edx),%ecx
    13d2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    13d5:	0f b6 12             	movzbl (%edx),%edx
    13d8:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    13da:	8b 45 10             	mov    0x10(%ebp),%eax
    13dd:	8d 50 ff             	lea    -0x1(%eax),%edx
    13e0:	89 55 10             	mov    %edx,0x10(%ebp)
    13e3:	85 c0                	test   %eax,%eax
    13e5:	7f dc                	jg     13c3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    13e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    13ea:	c9                   	leave  
    13eb:	c3                   	ret    

000013ec <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    13ec:	b8 01 00 00 00       	mov    $0x1,%eax
    13f1:	cd 40                	int    $0x40
    13f3:	c3                   	ret    

000013f4 <exit>:
SYSCALL(exit)
    13f4:	b8 02 00 00 00       	mov    $0x2,%eax
    13f9:	cd 40                	int    $0x40
    13fb:	c3                   	ret    

000013fc <wait>:
SYSCALL(wait)
    13fc:	b8 03 00 00 00       	mov    $0x3,%eax
    1401:	cd 40                	int    $0x40
    1403:	c3                   	ret    

00001404 <pipe>:
SYSCALL(pipe)
    1404:	b8 04 00 00 00       	mov    $0x4,%eax
    1409:	cd 40                	int    $0x40
    140b:	c3                   	ret    

0000140c <read>:
SYSCALL(read)
    140c:	b8 05 00 00 00       	mov    $0x5,%eax
    1411:	cd 40                	int    $0x40
    1413:	c3                   	ret    

00001414 <write>:
SYSCALL(write)
    1414:	b8 10 00 00 00       	mov    $0x10,%eax
    1419:	cd 40                	int    $0x40
    141b:	c3                   	ret    

0000141c <close>:
SYSCALL(close)
    141c:	b8 15 00 00 00       	mov    $0x15,%eax
    1421:	cd 40                	int    $0x40
    1423:	c3                   	ret    

00001424 <kill>:
SYSCALL(kill)
    1424:	b8 06 00 00 00       	mov    $0x6,%eax
    1429:	cd 40                	int    $0x40
    142b:	c3                   	ret    

0000142c <exec>:
SYSCALL(exec)
    142c:	b8 07 00 00 00       	mov    $0x7,%eax
    1431:	cd 40                	int    $0x40
    1433:	c3                   	ret    

00001434 <open>:
SYSCALL(open)
    1434:	b8 0f 00 00 00       	mov    $0xf,%eax
    1439:	cd 40                	int    $0x40
    143b:	c3                   	ret    

0000143c <mknod>:
SYSCALL(mknod)
    143c:	b8 11 00 00 00       	mov    $0x11,%eax
    1441:	cd 40                	int    $0x40
    1443:	c3                   	ret    

00001444 <unlink>:
SYSCALL(unlink)
    1444:	b8 12 00 00 00       	mov    $0x12,%eax
    1449:	cd 40                	int    $0x40
    144b:	c3                   	ret    

0000144c <fstat>:
SYSCALL(fstat)
    144c:	b8 08 00 00 00       	mov    $0x8,%eax
    1451:	cd 40                	int    $0x40
    1453:	c3                   	ret    

00001454 <link>:
SYSCALL(link)
    1454:	b8 13 00 00 00       	mov    $0x13,%eax
    1459:	cd 40                	int    $0x40
    145b:	c3                   	ret    

0000145c <mkdir>:
SYSCALL(mkdir)
    145c:	b8 14 00 00 00       	mov    $0x14,%eax
    1461:	cd 40                	int    $0x40
    1463:	c3                   	ret    

00001464 <chdir>:
SYSCALL(chdir)
    1464:	b8 09 00 00 00       	mov    $0x9,%eax
    1469:	cd 40                	int    $0x40
    146b:	c3                   	ret    

0000146c <dup>:
SYSCALL(dup)
    146c:	b8 0a 00 00 00       	mov    $0xa,%eax
    1471:	cd 40                	int    $0x40
    1473:	c3                   	ret    

00001474 <getpid>:
SYSCALL(getpid)
    1474:	b8 0b 00 00 00       	mov    $0xb,%eax
    1479:	cd 40                	int    $0x40
    147b:	c3                   	ret    

0000147c <sbrk>:
SYSCALL(sbrk)
    147c:	b8 0c 00 00 00       	mov    $0xc,%eax
    1481:	cd 40                	int    $0x40
    1483:	c3                   	ret    

00001484 <sleep>:
SYSCALL(sleep)
    1484:	b8 0d 00 00 00       	mov    $0xd,%eax
    1489:	cd 40                	int    $0x40
    148b:	c3                   	ret    

0000148c <uptime>:
SYSCALL(uptime)
    148c:	b8 0e 00 00 00       	mov    $0xe,%eax
    1491:	cd 40                	int    $0x40
    1493:	c3                   	ret    

00001494 <getprocsinfo>:
SYSCALL(getprocsinfo)
    1494:	b8 16 00 00 00       	mov    $0x16,%eax
    1499:	cd 40                	int    $0x40
    149b:	c3                   	ret    

0000149c <shmem_access>:
SYSCALL(shmem_access)
    149c:	b8 17 00 00 00       	mov    $0x17,%eax
    14a1:	cd 40                	int    $0x40
    14a3:	c3                   	ret    

000014a4 <shmem_count>:
SYSCALL(shmem_count)
    14a4:	b8 18 00 00 00       	mov    $0x18,%eax
    14a9:	cd 40                	int    $0x40
    14ab:	c3                   	ret    

000014ac <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14ac:	55                   	push   %ebp
    14ad:	89 e5                	mov    %esp,%ebp
    14af:	83 ec 18             	sub    $0x18,%esp
    14b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    14b5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14b8:	83 ec 04             	sub    $0x4,%esp
    14bb:	6a 01                	push   $0x1
    14bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
    14c0:	50                   	push   %eax
    14c1:	ff 75 08             	pushl  0x8(%ebp)
    14c4:	e8 4b ff ff ff       	call   1414 <write>
    14c9:	83 c4 10             	add    $0x10,%esp
}
    14cc:	90                   	nop
    14cd:	c9                   	leave  
    14ce:	c3                   	ret    

000014cf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    14cf:	55                   	push   %ebp
    14d0:	89 e5                	mov    %esp,%ebp
    14d2:	53                   	push   %ebx
    14d3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    14d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    14dd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    14e1:	74 17                	je     14fa <printint+0x2b>
    14e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    14e7:	79 11                	jns    14fa <printint+0x2b>
    neg = 1;
    14e9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    14f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    14f3:	f7 d8                	neg    %eax
    14f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14f8:	eb 06                	jmp    1500 <printint+0x31>
  } else {
    x = xx;
    14fa:	8b 45 0c             	mov    0xc(%ebp),%eax
    14fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1500:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1507:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    150a:	8d 41 01             	lea    0x1(%ecx),%eax
    150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1510:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1513:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1516:	ba 00 00 00 00       	mov    $0x0,%edx
    151b:	f7 f3                	div    %ebx
    151d:	89 d0                	mov    %edx,%eax
    151f:	0f b6 80 7c 1c 00 00 	movzbl 0x1c7c(%eax),%eax
    1526:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    152a:	8b 5d 10             	mov    0x10(%ebp),%ebx
    152d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1530:	ba 00 00 00 00       	mov    $0x0,%edx
    1535:	f7 f3                	div    %ebx
    1537:	89 45 ec             	mov    %eax,-0x14(%ebp)
    153a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    153e:	75 c7                	jne    1507 <printint+0x38>
  if(neg)
    1540:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1544:	74 2d                	je     1573 <printint+0xa4>
    buf[i++] = '-';
    1546:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1549:	8d 50 01             	lea    0x1(%eax),%edx
    154c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    154f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1554:	eb 1d                	jmp    1573 <printint+0xa4>
    putc(fd, buf[i]);
    1556:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1559:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155c:	01 d0                	add    %edx,%eax
    155e:	0f b6 00             	movzbl (%eax),%eax
    1561:	0f be c0             	movsbl %al,%eax
    1564:	83 ec 08             	sub    $0x8,%esp
    1567:	50                   	push   %eax
    1568:	ff 75 08             	pushl  0x8(%ebp)
    156b:	e8 3c ff ff ff       	call   14ac <putc>
    1570:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1573:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    157b:	79 d9                	jns    1556 <printint+0x87>
    putc(fd, buf[i]);
}
    157d:	90                   	nop
    157e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1581:	c9                   	leave  
    1582:	c3                   	ret    

00001583 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1583:	55                   	push   %ebp
    1584:	89 e5                	mov    %esp,%ebp
    1586:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1589:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1590:	8d 45 0c             	lea    0xc(%ebp),%eax
    1593:	83 c0 04             	add    $0x4,%eax
    1596:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1599:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15a0:	e9 59 01 00 00       	jmp    16fe <printf+0x17b>
    c = fmt[i] & 0xff;
    15a5:	8b 55 0c             	mov    0xc(%ebp),%edx
    15a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15ab:	01 d0                	add    %edx,%eax
    15ad:	0f b6 00             	movzbl (%eax),%eax
    15b0:	0f be c0             	movsbl %al,%eax
    15b3:	25 ff 00 00 00       	and    $0xff,%eax
    15b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    15bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15bf:	75 2c                	jne    15ed <printf+0x6a>
      if(c == '%'){
    15c1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15c5:	75 0c                	jne    15d3 <printf+0x50>
        state = '%';
    15c7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    15ce:	e9 27 01 00 00       	jmp    16fa <printf+0x177>
      } else {
        putc(fd, c);
    15d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15d6:	0f be c0             	movsbl %al,%eax
    15d9:	83 ec 08             	sub    $0x8,%esp
    15dc:	50                   	push   %eax
    15dd:	ff 75 08             	pushl  0x8(%ebp)
    15e0:	e8 c7 fe ff ff       	call   14ac <putc>
    15e5:	83 c4 10             	add    $0x10,%esp
    15e8:	e9 0d 01 00 00       	jmp    16fa <printf+0x177>
      }
    } else if(state == '%'){
    15ed:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    15f1:	0f 85 03 01 00 00    	jne    16fa <printf+0x177>
      if(c == 'd'){
    15f7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15fb:	75 1e                	jne    161b <printf+0x98>
        printint(fd, *ap, 10, 1);
    15fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1600:	8b 00                	mov    (%eax),%eax
    1602:	6a 01                	push   $0x1
    1604:	6a 0a                	push   $0xa
    1606:	50                   	push   %eax
    1607:	ff 75 08             	pushl  0x8(%ebp)
    160a:	e8 c0 fe ff ff       	call   14cf <printint>
    160f:	83 c4 10             	add    $0x10,%esp
        ap++;
    1612:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1616:	e9 d8 00 00 00       	jmp    16f3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    161b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    161f:	74 06                	je     1627 <printf+0xa4>
    1621:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1625:	75 1e                	jne    1645 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    1627:	8b 45 e8             	mov    -0x18(%ebp),%eax
    162a:	8b 00                	mov    (%eax),%eax
    162c:	6a 00                	push   $0x0
    162e:	6a 10                	push   $0x10
    1630:	50                   	push   %eax
    1631:	ff 75 08             	pushl  0x8(%ebp)
    1634:	e8 96 fe ff ff       	call   14cf <printint>
    1639:	83 c4 10             	add    $0x10,%esp
        ap++;
    163c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1640:	e9 ae 00 00 00       	jmp    16f3 <printf+0x170>
      } else if(c == 's'){
    1645:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1649:	75 43                	jne    168e <printf+0x10b>
        s = (char*)*ap;
    164b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    164e:	8b 00                	mov    (%eax),%eax
    1650:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1653:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    165b:	75 25                	jne    1682 <printf+0xff>
          s = "(null)";
    165d:	c7 45 f4 2c 1a 00 00 	movl   $0x1a2c,-0xc(%ebp)
        while(*s != 0){
    1664:	eb 1c                	jmp    1682 <printf+0xff>
          putc(fd, *s);
    1666:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1669:	0f b6 00             	movzbl (%eax),%eax
    166c:	0f be c0             	movsbl %al,%eax
    166f:	83 ec 08             	sub    $0x8,%esp
    1672:	50                   	push   %eax
    1673:	ff 75 08             	pushl  0x8(%ebp)
    1676:	e8 31 fe ff ff       	call   14ac <putc>
    167b:	83 c4 10             	add    $0x10,%esp
          s++;
    167e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1682:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1685:	0f b6 00             	movzbl (%eax),%eax
    1688:	84 c0                	test   %al,%al
    168a:	75 da                	jne    1666 <printf+0xe3>
    168c:	eb 65                	jmp    16f3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    168e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1692:	75 1d                	jne    16b1 <printf+0x12e>
        putc(fd, *ap);
    1694:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1697:	8b 00                	mov    (%eax),%eax
    1699:	0f be c0             	movsbl %al,%eax
    169c:	83 ec 08             	sub    $0x8,%esp
    169f:	50                   	push   %eax
    16a0:	ff 75 08             	pushl  0x8(%ebp)
    16a3:	e8 04 fe ff ff       	call   14ac <putc>
    16a8:	83 c4 10             	add    $0x10,%esp
        ap++;
    16ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16af:	eb 42                	jmp    16f3 <printf+0x170>
      } else if(c == '%'){
    16b1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16b5:	75 17                	jne    16ce <printf+0x14b>
        putc(fd, c);
    16b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16ba:	0f be c0             	movsbl %al,%eax
    16bd:	83 ec 08             	sub    $0x8,%esp
    16c0:	50                   	push   %eax
    16c1:	ff 75 08             	pushl  0x8(%ebp)
    16c4:	e8 e3 fd ff ff       	call   14ac <putc>
    16c9:	83 c4 10             	add    $0x10,%esp
    16cc:	eb 25                	jmp    16f3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    16ce:	83 ec 08             	sub    $0x8,%esp
    16d1:	6a 25                	push   $0x25
    16d3:	ff 75 08             	pushl  0x8(%ebp)
    16d6:	e8 d1 fd ff ff       	call   14ac <putc>
    16db:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    16de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16e1:	0f be c0             	movsbl %al,%eax
    16e4:	83 ec 08             	sub    $0x8,%esp
    16e7:	50                   	push   %eax
    16e8:	ff 75 08             	pushl  0x8(%ebp)
    16eb:	e8 bc fd ff ff       	call   14ac <putc>
    16f0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    16f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16fa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16fe:	8b 55 0c             	mov    0xc(%ebp),%edx
    1701:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1704:	01 d0                	add    %edx,%eax
    1706:	0f b6 00             	movzbl (%eax),%eax
    1709:	84 c0                	test   %al,%al
    170b:	0f 85 94 fe ff ff    	jne    15a5 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1711:	90                   	nop
    1712:	c9                   	leave  
    1713:	c3                   	ret    

00001714 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1714:	55                   	push   %ebp
    1715:	89 e5                	mov    %esp,%ebp
    1717:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    171a:	8b 45 08             	mov    0x8(%ebp),%eax
    171d:	83 e8 08             	sub    $0x8,%eax
    1720:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1723:	a1 98 1c 00 00       	mov    0x1c98,%eax
    1728:	89 45 fc             	mov    %eax,-0x4(%ebp)
    172b:	eb 24                	jmp    1751 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    172d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1730:	8b 00                	mov    (%eax),%eax
    1732:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1735:	77 12                	ja     1749 <free+0x35>
    1737:	8b 45 f8             	mov    -0x8(%ebp),%eax
    173a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    173d:	77 24                	ja     1763 <free+0x4f>
    173f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1742:	8b 00                	mov    (%eax),%eax
    1744:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1747:	77 1a                	ja     1763 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1749:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174c:	8b 00                	mov    (%eax),%eax
    174e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1751:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1754:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1757:	76 d4                	jbe    172d <free+0x19>
    1759:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175c:	8b 00                	mov    (%eax),%eax
    175e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1761:	76 ca                	jbe    172d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1763:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1766:	8b 40 04             	mov    0x4(%eax),%eax
    1769:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1770:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1773:	01 c2                	add    %eax,%edx
    1775:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1778:	8b 00                	mov    (%eax),%eax
    177a:	39 c2                	cmp    %eax,%edx
    177c:	75 24                	jne    17a2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    177e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1781:	8b 50 04             	mov    0x4(%eax),%edx
    1784:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1787:	8b 00                	mov    (%eax),%eax
    1789:	8b 40 04             	mov    0x4(%eax),%eax
    178c:	01 c2                	add    %eax,%edx
    178e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1791:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1794:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1797:	8b 00                	mov    (%eax),%eax
    1799:	8b 10                	mov    (%eax),%edx
    179b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    179e:	89 10                	mov    %edx,(%eax)
    17a0:	eb 0a                	jmp    17ac <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    17a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a5:	8b 10                	mov    (%eax),%edx
    17a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17aa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    17ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17af:	8b 40 04             	mov    0x4(%eax),%eax
    17b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17bc:	01 d0                	add    %edx,%eax
    17be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17c1:	75 20                	jne    17e3 <free+0xcf>
    p->s.size += bp->s.size;
    17c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c6:	8b 50 04             	mov    0x4(%eax),%edx
    17c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17cc:	8b 40 04             	mov    0x4(%eax),%eax
    17cf:	01 c2                	add    %eax,%edx
    17d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17d4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17da:	8b 10                	mov    (%eax),%edx
    17dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17df:	89 10                	mov    %edx,(%eax)
    17e1:	eb 08                	jmp    17eb <free+0xd7>
  } else
    p->s.ptr = bp;
    17e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17e9:	89 10                	mov    %edx,(%eax)
  freep = p;
    17eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ee:	a3 98 1c 00 00       	mov    %eax,0x1c98
}
    17f3:	90                   	nop
    17f4:	c9                   	leave  
    17f5:	c3                   	ret    

000017f6 <morecore>:

static Header*
morecore(uint nu)
{
    17f6:	55                   	push   %ebp
    17f7:	89 e5                	mov    %esp,%ebp
    17f9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17fc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1803:	77 07                	ja     180c <morecore+0x16>
    nu = 4096;
    1805:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    180c:	8b 45 08             	mov    0x8(%ebp),%eax
    180f:	c1 e0 03             	shl    $0x3,%eax
    1812:	83 ec 0c             	sub    $0xc,%esp
    1815:	50                   	push   %eax
    1816:	e8 61 fc ff ff       	call   147c <sbrk>
    181b:	83 c4 10             	add    $0x10,%esp
    181e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1821:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1825:	75 07                	jne    182e <morecore+0x38>
    return 0;
    1827:	b8 00 00 00 00       	mov    $0x0,%eax
    182c:	eb 26                	jmp    1854 <morecore+0x5e>
  hp = (Header*)p;
    182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1831:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1834:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1837:	8b 55 08             	mov    0x8(%ebp),%edx
    183a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    183d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1840:	83 c0 08             	add    $0x8,%eax
    1843:	83 ec 0c             	sub    $0xc,%esp
    1846:	50                   	push   %eax
    1847:	e8 c8 fe ff ff       	call   1714 <free>
    184c:	83 c4 10             	add    $0x10,%esp
  return freep;
    184f:	a1 98 1c 00 00       	mov    0x1c98,%eax
}
    1854:	c9                   	leave  
    1855:	c3                   	ret    

00001856 <malloc>:

void*
malloc(uint nbytes)
{
    1856:	55                   	push   %ebp
    1857:	89 e5                	mov    %esp,%ebp
    1859:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    185c:	8b 45 08             	mov    0x8(%ebp),%eax
    185f:	83 c0 07             	add    $0x7,%eax
    1862:	c1 e8 03             	shr    $0x3,%eax
    1865:	83 c0 01             	add    $0x1,%eax
    1868:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    186b:	a1 98 1c 00 00       	mov    0x1c98,%eax
    1870:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1873:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1877:	75 23                	jne    189c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1879:	c7 45 f0 90 1c 00 00 	movl   $0x1c90,-0x10(%ebp)
    1880:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1883:	a3 98 1c 00 00       	mov    %eax,0x1c98
    1888:	a1 98 1c 00 00       	mov    0x1c98,%eax
    188d:	a3 90 1c 00 00       	mov    %eax,0x1c90
    base.s.size = 0;
    1892:	c7 05 94 1c 00 00 00 	movl   $0x0,0x1c94
    1899:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    189c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    189f:	8b 00                	mov    (%eax),%eax
    18a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    18a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a7:	8b 40 04             	mov    0x4(%eax),%eax
    18aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18ad:	72 4d                	jb     18fc <malloc+0xa6>
      if(p->s.size == nunits)
    18af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b2:	8b 40 04             	mov    0x4(%eax),%eax
    18b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18b8:	75 0c                	jne    18c6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    18ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18bd:	8b 10                	mov    (%eax),%edx
    18bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18c2:	89 10                	mov    %edx,(%eax)
    18c4:	eb 26                	jmp    18ec <malloc+0x96>
      else {
        p->s.size -= nunits;
    18c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c9:	8b 40 04             	mov    0x4(%eax),%eax
    18cc:	2b 45 ec             	sub    -0x14(%ebp),%eax
    18cf:	89 c2                	mov    %eax,%edx
    18d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18d4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    18d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18da:	8b 40 04             	mov    0x4(%eax),%eax
    18dd:	c1 e0 03             	shl    $0x3,%eax
    18e0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18e9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18ef:	a3 98 1c 00 00       	mov    %eax,0x1c98
      return (void*)(p + 1);
    18f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f7:	83 c0 08             	add    $0x8,%eax
    18fa:	eb 3b                	jmp    1937 <malloc+0xe1>
    }
    if(p == freep)
    18fc:	a1 98 1c 00 00       	mov    0x1c98,%eax
    1901:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1904:	75 1e                	jne    1924 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    1906:	83 ec 0c             	sub    $0xc,%esp
    1909:	ff 75 ec             	pushl  -0x14(%ebp)
    190c:	e8 e5 fe ff ff       	call   17f6 <morecore>
    1911:	83 c4 10             	add    $0x10,%esp
    1914:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1917:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    191b:	75 07                	jne    1924 <malloc+0xce>
        return 0;
    191d:	b8 00 00 00 00       	mov    $0x0,%eax
    1922:	eb 13                	jmp    1937 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1924:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1927:	89 45 f0             	mov    %eax,-0x10(%ebp)
    192a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    192d:	8b 00                	mov    (%eax),%eax
    192f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1932:	e9 6d ff ff ff       	jmp    18a4 <malloc+0x4e>
}
    1937:	c9                   	leave  
    1938:	c3                   	ret    
