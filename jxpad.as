#module jxpad

#uselib "winmm"
#func joyGetPosEx "joyGetPosEx" int, var
#func joyGetDevCaps "joyGetDevCapsA" int, var, int

#uselib "xinput1_3"
#func XInputGetState "XInputGetState" int, var

; ボタンID
#enum global PAD_LEFT = 0
#enum global PAD_UP
#enum global PAD_RIGHT
#enum global PAD_DOWN
#enum global PAD_BUTTON_1
#enum global PAD_BUTTON_2
#enum global PAD_BUTTON_3
#enum global PAD_BUTTON_4
#enum global PAD_BUTTON_5
#enum global PAD_BUTTON_6
#enum global PAD_BUTTON_7
#enum global PAD_BUTTON_8
#enum global PAD_BUTTON_9
#enum global PAD_BUTTON_10
#enum global PAD_BUTTON_11
#enum global PAD_BUTTON_12
#enum DIG_KEY_NUM

; 軸ID
#enum global PAD_LSTICK_X = 0
#enum global PAD_LSTICK_Y
#enum global PAD_RSTICK_X
#enum global PAD_RSTICK_Y
#enum AXIS_NUM

; トリガーID
#enum global PAD_LTRIGGER = AXIS_NUM
#enum global PAD_RTRIGGER
#enum ANA_KEY_NUM

#const TRIGGER_NUM      2
#const STAT_NUM         16
#const DEV_MAX          16
#const JOYCAPS_SIZE     404
#const JOY_DEV_MAX      16
#const XINPUT_DEV_MAX   4
#const XINPUT_AXIS_NUM  4
#const DEV_AXIS_MAX     6

#enum TYPE_KEYBOARD = 0
#enum TYPE_XINPUT
#enum TYPE_JOY

#const PI_D4 M_PI / 4
#const PI_D8 M_PI / 8


