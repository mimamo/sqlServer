USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Bat_Cust_Type_Ref]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Bat_Cust_Type_Ref    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_Bat_Cust_Type_Ref] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 2), @parm4 varchar ( 10) as
    Select * from ARDoc where BatNbr = @parm1
        and CustId = @parm2
        and DocType = @parm3
        and RefNbr like @parm4
        and Rlsed = 1
        order by BatNbr, CustId, DocType, RefNbr
GO
