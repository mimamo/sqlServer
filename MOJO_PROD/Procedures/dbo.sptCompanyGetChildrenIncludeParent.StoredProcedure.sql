USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetChildrenIncludeParent]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyGetChildrenIncludeParent]
	@ParentCompanyKey int
AS --Encrypt
/*
|| When      Who Rel       What
|| 06/17/09  RLB 10.5.0.0  (55126) Only pulling Active Parent Companies
|| 
|| 
*/


SELECT	CompanyKey, CompanyName
FROM	tCompany (nolock) 
WHERE	ParentCompanyKey = @ParentCompanyKey and Active = 1
OR		CompanyKey = @ParentCompanyKey
ORDER BY CompanyName
GO
