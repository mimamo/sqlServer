USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormUpdate]
 @FormKey int,
 @ProjectKey int,
 @TaskKey int,
 @AssignedTo int,
 @ContactCompanyKey int,
 @Subject varchar(150),
 @DueDate smalldatetime,
 @Priority smallint
AS --Encrypt
 UPDATE
  tForm
 SET
	ProjectKey = @ProjectKey,
	TaskKey = @TaskKey,
	AssignedTo = @AssignedTo,
	ContactCompanyKey = @ContactCompanyKey,
	Subject = @Subject,
	DueDate = @DueDate,
	Priority = @Priority
 WHERE
  FormKey = @FormKey 
 RETURN 1
GO
