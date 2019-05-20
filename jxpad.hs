%dll
JXPAD

%ver
1.00

%data
2019/05/05

%author
K-s

%url
https://

%note
jxpad.as をインストールしてください

%type
ユーザー拡張命令

%group
ゲームパッド入力取得処理

%port
Win

%portinfo
Windows 7 以降の環境が必要です

;------------------------------------------
%index
initPad
JXPADモジュールを初期化

%prm
flag, vk
flag : XInput 取得モード [(0),1]
vk : キーボード取得マップ

%inst
JXPADモジュールを初期化し、接続されているゲームパッドから入力情報を取得できるようにします。

flag に 1 を指定するとXInput用のゲームパッドのみ取得します。0 を指定もしくは省略した場合は接続された全てのゲームパッドを取得します。なおどちらの場合でもキーボードは取得されます。

vk には getInputButton でボタンとして取得できるキーボードの仮想キーコードマップ(16進数表記)を文字列として指定できます。例えばカーソルとアルファベットのキーだけを設定するときは "2528 415a" を指定します。省略時は初期値が設定されます。

命令後 stat に接続数が返ります。キーボードは必ず取得されるため少なくとも 1 以上の値が返ります。(stat-1)が他の命令で利用できるパッドIDの最大値になります。（例：3が返った場合、0,1,2が利用可能なパッドID）パッドID 0 はキーボード固定です。

JXPADでは複数のゲームパッドが接続されていても1つのパッドとして入力情報を取得できますが、どのパッドからの情報かを知りたいときは getInputButton などを利用して判別する必要があります。

;------------------------------------------
%index
getInputButton
押されているボタンを取得

%prm
(pid, flag)
pid : パッドID (0)
flag : 同時押し取得フラグ (0)

%inst
pid で指定したパッドの押されいているボタンを取得します。

キーボード（パッドID 0）の場合は仮想キーコードが、ゲームパッドの場合はボタンステート値が取得されます。何も押されていないときは 0 が返ります。キーボードの場合、initPad で指定した仮想キーコードマップ以外のキーコードは取得できません。

flag に 1 を指定すると同時に押してる複数のボタンを取得できます。キーボードの場合1バイトずつ計4、ゲームパッドの場合1ビットずつ最大32のボタン状態が返ります。

%sample
#include "jxpad.as"
	initPad
	num = stat
*mainLoop
	repeat num
		b = getInputButton(cnt)
		if b != 0 {
			dialog strf("パッドID %d のボタン $%x が押されました", cnt, b)
		}
	loop
	await 30
	goto *mainLoop

;------------------------------------------
%index
getAxisAll
軸のアナログ値を取得

%prm
axis, pid
axis : 軸のアナログ値が入る実数型配列変数
pid : パッドID (0)

%inst
pid で指定したパッドの全ての軸のアナログ値が axis に入ります。アナログ値は -1.0 ~ 1.0 の実数型で、軸の数だけ axis 配列変数に入っています。

命令後 stat に軸の数が返ります。

キーボード（パッドID 0）は軸がないため axis には全て 0.0、stat には 0 が返ります。

%sample
#include "jxpad.as"
	initPad ;1
	num = stat
*mainLoop
	redraw 0 : color 255, 255, 255 : boxf : color
	repeat num
		pos 10 + cnt * 100, 10
		mes "PadID:" + cnt
		getAxisAll ax, cnt
		repeat stat
			mes ax(cnt)
		loop
	loop
	redraw 1
	await 30
	goto *mainLoop

;------------------------------------------
%index
getTrigAll
トリガーのアナログ値を取得

%prm
trig, pid
trig : トリガーのアナログ値が入る実数型配列変数
pid : パッドID (0)

%inst
pid で指定したパッドの2つのトリガーアナログ値が trig に入ります。アナログ値は 0.0 ~ 1.0 の実数型です。

XInputのパッドのみトリガーの値が取得でき stat には 2 が返ります。

%sample
#include "jxpad.as"
	initPad 1
	num = stat
*mainLoop
	redraw 0 : color 255, 255, 255 : boxf : color
	repeat num
		pos 10 + cnt * 100, 10
		mes "PadID:" + cnt
		getTrigAll tr, cnt
		repeat stat
			mes tr(cnt)
		loop
	loop
	redraw 1
	await 30
	goto *mainLoop

;------------------------------------------
%index
getButtonMap
ボタンの割当を取得

%prm
(pid, btn)
pid : パッドID (0)
btn : ボタンID (PAD_LEFT)

%inst
pid で指定したパッドのボタンの割当を取得します。

ボタンIDについては padPress を参照してください。

%href
assignButton

;------------------------------------------
%index
assignButton
ボタンの割当を変更

%prm
pid, btn, code
pid : パッドID (0)
btn : ボタンID (PAD_LEFT)
code : ボタンコード (0)

%inst
pid で指定したパッドのボタン btn にボタンコード code を割り当てます。

ボタンIDについては padPress を参照してください。ゲームパッドの場合 PAD_BUTTON_** のみ指定できます。

code は基本的に getInputButton で得られるボタンの値を指定するようにしてください。

