USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPOToSO_MarkConverted]    Script Date: 12/21/2015 15:42:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDWrkPOToSO_MarkConverted] @AccessNbr smallint As
Update ED850Header Set UpdateStatus = 'OC' Where EDIPOID In (Select Distinct EDIPOID From
EDWrkPOToSO Where AccessNbr = @AccessNbr And EDIPOID Not In (select Distinct EDIPOID From
EDWrkPOToSO Where AccessNbr = @AccessNbr And POQTY <> SOQTY))
GO
