USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptImportUpdate]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptImportUpdate]
	@ImportKey int,
	@DateImported smalldatetime,
	@Status smallint,
	@LogText text

AS --Encrypt

	UPDATE
		tImport
	SET
		DateImported = @DateImported,
		Status = @Status,
		LogText = @LogText
	WHERE
		ImportKey = @ImportKey 

	RETURN 1
GO
