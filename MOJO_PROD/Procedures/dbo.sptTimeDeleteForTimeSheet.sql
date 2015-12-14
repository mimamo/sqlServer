USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeDeleteForTimeSheet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeDeleteForTimeSheet]
	@TimeSheetKey int
 
AS --Encrypt
 DECLARE @Status smallint
 
 SELECT @Status = Status
 FROM tTimeSheet (NOLOCK)
 WHERE TimeSheetKey = @TimeSheetKey
 
 IF @Status = 1 OR @Status = 3
  DELETE tTime
  WHERE TimeSheetKey = @TimeSheetKey
 ELSE
  RETURN -1 --Can't delete
  
 RETURN 1
GO
