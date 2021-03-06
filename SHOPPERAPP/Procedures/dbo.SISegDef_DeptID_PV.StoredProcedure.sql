USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SISegDef_DeptID_PV]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SISegDef_DeptID_PV    Script Date: 4/7/98 12:42:26 PM ******/
/****** Object:  Stored Procedure dbo.SISegDef_DeptID_PV    Script Date: 12/17/97 10:48:52 AM ******/
Create Proc [dbo].[SISegDef_DeptID_PV] @parm1 Varchar(2), @parm2 Varchar(24) as
Select * from SegDef
where FieldClassName =  'SUBACCOUNT'
and SegNumber      =    @parm1
and ID like @parm2
and Description <> "Default"
order by FieldClassName, SegNumber, ID
GO
