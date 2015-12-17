USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_Structure]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Comp_Structure]
	@parm1 varchar (30),
	@parm2 varchar (10),
	@parm3 varchar (1) as
	Select * from Component where
        	Kitid = @parm1
		and KitSiteid = @parm2
		and KitStatus = @parm3
        	Order by Kitid,Kitsiteid,Sequence
GO
