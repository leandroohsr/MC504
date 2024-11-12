
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	add	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	add	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	1de58593          	add	a1,a1,478 # 11f0 <malloc+0xe0>
      1a:	4509                	li	a0,2
      1c:	407000ef          	jal	c22 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	1f7000ef          	jal	a1c <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	235000ef          	jal	a62 <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a00533          	neg	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	add	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	add	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	add	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	1a458593          	add	a1,a1,420 # 11f8 <malloc+0xe8>
      5c:	4509                	li	a0,2
      5e:	7d5000ef          	jal	1032 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	39f000ef          	jal	c02 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	add	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	add	s0,sp,16
  int pid;

  pid = fork();
      70:	38b000ef          	jal	bfa <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	add	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	17e50513          	add	a0,a0,382 # 1200 <malloc+0xf0>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	add	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	ec26                	sd	s1,24(sp)
      96:	1800                	add	s0,sp,48
  if(cmd == 0)
      98:	c10d                	beqz	a0,ba <runcmd+0x2c>
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e063          	bltu	a5,a4,c0 <runcmd+0x32>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	sll	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	25670713          	add	a4,a4,598 # 1300 <malloc+0x1f0>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
    exit(1);
      ba:	4505                	li	a0,1
      bc:	347000ef          	jal	c02 <exit>
    panic("runcmd");
      c0:	00001517          	auipc	a0,0x1
      c4:	14850513          	add	a0,a0,328 # 1208 <malloc+0xf8>
      c8:	f83ff0ef          	jal	4a <panic>
    if(ecmd->argv[0] == 0)
      cc:	6508                	ld	a0,8(a0)
      ce:	c105                	beqz	a0,ee <runcmd+0x60>
    exec(ecmd->argv[0], ecmd->argv);
      d0:	00848593          	add	a1,s1,8
      d4:	367000ef          	jal	c3a <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      d8:	6490                	ld	a2,8(s1)
      da:	00001597          	auipc	a1,0x1
      de:	13658593          	add	a1,a1,310 # 1210 <malloc+0x100>
      e2:	4509                	li	a0,2
      e4:	74f000ef          	jal	1032 <fprintf>
  exit(0);
      e8:	4501                	li	a0,0
      ea:	319000ef          	jal	c02 <exit>
      exit(1);
      ee:	4505                	li	a0,1
      f0:	313000ef          	jal	c02 <exit>
    close(rcmd->fd);
      f4:	5148                	lw	a0,36(a0)
      f6:	335000ef          	jal	c2a <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fa:	508c                	lw	a1,32(s1)
      fc:	6888                	ld	a0,16(s1)
      fe:	345000ef          	jal	c42 <open>
     102:	00054563          	bltz	a0,10c <runcmd+0x7e>
    runcmd(rcmd->cmd);
     106:	6488                	ld	a0,8(s1)
     108:	f87ff0ef          	jal	8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10c:	6890                	ld	a2,16(s1)
     10e:	00001597          	auipc	a1,0x1
     112:	11258593          	add	a1,a1,274 # 1220 <malloc+0x110>
     116:	4509                	li	a0,2
     118:	71b000ef          	jal	1032 <fprintf>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	2e5000ef          	jal	c02 <exit>
    if(fork1() == 0)
     122:	f47ff0ef          	jal	68 <fork1>
     126:	e501                	bnez	a0,12e <runcmd+0xa0>
      runcmd(lcmd->left);
     128:	6488                	ld	a0,8(s1)
     12a:	f65ff0ef          	jal	8e <runcmd>
    wait(0);
     12e:	4501                	li	a0,0
     130:	2db000ef          	jal	c0a <wait>
    runcmd(lcmd->right);
     134:	6888                	ld	a0,16(s1)
     136:	f59ff0ef          	jal	8e <runcmd>
    if(pipe(p) < 0)
     13a:	fd840513          	add	a0,s0,-40
     13e:	2d5000ef          	jal	c12 <pipe>
     142:	02054763          	bltz	a0,170 <runcmd+0xe2>
    if(fork1() == 0){
     146:	f23ff0ef          	jal	68 <fork1>
     14a:	e90d                	bnez	a0,17c <runcmd+0xee>
      close(1);
     14c:	4505                	li	a0,1
     14e:	2dd000ef          	jal	c2a <close>
      dup(p[1]);
     152:	fdc42503          	lw	a0,-36(s0)
     156:	325000ef          	jal	c7a <dup>
      close(p[0]);
     15a:	fd842503          	lw	a0,-40(s0)
     15e:	2cd000ef          	jal	c2a <close>
      close(p[1]);
     162:	fdc42503          	lw	a0,-36(s0)
     166:	2c5000ef          	jal	c2a <close>
      runcmd(pcmd->left);
     16a:	6488                	ld	a0,8(s1)
     16c:	f23ff0ef          	jal	8e <runcmd>
      panic("pipe");
     170:	00001517          	auipc	a0,0x1
     174:	0c050513          	add	a0,a0,192 # 1230 <malloc+0x120>
     178:	ed3ff0ef          	jal	4a <panic>
    if(fork1() == 0){
     17c:	eedff0ef          	jal	68 <fork1>
     180:	e115                	bnez	a0,1a4 <runcmd+0x116>
      close(0);
     182:	2a9000ef          	jal	c2a <close>
      dup(p[0]);
     186:	fd842503          	lw	a0,-40(s0)
     18a:	2f1000ef          	jal	c7a <dup>
      close(p[0]);
     18e:	fd842503          	lw	a0,-40(s0)
     192:	299000ef          	jal	c2a <close>
      close(p[1]);
     196:	fdc42503          	lw	a0,-36(s0)
     19a:	291000ef          	jal	c2a <close>
      runcmd(pcmd->right);
     19e:	6888                	ld	a0,16(s1)
     1a0:	eefff0ef          	jal	8e <runcmd>
    close(p[0]);
     1a4:	fd842503          	lw	a0,-40(s0)
     1a8:	283000ef          	jal	c2a <close>
    close(p[1]);
     1ac:	fdc42503          	lw	a0,-36(s0)
     1b0:	27b000ef          	jal	c2a <close>
    wait(0);
     1b4:	4501                	li	a0,0
     1b6:	255000ef          	jal	c0a <wait>
    wait(0);
     1ba:	4501                	li	a0,0
     1bc:	24f000ef          	jal	c0a <wait>
    break;
     1c0:	b725                	j	e8 <runcmd+0x5a>
    if(fork1() == 0)
     1c2:	ea7ff0ef          	jal	68 <fork1>
     1c6:	f20511e3          	bnez	a0,e8 <runcmd+0x5a>
      runcmd(bcmd->cmd);
     1ca:	6488                	ld	a0,8(s1)
     1cc:	ec3ff0ef          	jal	8e <runcmd>

00000000000001d0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d0:	1101                	add	sp,sp,-32
     1d2:	ec06                	sd	ra,24(sp)
     1d4:	e822                	sd	s0,16(sp)
     1d6:	e426                	sd	s1,8(sp)
     1d8:	1000                	add	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1da:	0a800513          	li	a0,168
     1de:	733000ef          	jal	1110 <malloc>
     1e2:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e4:	0a800613          	li	a2,168
     1e8:	4581                	li	a1,0
     1ea:	033000ef          	jal	a1c <memset>
  cmd->type = EXEC;
     1ee:	4785                	li	a5,1
     1f0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f2:	8526                	mv	a0,s1
     1f4:	60e2                	ld	ra,24(sp)
     1f6:	6442                	ld	s0,16(sp)
     1f8:	64a2                	ld	s1,8(sp)
     1fa:	6105                	add	sp,sp,32
     1fc:	8082                	ret

00000000000001fe <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     1fe:	7139                	add	sp,sp,-64
     200:	fc06                	sd	ra,56(sp)
     202:	f822                	sd	s0,48(sp)
     204:	f426                	sd	s1,40(sp)
     206:	f04a                	sd	s2,32(sp)
     208:	ec4e                	sd	s3,24(sp)
     20a:	e852                	sd	s4,16(sp)
     20c:	e456                	sd	s5,8(sp)
     20e:	e05a                	sd	s6,0(sp)
     210:	0080                	add	s0,sp,64
     212:	8b2a                	mv	s6,a0
     214:	8aae                	mv	s5,a1
     216:	8a32                	mv	s4,a2
     218:	89b6                	mv	s3,a3
     21a:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21c:	02800513          	li	a0,40
     220:	6f1000ef          	jal	1110 <malloc>
     224:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     226:	02800613          	li	a2,40
     22a:	4581                	li	a1,0
     22c:	7f0000ef          	jal	a1c <memset>
  cmd->type = REDIR;
     230:	4789                	li	a5,2
     232:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     234:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     238:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23c:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     240:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     244:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     248:	8526                	mv	a0,s1
     24a:	70e2                	ld	ra,56(sp)
     24c:	7442                	ld	s0,48(sp)
     24e:	74a2                	ld	s1,40(sp)
     250:	7902                	ld	s2,32(sp)
     252:	69e2                	ld	s3,24(sp)
     254:	6a42                	ld	s4,16(sp)
     256:	6aa2                	ld	s5,8(sp)
     258:	6b02                	ld	s6,0(sp)
     25a:	6121                	add	sp,sp,64
     25c:	8082                	ret

000000000000025e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     25e:	7179                	add	sp,sp,-48
     260:	f406                	sd	ra,40(sp)
     262:	f022                	sd	s0,32(sp)
     264:	ec26                	sd	s1,24(sp)
     266:	e84a                	sd	s2,16(sp)
     268:	e44e                	sd	s3,8(sp)
     26a:	1800                	add	s0,sp,48
     26c:	89aa                	mv	s3,a0
     26e:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     270:	4561                	li	a0,24
     272:	69f000ef          	jal	1110 <malloc>
     276:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     278:	4661                	li	a2,24
     27a:	4581                	li	a1,0
     27c:	7a0000ef          	jal	a1c <memset>
  cmd->type = PIPE;
     280:	478d                	li	a5,3
     282:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     284:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     288:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     28c:	8526                	mv	a0,s1
     28e:	70a2                	ld	ra,40(sp)
     290:	7402                	ld	s0,32(sp)
     292:	64e2                	ld	s1,24(sp)
     294:	6942                	ld	s2,16(sp)
     296:	69a2                	ld	s3,8(sp)
     298:	6145                	add	sp,sp,48
     29a:	8082                	ret

000000000000029c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29c:	7179                	add	sp,sp,-48
     29e:	f406                	sd	ra,40(sp)
     2a0:	f022                	sd	s0,32(sp)
     2a2:	ec26                	sd	s1,24(sp)
     2a4:	e84a                	sd	s2,16(sp)
     2a6:	e44e                	sd	s3,8(sp)
     2a8:	1800                	add	s0,sp,48
     2aa:	89aa                	mv	s3,a0
     2ac:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ae:	4561                	li	a0,24
     2b0:	661000ef          	jal	1110 <malloc>
     2b4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b6:	4661                	li	a2,24
     2b8:	4581                	li	a1,0
     2ba:	762000ef          	jal	a1c <memset>
  cmd->type = LIST;
     2be:	4791                	li	a5,4
     2c0:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c2:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c6:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2ca:	8526                	mv	a0,s1
     2cc:	70a2                	ld	ra,40(sp)
     2ce:	7402                	ld	s0,32(sp)
     2d0:	64e2                	ld	s1,24(sp)
     2d2:	6942                	ld	s2,16(sp)
     2d4:	69a2                	ld	s3,8(sp)
     2d6:	6145                	add	sp,sp,48
     2d8:	8082                	ret

00000000000002da <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2da:	1101                	add	sp,sp,-32
     2dc:	ec06                	sd	ra,24(sp)
     2de:	e822                	sd	s0,16(sp)
     2e0:	e426                	sd	s1,8(sp)
     2e2:	e04a                	sd	s2,0(sp)
     2e4:	1000                	add	s0,sp,32
     2e6:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2e8:	4541                	li	a0,16
     2ea:	627000ef          	jal	1110 <malloc>
     2ee:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f0:	4641                	li	a2,16
     2f2:	4581                	li	a1,0
     2f4:	728000ef          	jal	a1c <memset>
  cmd->type = BACK;
     2f8:	4795                	li	a5,5
     2fa:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	60e2                	ld	ra,24(sp)
     304:	6442                	ld	s0,16(sp)
     306:	64a2                	ld	s1,8(sp)
     308:	6902                	ld	s2,0(sp)
     30a:	6105                	add	sp,sp,32
     30c:	8082                	ret

000000000000030e <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     30e:	7139                	add	sp,sp,-64
     310:	fc06                	sd	ra,56(sp)
     312:	f822                	sd	s0,48(sp)
     314:	f426                	sd	s1,40(sp)
     316:	f04a                	sd	s2,32(sp)
     318:	ec4e                	sd	s3,24(sp)
     31a:	e852                	sd	s4,16(sp)
     31c:	e456                	sd	s5,8(sp)
     31e:	e05a                	sd	s6,0(sp)
     320:	0080                	add	s0,sp,64
     322:	8a2a                	mv	s4,a0
     324:	892e                	mv	s2,a1
     326:	8ab2                	mv	s5,a2
     328:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32a:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32c:	00002997          	auipc	s3,0x2
     330:	cdc98993          	add	s3,s3,-804 # 2008 <whitespace>
     334:	00b4fc63          	bgeu	s1,a1,34c <gettoken+0x3e>
     338:	0004c583          	lbu	a1,0(s1)
     33c:	854e                	mv	a0,s3
     33e:	700000ef          	jal	a3e <strchr>
     342:	c509                	beqz	a0,34c <gettoken+0x3e>
    s++;
     344:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     346:	fe9919e3          	bne	s2,s1,338 <gettoken+0x2a>
    s++;
     34a:	84ca                	mv	s1,s2
  if(q)
     34c:	000a8463          	beqz	s5,354 <gettoken+0x46>
    *q = s;
     350:	009ab023          	sd	s1,0(s5)
  ret = *s;
     354:	0004c783          	lbu	a5,0(s1)
     358:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35c:	03c00713          	li	a4,60
     360:	06f76463          	bltu	a4,a5,3c8 <gettoken+0xba>
     364:	03a00713          	li	a4,58
     368:	00f76e63          	bltu	a4,a5,384 <gettoken+0x76>
     36c:	cf89                	beqz	a5,386 <gettoken+0x78>
     36e:	02600713          	li	a4,38
     372:	00e78963          	beq	a5,a4,384 <gettoken+0x76>
     376:	fd87879b          	addw	a5,a5,-40
     37a:	0ff7f793          	zext.b	a5,a5
     37e:	4705                	li	a4,1
     380:	06f76b63          	bltu	a4,a5,3f6 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     384:	0485                	add	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     386:	000b0463          	beqz	s6,38e <gettoken+0x80>
    *eq = s;
     38a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     38e:	00002997          	auipc	s3,0x2
     392:	c7a98993          	add	s3,s3,-902 # 2008 <whitespace>
     396:	0124fc63          	bgeu	s1,s2,3ae <gettoken+0xa0>
     39a:	0004c583          	lbu	a1,0(s1)
     39e:	854e                	mv	a0,s3
     3a0:	69e000ef          	jal	a3e <strchr>
     3a4:	c509                	beqz	a0,3ae <gettoken+0xa0>
    s++;
     3a6:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3a8:	fe9919e3          	bne	s2,s1,39a <gettoken+0x8c>
    s++;
     3ac:	84ca                	mv	s1,s2
  *ps = s;
     3ae:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b2:	8556                	mv	a0,s5
     3b4:	70e2                	ld	ra,56(sp)
     3b6:	7442                	ld	s0,48(sp)
     3b8:	74a2                	ld	s1,40(sp)
     3ba:	7902                	ld	s2,32(sp)
     3bc:	69e2                	ld	s3,24(sp)
     3be:	6a42                	ld	s4,16(sp)
     3c0:	6aa2                	ld	s5,8(sp)
     3c2:	6b02                	ld	s6,0(sp)
     3c4:	6121                	add	sp,sp,64
     3c6:	8082                	ret
  switch(*s){
     3c8:	03e00713          	li	a4,62
     3cc:	02e79163          	bne	a5,a4,3ee <gettoken+0xe0>
    s++;
     3d0:	00148693          	add	a3,s1,1
    if(*s == '>'){
     3d4:	0014c703          	lbu	a4,1(s1)
     3d8:	03e00793          	li	a5,62
      s++;
     3dc:	0489                	add	s1,s1,2
      ret = '+';
     3de:	02b00a93          	li	s5,43
    if(*s == '>'){
     3e2:	faf702e3          	beq	a4,a5,386 <gettoken+0x78>
    s++;
     3e6:	84b6                	mv	s1,a3
  ret = *s;
     3e8:	03e00a93          	li	s5,62
     3ec:	bf69                	j	386 <gettoken+0x78>
  switch(*s){
     3ee:	07c00713          	li	a4,124
     3f2:	f8e789e3          	beq	a5,a4,384 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f6:	00002997          	auipc	s3,0x2
     3fa:	c1298993          	add	s3,s3,-1006 # 2008 <whitespace>
     3fe:	00002a97          	auipc	s5,0x2
     402:	c02a8a93          	add	s5,s5,-1022 # 2000 <symbols>
     406:	0324fd63          	bgeu	s1,s2,440 <gettoken+0x132>
     40a:	0004c583          	lbu	a1,0(s1)
     40e:	854e                	mv	a0,s3
     410:	62e000ef          	jal	a3e <strchr>
     414:	e11d                	bnez	a0,43a <gettoken+0x12c>
     416:	0004c583          	lbu	a1,0(s1)
     41a:	8556                	mv	a0,s5
     41c:	622000ef          	jal	a3e <strchr>
     420:	e911                	bnez	a0,434 <gettoken+0x126>
      s++;
     422:	0485                	add	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     424:	fe9913e3          	bne	s2,s1,40a <gettoken+0xfc>
      s++;
     428:	84ca                	mv	s1,s2
    ret = 'a';
     42a:	06100a93          	li	s5,97
  if(eq)
     42e:	f40b1ee3          	bnez	s6,38a <gettoken+0x7c>
     432:	bfb5                	j	3ae <gettoken+0xa0>
    ret = 'a';
     434:	06100a93          	li	s5,97
     438:	b7b9                	j	386 <gettoken+0x78>
     43a:	06100a93          	li	s5,97
     43e:	b7a1                	j	386 <gettoken+0x78>
     440:	06100a93          	li	s5,97
  if(eq)
     444:	f40b13e3          	bnez	s6,38a <gettoken+0x7c>
     448:	b79d                	j	3ae <gettoken+0xa0>

000000000000044a <peek>:

int
peek(char **ps, char *es, char *toks)
{
     44a:	7139                	add	sp,sp,-64
     44c:	fc06                	sd	ra,56(sp)
     44e:	f822                	sd	s0,48(sp)
     450:	f426                	sd	s1,40(sp)
     452:	f04a                	sd	s2,32(sp)
     454:	ec4e                	sd	s3,24(sp)
     456:	e852                	sd	s4,16(sp)
     458:	e456                	sd	s5,8(sp)
     45a:	0080                	add	s0,sp,64
     45c:	8a2a                	mv	s4,a0
     45e:	892e                	mv	s2,a1
     460:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     462:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     464:	00002997          	auipc	s3,0x2
     468:	ba498993          	add	s3,s3,-1116 # 2008 <whitespace>
     46c:	00b4fc63          	bgeu	s1,a1,484 <peek+0x3a>
     470:	0004c583          	lbu	a1,0(s1)
     474:	854e                	mv	a0,s3
     476:	5c8000ef          	jal	a3e <strchr>
     47a:	c509                	beqz	a0,484 <peek+0x3a>
    s++;
     47c:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     47e:	fe9919e3          	bne	s2,s1,470 <peek+0x26>
    s++;
     482:	84ca                	mv	s1,s2
  *ps = s;
     484:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     488:	0004c583          	lbu	a1,0(s1)
     48c:	4501                	li	a0,0
     48e:	e991                	bnez	a1,4a2 <peek+0x58>
}
     490:	70e2                	ld	ra,56(sp)
     492:	7442                	ld	s0,48(sp)
     494:	74a2                	ld	s1,40(sp)
     496:	7902                	ld	s2,32(sp)
     498:	69e2                	ld	s3,24(sp)
     49a:	6a42                	ld	s4,16(sp)
     49c:	6aa2                	ld	s5,8(sp)
     49e:	6121                	add	sp,sp,64
     4a0:	8082                	ret
  return *s && strchr(toks, *s);
     4a2:	8556                	mv	a0,s5
     4a4:	59a000ef          	jal	a3e <strchr>
     4a8:	00a03533          	snez	a0,a0
     4ac:	b7d5                	j	490 <peek+0x46>

00000000000004ae <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4ae:	7159                	add	sp,sp,-112
     4b0:	f486                	sd	ra,104(sp)
     4b2:	f0a2                	sd	s0,96(sp)
     4b4:	eca6                	sd	s1,88(sp)
     4b6:	e8ca                	sd	s2,80(sp)
     4b8:	e4ce                	sd	s3,72(sp)
     4ba:	e0d2                	sd	s4,64(sp)
     4bc:	fc56                	sd	s5,56(sp)
     4be:	f85a                	sd	s6,48(sp)
     4c0:	f45e                	sd	s7,40(sp)
     4c2:	f062                	sd	s8,32(sp)
     4c4:	ec66                	sd	s9,24(sp)
     4c6:	1880                	add	s0,sp,112
     4c8:	8a2a                	mv	s4,a0
     4ca:	89ae                	mv	s3,a1
     4cc:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4ce:	00001b97          	auipc	s7,0x1
     4d2:	d8ab8b93          	add	s7,s7,-630 # 1258 <malloc+0x148>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4d6:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     4da:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     4de:	a00d                	j	500 <parseredirs+0x52>
      panic("missing file for redirection");
     4e0:	00001517          	auipc	a0,0x1
     4e4:	d5850513          	add	a0,a0,-680 # 1238 <malloc+0x128>
     4e8:	b63ff0ef          	jal	4a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4ec:	4701                	li	a4,0
     4ee:	4681                	li	a3,0
     4f0:	f9043603          	ld	a2,-112(s0)
     4f4:	f9843583          	ld	a1,-104(s0)
     4f8:	8552                	mv	a0,s4
     4fa:	d05ff0ef          	jal	1fe <redircmd>
     4fe:	8a2a                	mv	s4,a0
    switch(tok){
     500:	03e00b13          	li	s6,62
     504:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     508:	865e                	mv	a2,s7
     50a:	85ca                	mv	a1,s2
     50c:	854e                	mv	a0,s3
     50e:	f3dff0ef          	jal	44a <peek>
     512:	c125                	beqz	a0,572 <parseredirs+0xc4>
    tok = gettoken(ps, es, 0, 0);
     514:	4681                	li	a3,0
     516:	4601                	li	a2,0
     518:	85ca                	mv	a1,s2
     51a:	854e                	mv	a0,s3
     51c:	df3ff0ef          	jal	30e <gettoken>
     520:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     522:	f9040693          	add	a3,s0,-112
     526:	f9840613          	add	a2,s0,-104
     52a:	85ca                	mv	a1,s2
     52c:	854e                	mv	a0,s3
     52e:	de1ff0ef          	jal	30e <gettoken>
     532:	fb8517e3          	bne	a0,s8,4e0 <parseredirs+0x32>
    switch(tok){
     536:	fb948be3          	beq	s1,s9,4ec <parseredirs+0x3e>
     53a:	03648063          	beq	s1,s6,55a <parseredirs+0xac>
     53e:	fd5495e3          	bne	s1,s5,508 <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     542:	4705                	li	a4,1
     544:	20100693          	li	a3,513
     548:	f9043603          	ld	a2,-112(s0)
     54c:	f9843583          	ld	a1,-104(s0)
     550:	8552                	mv	a0,s4
     552:	cadff0ef          	jal	1fe <redircmd>
     556:	8a2a                	mv	s4,a0
      break;
     558:	b765                	j	500 <parseredirs+0x52>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     55a:	4705                	li	a4,1
     55c:	60100693          	li	a3,1537
     560:	f9043603          	ld	a2,-112(s0)
     564:	f9843583          	ld	a1,-104(s0)
     568:	8552                	mv	a0,s4
     56a:	c95ff0ef          	jal	1fe <redircmd>
     56e:	8a2a                	mv	s4,a0
      break;
     570:	bf41                	j	500 <parseredirs+0x52>
    }
  }
  return cmd;
}
     572:	8552                	mv	a0,s4
     574:	70a6                	ld	ra,104(sp)
     576:	7406                	ld	s0,96(sp)
     578:	64e6                	ld	s1,88(sp)
     57a:	6946                	ld	s2,80(sp)
     57c:	69a6                	ld	s3,72(sp)
     57e:	6a06                	ld	s4,64(sp)
     580:	7ae2                	ld	s5,56(sp)
     582:	7b42                	ld	s6,48(sp)
     584:	7ba2                	ld	s7,40(sp)
     586:	7c02                	ld	s8,32(sp)
     588:	6ce2                	ld	s9,24(sp)
     58a:	6165                	add	sp,sp,112
     58c:	8082                	ret

000000000000058e <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     58e:	7159                	add	sp,sp,-112
     590:	f486                	sd	ra,104(sp)
     592:	f0a2                	sd	s0,96(sp)
     594:	eca6                	sd	s1,88(sp)
     596:	e8ca                	sd	s2,80(sp)
     598:	e4ce                	sd	s3,72(sp)
     59a:	e0d2                	sd	s4,64(sp)
     59c:	fc56                	sd	s5,56(sp)
     59e:	f85a                	sd	s6,48(sp)
     5a0:	f45e                	sd	s7,40(sp)
     5a2:	f062                	sd	s8,32(sp)
     5a4:	ec66                	sd	s9,24(sp)
     5a6:	1880                	add	s0,sp,112
     5a8:	8a2a                	mv	s4,a0
     5aa:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5ac:	00001617          	auipc	a2,0x1
     5b0:	cb460613          	add	a2,a2,-844 # 1260 <malloc+0x150>
     5b4:	e97ff0ef          	jal	44a <peek>
     5b8:	e505                	bnez	a0,5e0 <parseexec+0x52>
     5ba:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5bc:	c15ff0ef          	jal	1d0 <execcmd>
     5c0:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5c2:	8656                	mv	a2,s5
     5c4:	85d2                	mv	a1,s4
     5c6:	ee9ff0ef          	jal	4ae <parseredirs>
     5ca:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5cc:	008c0913          	add	s2,s8,8
     5d0:	00001b17          	auipc	s6,0x1
     5d4:	cb0b0b13          	add	s6,s6,-848 # 1280 <malloc+0x170>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     5d8:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5dc:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     5de:	a081                	j	61e <parseexec+0x90>
    return parseblock(ps, es);
     5e0:	85d6                	mv	a1,s5
     5e2:	8552                	mv	a0,s4
     5e4:	170000ef          	jal	754 <parseblock>
     5e8:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5ea:	8526                	mv	a0,s1
     5ec:	70a6                	ld	ra,104(sp)
     5ee:	7406                	ld	s0,96(sp)
     5f0:	64e6                	ld	s1,88(sp)
     5f2:	6946                	ld	s2,80(sp)
     5f4:	69a6                	ld	s3,72(sp)
     5f6:	6a06                	ld	s4,64(sp)
     5f8:	7ae2                	ld	s5,56(sp)
     5fa:	7b42                	ld	s6,48(sp)
     5fc:	7ba2                	ld	s7,40(sp)
     5fe:	7c02                	ld	s8,32(sp)
     600:	6ce2                	ld	s9,24(sp)
     602:	6165                	add	sp,sp,112
     604:	8082                	ret
      panic("syntax");
     606:	00001517          	auipc	a0,0x1
     60a:	c6250513          	add	a0,a0,-926 # 1268 <malloc+0x158>
     60e:	a3dff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     612:	8656                	mv	a2,s5
     614:	85d2                	mv	a1,s4
     616:	8526                	mv	a0,s1
     618:	e97ff0ef          	jal	4ae <parseredirs>
     61c:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     61e:	865a                	mv	a2,s6
     620:	85d6                	mv	a1,s5
     622:	8552                	mv	a0,s4
     624:	e27ff0ef          	jal	44a <peek>
     628:	ed15                	bnez	a0,664 <parseexec+0xd6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     62a:	f9040693          	add	a3,s0,-112
     62e:	f9840613          	add	a2,s0,-104
     632:	85d6                	mv	a1,s5
     634:	8552                	mv	a0,s4
     636:	cd9ff0ef          	jal	30e <gettoken>
     63a:	c50d                	beqz	a0,664 <parseexec+0xd6>
    if(tok != 'a')
     63c:	fd9515e3          	bne	a0,s9,606 <parseexec+0x78>
    cmd->argv[argc] = q;
     640:	f9843783          	ld	a5,-104(s0)
     644:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     648:	f9043783          	ld	a5,-112(s0)
     64c:	04f93823          	sd	a5,80(s2)
    argc++;
     650:	2985                	addw	s3,s3,1
    if(argc >= MAXARGS)
     652:	0921                	add	s2,s2,8
     654:	fb799fe3          	bne	s3,s7,612 <parseexec+0x84>
      panic("too many args");
     658:	00001517          	auipc	a0,0x1
     65c:	c1850513          	add	a0,a0,-1000 # 1270 <malloc+0x160>
     660:	9ebff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     664:	098e                	sll	s3,s3,0x3
     666:	9c4e                	add	s8,s8,s3
     668:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     66c:	040c3c23          	sd	zero,88(s8)
  return ret;
     670:	bfad                	j	5ea <parseexec+0x5c>

0000000000000672 <parsepipe>:
{
     672:	7179                	add	sp,sp,-48
     674:	f406                	sd	ra,40(sp)
     676:	f022                	sd	s0,32(sp)
     678:	ec26                	sd	s1,24(sp)
     67a:	e84a                	sd	s2,16(sp)
     67c:	e44e                	sd	s3,8(sp)
     67e:	1800                	add	s0,sp,48
     680:	892a                	mv	s2,a0
     682:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     684:	f0bff0ef          	jal	58e <parseexec>
     688:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     68a:	00001617          	auipc	a2,0x1
     68e:	bfe60613          	add	a2,a2,-1026 # 1288 <malloc+0x178>
     692:	85ce                	mv	a1,s3
     694:	854a                	mv	a0,s2
     696:	db5ff0ef          	jal	44a <peek>
     69a:	e909                	bnez	a0,6ac <parsepipe+0x3a>
}
     69c:	8526                	mv	a0,s1
     69e:	70a2                	ld	ra,40(sp)
     6a0:	7402                	ld	s0,32(sp)
     6a2:	64e2                	ld	s1,24(sp)
     6a4:	6942                	ld	s2,16(sp)
     6a6:	69a2                	ld	s3,8(sp)
     6a8:	6145                	add	sp,sp,48
     6aa:	8082                	ret
    gettoken(ps, es, 0, 0);
     6ac:	4681                	li	a3,0
     6ae:	4601                	li	a2,0
     6b0:	85ce                	mv	a1,s3
     6b2:	854a                	mv	a0,s2
     6b4:	c5bff0ef          	jal	30e <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6b8:	85ce                	mv	a1,s3
     6ba:	854a                	mv	a0,s2
     6bc:	fb7ff0ef          	jal	672 <parsepipe>
     6c0:	85aa                	mv	a1,a0
     6c2:	8526                	mv	a0,s1
     6c4:	b9bff0ef          	jal	25e <pipecmd>
     6c8:	84aa                	mv	s1,a0
  return cmd;
     6ca:	bfc9                	j	69c <parsepipe+0x2a>

00000000000006cc <parseline>:
{
     6cc:	7179                	add	sp,sp,-48
     6ce:	f406                	sd	ra,40(sp)
     6d0:	f022                	sd	s0,32(sp)
     6d2:	ec26                	sd	s1,24(sp)
     6d4:	e84a                	sd	s2,16(sp)
     6d6:	e44e                	sd	s3,8(sp)
     6d8:	e052                	sd	s4,0(sp)
     6da:	1800                	add	s0,sp,48
     6dc:	892a                	mv	s2,a0
     6de:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6e0:	f93ff0ef          	jal	672 <parsepipe>
     6e4:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6e6:	00001a17          	auipc	s4,0x1
     6ea:	baaa0a13          	add	s4,s4,-1110 # 1290 <malloc+0x180>
     6ee:	a819                	j	704 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     6f0:	4681                	li	a3,0
     6f2:	4601                	li	a2,0
     6f4:	85ce                	mv	a1,s3
     6f6:	854a                	mv	a0,s2
     6f8:	c17ff0ef          	jal	30e <gettoken>
    cmd = backcmd(cmd);
     6fc:	8526                	mv	a0,s1
     6fe:	bddff0ef          	jal	2da <backcmd>
     702:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     704:	8652                	mv	a2,s4
     706:	85ce                	mv	a1,s3
     708:	854a                	mv	a0,s2
     70a:	d41ff0ef          	jal	44a <peek>
     70e:	f16d                	bnez	a0,6f0 <parseline+0x24>
  if(peek(ps, es, ";")){
     710:	00001617          	auipc	a2,0x1
     714:	b8860613          	add	a2,a2,-1144 # 1298 <malloc+0x188>
     718:	85ce                	mv	a1,s3
     71a:	854a                	mv	a0,s2
     71c:	d2fff0ef          	jal	44a <peek>
     720:	e911                	bnez	a0,734 <parseline+0x68>
}
     722:	8526                	mv	a0,s1
     724:	70a2                	ld	ra,40(sp)
     726:	7402                	ld	s0,32(sp)
     728:	64e2                	ld	s1,24(sp)
     72a:	6942                	ld	s2,16(sp)
     72c:	69a2                	ld	s3,8(sp)
     72e:	6a02                	ld	s4,0(sp)
     730:	6145                	add	sp,sp,48
     732:	8082                	ret
    gettoken(ps, es, 0, 0);
     734:	4681                	li	a3,0
     736:	4601                	li	a2,0
     738:	85ce                	mv	a1,s3
     73a:	854a                	mv	a0,s2
     73c:	bd3ff0ef          	jal	30e <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     740:	85ce                	mv	a1,s3
     742:	854a                	mv	a0,s2
     744:	f89ff0ef          	jal	6cc <parseline>
     748:	85aa                	mv	a1,a0
     74a:	8526                	mv	a0,s1
     74c:	b51ff0ef          	jal	29c <listcmd>
     750:	84aa                	mv	s1,a0
  return cmd;
     752:	bfc1                	j	722 <parseline+0x56>

0000000000000754 <parseblock>:
{
     754:	7179                	add	sp,sp,-48
     756:	f406                	sd	ra,40(sp)
     758:	f022                	sd	s0,32(sp)
     75a:	ec26                	sd	s1,24(sp)
     75c:	e84a                	sd	s2,16(sp)
     75e:	e44e                	sd	s3,8(sp)
     760:	1800                	add	s0,sp,48
     762:	84aa                	mv	s1,a0
     764:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     766:	00001617          	auipc	a2,0x1
     76a:	afa60613          	add	a2,a2,-1286 # 1260 <malloc+0x150>
     76e:	cddff0ef          	jal	44a <peek>
     772:	c539                	beqz	a0,7c0 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     774:	4681                	li	a3,0
     776:	4601                	li	a2,0
     778:	85ca                	mv	a1,s2
     77a:	8526                	mv	a0,s1
     77c:	b93ff0ef          	jal	30e <gettoken>
  cmd = parseline(ps, es);
     780:	85ca                	mv	a1,s2
     782:	8526                	mv	a0,s1
     784:	f49ff0ef          	jal	6cc <parseline>
     788:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     78a:	00001617          	auipc	a2,0x1
     78e:	b2660613          	add	a2,a2,-1242 # 12b0 <malloc+0x1a0>
     792:	85ca                	mv	a1,s2
     794:	8526                	mv	a0,s1
     796:	cb5ff0ef          	jal	44a <peek>
     79a:	c90d                	beqz	a0,7cc <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     79c:	4681                	li	a3,0
     79e:	4601                	li	a2,0
     7a0:	85ca                	mv	a1,s2
     7a2:	8526                	mv	a0,s1
     7a4:	b6bff0ef          	jal	30e <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7a8:	864a                	mv	a2,s2
     7aa:	85a6                	mv	a1,s1
     7ac:	854e                	mv	a0,s3
     7ae:	d01ff0ef          	jal	4ae <parseredirs>
}
     7b2:	70a2                	ld	ra,40(sp)
     7b4:	7402                	ld	s0,32(sp)
     7b6:	64e2                	ld	s1,24(sp)
     7b8:	6942                	ld	s2,16(sp)
     7ba:	69a2                	ld	s3,8(sp)
     7bc:	6145                	add	sp,sp,48
     7be:	8082                	ret
    panic("parseblock");
     7c0:	00001517          	auipc	a0,0x1
     7c4:	ae050513          	add	a0,a0,-1312 # 12a0 <malloc+0x190>
     7c8:	883ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7cc:	00001517          	auipc	a0,0x1
     7d0:	aec50513          	add	a0,a0,-1300 # 12b8 <malloc+0x1a8>
     7d4:	877ff0ef          	jal	4a <panic>

00000000000007d8 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7d8:	1101                	add	sp,sp,-32
     7da:	ec06                	sd	ra,24(sp)
     7dc:	e822                	sd	s0,16(sp)
     7de:	e426                	sd	s1,8(sp)
     7e0:	1000                	add	s0,sp,32
     7e2:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7e4:	c131                	beqz	a0,828 <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7e6:	4118                	lw	a4,0(a0)
     7e8:	4795                	li	a5,5
     7ea:	02e7ef63          	bltu	a5,a4,828 <nulterminate+0x50>
     7ee:	00056783          	lwu	a5,0(a0)
     7f2:	078a                	sll	a5,a5,0x2
     7f4:	00001717          	auipc	a4,0x1
     7f8:	b2470713          	add	a4,a4,-1244 # 1318 <malloc+0x208>
     7fc:	97ba                	add	a5,a5,a4
     7fe:	439c                	lw	a5,0(a5)
     800:	97ba                	add	a5,a5,a4
     802:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     804:	651c                	ld	a5,8(a0)
     806:	c38d                	beqz	a5,828 <nulterminate+0x50>
     808:	01050793          	add	a5,a0,16
      *ecmd->eargv[i] = 0;
     80c:	67b8                	ld	a4,72(a5)
     80e:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     812:	07a1                	add	a5,a5,8
     814:	ff87b703          	ld	a4,-8(a5)
     818:	fb75                	bnez	a4,80c <nulterminate+0x34>
     81a:	a039                	j	828 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     81c:	6508                	ld	a0,8(a0)
     81e:	fbbff0ef          	jal	7d8 <nulterminate>
    *rcmd->efile = 0;
     822:	6c9c                	ld	a5,24(s1)
     824:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     828:	8526                	mv	a0,s1
     82a:	60e2                	ld	ra,24(sp)
     82c:	6442                	ld	s0,16(sp)
     82e:	64a2                	ld	s1,8(sp)
     830:	6105                	add	sp,sp,32
     832:	8082                	ret
    nulterminate(pcmd->left);
     834:	6508                	ld	a0,8(a0)
     836:	fa3ff0ef          	jal	7d8 <nulterminate>
    nulterminate(pcmd->right);
     83a:	6888                	ld	a0,16(s1)
     83c:	f9dff0ef          	jal	7d8 <nulterminate>
    break;
     840:	b7e5                	j	828 <nulterminate+0x50>
    nulterminate(lcmd->left);
     842:	6508                	ld	a0,8(a0)
     844:	f95ff0ef          	jal	7d8 <nulterminate>
    nulterminate(lcmd->right);
     848:	6888                	ld	a0,16(s1)
     84a:	f8fff0ef          	jal	7d8 <nulterminate>
    break;
     84e:	bfe9                	j	828 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     850:	6508                	ld	a0,8(a0)
     852:	f87ff0ef          	jal	7d8 <nulterminate>
    break;
     856:	bfc9                	j	828 <nulterminate+0x50>

0000000000000858 <parsecmd>:
{
     858:	7179                	add	sp,sp,-48
     85a:	f406                	sd	ra,40(sp)
     85c:	f022                	sd	s0,32(sp)
     85e:	ec26                	sd	s1,24(sp)
     860:	e84a                	sd	s2,16(sp)
     862:	1800                	add	s0,sp,48
     864:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     868:	84aa                	mv	s1,a0
     86a:	188000ef          	jal	9f2 <strlen>
     86e:	1502                	sll	a0,a0,0x20
     870:	9101                	srl	a0,a0,0x20
     872:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     874:	85a6                	mv	a1,s1
     876:	fd840513          	add	a0,s0,-40
     87a:	e53ff0ef          	jal	6cc <parseline>
     87e:	892a                	mv	s2,a0
  peek(&s, es, "");
     880:	00001617          	auipc	a2,0x1
     884:	a5060613          	add	a2,a2,-1456 # 12d0 <malloc+0x1c0>
     888:	85a6                	mv	a1,s1
     88a:	fd840513          	add	a0,s0,-40
     88e:	bbdff0ef          	jal	44a <peek>
  if(s != es){
     892:	fd843603          	ld	a2,-40(s0)
     896:	00961c63          	bne	a2,s1,8ae <parsecmd+0x56>
  nulterminate(cmd);
     89a:	854a                	mv	a0,s2
     89c:	f3dff0ef          	jal	7d8 <nulterminate>
}
     8a0:	854a                	mv	a0,s2
     8a2:	70a2                	ld	ra,40(sp)
     8a4:	7402                	ld	s0,32(sp)
     8a6:	64e2                	ld	s1,24(sp)
     8a8:	6942                	ld	s2,16(sp)
     8aa:	6145                	add	sp,sp,48
     8ac:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8ae:	00001597          	auipc	a1,0x1
     8b2:	a2a58593          	add	a1,a1,-1494 # 12d8 <malloc+0x1c8>
     8b6:	4509                	li	a0,2
     8b8:	77a000ef          	jal	1032 <fprintf>
    panic("syntax");
     8bc:	00001517          	auipc	a0,0x1
     8c0:	9ac50513          	add	a0,a0,-1620 # 1268 <malloc+0x158>
     8c4:	f86ff0ef          	jal	4a <panic>

00000000000008c8 <main>:
{
     8c8:	7179                	add	sp,sp,-48
     8ca:	f406                	sd	ra,40(sp)
     8cc:	f022                	sd	s0,32(sp)
     8ce:	ec26                	sd	s1,24(sp)
     8d0:	e84a                	sd	s2,16(sp)
     8d2:	e44e                	sd	s3,8(sp)
     8d4:	e052                	sd	s4,0(sp)
     8d6:	1800                	add	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     8d8:	00001497          	auipc	s1,0x1
     8dc:	a1048493          	add	s1,s1,-1520 # 12e8 <malloc+0x1d8>
     8e0:	4589                	li	a1,2
     8e2:	8526                	mv	a0,s1
     8e4:	35e000ef          	jal	c42 <open>
     8e8:	00054763          	bltz	a0,8f6 <main+0x2e>
    if(fd >= 3){
     8ec:	4789                	li	a5,2
     8ee:	fea7d9e3          	bge	a5,a0,8e0 <main+0x18>
      close(fd);
     8f2:	338000ef          	jal	c2a <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     8f6:	00001497          	auipc	s1,0x1
     8fa:	72a48493          	add	s1,s1,1834 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     8fe:	06300913          	li	s2,99
     902:	02000993          	li	s3,32
     906:	a039                	j	914 <main+0x4c>
    if(fork1() == 0)
     908:	f60ff0ef          	jal	68 <fork1>
     90c:	c93d                	beqz	a0,982 <main+0xba>
    wait(0);
     90e:	4501                	li	a0,0
     910:	2fa000ef          	jal	c0a <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     914:	06400593          	li	a1,100
     918:	8526                	mv	a0,s1
     91a:	ee6ff0ef          	jal	0 <getcmd>
     91e:	06054a63          	bltz	a0,992 <main+0xca>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     922:	0004c783          	lbu	a5,0(s1)
     926:	ff2791e3          	bne	a5,s2,908 <main+0x40>
     92a:	0014c703          	lbu	a4,1(s1)
     92e:	06400793          	li	a5,100
     932:	fcf71be3          	bne	a4,a5,908 <main+0x40>
     936:	0024c783          	lbu	a5,2(s1)
     93a:	fd3797e3          	bne	a5,s3,908 <main+0x40>
      buf[strlen(buf)-1] = 0;  // chop \n
     93e:	00001a17          	auipc	s4,0x1
     942:	6e2a0a13          	add	s4,s4,1762 # 2020 <buf.0>
     946:	8552                	mv	a0,s4
     948:	0aa000ef          	jal	9f2 <strlen>
     94c:	fff5079b          	addw	a5,a0,-1
     950:	1782                	sll	a5,a5,0x20
     952:	9381                	srl	a5,a5,0x20
     954:	9a3e                	add	s4,s4,a5
     956:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     95a:	00001517          	auipc	a0,0x1
     95e:	6c950513          	add	a0,a0,1737 # 2023 <buf.0+0x3>
     962:	310000ef          	jal	c72 <chdir>
     966:	fa0557e3          	bgez	a0,914 <main+0x4c>
        fprintf(2, "cannot cd %s\n", buf+3);
     96a:	00001617          	auipc	a2,0x1
     96e:	6b960613          	add	a2,a2,1721 # 2023 <buf.0+0x3>
     972:	00001597          	auipc	a1,0x1
     976:	97e58593          	add	a1,a1,-1666 # 12f0 <malloc+0x1e0>
     97a:	4509                	li	a0,2
     97c:	6b6000ef          	jal	1032 <fprintf>
     980:	bf51                	j	914 <main+0x4c>
      runcmd(parsecmd(buf));
     982:	00001517          	auipc	a0,0x1
     986:	69e50513          	add	a0,a0,1694 # 2020 <buf.0>
     98a:	ecfff0ef          	jal	858 <parsecmd>
     98e:	f00ff0ef          	jal	8e <runcmd>
  exit(0);
     992:	4501                	li	a0,0
     994:	26e000ef          	jal	c02 <exit>

0000000000000998 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     998:	1141                	add	sp,sp,-16
     99a:	e406                	sd	ra,8(sp)
     99c:	e022                	sd	s0,0(sp)
     99e:	0800                	add	s0,sp,16
  extern int main();
  main();
     9a0:	f29ff0ef          	jal	8c8 <main>
  exit(0);
     9a4:	4501                	li	a0,0
     9a6:	25c000ef          	jal	c02 <exit>

00000000000009aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9aa:	1141                	add	sp,sp,-16
     9ac:	e422                	sd	s0,8(sp)
     9ae:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9b0:	87aa                	mv	a5,a0
     9b2:	0585                	add	a1,a1,1
     9b4:	0785                	add	a5,a5,1
     9b6:	fff5c703          	lbu	a4,-1(a1)
     9ba:	fee78fa3          	sb	a4,-1(a5)
     9be:	fb75                	bnez	a4,9b2 <strcpy+0x8>
    ;
  return os;
}
     9c0:	6422                	ld	s0,8(sp)
     9c2:	0141                	add	sp,sp,16
     9c4:	8082                	ret

00000000000009c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9c6:	1141                	add	sp,sp,-16
     9c8:	e422                	sd	s0,8(sp)
     9ca:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     9cc:	00054783          	lbu	a5,0(a0)
     9d0:	cb91                	beqz	a5,9e4 <strcmp+0x1e>
     9d2:	0005c703          	lbu	a4,0(a1)
     9d6:	00f71763          	bne	a4,a5,9e4 <strcmp+0x1e>
    p++, q++;
     9da:	0505                	add	a0,a0,1
     9dc:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     9de:	00054783          	lbu	a5,0(a0)
     9e2:	fbe5                	bnez	a5,9d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     9e4:	0005c503          	lbu	a0,0(a1)
}
     9e8:	40a7853b          	subw	a0,a5,a0
     9ec:	6422                	ld	s0,8(sp)
     9ee:	0141                	add	sp,sp,16
     9f0:	8082                	ret

00000000000009f2 <strlen>:

uint
strlen(const char *s)
{
     9f2:	1141                	add	sp,sp,-16
     9f4:	e422                	sd	s0,8(sp)
     9f6:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9f8:	00054783          	lbu	a5,0(a0)
     9fc:	cf91                	beqz	a5,a18 <strlen+0x26>
     9fe:	0505                	add	a0,a0,1
     a00:	87aa                	mv	a5,a0
     a02:	86be                	mv	a3,a5
     a04:	0785                	add	a5,a5,1
     a06:	fff7c703          	lbu	a4,-1(a5)
     a0a:	ff65                	bnez	a4,a02 <strlen+0x10>
     a0c:	40a6853b          	subw	a0,a3,a0
     a10:	2505                	addw	a0,a0,1
    ;
  return n;
}
     a12:	6422                	ld	s0,8(sp)
     a14:	0141                	add	sp,sp,16
     a16:	8082                	ret
  for(n = 0; s[n]; n++)
     a18:	4501                	li	a0,0
     a1a:	bfe5                	j	a12 <strlen+0x20>

0000000000000a1c <memset>:

void*
memset(void *dst, int c, uint n)
{
     a1c:	1141                	add	sp,sp,-16
     a1e:	e422                	sd	s0,8(sp)
     a20:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a22:	ca19                	beqz	a2,a38 <memset+0x1c>
     a24:	87aa                	mv	a5,a0
     a26:	1602                	sll	a2,a2,0x20
     a28:	9201                	srl	a2,a2,0x20
     a2a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a2e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a32:	0785                	add	a5,a5,1
     a34:	fee79de3          	bne	a5,a4,a2e <memset+0x12>
  }
  return dst;
}
     a38:	6422                	ld	s0,8(sp)
     a3a:	0141                	add	sp,sp,16
     a3c:	8082                	ret

0000000000000a3e <strchr>:

char*
strchr(const char *s, char c)
{
     a3e:	1141                	add	sp,sp,-16
     a40:	e422                	sd	s0,8(sp)
     a42:	0800                	add	s0,sp,16
  for(; *s; s++)
     a44:	00054783          	lbu	a5,0(a0)
     a48:	cb99                	beqz	a5,a5e <strchr+0x20>
    if(*s == c)
     a4a:	00f58763          	beq	a1,a5,a58 <strchr+0x1a>
  for(; *s; s++)
     a4e:	0505                	add	a0,a0,1
     a50:	00054783          	lbu	a5,0(a0)
     a54:	fbfd                	bnez	a5,a4a <strchr+0xc>
      return (char*)s;
  return 0;
     a56:	4501                	li	a0,0
}
     a58:	6422                	ld	s0,8(sp)
     a5a:	0141                	add	sp,sp,16
     a5c:	8082                	ret
  return 0;
     a5e:	4501                	li	a0,0
     a60:	bfe5                	j	a58 <strchr+0x1a>

0000000000000a62 <gets>:

char*
gets(char *buf, int max)
{
     a62:	711d                	add	sp,sp,-96
     a64:	ec86                	sd	ra,88(sp)
     a66:	e8a2                	sd	s0,80(sp)
     a68:	e4a6                	sd	s1,72(sp)
     a6a:	e0ca                	sd	s2,64(sp)
     a6c:	fc4e                	sd	s3,56(sp)
     a6e:	f852                	sd	s4,48(sp)
     a70:	f456                	sd	s5,40(sp)
     a72:	f05a                	sd	s6,32(sp)
     a74:	ec5e                	sd	s7,24(sp)
     a76:	1080                	add	s0,sp,96
     a78:	8baa                	mv	s7,a0
     a7a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a7c:	892a                	mv	s2,a0
     a7e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a80:	4aa9                	li	s5,10
     a82:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a84:	89a6                	mv	s3,s1
     a86:	2485                	addw	s1,s1,1
     a88:	0344d663          	bge	s1,s4,ab4 <gets+0x52>
    cc = read(0, &c, 1);
     a8c:	4605                	li	a2,1
     a8e:	faf40593          	add	a1,s0,-81
     a92:	4501                	li	a0,0
     a94:	186000ef          	jal	c1a <read>
    if(cc < 1)
     a98:	00a05e63          	blez	a0,ab4 <gets+0x52>
    buf[i++] = c;
     a9c:	faf44783          	lbu	a5,-81(s0)
     aa0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     aa4:	01578763          	beq	a5,s5,ab2 <gets+0x50>
     aa8:	0905                	add	s2,s2,1
     aaa:	fd679de3          	bne	a5,s6,a84 <gets+0x22>
  for(i=0; i+1 < max; ){
     aae:	89a6                	mv	s3,s1
     ab0:	a011                	j	ab4 <gets+0x52>
     ab2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     ab4:	99de                	add	s3,s3,s7
     ab6:	00098023          	sb	zero,0(s3)
  return buf;
}
     aba:	855e                	mv	a0,s7
     abc:	60e6                	ld	ra,88(sp)
     abe:	6446                	ld	s0,80(sp)
     ac0:	64a6                	ld	s1,72(sp)
     ac2:	6906                	ld	s2,64(sp)
     ac4:	79e2                	ld	s3,56(sp)
     ac6:	7a42                	ld	s4,48(sp)
     ac8:	7aa2                	ld	s5,40(sp)
     aca:	7b02                	ld	s6,32(sp)
     acc:	6be2                	ld	s7,24(sp)
     ace:	6125                	add	sp,sp,96
     ad0:	8082                	ret

0000000000000ad2 <stat>:

int
stat(const char *n, struct stat *st)
{
     ad2:	1101                	add	sp,sp,-32
     ad4:	ec06                	sd	ra,24(sp)
     ad6:	e822                	sd	s0,16(sp)
     ad8:	e426                	sd	s1,8(sp)
     ada:	e04a                	sd	s2,0(sp)
     adc:	1000                	add	s0,sp,32
     ade:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ae0:	4581                	li	a1,0
     ae2:	160000ef          	jal	c42 <open>
  if(fd < 0)
     ae6:	02054163          	bltz	a0,b08 <stat+0x36>
     aea:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     aec:	85ca                	mv	a1,s2
     aee:	16c000ef          	jal	c5a <fstat>
     af2:	892a                	mv	s2,a0
  close(fd);
     af4:	8526                	mv	a0,s1
     af6:	134000ef          	jal	c2a <close>
  return r;
}
     afa:	854a                	mv	a0,s2
     afc:	60e2                	ld	ra,24(sp)
     afe:	6442                	ld	s0,16(sp)
     b00:	64a2                	ld	s1,8(sp)
     b02:	6902                	ld	s2,0(sp)
     b04:	6105                	add	sp,sp,32
     b06:	8082                	ret
    return -1;
     b08:	597d                	li	s2,-1
     b0a:	bfc5                	j	afa <stat+0x28>

0000000000000b0c <atoi>:

int
atoi(const char *s)
{
     b0c:	1141                	add	sp,sp,-16
     b0e:	e422                	sd	s0,8(sp)
     b10:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b12:	00054683          	lbu	a3,0(a0)
     b16:	fd06879b          	addw	a5,a3,-48
     b1a:	0ff7f793          	zext.b	a5,a5
     b1e:	4625                	li	a2,9
     b20:	02f66863          	bltu	a2,a5,b50 <atoi+0x44>
     b24:	872a                	mv	a4,a0
  n = 0;
     b26:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b28:	0705                	add	a4,a4,1
     b2a:	0025179b          	sllw	a5,a0,0x2
     b2e:	9fa9                	addw	a5,a5,a0
     b30:	0017979b          	sllw	a5,a5,0x1
     b34:	9fb5                	addw	a5,a5,a3
     b36:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b3a:	00074683          	lbu	a3,0(a4)
     b3e:	fd06879b          	addw	a5,a3,-48
     b42:	0ff7f793          	zext.b	a5,a5
     b46:	fef671e3          	bgeu	a2,a5,b28 <atoi+0x1c>
  return n;
}
     b4a:	6422                	ld	s0,8(sp)
     b4c:	0141                	add	sp,sp,16
     b4e:	8082                	ret
  n = 0;
     b50:	4501                	li	a0,0
     b52:	bfe5                	j	b4a <atoi+0x3e>

0000000000000b54 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b54:	1141                	add	sp,sp,-16
     b56:	e422                	sd	s0,8(sp)
     b58:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b5a:	02b57463          	bgeu	a0,a1,b82 <memmove+0x2e>
    while(n-- > 0)
     b5e:	00c05f63          	blez	a2,b7c <memmove+0x28>
     b62:	1602                	sll	a2,a2,0x20
     b64:	9201                	srl	a2,a2,0x20
     b66:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b6a:	872a                	mv	a4,a0
      *dst++ = *src++;
     b6c:	0585                	add	a1,a1,1
     b6e:	0705                	add	a4,a4,1
     b70:	fff5c683          	lbu	a3,-1(a1)
     b74:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b78:	fee79ae3          	bne	a5,a4,b6c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b7c:	6422                	ld	s0,8(sp)
     b7e:	0141                	add	sp,sp,16
     b80:	8082                	ret
    dst += n;
     b82:	00c50733          	add	a4,a0,a2
    src += n;
     b86:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b88:	fec05ae3          	blez	a2,b7c <memmove+0x28>
     b8c:	fff6079b          	addw	a5,a2,-1
     b90:	1782                	sll	a5,a5,0x20
     b92:	9381                	srl	a5,a5,0x20
     b94:	fff7c793          	not	a5,a5
     b98:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b9a:	15fd                	add	a1,a1,-1
     b9c:	177d                	add	a4,a4,-1
     b9e:	0005c683          	lbu	a3,0(a1)
     ba2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ba6:	fee79ae3          	bne	a5,a4,b9a <memmove+0x46>
     baa:	bfc9                	j	b7c <memmove+0x28>

0000000000000bac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bac:	1141                	add	sp,sp,-16
     bae:	e422                	sd	s0,8(sp)
     bb0:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bb2:	ca05                	beqz	a2,be2 <memcmp+0x36>
     bb4:	fff6069b          	addw	a3,a2,-1
     bb8:	1682                	sll	a3,a3,0x20
     bba:	9281                	srl	a3,a3,0x20
     bbc:	0685                	add	a3,a3,1
     bbe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bc0:	00054783          	lbu	a5,0(a0)
     bc4:	0005c703          	lbu	a4,0(a1)
     bc8:	00e79863          	bne	a5,a4,bd8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bcc:	0505                	add	a0,a0,1
    p2++;
     bce:	0585                	add	a1,a1,1
  while (n-- > 0) {
     bd0:	fed518e3          	bne	a0,a3,bc0 <memcmp+0x14>
  }
  return 0;
     bd4:	4501                	li	a0,0
     bd6:	a019                	j	bdc <memcmp+0x30>
      return *p1 - *p2;
     bd8:	40e7853b          	subw	a0,a5,a4
}
     bdc:	6422                	ld	s0,8(sp)
     bde:	0141                	add	sp,sp,16
     be0:	8082                	ret
  return 0;
     be2:	4501                	li	a0,0
     be4:	bfe5                	j	bdc <memcmp+0x30>

0000000000000be6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     be6:	1141                	add	sp,sp,-16
     be8:	e406                	sd	ra,8(sp)
     bea:	e022                	sd	s0,0(sp)
     bec:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     bee:	f67ff0ef          	jal	b54 <memmove>
}
     bf2:	60a2                	ld	ra,8(sp)
     bf4:	6402                	ld	s0,0(sp)
     bf6:	0141                	add	sp,sp,16
     bf8:	8082                	ret

0000000000000bfa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     bfa:	4885                	li	a7,1
 ecall
     bfc:	00000073          	ecall
 ret
     c00:	8082                	ret

0000000000000c02 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c02:	4889                	li	a7,2
 ecall
     c04:	00000073          	ecall
 ret
     c08:	8082                	ret

0000000000000c0a <wait>:
.global wait
wait:
 li a7, SYS_wait
     c0a:	488d                	li	a7,3
 ecall
     c0c:	00000073          	ecall
 ret
     c10:	8082                	ret

0000000000000c12 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c12:	4891                	li	a7,4
 ecall
     c14:	00000073          	ecall
 ret
     c18:	8082                	ret

0000000000000c1a <read>:
.global read
read:
 li a7, SYS_read
     c1a:	4895                	li	a7,5
 ecall
     c1c:	00000073          	ecall
 ret
     c20:	8082                	ret

0000000000000c22 <write>:
.global write
write:
 li a7, SYS_write
     c22:	48c1                	li	a7,16
 ecall
     c24:	00000073          	ecall
 ret
     c28:	8082                	ret

0000000000000c2a <close>:
.global close
close:
 li a7, SYS_close
     c2a:	48d5                	li	a7,21
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c32:	4899                	li	a7,6
 ecall
     c34:	00000073          	ecall
 ret
     c38:	8082                	ret

0000000000000c3a <exec>:
.global exec
exec:
 li a7, SYS_exec
     c3a:	489d                	li	a7,7
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <open>:
.global open
open:
 li a7, SYS_open
     c42:	48bd                	li	a7,15
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c4a:	48c5                	li	a7,17
 ecall
     c4c:	00000073          	ecall
 ret
     c50:	8082                	ret

0000000000000c52 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c52:	48c9                	li	a7,18
 ecall
     c54:	00000073          	ecall
 ret
     c58:	8082                	ret

0000000000000c5a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c5a:	48a1                	li	a7,8
 ecall
     c5c:	00000073          	ecall
 ret
     c60:	8082                	ret

0000000000000c62 <link>:
.global link
link:
 li a7, SYS_link
     c62:	48cd                	li	a7,19
 ecall
     c64:	00000073          	ecall
 ret
     c68:	8082                	ret

0000000000000c6a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c6a:	48d1                	li	a7,20
 ecall
     c6c:	00000073          	ecall
 ret
     c70:	8082                	ret

0000000000000c72 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c72:	48a5                	li	a7,9
 ecall
     c74:	00000073          	ecall
 ret
     c78:	8082                	ret

0000000000000c7a <dup>:
.global dup
dup:
 li a7, SYS_dup
     c7a:	48a9                	li	a7,10
 ecall
     c7c:	00000073          	ecall
 ret
     c80:	8082                	ret

0000000000000c82 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c82:	48ad                	li	a7,11
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c8a:	48b1                	li	a7,12
 ecall
     c8c:	00000073          	ecall
 ret
     c90:	8082                	ret

0000000000000c92 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c92:	48b5                	li	a7,13
 ecall
     c94:	00000073          	ecall
 ret
     c98:	8082                	ret

0000000000000c9a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c9a:	48b9                	li	a7,14
 ecall
     c9c:	00000073          	ecall
 ret
     ca0:	8082                	ret

0000000000000ca2 <tempo_total>:
.global tempo_total
tempo_total:
 li a7, SYS_tempo_total
     ca2:	48d9                	li	a7,22
 ecall
     ca4:	00000073          	ecall
 ret
     ca8:	8082                	ret

0000000000000caa <get_eficiencia>:
.global get_eficiencia
get_eficiencia:
 li a7, SYS_get_eficiencia
     caa:	48dd                	li	a7,23
 ecall
     cac:	00000073          	ecall
 ret
     cb0:	8082                	ret

0000000000000cb2 <get_overhead>:
.global get_overhead
get_overhead:
 li a7, SYS_get_overhead
     cb2:	48e1                	li	a7,24
 ecall
     cb4:	00000073          	ecall
 ret
     cb8:	8082                	ret

0000000000000cba <increment_metric>:
.global increment_metric
increment_metric:
 li a7, SYS_increment_metric
     cba:	48e5                	li	a7,25
 ecall
     cbc:	00000073          	ecall
 ret
     cc0:	8082                	ret

0000000000000cc2 <initialize_metrics>:
.global initialize_metrics
initialize_metrics:
 li a7, SYS_initialize_metrics
     cc2:	48e9                	li	a7,26
 ecall
     cc4:	00000073          	ecall
 ret
     cc8:	8082                	ret

0000000000000cca <get_justica>:
.global get_justica
get_justica:
 li a7, SYS_get_justica
     cca:	48ed                	li	a7,27
 ecall
     ccc:	00000073          	ecall
 ret
     cd0:	8082                	ret

0000000000000cd2 <set_justica>:
.global set_justica
set_justica:
 li a7, SYS_set_justica
     cd2:	48f1                	li	a7,28
 ecall
     cd4:	00000073          	ecall
 ret
     cd8:	8082                	ret

0000000000000cda <uptime_nolock>:
.global uptime_nolock
uptime_nolock:
 li a7, SYS_uptime_nolock
     cda:	48f5                	li	a7,29
 ecall
     cdc:	00000073          	ecall
 ret
     ce0:	8082                	ret

0000000000000ce2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ce2:	1101                	add	sp,sp,-32
     ce4:	ec06                	sd	ra,24(sp)
     ce6:	e822                	sd	s0,16(sp)
     ce8:	1000                	add	s0,sp,32
     cea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     cee:	4605                	li	a2,1
     cf0:	fef40593          	add	a1,s0,-17
     cf4:	f2fff0ef          	jal	c22 <write>
}
     cf8:	60e2                	ld	ra,24(sp)
     cfa:	6442                	ld	s0,16(sp)
     cfc:	6105                	add	sp,sp,32
     cfe:	8082                	ret

0000000000000d00 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d00:	7139                	add	sp,sp,-64
     d02:	fc06                	sd	ra,56(sp)
     d04:	f822                	sd	s0,48(sp)
     d06:	f426                	sd	s1,40(sp)
     d08:	f04a                	sd	s2,32(sp)
     d0a:	ec4e                	sd	s3,24(sp)
     d0c:	0080                	add	s0,sp,64
     d0e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d10:	c299                	beqz	a3,d16 <printint+0x16>
     d12:	0805c763          	bltz	a1,da0 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d16:	2581                	sext.w	a1,a1
  neg = 0;
     d18:	4881                	li	a7,0
     d1a:	fc040693          	add	a3,s0,-64
  }

  i = 0;
     d1e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d20:	2601                	sext.w	a2,a2
     d22:	00000517          	auipc	a0,0x0
     d26:	61650513          	add	a0,a0,1558 # 1338 <digits>
     d2a:	883a                	mv	a6,a4
     d2c:	2705                	addw	a4,a4,1
     d2e:	02c5f7bb          	remuw	a5,a1,a2
     d32:	1782                	sll	a5,a5,0x20
     d34:	9381                	srl	a5,a5,0x20
     d36:	97aa                	add	a5,a5,a0
     d38:	0007c783          	lbu	a5,0(a5)
     d3c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d40:	0005879b          	sext.w	a5,a1
     d44:	02c5d5bb          	divuw	a1,a1,a2
     d48:	0685                	add	a3,a3,1
     d4a:	fec7f0e3          	bgeu	a5,a2,d2a <printint+0x2a>
  if(neg)
     d4e:	00088c63          	beqz	a7,d66 <printint+0x66>
    buf[i++] = '-';
     d52:	fd070793          	add	a5,a4,-48
     d56:	00878733          	add	a4,a5,s0
     d5a:	02d00793          	li	a5,45
     d5e:	fef70823          	sb	a5,-16(a4)
     d62:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
     d66:	02e05663          	blez	a4,d92 <printint+0x92>
     d6a:	fc040793          	add	a5,s0,-64
     d6e:	00e78933          	add	s2,a5,a4
     d72:	fff78993          	add	s3,a5,-1
     d76:	99ba                	add	s3,s3,a4
     d78:	377d                	addw	a4,a4,-1
     d7a:	1702                	sll	a4,a4,0x20
     d7c:	9301                	srl	a4,a4,0x20
     d7e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d82:	fff94583          	lbu	a1,-1(s2)
     d86:	8526                	mv	a0,s1
     d88:	f5bff0ef          	jal	ce2 <putc>
  while(--i >= 0)
     d8c:	197d                	add	s2,s2,-1
     d8e:	ff391ae3          	bne	s2,s3,d82 <printint+0x82>
}
     d92:	70e2                	ld	ra,56(sp)
     d94:	7442                	ld	s0,48(sp)
     d96:	74a2                	ld	s1,40(sp)
     d98:	7902                	ld	s2,32(sp)
     d9a:	69e2                	ld	s3,24(sp)
     d9c:	6121                	add	sp,sp,64
     d9e:	8082                	ret
    x = -xx;
     da0:	40b005bb          	negw	a1,a1
    neg = 1;
     da4:	4885                	li	a7,1
    x = -xx;
     da6:	bf95                	j	d1a <printint+0x1a>

0000000000000da8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     da8:	711d                	add	sp,sp,-96
     daa:	ec86                	sd	ra,88(sp)
     dac:	e8a2                	sd	s0,80(sp)
     dae:	e4a6                	sd	s1,72(sp)
     db0:	e0ca                	sd	s2,64(sp)
     db2:	fc4e                	sd	s3,56(sp)
     db4:	f852                	sd	s4,48(sp)
     db6:	f456                	sd	s5,40(sp)
     db8:	f05a                	sd	s6,32(sp)
     dba:	ec5e                	sd	s7,24(sp)
     dbc:	e862                	sd	s8,16(sp)
     dbe:	e466                	sd	s9,8(sp)
     dc0:	e06a                	sd	s10,0(sp)
     dc2:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dc4:	0005c903          	lbu	s2,0(a1)
     dc8:	24090763          	beqz	s2,1016 <vprintf+0x26e>
     dcc:	8b2a                	mv	s6,a0
     dce:	8a2e                	mv	s4,a1
     dd0:	8bb2                	mv	s7,a2
  state = 0;
     dd2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     dd4:	4481                	li	s1,0
     dd6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     dd8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     ddc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     de0:	06c00c93          	li	s9,108
     de4:	a005                	j	e04 <vprintf+0x5c>
        putc(fd, c0);
     de6:	85ca                	mv	a1,s2
     de8:	855a                	mv	a0,s6
     dea:	ef9ff0ef          	jal	ce2 <putc>
     dee:	a019                	j	df4 <vprintf+0x4c>
    } else if(state == '%'){
     df0:	03598263          	beq	s3,s5,e14 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
     df4:	2485                	addw	s1,s1,1
     df6:	8726                	mv	a4,s1
     df8:	009a07b3          	add	a5,s4,s1
     dfc:	0007c903          	lbu	s2,0(a5)
     e00:	20090b63          	beqz	s2,1016 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     e04:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e08:	fe0994e3          	bnez	s3,df0 <vprintf+0x48>
      if(c0 == '%'){
     e0c:	fd579de3          	bne	a5,s5,de6 <vprintf+0x3e>
        state = '%';
     e10:	89be                	mv	s3,a5
     e12:	b7cd                	j	df4 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
     e14:	c7c9                	beqz	a5,e9e <vprintf+0xf6>
     e16:	00ea06b3          	add	a3,s4,a4
     e1a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e1e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     e20:	c681                	beqz	a3,e28 <vprintf+0x80>
     e22:	9752                	add	a4,a4,s4
     e24:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     e28:	03878f63          	beq	a5,s8,e66 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
     e2c:	05978963          	beq	a5,s9,e7e <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     e30:	07500713          	li	a4,117
     e34:	0ee78363          	beq	a5,a4,f1a <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e38:	07800713          	li	a4,120
     e3c:	12e78563          	beq	a5,a4,f66 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e40:	07000713          	li	a4,112
     e44:	14e78a63          	beq	a5,a4,f98 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     e48:	07300713          	li	a4,115
     e4c:	18e78863          	beq	a5,a4,fdc <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e50:	02500713          	li	a4,37
     e54:	04e79563          	bne	a5,a4,e9e <vprintf+0xf6>
        putc(fd, '%');
     e58:	02500593          	li	a1,37
     e5c:	855a                	mv	a0,s6
     e5e:	e85ff0ef          	jal	ce2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     e62:	4981                	li	s3,0
     e64:	bf41                	j	df4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
     e66:	008b8913          	add	s2,s7,8
     e6a:	4685                	li	a3,1
     e6c:	4629                	li	a2,10
     e6e:	000ba583          	lw	a1,0(s7)
     e72:	855a                	mv	a0,s6
     e74:	e8dff0ef          	jal	d00 <printint>
     e78:	8bca                	mv	s7,s2
      state = 0;
     e7a:	4981                	li	s3,0
     e7c:	bfa5                	j	df4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
     e7e:	06400793          	li	a5,100
     e82:	02f68963          	beq	a3,a5,eb4 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e86:	06c00793          	li	a5,108
     e8a:	04f68263          	beq	a3,a5,ece <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
     e8e:	07500793          	li	a5,117
     e92:	0af68063          	beq	a3,a5,f32 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
     e96:	07800793          	li	a5,120
     e9a:	0ef68263          	beq	a3,a5,f7e <vprintf+0x1d6>
        putc(fd, '%');
     e9e:	02500593          	li	a1,37
     ea2:	855a                	mv	a0,s6
     ea4:	e3fff0ef          	jal	ce2 <putc>
        putc(fd, c0);
     ea8:	85ca                	mv	a1,s2
     eaa:	855a                	mv	a0,s6
     eac:	e37ff0ef          	jal	ce2 <putc>
      state = 0;
     eb0:	4981                	li	s3,0
     eb2:	b789                	j	df4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
     eb4:	008b8913          	add	s2,s7,8
     eb8:	4685                	li	a3,1
     eba:	4629                	li	a2,10
     ebc:	000ba583          	lw	a1,0(s7)
     ec0:	855a                	mv	a0,s6
     ec2:	e3fff0ef          	jal	d00 <printint>
        i += 1;
     ec6:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     ec8:	8bca                	mv	s7,s2
      state = 0;
     eca:	4981                	li	s3,0
        i += 1;
     ecc:	b725                	j	df4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ece:	06400793          	li	a5,100
     ed2:	02f60763          	beq	a2,a5,f00 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     ed6:	07500793          	li	a5,117
     eda:	06f60963          	beq	a2,a5,f4c <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     ede:	07800793          	li	a5,120
     ee2:	faf61ee3          	bne	a2,a5,e9e <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
     ee6:	008b8913          	add	s2,s7,8
     eea:	4681                	li	a3,0
     eec:	4641                	li	a2,16
     eee:	000ba583          	lw	a1,0(s7)
     ef2:	855a                	mv	a0,s6
     ef4:	e0dff0ef          	jal	d00 <printint>
        i += 2;
     ef8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     efa:	8bca                	mv	s7,s2
      state = 0;
     efc:	4981                	li	s3,0
        i += 2;
     efe:	bddd                	j	df4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f00:	008b8913          	add	s2,s7,8
     f04:	4685                	li	a3,1
     f06:	4629                	li	a2,10
     f08:	000ba583          	lw	a1,0(s7)
     f0c:	855a                	mv	a0,s6
     f0e:	df3ff0ef          	jal	d00 <printint>
        i += 2;
     f12:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f14:	8bca                	mv	s7,s2
      state = 0;
     f16:	4981                	li	s3,0
        i += 2;
     f18:	bdf1                	j	df4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
     f1a:	008b8913          	add	s2,s7,8
     f1e:	4681                	li	a3,0
     f20:	4629                	li	a2,10
     f22:	000ba583          	lw	a1,0(s7)
     f26:	855a                	mv	a0,s6
     f28:	dd9ff0ef          	jal	d00 <printint>
     f2c:	8bca                	mv	s7,s2
      state = 0;
     f2e:	4981                	li	s3,0
     f30:	b5d1                	j	df4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f32:	008b8913          	add	s2,s7,8
     f36:	4681                	li	a3,0
     f38:	4629                	li	a2,10
     f3a:	000ba583          	lw	a1,0(s7)
     f3e:	855a                	mv	a0,s6
     f40:	dc1ff0ef          	jal	d00 <printint>
        i += 1;
     f44:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f46:	8bca                	mv	s7,s2
      state = 0;
     f48:	4981                	li	s3,0
        i += 1;
     f4a:	b56d                	j	df4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f4c:	008b8913          	add	s2,s7,8
     f50:	4681                	li	a3,0
     f52:	4629                	li	a2,10
     f54:	000ba583          	lw	a1,0(s7)
     f58:	855a                	mv	a0,s6
     f5a:	da7ff0ef          	jal	d00 <printint>
        i += 2;
     f5e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f60:	8bca                	mv	s7,s2
      state = 0;
     f62:	4981                	li	s3,0
        i += 2;
     f64:	bd41                	j	df4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
     f66:	008b8913          	add	s2,s7,8
     f6a:	4681                	li	a3,0
     f6c:	4641                	li	a2,16
     f6e:	000ba583          	lw	a1,0(s7)
     f72:	855a                	mv	a0,s6
     f74:	d8dff0ef          	jal	d00 <printint>
     f78:	8bca                	mv	s7,s2
      state = 0;
     f7a:	4981                	li	s3,0
     f7c:	bda5                	j	df4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f7e:	008b8913          	add	s2,s7,8
     f82:	4681                	li	a3,0
     f84:	4641                	li	a2,16
     f86:	000ba583          	lw	a1,0(s7)
     f8a:	855a                	mv	a0,s6
     f8c:	d75ff0ef          	jal	d00 <printint>
        i += 1;
     f90:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f92:	8bca                	mv	s7,s2
      state = 0;
     f94:	4981                	li	s3,0
        i += 1;
     f96:	bdb9                	j	df4 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
     f98:	008b8d13          	add	s10,s7,8
     f9c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fa0:	03000593          	li	a1,48
     fa4:	855a                	mv	a0,s6
     fa6:	d3dff0ef          	jal	ce2 <putc>
  putc(fd, 'x');
     faa:	07800593          	li	a1,120
     fae:	855a                	mv	a0,s6
     fb0:	d33ff0ef          	jal	ce2 <putc>
     fb4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fb6:	00000b97          	auipc	s7,0x0
     fba:	382b8b93          	add	s7,s7,898 # 1338 <digits>
     fbe:	03c9d793          	srl	a5,s3,0x3c
     fc2:	97de                	add	a5,a5,s7
     fc4:	0007c583          	lbu	a1,0(a5)
     fc8:	855a                	mv	a0,s6
     fca:	d19ff0ef          	jal	ce2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     fce:	0992                	sll	s3,s3,0x4
     fd0:	397d                	addw	s2,s2,-1
     fd2:	fe0916e3          	bnez	s2,fbe <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
     fd6:	8bea                	mv	s7,s10
      state = 0;
     fd8:	4981                	li	s3,0
     fda:	bd29                	j	df4 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
     fdc:	008b8993          	add	s3,s7,8
     fe0:	000bb903          	ld	s2,0(s7)
     fe4:	00090f63          	beqz	s2,1002 <vprintf+0x25a>
        for(; *s; s++)
     fe8:	00094583          	lbu	a1,0(s2)
     fec:	c195                	beqz	a1,1010 <vprintf+0x268>
          putc(fd, *s);
     fee:	855a                	mv	a0,s6
     ff0:	cf3ff0ef          	jal	ce2 <putc>
        for(; *s; s++)
     ff4:	0905                	add	s2,s2,1
     ff6:	00094583          	lbu	a1,0(s2)
     ffa:	f9f5                	bnez	a1,fee <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     ffc:	8bce                	mv	s7,s3
      state = 0;
     ffe:	4981                	li	s3,0
    1000:	bbd5                	j	df4 <vprintf+0x4c>
          s = "(null)";
    1002:	00000917          	auipc	s2,0x0
    1006:	32e90913          	add	s2,s2,814 # 1330 <malloc+0x220>
        for(; *s; s++)
    100a:	02800593          	li	a1,40
    100e:	b7c5                	j	fee <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1010:	8bce                	mv	s7,s3
      state = 0;
    1012:	4981                	li	s3,0
    1014:	b3c5                	j	df4 <vprintf+0x4c>
    }
  }
}
    1016:	60e6                	ld	ra,88(sp)
    1018:	6446                	ld	s0,80(sp)
    101a:	64a6                	ld	s1,72(sp)
    101c:	6906                	ld	s2,64(sp)
    101e:	79e2                	ld	s3,56(sp)
    1020:	7a42                	ld	s4,48(sp)
    1022:	7aa2                	ld	s5,40(sp)
    1024:	7b02                	ld	s6,32(sp)
    1026:	6be2                	ld	s7,24(sp)
    1028:	6c42                	ld	s8,16(sp)
    102a:	6ca2                	ld	s9,8(sp)
    102c:	6d02                	ld	s10,0(sp)
    102e:	6125                	add	sp,sp,96
    1030:	8082                	ret