#deffunc initPad_ int _flag, str _vk
#define global initPad(%1=0, %2="") initPad_ %1, %2

	if (initConst = 0) {
		initConst = 1

		sdim vkmap, 256 ; ボタンとして取得できる仮想キーコードマップ
		vknum = 0
		if (_vk == "") {
			ts = "0809 0c0d 1315 1719 1b39 415d 5f87 9091 a0a5 bac0 dbde e2e2 1012"
		} else {
			ts = _vk
		}
		split ts, " ", res
		repeat stat
			for k, int("$" + strmid(res(cnt) ,0, 2)), int("$" + strmid(res(cnt) ,2, 2)) + 1
				poke vkmap, vknum, k
				vknum++
			next
		loop

		dim xstat, 4 ; XINPUT_STATE
		dim jstat, 13 ; JOYINFOEX
		jstat = 52, 255 ; size, JOY_RETURNALL
		povbit = %_0011_0001_1001_1000_1100_0100_0110_0010
		dirbit = %_0110_0010_0011_0001_1001_1000_1100_0100

		dim defkm, DIG_KEY_NUM, 3

		defkm(0,  TYPE_KEYBOARD) = $25, $26, $27, $28 ; ←, ↑, →, ↓
		defkm(4,  TYPE_KEYBOARD) = $5a, $58, $43, $56 ; Z, X, C, V
		defkm(8,  TYPE_KEYBOARD) = $41, $53, $44, $46 ; A, S, D, F
		defkm(12, TYPE_KEYBOARD) = $0d, $1b, $10, $11 ; enter, esc, shift, ctrl

		defkm(0,  TYPE_XINPUT) = $4,    $1,    $8,    $2    ; ←, ↑, →, ↓
		defkm(4,  TYPE_XINPUT) = $1000, $2000, $4000, $8000 ; A, B, X, Y
		defkm(8,  TYPE_XINPUT) = $100,  $200,  $400,  $800  ; LS, RS, LTr, RTr
		defkm(12, TYPE_XINPUT) = $10,   $20,   $40,   $80   ; start, back, LT, RT

		repeat DIG_KEY_NUM - 4 ; Joyの方向キーはアサイン不可
			defkm(cnt + 4, TYPE_JOY) = 1 << cnt
		loop
	}

	devcnt = 0
	dim inputType
	dim inputId ; xinput id | joystick id

	inputType(0) = TYPE_KEYBOARD
	inputId(0) = 0
	devcnt++

	if (_flag) {
		if (varptr(XInputGetState)) {
			repeat XINPUT_DEV_MAX
				XInputGetState cnt, xstat
				if (stat == 0) {
					inputType(devcnt) = TYPE_XINPUT
					inputId(devcnt) = cnt
					devcnt++
				}
			loop
		}
	} else {
		dim usePovdir
		repeat JOY_DEV_MAX
			joyGetPosEx cnt, jstat
			if (stat == 0) {
				getJoyCaps cnt, jc
				usePovdir(cnt) = (jc(24) & $20) > 0
				inputType(devcnt) = TYPE_JOY
				inputId(devcnt) = cnt
				devcnt++
			}
		loop
	}

	dim keymap, DIG_KEY_NUM, devcnt
	ddim trigBorder, devcnt
	ddim axisBorder, devcnt
	dim axisCenter, DEV_AXIS_MAX, devcnt
	dim axisRange, DEV_AXIS_MAX, devcnt
	dim axisRev, AXIS_NUM, devcnt
	dim axisNo, AXIS_NUM, devcnt
	dim axisNum, devcnt

	repeat DIG_KEY_NUM
		keymap(cnt, 0) = defkm(cnt, TYPE_KEYBOARD)
	loop

	repeat devcnt - 1, 1 : id = cnt
		repeat DIG_KEY_NUM
			keymap(cnt, id) = defkm(cnt, inputType(id))
		loop
		setAxisBorder id, 0.5
		if (_flag) {
			axisNum(id) = XINPUT_AXIS_NUM
			repeat XINPUT_AXIS_NUM
				axisCenter(cnt, id) = 0
				axisRange(cnt, id) = $ffff
				assignAxis id, cnt, cnt
			loop
			setTrigBorder id, 0.5
		} else {
			getJoyCaps inputId(id), jc
			axisNum(id) = jc(26)
			if (axisNum(id) >= 2) { ; 軸数が2以上だと軸1,2は使用されているものとする（軸3~6はJOYCAPS.wCapsで判定できる）
				axbit = 0b11 + ((jc(24) & $f) << 2)
			} else { ; 軸数1以下は除外（たとえ1があってもスティックとして使えない）
				axbit = 0
			}
			xflag = (axisNum(id) == 5) & (jc(24) & $7 == $7) ; XInputかも
			ac = 0
			repeat DEV_AXIS_MAX
				if ((axbit & (1 << cnt)) == 0) : continue
				i = cnt * 2 + 9 + (cnt > 2) * 3
				axisCenter(cnt, id) = (jc(i + 1) + jc(i)) / 2
				axisRange(cnt, id) = jc(i + 1) - jc(i)
				if (ac < 4) {
					if (xflag) {
						switch cnt
						case 0
						case 1
							assignAxis id, ac, cnt
							swbreak
						case 2
							continue
						case 3
						case 4
							assignAxis id, 3 - (cnt - 3), cnt
							swbreak
						swend
					} else {
						assignAxis id, ac, cnt
					}
					ac++
				}
			loop
		}
	loop

	dim digstat, STAT_NUM, 2
	ddim anastat, ANA_KEY_NUM, STAT_NUM

	dim anaflag, STAT_NUM
	dim vtable, STAT_NUM, DEV_MAX
	dim sidcnt, STAT_NUM 
	
	dim defids
	repeat devcnt
		defids(cnt) = cnt
	loop
	setMultiPad 0, devcnt, defids

	return devcnt


#deffunc getInputDev array _dev, int _id

	_dev = inputType(_id), inputId(_id)
	return


#deffunc getJoyCaps int _jid, array _jc

	dim _jc, JOYCAPS_SIZE / 4
	joyGetDevCaps _jid, _jc, JOYCAPS_SIZE
	return stat ; 0で正常

	/* JOYCAPS(404) {
	 0:wMid(2), wPid(2)
	 1:szPname(32)
	 9:wXmin, wXmax, wYmin, wYmax, wZmin, wZmax
	 15:wNumButtons
	 16:wPeriodMin, wPeriodMax
	 18:wRmin, wRmax, wUmin, wUmax, wVmin, wVmax
	 24:wCaps
	 25:wMaxAxes, wNumAxes, wMaxButtons
	 28:szRegKey(32)
	 36:szOEMVxD(260)
	}
	; wCaps
	JOYCAPS_HASZ	$1
	JOYCAPS_HASR	$2
	JOYCAPS_HASU	$4
	JOYCAPS_HASV	$8
	JOYCAPS_HASPOV	$10
	JOYCAPS_POV4DIR	$20
	JOYCAPS_POVCTS	$40
	*/

