USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_ApplBatNbr_BatNbr]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_ApplBatNbr_BatNbr    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_ApplBatNbr_BatNbr] @parm1 varchar ( 10), @parm2 varchar ( 10) as
    Select * from ARDoc where
        (BatNbr = @parm1 or ApplBatNbr = @parm2)
        order by ApplBatNbr, ApplBatSeq, BatNbr, BatSeq
GO