0000000000001032 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1032:	715d                	add	sp,sp,-80
    1034:	ec06                	sd	ra,24(sp)
    1036:	e822                	sd	s0,16(sp)
    1038:	1000                	add	s0,sp,32
    103a:	e010                	sd	a2,0(s0)
    103c:	e414                	sd	a3,8(s0)
    103e:	e818                	sd	a4,16(s0)
    1040:	ec1c                	sd	a5,24(s0)
    1042:	03043023          	sd	a6,32(s0)
    1046:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    104a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    104e:	8622                	mv	a2,s0
    1050:	d59ff0ef          	jal	da8 <vprintf>
}
    1054:	60e2                	ld	ra,24(sp)
    1056:	6442                	ld	s0,16(sp)
    1058:	6161                	add	sp,sp,80
    105a:	8082                	ret

000000000000105c <printf>:

void
printf(const char *fmt, ...)
{
    105c:	711d                	add	sp,sp,-96
    105e:	ec06                	sd	ra,24(sp)
    1060:	e822                	sd	s0,16(sp)
    1062:	1000                	add	s0,sp,32
    1064:	e40c                	sd	a1,8(s0)
    1066:	e810                	sd	a2,16(s0)
    1068:	ec14                	sd	a3,24(s0)
    106a:	f018                	sd	a4,32(s0)
    106c:	f41c                	sd	a5,40(s0)
    106e:	03043823          	sd	a6,48(s0)
    1072:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1076:	00840613          	add	a2,s0,8
    107a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    107e:	85aa                	mv	a1,a0
    1080:	4505                	li	a0,1
    1082:	d27ff0ef          	jal	da8 <vprintf>
}
    1086:	60e2                	ld	ra,24(sp)
    1088:	6442                	ld	s0,16(sp)
    108a:	6125                	add	sp,sp,96
    108c:	8082                	ret

