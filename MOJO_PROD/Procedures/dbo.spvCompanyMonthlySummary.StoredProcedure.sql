USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvCompanyMonthlySummary]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvCompanyMonthlySummary]
 (
  @CompanyKey int,
  @Year int = NULL
 )
AS --Encrypt
 If @Year IS NULL
  SELECT 
   * 
  FROM
   vCompanyMonthlySummary (NOLOCK)
  WHERE
   CompanyKey = @CompanyKey
  ORDER BY
   Year, Month
 ELSE
  SELECT 
   * 
  FROM
   vCompanyMonthlySummary (NOLOCK)
  WHERE
   CompanyKey = @CompanyKey AND
   Year = @Year
  ORDER BY
   Year, Month
 RETURN
GO
