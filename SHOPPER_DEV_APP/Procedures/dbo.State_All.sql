USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[State_All]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.State_All    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[State_All] @parm1 varchar ( 3) as
    Select * from State where StateProvId like @parm1 order by StateProvId
GO
