USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[GLSetupMaster]    Script Date: 12/21/2015 13:44:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLSetupMaster    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc  [dbo].[GLSetupMaster] as
       Select BaseCuryId,CpnyName,LastBatNbr,NbrPer,PerNbr,PerRetHist,ZCount from GLSetup
GO
