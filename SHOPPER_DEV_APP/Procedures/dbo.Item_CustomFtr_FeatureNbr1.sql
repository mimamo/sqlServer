USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Item_CustomFtr_FeatureNbr1]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Item_CustomFtr_FeatureNbr1    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.Item_CustomFtr_FeatureNbr1    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Item_CustomFtr_FeatureNbr1] @parm1 varchar ( 30)as
        Select * from CustomFtr where InvtID Like @parm1
                order by InvtID, FeatureNbr
GO
