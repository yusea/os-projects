
_grep:     file format elf32-i386


Disassembly of section .text:

00001000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;

  m = 0;
    1006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    100d:	e9 b6 00 00 00       	jmp    10c8 <grep+0xc8>
    m += n;
    1012:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1015:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
    1018:	8b 45 f4             	mov    -0xc(%ebp),%eax
    101b:	05 20 1e 00 00       	add    $0x1e20,%eax
    1020:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
    1023:	c7 45 f0 20 1e 00 00 	movl   $0x1e20,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
    102a:	eb 4a                	jmp    1076 <grep+0x76>
      *q = 0;
    102c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    102f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
    1032:	83 ec 08             	sub    $0x8,%esp
    1035:	ff 75 f0             	pushl  -0x10(%ebp)
    1038:	ff 75 08             	pushl  0x8(%ebp)
    103b:	e8 9a 01 00 00       	call   11da <match>
    1040:	83 c4 10             	add    $0x10,%esp
    1043:	85 c0                	test   %eax,%eax
    1045:	74 26                	je     106d <grep+0x6d>
        *q = '\n';
    1047:	8b 45 e8             	mov    -0x18(%ebp),%eax
    104a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
    104d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1050:	83 c0 01             	add    $0x1,%eax
    1053:	89 c2                	mov    %eax,%edx
    1055:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1058:	29 c2                	sub    %eax,%edx
    105a:	89 d0                	mov    %edx,%eax
    105c:	83 ec 04             	sub    $0x4,%esp
    105f:	50                   	push   %eax
    1060:	ff 75 f0             	pushl  -0x10(%ebp)
    1063:	6a 01                	push   $0x1
    1065:	e8 43 05 00 00       	call   15ad <write>
    106a:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
    106d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1070:	83 c0 01             	add    $0x1,%eax
    1073:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
    1076:	83 ec 08             	sub    $0x8,%esp
    1079:	6a 0a                	push   $0xa
    107b:	ff 75 f0             	pushl  -0x10(%ebp)
    107e:	e8 89 03 00 00       	call   140c <strchr>
    1083:	83 c4 10             	add    $0x10,%esp
    1086:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1089:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    108d:	75 9d                	jne    102c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
    108f:	81 7d f0 20 1e 00 00 	cmpl   $0x1e20,-0x10(%ebp)
    1096:	75 07                	jne    109f <grep+0x9f>
      m = 0;
    1098:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
    109f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10a3:	7e 23                	jle    10c8 <grep+0xc8>
      m -= p - buf;
    10a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10a8:	ba 20 1e 00 00       	mov    $0x1e20,%edx
    10ad:	29 d0                	sub    %edx,%eax
    10af:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
    10b2:	83 ec 04             	sub    $0x4,%esp
    10b5:	ff 75 f4             	pushl  -0xc(%ebp)
    10b8:	ff 75 f0             	pushl  -0x10(%ebp)
    10bb:	68 20 1e 00 00       	push   $0x1e20
    10c0:	e8 83 04 00 00       	call   1548 <memmove>
    10c5:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;

  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    10c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10cb:	ba ff 03 00 00       	mov    $0x3ff,%edx
    10d0:	29 c2                	sub    %eax,%edx
    10d2:	89 d0                	mov    %edx,%eax
    10d4:	89 c2                	mov    %eax,%edx
    10d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10d9:	05 20 1e 00 00       	add    $0x1e20,%eax
    10de:	83 ec 04             	sub    $0x4,%esp
    10e1:	52                   	push   %edx
    10e2:	50                   	push   %eax
    10e3:	ff 75 0c             	pushl  0xc(%ebp)
    10e6:	e8 ba 04 00 00       	call   15a5 <read>
    10eb:	83 c4 10             	add    $0x10,%esp
    10ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    10f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10f5:	0f 8f 17 ff ff ff    	jg     1012 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
    10fb:	90                   	nop
    10fc:	c9                   	leave  
    10fd:	c3                   	ret    

000010fe <main>:

int
main(int argc, char *argv[])
{
    10fe:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1102:	83 e4 f0             	and    $0xfffffff0,%esp
    1105:	ff 71 fc             	pushl  -0x4(%ecx)
    1108:	55                   	push   %ebp
    1109:	89 e5                	mov    %esp,%ebp
    110b:	53                   	push   %ebx
    110c:	51                   	push   %ecx
    110d:	83 ec 10             	sub    $0x10,%esp
    1110:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
    1112:	83 3b 01             	cmpl   $0x1,(%ebx)
    1115:	7f 17                	jg     112e <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
    1117:	83 ec 08             	sub    $0x8,%esp
    111a:	68 d4 1a 00 00       	push   $0x1ad4
    111f:	6a 02                	push   $0x2
    1121:	e8 f6 05 00 00       	call   171c <printf>
    1126:	83 c4 10             	add    $0x10,%esp
    exit();
    1129:	e8 5f 04 00 00       	call   158d <exit>
  }
  pattern = argv[1];
    112e:	8b 43 04             	mov    0x4(%ebx),%eax
    1131:	8b 40 04             	mov    0x4(%eax),%eax
    1134:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(argc <= 2){
    1137:	83 3b 02             	cmpl   $0x2,(%ebx)
    113a:	7f 15                	jg     1151 <main+0x53>
    grep(pattern, 0);
    113c:	83 ec 08             	sub    $0x8,%esp
    113f:	6a 00                	push   $0x0
    1141:	ff 75 f0             	pushl  -0x10(%ebp)
    1144:	e8 b7 fe ff ff       	call   1000 <grep>
    1149:	83 c4 10             	add    $0x10,%esp
    exit();
    114c:	e8 3c 04 00 00       	call   158d <exit>
  }

  for(i = 2; i < argc; i++){
    1151:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
    1158:	eb 74                	jmp    11ce <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
    115a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    115d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1164:	8b 43 04             	mov    0x4(%ebx),%eax
    1167:	01 d0                	add    %edx,%eax
    1169:	8b 00                	mov    (%eax),%eax
    116b:	83 ec 08             	sub    $0x8,%esp
    116e:	6a 00                	push   $0x0
    1170:	50                   	push   %eax
    1171:	e8 57 04 00 00       	call   15cd <open>
    1176:	83 c4 10             	add    $0x10,%esp
    1179:	89 45 ec             	mov    %eax,-0x14(%ebp)
    117c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1180:	79 29                	jns    11ab <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
    1182:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1185:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    118c:	8b 43 04             	mov    0x4(%ebx),%eax
    118f:	01 d0                	add    %edx,%eax
    1191:	8b 00                	mov    (%eax),%eax
    1193:	83 ec 04             	sub    $0x4,%esp
    1196:	50                   	push   %eax
    1197:	68 f4 1a 00 00       	push   $0x1af4
    119c:	6a 01                	push   $0x1
    119e:	e8 79 05 00 00       	call   171c <printf>
    11a3:	83 c4 10             	add    $0x10,%esp
      exit();
    11a6:	e8 e2 03 00 00       	call   158d <exit>
    }
    grep(pattern, fd);
    11ab:	83 ec 08             	sub    $0x8,%esp
    11ae:	ff 75 ec             	pushl  -0x14(%ebp)
    11b1:	ff 75 f0             	pushl  -0x10(%ebp)
    11b4:	e8 47 fe ff ff       	call   1000 <grep>
    11b9:	83 c4 10             	add    $0x10,%esp
    close(fd);
    11bc:	83 ec 0c             	sub    $0xc,%esp
    11bf:	ff 75 ec             	pushl  -0x14(%ebp)
    11c2:	e8 ee 03 00 00       	call   15b5 <close>
    11c7:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
    11ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d1:	3b 03                	cmp    (%ebx),%eax
    11d3:	7c 85                	jl     115a <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
    11d5:	e8 b3 03 00 00       	call   158d <exit>

