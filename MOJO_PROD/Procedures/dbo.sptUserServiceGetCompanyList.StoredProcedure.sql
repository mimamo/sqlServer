USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserServiceGetCompanyList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserServiceGetCompanyList]

	(
		@CompanyKey int
	)

AS --Encrypt

Select 
	us.UserKey,
	us.ServiceKey
from tUserService us (nolock)
Inner Join tService s (nolock) on us.ServiceKey = s.ServiceKey
Where
	s.CompanyKey = @CompanyKey
GO
