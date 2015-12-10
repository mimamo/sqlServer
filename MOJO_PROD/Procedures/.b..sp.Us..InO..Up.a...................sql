USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserInOutUpdate]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sptUserInOutUpdate]
 @UserKey int,
 @InOutStatus varchar(10),
 @InOutNotes varchar(100)
AS --Encrypt
   
 UPDATE
  tUser
 SET
  InOutStatus = @InOutStatus,
  InOutNotes = @InOutNotes
 WHERE
  UserKey = @UserKey 

    
 RETURN 1
GO
