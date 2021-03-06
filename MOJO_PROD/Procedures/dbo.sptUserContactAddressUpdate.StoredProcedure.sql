USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserContactAddressUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserContactAddressUpdate]
 @UserKey int,
 @CompanyKey int,
 @FirstName varchar(100),
 @LastName varchar(100),
 @Salutation varchar(10),
 @Phone1 varchar(20),
 @Phone2 varchar(20),
 @Cell varchar(20),
 @Fax varchar(20),
 @Pager varchar(20),
 @Title varchar(50),
 @Email varchar(100),
 @Position varchar(50),
 @SecurityGroupKey int,
 @UserID varchar(100),
 @Password varchar(100),
 @ContactMethod tinyint,
 @Active tinyint,
 @ShowHints tinyint
AS --Encrypt
 UPDATE
  tUser
 SET
  CompanyKey = @CompanyKey,
  FirstName = @FirstName,
  LastName = @LastName,
  Salutation = @Salutation,
  Phone1 = @Phone1,
  Phone2 = @Phone2,
  Cell = @Cell,
  Fax = @Fax,
  Pager = @Pager,
  Title = @Title,
  Email = @Email,
  SecurityGroupKey = @SecurityGroupKey,
  UserID = @UserID,
  Password = @Password,
  ContactMethod = @ContactMethod,
  Active = @Active
 WHERE
  UserKey = @UserKey 
 RETURN 1
GO
