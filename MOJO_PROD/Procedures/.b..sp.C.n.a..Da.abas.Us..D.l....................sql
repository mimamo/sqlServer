USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactDatabaseUserDelete]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptContactDatabaseUserDelete]

	(
		@ContactDatabaseKey int
	)

AS --Encrypt

Delete from tContactDatabaseUser Where ContactDatabaseKey = @ContactDatabaseKey
GO
