USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPOToSO_CountBad]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDWrkPOToSO_CountBad] @AccessNbr smallint As
Select Count(*) From EDWrkPOToSO Where POQty <> SOQty And AccessNbr = @AccessNbr
GO
