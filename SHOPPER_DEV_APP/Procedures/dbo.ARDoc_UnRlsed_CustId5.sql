USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_UnRlsed_CustId5]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_UnRlsed_CustId5    Script Date: 5/19/98 11:30:33 AM ******/
Create Procedure [dbo].[ARDoc_UnRlsed_CustId5] @parm1 varchar ( 15) as
        SELECT * FROM ARDoc WHERE CustId = @parm1
        AND ((ARDoc.Rlsed = 0 and ARDoc.Doctype <> 'RC')
        OR (ARDoc.DocType ='RC'and ARDoc.NbrCycle > 0))
        ORDER BY ARDoc.BatNbr
GO
