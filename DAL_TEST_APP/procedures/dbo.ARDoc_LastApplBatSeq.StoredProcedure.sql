USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_LastApplBatSeq]    Script Date: 12/21/2015 13:56:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_LastApplBatSeq    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[ARDoc_LastApplBatSeq] @parm1 varchar ( 10) As
 Select MAX(BatSeq) from ARDoc WHERE ARDoc.ApplBatNbr = @parm1
GO
