USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetClientOpenList]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceGetClientOpenList]

	(
		@ClientKey int,
		@UserKey int,
		@UserRights int,
		@Open tinyint = 1
	)

AS --Encrypt

DECLARE @ParentCompanyKey int, @CompanyKey int

SELECT @CompanyKey = CompanyKey
	FROM tUser (NOLOCK)
	WHERE UserKey = @UserKey

SELECT @ParentCompanyKey = ParentCompanyKey
	FROM   tCompany (NOLOCK)
	WHERE  CompanyKey = @CompanyKey

if @Open = 1
	
	IF @UserRights = 2
		SELECT	 InvoiceKey
				,InvoiceNumber
				,InvoiceDate
				,DueDate
				,BilledAmount
				,OpenAmount
		FROM   vInvoice
		WHERE  ParentClientKey = @ParentCompanyKey
		AND    OpenAmount <> 0
		AND	   InvoiceStatus = 4
		Order By DueDate
	ELSE IF @UserRights = 1
		SELECT	 InvoiceKey
				,InvoiceNumber
				,InvoiceDate
				,DueDate
				,BilledAmount
				,OpenAmount
		FROM   vInvoice
		WHERE  ClientKey = @ClientKey
		AND    OpenAmount <> 0
		AND	   InvoiceStatus = 4
		Order By DueDate
	ELSE
		SELECT	 InvoiceKey
				,InvoiceNumber
				,InvoiceDate
				,DueDate
				,BilledAmount
				,OpenAmount
		FROM   vInvoice
		WHERE  PrimaryContactKey = @UserKey
		AND    OpenAmount <> 0
		AND	   InvoiceStatus = 4
		Order By DueDate
else
	IF @UserRights = 2
		SELECT	 InvoiceKey
				,InvoiceNumber
				,InvoiceDate
				,DueDate
				,BilledAmount
				,OpenAmount
		FROM   vInvoice
		WHERE  ParentClientKey = @ParentCompanyKey
		AND    OpenAmount = 0
		AND	   InvoiceStatus = 4
		Order By DueDate
	ELSE IF @UserRights = 1
		SELECT	 InvoiceKey
				,InvoiceNumber
				,InvoiceDate
				,DueDate
				,BilledAmount
				,OpenAmount
		FROM   vInvoice
		WHERE  ClientKey = @ClientKey
		AND    OpenAmount = 0
		AND	   InvoiceStatus = 4
		Order By DueDate
	ELSE
		SELECT	 InvoiceKey
				,InvoiceNumber
				,InvoiceDate
				,DueDate
				,BilledAmount
				,OpenAmount
		FROM   vInvoice
		WHERE  PrimaryContactKey = @UserKey
		AND    OpenAmount = 0
		AND	   InvoiceStatus = 4
		Order By DueDate
GO
