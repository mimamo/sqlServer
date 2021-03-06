USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPOToSO_ResetUnconverted]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDWrkPOToSO_ResetUnconverted] @AccessNbr smallint As
Update ED850Header Set UpdateStatus = 'OK' Where EDIPOID In (Select EDIPOID From EDWrkPOToSO
Where AccessNbr = @AccessNbr And Not Exists (Select * From SOHeader Where EDIPOID =
EDWrkPOToSO.EDIPOID And Cancelled = 0))
Delete From EDWrkPOToSO Where Not Exists (Select * From SOHeader Where EDIPOID = EDWrkPOToSO.EDIPOID
And Cancelled = 0) And AccessNbr = @AccessNbr
GO
