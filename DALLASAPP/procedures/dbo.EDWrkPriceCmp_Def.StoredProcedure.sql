USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPriceCmp_Def]    Script Date: 12/21/2015 13:44:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDWrkPriceCmp_Def]  As
Select *  From EDWrkPriceCmp Order by ComputerId, EdiPoId
GO
