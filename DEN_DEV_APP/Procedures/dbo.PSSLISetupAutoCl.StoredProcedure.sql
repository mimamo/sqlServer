USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLISetupAutoCl]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSLISetupAutoCl]
  AS
  Select LastClientNo From PSSLISetup
GO
