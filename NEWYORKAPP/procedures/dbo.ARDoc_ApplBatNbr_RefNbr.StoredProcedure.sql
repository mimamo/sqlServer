USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_ApplBatNbr_RefNbr]    Script Date: 12/21/2015 16:00:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_ApplBatNbr_RefNbr    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_ApplBatNbr_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 10) as
    Select * from ARDoc where ApplBatNbr = @parm1
        and DocType IN ('PA','CM')
        and RefNbr like @parm2
        order by ApplBatNbr, ApplBatSeq
GO
