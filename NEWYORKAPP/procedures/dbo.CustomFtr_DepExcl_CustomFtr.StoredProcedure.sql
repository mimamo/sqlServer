USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[CustomFtr_DepExcl_CustomFtr]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CustomFtr_DepExcl_CustomFtr    Script Date: 4/17/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.CustomFtr_DepExcl_CustomFtr    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[CustomFtr_DepExcl_CustomFtr] @parm1 varchar ( 30), @parm2 varchar ( 4), @parm3 varchar ( 1), @parm4beg smallint, @parm4end smallint as
        Select * from FtrDepExcl F, CustomFtr C where
                F.InvtID = C.InvtID and
                F.DepExclFtr = convert(int,C.FeatureNbr) and
                f.InvtID = @parm1 and
                F.FeatureNbr = @parm2 and F.DEType = @parm3 and F.LineNbr between @parm4beg and @parm4end
                order by F.InvtID, F.FeatureNbr, F.DEType, F.LineNbr
GO
