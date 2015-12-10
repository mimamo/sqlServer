USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10557]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10557]

AS


UPDATE tUser 
SET RequireUserTimeDetails = 0 
WHERE CompanyKey in (SELECT CompanyKey FROM tPreference WHERE ISNULL(RequireTimeDetails, 0) = 0) or OwnerCompanyKey in (SELECT CompanyKey FROM tPreference Where ISNULL(RequireTimeDetails, 0) = 0)


UPDATE tUser 
SET RequireUserTimeDetails = 1 
WHERE CompanyKey in (SELECT CompanyKey FROM tPreference WHERE ISNULL(RequireTimeDetails, 0) = 1) or OwnerCompanyKey in (SELECT CompanyKey FROM tPreference WHERE ISNULL(RequireTimeDetails, 0) = 1)
GO
