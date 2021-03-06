USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Doctype_RefNbr]    Script Date: 12/21/2015 13:44:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Doctype_RefNbr    Script Date: 4/7/98 12:30:33 PM ******/
CREATE PROC [dbo].[ARDoc_Doctype_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 10) as
    SELECT *
      FROM ardoc
     WHERE CpnyId = @parm1 AND
           doctype IN ('FI', 'IN', 'DM', 'NC') AND
           Rlsed = 1 AND
           refnbr LIKE @parm2
     ORDER BY CpnyId, Doctype, Refnbr
GO
