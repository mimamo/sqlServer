USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttachmentGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttachmentGet]
 @AttachmentKey int
AS --Encrypt
 -- ToDo: If there is more than one PrimaryKey, remove the extras or rewrite the If statement.
 IF @AttachmentKey IS NULL
  SELECT *
  FROM  tAttachment (nolock)
 ELSE
  SELECT *
  FROM tAttachment (nolock)
  WHERE
   AttachmentKey = @AttachmentKey
 RETURN 1
GO
