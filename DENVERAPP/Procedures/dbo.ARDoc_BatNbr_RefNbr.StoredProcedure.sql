USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_BatNbr_RefNbr]    Script Date: 12/21/2015 15:42:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_BatNbr_RefNbr    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_BatNbr_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 10) as
    Select * from ARDoc where BatNbr = @parm1
        and ARDoc.RefNbr like @parm2
        order by RefNbr
GO
