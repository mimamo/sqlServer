USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustomFtr_FtrOptions_InvtID]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CustomFtr_FtrOptions_InvtID    Script Date: 4/17/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.CustomFtr_FtrOptions_InvtID    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[CustomFtr_FtrOptions_InvtID] @parm1 varchar  (  30) as
	Select * from FtrOptions, CustomFtr where FtrOptions.invtid = @parm1
       	and FtrOptions.invtid = CustomFtr.invtid
 		and FtrOptions.featurenbr = CustomFtr.featurenbr
 		order by FtrOptions.Invtid, FtrOptions.FeatureNbr, FtrOptions.LineNbr
GO
