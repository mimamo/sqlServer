USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentUpdate]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAssignmentUpdate]
 @AssignmentKey int,
 @HourlyRate money
AS --Encrypt
 UPDATE
  tAssignment
 SET
  HourlyRate = @HourlyRate
 WHERE
  AssignmentKey = @AssignmentKey 
 RETURN 1
GO
