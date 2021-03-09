using System;
using System.ComponentModel;
using System.Threading;
using System.Windows.Forms;

namespace MouseServer
{
    public partial class Form1 : Form
    {
        public delegate void AddListItem(string text);
        public AddListItem myDelegate;
        public Form1()
        {
            InitializeComponent();
            
            notifyIcon1.ContextMenuStrip = contextMenuStrip1;
            notifyIcon1.Visible = true;

            Thread t = new Thread(ExecutarThread);
            t.Start();

            myDelegate = new AddListItem(AddListItemMethod);
        }

        public void AddListItemMethod(string text)
        {
            lblconexao.Text =  text.Equals("Desconectado") ?  text :  "Conectado com " +   text.Split(':')[0] ;
        }

        void ExecutarThread()
        {
            try
            {
                Server.ExecuteServer(this);
            }catch(Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        private bool canClose = false;

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (!canClose)
            {
                e.Cancel = true;
                Hide();
            }
        }

        private void abrirToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Show();
        }

        private void finalizarToolStripMenuItem_Click(object sender, EventArgs e)
        {
            canClose = true;
            
            Dispose();
            Application.Exit();
            
        }

        private void notifyIcon1_DoubleClick(object sender, EventArgs e)
        {
            Show();
        }

        private void Ocultar()
        {
            Hide();
            notifyIcon1.Visible = true;
        }

        private void Form1_Shown(object sender, EventArgs e)
        {
            Ocultar();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            lblip.Text = RedeControl.getIp;
        }

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {

        }

        private void Form1_Activated(object sender, EventArgs e)
        {
        }

        private void Form1_VisibleChanged(object sender, EventArgs e)
        {
            
        }

        private void contextMenuStrip1_Opening(object sender, CancelEventArgs e)
        {

        }
    }
}
