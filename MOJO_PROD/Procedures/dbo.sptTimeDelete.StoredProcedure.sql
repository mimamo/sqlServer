USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeDelete]
 @TimeKey uniqueidentifier
AS --Encrypt
 DELETE
 FROM tTime
 WHERE
  TimeKey = @TimeKey 
 RETURN 1
GO
