USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Global_Units]    Script Date: 12/21/2015 15:49:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Global_Units    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.Global_Units    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[Global_Units] @parm1 varchar ( 1) as
select distinct inunit.tounit from inunit where unittype = '1' and invtid like @parm1 order by toUnit
GO