#defcfunc getLSButton int _stat

	r = 0
	repeat 32
		r = _stat & (1 << cnt)
		if (r) : break
	loop
	return r


#defcfunc getInputButton int _id, int _f

	r = 0
	f = _f > 0
	switch inputType(_id)
	case TYPE_KEYBOARD
		p = 0
		repeat vknum
			v = peek(vkmap, cnt)
			getkey k, v
			if (k) {
				poke r, p, v
				if (f) && (p < 3) {
					p++
				} else {
					break
				}
			}
		loop
		swbreak
	case TYPE_XINPUT
		XInputGetState inputId(_id), xstat
		b = wpeek(xstat, 4)
		repeat 2
			if (trigBorder(_id) * 255 < peek(xstat, 6 + cnt)) : b |= $400 << cnt
		loop
		r = b & $fff0 ; ←, ↑, →, ↓ は除外
		if (f) : else {
			r = getLSButton(r)
		}
		swbreak
	case TYPE_JOY
		joyGetPosEx inputId(_id), jstat
		if (f) {
			r = jstat(8)
		} else {
			r = getLSButton(jstat(8))
		}
		swbreak
	swend
	return r


#deffunc getAxisAll array _axa, int _id

	r = 0
	ddim _axa, DEV_AXIS_MAX
	switch inputType(_id)
	case TYPE_XINPUT
		XInputGetState inputId(_id), xstat
		repeat XINPUT_AXIS_NUM
			_axa(cnt) = 2.0 * (wpeek(xstat, 8 + cnt * 2) << 16 >> 16) * (1 - cnt \ 2 * 2) / axisRange(cnt, _id)
		loop
		r = XINPUT_AXIS_NUM
		swbreak
	case TYPE_JOY
		joyGetPosEx inputId(_id), jstat
		foreach _axa
			if (axisRange(cnt, _id) == 0) {
				_axa(cnt) = 0.0
			} else {
				_axa(cnt) = 2.0 * (lpeek(jstat, 8 + cnt * 4) - axisCenter(cnt, _id)) / axisRange(cnt, _id)
			}
		loop
		r = DEV_AXIS_MAX
		swbreak
	swend
	return r


#deffunc getTrigAll array _trg, int _id

	r = 0
	ddim _trg, TRIGGER_NUM
	if (inputType(_id) == TYPE_XINPUT) {
		XInputGetState inputId(_id), xstat
		repeat TRIGGER_NUM
			_trg(cnt) = double(peek(xstat, 6 + cnt)) / 255
			r++
		loop
	}
	return r


#defcfunc getButtonMap int _id, int _k

	return keymap(_k, _id)

#deffunc assignButton int _id, int _k, int _c

	r = -1
	switch inputType(_id)
	case TYPE_KEYBOARD
		c = _c & $ff
		s = 0
		swbreak
	case TYPE_XINPUT
		c = getLSButton(_c & $fff0)
		s = 4
		swbreak
	case TYPE_JOY
		c = getLSButton(_c)
		s = 4
		swbreak
	swend
	if (_k < s || _k >= DIG_KEY_NUM) : return r
	repeat DIG_KEY_NUM - s, s
		if (cnt == _k) : continue
		if (c == keymap(cnt, _id)) {
			keymap(cnt, _id) = keymap(_k, _id)
			r = cnt
			break
		}
	loop
	keymap(_k, _id) = c
	return r

#defcfunc getAxisNo int _id, int _ax

	return axisNo(_ax, _id)

#defcfunc getAxisRev int _id, int _ax

	return axisRev(_ax, _id) != 1

#deffunc assignAxis int _id, int _ax, int _axn, int _rev

	r = -1
	if (inputType(_id) == TYPE_KEYBOARD) : return r
	if (_axn < 0 || _axn >= DEV_AXIS_MAX) : return r
	repeat AXIS_NUM
		if (cnt == _ax) : continue
		if (_axn == axisNo(cnt, _id)) {
			axisNo(cnt, _id) = axisNo(_ax, _id)
			axisRev(cnt, _id) = axisRev(_ax, _id)
			r = cnt
			break
		}
	loop
	axisNo(_ax, _id) = _axn
	axisRev(_ax, _id) = (_rev == 0) * 2 - 1
	return r

#defcfunc getAxisBorder int _id

	return axisBorder(_id)

#deffunc setAxisBorder int _id, double _t

	if (inputType(_id) != TYPE_KEYBOARD) {
		axisBorder(_id) = limitf(_t, 0.01, 0.99)
	}
	return

