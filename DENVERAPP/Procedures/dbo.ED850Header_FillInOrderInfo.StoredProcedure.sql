USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_FillInOrderInfo]    Script Date: 12/21/2015 15:42:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850Header_FillInOrderInfo] @AccessNbr smallint As
Update ED850Header Set OrdNbr = (Select Min(OrdNbr) From SOHeader A Where A.EDIPOID =  ED850Header.EDIPOID And
Cancelled = 0) Where ED850Header.EDIPOID In (Select EDIPOID From EDWrkPOToSO Where AccessNbr = @AccessNbr)
Update ED850HeaderExt Set ConvertedDate = GetDate() Where EDIPOID In (Select EDIPOID From
EDWrkPOToSO Where AccessNbr = @AccessNbr)
GO
