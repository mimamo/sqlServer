USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spSecurityGroupGetCompanyGroups]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSecurityGroupGetCompanyGroups]
 (
  @CompanyKey int
 )
AS --Encrypt
 SELECT sg.*
 FROM   tSecurityGroup sg (NOLOCK)
 WHERE  sg.CompanyKey        = @CompanyKey 
 AND    sg.Active            = 1
 ORDER BY GroupName
 
 /* set nocount on */
 return
GO
