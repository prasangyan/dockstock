﻿using System;
using System.Drawing;
using System.Drawing.Imaging;

namespace ImageUtils
{
    class ImageTransparency
    {
        public static Bitmap ChangeOpacity(Image img, float opacityvalueAsAPercentage)
        {
            float opacityvalue = opacityvalueAsAPercentage / 100;
            Bitmap bmp = new Bitmap(img.Width, img.Height); // Determining Width and Height of Source Image
            Graphics graphics = Graphics.FromImage(bmp);
            ColorMatrix colormatrix = new ColorMatrix();
            colormatrix.Matrix33 = opacityvalue;
            ImageAttributes imgAttribute = new ImageAttributes();
            imgAttribute.SetColorMatrix(colormatrix, ColorMatrixFlag.Default, ColorAdjustType.Bitmap);
            graphics.DrawImage(img, new Rectangle(0, 0, bmp.Width, bmp.Height), 0, 0, img.Width, img.Height, GraphicsUnit.Pixel, imgAttribute);
            graphics.Dispose();   // Releasing all resource used by graphics
            return bmp;
        }
    }
}
