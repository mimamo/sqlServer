USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyAddressUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyAddressUpdate]
 @CompanyKey int,
 @CompanyName varchar(200),
 @WebSite varchar(100),
 @Phone varchar(20),
 @Fax varchar(20),
 @Active tinyint,
 @EINNumber varchar(30),
 @BillingAddressKey int,
 @StateEINNumber varchar(30),
 @TimeZoneIndex int
 
AS --Encrypt

/*
|| When     Who Rel   What
|| 12/6/06  CRG 8.4   Added StateEINNumber
|| 11/07/13 RLB 10574 (195465) Added CompanyTimeZoneIndex
*/

 UPDATE
  tCompany
 SET
  CompanyName = @CompanyName,
  WebSite = @WebSite,
  Phone = @Phone,
  Fax = @Fax,
  Active = @Active,
  EINNumber = @EINNumber,
  BillingAddressKey = @BillingAddressKey,
  StateEINNumber = @StateEINNumber,
  TimeZoneIndex = @TimeZoneIndex
 WHERE
  CompanyKey = @CompanyKey 

 RETURN 1
GO
