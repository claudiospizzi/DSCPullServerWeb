using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Web;

namespace DSCPullServerWeb.Helpers
{
    public class ChecksumCalculator
    {
        public static string Create(string path)
        {
            SHA256 sha256 = SHA256.Create();

            byte[] hashRaw;
            string hashValue;

            using (FileStream fileStream = new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                fileStream.Position = 0;

                hashRaw = sha256.ComputeHash(fileStream);
                hashValue = BitConverter.ToString(hashRaw).Replace("-", "");
            }

            return hashValue;
        }

        public static bool Validate(string path, string value)
        {
            return Create(path) == value;
        }
    }
}