USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_ApplBatNbr_CuryId]    Script Date: 12/21/2015 14:05:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_ApplBatNbr_CuryId    Script Date: 4/7/98 12:30:32 PM ******/
Create proc [dbo].[ARDoc_ApplBatNbr_CuryId] @parm1 varchar ( 10), @parm2 varchar ( 4) As
 Select * from ARDoc WHERE ARDoc.ApplBatNbr = @parm1
 and ARDoc.CuryId like @parm2
 Order By ApplBatNbr, CuryId, ApplBatSeq
GO
