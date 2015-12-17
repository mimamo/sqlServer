USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustomBld_OrderNbr]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CustomBld_OrderNbr    Script Date: 4/17/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.CustomBld_OrderNbr    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[CustomBld_OrderNbr] @parm1 Varchar (10) as
        Select * from CustomBld where Source = 'OP' and OrderNbr = @parm1
                order by Source, OrderNbr, OrderLineRef, LineNbr
GO