#defcfunc getTrigBorder int _id

	return trigBorder(_id)

#deffunc setTrigBorder int _id, double _t

	if (inputType(_id) == TYPE_XINPUT) {
		trigBorder(_id) = limitf(_t, 0.01, 0.99)
	}
	return

#deffunc setMultiPad int _sid, int _n, array _ids

	repeat _n
		vtable(_sid, cnt) = _ids(cnt)
	loop
	sidcnt(_sid) = _n
	return

#deffunc enableAnalog int _sid, int _f

	anaflag(_sid) = _f >= 0
	return

#deffunc updatePad int _sid

	dstat = 0
	ana = anaflag(_sid)
	if (ana) {
		ddim axis, AXIS_NUM
		ddim trig, TRIGGER_NUM
	}

	repeat sidcnt(_sid)

		id = vtable(_sid, cnt)

		switch inputType(id)

		case TYPE_KEYBOARD

			repeat DIG_KEY_NUM
				getkey k, keymap(cnt, id)
				dstat |= k << cnt
			loop
			swbreak

		case TYPE_XINPUT

			XInputGetState inputId(id), xstat
			dup dupstat, xstat
			getter = *getXAxis
			gosub *setAxisAndDigitalDir
			b = wpeek(xstat, 4)
			repeat 2
				trg = peek(xstat, 6 + cnt)
				if (ana) {
					trig(cnt) = limitf(trig(cnt) + double(trg) / 255, 0, 1)
				} else {
					if (trigBorder(id) * 255 < trg) : b |= $400 << cnt
				}
			loop
			repeat DIG_KEY_NUM
				dstat |= ((b & keymap(cnt, id)) > 0) << cnt
			loop
			swbreak

		case TYPE_JOY

			jid = inputId(id)
			joyGetPosEx jid, jstat
			dup dupstat, jstat
			getter = *getJAxis
			gosub *setAxisAndDigitalDir
			if (usePovdir(jid)) {
				if (wpeek(jstat(10)) != $ffff) {
					dstat |= (povbit >> jstat(10) / 4500 * 4) & $f
				}
			}
			repeat DIG_KEY_NUM - 4, 4
				dstat |= ((jstat(8) & keymap(cnt, id)) > 0) << cnt
			loop
			swbreak

		swend

	loop

	digstat(_sid, 1) = digstat(_sid)
	digstat(_sid) = dstat
	if (ana) {
		anastat(0, _sid) = axis, axis(1), axis(2), axis(3), trig, trig(1)
	}

	return dstat

*setAxisAndDigitalDir
	if (ana) {
		repeat limit(axisNum(id), 0, AXIS_NUM)
			no = axisNo(cnt, id)
			gosub getter
			axis(cnt) = limitf(axis(cnt) + refdval * axisRev(cnt, id), -1, 1)
		loop
	} else {
		if ((axisNum(id) >= 2)) {
			no = axisNo(PAD_LSTICK_X, id) : gosub getter : x = refdval * axisRev(PAD_LSTICK_X, id)
			no = axisNo(PAD_LSTICK_Y, id) : gosub getter : y = refdval * axisRev(PAD_LSTICK_Y, id)
			if (sqrt(x * x + y * y) >= axisBorder(id)) {
				dstat |= (dirbit >> double(0 + ((atan(y, x) / PI_D4 + 8) \ 8 + 0.5)) * 4) & $f
			}
		}
	}
	return
*getXAxis
	return 2.0 * ((wpeek(dupstat, 8 + no * 2) << 16 >> 16) * (1 - no \ 2 * 2) - axisCenter(no, id)) / axisRange(no, id)
*getJAxis
	return 2.0 * (lpeek(dupstat, 8 + no * 4) - axisCenter(no, id)) / axisRange(no, id)


#defcfunc padPress int _k, int _sid
	return (digstat(_sid) & 1 << _k) > 0

#defcfunc padChanged int _k, int _sid
	return ((digstat(_sid) ^ digstat(_sid, 1)) & 1 << _k) > 0

#defcfunc padDown int _k, int _sid
	return ((digstat(_sid) ^ digstat(_sid, 1)) & digstat(_sid) & 1 << _k) > 0

#defcfunc padUp int _k, int _sid
	return ((digstat(_sid) ^ digstat(_sid, 1)) & digstat(_sid, 1) & 1 << _k) > 0

#defcfunc padAnalog int _a, int _sid
	return anastat(_a, _sid)

#global
