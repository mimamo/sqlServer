USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Account_AcctAct]    Script Date: 12/21/2015 15:36:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Account_AcctAct    Script Date: 4/7/98 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[Account_AcctAct] @parm1 varchar ( 10) AS
SELECT * FROM Account WHERE
 Acct  Like @parm1 and Active  =  1
GO
