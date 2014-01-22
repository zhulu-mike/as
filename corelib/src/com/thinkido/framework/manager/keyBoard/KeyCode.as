package com.thinkido.framework.manager.keyBoard
{
    public class KeyCode extends Object
    {
		/**
		 * 数字键 
		 */        
        public static const Num0:uint = 48;
		public static const Num1:uint = 49;
        public static const Num2:uint = 50;
        public static const Num3:uint = 51;
        public static const Num4:uint = 52;
        public static const Num5:uint = 53;
        public static const Num6:uint = 54;
        public static const Num7:uint = 55;
        public static const Num8:uint = 56;
        public static const Num9:uint = 57;
		
		/**
		 * 数字键盘上的数字 
		 */		
        public static const Numpad0:uint = 96;
        public static const Numpad1:uint = 97;
        public static const Numpad2:uint = 98;
        public static const Numpad3:uint = 99;
        public static const Numpad4:uint = 100;
        public static const Numpad5:uint = 101;
        public static const Numpad6:uint = 102;
        public static const Numpad7:uint = 103;
        public static const Numpad8:uint = 104;
        public static const Numpad9:uint = 105;
		
        public static const A:uint = 65;
        public static const B:uint = 66;
        public static const C:uint = 67;
        public static const D:uint = 68;
        public static const E:uint = 69;
        public static const F:uint = 70;
        public static const G:uint = 71;
        public static const H:uint = 72;
        public static const I:uint = 73;
        public static const J:uint = 74;
        public static const K:uint = 75;
        public static const L:uint = 76;
        public static const M:uint = 77;
        public static const N:uint = 78;
        public static const O:uint = 79;
        public static const P:uint = 80;
        public static const Q:uint = 81;
        public static const R:uint = 82;
        public static const S:uint = 83;
        public static const T:uint = 84;
        public static const U:uint = 85;
        public static const V:uint = 86;
        public static const W:uint = 87;
        public static const X:uint = 88;
        public static const Y:uint = 89;
        public static const Z:uint = 90;
		
        public static const F1:uint = 112;
        public static const F2:uint = 113;
        public static const F3:uint = 114;
        public static const F4:uint = 115;
        public static const F5:uint = 116;
        public static const F6:uint = 117;
        public static const F7:uint = 118;
        public static const F8:uint = 119;
        public static const F9:uint = 120;
        public static const F10:uint = 121;
        public static const F11:uint = 122;
        public static const F12:uint = 123;
		
		public static const NUMPAD_MULTIPLY:int = 106;
		public static const NUMPAD_ADD:int = 107;
		public static const NUMPAD_ENTER:int = 108;
		public static const NUMPAD_SUBTRACT:int = 109;
		public static const NUMPAD_DECIMAL:int = 110;
		public static const NUMPAD_DIVIDE:int = 111;
		
		
		public static const COLON:int = 186;
		public static const EQUALS:int = 187;
		public static const UNDERSCORE:int = 189;
		public static const QUESTION_MARK:int = 191;
		public static const OPEN_BRACKET:int = 219;
		public static const BACKWARD_SLASH:int = 220;
		public static const CLOSED_BRACKET:int = 221;
		public static const QUOTES:int = 222;
		public static const BACKSPACE:int = 8;
		public static const TAB:int = 9;
		public static const CLEAR:int = 12;
		public static const CAPS_LOCK:int = 20;
		public static const PAGE_UP:int = 33;
		public static const PAGE_DOWN:int = 34;
		public static const END:int = 35;
		public static const HOME:int = 36;
		public static const INSERT:int = 45;
		public static const DELETE:int = 46;
		public static const HELP:int = 47;
		public static const NUM_LOCK:int = 144;
		/**
		 *  `~ 
		 */
        public static const TILDE:uint = 192;
		
		
		public static const SPACE:uint = 32;
		public static const ENTER:uint = 13;
		public static const ESCAPE:uint = 27;
		public static const CONTROL:uint = 17;
		public static const SHIFT:uint = 16;
		public static const ALT:uint = 18;
		public static const LEFT:uint = 37;
		public static const UP:uint = 38;
		public static const RIGHT:uint = 39;
		public static const DOWN:uint = 40;
		/*
		 * 
		keycode对照表：
		字母和数字键的键码值(keyCode)
		按键 键码 按键 键码 按键 键码 按键 键码
		A 65 J 74 S 83 1 49
		B 66 K 75 T 84 2 50
		C 67 L 76 U 85 3 51
		D 68 M 77 V 86 4 52
		E 69 N 78 W 87 5 53
		F 70 O 79 X 88 6 54
		G 71 P 80 Y 89 7 55
		H 72 Q 81 Z 90 8 56
		I 73 R 82 0 48 9 57
		数字键盘上的键的键码值(keyCode) 功能键键码值(keyCode)
		按键 键码 按键 键码 按键 键码 按键 键码
		0 96 8 104 F1 112 F7 118
		1 97 9 105 F2 113 F8 119
		2 98 * 106 F3 114 F9 120
		3 99 + 107 F4 115 F10 121
		4 100 Enter 108 F5 116 F11 122
		5 101 - 109 F6 117 F12 123
		6 102 . 110
		7 103 / 111
		控制键键码值(keyCode)
		按键 键码 按键 键码 按键 键码 按键 键码
		BackSpace 8 Esc 27 Right Arrow 39 -_ 189
		Tab 9 Spacebar 32 Dw Arrow 40 .> 190
		Clear 12 Page Up 33 Insert 45 /? 191
		Enter 13 Page Down 34 Delete 46 `~ 192
		Shift 16 End 35 Num Lock 144 [{ 219
		Control 17 Home 36 ;: 186 \| 220
		Alt 18 Left Arrow 37 =+ 187 ]} 221
		Cape Lock 20 Up Arrow 38 ,< 188 ‘” 222
		多媒体键码值(keyCode)
		按键 键码 按键 键码 按键 键码 按键 键码
		音量加 175
		音量减 174
		停止 179
		静音 173
		浏览器 172
		邮件 180
		搜索 170
		收藏 171
		*/

        public function KeyCode()
        {
            return;
        }

    }
}
