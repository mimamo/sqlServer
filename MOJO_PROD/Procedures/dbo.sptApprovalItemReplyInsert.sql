USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalItemReplyInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalItemReplyInsert]
 @ApprovalItemKey int,
 @UserKey int,
 @Status smallint,
 @Comments text,
 @oIdentity INT OUTPUT
 
AS --Encrypt

/* Who	Rel	    When		What	
|| RTC  8.4.1	03/28/07	(8302) Changed Comment column to text from varchar(8000)
*/

 INSERT tApprovalItemReply
  (
  ApprovalItemKey,
  UserKey,
  Status,
  Comments
  )
 VALUES
  (
  @ApprovalItemKey,
  @UserKey,
  @Status,
  @Comments
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
