using DSCPullServerWeb.Helpers;
using System;
using System.IO;

namespace DSCPullServerWeb.Models
{
    public abstract class FileBase
    {
        protected FileInfo _dscFile;

        protected FileInfo _sumFile;
        private String v;
        private Stream stream;

        public FileBase(FileInfo dscFile)
        {
            _dscFile = dscFile;
            _sumFile = new FileInfo(_dscFile.FullName + ".checksum");
        }

        public FileInfo GetFileInfo()
        {
            return _dscFile;
        }

        public void Refresh()
        {
            if (_dscFile.Exists)
            {
                LoadChildProperties();

                Size           = _dscFile.Length;
                Created        = _dscFile.CreationTime;
                Checksum       = "";
                ChecksumStatus = "Missing";

                if (_sumFile.Exists)
                {
                    Checksum = File.ReadAllText(_sumFile.FullName);
                    ChecksumStatus = "Invalid";

                    if (ChecksumCalculator.Validate(_dscFile.FullName, Checksum))
                    {
                        ChecksumStatus = "Valid";
                    }
                }
            }
            else
            {
                throw new FileNotFoundException("File not found!", _dscFile.FullName);
            }
        }

        protected abstract void LoadChildProperties();

        public Int64 Size
        {
            get;
            private set;
        }

        public DateTime Created
        {
            get;
            private set;
        }

        public string Checksum
        {
            get;
            private set;
        }

        public string ChecksumStatus
        {
            get;
            private set;
        }
    }
}
