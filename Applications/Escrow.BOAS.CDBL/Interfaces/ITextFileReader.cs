using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.CDBL.Interfaces
{
    public interface ITextFileReader
    {
        string Read(string FilePath, ref DataTable table, int lineStart = 1, char splitChar = '~');

        string ReadCDBLFile(string FilePath, ref DataTable table, int lineStart = 1, char splitChar = '~', string folderDate = "");
    }
}
