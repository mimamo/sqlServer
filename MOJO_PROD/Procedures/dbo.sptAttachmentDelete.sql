USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttachmentDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttachmentDelete]
 @AttachmentKey int
AS --Encrypt
 DELETE
 FROM tAttachment
 WHERE
  AttachmentKey = @AttachmentKey 
 RETURN 1
GO
