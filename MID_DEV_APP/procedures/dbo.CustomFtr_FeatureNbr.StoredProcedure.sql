USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustomFtr_FeatureNbr]    Script Date: 12/21/2015 14:17:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CustomFtr_FeatureNbr    Script Date: 4/17/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.CustomFtr_FeatureNbr    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[CustomFtr_FeatureNbr] @parm1 varchar ( 30), @parm2 varchar ( 4) as
        Select * from CustomFtr where InvtID = @parm1 and
                FeatureNbr = @parm2
                order by InvtID, FeatureNbr
GO
