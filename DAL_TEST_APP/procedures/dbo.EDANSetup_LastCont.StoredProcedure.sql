USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDANSetup_LastCont]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDANSetup_LastCont] As Select LastSerContainer From ANSetup Order BY SetupId
GO
