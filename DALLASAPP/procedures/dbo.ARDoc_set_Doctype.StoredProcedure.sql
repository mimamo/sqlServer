USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_set_Doctype]    Script Date: 12/21/2015 13:44:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[ARDoc_set_Doctype] @parm1 varchar (10), @parm2 varchar (15), @parm3 varchar (10) as
        UPDATE ARDoc SET ARDoc.DocType = "VT"
        WHERE ARDoc.BatNbr = @parm1
        AND ARDoc.Custid = @parm2
        AND ARDoc.DocType = "PA"
        AND ARDoc.RefNbr = @parm3
GO
