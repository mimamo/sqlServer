USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBank_Test_Check_AR]    Script Date: 12/21/2015 14:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBank_Test_Check_AR]
   @CpnyIDAcctSub	varchar(44)
AS
   SELECT		Count(*)
   FROM			XDDBank (NoLock)
   WHERE		ARTest = 'Y'
			and CpnyID + Acct + Sub <> @CpnyIDAcctSub
GO
