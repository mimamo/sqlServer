USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPOToSO_MarkError]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDWrkPOToSO_MarkError] @AccessNbr smallint As
Update ED850Header Set UpdateStatus = 'CE' Where EDIPOID In (Select Distinct EDIPOID From
EDWrkPOToSO Where AccessNbr = @AccessNbr And EDIPOID In (Select Distinct EDIPOID From
EDWrkPOToSO Where AccessNbr = @AccessNbr And POQTY <> SOQTY))
Select Cast(@@ROWCOUNT As int)
GO
