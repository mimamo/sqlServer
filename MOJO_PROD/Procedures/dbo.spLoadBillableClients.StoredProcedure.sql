USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLoadBillableClients]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spLoadBillableClients]
 @CompanyKey int
 
AS --Encrypt
 SELECT CompanyKey, CompanyName AS Client, ISNULL(CustomerID, '') + ' - ' + ISNULL(CompanyName, '') as ClientFullName
 FROM tCompany (NOLOCK)
 WHERE BillableClient = 1
   AND  OwnerCompanyKey = @CompanyKey
   AND Active = 1
 ORDER BY CustomerID
GO
