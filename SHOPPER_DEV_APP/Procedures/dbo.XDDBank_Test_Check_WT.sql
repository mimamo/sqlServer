USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBank_Test_Check_WT]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBank_Test_Check_WT]
   @CpnyIDAcctSub	varchar(44)
AS
   SELECT		Count(*)
   FROM			XDDBank (NoLock)
   WHERE		WTTest = 'Y'
			and CpnyID + Acct + Sub <> @CpnyIDAcctSub
GO
