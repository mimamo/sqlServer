USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBank_Test_Check_AP]    Script Date: 12/21/2015 14:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBank_Test_Check_AP]
   @CpnyIDAcctSub	varchar(44)
AS
   SELECT		Count(*)
   FROM			XDDBank (NoLock)
   WHERE		Test = 'Y'
			and CpnyID + Acct + Sub <> @CpnyIDAcctSub
GO