000011da <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
    11da:	55                   	push   %ebp
    11db:	89 e5                	mov    %esp,%ebp
    11dd:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
    11e0:	8b 45 08             	mov    0x8(%ebp),%eax
    11e3:	0f b6 00             	movzbl (%eax),%eax
    11e6:	3c 5e                	cmp    $0x5e,%al
    11e8:	75 17                	jne    1201 <match+0x27>
    return matchhere(re+1, text);
    11ea:	8b 45 08             	mov    0x8(%ebp),%eax
    11ed:	83 c0 01             	add    $0x1,%eax
    11f0:	83 ec 08             	sub    $0x8,%esp
    11f3:	ff 75 0c             	pushl  0xc(%ebp)
    11f6:	50                   	push   %eax
    11f7:	e8 38 00 00 00       	call   1234 <matchhere>
    11fc:	83 c4 10             	add    $0x10,%esp
    11ff:	eb 31                	jmp    1232 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
    1201:	83 ec 08             	sub    $0x8,%esp
    1204:	ff 75 0c             	pushl  0xc(%ebp)
    1207:	ff 75 08             	pushl  0x8(%ebp)
    120a:	e8 25 00 00 00       	call   1234 <matchhere>
    120f:	83 c4 10             	add    $0x10,%esp
    1212:	85 c0                	test   %eax,%eax
    1214:	74 07                	je     121d <match+0x43>
      return 1;
    1216:	b8 01 00 00 00       	mov    $0x1,%eax
    121b:	eb 15                	jmp    1232 <match+0x58>
  }while(*text++ != '\0');
    121d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1220:	8d 50 01             	lea    0x1(%eax),%edx
    1223:	89 55 0c             	mov    %edx,0xc(%ebp)
    1226:	0f b6 00             	movzbl (%eax),%eax
    1229:	84 c0                	test   %al,%al
    122b:	75 d4                	jne    1201 <match+0x27>
  return 0;
    122d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1232:	c9                   	leave  
    1233:	c3                   	ret    

00001234 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
    1234:	55                   	push   %ebp
    1235:	89 e5                	mov    %esp,%ebp
    1237:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
    123a:	8b 45 08             	mov    0x8(%ebp),%eax
    123d:	0f b6 00             	movzbl (%eax),%eax
    1240:	84 c0                	test   %al,%al
    1242:	75 0a                	jne    124e <matchhere+0x1a>
    return 1;
    1244:	b8 01 00 00 00       	mov    $0x1,%eax
    1249:	e9 99 00 00 00       	jmp    12e7 <matchhere+0xb3>
  if(re[1] == '*')
    124e:	8b 45 08             	mov    0x8(%ebp),%eax
    1251:	83 c0 01             	add    $0x1,%eax
    1254:	0f b6 00             	movzbl (%eax),%eax
    1257:	3c 2a                	cmp    $0x2a,%al
    1259:	75 21                	jne    127c <matchhere+0x48>
    return matchstar(re[0], re+2, text);
    125b:	8b 45 08             	mov    0x8(%ebp),%eax
    125e:	8d 50 02             	lea    0x2(%eax),%edx
    1261:	8b 45 08             	mov    0x8(%ebp),%eax
    1264:	0f b6 00             	movzbl (%eax),%eax
    1267:	0f be c0             	movsbl %al,%eax
    126a:	83 ec 04             	sub    $0x4,%esp
    126d:	ff 75 0c             	pushl  0xc(%ebp)
    1270:	52                   	push   %edx
    1271:	50                   	push   %eax
    1272:	e8 72 00 00 00       	call   12e9 <matchstar>
    1277:	83 c4 10             	add    $0x10,%esp
    127a:	eb 6b                	jmp    12e7 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
    127c:	8b 45 08             	mov    0x8(%ebp),%eax
    127f:	0f b6 00             	movzbl (%eax),%eax
    1282:	3c 24                	cmp    $0x24,%al
    1284:	75 1d                	jne    12a3 <matchhere+0x6f>
    1286:	8b 45 08             	mov    0x8(%ebp),%eax
    1289:	83 c0 01             	add    $0x1,%eax
    128c:	0f b6 00             	movzbl (%eax),%eax
    128f:	84 c0                	test   %al,%al
    1291:	75 10                	jne    12a3 <matchhere+0x6f>
    return *text == '\0';
    1293:	8b 45 0c             	mov    0xc(%ebp),%eax
    1296:	0f b6 00             	movzbl (%eax),%eax
    1299:	84 c0                	test   %al,%al
    129b:	0f 94 c0             	sete   %al
    129e:	0f b6 c0             	movzbl %al,%eax
    12a1:	eb 44                	jmp    12e7 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    12a3:	8b 45 0c             	mov    0xc(%ebp),%eax
    12a6:	0f b6 00             	movzbl (%eax),%eax
    12a9:	84 c0                	test   %al,%al
    12ab:	74 35                	je     12e2 <matchhere+0xae>
    12ad:	8b 45 08             	mov    0x8(%ebp),%eax
    12b0:	0f b6 00             	movzbl (%eax),%eax
    12b3:	3c 2e                	cmp    $0x2e,%al
    12b5:	74 10                	je     12c7 <matchhere+0x93>
    12b7:	8b 45 08             	mov    0x8(%ebp),%eax
    12ba:	0f b6 10             	movzbl (%eax),%edx
    12bd:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c0:	0f b6 00             	movzbl (%eax),%eax
    12c3:	38 c2                	cmp    %al,%dl
    12c5:	75 1b                	jne    12e2 <matchhere+0xae>
    return matchhere(re+1, text+1);
    12c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ca:	8d 50 01             	lea    0x1(%eax),%edx
    12cd:	8b 45 08             	mov    0x8(%ebp),%eax
    12d0:	83 c0 01             	add    $0x1,%eax
    12d3:	83 ec 08             	sub    $0x8,%esp
    12d6:	52                   	push   %edx
    12d7:	50                   	push   %eax
    12d8:	e8 57 ff ff ff       	call   1234 <matchhere>
    12dd:	83 c4 10             	add    $0x10,%esp
    12e0:	eb 05                	jmp    12e7 <matchhere+0xb3>
  return 0;
    12e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12e7:	c9                   	leave  
    12e8:	c3                   	ret    