000000000000108e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    108e:	1141                	add	sp,sp,-16
    1090:	e422                	sd	s0,8(sp)
    1092:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1094:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1098:	00001797          	auipc	a5,0x1
    109c:	f787b783          	ld	a5,-136(a5) # 2010 <freep>
    10a0:	a02d                	j	10ca <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10a2:	4618                	lw	a4,8(a2)
    10a4:	9f2d                	addw	a4,a4,a1
    10a6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10aa:	6398                	ld	a4,0(a5)
    10ac:	6310                	ld	a2,0(a4)
    10ae:	a83d                	j	10ec <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    10b0:	ff852703          	lw	a4,-8(a0)
    10b4:	9f31                	addw	a4,a4,a2
    10b6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    10b8:	ff053683          	ld	a3,-16(a0)
    10bc:	a091                	j	1100 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10be:	6398                	ld	a4,0(a5)
    10c0:	00e7e463          	bltu	a5,a4,10c8 <free+0x3a>
    10c4:	00e6ea63          	bltu	a3,a4,10d8 <free+0x4a>
{
    10c8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10ca:	fed7fae3          	bgeu	a5,a3,10be <free+0x30>
    10ce:	6398                	ld	a4,0(a5)
    10d0:	00e6e463          	bltu	a3,a4,10d8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10d4:	fee7eae3          	bltu	a5,a4,10c8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    10d8:	ff852583          	lw	a1,-8(a0)
    10dc:	6390                	ld	a2,0(a5)
    10de:	02059813          	sll	a6,a1,0x20
    10e2:	01c85713          	srl	a4,a6,0x1c
    10e6:	9736                	add	a4,a4,a3
    10e8:	fae60de3          	beq	a2,a4,10a2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    10ec:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    10f0:	4790                	lw	a2,8(a5)
    10f2:	02061593          	sll	a1,a2,0x20
    10f6:	01c5d713          	srl	a4,a1,0x1c
    10fa:	973e                	add	a4,a4,a5
    10fc:	fae68ae3          	beq	a3,a4,10b0 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1100:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1102:	00001717          	auipc	a4,0x1
    1106:	f0f73723          	sd	a5,-242(a4) # 2010 <freep>
}
    110a:	6422                	ld	s0,8(sp)
    110c:	0141                	add	sp,sp,16
    110e:	8082                	ret

