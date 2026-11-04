using System;
using System.Collections.Generic;
using System.Text;

namespace VisitDreznica.Model.Exceptions;

public class NotFoundException(string message) : Exception(message);
