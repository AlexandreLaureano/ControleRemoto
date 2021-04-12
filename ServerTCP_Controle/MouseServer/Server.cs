using ServidorMouse;
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace MouseServer
{
    public static class Server
    {
        private const int portNum = 11111;
        static Form1 myFormControl1;

        public static void ExecuteServer(Form1 myForm)
        {
            
            myFormControl1 = myForm;
            bool done = false;
            TcpListener listener;

            try
            {
                listener = new TcpListener(IPAddress.Any, portNum);

                listener.Start();

                byte[] bytes = new byte[1024];
                while (true)
                {
                    Console.Write("Waiting for connection...");
                    TcpClient client = listener.AcceptTcpClient();

                    Console.WriteLine("Connection accepted.");
                    NetworkStream ns = client.GetStream();

                    myFormControl1.Invoke(myFormControl1.myDelegate, new object[] {client.Client.RemoteEndPoint.ToString()});

                    ns.Write(Encoding.UTF8.GetBytes("ON"), 0, 2);

                    while (!done && client.Connected) 
                    {
                        int bytesRead = ns.Read(bytes, 0, bytes.Length);
                        string msg = Encoding.ASCII.GetString(bytes, 0, bytesRead);
                        if (msg.Equals("done"))
                        {
                            done = true;
                        }
                        else
                        {
                            RunCommand(msg);
                        }
                    } 
                    done = false;

                    ns.Write(Encoding.UTF8.GetBytes("OFF"), 0, 3);
                    myFormControl1.Invoke(myFormControl1.myDelegate, new object[] { "Desconectado" });

                    ns.Close();
                    client.Close();
                } 
               
            }
            catch (System.IO.IOException ex)
            {
                Console.WriteLine("travou " + ex.ToString());
            }
            catch (Exception e)
            {
                Console.WriteLine("EX" + e.ToString());
            }
           
        }
        static void RunCommand(string msg)
        {
            if (msg.Split(';')[0] == "mov")
            {
                Mouse.MoveMouse(msg.Split(';')[1], msg.Split(';')[2]);
            }
            else
            {
                switch (msg)
                {
                    case "volUp":       Teclado.VolUp();        break;
                    case "volDown":     Teclado.VolDown();      break;
                    case "volMute":     Teclado.VolMute();      break;
                    case "play":        Teclado.PlayPause();    break;
                    case "next":        Teclado.NextT();        break;
                    case "previous":    Teclado.PreviousT();    break;
                    case "stop":        Teclado.Stop();         break;
                    case "space":       Teclado.Space();        break;
                    case "tab":         Teclado.AltTab();       break;
                    case "leftclick":   Mouse.LeftClick();      break;
                    case "rightclick":  Mouse.RightClick();     break;
                    case "middleclick": Mouse.MiddleClick();    break;
                    case "doubleclick": Mouse.DoubleClick();    break;
                    case "esc":         Teclado.Esc();          break;
                    case "up":          Teclado.ArrowUp();      break;
                    case "down":        Teclado.ArrowDown();    break;
                    case "left":        Teclado.ArrowLeft();    break;
                    case "right":       Teclado.ArrowRight();   break;
                    case "enter":       Teclado.Enter();        break;
                    case "back":        Teclado.BackSpace();    break;
                        //alfabeto
                    case "a": Teclado.A(); break;
                    case "b": Teclado.B(); break;
                    case "c": Teclado.C(); break;
                    case "d": Teclado.D(); break;
                    case "e": Teclado.E(); break;
                    case "f": Teclado.F(); break;
                    case "g": Teclado.G(); break;
                    case "h": Teclado.H(); break;
                    case "i": Teclado.I(); break;
                    case "j": Teclado.J(); break;
                    case "k": Teclado.K(); break;
                    case "l": Teclado.L(); break;
                    case "m": Teclado.M(); break;
                    case "n": Teclado.N(); break;
                    case "o": Teclado.O(); break;
                    case "p": Teclado.P(); break;
                    case "q": Teclado.Q(); break;
                    case "r": Teclado.R(); break;
                    case "s": Teclado.S(); break;
                    case "t": Teclado.T(); break;
                    case "u": Teclado.U(); break;
                    case "v": Teclado.V(); break;
                    case "w": Teclado.W(); break;
                    case "x": Teclado.X(); break;
                    case "y": Teclado.Y(); break;
                    case "z": Teclado.Z(); break;
                    //acentos
                    case ",": Teclado.Virgula(); break;
                    case ".": Teclado.Ponto(); break;
                    case ";": Teclado.PontoVirgula(); break;
                        //numérico
                    case "1": Teclado.N1(); break;
                    case "2": Teclado.N2(); break;
                    case "3": Teclado.N3(); break;
                    case "4": Teclado.N4(); break;
                    case "5": Teclado.N5(); break;
                    case "6": Teclado.N6(); break;
                    case "7": Teclado.N7(); break;
                    case "8": Teclado.N8(); break;
                    case "9": Teclado.N9(); break;
                    case "0": Teclado.N0(); break;
                    //F
                    case "F1": Teclado.F1(); break;
                    case "F2": Teclado.F2(); break;
                    case "F3": Teclado.F3(); break;
                    case "F4": Teclado.F4(); break;
                    case "F5": Teclado.F5(); break;
                    case "F6": Teclado.F6(); break;
                    case "F7": Teclado.F7(); break;
                    case "F8": Teclado.F8(); break;
                    case "F9": Teclado.F9(); break;
                    case "F10": Teclado.F10(); break;
                    case "F11": Teclado.F11(); break;
                    case "F122": Teclado.F12(); break;
                    default:
                        break;
                }
            }
        }


    }
}
