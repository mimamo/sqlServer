USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIDetail_Location_Reset]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PIDetail_Location_Reset    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[PIDetail_Location_Reset] @parm1 VarChar(10) as
   Update Location set Location.countstatus = 'A'
   	From Location, pidetail
    	Where pidetail.piid = @parm1
    	and Location.countstatus = 'P'
    	and Location.siteid = pidetail.siteid
    	and Location.invtid = pidetail.invtid
    	and Location.whseloc = pidetail.whseloc
GO