000012e9 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    12e9:	55                   	push   %ebp
    12ea:	89 e5                	mov    %esp,%ebp
    12ec:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
    12ef:	83 ec 08             	sub    $0x8,%esp
    12f2:	ff 75 10             	pushl  0x10(%ebp)
    12f5:	ff 75 0c             	pushl  0xc(%ebp)
    12f8:	e8 37 ff ff ff       	call   1234 <matchhere>
    12fd:	83 c4 10             	add    $0x10,%esp
    1300:	85 c0                	test   %eax,%eax
    1302:	74 07                	je     130b <matchstar+0x22>
      return 1;
    1304:	b8 01 00 00 00       	mov    $0x1,%eax
    1309:	eb 29                	jmp    1334 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
    130b:	8b 45 10             	mov    0x10(%ebp),%eax
    130e:	0f b6 00             	movzbl (%eax),%eax
    1311:	84 c0                	test   %al,%al
    1313:	74 1a                	je     132f <matchstar+0x46>
    1315:	8b 45 10             	mov    0x10(%ebp),%eax
    1318:	8d 50 01             	lea    0x1(%eax),%edx
    131b:	89 55 10             	mov    %edx,0x10(%ebp)
    131e:	0f b6 00             	movzbl (%eax),%eax
    1321:	0f be c0             	movsbl %al,%eax
    1324:	3b 45 08             	cmp    0x8(%ebp),%eax
    1327:	74 c6                	je     12ef <matchstar+0x6>
    1329:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
    132d:	74 c0                	je     12ef <matchstar+0x6>
  return 0;
    132f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1334:	c9                   	leave  
    1335:	c3                   	ret    

00001336 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1336:	55                   	push   %ebp
    1337:	89 e5                	mov    %esp,%ebp
    1339:	57                   	push   %edi
    133a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    133b:	8b 4d 08             	mov    0x8(%ebp),%ecx
    133e:	8b 55 10             	mov    0x10(%ebp),%edx
    1341:	8b 45 0c             	mov    0xc(%ebp),%eax
    1344:	89 cb                	mov    %ecx,%ebx
    1346:	89 df                	mov    %ebx,%edi
    1348:	89 d1                	mov    %edx,%ecx
    134a:	fc                   	cld    
    134b:	f3 aa                	rep stos %al,%es:(%edi)
    134d:	89 ca                	mov    %ecx,%edx
    134f:	89 fb                	mov    %edi,%ebx
    1351:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1354:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1357:	90                   	nop
    1358:	5b                   	pop    %ebx
    1359:	5f                   	pop    %edi
    135a:	5d                   	pop    %ebp
    135b:	c3                   	ret    

0000135c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    135c:	55                   	push   %ebp
    135d:	89 e5                	mov    %esp,%ebp
    135f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1362:	8b 45 08             	mov    0x8(%ebp),%eax
    1365:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1368:	90                   	nop
    1369:	8b 45 08             	mov    0x8(%ebp),%eax
    136c:	8d 50 01             	lea    0x1(%eax),%edx
    136f:	89 55 08             	mov    %edx,0x8(%ebp)
    1372:	8b 55 0c             	mov    0xc(%ebp),%edx
    1375:	8d 4a 01             	lea    0x1(%edx),%ecx
    1378:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    137b:	0f b6 12             	movzbl (%edx),%edx
    137e:	88 10                	mov    %dl,(%eax)
    1380:	0f b6 00             	movzbl (%eax),%eax
    1383:	84 c0                	test   %al,%al
    1385:	75 e2                	jne    1369 <strcpy+0xd>
    ;
  return os;
    1387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    138a:	c9                   	leave  
    138b:	c3                   	ret    

0000138c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    138c:	55                   	push   %ebp
    138d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    138f:	eb 08                	jmp    1399 <strcmp+0xd>
    p++, q++;
    1391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1395:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1399:	8b 45 08             	mov    0x8(%ebp),%eax
    139c:	0f b6 00             	movzbl (%eax),%eax
    139f:	84 c0                	test   %al,%al
    13a1:	74 10                	je     13b3 <strcmp+0x27>
    13a3:	8b 45 08             	mov    0x8(%ebp),%eax
    13a6:	0f b6 10             	movzbl (%eax),%edx
    13a9:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ac:	0f b6 00             	movzbl (%eax),%eax
    13af:	38 c2                	cmp    %al,%dl
    13b1:	74 de                	je     1391 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    13b3:	8b 45 08             	mov    0x8(%ebp),%eax
    13b6:	0f b6 00             	movzbl (%eax),%eax
    13b9:	0f b6 d0             	movzbl %al,%edx
    13bc:	8b 45 0c             	mov    0xc(%ebp),%eax
    13bf:	0f b6 00             	movzbl (%eax),%eax
    13c2:	0f b6 c0             	movzbl %al,%eax
    13c5:	29 c2                	sub    %eax,%edx
    13c7:	89 d0                	mov    %edx,%eax
}
    13c9:	5d                   	pop    %ebp
    13ca:	c3                   	ret    

