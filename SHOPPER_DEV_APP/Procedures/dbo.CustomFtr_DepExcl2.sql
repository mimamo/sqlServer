USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustomFtr_DepExcl2]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CustomFtr_DepExcl2    Script Date: 4/17/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.CustomFtr_DepExcl2    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[CustomFtr_DepExcl2] @parm1 varchar ( 30), @parm2 varchar ( 4), @parm3 varchar ( 1), @parm4 smallint as
        Select * from FtrDepExcl where InvtID = @parm1 and
                FeatureNbr = @parm2 and DEType = @parm3 and DepExclFtr = @parm4
                order by InvtID, FeatureNbr, DEType, DepExclFtr
GO