0000000000001110 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1110:	7139                	add	sp,sp,-64
    1112:	fc06                	sd	ra,56(sp)
    1114:	f822                	sd	s0,48(sp)
    1116:	f426                	sd	s1,40(sp)
    1118:	f04a                	sd	s2,32(sp)
    111a:	ec4e                	sd	s3,24(sp)
    111c:	e852                	sd	s4,16(sp)
    111e:	e456                	sd	s5,8(sp)
    1120:	e05a                	sd	s6,0(sp)
    1122:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1124:	02051493          	sll	s1,a0,0x20
    1128:	9081                	srl	s1,s1,0x20
    112a:	04bd                	add	s1,s1,15
    112c:	8091                	srl	s1,s1,0x4
    112e:	0014899b          	addw	s3,s1,1
    1132:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    1134:	00001517          	auipc	a0,0x1
    1138:	edc53503          	ld	a0,-292(a0) # 2010 <freep>
    113c:	c515                	beqz	a0,1168 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    113e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1140:	4798                	lw	a4,8(a5)
    1142:	02977f63          	bgeu	a4,s1,1180 <malloc+0x70>
  if(nu < 4096)
    1146:	8a4e                	mv	s4,s3
    1148:	0009871b          	sext.w	a4,s3
    114c:	6685                	lui	a3,0x1
    114e:	00d77363          	bgeu	a4,a3,1154 <malloc+0x44>
    1152:	6a05                	lui	s4,0x1
    1154:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1158:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    115c:	00001917          	auipc	s2,0x1
    1160:	eb490913          	add	s2,s2,-332 # 2010 <freep>
  if(p == (char*)-1)
    1164:	5afd                	li	s5,-1
    1166:	a885                	j	11d6 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
    1168:	00001797          	auipc	a5,0x1
    116c:	f2078793          	add	a5,a5,-224 # 2088 <base>
    1170:	00001717          	auipc	a4,0x1
    1174:	eaf73023          	sd	a5,-352(a4) # 2010 <freep>
    1178:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    117a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    117e:	b7e1                	j	1146 <malloc+0x36>
      if(p->s.size == nunits)
    1180:	02e48c63          	beq	s1,a4,11b8 <malloc+0xa8>
        p->s.size -= nunits;
    1184:	4137073b          	subw	a4,a4,s3
    1188:	c798                	sw	a4,8(a5)
        p += p->s.size;
    118a:	02071693          	sll	a3,a4,0x20
    118e:	01c6d713          	srl	a4,a3,0x1c
    1192:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1194:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1198:	00001717          	auipc	a4,0x1
    119c:	e6a73c23          	sd	a0,-392(a4) # 2010 <freep>
      return (void*)(p + 1);
    11a0:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    11a4:	70e2                	ld	ra,56(sp)
    11a6:	7442                	ld	s0,48(sp)
    11a8:	74a2                	ld	s1,40(sp)
    11aa:	7902                	ld	s2,32(sp)
    11ac:	69e2                	ld	s3,24(sp)
    11ae:	6a42                	ld	s4,16(sp)
    11b0:	6aa2                	ld	s5,8(sp)
    11b2:	6b02                	ld	s6,0(sp)
    11b4:	6121                	add	sp,sp,64
    11b6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    11b8:	6398                	ld	a4,0(a5)
    11ba:	e118                	sd	a4,0(a0)
    11bc:	bff1                	j	1198 <malloc+0x88>
  hp->s.size = nu;
    11be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11c2:	0541                	add	a0,a0,16
    11c4:	ecbff0ef          	jal	108e <free>
  return freep;
    11c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    11cc:	dd61                	beqz	a0,11a4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11d0:	4798                	lw	a4,8(a5)
    11d2:	fa9777e3          	bgeu	a4,s1,1180 <malloc+0x70>
    if(p == freep)
    11d6:	00093703          	ld	a4,0(s2)
    11da:	853e                	mv	a0,a5
    11dc:	fef719e3          	bne	a4,a5,11ce <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
    11e0:	8552                	mv	a0,s4
    11e2:	aa9ff0ef          	jal	c8a <sbrk>
  if(p == (char*)-1)
    11e6:	fd551ce3          	bne	a0,s5,11be <malloc+0xae>
        return 0;
    11ea:	4501                	li	a0,0
    11ec:	bf65                	j	11a4 <malloc+0x94>
