USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[AssyDoc_BatNbr_RefNbr]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[AssyDoc_BatNbr_RefNbr]
    @parm1 varchar ( 10),
    @parm2 varchar ( 15)
as
Select * from AssyDoc
    where BatNbr = @parm1
       and RefNbr like @parm2
    order by BatNbr, RefNbr
GO
