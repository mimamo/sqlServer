USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_ApplBatNbr]    Script Date: 12/21/2015 14:34:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_ApplBatNbr    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_ApplBatNbr] @parm1 varchar ( 10) as
    Select * from ARDoc where
        ApplBatNbr = @parm1
        order by ApplBatNbr, ApplBatSeq
GO
