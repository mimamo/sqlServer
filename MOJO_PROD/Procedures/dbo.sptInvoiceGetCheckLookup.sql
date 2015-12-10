USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetCheckLookup]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetCheckLookup]

	(
		@ClientKey int,
		@ReferenceNumber varchar(100)
	)

AS --Encrypt

if @ReferenceNumber is null
	Select 
		c.ReferenceNumber,
		c.CheckKey,
		ISNULL(Sum(ca.Amount), 0) as AppliedAmount,
		c.CheckAmount,
		c.CheckAmount - ISNULL(Sum(ca.Amount), 0) as OpenAmount,
		c.CheckDate
	From
		tCheck c (nolock)
		Left Outer Join tCheckAppl ca (nolock) on c.CheckKey = ca.CheckKey
	Where
		c.ClientKey = @ClientKey and
		ISNULL(c.VoidCheckKey, 0) = 0
	Group By
		c.ReferenceNumber,
		c.CheckKey,
		c.CheckAmount,
		c.CheckDate
	Having
		ISNULL(SUM(ca.Amount), 0) < c.CheckAmount
else
		Select 
		c.ReferenceNumber,
		c.CheckKey,
		ISNULL(Sum(ca.Amount), 0) as AppliedAmount,
		c.CheckAmount,
		c.CheckAmount - ISNULL(Sum(ca.Amount), 0) as OpenAmount,
		c.CheckDate
	From
		tCheck c (nolock)
		Left Outer Join tCheckAppl ca (nolock) on c.CheckKey = ca.CheckKey
	Where
		c.ClientKey = @ClientKey and
		c.ReferenceNumber like @ReferenceNumber + '%' and
		ISNULL(c.VoidCheckKey, 0) = 0
	Group By
		c.ReferenceNumber,
		c.CheckKey,
		c.CheckAmount,
		c.CheckDate
	Having
		ISNULL(SUM(ca.Amount), 0) < c.CheckAmount
GO
