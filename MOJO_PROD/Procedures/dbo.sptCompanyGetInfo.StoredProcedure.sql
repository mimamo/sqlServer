USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetInfo]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyGetInfo]
 @CompanyKey int

AS --Encrypt

  SELECT c.*
	,u.UserKey
	,u.FirstName
	,u.LastName
	,u.Phone1
	,u.Phone2
	,u.Fax as ContactFax
	,u.Cell
	,u.Pager
	
  FROM tCompany c (nolock)
  left outer join tUser u (nolock) on c.PrimaryContact = u.UserKey
  WHERE
	c.CompanyKey = @CompanyKey
 RETURN 1
GO
