USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIAdj_Location_Reset]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PIAdj_Location_Reset    Script Date: 4/17/98 10:58:19 AM ******/
Create Proc [dbo].[PIAdj_Location_Reset] @Parm1 Varchar(10),@Parm2 Varchar(10) as
   Update Location set countstatus = 'A'
	where location.siteid = @parm1 and location.whseloc = @Parm2
	and Location.countstatus = 'P'
GO
