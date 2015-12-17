USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Reverse_Doc]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_Reverse_Doc] @parm2 varchar (15), @parm3 varchar ( 10), @parm4 varchar ( 10) as
    Select * from ARDoc where
	CustId = @parm2
        and DocType = @parm3
        and RefNbr = @parm4
        and Rlsed = 1
GO
