USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_set_Doctype]    Script Date: 12/16/2015 15:55:13 ******/
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
