USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustomBld_Item_Det]    Script Date: 12/21/2015 16:06:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CustomBld_Item_Det    Script Date: 4/17/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.CustomBld_Item_Det    Script Date: 4/16/98 7:41:51 PM ******/
Create proc [dbo].[CustomBld_Item_Det] @parm1 varchar (2), @parm2 varchar (10), @parm3 varchar ( 4) as
        Select * from CustomBld where Source = @parm1 and
                OrderNbr = @parm2 and FeatureNbr like @parm3
            order by Source, OrderNbr, FeatureNbr, OptInvtID
GO
