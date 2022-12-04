using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _3de0_BLL.Exceptions
{
    public class CaffException : Exception
    {
        public CaffException(string? message) : base(message)
        {
        }
    }
}
