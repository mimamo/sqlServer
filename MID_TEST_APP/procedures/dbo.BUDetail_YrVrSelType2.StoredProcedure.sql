USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BUDetail_YrVrSelType2]    Script Date: 12/21/2015 15:49:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUDetail_YrVrSelType2    Script Date: 4/7/98 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[BUDetail_YrVrSelType2]
@Parm1 varchar ( 4), @Parm2 varchar ( 10), @Parm3 varchar ( 24), @Parm4 varchar ( 2) AS
SELECT * FROM accthist, account WHERE account.acct = accthist.acct and annbdgt <> 0 AND fiscyr = @Parm1 AND ledgerid = @Parm2 AND sub = @Parm3 AND AcctType IN (@Parm4) ORDER BY fiscyr, ledgerid, sub, accthist.Acct
GO
