// Todo: Add padding for the text box
// Todo: See if there is some way to calculate the spacing between elements. Right now I have just done it visually.
// Todo: Make the window dragable
// Todo: Add an animation for the connect button. It feels too sudden right now
// Todo: Add a click state for the button
// Todo: The connect button should rever back the original state after a hover.
// Todo: Add a tansition style to the button here, Exspecially the main page.

/*
 * Transition code taken from: http://www.dreamincode.net/forums/topic/144337-picturebox-image-transitions/
 * Opacity code taken from: http://raviranjankr.wordpress.com/2011/05/25/change-opacity-of-image-in-c/
 */
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Threading;

namespace MetroUI
{
    public partial class Form1 : Form
    {
        DropShadow ds = new DropShadow();

        /*
        private const int CS_DROPSHADOW = 0x20000;
        protected override CreateParams CreateParams
        {
            get
            {
                CreateParams cp = base.CreateParams;
                cp.ClassStyle |= CS_DROPSHADOW;
                return cp;
            }
        }
        */
        public Form1()
        {
            InitializeComponent();
            this.Shown += new EventHandler(Form1_Shown);
            this.Resize += new EventHandler(Form1_Resize);
            this.LocationChanged += new EventHandler(Form1_Resize);
        }

        void Form1_Shown(object sender, EventArgs e)
        {
            Rectangle rc = this.Bounds;
            rc.Inflate(10, 10);
            ds.Bounds = rc;
            ds.Show();
            this.BringToFront();
        }

        void Form1_Resize(object sender, EventArgs e)
        {
            ds.Visible = (this.WindowState == FormWindowState.Normal);
            if (ds.Visible)
            {
                Rectangle rc = this.Bounds;
                rc.Inflate(10, 10);
                ds.Bounds = rc;
            }
            this.BringToFront();
        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {

        }

        private void closeWindow_MouseHover(object sender, EventArgs e)
        {
            this.closeWindow.Image = Properties.Resources.closeHover;
        }

        private void closeWindow_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void connectBtn_MouseHover(object sender, EventArgs e)
        {
            this.connectBtn.Image = Properties.Resources.connectButton_Hover;
            /*Bitmap bm = null;
            bm = Properties.Resources.connectButton_Hover;
            Filter(bm);*/

            /*
            // Using this code to change the opacity of the image
            for (int i = 100; i > 0; i-=3)
            {
                connectBtn.Image = ImageUtils.ImageTransparency.ChangeOpacity(Properties.Resources.connectButton_Normal, i);
                Thread.Sleep(4);
            }
            for (int i = 0; i < 100; i+=1)
            {
                connectBtn.Image = ImageUtils.ImageTransparency.ChangeOpacity(Properties.Resources.connectButton_Hover, i);
                Thread.Sleep(1);
            }
            */
        }
        
        private void connectBtn_MouseLeave(object sender, EventArgs e)
        {
            this.connectBtn.Image = Properties.Resources.connectButton_Normal;
        }

        private void connectBtn_Click(object sender, EventArgs e)
        {
            this.connectBtn.Image = Properties.Resources.connectButton_Activel;
        }

        private void closeWindow_MouseLeave(object sender, EventArgs e)
        {
            this.closeWindow.Image = Properties.Resources.closeDefault;
        }
        
    }

    public class DropShadow : Form
    {
        
        public DropShadow()
        {
            this.Opacity = 0.2;
            this.BackColor = Color.Gray;
            this.ShowInTaskbar = false;
            this.FormBorderStyle = FormBorderStyle.None;
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private const int WS_EX_TRANSPARENT = 0x20;
        private const int WS_EX_NOACTIVATE = 0x8000000;

        protected override System.Windows.Forms.CreateParams CreateParams
        {
            get
            {
                CreateParams cp = base.CreateParams;
                cp.ExStyle = cp.ExStyle | WS_EX_TRANSPARENT | WS_EX_NOACTIVATE;
                return cp;
            }
        }

    }

}
