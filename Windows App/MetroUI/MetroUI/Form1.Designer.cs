namespace MetroUI
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.emailIdLbl = new System.Windows.Forms.Label();
            this.fieldDescriptionLbl = new System.Windows.Forms.Label();
            this.emailAddresstxtFld = new System.Windows.Forms.TextBox();
            this.passwordTxtFld = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.passwordLbl = new System.Windows.Forms.Label();
            this.connectBtn = new System.Windows.Forms.PictureBox();
            this.closeWindow = new System.Windows.Forms.PictureBox();
            this.pictureBox2 = new System.Windows.Forms.PictureBox();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.fadeTimer = new System.Windows.Forms.Timer(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.connectBtn)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.closeWindow)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // emailIdLbl
            // 
            this.emailIdLbl.AutoSize = true;
            this.emailIdLbl.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.emailIdLbl.ForeColor = System.Drawing.Color.Gray;
            this.emailIdLbl.Location = new System.Drawing.Point(3, 45);
            this.emailIdLbl.Name = "emailIdLbl";
            this.emailIdLbl.Size = new System.Drawing.Size(53, 21);
            this.emailIdLbl.TabIndex = 3;
            this.emailIdLbl.Text = "Email";
            // 
            // fieldDescriptionLbl
            // 
            this.fieldDescriptionLbl.AutoSize = true;
            this.fieldDescriptionLbl.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.fieldDescriptionLbl.ForeColor = System.Drawing.Color.Silver;
            this.fieldDescriptionLbl.Location = new System.Drawing.Point(3, 66);
            this.fieldDescriptionLbl.Name = "fieldDescriptionLbl";
            this.fieldDescriptionLbl.Size = new System.Drawing.Size(343, 21);
            this.fieldDescriptionLbl.TabIndex = 4;
            this.fieldDescriptionLbl.Text = "Enter the email address you signed up with here";
            // 
            // emailAddresstxtFld
            // 
            this.emailAddresstxtFld.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.emailAddresstxtFld.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(64)))), ((int)(((byte)(64)))), ((int)(((byte)(64)))));
            this.emailAddresstxtFld.Location = new System.Drawing.Point(7, 92);
            this.emailAddresstxtFld.Name = "emailAddresstxtFld";
            this.emailAddresstxtFld.Size = new System.Drawing.Size(382, 29);
            this.emailAddresstxtFld.TabIndex = 5;
            // 
            // passwordTxtFld
            // 
            this.passwordTxtFld.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.passwordTxtFld.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(64)))), ((int)(((byte)(64)))), ((int)(((byte)(64)))));
            this.passwordTxtFld.Location = new System.Drawing.Point(6, 186);
            this.passwordTxtFld.Name = "passwordTxtFld";
            this.passwordTxtFld.Size = new System.Drawing.Size(381, 29);
            this.passwordTxtFld.TabIndex = 8;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.Silver;
            this.label1.Location = new System.Drawing.Point(2, 160);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(314, 21);
            this.label1.TabIndex = 7;
            this.label1.Text = "Enter the password you signed up with here";
            // 
            // passwordLbl
            // 
            this.passwordLbl.AutoSize = true;
            this.passwordLbl.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.passwordLbl.ForeColor = System.Drawing.Color.Gray;
            this.passwordLbl.Location = new System.Drawing.Point(2, 139);
            this.passwordLbl.Name = "passwordLbl";
            this.passwordLbl.Size = new System.Drawing.Size(82, 21);
            this.passwordLbl.TabIndex = 6;
            this.passwordLbl.Text = "Password";
            // 
            // connectBtn
            // 
            this.connectBtn.Image = global::MetroUI.Properties.Resources.connectButton_Normal;
            this.connectBtn.Location = new System.Drawing.Point(211, 238);
            this.connectBtn.Name = "connectBtn";
            this.connectBtn.Size = new System.Drawing.Size(178, 50);
            this.connectBtn.TabIndex = 9;
            this.connectBtn.TabStop = false;
            this.connectBtn.Click += new System.EventHandler(this.connectBtn_Click);
            this.connectBtn.MouseLeave += new System.EventHandler(this.connectBtn_MouseLeave);
            this.connectBtn.MouseHover += new System.EventHandler(this.connectBtn_MouseHover);
            // 
            // closeWindow
            // 
            this.closeWindow.Image = global::MetroUI.Properties.Resources.closeDefault;
            this.closeWindow.Location = new System.Drawing.Point(376, 12);
            this.closeWindow.Name = "closeWindow";
            this.closeWindow.Size = new System.Drawing.Size(12, 12);
            this.closeWindow.TabIndex = 2;
            this.closeWindow.TabStop = false;
            this.closeWindow.Click += new System.EventHandler(this.closeWindow_Click);
            this.closeWindow.MouseLeave += new System.EventHandler(this.closeWindow_MouseLeave);
            this.closeWindow.MouseHover += new System.EventHandler(this.closeWindow_MouseHover);
            // 
            // pictureBox2
            // 
            this.pictureBox2.Image = global::MetroUI.Properties.Resources.topStrip;
            this.pictureBox2.Location = new System.Drawing.Point(12, 0);
            this.pictureBox2.Name = "pictureBox2";
            this.pictureBox2.Size = new System.Drawing.Size(400, 4);
            this.pictureBox2.TabIndex = 1;
            this.pictureBox2.TabStop = false;
            this.pictureBox2.Click += new System.EventHandler(this.pictureBox2_Click);
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = global::MetroUI.Properties.Resources.windowsAppLogo;
            this.pictureBox1.Location = new System.Drawing.Point(-1, 0);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(100, 30);
            this.pictureBox1.TabIndex = 0;
            this.pictureBox1.TabStop = false;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.ClientSize = new System.Drawing.Size(400, 300);
            this.Controls.Add(this.connectBtn);
            this.Controls.Add(this.passwordTxtFld);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.passwordLbl);
            this.Controls.Add(this.emailAddresstxtFld);
            this.Controls.Add(this.fieldDescriptionLbl);
            this.Controls.Add(this.emailIdLbl);
            this.Controls.Add(this.closeWindow);
            this.Controls.Add(this.pictureBox2);
            this.Controls.Add(this.pictureBox1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.connectBtn)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.closeWindow)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.PictureBox pictureBox2;
        private System.Windows.Forms.PictureBox closeWindow;
        private System.Windows.Forms.Label emailIdLbl;
        private System.Windows.Forms.Label fieldDescriptionLbl;
        private System.Windows.Forms.TextBox emailAddresstxtFld;
        private System.Windows.Forms.TextBox passwordTxtFld;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label passwordLbl;
        private System.Windows.Forms.PictureBox connectBtn;
        private System.Windows.Forms.Timer fadeTimer;
    }
}

