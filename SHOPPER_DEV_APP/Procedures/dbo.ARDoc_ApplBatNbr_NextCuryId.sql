USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_ApplBatNbr_NextCuryId]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_ApplBatNbr_NextCuryId    Script Date: 4/7/98 12:30:32 PM ******/
Create proc [dbo].[ARDoc_ApplBatNbr_NextCuryId] @parm1 varchar ( 10), @parm2 varchar ( 4) As
 Select * from ARDoc WHERE ARDoc.ApplBatNbr = @parm1
 and ARDoc.CuryId > @parm2
 Order By ApplBatNbr, CuryId, ApplBatSeq
GO
