USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_BatNbr]    Script Date: 12/21/2015 15:42:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_BatNbr    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_BatNbr] @parm1 varchar ( 10) as
    Select * from ARDoc where BatNbr = @parm1
        and DocType <> 'RC'
        order by BatNbr, BatSeq
GO
