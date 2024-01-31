ca65 V2.19 - Git 7979f8a41
Main file   : main.s
Current file: main.s

000000r 1               ; *********************************************************************
000000r 1               ;
000000r 1               ;  MINT Minimal Interpreter
000000r 1               ;
000000r 1               ;  GNU GENERAL PUBLIC LICENSE              Version 3, 29 June 2007
000000r 1               ;
000000r 1               ;  see the LICENSE file in this repo for more information
000000r 1               ;
000000r 1               ;  original for the Z80, by Ken Boak, John Hardy and Craig Jones.
000000r 1               ;
000000r 1               ;  adapted for the 6502, by Alvaro G. S. Barcellos, 10/2023
000000r 1               ;  (some code from 6502.org forum and FIG_Forth)
000000r 1               ;  (some code from https://www.nesdev.org/wiki/Programming_guide)
000000r 1               
000000r 1               ;  star(tm) date 10/10/2023
000000r 1               ; *********************************************************************
000000r 1               
000000r 1                   DSIZE       = $80
000000r 1                   RSIZE       = $80
000000r 1               
000000r 1                   TIBSIZE     = $100
000000r 1                   TRUE        = 1
000000r 1                   FALSE       = 0
000000r 1               
000000r 1                   NUMGRPS     = 5
000000r 1                   GRPSIZE     = $40
000000r 1               
000000r 1               ;----------------------------------------------------------------------
000000r 1               ; notes 6502 version:
000000r 1               ;
000000r 1               ;   code is for RAM use.
000000r 1               ;
000000r 1               ;   caller must save a, x, y and
000000r 1               ;   reserve 32 (?) words at hardware stack
000000r 1               ;
000000r 1               ;   stacks are from absolute address.
000000r 1               ;   data stack indexed by x
000000r 1               ;   return stack indexed by y
000000r 1               ;   terminal input buffer
000000r 1               ;   all just 128 cells deep and round-robin
000000r 1               ;   a cell is 16-bit
000000r 1               ;   16-bit jump table
000000r 1               ;   extense use of post-indexed indirect addressing
000000r 1               ;
000000r 1               ;   alt-a used for vS0, start of data stack
000000r 1               ;   alt-f used for vR0, start of return stack ****
000000r 1               ;   alt-g reserved, copycat of references ****
000000r 1               ;
000000r 1               ;   all rotines must end with:
000000r 1               ;   jmp next_ or jmp drop_ or a jmp / branch
000000r 1               ;----------------------------------------------------------------------
000000r 1               
000000r 1               ;----------------------------------------------------------------------
000000r 1               ; page 0, reserved cells
000000r 1                   zpage = $f0
000000r 1               
000000r 1               ; copycat
000000r 1                   yp = zpage + $0  ; y index, return stack pointer,
000000r 1                   xp = zpage + $1  ; x index, parameter stack pointer,
000000r 1                   ap = zpage + $2  ; accumulator
000000r 1                   ns = zpage + $3  ; nests
000000r 1               
000000r 1               ; pseudos
000000r 1                   tos = zpage + $4  ; tos  register
000000r 1                   nos = zpage + $6  ; nos  register
000000r 1                   wrk = zpage + $8  ; work register
000000r 1                   tmp = zpage + $a  ; work register
000000r 1               
000000r 1               ; holds
000000r 1                   nxt = zpage + $c  ; next pointer
000000r 1                   ips = zpage + $e  ; instruction pointer
000000r 1               
000000r 1               ; all in RAM, better put tables at end of code ?
000000r 1               
000000r 1               ;    start = $200
000000r 1               ;    tib = start  ; terminal input buffer, upwards
000000r 1               ;    spz = start + $1FF  ; absolute data stack, backwards
000000r 1               ;    rpz = start + $2FF  ; absolute parameter stack, backwards
000000r 1               ;
000000r 1               ;    vars = start + $300  ;   26 words
000000r 1               ;    vsys = start + $336  ;   26 words
000000r 1               ;    defs = start + $36C  ;   26 words
000000r 1               ;    tmps = start + $3D8  ;   14 words
000000r 1               ;
000000r 1               ;    free = start + $400  ; free ram start
000000r 1               
000000r 1               ;----------------------------------------------------------------------
000000r 1               .segment "VECTORS"
000000r 1               
000000r 1  rr rr        .word init
000002r 1  rr rr        .word init
000004r 1  rr rr        .word init
000006r 1               
000006r 1               ;----------------------------------------------------------------------
000006r 1               .segment "CODE"
000000r 1               
000000r 1               VOID:
000000r 1               
000000r 1  00 00 00 00      .res $100, $00
000004r 1  00 00 00 00  
000008r 1  00 00 00 00  
000100r 1               spz:
000100r 1               
000100r 1  00 00 00 00      .res $100, $00
000104r 1  00 00 00 00  
000108r 1  00 00 00 00  
000200r 1               rpz:
000200r 1               
000200r 1               tib:
000200r 1  00 00 00 00      .res $100, $00
000204r 1  00 00 00 00  
000208r 1  00 00 00 00  
000300r 1               
000300r 1               vsys:
000300r 1  00 00 00 00      .res $36, $00
000304r 1  00 00 00 00  
000308r 1  00 00 00 00  
000336r 1               
000336r 1               vars:
000336r 1  00 00 00 00      .res $36, $00
00033Ar 1  00 00 00 00  
00033Er 1  00 00 00 00  
00036Cr 1               
00036Cr 1               defs:
00036Cr 1  00 00 00 00      .res $36, $00
000370r 1  00 00 00 00  
000374r 1  00 00 00 00  
0003A2r 1               
0003A2r 1               vtmp:
0003A2r 1  00 00 00 00      .res $5E, $00
0003A6r 1  00 00 00 00  
0003AAr 1  00 00 00 00  
000400r 1               
000400r 1               ;----------------------------------------------------------------------
000400r 1               .segment "ONCE"
000000r 1               
000000r 1               ; **********************************************************************
000000r 1               ;
000000r 1               ; (not yet) routines are ordered to occupy pages of 256 bytes
000000r 1               ;
000000r 1               ; **********************************************************************
000000r 1               
000000r 1               putchar:
000000r 1  18               clc
000001r 1  60               rts
000002r 1               
000002r 1               getchar:
000002r 1  18               clc
000003r 1  60               rts
000004r 1               
000004r 1               hitchar:
000004r 1  18               clc
000005r 1  60               rts
000006r 1               
000006r 1               ;----------------------------------------------------------------------
000006r 1               key_:
000006r 1  20 rr rr         jsr getchar
000009r 1  85 F4            sta tos + 0
00000Br 1  A9 00            lda #0
00000Dr 1  85 F5            sta tos + 1
00000Fr 1  20 rr rr         jsr spush_
000012r 1  4C rr rr         jmp next_
000015r 1               
000015r 1               ;----------------------------------------------------------------------
000015r 1               emit_:
000015r 1  20 rr rr         jsr spull_
000018r 1  A5 F4            lda tos + 0
00001Ar 1  20 rr rr         jsr putchar
00001Dr 1  4C rr rr         jmp next_
000020r 1               
000020r 1               ;----------------------------------------------------------------------
000020r 1               aNop_:
000020r 1               nop_:
000020r 1  18               clc
000021r 1  4C rr rr         jmp next_
000024r 1               
000024r 1               ;----------------------------------------------------------------------
000024r 1               ; increase instruction pointer
000024r 1               incps_:
000024r 1  E6 FE            inc ips + 0
000026r 1  D0 02            bne @noeq
000028r 1  E6 FF            inc ips + 1
00002Ar 1               @noeq:
00002Ar 1  60               rts
00002Br 1               
00002Br 1               ;----------------------------------------------------------------------
00002Br 1               ; decrease instruction pointer
00002Br 1               decps_:
00002Br 1  A5 FE            lda ips + 0
00002Dr 1  D0 02            bne @noeq
00002Fr 1  C6 FF            dec ips + 1
000031r 1               @noeq:
000031r 1  C6 FE            dec ips + 0
000033r 1  60               rts
000034r 1               
000034r 1               ;----------------------------------------------------------------------
000034r 1               ; load char at instruction pointer
000034r 1               ldaps_:
000034r 1  A0 00            ldy #$00
000036r 1  B1 FE            lda (ips), y
000038r 1  60               rts
000039r 1               
000039r 1               ;----------------------------------------------------------------------
000039r 1               pushps_:
000039r 1               ; push ps into RS
000039r 1  A4 F0            ldy yp
00003Br 1  88               dey
00003Cr 1  88               dey
00003Dr 1  A5 FE            lda ips + 0
00003Fr 1  99 rr rr         sta rpz + 0, y
000042r 1  A5 FF            lda ips + 1
000044r 1  99 rr rr         sta rpz + 1, y
000047r 1  84 F0            sty yp
000049r 1  60               rts
00004Ar 1               
00004Ar 1               ;----------------------------------------------------------------------
00004Ar 1               pullps_:
00004Ar 1               ; pull ps from RS
00004Ar 1  A4 F0            ldy yp
00004Cr 1  B9 rr rr         lda rpz + 0, y
00004Fr 1  85 FE            sta ips + 0
000051r 1  B9 rr rr         lda rpz + 1, y
000054r 1  85 FF            sta ips + 1
000056r 1  C8               iny
000057r 1  C8               iny
000058r 1  84 F0            sty yp
00005Ar 1  60               rts
00005Br 1               
00005Br 1               ;----------------------------------------------------------------------
00005Br 1               ; push tos into return stack
00005Br 1               rpush_:
00005Br 1  A4 F0            ldy yp
00005Dr 1  88               dey
00005Er 1  88               dey
00005Fr 1  A5 F4            lda tos + 0
000061r 1  99 rr rr         sta rpz + 0, y
000064r 1  A5 F5            lda tos + 1
000066r 1  B9 rr rr         lda rpz + 1, y
000069r 1  84 F0            sty yp
00006Br 1  60               rts
00006Cr 1               
00006Cr 1               ;----------------------------------------------------------------------
00006Cr 1               ; push tos from return stack
00006Cr 1               rpull_:
00006Cr 1  A4 F0            ldy yp
00006Er 1  B9 rr rr         lda rpz + 0, y
000071r 1  85 F4            sta tos + 0
000073r 1  B9 rr rr         lda rpz + 1, y
000076r 1  85 F5            sta tos + 1
000078r 1  C8               iny
000079r 1  C8               iny
00007Ar 1  84 F0            sty yp
00007Cr 1  60               rts
00007Dr 1               
00007Dr 1               ;----------------------------------------------------------------------
00007Dr 1               ; push tos into stack
00007Dr 1               spush_:
00007Dr 1                   ; ldx xp
00007Dr 1  CA               dex
00007Er 1  CA               dex
00007Fr 1  A5 F4            lda tos + 0
000081r 1  9D rr rr         sta spz + 0, x
000084r 1  A5 F5            lda tos + 1
000086r 1  9D rr rr         sta spz + 1, x
000089r 1                   ; stx xp
000089r 1  60               rts
00008Ar 1               
00008Ar 1               ;----------------------------------------------------------------------
00008Ar 1               ; pull tos from stack
00008Ar 1               spull_:
00008Ar 1                   ; ldx xp
00008Ar 1  BD rr rr         lda spz + 0, x
00008Dr 1  85 F4            sta tos + 0
00008Fr 1  BD rr rr         lda spz + 1, x
000092r 1  85 F5            sta tos + 1
000094r 1  E8               inx
000095r 1  E8               inx
000096r 1                   ; stx xp
000096r 1  60               rts
000097r 1               
000097r 1               ;----------------------------------------------------------------------
000097r 1               ; take two from stack
000097r 1               take2_:
000097r 1                   ; ldx xp
000097r 1  BD rr rr         lda spz + 0, x
00009Ar 1  85 F4            sta tos + 0
00009Cr 1  BD rr rr         lda spz + 1, x
00009Fr 1  85 F5            sta tos + 1
0000A1r 1  BD rr rr         lda spz + 2, x
0000A4r 1  85 F8            sta nos + 2
0000A6r 1  BD rr rr         lda spz + 3, x
0000A9r 1  85 F9            sta nos + 3
0000ABr 1  E8               inx
0000ACr 1  E8               inx
0000ADr 1  E8               inx
0000AEr 1  E8               inx
0000AFr 1                   ; stx xp
0000AFr 1  60               rts
0000B0r 1               
0000B0r 1               ;----------------------------------------------------------------------
0000B0r 1               ; NEGate the value on top of stack (2's complement)
0000B0r 1               neg_:
0000B0r 1                   ; ldx xp
0000B0r 1  38               sec
0000B1r 1  A9 00            lda #0
0000B3r 1  FD rr rr         sbc spz + 0, x
0000B6r 1  9D rr rr         sta spz + 0, x
0000B9r 1  38               sec
0000BAr 1  A9 00            lda #0
0000BCr 1  FD rr rr         sbc spz + 1, x
0000BFr 1  9D rr rr         sta spz + 1, x
0000C2r 1                   ; stx xp
0000C2r 1  4C rr rr         jmp next_
0000C5r 1               
0000C5r 1               ;----------------------------------------------------------------------
0000C5r 1               ; Bitwise INVert the top member of the stack (1's complement)
0000C5r 1               inv_:
0000C5r 1                   ; ldx xp
0000C5r 1  A9 FF            lda #$FF
0000C7r 1  5D rr rr         eor spz + 0, x
0000CAr 1  9D rr rr         sta spz + 0, x
0000CDr 1  A9 FF            lda #$FF
0000CFr 1  5D rr rr         eor spz + 1, x
0000D2r 1  9D rr rr         sta spz + 1, x
0000D5r 1                   ; stx xp
0000D5r 1  4C rr rr         jmp next_
0000D8r 1               
0000D8r 1               ;----------------------------------------------------------------------
0000D8r 1               ; Duplicate the top member of the stack
0000D8r 1               ; a b c -- a b c c
0000D8r 1               dup_:
0000D8r 1                   ; ldx xp
0000D8r 1  CA               dex
0000D9r 1  CA               dex
0000DAr 1  BD rr rr         lda spz + 2, x
0000DDr 1  9D rr rr         sta spz + 0, x
0000E0r 1  BD rr rr         lda spz + 3, x
0000E3r 1  9D rr rr         sta spz + 1, x
0000E6r 1                   ; stx xp
0000E6r 1  4C rr rr         jmp next_
0000E9r 1               
0000E9r 1               ;----------------------------------------------------------------------
0000E9r 1               ; Duplicate 2nd element of the stack
0000E9r 1               ; a b c -- a b c b
0000E9r 1               over_:
0000E9r 1                   ; ldx xp
0000E9r 1  CA               dex
0000EAr 1  CA               dex
0000EBr 1  BD rr rr         lda spz + 4, x
0000EEr 1  9D rr rr         sta spz + 0, x
0000F1r 1  BD rr rr         lda spz + 5, x
0000F4r 1  9D rr rr         sta spz + 1, x
0000F7r 1                   ; stx xp
0000F7r 1  4C rr rr         jmp next_
0000FAr 1               
0000FAr 1               ;----------------------------------------------------------------------
0000FAr 1               ; Rotate 3 elements at stack
0000FAr 1               ; a b c -- b c a
0000FAr 1               rot_:
0000FAr 1                   ; ldx xp
0000FAr 1                   ; c -> w
0000FAr 1  BD rr rr         lda spz + 0, x
0000FDr 1  85 F4            sta tos + 0
0000FFr 1  BD rr rr         lda spz + 0, x
000102r 1  85 F5            sta tos + 1
000104r 1                   ; b -> u
000104r 1  BD rr rr         lda spz + 2, x
000107r 1  85 F6            sta nos + 0
000109r 1  BD rr rr         lda spz + 3, x
00010Cr 1  85 F7            sta nos + 1
00010Er 1                   ; a -> c
00010Er 1  BD rr rr         lda spz + 4, x
000111r 1  9D rr rr         sta spz + 0, x
000114r 1  BD rr rr         lda spz + 5, x
000117r 1  9D rr rr         sta spz + 1, x
00011Ar 1                   ; u -> a
00011Ar 1  A5 F6            lda nos + 0
00011Cr 1  9D rr rr         sta spz + 4, x
00011Fr 1  A5 F7            lda nos + 1
000121r 1  9D rr rr         sta spz + 5, x
000124r 1                   ; w -> b
000124r 1  A5 F4            lda tos + 0
000126r 1  9D rr rr         sta spz + 2, x
000129r 1  A5 F5            lda tos + 1
00012Br 1  9D rr rr         sta spz + 3, x
00012Er 1                   ; stx xp
00012Er 1  4C rr rr         jmp next_
000131r 1               
000131r 1               ;----------------------------------------------------------------------
000131r 1               ; Swap 2nd and 1st elements of the stack
000131r 1               ; a b c -- a c b
000131r 1               swap_:
000131r 1                   ; ldx xp
000131r 1                   ; b -> w
000131r 1  BD rr rr         lda spz + 2, x
000134r 1  85 F8            sta wrk + 0
000136r 1  BD rr rr         lda spz + 3, x
000139r 1  85 F9            sta wrk + 1
00013Br 1                   ; a -> b
00013Br 1  BD rr rr         lda spz + 0, x
00013Er 1  9D rr rr         sta spz + 2, x
000141r 1  BD rr rr         lda spz + 1, x
000144r 1  9D rr rr         sta spz + 3, x
000147r 1                   ; w -> a
000147r 1  A5 F8            lda wrk + 0
000149r 1  9D rr rr         sta spz + 0, x
00014Cr 1  A5 F9            lda wrk + 1
00014Er 1  9D rr rr         sta spz + 1, x
000151r 1                   ; stx xp
000151r 1  4C rr rr         jmp next_
000154r 1               
000154r 1               ;----------------------------------------------------------------------
000154r 1               ;  Left shift { is multply by 2
000154r 1               shl_:
000154r 1                   ; ldx xp
000154r 1  1E rr rr         asl spz + 0, x
000157r 1  3E rr rr         rol spz + 1, x
00015Ar 1                   ; stx xp
00015Ar 1  4C rr rr         jmp next_
00015Dr 1               
00015Dr 1               ;----------------------------------------------------------------------
00015Dr 1               ;  Right shift } is a divide by 2
00015Dr 1               shr_:
00015Dr 1                   ; ldx xp
00015Dr 1  5E rr rr         lsr spz + 0, x
000160r 1  7E rr rr         ror spz + 1, x
000163r 1                   ; stx xp
000163r 1  4C rr rr         jmp next_
000166r 1               
000166r 1               ;----------------------------------------------------------------------
000166r 1               ; Drop the top member of the stack
000166r 1               ; a b c -- a b
000166r 1               drop_:
000166r 1                   ; ldx xp
000166r 1  E8               inx
000167r 1  E8               inx
000168r 1                   ; stx xp
000168r 1  4C rr rr         jmp next_
00016Br 1               
00016Br 1               ;----------------------------------------------------------------------
00016Br 1               ;  Bitwise AND the top 2 elements of the stack
00016Br 1               and_:
00016Br 1                   ; ldx xp
00016Br 1  BD rr rr         lda spz + 2, x
00016Er 1  3D rr rr         and spz + 0, x
000171r 1  9D rr rr         sta spz + 2, x
000174r 1  BD rr rr         lda spz + 3, x
000177r 1  3D rr rr         and spz + 1, x
00017Ar 1  9D rr rr         sta spz + 3, x
00017Dr 1                   ; stx xp
00017Dr 1  4C rr rr         jmp drop_
000180r 1               
000180r 1               ;----------------------------------------------------------------------
000180r 1               ;  Bitwise OR the top 2 elements of the stack
000180r 1               or_:
000180r 1                   ; ldx xp
000180r 1  BD rr rr         lda spz + 2, x
000183r 1  1D rr rr         ora spz + 0, x
000186r 1  9D rr rr         sta spz + 2, x
000189r 1  BD rr rr         lda spz + 3, x
00018Cr 1  1D rr rr         ora spz + 1, x
00018Fr 1  9D rr rr         sta spz + 3, x
000192r 1                   ; stx xp
000192r 1  4C rr rr         jmp drop_
000195r 1               
000195r 1               ;----------------------------------------------------------------------
000195r 1               ;  Bitwise XOR the top 2 elements of the stack
000195r 1               xor_:
000195r 1                   ; ldx xp
000195r 1  BD rr rr         lda spz + 2, x
000198r 1  5D rr rr         eor spz + 0, x
00019Br 1  9D rr rr         sta spz + 2, x
00019Er 1  BD rr rr         lda spz + 3, x
0001A1r 1  5D rr rr         eor spz + 1, x
0001A4r 1  9D rr rr         sta spz + 3, x
0001A7r 1                   ; stx xp
0001A7r 1  4C rr rr         jmp drop_
0001AAr 1               
0001AAr 1               ;----------------------------------------------------------------------
0001AAr 1               ; Add the top 2 members of the stack
0001AAr 1               ; a b c -- a (b+c)
0001AAr 1               add_:
0001AAr 1                   ; ldx xp
0001AAr 1  18               clc
0001ABr 1  BD rr rr         lda spz + 2, x
0001AEr 1  7D rr rr         adc spz + 0, x
0001B1r 1  9D rr rr         sta spz + 2, x
0001B4r 1  BD rr rr         lda spz + 3, x
0001B7r 1  7D rr rr         adc spz + 1, x
0001BAr 1  9D rr rr         sta spz + 3, x
0001BDr 1                   ; stx xp
0001BDr 1  4C rr rr         jmp drop_
0001C0r 1               
0001C0r 1               ;----------------------------------------------------------------------
0001C0r 1               ; Subtract the top 2 members of the stack
0001C0r 1               ; a b c -- a (b-c)
0001C0r 1               sub_:
0001C0r 1                   ; ldx xp
0001C0r 1  38               sec
0001C1r 1  BD rr rr         lda spz + 2, x
0001C4r 1  FD rr rr         sbc spz + 0, x
0001C7r 1  9D rr rr         sta spz + 2, x
0001CAr 1  BD rr rr         lda spz + 3, x
0001CDr 1  FD rr rr         sbc spz + 1, x
0001D0r 1  9D rr rr         sta spz + 3, x
0001D3r 1                   ; stx xp
0001D3r 1  4C rr rr         jmp drop_
0001D6r 1               
0001D6r 1               ;----------------------------------------------------------------------
0001D6r 1               opin:
0001D6r 1  A4 F0            ldy yp
0001D8r 1                   ; pseudo tos
0001D8r 1  B9 rr rr         lda spz + 0, y
0001DBr 1  85 F8            sta wrk + 0
0001DDr 1  B9 rr rr         lda spz + 1, y
0001E0r 1  85 F9            sta wrk + 1
0001E2r 1                   ; pseudo nos
0001E2r 1  B9 rr rr         lda spz + 2, y
0001E5r 1  85 FA            sta tmp + 0
0001E7r 1  B9 rr rr         lda spz + 3, y
0001EAr 1  85 FB            sta tmp + 1
0001ECr 1                   ; clear results
0001ECr 1  A9 00            lda #0
0001EEr 1  85 F4            sta tos + 0
0001F0r 1  85 F5            sta tos + 1
0001F2r 1  85 F6            sta nos + 0
0001F4r 1  85 F6            sta nos + 0
0001F6r 1  60               rts
0001F7r 1               
0001F7r 1               ;----------------------------------------------------------------------
0001F7r 1               opout:
0001F7r 1                   ; copy results
0001F7r 1  A4 F0            ldy yp
0001F9r 1  A5 F6            lda nos + 0
0001FBr 1  99 rr rr         sta spz + 0, y
0001FEr 1  A5 F7            lda nos + 1
000200r 1  99 rr rr         sta spz + 1, y
000203r 1  A5 F4            lda tos + 0
000205r 1  99 rr rr         sta spz + 2, y
000208r 1  A5 F5            lda tos + 1
00020Ar 1  99 rr rr         sta spz + 3, y
00020Dr 1  60               rts
00020Er 1               
00020Er 1               ;----------------------------------------------------------------------
00020Er 1               ; Divide the top 2 members of the stack
00020Er 1               ; divisor dividend -- quontient remainder
00020Er 1               div_:
00020Er 1  20 rr rr         jsr divd
000211r 1  4C rr rr         jmp next_
000214r 1               
000214r 1               divd:
000214r 1  20 rr rr         jsr opin
000217r 1                   ; countdown
000217r 1  A0 10            ldy #16
000219r 1               @loop:
000219r 1  06 FA            asl tmp + 0
00021Br 1  26 FB            rol tmp + 1
00021Dr 1  26 F4            rol tos + 0
00021Fr 1  26 F5            rol tos + 1
000221r 1  38               sec
000222r 1  A5 F6            lda nos + 0
000224r 1  E5 F4            sbc tos + 0
000226r 1  85 F4            sta tos + 0
000228r 1  A5 F7            lda nos + 1
00022Ar 1  E5 F5            sbc tos + 1
00022Cr 1  85 F5            sta tos + 1
00022Er 1  90 0D            bcc @iscc
000230r 1  18               clc
000231r 1  A5 F6            lda nos + 0
000233r 1  65 F4            adc tos + 0
000235r 1  85 F4            sta tos + 0
000237r 1  A5 F7            lda nos + 1
000239r 1  65 F5            adc tos + 1
00023Br 1  85 F5            sta tos + 1
00023Dr 1               @iscc:
00023Dr 1                   ; countdown
00023Dr 1  88               dey
00023Er 1  D0 D9            bne @loop
000240r 1  20 rr rr         jsr opout
000243r 1  4C rr rr         jmp next_
000246r 1               
000246r 1               ;----------------------------------------------------------------------
000246r 1               ; 16-bit multiply 16x16, 32 result
000246r 1               ; multiplier multiplicand -- resultLSW resultMSW
000246r 1               ;
000246r 1               mul_:
000246r 1  20 rr rr         jsr mult
000249r 1  4C rr rr         jmp next_
00024Cr 1               
00024Cr 1               mult:
00024Cr 1  20 rr rr         jsr opin
00024Fr 1                   ; countdown
00024Fr 1  A0 10            ldy #16
000251r 1               @loop:
000251r 1  06 F4            asl tos + 0
000253r 1  26 F5            rol tos + 1
000255r 1  26 F6            rol nos + 0
000257r 1  26 F6            rol nos + 0
000259r 1  90 13            bcc @iscc
00025Br 1  18               clc
00025Cr 1  A5 FA            lda tmp + 0
00025Er 1  65 F4            adc tos + 0
000260r 1  85 F4            sta tos + 0
000262r 1  A5 FB            lda tmp + 1
000264r 1  65 F5            adc tos + 1
000266r 1  85 F5            sta tos + 1
000268r 1  A9 00            lda #0
00026Ar 1  65 F6            adc nos + 0
00026Cr 1  85 F6            sta nos + 0
00026Er 1               @iscc:
00026Er 1                   ; countdown
00026Er 1  88               dey
00026Fr 1  D0 E0            bne @loop
000271r 1  20 rr rr         jsr opout
000274r 1  4C rr rr         jmp next_
000277r 1               
000277r 1               ;----------------------------------------------------------------------
000277r 1               ; \+    a b c -- a ; [c]+b  ; increment variable at c by b
000277r 1               incr_:
000277r 1  20 rr rr         jsr take2_
00027Ar 1  18               clc
00027Br 1  A0 00            ldy #$00
00027Dr 1  B1 F4            lda (tos), y
00027Fr 1  65 F6            adc nos + 0
000281r 1  91 F4            sta (tos), y
000283r 1  C8               iny
000284r 1  B1 F4            lda (tos), y
000286r 1  65 F7            adc nos + 1
000288r 1  91 F4            sta (tos), y
00028Ar 1  4C rr rr         jmp next_
00028Dr 1               
00028Dr 1               ;----------------------------------------------------------------------
00028Dr 1               ; \-    a b c -- a ; [c]-b  ; decrement variable at c by b
00028Dr 1               decr_:
00028Dr 1  20 rr rr         jsr take2_
000290r 1  38               sec
000291r 1  A0 00            ldy #$00
000293r 1  B1 F4            lda (tos), y
000295r 1  E5 F6            sbc nos + 0
000297r 1  91 F4            sta (tos), y
000299r 1  C8               iny
00029Ar 1  B1 F4            lda (tos), y
00029Cr 1  E5 F7            sbc nos + 1
00029Er 1  91 F4            sta (tos), y
0002A0r 1  4C rr rr         jmp next_
0002A3r 1               
0002A3r 1               ;----------------------------------------------------------------------
0002A3r 1               ; false
0002A3r 1               false2:
0002A3r 1                   ; ldx xp
0002A3r 1  A9 00            lda #$00
0002A5r 1  9D rr rr         sta spz + 2, x
0002A8r 1  9D rr rr         sta spz + 3, x
0002ABr 1                   ; stx xp
0002ABr 1  4C rr rr         jmp drop_
0002AEr 1               
0002AEr 1               ;----------------------------------------------------------------------
0002AEr 1               ; true
0002AEr 1               true2:
0002AEr 1                   ; ldx xp
0002AEr 1  A9 01            lda #$01
0002B0r 1  9D rr rr         sta spz + 2, x
0002B3r 1  A9 00            lda #$00
0002B5r 1  9D rr rr         sta spz + 3, x
0002B8r 1                   ; stx xp
0002B8r 1  4C rr rr         jmp drop_
0002BBr 1               
0002BBr 1               ;----------------------------------------------------------------------
0002BBr 1               ; subtract for compare
0002BBr 1               cmp_:
0002BBr 1                   ; ldx xp
0002BBr 1  38               sec
0002BCr 1  BD rr rr         lda spz + 2, x
0002BFr 1  FD rr rr         sbc spz + 0, x
0002C2r 1  BD rr rr         lda spz + 3, x
0002C5r 1  FD rr rr         sbc spz + 1, x
0002C8r 1                   ; stx xp
0002C8r 1  60               rts
0002C9r 1               
0002C9r 1               ;----------------------------------------------------------------------
0002C9r 1               ; signed equal than
0002C9r 1               eq_:
0002C9r 1  20 rr rr         jsr cmp_
0002CCr 1  D0 D5            bne false2
0002CEr 1  F0 DE            beq true2
0002D0r 1               
0002D0r 1               ;----------------------------------------------------------------------
0002D0r 1               ; signed less than
0002D0r 1               lt_:
0002D0r 1  20 rr rr         jsr cmp_
0002D3r 1  30 D9            bmi true2
0002D5r 1  10 CC            bpl false2
0002D7r 1               
0002D7r 1               ;----------------------------------------------------------------------
0002D7r 1               ; signed greather than
0002D7r 1               ; must be in that order, bpl is non negative flag
0002D7r 1               gt_:
0002D7r 1  20 rr rr         jsr cmp_
0002DAr 1  30 C7            bmi false2
0002DCr 1  F0 C5            beq false2
0002DEr 1  10 CE            bpl true2
0002E0r 1               
0002E0r 1               ;----------------------------------------------------------------------
0002E0r 1               ; fetch the value from the address placed on the top of the stack
0002E0r 1               ; a b c - a b (c)
0002E0r 1               ; fetch a byte
0002E0r 1               cFetch_:
0002E0r 1  A9 00            lda #$00
0002E2r 1  85 F5            sta tos + 1
0002E4r 1  38               sec
0002E5r 1  4C rr rr         jmp isfetch_
0002E8r 1               
0002E8r 1               ;----------------------------------------------------------------------
0002E8r 1               ; fetch a word
0002E8r 1               fetch_:
0002E8r 1  18               clc
0002E9r 1  4C rr rr         jmp isfetch_
0002ECr 1               
0002ECr 1               ;----------------------------------------------------------------------
0002ECr 1               isfetch_:
0002ECr 1                   ; ldx xp
0002ECr 1                   ; load the reference
0002ECr 1  BD rr rr         lda spz + 0, x
0002EFr 1  85 F6            sta nos + 0
0002F1r 1  BD rr rr         lda spz + 1, x
0002F4r 1  85 F7            sta nos + 1
0002F6r 1                   ; then the value
0002F6r 1  A0 00            ldy #$00
0002F8r 1  B1 F6            lda (nos), y
0002FAr 1  85 F4            sta tos + 0
0002FCr 1  B0 05            bcs @cset
0002FEr 1  C8               iny
0002FFr 1  B1 F6            lda (nos), y
000301r 1  85 F5            sta tos + 1
000303r 1               @cset:
000303r 1                   ; save the value
000303r 1  A5 F4            lda tos + 0
000305r 1  9D rr rr         sta spz + 0, x
000308r 1  A5 F5            lda tos + 1
00030Ar 1  9D rr rr         sta spz + 1, x
00030Dr 1                   ; next
00030Dr 1                   ; stx xp
00030Dr 1  4C rr rr         jmp next_
000310r 1               
000310r 1               ;----------------------------------------------------------------------
000310r 1               ; store the value into the address placed on the top of the stack
000310r 1               ; a b c -- a
000310r 1               ; store a byte
000310r 1               cStore_:
000310r 1  38               sec
000311r 1  4C rr rr         jmp isstore_
000314r 1               
000314r 1               ;----------------------------------------------------------------------
000314r 1               ; store a word
000314r 1               store_:
000314r 1  18               clc
000315r 1  4C rr rr         jmp isstore_
000318r 1               
000318r 1               ;----------------------------------------------------------------------
000318r 1               isstore_:
000318r 1  20 rr rr         jsr take2_
00031Br 1                   ; copy the value
00031Br 1  A0 00            ldy #$00
00031Dr 1  A5 F6            lda nos + 0
00031Fr 1  91 F4            sta (tos), y
000321r 1  B0 05            bcs @cset
000323r 1  C8               iny
000324r 1  A5 F7            lda nos + 1
000326r 1  91 F4            sta (tos), y
000328r 1                   ; next
000328r 1               @cset:
000328r 1                   ; stx xp
000328r 1  4C rr rr         jmp next_
00032Br 1               
00032Br 1               ;----------------------------------------------------------------------
00032Br 1               ; hook for debug
00032Br 1               exec_:
00032Br 1  20 rr rr         jsr spull_
00032Er 1  6C F4 00         jmp (tos)
000331r 1               
000331r 1               ;----------------------------------------------------------------------
000331r 1               _empty_:
000331r 1  20 rr rr         jsr printStr
000334r 1  56 4F 49 44      .asciiz  "void define\r\n"
000338r 1  20 44 45 46  
00033Cr 1  49 4E 45 BF  
000344r 1  4C rr rr         jmp next_
000347r 1               
000347r 1               ;----------------------------------------------------------------------
000347r 1               ; puts a string, limit 255 chars
000347r 1               str_:
000347r 1  A0 00            ldy #$00
000349r 1               @loop:
000349r 1  C8               iny
00034Ar 1  B1 FE            lda (ips), y
00034Cr 1  C9 AD            cmp #'`'              ; ` is the string terminator
00034Er 1  F0 06            beq @ends
000350r 1  20 rr rr         jsr putchar
000353r 1  18               clc
000354r 1  90 F3            bcc @loop
000356r 1                   ; error in putchar
000356r 1               @ends:
000356r 1  4C rr rr         jmp next_
000359r 1               
000359r 1               ;----------------------------------------------------------------------
000359r 1               macro:
000359r 1  0A               asl
00035Ar 1  85 F2            sta ap
00035Cr 1  A9 rr            lda #<ctlcodes
00035Er 1  85 F4            sta tos + 0
000360r 1  A9 rr            lda #>ctlcodes
000362r 1  85 F5            sta tos + 1
000364r 1  A5 F2            lda ap
000366r 1  18               clc
000367r 1  65 F4            adc tos + 0
000369r 1  85 F4            sta tos + 0
00036Br 1  65 F5            adc tos + 1
00036Dr 1  85 F5            sta tos + 1
00036Fr 1  20 rr rr         jsr spush_
000372r 1  20 rr rr         jsr enter_
000375r 1  BF BF C7 00      .asciiz "\\G"
000379r 1  4C rr rr         jmp interpret2
00037Cr 1               
00037Cr 1               ;----------------------------------------------------------------------
00037Cr 1               interpret:
00037Cr 1  20 rr rr         jsr enter_
00037Fr 1  BF BF CE AD      .asciiz "\\N`> `"
000383r 1  3E 20 AD 00  
000387r 1                   ; fall throught
000387r 1               
000387r 1               ; used by tests
000387r 1               interpret1:
000387r 1  A9 00            lda #$00
000389r 1  8D rr rr         sta vTIBPtr + 0
00038Cr 1  8D rr rr         sta vTIBPtr + 1
00038Fr 1               
00038Fr 1               interpret2:
00038Fr 1  A9 00            lda #$00
000391r 1  85 F3            sta ns
000393r 1  A8               tay
000394r 1  F0 07            beq @cast
000396r 1               
000396r 1               ; calc nesting (a macro might have changed it)
000396r 1               @loop:
000396r 1  B9 rr rr         lda tib, y
000399r 1  C8               iny
00039Ar 1  20 rr rr         jsr  nesting            ; update nesting value
00039Dr 1               
00039Dr 1               @cast:
00039Dr 1  C0 00            cpy #0
00039Fr 1  D0 F5            bne @loop
0003A1r 1                   ; fall throught
0003A1r 1               
0003A1r 1               ;----------------------------------------------------------------------
0003A1r 1               ; loop around waiting for character
0003A1r 1               ; get a line into tib
0003A1r 1               waitchar:
0003A1r 1               getstr:
0003A1r 1                   ; already ldy #$00
0003A1r 1               @loop:
0003A1r 1  20 rr rr         jsr getchar
0003A4r 1  C9 20            cmp #32                 ; ge space ?
0003A6r 1  B0 0F            bcs @ischar
0003A8r 1  C9 00            cmp #$0                 ; is it end of string ?
0003AAr 1  F0 24            beq @endstr
0003ACr 1  C9 0D            cmp #13                 ; carriage return ?
0003AEr 1  F0 10            beq @iscrlf
0003B0r 1  C9 0A            cmp #10                 ; line feed ?
0003B2r 1  F0 0C            beq @iscrlf
0003B4r 1               @ismacro:
0003B4r 1  4C rr rr         jmp macro
0003B7r 1               @ischar:
0003B7r 1  20 rr rr         jsr @echo
0003BAr 1                   ; nest ?
0003BAr 1  20 rr rr         jsr nesting
0003BDr 1  4C rr rr         jmp @loop            ; wait for next character
0003C0r 1               @iscrlf:
0003C0r 1                   ; CR
0003C0r 1  A9 0D            lda #13
0003C2r 1  20 rr rr         jsr @echo
0003C5r 1                   ; LF
0003C5r 1  A9 0A            lda #10
0003C7r 1  20 rr rr         jsr @echo
0003CAr 1                   ; pending nest ?
0003CAr 1  A5 F3            lda ns
0003CCr 1  C9 00            cmp #$00
0003CEr 1  F0 D1            beq @loop
0003D0r 1               ; mark etx, used later to check Z80 stack deep,
0003D0r 1               ; not need in 6502 round-robin stack,
0003D0r 1               ; preserved for compability
0003D0r 1               @endstr:
0003D0r 1                   ; mark ETX
0003D0r 1  A9 03            lda #$03
0003D2r 1  99 rr rr         sta tib, y
0003D5r 1  C8               iny
0003D6r 1                   ; mark NUL
0003D6r 1  A9 00            lda #$00
0003D8r 1  99 rr rr         sta tib, y
0003DBr 1               
0003DBr 1  A9 rr            lda #<tib
0003DDr 1  85 FE            sta ips + 0
0003DFr 1  A9 rr            lda #>tib
0003E1r 1  85 FF            sta ips + 1
0003E3r 1  20 rr rr         jsr decps_
0003E6r 1  4C rr rr         jmp next_
0003E9r 1               
0003E9r 1               ; maximum 255 chars
0003E9r 1               @echo:
0003E9r 1                   ; echo
0003E9r 1  20 rr rr         jsr putchar
0003ECr 1                   ; store
0003ECr 1  99 rr rr         sta tib, y
0003EFr 1  C8               iny
0003F0r 1                   ; limit 253
0003F0r 1  C0 FD            cpy #$FD
0003F2r 1  F0 DC            beq @endstr
0003F4r 1  60               rts
0003F5r 1               
0003F5r 1               ;----------------------------------------------------------------------
0003F5r 1               ; calculate nesting value
0003F5r 1               nesting:
0003F5r 1  C9 AD            cmp #'`'
0003F7r 1  D0 07            bne @nests
0003F9r 1  A9 80            lda #$80
0003FBr 1  45 F3            eor ns
0003FDr 1  85 F3            sta ns
0003FFr 1  60               rts
000400r 1               @nests:
000400r 1  24 F3            bit ns
000402r 1  30 18            bmi @nonest
000404r 1  C9 3A            cmp #':'
000406r 1  F0 15            beq @nestinc
000408r 1  C9 5B            cmp #'['
00040Ar 1  F0 11            beq @nestinc
00040Cr 1  C9 28            cmp #'('
00040Er 1  F0 0D            beq @nestinc
000410r 1  C9 3B            cmp #';'
000412r 1  F0 0C            beq @nestdec
000414r 1  C9 5D            cmp #']'
000416r 1  F0 08            beq @nestdec
000418r 1  C9 29            cmp #')'
00041Ar 1  F0 04            beq @nestdec
00041Cr 1               @nonest:
00041Cr 1  60               rts
00041Dr 1               @nestinc:
00041Dr 1  E6 F3            inc ns
00041Fr 1  60               rts
000420r 1               @nestdec:
000420r 1  C6 F3            dec ns
000422r 1  60               rts
000423r 1               
000423r 1               ;----------------------------------------------------------------------
000423r 1               ; prints a asciiz, refered by hardware stack
000423r 1               printStr:
000423r 1  68               pla
000424r 1  85 F9            sta wrk + 1
000426r 1  68               pla
000427r 1  85 F8            sta wrk + 0
000429r 1  20 rr rr         jsr puts_
00042Cr 1  A5 F8            lda wrk + 0
00042Er 1  48               pha
00042Fr 1  A5 F9            lda wrk + 1
000431r 1  48               pha
000432r 1  60               rts
000433r 1               
000433r 1               ;----------------------------------------------------------------------
000433r 1               ; prints a asciiz, refered by wrk
000433r 1               puts_:
000433r 1  A0 00            ldy #$00
000435r 1  20 rr rr         jsr @noeq
000438r 1               @loop:
000438r 1  20 rr rr         jsr putchar
00043Br 1  E6 F8            inc wrk + 0
00043Dr 1  D0 02            bne @noeq
00043Fr 1  E6 F9            inc wrk + 1
000441r 1               @noeq:
000441r 1  B1 F8            lda (wrk), y
000443r 1  D0 F3            bne @loop
000445r 1               @ends:
000445r 1  60               rts
000446r 1               
000446r 1               ;----------------------------------------------------------------------
000446r 1               ; prints number in tos to decimal ASCII
000446r 1               ; ps. putchar ends with rts
000446r 1               printdec:
000446r 1  A9 10            lda #<10000
000448r 1  85 F6            sta nos + 0
00044Ar 1  A9 27            lda #>10000
00044Cr 1  85 F7            sta nos + 1
00044Er 1  20 rr rr         jsr @nums
000451r 1  A9 E8            lda #<1000
000453r 1  85 F6            sta nos + 0
000455r 1  A9 03            lda #>1000
000457r 1  85 F7            sta nos + 1
000459r 1  20 rr rr         jsr @nums
00045Cr 1  A9 64            lda #<100
00045Er 1  85 F6            sta nos + 0
000460r 1  A9 00            lda #>100
000462r 1  85 F7            sta nos + 1
000464r 1  20 rr rr         jsr @nums
000467r 1  A9 0A            lda #<10
000469r 1  85 F6            sta nos + 0
00046Br 1  A9 00            lda #>10
00046Dr 1  85 F7            sta nos + 1
00046Fr 1  20 rr rr         jsr @nums
000472r 1  A9 0A            lda #<10
000474r 1  85 F6            sta nos + 0
000476r 1  A9 00            lda #>10
000478r 1  85 F7            sta nos + 1
00047Ar 1               @nums:
00047Ar 1  A0 2F            ldy #'0'-1
00047Cr 1               @loop:
00047Cr 1  C8               iny
00047Dr 1  38               sec
00047Er 1  A5 F4            lda tos + 0
000480r 1  E5 F6            sbc nos + 0
000482r 1  85 F4            sta tos + 0
000484r 1  A5 F5            lda tos + 1
000486r 1  E5 F7            sbc nos + 1
000488r 1  85 F5            sta tos + 1
00048Ar 1  90 F0            bcc @loop
00048Cr 1  18               clc
00048Dr 1  A5 F4            lda tos + 0
00048Fr 1  65 F6            adc nos + 0
000491r 1  85 F4            sta tos + 0
000493r 1  A5 F5            lda tos + 1
000495r 1  65 F7            adc nos + 1
000497r 1  85 F5            sta tos + 1
000499r 1  98               tya
00049Ar 1  4C rr rr         jmp putchar
00049Dr 1               
00049Dr 1               ;----------------------------------------------------------------------
00049Dr 1               ; prints number in tos to hexadecimal ASCII
00049Dr 1               printhex:
00049Dr 1  A5 F5            lda tos + 1
00049Fr 1  20 rr rr         jsr printhex8
0004A2r 1  A5 F4            lda tos + 0
0004A4r 1  20 rr rr         jsr printhex8
0004A7r 1  60               rts
0004A8r 1               
0004A8r 1               ;----------------------------------------------------------------------
0004A8r 1               ; print a 8-bit HEX
0004A8r 1               printhex8:
0004A8r 1  85 F2            sta ap
0004AAr 1  18               clc
0004ABr 1  6A               ror
0004ACr 1  6A               ror
0004ADr 1  6A               ror
0004AEr 1  6A               ror
0004AFr 1  20 rr rr         jsr @conv
0004B2r 1  A5 F2            lda ap
0004B4r 1               @conv:
0004B4r 1  18               clc
0004B5r 1  29 0F            and #$0F
0004B7r 1  69 30            adc #$30
0004B9r 1  C9 3A            cmp #$3A
0004BBr 1  90 02            bcc @ends
0004BDr 1  69 06            adc #$06
0004BFr 1               @ends:
0004BFr 1  4C rr rr         jmp putchar
0004C2r 1               
0004C2r 1               ;----------------------------------------------------------------------
0004C2r 1               ; convert a decimal value to binary
0004C2r 1               num_:
0004C2r 1  20 rr rr         jsr decps_
0004C5r 1  A9 00            lda #$00
0004C7r 1  85 F4            sta tos + 0
0004C9r 1  85 F5            sta tos + 1
0004CBr 1               @loop:
0004CBr 1  20 rr rr         jsr incps_
0004CEr 1  20 rr rr         jsr ldaps_
0004D1r 1  C9 30            cmp #'0' + 0
0004D3r 1  90 18            bcc @ends
0004D5r 1  C9 3A            cmp #'9' + 1
0004D7r 1  B0 14            bcs @ends
0004D9r 1               @cv10:
0004D9r 1  38               sec
0004DAr 1  E9 30            sbc #'0'
0004DCr 1               @uval:
0004DCr 1  18               clc
0004DDr 1  65 F4            adc tos + 0
0004DFr 1  85 F4            sta tos + 0
0004E1r 1  A9 00            lda #$00
0004E3r 1  65 F5            adc tos + 1
0004E5r 1  85 F5            sta tos + 1
0004E7r 1  20 rr rr         jsr mul10_
0004EAr 1  18               clc
0004EBr 1  90 DE            bcc @loop
0004EDr 1               @ends:
0004EDr 1  20 rr rr         jsr spush_
0004F0r 1  4C rr rr         jmp next_
0004F3r 1               
0004F3r 1               ;----------------------------------------------------------------------
0004F3r 1               ; multiply by ten
0004F3r 1               ; 2x + 8x
0004F3r 1               mul10_:
0004F3r 1                   ; 2x
0004F3r 1  06 F4            asl tos + 0
0004F5r 1  85 F4            sta tos + 0
0004F7r 1  85 F6            sta nos + 0
0004F9r 1  26 F5            rol tos + 1
0004FBr 1  85 F5            sta tos + 1
0004FDr 1  85 F7            sta nos + 1
0004FFr 1                   ; 2x
0004FFr 1  06 F4            asl tos + 0
000501r 1  85 F4            sta tos + 0
000503r 1  26 F5            rol tos + 1
000505r 1  85 F5            sta tos + 1
000507r 1                   ; 2x
000507r 1  06 F4            asl tos + 0
000509r 1  85 F4            sta tos + 0
00050Br 1  26 F5            rol tos + 1
00050Dr 1  85 F5            sta tos + 1
00050Fr 1                   ; 2x + 8x
00050Fr 1  18               clc
000510r 1  A5 F4            lda tos + 0
000512r 1  65 F6            adc nos + 0
000514r 1  85 F4            sta tos + 0
000516r 1  A5 F5            lda tos + 1
000518r 1  65 F7            adc nos + 1
00051Ar 1  85 F5            sta tos + 1
00051Cr 1  60               rts
00051Dr 1               
00051Dr 1               ;----------------------------------------------------------------------
00051Dr 1               ; convert a hexadecimal value to binary
00051Dr 1               hex_:
00051Dr 1  20 rr rr         jsr decps_
000520r 1  A9 00            lda #$00
000522r 1  85 F4            sta tos + 0
000524r 1  85 F5            sta tos + 1
000526r 1               @loop:
000526r 1  20 rr rr         jsr incps_
000529r 1  20 rr rr         jsr ldaps_
00052Cr 1               @isd:
00052Cr 1  C9 30            cmp #'0'
00052Er 1  90 28            bcc @ends
000530r 1  C9 3A            cmp #'9' + 1
000532r 1  B0 06            bcs @ish
000534r 1               @cv10:
000534r 1  38               sec
000535r 1  E9 30            sbc #'0'
000537r 1  18               clc
000538r 1  90 0D            bcc @uval
00053Ar 1               @ish:
00053Ar 1                   ; to upper
00053Ar 1  29 DF            and #%11011111
00053Cr 1  C5 C1            cmp 'A'
00053Er 1  90 18            bcc @ends
000540r 1  C5 C7            cmp 'F' + 1
000542r 1  B0 14            bcs @ends
000544r 1               @cv16:
000544r 1  38               sec
000545r 1  E9 B7            sbc #'A' - 10
000547r 1               @uval:
000547r 1  18               clc
000548r 1  65 F4            adc tos + 0
00054Ar 1  85 F4            sta tos + 0
00054Cr 1  A9 00            lda #$00
00054Er 1  65 F5            adc tos + 1
000550r 1  85 F5            sta tos + 1
000552r 1  20 rr rr         jsr mul16_
000555r 1  18               clc
000556r 1  90 CE            bcc @loop
000558r 1               @ends:
000558r 1  20 rr rr         jsr spush_
00055Br 1  4C rr rr         jmp next_
00055Er 1               
00055Er 1               ;----------------------------------------------------------------------
00055Er 1               ; multiply by sixteen
00055Er 1               mul16_:
00055Er 1  A0 04            ldy #04
000560r 1               @loop:
000560r 1  06 F4            asl tos + 0
000562r 1  85 F4            sta tos + 0
000564r 1  26 F5            rol tos + 1
000566r 1  85 F5            sta tos + 1
000568r 1  88               dey
000569r 1  D0 F5            bne @loop
00056Br 1  60               rts
00056Cr 1               
00056Cr 1               ;----------------------------------------------------------------------
00056Cr 1               ; skip to eol
00056Cr 1               comment_:
00056Cr 1  A0 00            ldy #$00
00056Er 1               @loop:
00056Er 1  C8               iny
00056Fr 1  B1 FE            lda (ips), y
000571r 1  C9 0D            cmp #13
000573r 1  D0 F9            bne @loop
000575r 1                   ; skip \r
000575r 1  C8               iny
000576r 1                   ; skip \n
000576r 1  C8               iny
000577r 1                   ; offset
000577r 1  98               tya
000578r 1  18               clc
000579r 1  65 FE            adc ips + 0
00057Br 1  90 02            bcc @iscc
00057Dr 1  E6 FF            inc ips + 1
00057Fr 1               @iscc:
00057Fr 1  4C rr rr         jmp next_
000582r 1               
000582r 1               ;----------------------------------------------------------------------
000582r 1               depth_:
000582r 1                   ; limit to 255 bytes
000582r 1  A9 FF            lda #$FF
000584r 1  38               sec
000585r 1  E5 F1            sbc xp
000587r 1                   ; words
000587r 1  4A               lsr
000588r 1  85 F4            sta tos + 0
00058Ar 1  A9 00            lda #00
00058Cr 1  85 F5            sta tos + 1
00058Er 1  20 rr rr         jsr spush_
000591r 1  4C rr rr         jmp next_
000594r 1               
000594r 1               ;----------------------------------------------------------------------
000594r 1               ; print hexadecimal
000594r 1               hdot_:
000594r 1  20 rr rr         jsr spull_
000597r 1  20 rr rr         jsr printhex
00059Ar 1  4C rr rr         jmp dotsp
00059Dr 1               
00059Dr 1               ;----------------------------------------------------------------------
00059Dr 1               ; print decimal
00059Dr 1               dot_:
00059Dr 1  20 rr rr         jsr spull_
0005A0r 1  20 rr rr         jsr printdec
0005A3r 1  4C rr rr         jmp dotsp
0005A6r 1               
0005A6r 1               ;----------------------------------------------------------------------
0005A6r 1               ; print space
0005A6r 1               dotsp:
0005A6r 1  A9 20            lda #' '
0005A8r 1  20 rr rr         jsr writeChar1
0005ABr 1  4C rr rr         jmp next_
0005AEr 1               
0005AEr 1               ;----------------------------------------------------------------------
0005AEr 1               writeChar:
0005AEr 1  20 rr rr         jsr ldaps_
0005B1r 1  20 rr rr         jsr writeChar1
0005B4r 1  4C rr rr         jmp next_
0005B7r 1               
0005B7r 1               ;----------------------------------------------------------------------
0005B7r 1               writeChar1:
0005B7r 1  4C rr rr         jmp putchar
0005BAr 1               
0005BAr 1               ;----------------------------------------------------------------------
0005BAr 1               newln_:
0005BAr 1  20 rr rr         jsr crlf
0005BDr 1  4C rr rr         jmp next_
0005C0r 1               
0005C0r 1               ;----------------------------------------------------------------------
0005C0r 1               crlf:
0005C0r 1  20 rr rr         jsr printStr
0005C3r 1  BF 52 BF 4E      .asciiz "\r\n"
0005C7r 1  00           
0005C8r 1  60               rts
0005C9r 1               
0005C9r 1               ;----------------------------------------------------------------------
0005C9r 1               prompt:
0005C9r 1  20 rr rr         jsr printStr
0005CCr 1  BF 52 BF 4E      .asciiz "\r\n> "
0005D0r 1  3E 20 00     
0005D3r 1  60               rts
0005D4r 1               
0005D4r 1               ;----------------------------------------------------------------------
0005D4r 1               printStk_:
0005D4r 1  20 rr rr         jsr enter_
0005D7r 1                   ;.asciiz  "\\a@2-\\D1-(",$22,"@\\b@\\(,)(.)2-)'"
0005D7r 1  BF BF 41 40      .asciiz  "\\a@2-\\D1-(34@\\b@\\(,)(.)2-)'"
0005DBr 1  32 2D BF BF  
0005DFr 1  C4 31 2D 28  
0005F7r 1  4C rr rr         jmp next_
0005FAr 1               
0005FAr 1               ;----------------------------------------------------------------------
0005FAr 1               ; 6502 is memory mapped IO
0005FAr 1               inPort_:
0005FAr 1  4C rr rr         jmp cFetch_
0005FDr 1               
0005FDr 1               ;----------------------------------------------------------------------
0005FDr 1               ; 6502 is memory mapped IO
0005FDr 1               outPort_:
0005FDr 1  4C rr rr         jmp cStore_
000600r 1               
000600r 1               ;----------------------------------------------------------------------
000600r 1               charCode_:
000600r 1  20 rr rr         jsr incps_
000603r 1  20 rr rr         jsr ldaps_
000606r 1  85 F4            sta tos + 0
000608r 1  A9 00            lda #$00
00060Ar 1  85 F5            sta tos + 1
00060Cr 1  20 rr rr         jsr spush_
00060Fr 1  4C rr rr         jmp next_
000612r 1               
000612r 1               ;----------------------------------------------------------------------
000612r 1               ; Execute next opcode
000612r 1               next_:
000612r 1                   ; using full jump table
000612r 1  20 rr rr         jsr incps_
000615r 1  20 rr rr         jsr ldaps_
000618r 1  0A               asl
000619r 1  A8               tay
00061Ar 1  B9 rr rr         lda optcodes, y
00061Dr 1  85 F8            sta wrk + 0
00061Fr 1  C8               iny
000620r 1  B9 rr rr         lda optcodes, y
000623r 1  85 F9            sta wrk + 1
000625r 1  6C F8 00         jmp (wrk)
000628r 1               
000628r 1               ;----------------------------------------------------------------------
000628r 1               ; Execute next alt opcode
000628r 1               alt_:
000628r 1                   ; using full jump table
000628r 1  20 rr rr         jsr incps_
00062Br 1  20 rr rr         jsr ldaps_
00062Er 1  0A               asl
00062Fr 1  A8               tay
000630r 1  B9 rr rr         lda altcodes, y
000633r 1  85 F8            sta wrk + 0
000635r 1  C8               iny
000636r 1  B9 rr rr         lda altcodes, y
000639r 1  85 F9            sta wrk + 1
00063Br 1  6C F8 00         jmp (wrk)
00063Er 1               
00063Er 1               ;----------------------------------------------------------------------
00063Er 1               ; Execute code inline
00063Er 1               enter_:
00063Er 1  20 rr rr         jsr pushps_
000641r 1               ; pull from system stack
000641r 1  68               pla
000642r 1  85 FE            sta ips + 0
000644r 1  68               pla
000645r 1  85 FF            sta ips + 1
000647r 1  20 rr rr         jsr decps_
00064Ar 1  4C rr rr         jmp next_
00064Dr 1               
00064Dr 1               ;----------------------------------------------------------------------
00064Dr 1               ; Execute code from data stack
00064Dr 1               go_:
00064Dr 1  20 rr rr         jsr pushps_
000650r 1               ; pull ps from data stack
000650r 1                   ; ldx xp
000650r 1  BD rr rr         lda spz + 0, x
000653r 1  85 FE            sta ips + 0
000655r 1  BD rr rr         lda spz + 1, x
000658r 1  85 FF            sta ips + 1
00065Ar 1  E8               inx
00065Br 1  E8               inx
00065Cr 1                   ; stx xp
00065Cr 1  20 rr rr         jsr decps_
00065Fr 1  4C rr rr         jmp next_
000662r 1               
000662r 1               ;----------------------------------------------------------------------
000662r 1               ; Execute code from a user function
000662r 1               call_:
000662r 1  85 F2            sta ap
000664r 1  20 rr rr         jsr pushps_
000667r 1  20 rr rr         jsr lookupDefs
00066Ar 1  20 rr rr         jsr decps_
00066Dr 1  4C rr rr         jmp next_
000670r 1               
000670r 1               lookupDeft:
000670r 1  A5 F2            lda ap
000672r 1  8D rr rr         sta vEdited
000675r 1                   ; fall throught
000675r 1               
000675r 1               lookupDefs:
000675r 1  A5 F2            lda ap
000677r 1  E5 C1            sbc 'A'
000679r 1  0A               asl
00067Ar 1  A8               tay
00067Br 1  AD rr rr         lda vDefs + 0
00067Er 1  85 F4            sta tos + 0
000680r 1  AD rr rr         lda vDefs + 1
000683r 1  85 F5            sta tos + 1
000685r 1  60               rts
000686r 1               
000686r 1               ;----------------------------------------------------------------------
000686r 1               ; push an user variable
000686r 1               var_:
000686r 1  85 F2            sta ap
000688r 1  A9 rr            lda #<vars
00068Ar 1  85 F4            sta tos + 0
00068Cr 1  A9 rr            lda #>vars
00068Er 1  85 F5            sta tos + 1
000690r 1  4C rr rr         jmp a2z_
000693r 1               
000693r 1               ;----------------------------------------------------------------------
000693r 1               ; push a mint variable
000693r 1               sysVar_:
000693r 1  85 F2            sta ap
000695r 1  A9 rr            lda #<vsys
000697r 1  85 F4            sta tos + 0
000699r 1  A9 rr            lda #>vsys
00069Br 1  85 F5            sta tos + 1
00069Dr 1  4C rr rr         jmp a2z_
0006A0r 1               
0006A0r 1               ;----------------------------------------------------------------------
0006A0r 1               ; push a reference into stack
0006A0r 1               a2z_:
0006A0r 1  A5 F2            lda ap
0006A2r 1  38               sec
0006A3r 1  E9 41            sbc #'a'
0006A5r 1  0A               asl
0006A6r 1  18               clc
0006A7r 1  65 F4            adc tos + 0
0006A9r 1  90 02            bcc @iscc
0006ABr 1  E6 F5            inc tos + 1
0006ADr 1               @iscc:
0006ADr 1  20 rr rr         jsr spush_
0006B0r 1  4C rr rr         jmp next_
0006B3r 1               
0006B3r 1               ;----------------------------------------------------------------------
0006B3r 1               ; skip spaces
0006B3r 1               nosp_:
0006B3r 1  20 rr rr         jsr incps_
0006B6r 1  20 rr rr         jsr ldaps_
0006B9r 1  C9 20            cmp #' '
0006BBr 1  F0 F6            beq nosp_
0006BDr 1  60               rts
0006BEr 1               
0006BEr 1               ;----------------------------------------------------------------------
0006BEr 1               getRef_:
0006BEr 1  20 rr rr         jsr nosp_
0006C1r 1  85 F2            sta ap
0006C3r 1  20 rr rr         jsr lookupDefs
0006C6r 1  4C rr rr         jmp fetch_
0006C9r 1               
0006C9r 1               ;----------------------------------------------------------------------
0006C9r 1               def_:
0006C9r 1                   ; skip spaces
0006C9r 1  20 rr rr         jsr nosp_
0006CCr 1  85 F2            sta ap
0006CEr 1  20 rr rr         jsr lookupDefs
0006D1r 1  AD rr rr         lda vHeapPtr + 0
0006D4r 1  91 F4            sta (tos), y
0006D6r 1  85 F6            sta nos + 0
0006D8r 1  C8               iny
0006D9r 1  AD rr rr         lda vHeapPtr + 1
0006DCr 1  91 F4            sta (tos), y
0006DEr 1  85 F7            sta nos + 1
0006E0r 1  A0 00            ldy #0
0006E2r 1                   ; copy until 255 or ;
0006E2r 1               @loop:
0006E2r 1  B1 FE            lda (ips), y
0006E4r 1  91 F6            sta (nos), y
0006E6r 1  C8               iny
0006E7r 1  F0 04            beq @ends
0006E9r 1  C9 3B            cmp #';'
0006EBr 1  D0 F5            bne @loop
0006EDr 1               @ends:
0006EDr 1  98               tya
0006EEr 1  85 F2            sta ap
0006F0r 1                   ; update Heap
0006F0r 1  18               clc
0006F1r 1  6D rr rr         adc vHeapPtr + 0
0006F4r 1  8D rr rr         sta vHeapPtr + 0
0006F7r 1  90 03            bcc @iscc
0006F9r 1  EE rr rr         inc vHeapPtr + 1
0006FCr 1               @iscc:
0006FCr 1  A5 F2            lda ap
0006FEr 1                   ; update ip
0006FEr 1  18               clc
0006FFr 1  65 FE            adc ips + 0
000701r 1  85 FE            sta ips + 0
000703r 1  90 02            bcc @iscci
000705r 1  E6 FF            inc ips + 1
000707r 1               @iscci:
000707r 1  4C rr rr         jmp next_
00070Ar 1               
00070Ar 1               
00070Ar 1               
00070Ar 1               ;----------------------------------------------------------------------
00070Ar 1               break_:
00070Ar 1  20 rr rr         jsr spull_
00070Dr 1  A5 F4            lda tos + 0
00070Fr 1  05 F5            ora tos + 1
000711r 1  D0 03            bne @isne
000713r 1  4C rr rr         jmp next_
000716r 1               @isne:
000716r 1  A5 F0            lda yp
000718r 1  18               clc
000719r 1  69 06            adc #$06
00071Br 1  4C rr rr         jmp begin1
00071Er 1               
00071Er 1               ;----------------------------------------------------------------------
00071Er 1               ; Left parentesis ( begins a loop
00071Er 1               begin_:
00071Er 1               
00071Er 1               	; tos is zero ?
00071Er 1  20 rr rr     	jsr spull_
000721r 1  A5 F4        	lda tos + 0
000723r 1  05 F5        	ora tos + 1
000725r 1  F0 28        	beq begin1
000727r 1               
000727r 1               	; alloc frame
000727r 1  A5 F0            lda yp
000729r 1  38               sec
00072Ar 1  E9 06            sbc #6
00072Cr 1  85 F0            sta yp
00072Er 1               
00072Er 1  A4 F0            ldy yp
000730r 1                   ; counter
000730r 1  A9 00            lda #$00
000732r 1  99 rr rr         sta rpz + 0, y
000735r 1  99 rr rr         sta rpz + 1, y
000738r 1                   ; limit
000738r 1  A5 F4            lda tos + 0
00073Ar 1  99 rr rr         sta rpz + 2, y
00073Dr 1  A5 F5            lda tos + 1
00073Fr 1  99 rr rr         sta rpz + 3, y
000742r 1                   ; pointer
000742r 1  A5 FE            lda ips + 0
000744r 1  99 rr rr         sta rpz + 4, y
000747r 1  A5 FF            lda ips + 1
000749r 1  99 rr rr         sta rpz + 5, y
00074Cr 1  4C rr rr         jmp next_
00074Fr 1               
00074Fr 1               begin1:
00074Fr 1  A9 01            lda #$01
000751r 1  85 F3            sta ns
000753r 1               
000753r 1               @loop:
000753r 1  20 rr rr         jsr incps_
000756r 1  20 rr rr         jsr ldaps_
000759r 1  20 rr rr         jsr nesting
00075Cr 1  A5 F3            lda ns
00075Er 1  45 F3            eor ns
000760r 1  D0 F1            bne @loop
000762r 1  4C rr rr         jmp next_
000765r 1               
000765r 1               ;----------------------------------------------------------------------
000765r 1               ; Right parentesis ) again a loop
000765r 1               again_:
000765r 1  A4 F0            ldy yp
000767r 1                   ; counter
000767r 1  B9 rr rr         lda rpz + 0, y
00076Ar 1  85 F8            sta wrk + 0
00076Cr 1  B9 rr rr         lda rpz + 1, y
00076Fr 1  85 F9            sta wrk + 1
000771r 1               
000771r 1                   ; check if IFTEMode $FFFF
000771r 1               
000771r 1  A5 F8            lda wrk + 0
000773r 1  25 F9            and wrk + 1
000775r 1  85 F2            sta ap
000777r 1  E6 F2            inc ap
000779r 1  D0 11            bne again1
00077Br 1               
00077Br 1                   ; push FALSE
00077Br 1  A5 00            lda FALSE
00077Dr 1  85 F4            sta tos + 0
00077Fr 1  85 F5            sta tos + 1
000781r 1  20 rr rr         jsr spush_
000784r 1               
000784r 1                   ; drop IFTEMmode
000784r 1  A5 F0            lda yp
000786r 1  18               clc
000787r 1  69 02            adc #2
000789r 1  4C rr rr         jmp next_
00078Cr 1               
00078Cr 1               again1:
00078Cr 1                   ; peek loop limit
00078Cr 1  AD rr rr         lda rpz + 2
00078Fr 1  85 F6            sta nos + 0
000791r 1  AD rr rr         lda rpz + 3
000794r 1  85 F9            sta nos + 3
000796r 1               
000796r 1                   ; test end
000796r 1  38               sec
000797r 1  A5 F6            lda nos + 0
000799r 1  E5 F8            sbc wrk + 0
00079Br 1  D0 10            bne @noeq
00079Dr 1  A5 F7            lda nos + 1
00079Fr 1  E5 F9            sbc wrk + 1
0007A1r 1  D0 0A            bne @noeq
0007A3r 1               
0007A3r 1                   ; drop loop vars
0007A3r 1  A5 F0            lda yp
0007A5r 1  18               clc
0007A6r 1  69 06            adc #6
0007A8r 1  85 F0        	sta yp
0007AAr 1  4C rr rr     	jmp next_
0007ADr 1               
0007ADr 1               @noeq:
0007ADr 1                   ; increase counter
0007ADr 1  E6 F8            inc wrk + 0
0007AFr 1  D0 02            bne @novr
0007B1r 1  E6 F9            inc wrk + 1
0007B3r 1               @novr:
0007B3r 1                   ; poke loop var
0007B3r 1  A5 F8            lda wrk + 0
0007B5r 1  8D rr rr         sta rpz + 0
0007B8r 1  A5 F9            lda wrk + 1
0007BAr 1  8D rr rr         sta rpz + 1
0007BDr 1               
0007BDr 1                   ; return at begin
0007BDr 1  B9 rr rr         lda rpz + 4, y
0007C0r 1  85 FE            sta ips + 0
0007C2r 1  B9 rr rr         lda rpz + 5, y
0007C5r 1  85 FF            sta ips + 1
0007C7r 1               
0007C7r 1  4C rr rr         jmp next_
0007CAr 1               
0007CAr 1               ;----------------------------------------------------------------------
0007CAr 1               j_:
0007CAr 1  A5 F0            lda yp
0007CCr 1  38               sec
0007CDr 1  E9 06            sbc #6
0007CFr 1  A8               tay
0007D0r 1                   ; fall through
0007D0r 1               ;----------------------------------------------------------------------
0007D0r 1               i_:
0007D0r 1  A4 F0            ldy yp
0007D2r 1  B9 rr rr         lda spz + 0, y
0007D5r 1  85 F4            sta tos + 0
0007D7r 1  C8               iny
0007D8r 1  B9 rr rr         lda spz + 0, y
0007DBr 1  85 F5            sta tos + 1
0007DDr 1  20 rr rr         jsr spush_
0007E0r 1  4C rr rr         jmp next_
0007E3r 1               
0007E3r 1               ;----------------------------------------------------------------------
0007E3r 1               ifte_:
0007E3r 1  20 rr rr         jsr spull_
0007E6r 1  A5 F4            lda tos + 0
0007E8r 1  05 F5            ora tos + 1
0007EAr 1  D0 08            bne @isne
0007ECr 1  E6 F4            inc tos + 0
0007EEr 1  20 rr rr         jsr spush_
0007F1r 1  4C rr rr         jmp begin1
0007F4r 1               @isne:
0007F4r 1  A9 FF            lda #$FF
0007F6r 1  85 F4            sta tos + 0
0007F8r 1  85 F5            sta tos + 1
0007FAr 1  20 rr rr         jsr spush_
0007FDr 1  4C rr rr         jmp next_
000800r 1               
000800r 1               ;----------------------------------------------------------------------
000800r 1               ret_:
000800r 1  20 rr rr         jsr pullps_
000803r 1  4C rr rr         jmp next_
000806r 1               
000806r 1               ;----------------------------------------------------------------------
000806r 1               ;
000806r 1               exit_:
000806r 1  20 rr rr         jsr incps_
000809r 1  A5 FE            lda ips + 0
00080Br 1  85 F4            sta tos + 0
00080Dr 1  A5 FF            lda ips + 1
00080Fr 1  85 F5            sta tos + 1
000811r 1  20 rr rr         jsr pullps_
000814r 1  6C F4 00         jmp (tos)
000817r 1               
000817r 1               ;----------------------------------------------------------------------
000817r 1               ; 6502 stack is fixed and round robin
000817r 1               ; no need control deep
000817r 1               etx_:
000817r 1  4C rr rr         jmp interpret
00081Ar 1               
00081Ar 1               ;----------------------------------------------------------------------
00081Ar 1               init:
00081Ar 1               
00081Ar 1               endGroup_:
00081Ar 1               group_:
00081Ar 1               
00081Ar 1               cArrDef_:
00081Ar 1               editDef_:
00081Ar 1               
00081Ar 1               arrEnd_:
00081Ar 1               arrDef_:
00081Ar 1               
00081Ar 1               
00081Ar 1               ;----------------------------------------------------------------------
00081Ar 1               ;optcodes:
00081Ar 1               ;altcodes:
00081Ar 1               ;ctlcodes:
00081Ar 1               
00081Ar 1               .include "jumptables.s"
00081Ar 2               ; **************************************************************************
00081Ar 2               ; Jump Tables, not optmized
00081Ar 2               ; **************************************************************************
00081Ar 2               ; .align $100
00081Ar 2               
00081Ar 2               ;----------------------------------------------------------------------
00081Ar 2               optcodes:
00081Ar 2  rr rr               .word (exit_)    ;   NUL
00081Cr 2  rr rr               .word (nop_)     ;   SOH
00081Er 2  rr rr               .word (nop_)     ;   STX
000820r 2  rr rr               .word (etx_)     ;   ETX
000822r 2  rr rr               .word (nop_)     ;   EOT
000824r 2  rr rr               .word (nop_)     ;   ENQ
000826r 2  rr rr               .word (nop_)     ;   apK
000828r 2  rr rr               .word (nop_)     ;   BEL
00082Ar 2  rr rr               .word (nop_)     ;   BS
00082Cr 2  rr rr               .word (nop_)     ;   TAB
00082Er 2  rr rr               .word (nop_)     ;   LF
000830r 2  rr rr               .word (nop_)     ;   VT
000832r 2  rr rr               .word (nop_)     ;   FF
000834r 2  rr rr               .word (nop_)     ;   CR
000836r 2  rr rr               .word (nop_)     ;   SO
000838r 2  rr rr               .word (nop_)     ;   SI
00083Ar 2  rr rr               .word (nop_)     ;   DLE
00083Cr 2  rr rr               .word (nop_)     ;   DC1
00083Er 2  rr rr               .word (nop_)     ;   DC2
000840r 2  rr rr               .word (nop_)     ;   DC3
000842r 2  rr rr               .word (nop_)     ;   DC4
000844r 2  rr rr               .word (nop_)     ;   NAK
000846r 2  rr rr               .word (nop_)     ;   SYN
000848r 2  rr rr               .word (nop_)     ;   ETB
00084Ar 2  rr rr               .word (nop_)     ;   CAN
00084Cr 2  rr rr               .word (nop_)     ;   EM
00084Er 2  rr rr               .word (nop_)     ;   SUB
000850r 2  rr rr               .word (nop_)     ;   ESC
000852r 2  rr rr               .word (nop_)     ;   FS
000854r 2  rr rr               .word (nop_)     ;   GS
000856r 2  rr rr               .word (nop_)     ;   RS
000858r 2  rr rr               .word (nop_)     ;   nos
00085Ar 2  rr rr               .word (nop_)     ;   SP
00085Cr 2  rr rr               .word (store_)   ;   !
00085Er 2  rr rr               .word (dup_)     ;   "
000860r 2  rr rr               .word (hex_)    ;    #
000862r 2  rr rr               .word (swap_)   ;    $
000864r 2  rr rr               .word (over_)   ;    %
000866r 2  rr rr               .word (and_)    ;    &
000868r 2  rr rr               .word (drop_)   ;    '
00086Ar 2  rr rr               .word (begin_)  ;    (
00086Cr 2  rr rr               .word (again_)  ;    )
00086Er 2  rr rr               .word (mul_)    ;    *
000870r 2  rr rr               .word (add_)    ;    +
000872r 2  rr rr               .word (hdot_)   ;    ,
000874r 2  rr rr               .word (sub_)    ;    -
000876r 2  rr rr               .word (dot_)    ;    .
000878r 2  rr rr               .word (div_)    ;    /
00087Ar 2  rr rr               .word (num_)    ;    0
00087Cr 2  rr rr               .word (num_)    ;    1
00087Er 2  rr rr               .word (num_)    ;    2
000880r 2  rr rr               .word (num_)    ;    3
000882r 2  rr rr               .word (num_)    ;    4
000884r 2  rr rr               .word (num_)    ;    5
000886r 2  rr rr               .word (num_)    ;    6
000888r 2  rr rr               .word (num_)    ;    7
00088Ar 2  rr rr               .word (num_)    ;    8
00088Cr 2  rr rr               .word (num_)    ;    9
00088Er 2  rr rr               .word (def_)    ;    :
000890r 2  rr rr               .word (ret_)    ;    ;
000892r 2  rr rr               .word (lt_)     ;    <
000894r 2  rr rr               .word (eq_)     ;    =
000896r 2  rr rr               .word (gt_)     ;    >
000898r 2  rr rr               .word (getRef_) ;    ?
00089Ar 2  rr rr               .word (fetch_)  ;    @
00089Cr 2  rr rr               .word (call_)    ;    A
00089Er 2  rr rr               .word (call_)    ;    B
0008A0r 2  rr rr               .word (call_)    ;    C
0008A2r 2  rr rr               .word (call_)    ;    D
0008A4r 2  rr rr               .word (call_)    ;    E
0008A6r 2  rr rr               .word (call_)    ;    F
0008A8r 2  rr rr               .word (call_)    ;    G
0008AAr 2  rr rr               .word (call_)    ;    H
0008ACr 2  rr rr               .word (call_)    ;    I
0008AEr 2  rr rr               .word (call_)    ;    J
0008B0r 2  rr rr               .word (call_)    ;    K
0008B2r 2  rr rr               .word (call_)    ;    L
0008B4r 2  rr rr               .word (call_)    ;    M
0008B6r 2  rr rr               .word (call_)    ;    N
0008B8r 2  rr rr               .word (call_)    ;    O
0008BAr 2  rr rr               .word (call_)    ;    P
0008BCr 2  rr rr               .word (call_)    ;    Q
0008BEr 2  rr rr               .word (call_)    ;    R
0008C0r 2  rr rr               .word (call_)    ;    S
0008C2r 2  rr rr               .word (call_)    ;    T
0008C4r 2  rr rr               .word (call_)    ;    U
0008C6r 2  rr rr               .word (call_)    ;    V
0008C8r 2  rr rr               .word (call_)    ;    W
0008CAr 2  rr rr               .word (call_)    ;    X
0008CCr 2  rr rr               .word (call_)    ;    Y
0008CEr 2  rr rr               .word (call_)    ;    Z
0008D0r 2  rr rr               .word (arrDef_) ;    [
0008D2r 2  rr rr               .word (alt_)    ;    \
0008D4r 2  rr rr               .word (arrEnd_) ;    ]
0008D6r 2  rr rr               .word (xor_)    ;    ^
0008D8r 2  rr rr               .word (neg_)    ;    _
0008DAr 2  rr rr               .word (str_)    ;    `
0008DCr 2  rr rr               .word (var_)    ;    a
0008DEr 2  rr rr               .word (var_)    ;    b
0008E0r 2  rr rr               .word (var_)    ;    c
0008E2r 2  rr rr               .word (var_)    ;    d
0008E4r 2  rr rr               .word (var_)    ;    e
0008E6r 2  rr rr               .word (var_)    ;    f
0008E8r 2  rr rr               .word (var_)    ;    g
0008EAr 2  rr rr               .word (var_)    ;    h
0008ECr 2  rr rr               .word (var_)    ;    i
0008EEr 2  rr rr               .word (var_)    ;    j
0008F0r 2  rr rr               .word (var_)    ;    k
0008F2r 2  rr rr               .word (var_)    ;    l
0008F4r 2  rr rr               .word (var_)    ;    m
0008F6r 2  rr rr               .word (var_)    ;    n
0008F8r 2  rr rr               .word (var_)    ;    o
0008FAr 2  rr rr               .word (var_)    ;    p
0008FCr 2  rr rr               .word (var_)    ;    q
0008FEr 2  rr rr               .word (var_)    ;    r
000900r 2  rr rr               .word (var_)    ;    s
000902r 2  rr rr               .word (var_)    ;    t
000904r 2  rr rr               .word (var_)    ;    u
000906r 2  rr rr               .word (var_)    ;    v
000908r 2  rr rr               .word (var_)    ;    w
00090Ar 2  rr rr               .word (var_)    ;    x
00090Cr 2  rr rr               .word (var_)    ;    y
00090Er 2  rr rr               .word (var_)    ;    z
000910r 2  rr rr               .word (shl_)    ;    {
000912r 2  rr rr               .word (or_)     ;    |
000914r 2  rr rr               .word (shr_)    ;    }
000916r 2  rr rr               .word (inv_)    ;    ~
000918r 2  rr rr               .word (nop_)    ;    backspace
00091Ar 2               
00091Ar 2               ;----------------------------------------------------------------------
00091Ar 2               ; alternate function codes
00091Ar 2               ctlcodes:
00091Ar 2               altcodes:
00091Ar 2  rr rr               .word (empty_)      ; NUL ^@
00091Cr 2  rr rr               .word (empty_)      ; SOH ^A
00091Er 2  rr rr               .word (toggleBase_) ; STX ^B
000920r 2  rr rr               .word (empty_)      ; ETX ^C
000922r 2  rr rr               .word (empty_)      ; EOT ^D
000924r 2  rr rr               .word (edit_)       ; ENQ ^E
000926r 2  rr rr               .word (empty_)      ; ACK ^F
000928r 2  rr rr               .word (empty_)      ; BEL ^G
00092Ar 2  rr rr               .word (backsp_)     ; BS  ^H
00092Cr 2  rr rr               .word (empty_)      ; TAB ^I
00092Er 2  rr rr               .word (reedit_)     ; LF  ^J
000930r 2  rr rr               .word (empty_)      ; VT  ^K
000932r 2  rr rr               .word (list_)       ; FF  ^L
000934r 2  rr rr               .word (empty_)      ; CR  ^M
000936r 2  rr rr               .word (empty_)      ; SO  ^N
000938r 2  rr rr               .word (empty_)      ; SI  ^O
00093Ar 2  rr rr               .word (printStack_) ; DLE ^P
00093Cr 2  rr rr               .word (empty_)      ; DC1 ^Q
00093Er 2  rr rr               .word (empty_)      ; DC2 ^R
000940r 2  rr rr               .word (empty_)      ; DC3 ^S
000942r 2  rr rr               .word (empty_)      ; DC4 ^T
000944r 2  rr rr               .word (empty_)      ; NAK ^U
000946r 2  rr rr               .word (empty_)      ; SYN ^V
000948r 2  rr rr               .word (empty_)      ; ETB ^W
00094Ar 2  rr rr               .word (empty_)      ; CAN ^X
00094Cr 2  rr rr               .word (empty_)      ; EM  ^Y
00094Er 2  rr rr               .word (empty_)      ; SUB ^Z
000950r 2  rr rr               .word (empty_)      ; ESC ^[
000952r 2  rr rr               .word (empty_)      ; FS  ^\
000954r 2  rr rr               .word (empty_)      ; GS  ^]
000956r 2  rr rr               .word (empty_)      ; RS  ^^
000958r 2  rr rr               .word (empty_)      ; nos  ^_)
00095Ar 2  rr rr               .word (aNop_)       ; SP  ^`
00095Cr 2  rr rr               .word (cStore_)     ;    !
00095Er 2  rr rr               .word (aNop_)       ;    "
000960r 2  rr rr               .word (aNop_)       ;    #
000962r 2  rr rr               .word (aNop_)       ;    $  ( -- adr ) text input ptr
000964r 2  rr rr               .word (aNop_)       ;    %
000966r 2  rr rr               .word (aNop_)       ;    &
000968r 2  rr rr               .word (aNop_)       ;    '
00096Ar 2  rr rr               .word (ifte_)       ;    (  ( b -- )
00096Cr 2  rr rr               .word (aNop_)       ;    )
00096Er 2  rr rr               .word (aNop_)       ;    *
000970r 2  rr rr               .word (incr_)       ;    +  ( adr -- ) decrements variable at address
000972r 2  rr rr               .word (aNop_)       ;    ,
000974r 2  rr rr               .word (aNop_)       ;    -
000976r 2  rr rr               .word (aNop_)       ;    .
000978r 2  rr rr               .word (aNop_)       ;    /
00097Ar 2  rr rr               .word (aNop_)       ;    0
00097Cr 2  rr rr               .word (aNop_)       ;    1
00097Er 2  rr rr               .word (aNop_)       ;    2
000980r 2  rr rr               .word (aNop_)       ;    3
000982r 2  rr rr               .word (aNop_)       ;    4
000984r 2  rr rr               .word (aNop_)       ;    5
000986r 2  rr rr               .word (aNop_)       ;    6
000988r 2  rr rr               .word (aNop_)       ;    7
00098Ar 2  rr rr               .word (aNop_)       ;    8
00098Cr 2  rr rr               .word (aNop_)       ;    9
00098Er 2  rr rr               .word (aNop_)       ;    :  start defining a macro
000990r 2  rr rr               .word (aNop_)       ;    ;
000992r 2  rr rr               .word (aNop_)       ;    <
000994r 2  rr rr               .word (aNop_)       ;    =
000996r 2  rr rr               .word (aNop_)       ;    >
000998r 2  rr rr               .word (aNop_)       ;    ?
00099Ar 2  rr rr               .word (cFetch_)     ;    @
00099Cr 2  rr rr               .word (aNop_)       ;    A
00099Er 2  rr rr               .word (break_)      ;    B
0009A0r 2  rr rr               .word (nop_)        ;    C
0009A2r 2  rr rr               .word (depth_)      ;    D  ( -- val ) depth of data stack
0009A4r 2  rr rr               .word (emit_)       ;    E   ( val -- ) emits a char to output
0009A6r 2  rr rr               .word (aNop_)       ;    F
0009A8r 2  rr rr               .word (go_)         ;    G   ( -- ? ) execute mint definition
0009AAr 2  rr rr               .word (aNop_)       ;    H
0009ACr 2  rr rr               .word (inPort_)     ;    I  ( port -- val )
0009AEr 2  rr rr               .word (aNop_)       ;    J
0009B0r 2  rr rr               .word (key_)        ;    K  ( -- val )  read a char from input
0009B2r 2  rr rr               .word (aNop_)       ;    L
0009B4r 2  rr rr               .word (aNop_)       ;    M
0009B6r 2  rr rr               .word (newln_)      ;    N   ; prints a newline to output
0009B8r 2  rr rr               .word (outPort_)    ;    O  ( val port -- )
0009BAr 2  rr rr               .word (printStk_)   ;    P  ( -- ) non-destructively prints stack
0009BCr 2  rr rr               .word (aNop_)       ;    Q  quits from Mint REPL
0009BEr 2  rr rr               .word (rot_)        ;    R  ( a b c -- b c a )
0009C0r 2  rr rr               .word (aNop_)       ;    S
0009C2r 2  rr rr               .word (aNop_)       ;    T
0009C4r 2  rr rr               .word (aNop_)       ;    U
0009C6r 2  rr rr               .word (aNop_)       ;    V
0009C8r 2  rr rr               .word (aNop_)       ;    W   ; ( b -- ) if false, skip to end of loop
0009CAr 2  rr rr               .word (exec_)       ;    X
0009CCr 2  rr rr               .word (aNop_)       ;    Y
0009CEr 2  rr rr               .word (editDef_)    ;    Z
0009D0r 2  rr rr               .word (cArrDef_)    ;    [
0009D2r 2  rr rr               .word (comment_)    ;    \  comment text, skips reading until end of line
0009D4r 2  rr rr               .word (aNop_)       ;    ]
0009D6r 2  rr rr               .word (charCode_)   ;    ^
0009D8r 2  rr rr               .word (aNop_)       ;    _
0009DAr 2  rr rr               .word (aNop_)       ;    `
0009DCr 2  rr rr        vS0:        .word (sysVar_)     ;    a  ; start of data stack variable
0009DEr 2  rr rr        vBase16:    .word (sysVar_)     ;    b  ; base16 variable
0009E0r 2  rr rr        vTIBPtr:    .word (sysVar_)     ;    c  ; TIBPtr variable
0009E2r 2  rr rr        vDefs:      .word (sysVar_)     ;    d
0009E4r 2  rr rr        vEdited:    .word (sysVar_)     ;    e
0009E6r 2  rr rr        vR0:        .word (sysVar_)     ;    f
0009E8r 2  rr rr                    .word (sysVar_)     ;    g
0009EAr 2  rr rr        vHeapPtr:   .word (sysVar_)     ;    h  ; heap ptr variable
0009ECr 2  rr rr               .word (i_)          ;    i  ; returns index variable of current loop
0009EEr 2  rr rr               .word (j_)          ;    j  ; returns index variable of outer loop
0009F0r 2  rr rr               .word (sysVar_)     ;    k
0009F2r 2  rr rr               .word (sysVar_)     ;    l
0009F4r 2  rr rr               .word (sysVar_)     ;    m  ( a b -- c ) return the minimum value
0009F6r 2  rr rr               .word (sysVar_)     ;    n
0009F8r 2  rr rr               .word (sysVar_)     ;    o
0009FAr 2  rr rr               .word (sysVar_)     ;    p
0009FCr 2  rr rr               .word (sysVar_)     ;    q
0009FEr 2  rr rr               .word (sysVar_)     ;    r
000A00r 2  rr rr               .word (sysVar_)     ;    s
000A02r 2  rr rr               .word (sysVar_)     ;    t
000A04r 2  rr rr               .word (sysVar_)     ;    u
000A06r 2  rr rr               .word (sysVar_)     ;    v
000A08r 2  rr rr               .word (sysVar_)     ;    w
000A0Ar 2  rr rr               .word (sysVar_)     ;    x
000A0Cr 2  rr rr               .word (sysVar_)     ;    y
000A0Er 2  rr rr               .word (sysVar_)     ;    z
000A10r 2  rr rr               .word (group_)      ;    {
000A12r 2  rr rr               .word (aNop_)       ;    |
000A14r 2  rr rr               .word (endGroup_)   ;    }
000A16r 2  rr rr               .word (aNop_)       ;    ~
000A18r 2  rr rr               .word (aNop_)       ;    BS
000A1Ar 2               
000A1Ar 2               ; *********************************************************************
000A1Ar 2               ; Macros must be written in Mint and end with ;
000A1Ar 2               ; this code must not span pages
000A1Ar 2               ; *********************************************************************
000A1Ar 2               macros:
000A1Ar 2               
000A1Ar 2               .include "6502.MINT.macros.asm"
000A1Ar 3               empty_:
000A1Ar 3  3B 00                .asciiz ";"
000A1Cr 3               
000A1Cr 3               backsp_:
000A1Cr 3  BF BF 43 40          .asciiz "\\c@0=0=(1_\\c\\+`\b \b`);"
000A20r 3  30 3D 30 3D  
000A24r 3  28 31 A4 BF  
000A37r 3               
000A37r 3               reedit_:
000A37r 3  BF BF 45 BF          .asciiz "\\e\\@\\Z;"
000A3Br 3  BF 40 BF BF  
000A3Fr 3  DA 3B 00     
000A42r 3               
000A42r 3               edit_:
000A42r 3  AD 3F AD BF          .asciiz "`?`\\K\\N`> `\\^A-\\Z;"
000A46r 3  BF CB BF BF  
000A4Ar 3  CE AD 3E 20  
000A59r 3               
000A59r 3               list_:
000A59r 3  BF BF CE 32          .asciiz "\\N26(\\i@\\Z\\c@0>(\\N))\\N`> `;"
000A5Dr 3  36 28 BF BF  
000A61r 3  49 40 BF BF  
000A7Br 3               
000A7Br 3               printStack_:
000A7Br 3  AD 3D 3E 20          .asciiz "`=> `\\P\\N\\N`> `;"
000A7Fr 3  AD BF BF D0  
000A83r 3  BF BF CE BF  
000A8Fr 3               
000A8Fr 3               toggleBase_:
000A8Fr 3  BF BF 42 40          .asciiz "\\b@0=\\b!;"
000A93r 3  30 3D BF BF  
000A97r 3  42 21 3B 00  
000A9Br 3               
000A9Br 3               
000A9Br 2               
000A9Br 2               ; heap must be here !
000A9Br 2               
000A9Br 2               heap:
000A9Br 2               
000A9Br 2               
000A9Br 1               
000A9Br 1               
