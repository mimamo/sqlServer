USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CpnyID_Type_CheckRef]    Script Date: 12/21/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_CpnyID_Type_CheckRef] @parm1 varchar ( 10), @parm2 varchar (15), @parm3 varchar ( 10), @parm4 varchar ( 10) as
    Select * from ARDoc where
        CpnyID like @parm1
        and CustId = @parm2
        and DocType like @parm3
        and RefNbr like @parm4
        order by CustId, DocType, RefNbr
GO
