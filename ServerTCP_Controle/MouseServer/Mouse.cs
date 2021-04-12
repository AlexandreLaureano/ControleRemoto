using System;
using System.Runtime.InteropServices;
using System.Threading;
using System.Drawing;

using FlaUI.Core.Input;

namespace ServidorMouse
{
    static class Mouse
    {
        [DllImport("user32")]
        private static extern int mouse_event(int dwFlags, int dx, int dy, int cButtons, int dwExtraInfo);
        [DllImport("user32.dll")]
        public extern static bool GetCursorPos(out POINT pot);
        [DllImport("user32.dll")]
        static extern void SetCursorPos(int x, int y);
        // Move the mouse
        const int MOUSEEVENTF_MOVE = 0x0001;
        // Simulate the left mouse button press
        const int MOUSEEVENTF_LEFTDOWN = 0x0002;
        // Simulate the left mouse button to lift
        const int MOUSEEVENTF_LEFTUP = 0x0004;
        // Simulate the right mouse button press
        const int MOUSEEVENTF_RIGHTDOWN = 0x0008;
        // Simulate the right mouse button up
        const int MOUSEEVENTF_RIGHTUP = 0x0010;
        // Simulate the middle mouse button press
        const int MOUSEEVENTF_MIDDLEDOWN = 0x0020;
        // Simulate the middle mouse button to lift
        const int MOUSEEVENTF_MIDDLEUP = 0x0040;
        // Indicate whether to use absolute coordinates
        const int MOUSEEVENTF_ABSOLUTE = 0x8000;

        public struct POINT
        {
            public int X;
            public int Y;
        }


      
        public static void LeftClick()
        {
            POINT point;
            GetCursorPos(out point);
            mouse_event(MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP, point.X, point.Y, 0, 0);
        }

        public static void RightClick()
        {
            POINT point;
            GetCursorPos(out point);
            mouse_event(MOUSEEVENTF_RIGHTDOWN | MOUSEEVENTF_RIGHTUP, point.X, point.Y, 0, 0);
        }

        public static void MiddleClick()
        {
            POINT point;
            GetCursorPos(out point);
            mouse_event(MOUSEEVENTF_MIDDLEDOWN | MOUSEEVENTF_MIDDLEUP, point.X, point.Y, 0, 0);
        }

        public static void DoubleClick()
        {
            POINT point;
            GetCursorPos(out point);
            mouse_event(MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP, point.X, point.Y, 0, 0);
            Thread.Sleep(50);
            mouse_event(MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP, point.X, point.Y, 0, 0);
        }

      
        public static void MoveMouse22(string x, string y)
        {

            var diffX = double.Parse(x) * -1;
            var diffY = double.Parse(y) * -1;

            double x1, y1;
            POINT point;
            GetCursorPos(out point);
            var targetX = point.X - double.Parse(x);
            var targetY = point.Y - double.Parse(y);

            double delta = Math.Sqrt(Math.Pow(targetX - point.X, 2) + Math.Pow(targetY - point.Y, 2));
            double movX = diffX / delta;
            double movY = diffY / delta;
            x1 = point.X;
            y1 = point.Y;

            for (int i = 1; i <= delta; i++)
            {
                if (x1 != targetX) x1 = (point.X + (movX * i));
                if (y1 != targetY) y1 = (point.Y + (movY * i));

                SetCursorPos((int)x1, (int)y1);
                //  Thread.Sleep(1);
            }

            if (point.X != targetX && point.Y != targetY)
            {
                SetCursorPos((int)targetX, (int)targetY);
            }
        }

         public static void MoveMouse(string x, string y)
        {
            var currentPosition = Position;      
            int newX = int.Parse(x) *-1 + currentPosition.X;
            int newY = int.Parse(y) *-1 + currentPosition.Y;
           // Get starting position
            var startPos = Position;
            var endPos = new Point(newX, newY);

            
            // Break out if there is no positional change
            if (startPos == endPos)
            {
                return;
            }

            // Calculate some values for duration and interval
            var totalDistance = startPos.Distance(newX, newY);
            var duration = TimeSpan.FromMilliseconds(1);// FromMilliseconds(Convert.ToInt32(totalDistance / MovePixelsPerMillisecond));
            var steps = Math.Max(Convert.ToInt32(totalDistance / MovePixelsPerStep), 1); // Make sure to have et least one step
            var interval = TimeSpan.FromMilliseconds(duration.TotalMilliseconds / steps);

            // Execute the movement
            Interpolation.Execute(point => { Position = point; }, startPos, endPos, duration, interval, true);
            Wait.UntilInputIsProcessed();
          
        }
        public static Point Position
        {
            get
            {
                GetCursorPos(out var point);
                return new Point(point.X, point.Y);
            }
            set
            {
                SetCursorPos(value.X, value.Y);
                // There is a bug that in a multi-monitor scenario with different sizes,
                // the mouse is only moved to x=0 on the target monitor.
                // In that case, just redo the move a 2nd time and it works
                // as the mouse is on the correct monitor alreay.
                // See https://stackoverflow.com/questions/58753372/winapi-setcursorpos-seems-like-not-working-properly-on-multiple-monitors-with-di
                GetCursorPos(out var point);
                if (point.X != value.X || point.Y != value.Y)
                {
                    SetCursorPos(value.X, value.Y);
                }
            }
        }

        public static double Distance(this Point self, double otherX, double otherY) => Math.Sqrt(Math.Pow(self.X - otherX, 2) + Math.Pow(self.Y - otherY, 2));

        public static double MovePixelsPerMillisecond { get; set; } = 3;

        public static double MovePixelsPerStep { get; set; } =10;

     }
}
