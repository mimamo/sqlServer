USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_Kitid_Status_Siteid_Type]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Kit_Kitid_Status_Siteid_Type] @parm1 varchar ( 30), @parm2 varchar (1), @parm3 varchar (10)   as
	Select * from Kit where
	Kitid like @parm1
	and Status like @parm2
	and Siteid like @parm3
	and KitType = 'B'
	Order by Kitid,Status,Siteid
GO
