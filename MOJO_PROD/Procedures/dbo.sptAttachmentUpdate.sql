USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttachmentUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttachmentUpdate]
 @AttachmentKey int,
 @AssociatedEntity varchar(50),
 @EntityKey int,
 @AddedBy int,
 @FileName varchar(300),
 @Comments varchar(1000)
AS --Encrypt
 UPDATE
  tAttachment
 SET
  AssociatedEntity = @AssociatedEntity,
  EntityKey = @EntityKey,
  AddedBy = @AddedBy,
  FileName = @FileName,
  Comments = @Comments
 WHERE
  AttachmentKey = @AttachmentKey 
 RETURN 1
GO
