USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPriceCmp_Def]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDWrkPriceCmp_Def]  As
Select *  From EDWrkPriceCmp Order by ComputerId, EdiPoId
GO
