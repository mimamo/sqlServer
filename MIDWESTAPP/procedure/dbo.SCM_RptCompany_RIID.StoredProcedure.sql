USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_RptCompany_RIID]    Script Date: 12/21/2015 15:55:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_RptCompany_RIID]
	@RIID SmallInt

as

	SELECT * FROM RptCompany Where RI_ID = @RIID
GO
