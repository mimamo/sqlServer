USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DEL_AcctHist_FiscYr]    Script Date: 12/21/2015 15:36:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DEL_AcctHist_FiscYr    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[DEL_AcctHist_FiscYr] @parm1 varchar ( 4) as
       Delete accthist from AcctHist
           where FiscYr <= @parm1
GO
