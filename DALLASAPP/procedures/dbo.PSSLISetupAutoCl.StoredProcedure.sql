USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLISetupAutoCl]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSLISetupAutoCl]
  AS
  Select LastClientNo From PSSLISetup
GO
