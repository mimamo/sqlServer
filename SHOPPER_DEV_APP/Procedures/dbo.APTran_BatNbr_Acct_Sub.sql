USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_BatNbr_Acct_Sub]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTran_BatNbr_Acct_Sub    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APTran_BatNbr_Acct_Sub] @parm1 varchar ( 10) as
Select * from APTran where
BatNbr = @parm1
Order by BatNbr, Acct, Sub
GO
