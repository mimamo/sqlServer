USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLSetup_MCFields]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLSetup_MCFields    Script Date: 4/7/98 12:38:58 PM ******/
CREATE PROC [dbo].[GLSetup_MCFields] AS
SELECT Central_Cash_Cntl, CpnyId, CpnyName, MCActive, Mult_Cpny_Db FROM GLSetup
GO
