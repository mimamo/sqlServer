USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFASetupAutoBatNbr]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFASetupAutoBatNbr] AS
  SELECT LastTranBatNbr FROM PSSFASetup
GO
