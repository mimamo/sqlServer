USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BUDetail_EstProp]    Script Date: 12/21/2015 16:06:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUDetail_EstProp    Script Date: 4/7/98 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[BUDetail_EstProp] @Parm1 varchar ( 24), @Parm2 varchar ( 4), @Parm3 varchar ( 10) AS
SELECT * FROM Accthist WHERE (YTDEstimated <> 0 Or Annbdgt <> 0) And sub = @Parm1 and fiscyr = @Parm2 And ledgerid = @Parm3 Order By fiscyr, ledgerid, sub, Acct
GO
