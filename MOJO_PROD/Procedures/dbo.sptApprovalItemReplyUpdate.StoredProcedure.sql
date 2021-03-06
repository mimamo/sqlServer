USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalItemReplyUpdate]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalItemReplyUpdate]
 @ApprovalItemReplyKey int,
 @Status smallint,
 @Comments text
 
AS --Encrypt

/* Who	Rel	    When		What	
|| GHL  8.3	    04/28/06	Allowed update of comments even when reply/status is incorrect  (<0)
				            Users complained that comments were lost
|| RTC  8.4.1	03/28/07	(8302) Changed Comment column to text from varchar(8000)
*/

IF @Status > 0	
	 UPDATE  tApprovalItemReply
	 SET         Status = @Status,
	                 Comments = @Comments,
	                 DateUpdated = GETUTCDATE()
	 WHERE  ApprovalItemReplyKey = @ApprovalItemReplyKey 
ELSE
	 UPDATE  tApprovalItemReply
	 SET         Comments = @Comments,
	                 DateUpdated = GETUTCDATE()
	 WHERE  ApprovalItemReplyKey = @ApprovalItemReplyKey 
	 

RETURN 1
GO
