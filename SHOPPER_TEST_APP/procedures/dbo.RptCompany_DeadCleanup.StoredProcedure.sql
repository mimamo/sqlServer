USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RptCompany_DeadCleanup]    Script Date: 12/21/2015 16:07:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RptCompany_DeadCleanup] AS
	delete from RptCompany where ri_id NOT IN (select ri_id from rptruntime)
GO
