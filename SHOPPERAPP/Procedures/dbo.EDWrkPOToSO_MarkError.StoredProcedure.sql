USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPOToSO_MarkError]    Script Date: 12/21/2015 16:13:13 ******/
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
