USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_GetARDocs_Terms]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCM_GetARDocs_Terms]
	@parmBatNbr Varchar(10)
	AS
	SELECT * FROM ARdoc,Terms (NoLock)
		Where
			ArDoc.Batnbr = @parmBatNbr
			And
			Ardoc.Terms = Terms.TermsID
			And
			Refnbr LIKE '%'
		ORDER BY
			Refnbr
GO
