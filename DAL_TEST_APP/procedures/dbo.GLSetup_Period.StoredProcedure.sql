USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLSetup_Period]    Script Date: 12/21/2015 13:57:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GLSetup_Period] AS
BEGIN
	SELECT BaseCuryId, CpnyName, LastBatNbr, NbrPer, PerNbr, PerRetHist, ZCount, AllowPostOpt, PriorYearPost
	FROM GLSetup
END
GO
