USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetAdmin]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectGetAdmin]
 (
  @CompanyKey int,
  @Active tinyint
 )
AS --Encrypt
  SELECT 
   ISNULL(LEFT(tCompany.CompanyName, 25) + '  \  ', '') + LEFT(tProject.ProjectName, 25) AS ProjectName, 
      tProject.ProjectKey, 
      LEFT(tProject.ProjectName, 25) AS ProjectShortName, 
      tProject.ProjectNumber,
      tCompany.CompanyName,
      tCompany.CustomerID
  FROM tProject (NOLOCK) LEFT OUTER JOIN
      tCompany (NOLOCK) ON tProject.ClientKey = tCompany.CompanyKey
  WHERE
   tProject.CompanyKey = @CompanyKey AND 
   tProject.Active = @Active AND
   tProject.Deleted <> 1
  ORDER BY 
   tProject.ProjectNumber,
   tCompany.CompanyName,
   ProjectShortName
GO
