USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLinkInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLinkInsert]
 @AssociatedEntity varchar(50),
 @EntityKey int,
 @Type smallint,
 @AddedBy int,
 @FileKey int,
 @FormKey int,
 @URL varchar(1000),
 @URLName varchar(300),
 @URLDescription varchar(500),
 @oIdentity INT OUTPUT
AS --Encrypt
 INSERT tLink
  (
  AssociatedEntity,
  EntityKey,
  Type,
  AddedBy,
  FileKey,
  FormKey,
  URL,
  URLName,
  URLDescription
  )
 VALUES
  (
  @AssociatedEntity,
  @EntityKey,
  @Type,
  @AddedBy,
  @FileKey,
  @FormKey,
  @URL,
  @URLName,
  @URLDescription
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
