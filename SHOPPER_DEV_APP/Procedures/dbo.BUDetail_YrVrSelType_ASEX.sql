USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BUDetail_YrVrSelType_ASEX]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUDetail_YrVrSelType_ASEX    Script Date: 10/23/98 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[BUDetail_YrVrSelType_ASEX]
@Parm1 varchar ( 10), @Parm2 varchar ( 4), @Parm3 varchar ( 10), @Parm4 varchar ( 24) AS
SELECT * FROM Accthist, account WHERE account.acct = accthist.acct and CpnyID = @Parm1 AND fiscyr = @Parm2 AND ledgerid = @Parm3 AND sub = @Parm4 AND acctType IN ('1A', '2A', '3A', '4A', '1E', '2E', '3E', '4E') ORDER BY fiscyr, ledgerid, sub, accthist.Acct
GO
