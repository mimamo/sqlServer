USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalUpdate]
 @ApprovalKey int,
 @ProjectKey int,
 @Subject varchar(200),
 @Description varchar(1000),
 @DueDate smalldatetime,
 @ApprovalOrderType smallint, 
 @ViewOtherComments smallint,
 @SendUpdatesTo int
AS --Encrypt
 UPDATE
  tApproval
 SET
  ProjectKey = @ProjectKey,
  Subject = @Subject,
  Description = @Description,
  DueDate = @DueDate,
  ApprovalOrderType = @ApprovalOrderType,
  ViewOtherComments = @ViewOtherComments,
  SendUpdatesTo = @SendUpdatesTo
 WHERE
  ApprovalKey = @ApprovalKey 
 RETURN 1
GO
