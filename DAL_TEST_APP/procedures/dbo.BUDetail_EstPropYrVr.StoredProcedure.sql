USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BUDetail_EstPropYrVr]    Script Date: 12/21/2015 13:56:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUDetail_EstPropYrVr    Script Date: 4/7/98 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[BUDetail_EstPropYrVr] @Parm1 varchar ( 4), @Parm2 varchar ( 10) AS
SELECT * FROM accthist WHERE (YTDEstimated <> 0 Or annbdgt <> 0) And fiscyr = @Parm1 And ledgerid = @Parm2 Order By fiscyr, ledgerid, sub, Acct
GO
