USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetUserList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCompanyGetUserList]
 @CompanyKey int
 
AS --Encrypt
 SELECT 
   tUser.*,
   tUser.FirstName + ' ' + tUser.LastName as UserName
 FROM tUser (nolock)
 WHERE CompanyKey = @CompanyKey
 ORDER BY LastName, FirstName
 
 RETURN 1
GO
