USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_BatNbr_RefNbr]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_BatNbr_RefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_BatNbr_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 1), @parm3 varchar ( 10) As
Select * From APDoc
Where APDoc.BatNbr = @parm1 And
APDoc.DocClass = @parm2 and
APDoc.RefNbr like @parm3 and
(APDoc.DocType <> 'MC' and APDoc.DocType <> 'SC' and APDoc.DocType <> 'VT')
Order By APDoc.BatNbr, APDoc.RefNbr
GO
