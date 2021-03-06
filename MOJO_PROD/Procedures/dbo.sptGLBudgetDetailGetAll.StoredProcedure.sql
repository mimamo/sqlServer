USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetDetailGetAll]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetDetailGetAll]

		@GLBudgetKey int

AS --Encrypt
  

	select *
		  ,isnull(Month1, 0) + isnull(Month2, 0) + isnull(Month3, 0) + isnull(Month4, 0) + isnull(Month5, 0) + isnull(Month6, 0) + isnull(Month7, 0) + isnull(Month8, 0) + isnull(Month9, 0) + isnull(Month10, 0) + isnull(Month11, 0) + isnull(Month12, 0) as Year
	  from tGLBudgetDetail (nolock) 
	 where GLBudgetKey = @GLBudgetKey
GO