000013cb <strlen>:

uint
strlen(const char *s)
{
    13cb:	55                   	push   %ebp
    13cc:	89 e5                	mov    %esp,%ebp
    13ce:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    13d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    13d8:	eb 04                	jmp    13de <strlen+0x13>
    13da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    13de:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13e1:	8b 45 08             	mov    0x8(%ebp),%eax
    13e4:	01 d0                	add    %edx,%eax
    13e6:	0f b6 00             	movzbl (%eax),%eax
    13e9:	84 c0                	test   %al,%al
    13eb:	75 ed                	jne    13da <strlen+0xf>
    ;
  return n;
    13ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13f0:	c9                   	leave  
    13f1:	c3                   	ret    

000013f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
    13f2:	55                   	push   %ebp
    13f3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    13f5:	8b 45 10             	mov    0x10(%ebp),%eax
    13f8:	50                   	push   %eax
    13f9:	ff 75 0c             	pushl  0xc(%ebp)
    13fc:	ff 75 08             	pushl  0x8(%ebp)
    13ff:	e8 32 ff ff ff       	call   1336 <stosb>
    1404:	83 c4 0c             	add    $0xc,%esp
  return dst;
    1407:	8b 45 08             	mov    0x8(%ebp),%eax
}
    140a:	c9                   	leave  
    140b:	c3                   	ret    

0000140c <strchr>:

char*
strchr(const char *s, char c)
{
    140c:	55                   	push   %ebp
    140d:	89 e5                	mov    %esp,%ebp
    140f:	83 ec 04             	sub    $0x4,%esp
    1412:	8b 45 0c             	mov    0xc(%ebp),%eax
    1415:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1418:	eb 14                	jmp    142e <strchr+0x22>
    if(*s == c)
    141a:	8b 45 08             	mov    0x8(%ebp),%eax
    141d:	0f b6 00             	movzbl (%eax),%eax
    1420:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1423:	75 05                	jne    142a <strchr+0x1e>
      return (char*)s;
    1425:	8b 45 08             	mov    0x8(%ebp),%eax
    1428:	eb 13                	jmp    143d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    142a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    142e:	8b 45 08             	mov    0x8(%ebp),%eax
    1431:	0f b6 00             	movzbl (%eax),%eax
    1434:	84 c0                	test   %al,%al
    1436:	75 e2                	jne    141a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1438:	b8 00 00 00 00       	mov    $0x0,%eax
}
    143d:	c9                   	leave  
    143e:	c3                   	ret    

0000143f <gets>:

