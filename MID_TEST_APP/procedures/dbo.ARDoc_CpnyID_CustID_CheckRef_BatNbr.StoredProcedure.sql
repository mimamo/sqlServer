USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CpnyID_CustID_CheckRef_BatNbr]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_CpnyID_CustID_CheckRef_BatNbr] @parm1 varchar ( 10), @parm2 varchar (15), @parm3 varchar ( 10), @parm4 varchar(10) as
    Select * from ARDoc where
        CpnyID like @parm1
        and CustId like @parm2
        and DocType  in ('PA', 'PP')
        and RefNbr like @parm3
        and BatNbr like @parm4
        order by CustId, DocType, RefNbr
GO
