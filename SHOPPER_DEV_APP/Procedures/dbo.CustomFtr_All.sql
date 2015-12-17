USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustomFtr_All]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CustomFtr_All    Script Date: 7/13/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.CustomFtr_All    Script Date: 7/13/98 7:41:51 PM ******/
Create Proc [dbo].[CustomFtr_All] @parm1 varchar ( 30), @parm2 varchar ( 4) as
        Select * from CustomFtr where InvtID = @parm1 and
                FeatureNbr like @parm2
                order by  FeatureNbr
GO
