USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIAdj_Location_Reset]    Script Date: 12/16/2015 15:55:25 ******/
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
