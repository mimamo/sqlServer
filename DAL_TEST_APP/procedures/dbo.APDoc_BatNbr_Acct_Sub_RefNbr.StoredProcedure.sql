USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_BatNbr_Acct_Sub_RefNbr]    Script Date: 12/21/2015 13:56:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_BatNbr_Acct_Sub_RefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_BatNbr_Acct_Sub_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10) As
Select * From APDoc
Where APDoc.BatNbr = @parm1 And
APDoc.DocClass = "C" and
APDoc.Acct like @parm2 and
APDoc.Sub like @parm3 and
APDoc.RefNbr like @parm4 and
(APDoc.DocType <> 'MC' and APDoc.DocType <> 'SC' and APDoc.DocType <> 'VT')
Order By APDoc.BatNbr, APDoc.Acct, APDoc.Sub, APDoc.RefNbr
GO