ボタンに割り当てたコードが他のボタンと重複していた場合は置き換えられます。その際重複先のボタンIDが stat に数値で返ります。重複していない場合は -1 が返ります。

%href
getButtonMap

;------------------------------------------
%index
getAxisNo
アナログ軸No.を取得

%prm
(pid, ax)
pid : パッドID (0)
ax : 軸ID (PAD_LSTICK_X)

%inst
pid で指定したパッドの軸ID ax の軸No.を取得します。

%href
assignAxis

;------------------------------------------
%index
getAxisRev
軸反転フラグを取得

%prm
(pid, ax)
pid : パッドID (0)
ax : 軸ID (PAD_LSTICK_X)

%inst
pid で指定したパッドの軸ID ax の反転フラグを取得します。

%href
assignAxis

;------------------------------------------
%index
assignAxis
軸の割当を変更

%prm
pid, ax, axn, rev
pid : パッドID (0)
ax : 軸ID (PAD_LSTICK_X)
axn : 軸No. (0)
rev : 反転フラグ (0)

%inst
pid で指定したパッドの軸ID ax に、軸No. axn を割り当てます。rev に 1 を指定すると軸の正負が反転します。

割り当てた軸が他の軸と重複していた場合は置き換えられます。その際重複先の軸IDが stat に数値で返ります。重複していない場合は -1 が返ります。

%href
getAxisNo
getAxisRev

;------------------------------------------
%index
getAxisBorder
軸の閾値を取得

%prm
(pid)
pid : パッドID (0)

%inst
pid で指定したパッドの左スティックの閾値を 0.01 ~ 0.99 の実数値として取得します。

%href
setAxisBorder

;------------------------------------------
%index
setAxisBorder
軸の閾値を設定

%prm
pid, border
pid : パッドID (0)
border : 閾値 [0.01 ~ 0.99]

%inst
pid で指定したパッドの左スティックの閾値を設定します。

JXPADでは enableAnalog でアナログ値を取得不可にした場合、左スティックの情報をデジタル方向（PAD_LEFT, _UP, _RIGHT, _DOWN）に変換しています。この変換の閾値がここで設定する値となります。

アナログ値の閾値（ニュートラル時のブレ防止）などはユーザー側のプログラムで処理してください。

%href
getAxisBorder

;------------------------------------------
%index
getTrigBorder
トリガーの閾値を取得

%prm
(pid)
pid : パッドID (0)

%inst
pid で指定したパッドのトリガーの閾値を 0.01 ~ 0.99 の実数値として取得します。

XInputのパッドのみ有効です。

%href
setTrigBorder

;------------------------------------------
%index
setTrigBorder
トリガーの閾値を設定

%prm
pid, border
pid : パッドID (0)
border : 閾値 [0.01 ~ 0.99]

%inst
pid で指定したパッドのトリガーの閾値を設定します。トリガーをボタンとして扱うときの閾値です。

XInputのパッドのみ有効です。

%href
getTrigBorder

;------------------------------------------
%index
setMultiPad
複数パッドの設定

%prm
sid, num, pids
sid : ステートID (0)
num : パッドIDの要素数
pids : パッドIDが入った配列

%inst
sid に関連付けるパッドIDを設定します。

JXPAD初期化時、ステートID 0 には接続された全てのパッド（キーボード）が関連付けされています。この命令を使うとステートID毎にパッドを変えることができ、2Pプレイ対応のゲームなどに利用できます。

ステートIDは 0 から順番に設定してください。同じIDを指定すると以前の設定が上書きされます。

%sample
#include "jxpad.as"
	initPad
	if stat < 3 : dialog "ゲームパッドを２つ接続してください" : end
	; キーボードとパッドAは1P側、パッドBは2P側のように設定する場合
	a = 0, 1
	setMultiPad 0, 2, a  ; ステートID 0 を 1P側
	a = 2
	setMultiPad 1, 1, a  ; ステートID 1 を 2P側
	num = 2
*mainLoop
	redraw 0 : color 255, 255, 255 : boxf : color
	pos 10, 10
	repeat num
		updatePad cnt
		if padPress(PAD_BUTTON_1, cnt) {
			mes strf("%dP が ボタン1 を押している！", cnt + 1)
		}
	loop
	redraw 1
	await 30
	goto *mainLoop

;------------------------------------------
%index
enableAnalog
アナログ値の取得設定

%prm
sid, flag
sid : ステートID (0)
flag : 取得フラグ (0)

%inst
ステートID sid のアナログ値を取得するかどうかを設定します。

ここでのアナログ値は padAnalog で得られるスティックやトリガーのアナログ値のことで、flag に 0 以上もしくは省略すると取得可に、負の値を指定すると取得不可に設定します。

アナログスティックの無いゲームパッドによっては取得可にすると PAD_LEFT などのデジタル方向が取れなくなるため、アナログ値が不必要なプログラムでは取得不可に設定してください。

JXPAD初期化時には取得不可に設定されています。

%href
padAnalog

;------------------------------------------
%index
updatePad
ステートの更新

%prm
sid
sid : ステートID (0)

