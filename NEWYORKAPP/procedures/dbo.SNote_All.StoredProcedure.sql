USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SNote_All]    Script Date: 12/21/2015 16:01:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SNote_All    Script Date: 4/17/98 12:50:25 PM ******/
Create Proc [dbo].[SNote_All] @lMin int, @lMax int as
    SELECT * FROM SNote WHERE nID BETWEEN @lMin and @lMax
GO
