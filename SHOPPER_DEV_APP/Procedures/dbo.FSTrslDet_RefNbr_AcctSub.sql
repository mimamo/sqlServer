USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FSTrslDet_RefNbr_AcctSub]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FSTrslDet_RefNbr_AcctSub    Script Date: 4/7/98 12:45:04 PM ******/
Create Proc [dbo].[FSTrslDet_RefNbr_AcctSub] @parm1 varchar (10) As
     SELECT * FROM FSTrslDet
     WHERE RefNbr = @parm1
     ORDER BY RefNbr, Acct, Sub
GO
