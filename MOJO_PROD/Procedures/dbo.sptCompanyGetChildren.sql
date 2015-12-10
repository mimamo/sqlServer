USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetChildren]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyGetChildren]

	(
		@CompanyKey int
	)

AS --Encrypt

Select
	CompanyKey,
	CompanyName
From
	tCompany (nolock) 
Where
	ParentCompanyKey = @CompanyKey
Order By CompanyName
GO
