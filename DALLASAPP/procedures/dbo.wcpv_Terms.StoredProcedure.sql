USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[wcpv_Terms]    Script Date: 12/21/2015 13:45:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[wcpv_Terms]
	@TermsID VARCHAR(2) = '%'
as
	SELECT
		descr, termsid
	FROM
		terms
	WHERE
		termsid LIKE @TermsID
	ORDER BY Descr
GO
