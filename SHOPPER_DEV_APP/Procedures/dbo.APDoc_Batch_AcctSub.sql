USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_Batch_AcctSub]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[APDoc_Batch_AcctSub] @parm1 VarChar ( 10), @parm2 VarChar ( 24), @parm3 VarChar ( 10)AS
Select * from APDoc where BatNbr = @parm1 And Acct LIKE @parm3 and Sub LIKE @parm2 order by Acct, Sub
GO
