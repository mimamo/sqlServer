USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckUpdateCCAuthCode]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckUpdateCCAuthCode]

	(
		@CheckKey int,
		@AuthCode varchar(100)
	)
AS --Encrypt


Update tCheck
Set AuthCode = @AuthCode 
Where CheckKey = @CheckKey
GO
