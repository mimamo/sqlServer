USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Budget_Year_All]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Budget_Year_All    Script Date: 4/7/98 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[Budget_Year_All]
@Parm1 varchar ( 4) AS
SELECT * FROM budget_year WHERE budgetyear LIKE @Parm1 ORDER BY BudgetYear
GO
