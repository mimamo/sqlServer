USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_LastBatSeq]    Script Date: 12/21/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_LastBatSeq    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[ARDoc_LastBatSeq] @parm1 varchar ( 10) As
 Select MAX(BatSeq) from ARDoc WHERE ARDoc.BatNbr = @parm1
GO
