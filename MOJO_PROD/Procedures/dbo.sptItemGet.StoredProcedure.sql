USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemGet]
	@ItemKey int = 0,
	@ItemID varchar(50) = NULL,
	@CompanyKey int = NULL

AS --Encrypt

/*
  || When       Who Rel      What
  || 07/30/2009 MFT 10.5.0.5 Added ItemID & CompanyKey params and condition
*/

IF @ItemKey > 0
		SELECT i.*,
			gl.AccountNumber,
			wt.WorkTypeID,
			gl.AccountNumber AS ExpenseAccountNumber,
			gl2.AccountNumber AS SalesAccountNumber,
			c.ClassID
		FROM tItem i (nolock) 
			Left Outer Join tGLAccount gl (nolock) on i.ExpenseAccountKey = gl.GLAccountKey
			Left Outer Join tWorkType wt (nolock) on i.WorkTypeKey = wt.WorkTypeKey
			Left outer Join tGLAccount gl2 (nolock) on i.SalesAccountKey = gl2.GLAccountKey
			Left outer Join tClass c (nolock) on i.ClassKey = c.ClassKey		
		WHERE
			ItemKey = @ItemKey
ELSE
		SELECT i.*,
			gl.AccountNumber,
			wt.WorkTypeID,
			gl.AccountNumber AS ExpenseAccountNumber,
			gl2.AccountNumber AS SalesAccountNumber,
			c.ClassID
		FROM tItem i (nolock) 
			Left Outer Join tGLAccount gl (nolock) on i.ExpenseAccountKey = gl.GLAccountKey
			Left Outer Join tWorkType wt (nolock) on i.WorkTypeKey = wt.WorkTypeKey
			Left outer Join tGLAccount gl2 (nolock) on i.SalesAccountKey = gl2.GLAccountKey
			Left outer Join tClass c (nolock) on i.ClassKey = c.ClassKey		
		WHERE
			i.CompanyKey = @CompanyKey AND
			ItemID = @ItemID

RETURN 1
GO
