using System;
using System.Runtime.InteropServices;

namespace ServidorMouse
{
    class Teclado 
    {
        [DllImport("user32.dll")]
        static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

        public const int KEYEVENTF_KEYDOWN = 0x0000; // New definition
        public const int KEYEVENTF_EXTENDEDKEY = 0x0001; //Key down flag
        public const int KEYEVENTF_KEYUP = 0x0002; //Key up flag

        //Song Control
        public static void PlayPause() => PressOneKey(0xB3);
        public static void Stop() => PressOneKey(0xB2);
        public static void NextT() => PressOneKey(0xB0);
        public static void PreviousT() => PressOneKey(0xB1);

        //Volume Control
        public static void VolUp() => PressOneKey(0xAF);
        public static void VolDown() => PressOneKey(0xAE);
        public static void VolMute() => PressOneKey(0xAD);

        //Movimento Control
        public static void ArrowUp() => PressOneKey(0x26);
        public static void ArrowDown() => PressOneKey(0x28);
        public static void ArrowRight() => PressOneKey(0x27);
        public static void ArrowLeft() => PressOneKey(0x25);

        //Numeric
        public static void N0() => PressOneKey(0x30);
        public static void N1() => PressOneKey(0x31);
        public static void N2() => PressOneKey(0x32);
        public static void N3() => PressOneKey(0x33);
        public static void N4() => PressOneKey(0x34);
        public static void N5() => PressOneKey(0x35);
        public static void N6() => PressOneKey(0x36);
        public static void N7() => PressOneKey(0x37);
        public static void N8() => PressOneKey(0x38);
        public static void N9() => PressOneKey(0x39);

        //Alphabetic
        public static void A() => PressOneKey(0x41);
        public static void B() => PressOneKey(0x42);
        public static void C() => PressOneKey(0x43);
        public static void D() => PressOneKey(0x44);
        public static void E() => PressOneKey(0x45);
        public static void F() => PressOneKey(0x46);
        public static void G() => PressOneKey(0x47);
        public static void H() => PressOneKey(0x48);
        public static void I() => PressOneKey(0x49);
        public static void J() => PressOneKey(0x4A);
        public static void K() => PressOneKey(0x4B);
        public static void L() => PressOneKey(0x4C);
        public static void M() => PressOneKey(0x4D);
        public static void N() => PressOneKey(0x4E);
        public static void O() => PressOneKey(0x4F);
        public static void P() => PressOneKey(0x50);
        public static void Q() => PressOneKey(0x51);
        public static void R() => PressOneKey(0x52);
        public static void S() => PressOneKey(0x53);
        public static void T() => PressOneKey(0x54);
        public static void U() => PressOneKey(0x55);
        public static void V() => PressOneKey(0x56);
        public static void W() => PressOneKey(0x57);
        public static void X() => PressOneKey(0x58);
        public static void Y() => PressOneKey(0x59);
        public static void Z() => PressOneKey(0x5A);

        //Acentuuação
        public static void Virgula() => PressOneKey(0xBC);
        public static void Ponto() => PressOneKey(0xBE);
        public static void PontoVirgula() => PressOneKey(0xBA);
        //F Keys
        public static void F1() => PressOneKey(0x70);
        public static void F2() => PressOneKey(0x71);
        public static void F3() => PressOneKey(0x72);
        public static void F4() => PressOneKey(0x73);
        public static void F5() => PressOneKey(0x74);
        public static void F6() => PressOneKey(0x75);
        public static void F7() => PressOneKey(0x76);
        public static void F8() => PressOneKey(0x77);
        public static void F9() => PressOneKey(0x78);
        public static void F10() => PressOneKey(0x79);
        public static void F11() => PressOneKey(0x7A);
        public static void F12() => PressOneKey(0x7B);

        //Util Control
        public static void AltTab()
        {
            keybd_event(0xA4, 0, KEYEVENTF_KEYDOWN, (UIntPtr)0);
            keybd_event(0x09, 0, KEYEVENTF_KEYDOWN, (UIntPtr)0);
            keybd_event(0x09, 0, KEYEVENTF_KEYUP, (UIntPtr)0);
            keybd_event(0xA4, 0, KEYEVENTF_KEYUP, (UIntPtr)0);
        }
        public static void Space() => PressOneKey(0x20);
        public static void Esc() => PressOneKey(0x1B);
        public static void Enter() => PressOneKey(0x0D);
        public static void BackSpace() => PressOneKey(0x08);

        public static void AlterarCapsLock()
        {
            const int KEYEVENTF_EXTENDEDKEY = 0x1;
            const int KEYEVENTF_KEYUP = 0x2;
            keybd_event(0x14, 0x45, KEYEVENTF_EXTENDEDKEY, (UIntPtr)0);
            keybd_event(0x14, 0x45, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP,
            (UIntPtr)0);
        }

        static void PressOneKey(byte key)
        {
            keybd_event(key, 0, KEYEVENTF_KEYDOWN, (UIntPtr)0);
            keybd_event(key, 0, KEYEVENTF_KEYUP, (UIntPtr)0);
        }
    }
}
