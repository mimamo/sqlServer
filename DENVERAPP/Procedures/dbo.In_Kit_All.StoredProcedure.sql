USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[In_Kit_All]    Script Date: 12/21/2015 15:42:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.In_Kit_All    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.In_Kit_All    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[In_Kit_All] @parm1 varchar ( 30) as
Select * from Kit where KitType = '' and KitId like @parm1
order by KitId
GO
