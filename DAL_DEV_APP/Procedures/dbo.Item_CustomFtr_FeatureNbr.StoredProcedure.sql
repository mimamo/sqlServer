USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Item_CustomFtr_FeatureNbr]    Script Date: 12/21/2015 13:35:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Item_CustomFtr_FeatureNbr    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.Item_CustomFtr_FeatureNbr    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Item_CustomFtr_FeatureNbr] @parm1 varchar ( 30), @parm2 varchar ( 4) as
        Select * from CustomFtr where InvtID = @parm1 and
                FeatureNbr like @parm2
                order by InvtID, FeatureNbr
GO
