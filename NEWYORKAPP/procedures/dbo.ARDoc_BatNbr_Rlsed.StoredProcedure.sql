USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_BatNbr_Rlsed]    Script Date: 12/21/2015 16:00:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_BatNbr_Rlsed    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_BatNbr_Rlsed] @parm1 varchar ( 10) as
    Select * from ARDoc where BatNbr = @parm1
        and Rlsed = 1
        order by RefNbr
GO
