USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Account_AcctMask]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Account_AcctMask    Script Date: 4/7/98 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[Account_AcctMask] @parm1 varchar ( 10) AS
SELECT * FROM Account WHERE
Acct  LIKE @parm1 and Active  =  1     ORDER BY Acct
GO
