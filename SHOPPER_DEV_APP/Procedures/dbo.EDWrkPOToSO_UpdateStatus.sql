USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPOToSO_UpdateStatus]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDWrkPOToSO_UpdateStatus] @AccessNbr smallint As
Update ED850Header Set UpdateStatus = 'CE' From ED850Header A, EDWrkPOToSO B Where
A.CpnyId = B.CpnyId And A.EDIPOID = B.EDIPOID And B.AccessNbr = @AccessNbr And B.POQty <> B.SOQty
GO