char*
gets(char *buf, int max)
{
    143f:	55                   	push   %ebp
    1440:	89 e5                	mov    %esp,%ebp
    1442:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    144c:	eb 42                	jmp    1490 <gets+0x51>
    cc = read(0, &c, 1);
    144e:	83 ec 04             	sub    $0x4,%esp
    1451:	6a 01                	push   $0x1
    1453:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1456:	50                   	push   %eax
    1457:	6a 00                	push   $0x0
    1459:	e8 47 01 00 00       	call   15a5 <read>
    145e:	83 c4 10             	add    $0x10,%esp
    1461:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1468:	7e 33                	jle    149d <gets+0x5e>
      break;
    buf[i++] = c;
    146a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    146d:	8d 50 01             	lea    0x1(%eax),%edx
    1470:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1473:	89 c2                	mov    %eax,%edx
    1475:	8b 45 08             	mov    0x8(%ebp),%eax
    1478:	01 c2                	add    %eax,%edx
    147a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    147e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1480:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1484:	3c 0a                	cmp    $0xa,%al
    1486:	74 16                	je     149e <gets+0x5f>
    1488:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    148c:	3c 0d                	cmp    $0xd,%al
    148e:	74 0e                	je     149e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1490:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1493:	83 c0 01             	add    $0x1,%eax
    1496:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1499:	7c b3                	jl     144e <gets+0xf>
    149b:	eb 01                	jmp    149e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    149d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    149e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14a1:	8b 45 08             	mov    0x8(%ebp),%eax
    14a4:	01 d0                	add    %edx,%eax
    14a6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    14a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14ac:	c9                   	leave  
    14ad:	c3                   	ret    

000014ae <stat>:

int
stat(const char *n, struct stat *st)
{
    14ae:	55                   	push   %ebp
    14af:	89 e5                	mov    %esp,%ebp
    14b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14b4:	83 ec 08             	sub    $0x8,%esp
    14b7:	6a 00                	push   $0x0
    14b9:	ff 75 08             	pushl  0x8(%ebp)
    14bc:	e8 0c 01 00 00       	call   15cd <open>
    14c1:	83 c4 10             	add    $0x10,%esp
    14c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14cb:	79 07                	jns    14d4 <stat+0x26>
    return -1;
    14cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    14d2:	eb 25                	jmp    14f9 <stat+0x4b>
  r = fstat(fd, st);
    14d4:	83 ec 08             	sub    $0x8,%esp
    14d7:	ff 75 0c             	pushl  0xc(%ebp)
    14da:	ff 75 f4             	pushl  -0xc(%ebp)
    14dd:	e8 03 01 00 00       	call   15e5 <fstat>
    14e2:	83 c4 10             	add    $0x10,%esp
    14e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    14e8:	83 ec 0c             	sub    $0xc,%esp
    14eb:	ff 75 f4             	pushl  -0xc(%ebp)
    14ee:	e8 c2 00 00 00       	call   15b5 <close>
    14f3:	83 c4 10             	add    $0x10,%esp
  return r;
    14f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    14f9:	c9                   	leave  
    14fa:	c3                   	ret    

000014fb <atoi>:

int
atoi(const char *s)
{
    14fb:	55                   	push   %ebp
    14fc:	89 e5                	mov    %esp,%ebp
    14fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1501:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1508:	eb 25                	jmp    152f <atoi+0x34>
    n = n*10 + *s++ - '0';
    150a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    150d:	89 d0                	mov    %edx,%eax
    150f:	c1 e0 02             	shl    $0x2,%eax
    1512:	01 d0                	add    %edx,%eax
    1514:	01 c0                	add    %eax,%eax
    1516:	89 c1                	mov    %eax,%ecx
    1518:	8b 45 08             	mov    0x8(%ebp),%eax
    151b:	8d 50 01             	lea    0x1(%eax),%edx
    151e:	89 55 08             	mov    %edx,0x8(%ebp)
    1521:	0f b6 00             	movzbl (%eax),%eax
    1524:	0f be c0             	movsbl %al,%eax
    1527:	01 c8                	add    %ecx,%eax
    1529:	83 e8 30             	sub    $0x30,%eax
    152c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    152f:	8b 45 08             	mov    0x8(%ebp),%eax
    1532:	0f b6 00             	movzbl (%eax),%eax
    1535:	3c 2f                	cmp    $0x2f,%al
    1537:	7e 0a                	jle    1543 <atoi+0x48>
    1539:	8b 45 08             	mov    0x8(%ebp),%eax
    153c:	0f b6 00             	movzbl (%eax),%eax
    153f:	3c 39                	cmp    $0x39,%al
    1541:	7e c7                	jle    150a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1543:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1546:	c9                   	leave  
    1547:	c3                   	ret    

00001548 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1548:	55                   	push   %ebp
    1549:	89 e5                	mov    %esp,%ebp
    154b:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    154e:	8b 45 08             	mov    0x8(%ebp),%eax
    1551:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1554:	8b 45 0c             	mov    0xc(%ebp),%eax
    1557:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    155a:	eb 17                	jmp    1573 <memmove+0x2b>
    *dst++ = *src++;
    155c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    155f:	8d 50 01             	lea    0x1(%eax),%edx
    1562:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1565:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1568:	8d 4a 01             	lea    0x1(%edx),%ecx
    156b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    156e:	0f b6 12             	movzbl (%edx),%edx
    1571:	88 10                	mov    %dl,(%eax)
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1573:	8b 45 10             	mov    0x10(%ebp),%eax
    1576:	8d 50 ff             	lea    -0x1(%eax),%edx
    1579:	89 55 10             	mov    %edx,0x10(%ebp)
    157c:	85 c0                	test   %eax,%eax
    157e:	7f dc                	jg     155c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1580:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1583:	c9                   	leave  
    1584:	c3                   	ret    

00001585 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1585:	b8 01 00 00 00       	mov    $0x1,%eax
    158a:	cd 40                	int    $0x40
    158c:	c3                   	ret    

0000158d <exit>:
SYSCALL(exit)
    158d:	b8 02 00 00 00       	mov    $0x2,%eax
    1592:	cd 40                	int    $0x40
    1594:	c3                   	ret    

00001595 <wait>:
SYSCALL(wait)
    1595:	b8 03 00 00 00       	mov    $0x3,%eax
    159a:	cd 40                	int    $0x40
    159c:	c3                   	ret    

0000159d <pipe>:
SYSCALL(pipe)
    159d:	b8 04 00 00 00       	mov    $0x4,%eax
    15a2:	cd 40                	int    $0x40
    15a4:	c3                   	ret    

000015a5 <read>:
SYSCALL(read)
    15a5:	b8 05 00 00 00       	mov    $0x5,%eax
    15aa:	cd 40                	int    $0x40
    15ac:	c3                   	ret    

000015ad <write>:
SYSCALL(write)
    15ad:	b8 10 00 00 00       	mov    $0x10,%eax
    15b2:	cd 40                	int    $0x40
    15b4:	c3                   	ret    

000015b5 <close>:
SYSCALL(close)
    15b5:	b8 15 00 00 00       	mov    $0x15,%eax
    15ba:	cd 40                	int    $0x40
    15bc:	c3                   	ret    

000015bd <kill>:
SYSCALL(kill)
    15bd:	b8 06 00 00 00       	mov    $0x6,%eax
    15c2:	cd 40                	int    $0x40
    15c4:	c3                   	ret    

000015c5 <exec>:
SYSCALL(exec)
    15c5:	b8 07 00 00 00       	mov    $0x7,%eax
    15ca:	cd 40                	int    $0x40
    15cc:	c3                   	ret    

000015cd <open>:
SYSCALL(open)
    15cd:	b8 0f 00 00 00       	mov    $0xf,%eax
    15d2:	cd 40                	int    $0x40
    15d4:	c3                   	ret    

000015d5 <mknod>:
SYSCALL(mknod)
    15d5:	b8 11 00 00 00       	mov    $0x11,%eax
    15da:	cd 40                	int    $0x40
    15dc:	c3                   	ret    

000015dd <unlink>:
SYSCALL(unlink)
    15dd:	b8 12 00 00 00       	mov    $0x12,%eax
    15e2:	cd 40                	int    $0x40
    15e4:	c3                   	ret    

000015e5 <fstat>:
SYSCALL(fstat)
    15e5:	b8 08 00 00 00       	mov    $0x8,%eax
    15ea:	cd 40                	int    $0x40
    15ec:	c3                   	ret    

000015ed <link>:
SYSCALL(link)
    15ed:	b8 13 00 00 00       	mov    $0x13,%eax
    15f2:	cd 40                	int    $0x40
    15f4:	c3                   	ret    

000015f5 <mkdir>:
SYSCALL(mkdir)
    15f5:	b8 14 00 00 00       	mov    $0x14,%eax
    15fa:	cd 40                	int    $0x40
    15fc:	c3                   	ret    

000015fd <chdir>:
SYSCALL(chdir)
    15fd:	b8 09 00 00 00       	mov    $0x9,%eax
    1602:	cd 40                	int    $0x40
    1604:	c3                   	ret    

00001605 <dup>:
SYSCALL(dup)
    1605:	b8 0a 00 00 00       	mov    $0xa,%eax
    160a:	cd 40                	int    $0x40
    160c:	c3                   	ret    

0000160d <getpid>:
SYSCALL(getpid)
    160d:	b8 0b 00 00 00       	mov    $0xb,%eax
    1612:	cd 40                	int    $0x40
    1614:	c3                   	ret    

00001615 <sbrk>:
SYSCALL(sbrk)
    1615:	b8 0c 00 00 00       	mov    $0xc,%eax
    161a:	cd 40                	int    $0x40
    161c:	c3                   	ret    

0000161d <sleep>:
SYSCALL(sleep)
    161d:	b8 0d 00 00 00       	mov    $0xd,%eax
    1622:	cd 40                	int    $0x40
    1624:	c3                   	ret    

00001625 <uptime>:
SYSCALL(uptime)
    1625:	b8 0e 00 00 00       	mov    $0xe,%eax
    162a:	cd 40                	int    $0x40
    162c:	c3                   	ret    

0000162d <getprocsinfo>:
SYSCALL(getprocsinfo)
    162d:	b8 16 00 00 00       	mov    $0x16,%eax
    1632:	cd 40                	int    $0x40
    1634:	c3                   	ret    

00001635 <shmem_access>:
SYSCALL(shmem_access)
    1635:	b8 17 00 00 00       	mov    $0x17,%eax
    163a:	cd 40                	int    $0x40
    163c:	c3                   	ret    

0000163d <shmem_count>:
SYSCALL(shmem_count)
    163d:	b8 18 00 00 00       	mov    $0x18,%eax
    1642:	cd 40                	int    $0x40
    1644:	c3                   	ret    

00001645 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1645:	55                   	push   %ebp
    1646:	89 e5                	mov    %esp,%ebp
    1648:	83 ec 18             	sub    $0x18,%esp
    164b:	8b 45 0c             	mov    0xc(%ebp),%eax
    164e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1651:	83 ec 04             	sub    $0x4,%esp
    1654:	6a 01                	push   $0x1
    1656:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1659:	50                   	push   %eax
    165a:	ff 75 08             	pushl  0x8(%ebp)
    165d:	e8 4b ff ff ff       	call   15ad <write>
    1662:	83 c4 10             	add    $0x10,%esp
}
    1665:	90                   	nop
    1666:	c9                   	leave  
    1667:	c3                   	ret    

00001668 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1668:	55                   	push   %ebp
    1669:	89 e5                	mov    %esp,%ebp
    166b:	53                   	push   %ebx
    166c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    166f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1676:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    167a:	74 17                	je     1693 <printint+0x2b>
    167c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1680:	79 11                	jns    1693 <printint+0x2b>
    neg = 1;
    1682:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1689:	8b 45 0c             	mov    0xc(%ebp),%eax
    168c:	f7 d8                	neg    %eax
    168e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1691:	eb 06                	jmp    1699 <printint+0x31>
  } else {
    x = xx;
    1693:	8b 45 0c             	mov    0xc(%ebp),%eax
    1696:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1699:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16a0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16a3:	8d 41 01             	lea    0x1(%ecx),%eax
    16a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    16a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16af:	ba 00 00 00 00       	mov    $0x0,%edx
    16b4:	f7 f3                	div    %ebx
    16b6:	89 d0                	mov    %edx,%eax
    16b8:	0f b6 80 e0 1d 00 00 	movzbl 0x1de0(%eax),%eax
    16bf:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    16c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16c9:	ba 00 00 00 00       	mov    $0x0,%edx
    16ce:	f7 f3                	div    %ebx
    16d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16d7:	75 c7                	jne    16a0 <printint+0x38>
  if(neg)
    16d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    16dd:	74 2d                	je     170c <printint+0xa4>
    buf[i++] = '-';
    16df:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16e2:	8d 50 01             	lea    0x1(%eax),%edx
    16e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
    16e8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    16ed:	eb 1d                	jmp    170c <printint+0xa4>
    putc(fd, buf[i]);
    16ef:	8d 55 dc             	lea    -0x24(%ebp),%edx
    16f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f5:	01 d0                	add    %edx,%eax
    16f7:	0f b6 00             	movzbl (%eax),%eax
    16fa:	0f be c0             	movsbl %al,%eax
    16fd:	83 ec 08             	sub    $0x8,%esp
    1700:	50                   	push   %eax
    1701:	ff 75 08             	pushl  0x8(%ebp)
    1704:	e8 3c ff ff ff       	call   1645 <putc>
    1709:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    170c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1710:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1714:	79 d9                	jns    16ef <printint+0x87>
    putc(fd, buf[i]);
}
    1716:	90                   	nop
    1717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    171a:	c9                   	leave  
    171b:	c3                   	ret    

0000171c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    171c:	55                   	push   %ebp
    171d:	89 e5                	mov    %esp,%ebp
    171f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1722:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1729:	8d 45 0c             	lea    0xc(%ebp),%eax
    172c:	83 c0 04             	add    $0x4,%eax
    172f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1732:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1739:	e9 59 01 00 00       	jmp    1897 <printf+0x17b>
    c = fmt[i] & 0xff;
    173e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1741:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1744:	01 d0                	add    %edx,%eax
    1746:	0f b6 00             	movzbl (%eax),%eax
    1749:	0f be c0             	movsbl %al,%eax
    174c:	25 ff 00 00 00       	and    $0xff,%eax
    1751:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1754:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1758:	75 2c                	jne    1786 <printf+0x6a>
      if(c == '%'){
    175a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    175e:	75 0c                	jne    176c <printf+0x50>
        state = '%';
    1760:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1767:	e9 27 01 00 00       	jmp    1893 <printf+0x177>
      } else {
        putc(fd, c);
    176c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    176f:	0f be c0             	movsbl %al,%eax
    1772:	83 ec 08             	sub    $0x8,%esp
    1775:	50                   	push   %eax
    1776:	ff 75 08             	pushl  0x8(%ebp)
    1779:	e8 c7 fe ff ff       	call   1645 <putc>
    177e:	83 c4 10             	add    $0x10,%esp
    1781:	e9 0d 01 00 00       	jmp    1893 <printf+0x177>
      }
    } else if(state == '%'){
    1786:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    178a:	0f 85 03 01 00 00    	jne    1893 <printf+0x177>
      if(c == 'd'){
    1790:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1794:	75 1e                	jne    17b4 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1796:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1799:	8b 00                	mov    (%eax),%eax
    179b:	6a 01                	push   $0x1
    179d:	6a 0a                	push   $0xa
    179f:	50                   	push   %eax
    17a0:	ff 75 08             	pushl  0x8(%ebp)
    17a3:	e8 c0 fe ff ff       	call   1668 <printint>
    17a8:	83 c4 10             	add    $0x10,%esp
        ap++;
    17ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17af:	e9 d8 00 00 00       	jmp    188c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    17b4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    17b8:	74 06                	je     17c0 <printf+0xa4>
    17ba:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    17be:	75 1e                	jne    17de <printf+0xc2>
        printint(fd, *ap, 16, 0);
    17c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17c3:	8b 00                	mov    (%eax),%eax
    17c5:	6a 00                	push   $0x0
    17c7:	6a 10                	push   $0x10
    17c9:	50                   	push   %eax
    17ca:	ff 75 08             	pushl  0x8(%ebp)
    17cd:	e8 96 fe ff ff       	call   1668 <printint>
    17d2:	83 c4 10             	add    $0x10,%esp
        ap++;
    17d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17d9:	e9 ae 00 00 00       	jmp    188c <printf+0x170>
      } else if(c == 's'){
    17de:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    17e2:	75 43                	jne    1827 <printf+0x10b>
        s = (char*)*ap;
    17e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17e7:	8b 00                	mov    (%eax),%eax
    17e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    17ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    17f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17f4:	75 25                	jne    181b <printf+0xff>
          s = "(null)";
    17f6:	c7 45 f4 0a 1b 00 00 	movl   $0x1b0a,-0xc(%ebp)
        while(*s != 0){
    17fd:	eb 1c                	jmp    181b <printf+0xff>
          putc(fd, *s);
    17ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1802:	0f b6 00             	movzbl (%eax),%eax
    1805:	0f be c0             	movsbl %al,%eax
    1808:	83 ec 08             	sub    $0x8,%esp
    180b:	50                   	push   %eax
    180c:	ff 75 08             	pushl  0x8(%ebp)
    180f:	e8 31 fe ff ff       	call   1645 <putc>
    1814:	83 c4 10             	add    $0x10,%esp
          s++;
    1817:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    181e:	0f b6 00             	movzbl (%eax),%eax
    1821:	84 c0                	test   %al,%al
    1823:	75 da                	jne    17ff <printf+0xe3>
    1825:	eb 65                	jmp    188c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1827:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    182b:	75 1d                	jne    184a <printf+0x12e>
        putc(fd, *ap);
    182d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1830:	8b 00                	mov    (%eax),%eax
    1832:	0f be c0             	movsbl %al,%eax
    1835:	83 ec 08             	sub    $0x8,%esp
    1838:	50                   	push   %eax
    1839:	ff 75 08             	pushl  0x8(%ebp)
    183c:	e8 04 fe ff ff       	call   1645 <putc>
    1841:	83 c4 10             	add    $0x10,%esp
        ap++;
    1844:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1848:	eb 42                	jmp    188c <printf+0x170>
      } else if(c == '%'){
    184a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    184e:	75 17                	jne    1867 <printf+0x14b>
        putc(fd, c);
    1850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1853:	0f be c0             	movsbl %al,%eax
    1856:	83 ec 08             	sub    $0x8,%esp
    1859:	50                   	push   %eax
    185a:	ff 75 08             	pushl  0x8(%ebp)
    185d:	e8 e3 fd ff ff       	call   1645 <putc>
    1862:	83 c4 10             	add    $0x10,%esp
    1865:	eb 25                	jmp    188c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1867:	83 ec 08             	sub    $0x8,%esp
    186a:	6a 25                	push   $0x25
    186c:	ff 75 08             	pushl  0x8(%ebp)
    186f:	e8 d1 fd ff ff       	call   1645 <putc>
    1874:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    187a:	0f be c0             	movsbl %al,%eax
    187d:	83 ec 08             	sub    $0x8,%esp
    1880:	50                   	push   %eax
    1881:	ff 75 08             	pushl  0x8(%ebp)
    1884:	e8 bc fd ff ff       	call   1645 <putc>
    1889:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    188c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1893:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1897:	8b 55 0c             	mov    0xc(%ebp),%edx
    189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    189d:	01 d0                	add    %edx,%eax
    189f:	0f b6 00             	movzbl (%eax),%eax
    18a2:	84 c0                	test   %al,%al
    18a4:	0f 85 94 fe ff ff    	jne    173e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    18aa:	90                   	nop
    18ab:	c9                   	leave  
    18ac:	c3                   	ret    

000018ad <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    18ad:	55                   	push   %ebp
    18ae:	89 e5                	mov    %esp,%ebp
    18b0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    18b3:	8b 45 08             	mov    0x8(%ebp),%eax
    18b6:	83 e8 08             	sub    $0x8,%eax
    18b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18bc:	a1 08 1e 00 00       	mov    0x1e08,%eax
    18c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    18c4:	eb 24                	jmp    18ea <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    18c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18c9:	8b 00                	mov    (%eax),%eax
    18cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18ce:	77 12                	ja     18e2 <free+0x35>
    18d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18d6:	77 24                	ja     18fc <free+0x4f>
    18d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18db:	8b 00                	mov    (%eax),%eax
    18dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    18e0:	77 1a                	ja     18fc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18e5:	8b 00                	mov    (%eax),%eax
    18e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    18ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18f0:	76 d4                	jbe    18c6 <free+0x19>
    18f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18f5:	8b 00                	mov    (%eax),%eax
    18f7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    18fa:	76 ca                	jbe    18c6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    18fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18ff:	8b 40 04             	mov    0x4(%eax),%eax
    1902:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1909:	8b 45 f8             	mov    -0x8(%ebp),%eax
    190c:	01 c2                	add    %eax,%edx
    190e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1911:	8b 00                	mov    (%eax),%eax
    1913:	39 c2                	cmp    %eax,%edx
    1915:	75 24                	jne    193b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1917:	8b 45 f8             	mov    -0x8(%ebp),%eax
    191a:	8b 50 04             	mov    0x4(%eax),%edx
    191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1920:	8b 00                	mov    (%eax),%eax
    1922:	8b 40 04             	mov    0x4(%eax),%eax
    1925:	01 c2                	add    %eax,%edx
    1927:	8b 45 f8             	mov    -0x8(%ebp),%eax
    192a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    192d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1930:	8b 00                	mov    (%eax),%eax
    1932:	8b 10                	mov    (%eax),%edx
    1934:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1937:	89 10                	mov    %edx,(%eax)
    1939:	eb 0a                	jmp    1945 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    193b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    193e:	8b 10                	mov    (%eax),%edx
    1940:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1943:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1945:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1948:	8b 40 04             	mov    0x4(%eax),%eax
    194b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1952:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1955:	01 d0                	add    %edx,%eax
    1957:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    195a:	75 20                	jne    197c <free+0xcf>
    p->s.size += bp->s.size;
    195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    195f:	8b 50 04             	mov    0x4(%eax),%edx
    1962:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1965:	8b 40 04             	mov    0x4(%eax),%eax
    1968:	01 c2                	add    %eax,%edx
    196a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    196d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1970:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1973:	8b 10                	mov    (%eax),%edx
    1975:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1978:	89 10                	mov    %edx,(%eax)
    197a:	eb 08                	jmp    1984 <free+0xd7>
  } else
    p->s.ptr = bp;
    197c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    197f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1982:	89 10                	mov    %edx,(%eax)
  freep = p;
    1984:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1987:	a3 08 1e 00 00       	mov    %eax,0x1e08
}
    198c:	90                   	nop
    198d:	c9                   	leave  
    198e:	c3                   	ret    

0000198f <morecore>:

static Header*
morecore(uint nu)
{
    198f:	55                   	push   %ebp
    1990:	89 e5                	mov    %esp,%ebp
    1992:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1995:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    199c:	77 07                	ja     19a5 <morecore+0x16>
    nu = 4096;
    199e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    19a5:	8b 45 08             	mov    0x8(%ebp),%eax
    19a8:	c1 e0 03             	shl    $0x3,%eax
    19ab:	83 ec 0c             	sub    $0xc,%esp
    19ae:	50                   	push   %eax
    19af:	e8 61 fc ff ff       	call   1615 <sbrk>
    19b4:	83 c4 10             	add    $0x10,%esp
    19b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    19ba:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    19be:	75 07                	jne    19c7 <morecore+0x38>
    return 0;
    19c0:	b8 00 00 00 00       	mov    $0x0,%eax
    19c5:	eb 26                	jmp    19ed <morecore+0x5e>
  hp = (Header*)p;
    19c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    19cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19d0:	8b 55 08             	mov    0x8(%ebp),%edx
    19d3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    19d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19d9:	83 c0 08             	add    $0x8,%eax
    19dc:	83 ec 0c             	sub    $0xc,%esp
    19df:	50                   	push   %eax
    19e0:	e8 c8 fe ff ff       	call   18ad <free>
    19e5:	83 c4 10             	add    $0x10,%esp
  return freep;
    19e8:	a1 08 1e 00 00       	mov    0x1e08,%eax
}
    19ed:	c9                   	leave  
    19ee:	c3                   	ret    

000019ef <malloc>:

void*
malloc(uint nbytes)
{
    19ef:	55                   	push   %ebp
    19f0:	89 e5                	mov    %esp,%ebp
    19f2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    19f5:	8b 45 08             	mov    0x8(%ebp),%eax
    19f8:	83 c0 07             	add    $0x7,%eax
    19fb:	c1 e8 03             	shr    $0x3,%eax
    19fe:	83 c0 01             	add    $0x1,%eax
    1a01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a04:	a1 08 1e 00 00       	mov    0x1e08,%eax
    1a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a10:	75 23                	jne    1a35 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1a12:	c7 45 f0 00 1e 00 00 	movl   $0x1e00,-0x10(%ebp)
    1a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a1c:	a3 08 1e 00 00       	mov    %eax,0x1e08
    1a21:	a1 08 1e 00 00       	mov    0x1e08,%eax
    1a26:	a3 00 1e 00 00       	mov    %eax,0x1e00
    base.s.size = 0;
    1a2b:	c7 05 04 1e 00 00 00 	movl   $0x0,0x1e04
    1a32:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a38:	8b 00                	mov    (%eax),%eax
    1a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a40:	8b 40 04             	mov    0x4(%eax),%eax
    1a43:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a46:	72 4d                	jb     1a95 <malloc+0xa6>
      if(p->s.size == nunits)
    1a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a4b:	8b 40 04             	mov    0x4(%eax),%eax
    1a4e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a51:	75 0c                	jne    1a5f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a56:	8b 10                	mov    (%eax),%edx
    1a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a5b:	89 10                	mov    %edx,(%eax)
    1a5d:	eb 26                	jmp    1a85 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a62:	8b 40 04             	mov    0x4(%eax),%eax
    1a65:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1a68:	89 c2                	mov    %eax,%edx
    1a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a6d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a73:	8b 40 04             	mov    0x4(%eax),%eax
    1a76:	c1 e0 03             	shl    $0x3,%eax
    1a79:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a82:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a88:	a3 08 1e 00 00       	mov    %eax,0x1e08
      return (void*)(p + 1);
    1a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a90:	83 c0 08             	add    $0x8,%eax
    1a93:	eb 3b                	jmp    1ad0 <malloc+0xe1>
    }
    if(p == freep)
    1a95:	a1 08 1e 00 00       	mov    0x1e08,%eax
    1a9a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1a9d:	75 1e                	jne    1abd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    1a9f:	83 ec 0c             	sub    $0xc,%esp
    1aa2:	ff 75 ec             	pushl  -0x14(%ebp)
    1aa5:	e8 e5 fe ff ff       	call   198f <morecore>
    1aaa:	83 c4 10             	add    $0x10,%esp
    1aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1ab0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ab4:	75 07                	jne    1abd <malloc+0xce>
        return 0;
    1ab6:	b8 00 00 00 00       	mov    $0x0,%eax
    1abb:	eb 13                	jmp    1ad0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac6:	8b 00                	mov    (%eax),%eax
    1ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1acb:	e9 6d ff ff ff       	jmp    1a3d <malloc+0x4e>
}
    1ad0:	c9                   	leave  
    1ad1:	c3                   	ret    
