USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_RptCompany_RIID]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_RptCompany_RIID]
	@RIID SmallInt

as

	SELECT * FROM RptCompany Where RI_ID = @RIID
GO
