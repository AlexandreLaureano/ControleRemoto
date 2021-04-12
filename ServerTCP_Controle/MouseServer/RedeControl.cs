using System.Net;

namespace MouseServer
{
    static class RedeControl
    {
        static string hostName = Dns.GetHostName();

        public static string getIp => Dns.GetHostByName(hostName).AddressList[0].ToString();
    }
}
