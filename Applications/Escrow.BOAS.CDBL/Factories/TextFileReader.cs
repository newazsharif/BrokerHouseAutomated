using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.CDBL.Interfaces;
using System.Data;
using System.IO;

namespace Escrow.BOAS.CDBL.Factories
{
    public class TextFileReader : ITextFileReader
    {
        public string Read(string FilePath, ref DataTable table, int lineStart = 1, char splitChar = '~')
        {
            string error = string.Empty;
            int rowNumber = 0;

            if (!File.Exists(FilePath)) return "File not exists";
            string[] rows = File.ReadAllLines(FilePath);
            if (rows.Count() <= lineStart) return "Data not found";
            rows.Skip(lineStart - 1);
            int columnsCount = table.Columns.Count;

            foreach (string row in rows)
            {
                rowNumber += 1;
                string[] cells = row.Split(splitChar);
                if (cells.Count() != columnsCount)
                {
                    error += rowNumber.ToString() + ",";
                }
                else
                {
                    DataRow dr = table.NewRow();
                    try
                    {
                        dr.ItemArray = cells;
                        table.Rows.Add(dr);
                    }
                    catch
                    {
                        error += rowNumber.ToString() + ",";
                    }

                }
            }
            if (error.Length > 0) error = error.Substring(0, error.Length - 1);
            return "Error found on line number: " + error;
        }

        public string ReadCDBLFile(string FilePath, ref DataTable table, int lineStart = 1, char splitChar = '~', string folderDate = "")
        {
            string error = string.Empty;
            int rowNumber = 0;

            if (!File.Exists(FilePath)) return "File not exists";
            string[] rows = File.ReadAllLines(FilePath);
            if (rows.Count() <= lineStart) return "Data not found";
            rows.Skip(lineStart - 1);
            int columnsCount = table.Columns.Count;

            foreach (string row in rows)
            {
                rowNumber += 1;
                string[] cells = row.Split(splitChar);
                if (cells.Count() != columnsCount - 1)
                {
                    error += rowNumber.ToString() + ",";
                }
                else
                {
                    DataRow dr = table.NewRow();
                    int lastIndex = dr.ItemArray.Count();
                    try
                    {
                        dr.ItemArray = cells;
                        dr[lastIndex - 1] = folderDate;
                        table.Rows.Add(dr);
                    }
                    catch
                    {
                        error += rowNumber.ToString() + ",";
                    }

                }
            }
            if (error.Length > 0) error = error.Substring(0, error.Length - 1);
            return "Error found on line number: " + error;
        }
    }
}
