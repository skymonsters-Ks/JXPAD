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
jxpad.as ���C���X�g�[�����Ă�������

%type
���[�U�[�g������

%group
�Q�[���p�b�h���͎擾����

%port
Win

%portinfo
Windows 7 �ȍ~�̊����K�v�ł�

;------------------------------------------
%index
initPad
JXPAD���W���[����������

%prm
flag, vk
flag : XInput �擾���[�h [(0),1]
vk : �L�[�{�[�h�擾�}�b�v

%inst
JXPAD���W���[�������������A�ڑ�����Ă���Q�[���p�b�h������͏����擾�ł���悤�ɂ��܂��B

flag �� 1 ���w�肷���XInput�p�̃Q�[���p�b�h�̂ݎ擾���܂��B0 ���w��������͏ȗ������ꍇ�͐ڑ����ꂽ�S�ẴQ�[���p�b�h���擾���܂��B�Ȃ��ǂ���̏ꍇ�ł��L�[�{�[�h�͎擾����܂��B

vk �ɂ� getInputButton �Ń{�^���Ƃ��Ď擾�ł���L�[�{�[�h�̉��z�L�[�R�[�h�}�b�v(16�i���\�L)�𕶎���Ƃ��Ďw��ł��܂��B�Ⴆ�΃J�[�\���ƃA���t�@�x�b�g�̃L�[������ݒ肷��Ƃ��� "2528 415a" ���w�肵�܂��B�ȗ����͏����l���ݒ肳��܂��B

���ߌ� stat �ɐڑ������Ԃ�܂��B�L�[�{�[�h�͕K���擾����邽�ߏ��Ȃ��Ƃ� 1 �ȏ�̒l���Ԃ�܂��B(stat-1)�����̖��߂ŗ��p�ł���p�b�hID�̍ő�l�ɂȂ�܂��B�i��F3���Ԃ����ꍇ�A0,1,2�����p�\�ȃp�b�hID�j�p�b�hID 0 �̓L�[�{�[�h�Œ�ł��B

JXPAD�ł͕����̃Q�[���p�b�h���ڑ�����Ă��Ă�1�̃p�b�h�Ƃ��ē��͏����擾�ł��܂����A�ǂ̃p�b�h����̏�񂩂�m�肽���Ƃ��� getInputButton �Ȃǂ𗘗p���Ĕ��ʂ���K�v������܂��B

;------------------------------------------
%index
getInputButton
������Ă���{�^�����擾

%prm
(pid, flag)
pid : �p�b�hID (0)
flag : ���������擾�t���O (0)

%inst
pid �Ŏw�肵���p�b�h�̉����ꂢ�Ă���{�^�����擾���܂��B

�L�[�{�[�h�i�p�b�hID 0�j�̏ꍇ�͉��z�L�[�R�[�h���A�Q�[���p�b�h�̏ꍇ�̓{�^���X�e�[�g�l���擾����܂��B����������Ă��Ȃ��Ƃ��� 0 ���Ԃ�܂��B�L�[�{�[�h�̏ꍇ�AinitPad �Ŏw�肵�����z�L�[�R�[�h�}�b�v�ȊO�̃L�[�R�[�h�͎擾�ł��܂���B

flag �� 1 ���w�肷��Ɠ����ɉ����Ă镡���̃{�^�����擾�ł��܂��B�L�[�{�[�h�̏ꍇ1�o�C�g���v4�A�Q�[���p�b�h�̏ꍇ1�r�b�g���ő�32�̃{�^����Ԃ��Ԃ�܂��B

%sample
#include "jxpad.as"
	initPad
	num = stat
*mainLoop
	repeat num
		b = getInputButton(cnt)
		if b != 0 {
			dialog strf("�p�b�hID %d �̃{�^�� $%x ��������܂���", cnt, b)
		}
	loop
	await 30
	goto *mainLoop

;------------------------------------------
%index
getAxisAll
���̃A�i���O�l���擾

%prm
axis, pid
axis : ���̃A�i���O�l����������^�z��ϐ�
pid : �p�b�hID (0)

%inst
pid �Ŏw�肵���p�b�h�̑S�Ă̎��̃A�i���O�l�� axis �ɓ���܂��B�A�i���O�l�� -1.0 ~ 1.0 �̎����^�ŁA���̐����� axis �z��ϐ��ɓ����Ă��܂��B

���ߌ� stat �Ɏ��̐����Ԃ�܂��B

�L�[�{�[�h�i�p�b�hID 0�j�͎����Ȃ����� axis �ɂ͑S�� 0.0�Astat �ɂ� 0 ���Ԃ�܂��B

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
�g���K�[�̃A�i���O�l���擾

%prm
trig, pid
trig : �g���K�[�̃A�i���O�l����������^�z��ϐ�
pid : �p�b�hID (0)

%inst
pid �Ŏw�肵���p�b�h��2�̃g���K�[�A�i���O�l�� trig �ɓ���܂��B�A�i���O�l�� 0.0 ~ 1.0 �̎����^�ł��B

XInput�̃p�b�h�̂݃g���K�[�̒l���擾�ł� stat �ɂ� 2 ���Ԃ�܂��B

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
�{�^���̊������擾

%prm
(pid, btn)
pid : �p�b�hID (0)
btn : �{�^��ID (PAD_LEFT)

%inst
pid �Ŏw�肵���p�b�h�̃{�^���̊������擾���܂��B

�{�^��ID�ɂ��Ă� padPress ���Q�Ƃ��Ă��������B

%href
assignButton

;------------------------------------------
%index
assignButton
�{�^���̊�����ύX

%prm
pid, btn, code
pid : �p�b�hID (0)
btn : �{�^��ID (PAD_LEFT)
code : �{�^���R�[�h (0)

%inst
pid �Ŏw�肵���p�b�h�̃{�^�� btn �Ƀ{�^���R�[�h code �����蓖�Ă܂��B

�{�^��ID�ɂ��Ă� padPress ���Q�Ƃ��Ă��������B�Q�[���p�b�h�̏ꍇ PAD_BUTTON_** �̂ݎw��ł��܂��B

code �͊�{�I�� getInputButton �œ�����{�^���̒l���w�肷��悤�ɂ��Ă��������B

�{�^���Ɋ��蓖�Ă��R�[�h�����̃{�^���Əd�����Ă����ꍇ�͒u���������܂��B���̍ۏd����̃{�^��ID�� stat �ɐ��l�ŕԂ�܂��B�d�����Ă��Ȃ��ꍇ�� -1 ���Ԃ�܂��B

%href
getButtonMap

;------------------------------------------
%index
getAxisNo
�A�i���O��No.���擾

%prm
(pid, ax)
pid : �p�b�hID (0)
ax : ��ID (PAD_LSTICK_X)

%inst
pid �Ŏw�肵���p�b�h�̎�ID ax �̎�No.���擾���܂��B

%href
assignAxis

;------------------------------------------
%index
getAxisRev
�����]�t���O���擾

%prm
(pid, ax)
pid : �p�b�hID (0)
ax : ��ID (PAD_LSTICK_X)

%inst
pid �Ŏw�肵���p�b�h�̎�ID ax �̔��]�t���O���擾���܂��B

%href
assignAxis

;------------------------------------------
%index
assignAxis
���̊�����ύX

%prm
pid, ax, axn, rev
pid : �p�b�hID (0)
ax : ��ID (PAD_LSTICK_X)
axn : ��No. (0)
rev : ���]�t���O (0)

%inst
pid �Ŏw�肵���p�b�h�̎�ID ax �ɁA��No. axn �����蓖�Ă܂��Brev �� 1 ���w�肷��Ǝ��̐��������]���܂��B

���蓖�Ă��������̎��Əd�����Ă����ꍇ�͒u���������܂��B���̍ۏd����̎�ID�� stat �ɐ��l�ŕԂ�܂��B�d�����Ă��Ȃ��ꍇ�� -1 ���Ԃ�܂��B

%href
getAxisNo
getAxisRev

;------------------------------------------
%index
getAxisBorder
����臒l���擾

%prm
(pid)
pid : �p�b�hID (0)

%inst
pid �Ŏw�肵���p�b�h�̍��X�e�B�b�N��臒l�� 0.01 ~ 0.99 �̎����l�Ƃ��Ď擾���܂��B

%href
setAxisBorder

;------------------------------------------
%index
setAxisBorder
����臒l��ݒ�

%prm
pid, border
pid : �p�b�hID (0)
border : 臒l [0.01 ~ 0.99]

%inst
pid �Ŏw�肵���p�b�h�̍��X�e�B�b�N��臒l��ݒ肵�܂��B

JXPAD�ł� enableAnalog �ŃA�i���O�l���擾�s�ɂ����ꍇ�A���X�e�B�b�N�̏����f�W�^�������iPAD_LEFT, _UP, _RIGHT, _DOWN�j�ɕϊ����Ă��܂��B���̕ϊ���臒l�������Őݒ肷��l�ƂȂ�܂��B

�A�i���O�l��臒l�i�j���[�g�������̃u���h�~�j�Ȃǂ̓��[�U�[���̃v���O�����ŏ������Ă��������B

%href
getAxisBorder

;------------------------------------------
%index
getTrigBorder
�g���K�[��臒l���擾

%prm
(pid)
pid : �p�b�hID (0)

%inst
pid �Ŏw�肵���p�b�h�̃g���K�[��臒l�� 0.01 ~ 0.99 �̎����l�Ƃ��Ď擾���܂��B

XInput�̃p�b�h�̂ݗL���ł��B

%href
setTrigBorder

;------------------------------------------
%index
setTrigBorder
�g���K�[��臒l��ݒ�

%prm
pid, border
pid : �p�b�hID (0)
border : 臒l [0.01 ~ 0.99]

%inst
pid �Ŏw�肵���p�b�h�̃g���K�[��臒l��ݒ肵�܂��B�g���K�[���{�^���Ƃ��Ĉ����Ƃ���臒l�ł��B

XInput�̃p�b�h�̂ݗL���ł��B

%href
getTrigBorder

;------------------------------------------
%index
setMultiPad
�����p�b�h�̐ݒ�

%prm
sid, num, pids
sid : �X�e�[�gID (0)
num : �p�b�hID�̗v�f��
pids : �p�b�hID���������z��

%inst
sid �Ɋ֘A�t����p�b�hID��ݒ肵�܂��B

JXPAD���������A�X�e�[�gID 0 �ɂ͐ڑ����ꂽ�S�Ẵp�b�h�i�L�[�{�[�h�j���֘A�t������Ă��܂��B���̖��߂��g���ƃX�e�[�gID���Ƀp�b�h��ς��邱�Ƃ��ł��A2P�v���C�Ή��̃Q�[���Ȃǂɗ��p�ł��܂��B

�X�e�[�gID�� 0 ���珇�Ԃɐݒ肵�Ă��������B����ID���w�肷��ƈȑO�̐ݒ肪�㏑������܂��B

%sample
#include "jxpad.as"
	initPad
	if stat < 3 : dialog "�Q�[���p�b�h���Q�ڑ����Ă�������" : end
	; �L�[�{�[�h�ƃp�b�hA��1P���A�p�b�hB��2P���̂悤�ɐݒ肷��ꍇ
	a = 0, 1
	setMultiPad 0, 2, a  ; �X�e�[�gID 0 �� 1P��
	a = 2
	setMultiPad 1, 1, a  ; �X�e�[�gID 1 �� 2P��
	num = 2
*mainLoop
	redraw 0 : color 255, 255, 255 : boxf : color
	pos 10, 10
	repeat num
		updatePad cnt
		if padPress(PAD_BUTTON_1, cnt) {
			mes strf("%dP �� �{�^��1 �������Ă���I", cnt + 1)
		}
	loop
	redraw 1
	await 30
	goto *mainLoop

;------------------------------------------
%index
enableAnalog
�A�i���O�l�̎擾�ݒ�

%prm
sid, flag
sid : �X�e�[�gID (0)
flag : �擾�t���O (0)

%inst
�X�e�[�gID sid �̃A�i���O�l���擾���邩�ǂ�����ݒ肵�܂��B

�����ł̃A�i���O�l�� padAnalog �œ�����X�e�B�b�N��g���K�[�̃A�i���O�l�̂��ƂŁAflag �� 0 �ȏ�������͏ȗ�����Ǝ擾�ɁA���̒l���w�肷��Ǝ擾�s�ɐݒ肵�܂��B

�A�i���O�X�e�B�b�N�̖����Q�[���p�b�h�ɂ���Ă͎擾�ɂ���� PAD_LEFT �Ȃǂ̃f�W�^�����������Ȃ��Ȃ邽�߁A�A�i���O�l���s�K�v�ȃv���O�����ł͎擾�s�ɐݒ肵�Ă��������B

JXPAD���������ɂ͎擾�s�ɐݒ肳��Ă��܂��B

%href
padAnalog

;------------------------------------------
%index
updatePad
�X�e�[�g�̍X�V

%prm
sid
sid : �X�e�[�gID (0)

%inst
�X�e�[�gID sid �̃p�b�h�̏�Ԃ��X�V���܂��B

����ɂ�� padPress �Ȃǂ̃{�^���� padAnalog �̎��E�g���K�[�̏�Ԃ��X�V�ł��܂��B�ʏ탁�C�����[�v���ň�x�i�����̃X�e�[�gID������ꍇ�͂��̕������j���s���Ă��������B

���s��A�{�^����Ԃ�\���l�� stat �ɕԂ�܂��B���̒l�� stick ���߂̂悤�ɕ����̃{�^����񂪓��������̂ŁA�����Ă���{�^���̒l���S�ĉ��Z����܂��B

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

�Ⴆ�Ε����{�^���̂ǂꂩ��������Ă��邩�𔻒肵�����ꍇ�A

updatePad
if stat & 15 : mes "�����{�^����������Ă���"

�̂悤�ɂ���� padPress �ň�����肷��������������ł��傤�B

%sample
#include "jxpad.as"
	initPad
*mainLoop
	redraw 0 : color 255, 255, 255 : boxf : color
	pos 0, 0
	updatePad
	mes stat
	if padPress(PAD_BUTTON_1) : pos 0, 30 : mes "�{�^��1��������Ă���"
	if padDown(PAD_BUTTON_1) : pos 0, 50 : mes "�{�^��1�������ꂽ"
	if padUp(PAD_BUTTON_1) : pos 0, 70 : mes "�{�^��1�������ꂽ"
	if padChanged(PAD_BUTTON_1) : pos 0, 90 : mes "�{�^��1�̏�Ԃ��ς����"
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
�{�^���̔���

%prm
(btn, sid)
btn : �{�^��ID (PAD_LEFT)
sid : �X�e�[�gID (0)

%inst
�X�e�[�gID sid �̃{�^�� btn ��������Ă��邩���擾���܂��B

�{�^��ID�ɂ͎��̂����ꂩ���w�肵�܂��B( )���̓L�[�{�[�h�̃f�t�H���g�̊����ł��B

PAD_LEFT      : (��)
PAD_UP        : (��)
PAD_RIGHT     : (��)
PAD_DOWN      : (��)
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

������Ă���� 1�A�����łȂ���� 0 ���Ԃ�܂��B

%href
updatePad

;------------------------------------------
%index
padChanged
�{�^���̔���

%prm
(btn, sid)
btn : �{�^��ID (PAD_LEFT)
sid : �X�e�[�gID (0)

%inst
�X�e�[�gID sid �̃{�^�� btn ���O��̏�Ԃ���ω����������擾���܂��B

�ω����Ă���� 1�A�����łȂ���� 0 ���Ԃ�܂��B

�{�^��ID�ɂ��Ă� padPress ���Q�Ƃ��Ă��������B

%href
updatePad

;------------------------------------------
%index
padDown
�{�^���̔���

%prm
(btn, sid)
btn : �{�^��ID (PAD_LEFT)
sid : �X�e�[�gID (0)

%inst
�X�e�[�gID sid �̃{�^�� btn ��������Ă����Ԃ��牟���ꂽ��ԂɂȂ������i�����ꂽ�u�ԁj���擾���܂��B

�����ꂽ�u�ԂȂ�� 1�A�����łȂ���� 0 ���Ԃ�܂��B

�{�^��ID�ɂ��Ă� padPress ���Q�Ƃ��Ă��������B

%href
updatePad

;------------------------------------------
%index
padUp
�{�^���̔���

%prm
(btn, sid)
btn : �{�^��ID (PAD_LEFT)
sid : �X�e�[�gID (0)

%inst
�X�e�[�gID sid �̃{�^�� btn ��������Ă����Ԃ��痣���ꂽ��ԂɂȂ������i�����ꂽ�u�ԁj���擾���܂��B

�����ꂽ�u�ԂȂ�� 1�A�����łȂ���� 0 ���Ԃ�܂��B

�{�^��ID�ɂ��Ă� padPress ���Q�Ƃ��Ă��������B

%href
updatePad

;------------------------------------------
%index
padAnalog
�A�i���O�l���擾

%prm
(aid, sid)
aid : ��ID or �g���K�[ID (PAD_LSTICK_X)
sid : �X�e�[�gID (0)

%inst
�X�e�[�gID sid �̃A�i���O�l���擾���܂��B

aid �ɂ͎��̂����ꂩ���w�肵�܂��B

PAD_LSTICK_X ; ���X�e�B�b�N X��
PAD_LSTICK_Y ; �V Y��
PAD_RSTICK_X ; �E�X�e�B�b�N X��
PAD_RSTICK_Y ; �V Y��
PAD_LTRIGGER ; ���g���K�[
PAD_RTRIGGER ; �E�g���K�[

�X�e�B�b�N�̏ꍇ�� -1.0 ~ 1.0�A�g���K�[�̏ꍇ�� 0.0 ~ 1.0 �̒l���Ԃ�܂��B

�A�i���O�l���擾����ɂ͎��O�� enableAnalog �Ŏ擾�ɐݒ肵�Ă����K�v������܂��B

%href
enableAnalog
