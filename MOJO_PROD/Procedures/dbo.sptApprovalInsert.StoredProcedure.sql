USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalInsert]
 @ProjectKey int,
 @Subject varchar(200),
 @Description varchar(1000),
 @DueDate smalldatetime,
 @ApprovalOrderType smallint,
 @ViewOtherComments smallint,
 @SendUpdatesTo int,
 @UserKey int,
 @oIdentity INT OUTPUT
AS --Encrypt
 INSERT tApproval
  (
  ProjectKey,
  Subject,
  Description,
  DueDate,
  ApprovalOrderType,
  ViewOtherComments,
  Status,
  SendUpdatesTo
  )
 VALUES
  (
  @ProjectKey,
  @Subject,
  @Description,
  @DueDate,
  @ApprovalOrderType,
  @ViewOtherComments,
  0,
  @SendUpdatesTo
  )
 
 SELECT @oIdentity = @@IDENTITY
 
 EXEC sptApprovalUpdateListInsert @oIdentity, @UserKey
 
 RETURN 1
GO