%inst
ステートID sid のパッドの状態を更新します。

これにより padPress などのボタンや padAnalog の軸・トリガーの状態を更新できます。通常メインループ内で一度（複数のステートIDがある場合はその分だけ）実行してください。

実行後、ボタン状態を表す値が stat に返ります。この値は stick 命令のように複数のボタン情報が入ったもので、押しているボタンの値が全て加算されます。

1     ; PAD_LEFT
2     ; PAD_UP
4     ; PAD_RIGHT
8     ; PAD_DOWN
16    ; PAD_BUTTON_1
32    ; PAD_BUTTON_2
64    ; PAD_BUTTON_3
128   ; PAD_BUTTON_4
256   ; PAD_BUTTON_5
512   ; PAD_BUTTON_6
1024  ; PAD_BUTTON_7
2048  ; PAD_BUTTON_8
4096  ; PAD_BUTTON_9
8192  ; PAD_BUTTON_10
16384 ; PAD_BUTTON_11
32768 ; PAD_BUTTON_12

例えば方向ボタンのどれかが押されているかを判定したい場合、

updatePad
if stat & 15 : mes "方向ボタンが押されている"

のようにすると padPress で一つずつ判定するより効率がいいでしょう。

%sample
#include "jxpad.as"
	initPad
*mainLoop
	redraw 0 : color 255, 255, 255 : boxf : color
	pos 0, 0
	updatePad
	mes stat
	if padPress(PAD_BUTTON_1) : pos 0, 30 : mes "ボタン1が押されている"
	if padDown(PAD_BUTTON_1) : pos 0, 50 : mes "ボタン1が押された"
	if padUp(PAD_BUTTON_1) : pos 0, 70 : mes "ボタン1が離された"
	if padChanged(PAD_BUTTON_1) : pos 0, 90 : mes "ボタン1の状態が変わった"
	redraw 1
	await 100
	goto *mainLoop

%href
padPress
padChanged
padDown
padUp

;------------------------------------------
%index
padPress
ボタンの判定

%prm
(btn, sid)
btn : ボタンID (PAD_LEFT)
sid : ステートID (0)

%inst
ステートID sid のボタン btn が押されているかを取得します。

ボタンIDには次のいずれかを指定します。( )内はキーボードのデフォルトの割当です。

PAD_LEFT      : (←)
PAD_UP        : (↑)
PAD_RIGHT     : (→)
PAD_DOWN      : (↓)
PAD_BUTTON_1  : (Z)
PAD_BUTTON_2  : (X)
PAD_BUTTON_3  : (C)
PAD_BUTTON_4  : (V)
PAD_BUTTON_5  : (A)
PAD_BUTTON_6  : (S)
PAD_BUTTON_7  : (D)
PAD_BUTTON_8  : (F)
PAD_BUTTON_9  : (Enter)
PAD_BUTTON_10 : (Esc)
PAD_BUTTON_11 : (Shift)
PAD_BUTTON_12 : (Ctrl)

押されていれば 1、そうでなければ 0 が返ります。

%href
updatePad

;------------------------------------------
%index
padChanged
ボタンの判定

%prm
(btn, sid)
btn : ボタンID (PAD_LEFT)
sid : ステートID (0)

%inst
ステートID sid のボタン btn が前回の状態から変化したかを取得します。

変化していれば 1、そうでなければ 0 が返ります。

ボタンIDについては padPress を参照してください。

%href
updatePad

;------------------------------------------
%index
padDown
ボタンの判定

%prm
(btn, sid)
btn : ボタンID (PAD_LEFT)
sid : ステートID (0)

%inst
ステートID sid のボタン btn が離されている状態から押された状態になったか（押された瞬間）を取得します。

押された瞬間ならば 1、そうでなければ 0 が返ります。

ボタンIDについては padPress を参照してください。

%href
updatePad

;------------------------------------------
%index
padUp
ボタンの判定

%prm
(btn, sid)
btn : ボタンID (PAD_LEFT)
sid : ステートID (0)

%inst
ステートID sid のボタン btn が押されている状態から離された状態になったか（離された瞬間）を取得します。

離された瞬間ならば 1、そうでなければ 0 が返ります。

ボタンIDについては padPress を参照してください。

%href
updatePad

;------------------------------------------
%index
padAnalog
アナログ値を取得

%prm
(aid, sid)
aid : 軸ID or トリガーID (PAD_LSTICK_X)
sid : ステートID (0)

%inst
ステートID sid のアナログ値を取得します。

aid には次のいずれかを指定します。

PAD_LSTICK_X ; 左スティック X軸
PAD_LSTICK_Y ; 〃 Y軸
PAD_RSTICK_X ; 右スティック X軸
PAD_RSTICK_Y ; 〃 Y軸
PAD_LTRIGGER ; 左トリガー
PAD_RTRIGGER ; 右トリガー

スティックの場合は -1.0 ~ 1.0、トリガーの場合は 0.0 ~ 1.0 の値が返ります。

アナログ値を取得するには事前に enableAnalog で取得可に設定しておく必要があります。

%href
enableAnalog
