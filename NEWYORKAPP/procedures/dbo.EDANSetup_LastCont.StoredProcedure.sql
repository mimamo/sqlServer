USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDANSetup_LastCont]    Script Date: 12/21/2015 16:00:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDANSetup_LastCont] As Select LastSerContainer From ANSetup Order BY SetupId
GO
