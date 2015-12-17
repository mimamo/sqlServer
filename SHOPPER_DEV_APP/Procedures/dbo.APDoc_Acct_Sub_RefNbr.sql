USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_Acct_Sub_RefNbr]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_Acct_Sub_RefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_Acct_Sub_RefNbr]
@parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar ( 10) as
Select * from APDoc where Acct = @parm1
and Sub = @parm2
and RefNbr = @parm3
and Doctype in ("CK" ,"HC", "MC", "QC", "SC", "VC" , "ZC"  )
Order by Acct, Sub, DocType, RefNbr
GO
